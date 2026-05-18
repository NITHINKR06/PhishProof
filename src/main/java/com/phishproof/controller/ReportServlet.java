package com.phishproof.controller;

import com.phishproof.dao.*;
import com.phishproof.model.*;
import com.google.gson.Gson;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;
import java.util.*;

/**
 * ReportServlet — Campaign analytics and JSON data endpoints for charts.
 * GET /admin/reports?id=X   — HTML report page for a campaign
 * GET /admin/reports/data?id=X — JSON data for Chart.js
 */
@WebServlet("/admin/reports/*")
public class ReportServlet extends HttpServlet {

    private final CampaignDAO     campaignDAO     = new CampaignDAO();
    private final PhishLinkDAO    phishLinkDAO    = new PhishLinkDAO();
    private final CapturedDataDAO capturedDataDAO = new CapturedDataDAO();

    private final Gson gson = new Gson();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        HttpSession session = req.getSession(false);
        User user = (session != null) ? (User) session.getAttribute("user") : null;
        if (user == null || !user.isAdmin()) {
            resp.sendRedirect(req.getContextPath() + "/login");
            return;
        }

        String path = req.getPathInfo();
        if ("/data".equals(path)) {
            serveJsonData(req, resp);
        } else {
            serveReportPage(req, resp);
        }
    }

    private void serveReportPage(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        String idStr = req.getParameter("id");
        if (idStr == null) {
            req.setAttribute("campaigns", campaignDAO.findAll());
            req.getRequestDispatcher("/WEB-INF/views/admin/reports.jsp").forward(req, resp);
            return;
        }

        int id = Integer.parseInt(idStr);
        Campaign campaign = campaignDAO.findById(id);
        List<PhishLink> links = phishLinkDAO.findByCampaign(id);
        List<CapturedData> captures = capturedDataDAO.findByCampaign(id);

        req.setAttribute("campaign", campaign);
        req.setAttribute("links",    links);
        req.setAttribute("captures", captures);
        req.getRequestDispatcher("/WEB-INF/views/admin/report-detail.jsp").forward(req, resp);
    }

    private void serveJsonData(HttpServletRequest req, HttpServletResponse resp)
            throws IOException {

        int id = Integer.parseInt(req.getParameter("id"));
        Campaign campaign = campaignDAO.findById(id);
        List<PhishLink> links = phishLinkDAO.findByCampaign(id);

        int total     = links.size();
        int clicked   = (int) links.stream().filter(PhishLink::isClicked).count();
        int submitted = (int) links.stream().filter(PhishLink::isSubmitted).count();
        int safe      = total - clicked;

        Map<String, Object> data = new LinkedHashMap<>();
        data.put("campaignName", campaign.getName());
        data.put("total",     total);
        data.put("clicked",   clicked);
        data.put("submitted", submitted);
        data.put("safe",      safe);
        data.put("clickRate",   campaign.getClickRate());
        data.put("submitRate",  campaign.getSubmitRate());

        resp.setContentType("application/json");
        resp.setCharacterEncoding("UTF-8");
        resp.getWriter().write(gson.toJson(data));
    }
}
