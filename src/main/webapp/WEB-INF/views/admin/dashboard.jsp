<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ page import="com.phishproof.model.User" %>
<%
    User currentUser = (User) session.getAttribute("user");
    if (currentUser == null || !currentUser.isAdmin()) {
        response.sendRedirect(request.getContextPath() + "/login"); return;
    }
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>PhishProof — Admin Dashboard</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://fonts.googleapis.com/css2?family=Share+Tech+Mono&family=Rajdhani:wght@400;600;700&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/main.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/admin.css">
</head>
<body class="dark-theme">

    <%@ include file="partials/admin-nav.jsp" %>

    <div class="main-content">
        <!-- Page Header -->
        <div class="page-header">
            <div>
                <h1 class="page-title">Command Center</h1>
                <p class="page-sub">Real-time phishing campaign overview</p>
            </div>
            <a href="${pageContext.request.contextPath}/admin/campaigns/new" class="btn btn-primary-cyber">
                + New Campaign
            </a>
        </div>

        <!-- Stats Row -->
        <div class="row g-3 mb-4">
            <div class="col-md-3">
                <div class="stat-card stat-blue">
                    <div class="stat-icon">📋</div>
                    <div class="stat-value">${totalCampaigns}</div>
                    <div class="stat-label">Total Campaigns</div>
                </div>
            </div>
            <div class="col-md-3">
                <div class="stat-card stat-green">
                    <div class="stat-icon">⚡</div>
                    <div class="stat-value">${activeCampaigns}</div>
                    <div class="stat-label">Active</div>
                </div>
            </div>
            <div class="col-md-3">
                <div class="stat-card stat-yellow">
                    <div class="stat-icon">👆</div>
                    <div class="stat-value">${totalClicks}</div>
                    <div class="stat-label">Links Clicked</div>
                </div>
            </div>
            <div class="col-md-3">
                <div class="stat-card stat-red">
                    <div class="stat-icon">🎣</div>
                    <div class="stat-value">${totalCaptures}</div>
                    <div class="stat-label">Credentials Captured</div>
                </div>
            </div>
        </div>

        <!-- Campaigns Table -->
        <div class="cyber-card">
            <div class="cyber-card-header">
                <span>📡 Campaign List</span>
                <span class="card-badge">${totalCampaigns} total</span>
            </div>
            <div class="table-responsive">
                <table class="table cyber-table">
                    <thead>
                        <tr>
                            <th>Campaign</th>
                            <th>Template</th>
                            <th>Status</th>
                            <th>Difficulty</th>
                            <th>Targets</th>
                            <th>Click Rate</th>
                            <th>Submit Rate</th>
                            <th>Actions</th>
                        </tr>
                    </thead>
                    <tbody>
                        <c:forEach var="c" items="${campaigns}">
                        <tr>
                            <td>
                                <div class="campaign-name">${c.name}</div>
                                <div class="campaign-sub">by ${c.createdByName}</div>
                            </td>
                            <td>${c.templateName}</td>
                            <td>
                                <span class="badge ${c.statusBadgeClass}">${c.status}</span>
                            </td>
                            <td>
                                <span class="badge ${c.difficultyBadgeClass}">${c.difficulty}</span>
                            </td>
                            <td>${c.totalTargets}</td>
                            <td>
                                <div class="rate-bar">
                                    <div class="rate-fill rate-click" style="width:${c.clickRate}%"></div>
                                </div>
                                <fmt:formatNumber value="${c.clickRate}" maxFractionDigits="1"/>%
                            </td>
                            <td>
                                <div class="rate-bar">
                                    <div class="rate-fill rate-submit" style="width:${c.submitRate}%"></div>
                                </div>
                                <fmt:formatNumber value="${c.submitRate}" maxFractionDigits="1"/>%
                            </td>
                            <td>
                                <a href="${pageContext.request.contextPath}/admin/campaigns/view?id=${c.id}" class="btn-action">View</a>
                                <a href="${pageContext.request.contextPath}/admin/reports?id=${c.id}" class="btn-action">Report</a>
                            </td>
                        </tr>
                        </c:forEach>
                        <c:if test="${empty campaigns}">
                        <tr><td colspan="8" class="text-center text-muted py-4">No campaigns yet. Create your first one!</td></tr>
                        </c:if>
                    </tbody>
                </table>
            </div>
        </div>
    </div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
