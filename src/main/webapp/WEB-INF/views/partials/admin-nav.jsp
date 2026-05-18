<%@ page import="com.phishproof.model.User" %>
<%  User navUser = (User) session.getAttribute("user"); %>
<nav class="sidebar">
    <div class="sidebar-brand">
        <span class="brand-icon">🛡️</span>
        <span class="brand-text">Phish<span class="brand-accent">Proof</span></span>
    </div>
    <div class="sidebar-user">
        <div class="user-avatar"><%= navUser != null ? navUser.getName().charAt(0) : "A" %></div>
        <div class="user-info">
            <div class="user-name"><%= navUser != null ? navUser.getName() : "" %></div>
            <div class="user-role">Administrator</div>
        </div>
    </div>
    <ul class="sidebar-nav">
        <li><a href="${pageContext.request.contextPath}/admin/dashboard"     class="nav-link"><span class="nav-icon">🏠</span> Dashboard</a></li>
        <li><a href="${pageContext.request.contextPath}/admin/campaigns"     class="nav-link"><span class="nav-icon">📡</span> Campaigns</a></li>
        <li><a href="${pageContext.request.contextPath}/admin/campaigns/new" class="nav-link"><span class="nav-icon">➕</span> New Campaign</a></li>
        <li><a href="${pageContext.request.contextPath}/admin/reports"       class="nav-link"><span class="nav-icon">📊</span> Reports</a></li>
        <li><a href="${pageContext.request.contextPath}/admin/users"         class="nav-link"><span class="nav-icon">👥</span> Users</a></li>
        <li class="nav-divider"></li>
        <li><a href="${pageContext.request.contextPath}/logout"              class="nav-link nav-logout"><span class="nav-icon">🚪</span> Logout</a></li>
    </ul>
</nav>
