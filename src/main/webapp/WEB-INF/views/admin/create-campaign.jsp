<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ page import="com.phishproof.model.User" %>
<%  User currentUser = (User) session.getAttribute("user");
    if (currentUser == null || !currentUser.isAdmin()) {
        response.sendRedirect(request.getContextPath() + "/login"); return; } %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>PhishProof — New Campaign</title>
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
                <h1 class="page-title">New Campaign</h1>
                <p class="page-sub">Configure a phishing awareness exercise</p>
            </div>
        </div>

        <c:if test="${not empty error}">
            <div class="alert alert-danger mb-3">${error}</div>
        </c:if>

        <form method="post" action="${pageContext.request.contextPath}/admin/campaigns/create">
            <div class="row g-4">

                <!-- Left column: Campaign details -->
                <div class="col-md-7">
                    <div class="cyber-card">
                        <div class="cyber-card-header">📋 Campaign Details</div>
                        <div class="p-3">
                            <div class="mb-3">
                                <label class="form-label cyber-label">Campaign Name *</label>
                                <input type="text" name="name" class="form-control cyber-input" required
                                       placeholder="e.g. Q1 Finance Department Test">
                            </div>
                            <div class="mb-3">
                                <label class="form-label cyber-label">Description</label>
                                <textarea name="description" class="form-control cyber-input" rows="3"
                                          placeholder="What is the goal of this campaign?"></textarea>
                            </div>
                            <div class="mb-3">
                                <label class="form-label cyber-label">Difficulty Level</label>
                                <select name="difficulty" class="form-select cyber-input">
                                    <option value="EASY">🟢 Easy — Obvious red flags</option>
                                    <option value="MEDIUM" selected>🟡 Medium — Realistic clone</option>
                                    <option value="HARD">🔴 Hard — Near-perfect replica</option>
                                </select>
                            </div>
                        </div>
                    </div>

                    <!-- Template selection -->
                    <div class="cyber-card mt-3">
                        <div class="cyber-card-header">🎭 Select Phishing Template</div>
                        <div class="p-3">
                            <div class="row g-3">
                                <c:forEach var="t" items="${templates}">
                                <div class="col-md-6">
                                    <label class="template-card">
                                        <input type="radio" name="templateId" value="${t.id}" required>
                                        <div class="template-card-body">
                                            <div class="template-brand">${t.brand}</div>
                                            <div class="template-name">${t.name}</div>
                                            <span class="template-cat cat-${t.category.name().toLowerCase()}">${t.category}</span>
                                        </div>
                                    </label>
                                </div>
                                </c:forEach>
                            </div>
                        </div>
                    </div>
                </div>

                <!-- Right column: Target users -->
                <div class="col-md-5">
                    <div class="cyber-card">
                        <div class="cyber-card-header">
                            🎯 Select Targets
                            <span class="card-badge" id="selectedCount">0 selected</span>
                        </div>
                        <div class="p-3">
                            <div class="mb-2">
                                <button type="button" class="btn btn-sm btn-outline-secondary me-1" onclick="selectAll(true)">Select All</button>
                                <button type="button" class="btn btn-sm btn-outline-secondary" onclick="selectAll(false)">Clear</button>
                            </div>
                            <div class="target-list">
                                <c:forEach var="u" items="${learners}">
                                <label class="target-item">
                                    <input type="checkbox" name="targetUsers" value="${u.id}" class="target-check">
                                    <div class="target-avatar">${u.name.charAt(0)}</div>
                                    <div class="target-info">
                                        <div class="target-name">${u.name}</div>
                                        <div class="target-dept">${u.department} &bull; ${u.email}</div>
                                    </div>
                                </label>
                                </c:forEach>
                            </div>
                        </div>
                    </div>

                    <div class="mt-3">
                        <button type="submit" class="btn btn-primary-cyber w-100">
                            🚀 &nbsp;Create Campaign
                        </button>
                        <a href="${pageContext.request.contextPath}/admin/campaigns" class="btn btn-outline-secondary w-100 mt-2">
                            Cancel
                        </a>
                    </div>
                </div>
            </div>
        </form>
    </div>

<script>
function selectAll(state) {
    document.querySelectorAll('.target-check').forEach(cb => cb.checked = state);
    updateCount();
}
function updateCount() {
    const n = document.querySelectorAll('.target-check:checked').length;
    document.getElementById('selectedCount').textContent = n + ' selected';
}
document.querySelectorAll('.target-check').forEach(cb => cb.addEventListener('change', updateCount));
</script>
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
