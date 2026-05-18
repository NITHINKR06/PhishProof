package com.phishproof.controller;

import com.phishproof.dao.*;
import com.phishproof.model.*;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;
import java.util.List;

/**
 * UserInboxServlet — Shows the learner's simulated phishing email inbox.
 * GET /user/inbox
 */
@WebServlet("/user/inbox")
public class UserInboxServlet extends HttpServlet {

    private final PhishLinkDAO phishLinkDAO = new PhishLinkDAO();
    private final CampaignDAO  campaignDAO  = new CampaignDAO();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        HttpSession session = req.getSession(false);
        User user = (session != null) ? (User) session.getAttribute("user") : null;
        if (user == null) {
            resp.sendRedirect(req.getContextPath() + "/login");
            return;
        }

        List<PhishLink> links   = phishLinkDAO.findByUser(user.getId());
        String          baseUrl = req.getScheme() + "://" + req.getServerName() +
                                  (req.getServerPort() == 80 || req.getServerPort() == 443
                                   ? "" : ":" + req.getServerPort()) +
                                  req.getContextPath();

        req.setAttribute("links",   links);
        req.setAttribute("baseUrl", baseUrl);
        req.setAttribute("user",    user);
        req.getRequestDispatcher("/WEB-INF/views/user/inbox.jsp").forward(req, resp);
    }
}
