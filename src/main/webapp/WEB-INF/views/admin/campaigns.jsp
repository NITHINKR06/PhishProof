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
    <title>PhishProof — Campaigns</title>
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
            <h1 class="page-title">Campaigns</h1>
            <p class="page-sub">All phishing simulation campaigns</p>
        </div>
        <a href="${pageContext.request.contextPath}/admin/campaigns/new" class="btn-primary-cyber">+ New Campaign</a>
    </div>

    <!-- Filter bar -->
    <div class="d-flex gap-2 mb-4">
        <button class="btn btn-sm filter-btn active" data-filter="ALL">All</button>
        <button class="btn btn-sm filter-btn" data-filter="DRAFT">Draft</button>
        <button class="btn btn-sm filter-btn" data-filter="ACTIVE">Active</button>
        <button class="btn btn-sm filter-btn" data-filter="COMPLETED">Completed</button>
    </div>

    <!-- Campaign cards grid -->
    <div class="campaigns-grid" id="campaignGrid">
        <c:forEach var="c" items="${campaigns}">
        <div class="campaign-card" data-status="${c.status}">
            <div class="campaign-card-header">
                <div>
                    <div class="campaign-card-title">${c.name}</div>
                    <div class="campaign-card-meta">
                        Template: ${c.templateName} &bull; by ${c.createdByName}
                    </div>
                </div>
                <div class="d-flex flex-column gap-1 align-items-end">
                    <span class="badge ${c.statusBadgeClass}">${c.status}</span>
                    <span class="badge ${c.difficultyBadgeClass}">${c.difficulty}</span>
                </div>
            </div>

            <div class="campaign-card-stats">
                <div class="mini-stat">
                    <div class="mini-stat-val">${c.totalTargets}</div>
                    <div class="mini-stat-label">Targets</div>
                </div>
                <div class="mini-stat">
                    <div class="mini-stat-val" style="color:var(--accent-yellow)">${c.clicked}</div>
                    <div class="mini-stat-label">Clicked</div>
                </div>
                <div class="mini-stat">
                    <div class="mini-stat-val" style="color:var(--accent-red)">${c.submitted}</div>
                    <div class="mini-stat-label">Captured</div>
                </div>
                <div class="mini-stat">
                    <div class="mini-stat-val" style="color:var(--accent-green)">${c.totalTargets - c.clicked}</div>
                    <div class="mini-stat-label">Safe</div>
                </div>
            </div>

            <!-- Progress bars -->
            <div style="margin-bottom:14px">
                <div style="display:flex;justify-content:space-between;font-size:11px;color:var(--text-muted);margin-bottom:4px">
                    <span>Click rate</span>
                    <span><fmt:formatNumber value="${c.clickRate}" maxFractionDigits="1"/>%</span>
                </div>
                <div style="height:4px;background:var(--border-dim);border-radius:2px">
                    <div style="height:100%;background:var(--accent-yellow);border-radius:2px;width:${c.clickRate}%"></div>
                </div>
            </div>

            <div class="campaign-card-actions">
                <a href="${pageContext.request.contextPath}/admin/campaigns/view?id=${c.id}" class="btn-action">🔍 View</a>
                <a href="${pageContext.request.contextPath}/admin/reports?id=${c.id}"         class="btn-action">📊 Report</a>
                <c:if test="${c.status == 'DRAFT'}">
                <form method="post" action="${pageContext.request.contextPath}/admin/campaigns/launch" style="display:inline">
                    <input type="hidden" name="id" value="${c.id}">
                    <button class="btn-action" style="color:var(--accent-green);border-color:rgba(26,170,92,0.3)">⚡ Launch</button>
                </form>
                </c:if>
                <form method="post" action="${pageContext.request.contextPath}/admin/campaigns/delete"
                      style="display:inline" onsubmit="return confirm('Delete campaign \'${c.name}\'?')">
                    <input type="hidden" name="id" value="${c.id}">
                    <button class="btn-action" style="color:var(--accent-red);border-color:rgba(220,53,69,0.3)">🗑 Delete</button>
                </form>
            </div>
        </div>
        </c:forEach>

        <c:if test="${empty campaigns}">
        <div style="grid-column:1/-1;text-align:center;padding:60px 20px;color:var(--text-muted)">
            <div style="font-size:48px;margin-bottom:16px">📭</div>
            <p style="font-size:16px">No campaigns yet.</p>
            <a href="${pageContext.request.contextPath}/admin/campaigns/new" class="btn-primary-cyber mt-3 d-inline-block">Create Your First Campaign</a>
        </div>
        </c:if>
    </div>
</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
<script>
// Filter buttons
document.querySelectorAll('.filter-btn').forEach(btn => {
    btn.addEventListener('click', function() {
        document.querySelectorAll('.filter-btn').forEach(b => b.classList.remove('active'));
        this.classList.add('active');
        const filter = this.dataset.filter;
        document.querySelectorAll('.campaign-card').forEach(card => {
            card.style.display = (filter === 'ALL' || card.dataset.status === filter) ? '' : 'none';
        });
    });
});
// Filter button base styles
document.querySelectorAll('.filter-btn').forEach(b => {
    b.style.cssText = 'background:transparent;border:1px solid var(--border-mid);color:var(--text-secondary);font-size:12px;padding:5px 14px;border-radius:2px;font-family:var(--font-mono);letter-spacing:1px;cursor:pointer';
});
document.querySelector('.filter-btn.active').style.cssText += ';border-color:var(--accent-blue);color:var(--accent-blue)';
</script>
</body>
</html>
