<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ page import="com.phishproof.model.User" %>
<%  User cu = (User) session.getAttribute("user");
    if (cu == null || !cu.isAdmin()) { response.sendRedirect(request.getContextPath() + "/login"); return; } %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>PhishProof — Reports</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://fonts.googleapis.com/css2?family=Share+Tech+Mono&family=Rajdhani:wght@400;600;700&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/main.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/admin.css">
</head>
<body class="dark-theme">
<%@ include file="../partials/admin-nav.jsp" %>

<div class="main-content">
    <div class="page-header">
        <div>
            <h1 class="page-title">Reports</h1>
            <p class="page-sub">Analytics and results for all campaigns</p>
        </div>
    </div>

    <div class="cyber-card">
        <div class="cyber-card-header">📊 Select a Campaign to View Report</div>
        <div class="table-responsive">
            <table class="table cyber-table">
                <thead>
                    <tr>
                        <th>Campaign</th>
                        <th>Template</th>
                        <th>Status</th>
                        <th>Targets</th>
                        <th>Click Rate</th>
                        <th>Submit Rate</th>
                        <th>Risk Level</th>
                        <th>Report</th>
                    </tr>
                </thead>
                <tbody>
                    <c:forEach var="c" items="${campaigns}">
                    <tr>
                        <td>
                            <div class="campaign-name">${c.name}</div>
                            <div class="campaign-sub">${c.createdByName}</div>
                        </td>
                        <td>${c.templateName}</td>
                        <td><span class="badge ${c.statusBadgeClass}">${c.status}</span></td>
                        <td>${c.totalTargets}</td>
                        <td>
                            <div style="display:flex;align-items:center;gap:8px">
                                <div style="width:60px;height:4px;background:var(--border-dim);border-radius:2px">
                                    <div style="height:100%;background:var(--accent-yellow);border-radius:2px;width:${c.clickRate}%"></div>
                                </div>
                                <span style="font-family:var(--font-mono);font-size:12px">
                                    <fmt:formatNumber value="${c.clickRate}" maxFractionDigits="1"/>%
                                </span>
                            </div>
                        </td>
                        <td>
                            <div style="display:flex;align-items:center;gap:8px">
                                <div style="width:60px;height:4px;background:var(--border-dim);border-radius:2px">
                                    <div style="height:100%;background:var(--accent-red);border-radius:2px;width:${c.submitRate}%"></div>
                                </div>
                                <span style="font-family:var(--font-mono);font-size:12px">
                                    <fmt:formatNumber value="${c.submitRate}" maxFractionDigits="1"/>%
                                </span>
                            </div>
                        </td>
                        <td>
                            <c:choose>
                                <c:when test="${c.submitRate >= 50}"><span class="badge" style="background:rgba(220,53,69,0.15);color:#dc3545;border:1px solid rgba(220,53,69,0.3)">🔴 HIGH</span></c:when>
                                <c:when test="${c.submitRate >= 20}"><span class="badge" style="background:rgba(230,168,23,0.15);color:#e6a817;border:1px solid rgba(230,168,23,0.3)">🟡 MED</span></c:when>
                                <c:otherwise><span class="badge" style="background:rgba(26,170,92,0.12);color:#1aaa5c;border:1px solid rgba(26,170,92,0.25)">🟢 LOW</span></c:otherwise>
                            </c:choose>
                        </td>
                        <td>
                            <a href="${pageContext.request.contextPath}/admin/reports?id=${c.id}" class="btn-action">📊 Open Report</a>
                        </td>
                    </tr>
                    </c:forEach>
                    <c:if test="${empty campaigns}">
                    <tr><td colspan="8" class="text-center text-muted py-4">No campaigns found.</td></tr>
                    </c:if>
                </tbody>
            </table>
        </div>
    </div>
</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
