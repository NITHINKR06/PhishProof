package com.phishproof.controller;

import com.phishproof.dao.*;
import com.phishproof.model.*;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;

/**
 * RevealServlet — Shows the "You were phished!" awareness page.
 * GET /reveal?lid={linkId}
 */
@WebServlet("/reveal")
public class RevealServlet extends HttpServlet {

    private final CapturedDataDAO capturedDataDAO = new CapturedDataDAO();
    private final PhishLinkDAO    phishLinkDAO    = new PhishLinkDAO();
    private final CampaignDAO     campaignDAO     = new CampaignDAO();
    private final TemplateDAO     templateDAO     = new TemplateDAO();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        String lidStr = req.getParameter("lid");
        if (lidStr == null) {
            resp.sendRedirect(req.getContextPath() + "/login");
            return;
        }

        int linkId = Integer.parseInt(lidStr);
        CapturedData captured = capturedDataDAO.findByLinkId(linkId);
        PhishLink    link     = phishLinkDAO.findByToken(
            getTokenForLinkId(linkId, phishLinkDAO));
        Campaign     campaign = (link != null) ? campaignDAO.findById(link.getCampaignId()) : null;
        Template     template = (campaign != null) ? templateDAO.findById(campaign.getTemplateId()) : null;

        req.setAttribute("captured",  captured);
        req.setAttribute("link",      link);
        req.setAttribute("campaign",  campaign);
        req.setAttribute("template",  template);

        req.getRequestDispatcher("/WEB-INF/views/reveal.jsp").forward(req, resp);
    }

    private String getTokenForLinkId(int id, PhishLinkDAO dao) {
        // Helper: reverse-lookup token by id using user inbox links
        // For reveal page we fetch via linkId directly from captured_data join
        return null; // link is fetched via capturedData.linkId in JSP
    }
}
