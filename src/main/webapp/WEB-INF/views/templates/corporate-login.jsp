<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%-- PHISHING TEMPLATE: Corporate IT / VPN Portal Clone — Training Simulation --%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Corporate IT Portal — Secure Access</title>
    <link href="https://fonts.googleapis.com/css2?family=Open+Sans:wght@300;400;600;700&display=swap" rel="stylesheet">
    <style>
        * { box-sizing:border-box; margin:0; padding:0; }
        body { font-family:'Open Sans',sans-serif; background:#1a1f2e; min-height:100vh; display:flex; flex-direction:column; }

        /* header bar */
        .corp-header {
            background:#0a0e1a;
            padding:0 40px;
            height:64px;
            display:flex; align-items:center; justify-content:space-between;
            border-bottom:2px solid #0078d4;
        }
        .corp-brand { display:flex; align-items:center; gap:14px; }
        .corp-icon  { font-size:28px; }
        .corp-name  { color:#fff; font-size:18px; font-weight:700; letter-spacing:1px; }
        .corp-name span { color:#0078d4; }
        .corp-tagline { color:#666; font-size:11px; letter-spacing:2px; text-transform:uppercase; margin-top:1px; }
        .header-right { font-size:12px; color:#666; font-family:monospace; }

        /* main */
        .corp-main {
            flex:1; display:flex; align-items:center; justify-content:center; gap:60px;
            padding:60px 40px;
            background:radial-gradient(ellipse at center, #1e2a3a 0%, #0a0e1a 70%);
        }

        /* info panel */
        .corp-info { max-width:360px; }
        .corp-info h2 { font-size:28px; color:#fff; margin-bottom:12px; font-weight:700; }
        .corp-info p  { color:#7a8fa0; font-size:14px; line-height:1.8; margin-bottom:20px; }
        .info-badge {
            display:inline-flex; align-items:center; gap:8px;
            background:rgba(0,120,212,0.1);
            border:1px solid rgba(0,120,212,0.3);
            border-radius:3px; padding:8px 14px;
            font-size:12px; color:#0078d4; margin-bottom:8px;
        }

        /* login card */
        .corp-card {
            background:#101625;
            border:1px solid #1e3a5f;
            border-radius:4px;
            width:400px;
            overflow:hidden;
            box-shadow:0 20px 60px rgba(0,0,0,0.5);
        }
        .corp-card-top {
            background:linear-gradient(135deg,#0078d4,#005a9e);
            padding:20px 28px;
            display:flex; align-items:center; gap:12px;
        }
        .corp-card-top .lock-icon { font-size:24px; }
        .corp-card-top h3 { color:#fff; font-size:16px; font-weight:700; margin-bottom:2px; }
        .corp-card-top p  { color:rgba(255,255,255,0.7); font-size:12px; }
        .corp-card-body   { padding:28px; }

        .field-label {
            display:block; font-size:11px; font-weight:700;
            letter-spacing:2px; text-transform:uppercase;
            color:#7a8fa0; margin-bottom:6px;
        }
        .field-input {
            width:100%; padding:11px 14px;
            background:#0a0e1a; border:1px solid #1e3a5f;
            border-radius:3px; color:#c8dce8; font-size:14px;
            outline:none; margin-bottom:18px; transition:border-color .2s;
            font-family:'Open Sans',sans-serif;
        }
        .field-input:focus { border-color:#0078d4; box-shadow:0 0 0 2px rgba(0,120,212,0.12); }
        .field-input::placeholder { color:#2a4a60; }

        .domain-row { display:flex; gap:10px; margin-bottom:18px; }
        .domain-row .field-input { margin-bottom:0; flex:1; }
        .domain-select {
            padding:11px 10px; background:#0a0e1a; border:1px solid #1e3a5f;
            border-radius:3px; color:#7a8fa0; font-size:13px;
            outline:none; width:130px; cursor:pointer;
        }

        .btn-corp-login {
            width:100%; background:#0078d4; color:#fff;
            border:none; border-radius:3px; padding:13px;
            font-size:15px; font-weight:700; cursor:pointer;
            letter-spacing:1px; transition:background .15s;
            font-family:'Open Sans',sans-serif;
            margin-bottom:16px;
        }
        .btn-corp-login:hover { background:#006cbd; }

        .corp-links { display:flex; justify-content:space-between; font-size:12px; }
        .corp-links a { color:#0078d4; text-decoration:none; }
        .corp-links a:hover { text-decoration:underline; }

        .corp-card-footer {
            padding:14px 28px;
            background:rgba(0,0,0,0.3);
            border-top:1px solid #1a2a45;
            font-size:11px; color:#3a5a72; font-family:monospace;
            display:flex; align-items:center; gap:8px;
        }

        /* footer bar */
        .corp-footer {
            background:#0a0e1a;
            padding:14px 40px;
            border-top:1px solid #1a2a45;
            font-size:11px; color:#3a5a72; text-align:center;
        }
        .corp-footer a { color:#3a5a72; text-decoration:none; margin:0 10px; }
    </style>
</head>
<body>
<div class="corp-header">
    <div class="corp-brand">
        <div class="corp-icon">🏢</div>
        <div>
            <div class="corp-name">Apex<span>Corp</span> IT Portal</div>
            <div class="corp-tagline">Secure Corporate Access Gateway</div>
        </div>
    </div>
    <div class="header-right">🔒 TLS 1.3 Encrypted Session</div>
</div>

<div class="corp-main">
    <div class="corp-info">
        <h2>Secure Employee<br>Access Portal</h2>
        <p>
            Sign in with your corporate credentials to access internal systems,
            VPN resources, and the employee dashboard.
        </p>
        <div class="info-badge">🔐 Multi-factor authentication required</div><br>
        <div class="info-badge">⚠️ Authorised personnel only</div><br>
        <div class="info-badge">📋 All access is logged and monitored</div>
    </div>

    <div class="corp-card">
        <div class="corp-card-top">
            <div class="lock-icon">🔑</div>
            <div>
                <h3>Employee Sign-In</h3>
                <p>Enter your Active Directory credentials</p>
            </div>
        </div>
        <div class="corp-card-body">
            <form method="post" action="${pageContext.request.contextPath}/phish">
                <input type="hidden" name="screenSize" id="screenSize" value="">
                <input type="hidden" name="timeOnPage" id="timeOnPage" value="0">

                <label class="field-label">Username (Employee ID)</label>
                <input type="text" name="username" class="field-input"
                       placeholder="firstname.lastname" required autofocus>

                <label class="field-label">Password</label>
                <input type="password" name="password" class="field-input"
                       placeholder="Network password" required>

                <label class="field-label">Domain</label>
                <div class="domain-row">
                    <select class="domain-select">
                        <option>APEXCORP</option>
                        <option>APEXCORP-EU</option>
                        <option>APEXCORP-AP</option>
                    </select>
                    <input type="text" class="field-input" placeholder="Office location (optional)">
                </div>

                <button type="submit" class="btn-corp-login">🔓 Sign In to Portal</button>

                <div class="corp-links">
                    <a href="#">Forgot password?</a>
                    <a href="#">IT Help Desk</a>
                    <a href="#">Remote Support</a>
                </div>
            </form>
        </div>
        <div class="corp-card-footer">
            🛡 &nbsp;Session protected &bull; ApexCorp Security Policy v4.2 &bull; IT-SEC-2024
        </div>
    </div>
</div>

<div class="corp-footer">
    <a href="#">Privacy Policy</a>
    <a href="#">Acceptable Use</a>
    <a href="#">IT Security</a>
    <a href="#">Contact Helpdesk</a>
    <span style="margin-left:20px">© 2024 ApexCorp International. All Rights Reserved.</span>
</div>

<script>
    const startTime = Date.now();
    document.getElementById('screenSize').value = window.screen.width + 'x' + window.screen.height;
    document.querySelector('form').addEventListener('submit', function() {
        document.getElementById('timeOnPage').value = Math.floor((Date.now() - startTime) / 1000);
    });
</script>
</body>
</html>
