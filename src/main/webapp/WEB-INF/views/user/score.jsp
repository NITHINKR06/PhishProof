<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ page import="com.phishproof.model.User" %>
<%  User cu = (User) session.getAttribute("user");
    if (cu == null) { response.sendRedirect(request.getContextPath() + "/login"); return; } %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>PhishProof — My Awareness Score</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://fonts.googleapis.com/css2?family=Share+Tech+Mono&family=Rajdhani:wght@400;600;700&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/main.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/inbox.css">
    <script src="https://cdn.jsdelivr.net/npm/chart.js@4.4.0/dist/chart.umd.min.js"></script>
    <style>
        .score-hero {
            text-align: center;
            padding: 50px 20px 36px;
        }
        .big-score {
            font-family: var(--font-mono);
            font-size: 88px; font-weight: 700;
            line-height: 1; margin: 16px 0;
        }
        .score-ring-wrap { display: inline-block; position: relative; }
        .level-badge {
            display: inline-block;
            padding: 6px 20px;
            border-radius: 20px;
            font-size: 14px; font-weight: 700;
            letter-spacing: 2px; text-transform: uppercase;
        }
        .level-novice   { background: rgba(220,53,69,0.15);  color: #dc3545; border: 1px solid rgba(220,53,69,0.3); }
        .level-learning { background: rgba(230,168,23,0.15); color: #e6a817; border: 1px solid rgba(230,168,23,0.3); }
        .level-aware    { background: rgba(0,180,255,0.15);  color: #00b4ff; border: 1px solid rgba(0,180,255,0.3); }
        .level-expert   { background: rgba(26,170,92,0.15);  color: #1aaa5c; border: 1px solid rgba(26,170,92,0.3); }

        .stat-row { display: grid; grid-template-columns: repeat(3,1fr); gap: 16px; margin-bottom: 28px; }
        .mini-stat-card {
            background: var(--bg-card);
            border: 1px solid var(--border-dim);
            border-radius: 4px; padding: 20px;
            text-align: center;
        }
        .mini-stat-card .val { font-size: 32px; font-weight: 700; color: #fff; }
        .mini-stat-card .lbl { font-size: 11px; color: var(--text-muted); text-transform: uppercase; letter-spacing: 2px; margin-top: 4px; }

        .history-item {
            display: flex; align-items: center; gap: 16px;
            padding: 16px 20px;
            border-bottom: 1px solid var(--border-dim);
        }
        .history-item:last-child { border-bottom: none; }
        .h-campaign { flex: 1; }
        .h-name  { font-weight: 600; color: #fff; font-size: 15px; }
        .h-date  { font-size: 11px; color: var(--text-muted); font-family: var(--font-mono); }
        .h-score { font-family: var(--font-mono); font-size: 22px; font-weight: 700; }
        .h-result-icon { font-size: 24px; }
    </style>
</head>
<body class="dark-theme">

<nav class="inbox-topbar">
    <div class="topbar-brand">🛡️ <span>Phish</span><span class="accent">Proof</span> &mdash; <span class="small text-muted">My Scores</span></div>
    <div class="topbar-user">
        <span class="user-chip">${cu.name}</span>
        <a href="${pageContext.request.contextPath}/user/inbox" class="btn-logout" style="color:var(--accent-blue);border-color:rgba(0,180,255,0.3)">← Inbox</a>
        <a href="${pageContext.request.contextPath}/logout" class="btn-logout">Logout</a>
    </div>
</nav>

<div style="margin-top:56px; max-width:860px; margin-left:auto; margin-right:auto; padding:36px 20px">

    <!-- Hero score -->
    <div class="score-hero">
        <div style="font-size:12px;letter-spacing:3px;text-transform:uppercase;color:var(--text-muted);margin-bottom:8px">Your Phishing Awareness Score</div>
        <canvas id="gaugeChart" width="200" height="110" style="display:block;margin:0 auto 10px"></canvas>
        <div class="big-score" id="overallScore" style="color:var(--accent-yellow)">—</div>
        <div id="levelBadge" class="level-badge level-learning">Calculating...</div>
        <p style="color:var(--text-muted);margin-top:14px;font-size:14px;max-width:440px;margin-inline:auto">
            Based on your simulation history. The higher the score, the more phishing-aware you are.
        </p>
    </div>

    <!-- Stats -->
    <div class="stat-row">
        <div class="mini-stat-card">
            <div class="val" style="color:var(--accent-blue)" id="statTotal">—</div>
            <div class="lbl">Campaigns Received</div>
        </div>
        <div class="mini-stat-card">
            <div class="val" style="color:var(--accent-red)" id="statClicked">—</div>
            <div class="lbl">Times Clicked</div>
        </div>
        <div class="mini-stat-card">
            <div class="val" style="color:var(--accent-green)" id="statSafe">—</div>
            <div class="lbl">Stayed Safe</div>
        </div>
    </div>

    <!-- History -->
    <div class="cyber-card">
        <div class="cyber-card-header">📋 Simulation History</div>
        <c:choose>
            <c:when test="${empty links}">
                <div style="text-align:center;padding:48px;color:var(--text-muted)">
                    <div style="font-size:40px;margin-bottom:12px">📭</div>
                    No simulations yet. Check your inbox for campaigns!
                </div>
            </c:when>
            <c:otherwise>
                <c:forEach var="link" items="${links}">
                <div class="history-item">
                    <div class="h-result-icon">
                        <c:choose>
                            <c:when test="${link.submitted}">😱</c:when>
                            <c:when test="${link.clicked}">😬</c:when>
                            <c:otherwise>✅</c:otherwise>
                        </c:choose>
                    </div>
                    <div class="h-campaign">
                        <div class="h-name">Phishing Simulation #${link.campaignId}</div>
                        <div class="h-date">
                            <c:choose>
                                <c:when test="${link.clickedAt != null}">Clicked: ${link.clickedAt}</c:when>
                                <c:otherwise>Not yet opened</c:otherwise>
                            </c:choose>
                        </div>
                    </div>
                    <div>
                        <c:choose>
                            <c:when test="${link.submitted}">
                                <span class="badge" style="background:rgba(220,53,69,0.12);color:#dc3545;border:1px solid rgba(220,53,69,0.25)">⚠ Submitted Creds</span>
                            </c:when>
                            <c:when test="${link.clicked}">
                                <span class="badge badge-warning">Clicked Link</span>
                            </c:when>
                            <c:otherwise>
                                <span class="badge badge-success">Stayed Safe</span>
                            </c:otherwise>
                        </c:choose>
                    </div>
                    <div class="h-score">
                        <c:choose>
                            <c:when test="${link.submitted}"><span style="color:var(--accent-red)">15</span></c:when>
                            <c:when test="${link.clicked}"><span style="color:var(--accent-yellow)">40</span></c:when>
                            <c:otherwise><span style="color:var(--accent-green)">85</span></c:otherwise>
                        </c:choose>
                    </div>
                </div>
                </c:forEach>
            </c:otherwise>
        </c:choose>
    </div>

    <!-- Tips based on performance -->
    <div class="cyber-card mt-3">
        <div class="cyber-card-header">💡 Personalised Tips</div>
        <div style="padding:20px">
            <p style="color:var(--text-secondary);font-size:14px;line-height:1.8;margin:0">
                Keep practising with new simulations. Each time you successfully identify a phishing attempt,
                your score improves. Focus on checking the URL bar before entering credentials —
                this single habit blocks over 90% of phishing attacks.
            </p>
        </div>
    </div>

</div>

<script>
// Pull stats from links on the page
const links = [
    <c:forEach var="link" items="${links}" varStatus="st">
    { clicked: ${link.clicked}, submitted: ${link.submitted} }<c:if test="${!st.last}">,</c:if>
    </c:forEach>
];

const total     = links.length;
const clicked   = links.filter(l => l.clicked).length;
const submitted = links.filter(l => l.submitted).length;
const safe      = total - clicked;

document.getElementById('statTotal').textContent   = total;
document.getElementById('statClicked').textContent  = clicked;
document.getElementById('statSafe').textContent     = safe;

// Compute overall score
let score = total === 0 ? 0 : Math.round(
    ((safe * 85) + ((clicked - submitted) * 40) + (submitted * 15)) / Math.max(total, 1)
);
score = Math.max(0, Math.min(100, score));

// Animate score
let cur = 0;
const el = document.getElementById('overallScore');
const t = setInterval(() => {
    cur += 2;
    if (cur >= score) { cur = score; clearInterval(t); }
    el.textContent = cur + '/100';
    el.style.color = cur < 30 ? '#dc3545' : cur < 60 ? '#e6a817' : '#1aaa5c';
}, 20);

// Level badge
setTimeout(() => {
    const badge = document.getElementById('levelBadge');
    if (score < 30)      { badge.textContent = '🔴 Novice — High Risk';   badge.className = 'level-badge level-novice'; }
    else if (score < 50) { badge.textContent = '🟡 Learning — Moderate';  badge.className = 'level-badge level-learning'; }
    else if (score < 75) { badge.textContent = '🔵 Aware — Getting Good'; badge.className = 'level-badge level-aware'; }
    else                 { badge.textContent = '🟢 Expert — Well Done!';  badge.className = 'level-badge level-expert'; }
}, 600);

// Gauge chart
const gauge = document.getElementById('gaugeChart');
new Chart(gauge, {
    type: 'doughnut',
    data: {
        datasets: [{
            data: [score, 100 - score],
            backgroundColor: [score < 30 ? '#dc3545' : score < 60 ? '#e6a817' : '#1aaa5c', '#1a2a45'],
            borderWidth: 0,
            circumference: 180,
            rotation: 270
        }]
    },
    options: {
        plugins: { legend: { display: false }, tooltip: { enabled: false } },
        cutout: '75%'
    }
});
</script>
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
