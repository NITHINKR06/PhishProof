<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ page import="com.phishproof.model.User" %>
<%  User currentUser = (User) session.getAttribute("user");
    if (currentUser == null) { response.sendRedirect(request.getContextPath() + "/login"); return; } %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>PhishProof — Inbox</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://fonts.googleapis.com/css2?family=Share+Tech+Mono&family=Rajdhani:wght@400;600;700&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/main.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/inbox.css">
</head>
<body class="dark-theme">

<!-- Top bar -->
<nav class="inbox-topbar">
    <div class="topbar-brand">🛡️ <span>Phish</span><span class="accent">Proof</span> &nbsp;&mdash;&nbsp; <span class="small text-muted">Simulated Training Inbox</span></div>
    <div class="topbar-user">
        <span class="user-chip">${user.name}</span>
        <a href="${pageContext.request.contextPath}/logout" class="btn-logout">Logout</a>
    </div>
</nav>

<div class="inbox-layout">
    <!-- Sidebar -->
    <div class="inbox-sidebar">
        <div class="folder active">📥 Inbox <span class="folder-count">${links.size()}</span></div>
        <div class="folder">🔒 Security Tips</div>
        <hr style="border-color:#1e3a5f">
        <div class="inbox-info">
            <p>⚠️ This is a <strong>phishing simulation</strong> training environment.</p>
            <p>Some emails may be phishing attempts. Can you spot them?</p>
        </div>
    </div>

    <!-- Email list -->
    <div class="email-list">
        <div class="email-list-header">📧 Inbox — ${links.size()} message(s)</div>

        <c:choose>
        <c:when test="${empty links}">
            <div class="empty-inbox">
                <div class="empty-icon">📭</div>
                <p>Your inbox is empty. Check back soon.</p>
            </div>
        </c:when>
        <c:otherwise>
            <c:forEach var="link" items="${links}">
            <div class="email-item ${link.clicked ? 'read' : 'unread'}"
                 onclick="openEmail('${link.token}', '${baseUrl}')">
                <div class="email-avatar">📧</div>
                <div class="email-body">
                    <div class="email-from">
                        <c:choose>
                            <c:when test="${link.campaignId % 5 == 0}">security-team@yourcompany.com</c:when>
                            <c:when test="${link.campaignId % 5 == 1}">no-reply@accounts.google.com</c:when>
                            <c:when test="${link.campaignId % 5 == 2}">support@facebook.com</c:when>
                            <c:when test="${link.campaignId % 5 == 3}">alerts@onlinebanking.com</c:when>
                            <c:otherwise>IT-support@yourcompany.net</c:otherwise>
                        </c:choose>
                    </div>
                    <div class="email-subject">
                        <c:if test="${!link.clicked}"><strong></c:if>
                        Action Required: Verify your account immediately
                        <c:if test="${!link.clicked}"></strong></c:if>
                    </div>
                    <div class="email-preview">
                        Your account has been flagged for unusual activity. Please verify your credentials to avoid suspension...
                    </div>
                </div>
                <div class="email-meta">
                    <div class="email-time">Today</div>
                    <c:if test="${!link.clicked}"><div class="unread-dot"></div></c:if>
                    <c:if test="${link.submitted}"><div class="submitted-badge">⚠ Opened</div></c:if>
                </div>
            </div>
            </c:forEach>
        </c:otherwise>
        </c:choose>
    </div>
</div>

<!-- Email Preview Modal -->
<div class="modal fade" id="emailModal" tabindex="-1">
    <div class="modal-dialog modal-xl">
        <div class="modal-content cyber-modal">
            <div class="modal-header">
                <h5 class="modal-title">📧 Email Preview</h5>
                <button type="button" class="btn-close btn-close-white" data-bs-dismiss="modal"></button>
            </div>
            <div class="modal-body" id="emailContent">
                <p class="text-center text-muted">Loading...</p>
            </div>
            <div class="modal-footer">
                <div class="report-question">
                    <strong>🤔 Do you think this is a phishing email?</strong><br>
                    <a id="clickLink" href="#" class="btn btn-danger mt-2">Click the link in this email</a>
                    &nbsp;
                    <button class="btn btn-success mt-2" onclick="reportPhish()">🚨 Report as Phishing</button>
                </div>
            </div>
        </div>
    </div>
</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
<script>
let currentToken = '';
let currentBase = '';

function openEmail(token, base) {
    currentToken = token;
    currentBase  = base;
    const phishUrl = base + '/phish?t=' + token;

    document.getElementById('emailContent').innerHTML = `
        <div class="fake-email-view">
            <div class="fake-email-header">
                <div><strong>From:</strong> security-alert@accounts-verify.net</div>
                <div><strong>To:</strong> ${currentUser.email}</div>
                <div><strong>Subject:</strong> ⚠ Urgent: Action Required — Account Verification</div>
            </div>
            <hr style="border-color:#1e3a5f">
            <div class="fake-email-body">
                <p>Dear User,</p>
                <p>We have detected <strong>unusual login activity</strong> on your account from an unrecognized device.</p>
                <p>To protect your account, please <strong>verify your identity immediately</strong> by clicking the button below:</p>
                <div class="text-center my-3">
                    <a href="${phishUrl}" class="btn btn-primary" style="padding:12px 40px;font-size:16px">
                        ✅ Verify My Account Now
                    </a>
                </div>
                <p style="color:#888;font-size:12px">
                    If you do not verify within 24 hours, your account will be temporarily suspended.<br>
                    This link expires in: <strong style="color:#e6a817">23:58:42</strong>
                </p>
                <hr style="border-color:#1e3a5f">
                <p style="color:#666;font-size:11px">
                    Security Team | accounts-verify.net | 1600 Amphitheatre Pkwy, Mountain View, CA
                </p>
            </div>
        </div>`;

    document.getElementById('clickLink').href = phishUrl;
    new bootstrap.Modal(document.getElementById('emailModal')).show();
}

function reportPhish() {
    alert('✅ Correct! You identified this as a phishing email.\\n\\nRed flags you spotted:\\n• Sender domain: accounts-verify.net (not a real domain)\\n• Urgency / pressure tactics\\n• Threatening account suspension\\nGreat job staying safe!');
    bootstrap.Modal.getInstance(document.getElementById('emailModal')).hide();
}

// Countdown timer (fake urgency)
let timeLeft = 86382;
setInterval(() => {
    timeLeft--;
    const h = String(Math.floor(timeLeft/3600)).padStart(2,'0');
    const m = String(Math.floor((timeLeft%3600)/60)).padStart(2,'0');
    const s = String(timeLeft%60).padStart(2,'0');
    const el = document.querySelector('#emailContent strong[style*="color:#e6a817"]');
    if(el) el.textContent = h+':'+m+':'+s;
}, 1000);
</script>
</body>
</html>
