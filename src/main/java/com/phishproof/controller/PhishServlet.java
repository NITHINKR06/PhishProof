package com.phishproof.controller;

import com.phishproof.dao.*;
import com.phishproof.model.*;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;

/**
 * PhishServlet — The core phishing engine.
 *
 * GET  /phish?t={token}  — logs the click, renders the fake login page
 * POST /phish            — logs credential submission, redirects to reveal page
 */
@WebServlet("/phish")
public class PhishServlet extends HttpServlet {

    private final PhishLinkDAO    phishLinkDAO    = new PhishLinkDAO();
    private final CampaignDAO     campaignDAO     = new CampaignDAO();
    private final TemplateDAO     templateDAO     = new TemplateDAO();
    private final CapturedDataDAO capturedDataDAO = new CapturedDataDAO();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        String token = req.getParameter("t");
        if (token == null || token.isBlank()) {
            resp.sendRedirect(req.getContextPath() + "/login");
            return;
        }

        PhishLink link = phishLinkDAO.findByToken(token);
        if (link == null || link.isExpired()) {
            req.setAttribute("message", "This link has expired or is invalid.");
            req.getRequestDispatcher("/WEB-INF/views/error.jsp").forward(req, resp);
            return;
        }

        // Record the click (idempotent — only first click is recorded)
        phishLinkDAO.markClicked(token);

        // Load campaign + template
        Campaign campaign = campaignDAO.findById(link.getCampaignId());
        Template template = templateDAO.findById(campaign.getTemplateId());

        // Store token in session for POST submission
        req.getSession(true).setAttribute("phishToken", token);
        req.getSession().setAttribute("phishLinkId", link.getId());

        // Render the fake login page
        String templatePage = "/WEB-INF/views/templates/" + template.getHtmlFile();
        req.setAttribute("token",    token);
        req.setAttribute("campaign", campaign);
        req.setAttribute("template", template);
        req.getRequestDispatcher(templatePage).forward(req, resp);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        String token = (String) req.getSession().getAttribute("phishToken");
        Integer linkId = (Integer) req.getSession().getAttribute("phishLinkId");

        if (token == null || linkId == null) {
            resp.sendRedirect(req.getContextPath() + "/login");
            return;
        }

        // Mark the link as submitted
        phishLinkDAO.markSubmitted(token);

        // Capture the entered credentials
        CapturedData data = new CapturedData();
        data.setLinkId(linkId);
        data.setFakeUsername(req.getParameter("username"));
        data.setFakePassword(req.getParameter("password"));
        data.setIpAddress(getClientIp(req));
        data.setUserAgent(req.getHeader("User-Agent"));
        data.setScreenSize(req.getParameter("screenSize"));
        data.setReferrer(req.getHeader("Referer"));
        try {
            String timeStr = req.getParameter("timeOnPage");
            data.setTimeOnPage(timeStr != null ? Integer.parseInt(timeStr) : 0);
        } catch (NumberFormatException ignored) {}

        capturedDataDAO.insert(data);

        // Clean up phish token from session
        req.getSession().removeAttribute("phishToken");
        req.getSession().setAttribute("lastCapturedLinkId", linkId);

        // Redirect to the reveal / awareness page
        resp.sendRedirect(req.getContextPath() + "/reveal?lid=" + linkId);
    }

    private String getClientIp(HttpServletRequest req) {
        String ip = req.getHeader("X-Forwarded-For");
        if (ip == null || ip.isEmpty()) ip = req.getRemoteAddr();
        return ip.contains(",") ? ip.split(",")[0].trim() : ip;
    }
}
