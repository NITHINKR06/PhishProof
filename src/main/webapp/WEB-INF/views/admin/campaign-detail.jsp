<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ page import="com.phishproof.model.User" %>
<%  User cu = (User) session.getAttribute("user");
    if (cu == null || !cu.isAdmin()) { response.sendRedirect(request.getContextPath() + "/login"); return; } %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>PhishProof — ${campaign.name}</title>
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
                <h1 class="page-title">${campaign.name}</h1>
                <p class="page-sub">
                    <span class="badge ${campaign.statusBadgeClass}">${campaign.status}</span>
                    &nbsp;
                    <span class="badge ${campaign.difficultyBadgeClass}">${campaign.difficulty}</span>
                    &nbsp; Template: ${campaign.templateName}
                </p>
            </div>
            <div class="d-flex gap-2">
                <c:if test="${campaign.status == 'DRAFT'}">
                <form method="post" action="${pageContext.request.contextPath}/admin/campaigns/launch" style="display:inline">
                    <input type="hidden" name="id" value="${campaign.id}">
                    <button class="btn btn-primary-cyber">⚡ Launch Campaign</button>
                </form>
                </c:if>
                <a href="${pageContext.request.contextPath}/admin/reports?id=${campaign.id}" class="btn btn-outline-info">📊 View Report</a>
            </div>
        </div>

        <!-- Stats -->
        <div class="row g-3 mb-4">
            <div class="col-md-3">
                <div class="stat-card stat-blue">
                    <div class="stat-value">${campaign.totalTargets}</div>
                    <div class="stat-label">Targets</div>
                </div>
            </div>
            <div class="col-md-3">
                <div class="stat-card stat-yellow">
                    <div class="stat-value">${campaign.clicked}</div>
                    <div class="stat-label">Clicked Link</div>
                </div>
            </div>
            <div class="col-md-3">
                <div class="stat-card stat-red">
                    <div class="stat-value">${campaign.submitted}</div>
                    <div class="stat-label">Submitted Creds</div>
                </div>
            </div>
            <div class="col-md-3">
                <div class="stat-card stat-green">
                    <div class="stat-value">${campaign.totalTargets - campaign.clicked}</div>
                    <div class="stat-label">Stayed Safe</div>
                </div>
            </div>
        </div>

        <!-- Phish Links Table -->
        <div class="cyber-card">
            <div class="cyber-card-header">🔗 Phish Links — Per User Tracking</div>
            <div class="table-responsive">
                <table class="table cyber-table">
                    <thead>
                        <tr>
                            <th>Target</th>
                            <th>Email</th>
                            <th>Phish URL</th>
                            <th>Clicked</th>
                            <th>Submitted</th>
                            <th>Clicked At</th>
                        </tr>
                    </thead>
                    <tbody>
                        <c:forEach var="link" items="${links}">
                        <tr>
                            <td>${link.userName}</td>
                            <td>${link.userEmail}</td>
                            <td>
                                <span class="phish-url" title="${baseUrl}/phish?t=${link.token}">
                                    /phish?t=${link.token.substring(0,12)}...
                                </span>
                                <button class="btn-copy" onclick="copyUrl('${baseUrl}/phish?t=${link.token}')">Copy</button>
                            </td>
                            <td>
                                <c:choose>
                                    <c:when test="${link.clicked}"><span class="status-dot dot-red"></span> Yes</c:when>
                                    <c:otherwise><span class="status-dot dot-green"></span> No</c:otherwise>
                                </c:choose>
                            </td>
                            <td>
                                <c:choose>
                                    <c:when test="${link.submitted}"><span class="badge badge-danger-sm">⚠ Submitted</span></c:when>
                                    <c:otherwise><span class="badge badge-safe-sm">Safe</span></c:otherwise>
                                </c:choose>
                            </td>
                            <td class="mono-text">
                                <c:choose>
                                    <c:when test="${link.clickedAt != null}">${link.clickedAt}</c:when>
                                    <c:otherwise>—</c:otherwise>
                                </c:choose>
                            </td>
                        </tr>
                        </c:forEach>
                    </tbody>
                </table>
            </div>
        </div>
    </div>

<script>
function copyUrl(url) {
    navigator.clipboard.writeText(url).then(() => {
        alert('Phish URL copied to clipboard:\n' + url);
    });
}
</script>
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
