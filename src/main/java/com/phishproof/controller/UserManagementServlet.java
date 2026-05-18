package com.phishproof.controller;

import com.phishproof.dao.UserDAO;
import com.phishproof.model.User;
import com.phishproof.util.PasswordUtil;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;
import java.util.List;

/**
 * UserManagementServlet — Admin user management (list, add, toggle active).
 *
 * GET  /admin/users          — list all users
 * POST /admin/users/add      — create a new user
 * POST /admin/users/toggle   — activate / deactivate a user
 */
@WebServlet("/admin/users/*")
public class UserManagementServlet extends HttpServlet {

    private final UserDAO userDAO = new UserDAO();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        if (!isAdmin(req)) { resp.sendRedirect(req.getContextPath() + "/login"); return; }

        List<User> users = userDAO.findAll();
        req.setAttribute("users", users);
        req.getRequestDispatcher("/WEB-INF/views/admin/users.jsp").forward(req, resp);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        if (!isAdmin(req)) { resp.sendRedirect(req.getContextPath() + "/login"); return; }

        String path = req.getPathInfo();
        if (path == null) path = "/";

        switch (path) {
            case "/add":
                addUser(req, resp);
                break;
            case "/toggle":
                toggleUser(req, resp);
                break;
            default:
                resp.sendRedirect(req.getContextPath() + "/admin/users");
        }
    }

    // ── Create user ───────────────────────────────────────────────────────

    private void addUser(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        String name       = req.getParameter("name");
        String email      = req.getParameter("email");
        String password   = req.getParameter("password");
        String department = req.getParameter("department");
        String roleStr    = req.getParameter("role");

        // Validate
        if (name == null || email == null || password == null
                || name.isBlank() || email.isBlank() || password.isBlank()) {
            req.setAttribute("error", "Name, email and password are required.");
            req.setAttribute("users", userDAO.findAll());
            req.getRequestDispatcher("/WEB-INF/views/admin/users.jsp").forward(req, resp);
            return;
        }

        if (password.length() < 6) {
            req.setAttribute("error", "Password must be at least 6 characters.");
            req.setAttribute("users", userDAO.findAll());
            req.getRequestDispatcher("/WEB-INF/views/admin/users.jsp").forward(req, resp);
            return;
        }

        // Check duplicate email
        if (userDAO.findByEmail(email.trim().toLowerCase()) != null) {
            req.setAttribute("error", "A user with this email already exists.");
            req.setAttribute("users", userDAO.findAll());
            req.getRequestDispatcher("/WEB-INF/views/admin/users.jsp").forward(req, resp);
            return;
        }

        User user = new User();
        user.setName(name.trim());
        user.setEmail(email.trim().toLowerCase());
        user.setPassword(PasswordUtil.hash(password));
        user.setDepartment(department);
        user.setActive(true);
        try {
            user.setRole(User.Role.valueOf(roleStr));
        } catch (Exception e) {
            user.setRole(User.Role.LEARNER);
        }

        if (userDAO.insert(user)) {
            req.setAttribute("success", "User '" + user.getName() + "' created successfully.");
        } else {
            req.setAttribute("error", "Failed to create user. Please try again.");
        }

        req.setAttribute("users", userDAO.findAll());
        req.getRequestDispatcher("/WEB-INF/views/admin/users.jsp").forward(req, resp);
    }

    // ── Toggle active ─────────────────────────────────────────────────────

    private void toggleUser(HttpServletRequest req, HttpServletResponse resp)
            throws IOException {

        int     id     = Integer.parseInt(req.getParameter("id"));
        boolean active = Boolean.parseBoolean(req.getParameter("active"));

        // Prevent admin from deactivating themselves
        User self = (User) req.getSession().getAttribute("user");
        if (self != null && self.getId() == id) {
            resp.sendRedirect(req.getContextPath() + "/admin/users");
            return;
        }

        userDAO.toggleActive(id, active);
        resp.sendRedirect(req.getContextPath() + "/admin/users");
    }

    // ── Helper ────────────────────────────────────────────────────────────

    private boolean isAdmin(HttpServletRequest req) {
        HttpSession session = req.getSession(false);
        if (session == null) return false;
        User user = (User) session.getAttribute("user");
        return user != null && user.isAdmin();
    }
}
