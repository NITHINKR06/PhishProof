package com.phishproof.controller;

import com.phishproof.dao.PhishLinkDAO;
import com.phishproof.model.User;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;

/**
 * UserScoreServlet — Displays the learner's phishing awareness score.
 * GET /user/score
 */
@WebServlet("/user/score")
public class UserScoreServlet extends HttpServlet {

    private final PhishLinkDAO phishLinkDAO = new PhishLinkDAO();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        HttpSession session = req.getSession(false);
        User user = (session != null) ? (User) session.getAttribute("user") : null;
        if (user == null) {
            resp.sendRedirect(req.getContextPath() + "/login");
            return;
        }

        req.setAttribute("links", phishLinkDAO.findByUser(user.getId()));
        req.getRequestDispatcher("/WEB-INF/views/user/score.jsp").forward(req, resp);
    }
}
