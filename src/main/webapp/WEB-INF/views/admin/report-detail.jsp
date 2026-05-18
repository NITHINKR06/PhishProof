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
    <title>PhishProof — Report: ${campaign.name}</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://fonts.googleapis.com/css2?family=Share+Tech+Mono&family=Rajdhani:wght@400;600;700&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/main.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/admin.css">
    <script src="https://cdn.jsdelivr.net/npm/chart.js@4.4.0/dist/chart.umd.min.js"></script>
</head>
<body class="dark-theme">
    <%@ include file="../partials/admin-nav.jsp" %>

    <div class="main-content">
        <div class="page-header">
            <div>
                <h1 class="page-title">📊 Campaign Report</h1>
                <p class="page-sub">${campaign.name}</p>
            </div>
        </div>

        <!-- Chart Row -->
        <div class="row g-3 mb-4">
            <div class="col-md-4">
                <div class="cyber-card">
                    <div class="cyber-card-header">Results Breakdown</div>
                    <div style="padding:20px">
                        <canvas id="donutChart" height="220"></canvas>
                    </div>
                </div>
            </div>
            <div class="col-md-8">
                <div class="cyber-card">
                    <div class="cyber-card-header">User-level Results</div>
                    <div style="padding:20px">
                        <canvas id="barChart" height="220"></canvas>
                    </div>
                </div>
            </div>
        </div>

        <!-- Captured Credentials Table -->
        <div class="cyber-card">
            <div class="cyber-card-header">🔑 Captured Credentials</div>
            <div class="table-responsive">
                <table class="table cyber-table">
                    <thead>
                        <tr>
                            <th>User</th>
                            <th>Fake Username</th>
                            <th>Password (masked)</th>
                            <th>IP Address</th>
                            <th>Time on Page</th>
                            <th>Captured At</th>
                        </tr>
                    </thead>
                    <tbody>
                        <c:forEach var="cap" items="${captures}">
                        <tr>
                            <td>${cap.userName}</td>
                            <td class="mono-text">${cap.fakeUsername}</td>
                            <td class="mono-text">${cap.maskedPassword}</td>
                            <td class="mono-text">${cap.ipAddress}</td>
                            <td>${cap.timeOnPage}s</td>
                            <td class="mono-text">${cap.capturedAt}</td>
                        </tr>
                        </c:forEach>
                        <c:if test="${empty captures}">
                        <tr><td colspan="6" class="text-center text-muted py-3">No credentials captured yet.</td></tr>
                        </c:if>
                    </tbody>
                </table>
            </div>
        </div>
    </div>

<script>
// Fetch chart data
fetch('${pageContext.request.contextPath}/admin/reports/data?id=${campaign.id}')
  .then(r => r.json())
  .then(data => {
    const darkGrid = 'rgba(255,255,255,0.05)';
    const textColor = '#7a9bb5';
    Chart.defaults.color = textColor;

    // Donut chart
    new Chart(document.getElementById('donutChart'), {
        type: 'doughnut',
        data: {
            labels: ['Safe', 'Clicked Only', 'Submitted Creds'],
            datasets: [{
                data: [data.safe, data.clicked - data.submitted, data.submitted],
                backgroundColor: ['#1a9e5c','#e6a817','#dc3545'],
                borderColor: '#0d1226',
                borderWidth: 3
            }]
        },
        options: { plugins: { legend: { position: 'bottom' } } }
    });

    // Bar chart — per-user
    const links = ${campaign.totalTargets};
    new Chart(document.getElementById('barChart'), {
        type: 'bar',
        data: {
            labels: ['Total Targets', 'Clicked Link', 'Submitted Creds', 'Stayed Safe'],
            datasets: [{
                label: 'Users',
                data: [data.total, data.clicked, data.submitted, data.safe],
                backgroundColor: ['#1e3a5f','#e6a817','#dc3545','#1a9e5c'],
                borderRadius: 3
            }]
        },
        options: {
            plugins: { legend: { display: false } },
            scales: {
                x: { grid: { color: darkGrid } },
                y: { grid: { color: darkGrid }, beginAtZero: true }
            }
        }
    });
  });
</script>
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
