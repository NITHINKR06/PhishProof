<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ page import="com.phishproof.model.User" %>
<%  User cu = (User) session.getAttribute("user");
    if (cu == null || !cu.isAdmin()) { response.sendRedirect(request.getContextPath() + "/login"); return; } %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>PhishProof — Users</title>
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
            <h1 class="page-title">Users</h1>
            <p class="page-sub">Manage learners and administrators</p>
        </div>
        <button class="btn-primary-cyber" data-bs-toggle="modal" data-bs-target="#addUserModal">+ Add User</button>
    </div>

    <c:if test="${not empty success}">
        <div class="alert-success mb-3">✔ ${success}</div>
    </c:if>
    <c:if test="${not empty error}">
        <div class="alert-danger mb-3">⚠ ${error}</div>
    </c:if>

    <div class="cyber-card">
        <div class="cyber-card-header">
            <span>👥 All Users</span>
            <span class="card-badge">${users.size()} total</span>
        </div>
        <c:forEach var="u" items="${users}">
        <div class="user-card">
            <div class="user-card-avatar">${u.name.charAt(0)}</div>
            <div class="user-card-info">
                <div class="user-card-name">${u.name}
                    <c:if test="${u.role == 'ADMIN'}">
                        <span class="badge badge-info ms-1" style="font-size:9px">ADMIN</span>
                    </c:if>
                </div>
                <div class="user-card-email">${u.email}</div>
                <div class="user-card-dept">${u.department} &bull; Joined: ${u.createdAt}</div>
            </div>
            <div class="user-card-actions">
                <c:choose>
                    <c:when test="${u.active}">
                        <span class="status-dot dot-green"></span>
                        <span style="font-size:11px;color:var(--accent-green)">Active</span>
                    </c:when>
                    <c:otherwise>
                        <span class="status-dot dot-red"></span>
                        <span style="font-size:11px;color:var(--accent-red)">Inactive</span>
                    </c:otherwise>
                </c:choose>
                <form method="post" action="${pageContext.request.contextPath}/admin/users/toggle" style="display:inline">
                    <input type="hidden" name="id" value="${u.id}">
                    <input type="hidden" name="active" value="${!u.active}">
                    <button class="btn-action" style="${u.active ? 'color:var(--accent-red)' : 'color:var(--accent-green)'}">
                        ${u.active ? 'Deactivate' : 'Activate'}
                    </button>
                </form>
            </div>
        </div>
        </c:forEach>
    </div>
</div>

<!-- Add User Modal -->
<div class="modal fade" id="addUserModal" tabindex="-1">
    <div class="modal-dialog">
        <div class="modal-content cyber-modal">
            <div class="modal-header">
                <h5 class="modal-title">➕ Add New User</h5>
                <button type="button" class="btn-close btn-close-white" data-bs-dismiss="modal"></button>
            </div>
            <form method="post" action="${pageContext.request.contextPath}/admin/users/add">
                <div class="modal-body">
                    <div class="mb-3">
                        <label class="cyber-label">Full Name</label>
                        <input type="text" name="name" class="cyber-input" required placeholder="John Doe">
                    </div>
                    <div class="mb-3">
                        <label class="cyber-label">Email</label>
                        <input type="email" name="email" class="cyber-input" required placeholder="john@company.com">
                    </div>
                    <div class="mb-3">
                        <label class="cyber-label">Password</label>
                        <input type="password" name="password" class="cyber-input" required placeholder="Min 8 characters">
                    </div>
                    <div class="row g-2">
                        <div class="col-6">
                            <label class="cyber-label">Department</label>
                            <input type="text" name="department" class="cyber-input" placeholder="e.g. Finance">
                        </div>
                        <div class="col-6">
                            <label class="cyber-label">Role</label>
                            <select name="role" class="cyber-input">
                                <option value="LEARNER">Learner</option>
                                <option value="ADMIN">Admin</option>
                            </select>
                        </div>
                    </div>
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Cancel</button>
                    <button type="submit" class="btn-primary-cyber">Create User</button>
                </div>
            </form>
        </div>
    </div>
</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
