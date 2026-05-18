package com.phishproof.controller;

import com.phishproof.dao.*;
import com.phishproof.model.User;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;

/**
 * AdminDashboardServlet — Renders the admin overview dashboard.
 */
@WebServlet("/admin/dashboard")
public class AdminDashboardServlet extends HttpServlet {

    private final CampaignDAO     campaignDAO     = new CampaignDAO();
    private final UserDAO         userDAO         = new UserDAO();
    private final PhishLinkDAO    phishLinkDAO    = new PhishLinkDAO();
    private final CapturedDataDAO capturedDataDAO = new CapturedDataDAO();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        // Auth guard
        User user = (User) req.getSession(false).getAttribute("user");
        if (user == null || !user.isAdmin()) {
            resp.sendRedirect(req.getContextPath() + "/login");
            return;
        }

        // Summary stats
        req.setAttribute("totalCampaigns",  campaignDAO.findAll().size());
        req.setAttribute("activeCampaigns", campaignDAO.countActive());
        req.setAttribute("totalLearners",   userDAO.countLearners());
        req.setAttribute("totalClicks",     phishLinkDAO.countTotalClicks());
        req.setAttribute("totalCaptures",   capturedDataDAO.countTotal());
        req.setAttribute("campaigns",       campaignDAO.findAll());

        req.getRequestDispatcher("/WEB-INF/views/admin/dashboard.jsp").forward(req, resp);
    }
}
