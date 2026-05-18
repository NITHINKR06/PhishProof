package com.phishproof.controller;

import com.phishproof.dao.*;
import com.phishproof.model.*;
import com.phishproof.util.TokenGenerator;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;
import java.time.LocalDateTime;
import java.util.List;

/**
 * CampaignServlet — Handles campaign creation, launching, viewing, and management.
 * URL patterns:
 *   GET  /admin/campaigns         — list all campaigns
 *   GET  /admin/campaigns/new     — show create form
 *   POST /admin/campaigns/create  — save new campaign
 *   GET  /admin/campaigns/view?id=X  — campaign detail + link list
 *   POST /admin/campaigns/launch  — change status to ACTIVE
 *   POST /admin/campaigns/delete  — delete campaign
 */
@WebServlet("/admin/campaigns/*")
public class CampaignServlet extends HttpServlet {

    private final CampaignDAO  campaignDAO  = new CampaignDAO();
    private final TemplateDAO  templateDAO  = new TemplateDAO();
    private final UserDAO      userDAO      = new UserDAO();
    private final PhishLinkDAO phishLinkDAO = new PhishLinkDAO();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        guardAdmin(req, resp);
        String path = req.getPathInfo();
        if (path == null) path = "/";

        switch (path) {
            case "/new":
                req.setAttribute("templates", templateDAO.findAll());
                req.setAttribute("learners",  userDAO.findByRole(User.Role.LEARNER));
                req.getRequestDispatcher("/WEB-INF/views/admin/create-campaign.jsp").forward(req, resp);
                break;

            case "/view":
                int id = Integer.parseInt(req.getParameter("id"));
                Campaign campaign = campaignDAO.findById(id);
                List<PhishLink> links = phishLinkDAO.findByCampaign(id);
                req.setAttribute("campaign", campaign);
                req.setAttribute("links",    links);
                req.setAttribute("baseUrl",  getBaseUrl(req));
                req.getRequestDispatcher("/WEB-INF/views/admin/campaign-detail.jsp").forward(req, resp);
                break;

            default: // list
                req.setAttribute("campaigns", campaignDAO.findAll());
                req.getRequestDispatcher("/WEB-INF/views/admin/campaigns.jsp").forward(req, resp);
        }
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        guardAdmin(req, resp);
        String path = req.getPathInfo();
        if (path == null) path = "/";

        switch (path) {
            case "/create":
                createCampaign(req, resp);
                break;
            case "/launch":
                int lid = Integer.parseInt(req.getParameter("id"));
                campaignDAO.updateStatus(lid, Campaign.Status.ACTIVE);
                resp.sendRedirect(req.getContextPath() + "/admin/campaigns/view?id=" + lid);
                break;
            case "/delete":
                int did = Integer.parseInt(req.getParameter("id"));
                campaignDAO.delete(did);
                resp.sendRedirect(req.getContextPath() + "/admin/campaigns");
                break;
            default:
                resp.sendRedirect(req.getContextPath() + "/admin/campaigns");
        }
    }

    private void createCampaign(HttpServletRequest req, HttpServletResponse resp)
            throws IOException, ServletException {

        User admin = (User) req.getSession().getAttribute("user");

        Campaign campaign = new Campaign();
        campaign.setName(req.getParameter("name"));
        campaign.setDescription(req.getParameter("description"));
        campaign.setTemplateId(Integer.parseInt(req.getParameter("templateId")));
        campaign.setCreatedBy(admin.getId());
        campaign.setStatus(Campaign.Status.DRAFT);
        campaign.setDifficulty(Campaign.Difficulty.valueOf(req.getParameter("difficulty")));

        int campaignId = campaignDAO.insert(campaign);
        if (campaignId < 0) {
            req.setAttribute("error", "Failed to create campaign.");
            req.setAttribute("templates", templateDAO.findAll());
            req.setAttribute("learners",  userDAO.findByRole(User.Role.LEARNER));
            req.getRequestDispatcher("/WEB-INF/views/admin/create-campaign.jsp").forward(req, resp);
            return;
        }

        // Generate unique phish link for each selected target user
        String[] targetIds = req.getParameterValues("targetUsers");
        if (targetIds != null) {
            for (String uid : targetIds) {
                PhishLink link = new PhishLink();
                link.setToken(TokenGenerator.generate());
                link.setCampaignId(campaignId);
                link.setUserId(Integer.parseInt(uid));
                link.setExpiresAt(LocalDateTime.now().plusDays(30));
                phishLinkDAO.insert(link);
            }
        }

        resp.sendRedirect(req.getContextPath() + "/admin/campaigns/view?id=" + campaignId);
    }

    private void guardAdmin(HttpServletRequest req, HttpServletResponse resp) throws IOException {
        HttpSession session = req.getSession(false);
        User user = (session != null) ? (User) session.getAttribute("user") : null;
        if (user == null || !user.isAdmin()) {
            resp.sendRedirect(req.getContextPath() + "/login");
        }
    }

    private String getBaseUrl(HttpServletRequest req) {
        return req.getScheme() + "://" + req.getServerName() +
               (req.getServerPort() == 80 || req.getServerPort() == 443 ? "" : ":" + req.getServerPort()) +
               req.getContextPath();
    }
}
