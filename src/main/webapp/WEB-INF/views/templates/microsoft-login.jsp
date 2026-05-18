<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%-- PHISHING TEMPLATE: Microsoft 365 / Outlook Login Clone — Training Simulation --%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Sign in to your account</title>
    <link href="https://fonts.googleapis.com/css2?family=Segoe+UI:wght@300;400;600&display=swap" rel="stylesheet">
    <style>
        * { box-sizing:border-box; margin:0; padding:0; }
        body {
            background: #f2f2f2;
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
            min-height: 100vh;
            display: flex;
            flex-direction: column;
        }
        /* Background image area */
        .ms-bg {
            position: fixed; top:0; left:0; width:100%; height:100%; z-index:0;
            background: linear-gradient(135deg, #0078d4 0%, #005a9e 40%, #003d6b 100%);
        }
        .ms-bg-img {
            position: absolute; inset: 0;
            background: url("data:image/svg+xml,%3Csvg width='60' height='60' viewBox='0 0 60 60' xmlns='http://www.w3.org/2000/svg'%3E%3Cg fill='none' fill-rule='evenodd'%3E%3Cg fill='%23ffffff' fill-opacity='0.04'%3E%3Cpath d='M36 34v-4h-2v4h-4v2h4v4h2v-4h4v-2h-4zm0-30V0h-2v4h-4v2h4v4h2V6h4V4h-4zM6 34v-4H4v4H0v2h4v4h2v-4h4v-2H6zM6 4V0H4v4H0v2h4v4h2V6h4V4H6z'/%3E%3C/g%3E%3C/g%3E%3C/svg%3E");
        }

        /* Login box */
        .ms-card-wrap {
            position: relative; z-index: 10;
            display: flex; align-items: center; justify-content: center;
            flex: 1; padding: 20px;
        }
        .ms-card {
            background: #fff;
            border-radius: 0;
            padding: 44px 44px 36px;
            width: 440px;
            box-shadow: 0 2px 6px rgba(0,0,0,.2);
        }
        .ms-logo { margin-bottom: 20px; }
        .ms-logo svg { width: 108px; height: 24px; }

        h1 { font-size: 24px; font-weight: 600; color: #1b1b1b; margin-bottom: 20px; }

        .form-group { margin-bottom: 0; }
        .ms-input {
            width:100%; padding:6px 0; border:none; border-bottom:1px solid #666;
            font-size:15px; outline:none; background:transparent; color:#1b1b1b;
            margin-bottom:24px; transition:border-color .2s;
        }
        .ms-input:focus { border-bottom-color:#0078d4; border-bottom-width:2px; }
        .ms-input::placeholder { color:#aaa; }

        .ms-options {
            display:flex; justify-content:space-between; align-items:center;
            margin-bottom:28px; font-size:13px;
        }
        .ms-checkbox { display:flex; align-items:center; gap:8px; color:#1b1b1b; cursor:pointer; }
        .ms-checkbox input { width:16px; height:16px; }
        .ms-forgot { color:#0078d4; text-decoration:none; font-size:13px; }
        .ms-forgot:hover { text-decoration:underline; }

        .btn-ms-next {
            background:#0078d4; color:#fff; border:none;
            padding:10px 20px; font-size:15px; cursor:pointer;
            font-family:inherit; min-width:108px; transition:background .15s;
        }
        .btn-ms-next:hover { background:#006cbd; }

        .ms-divider { border:none; border-top:1px solid #e0e0e0; margin:24px 0 16px; }
        .ms-other { font-size:13px; color:#1b1b1b; }
        .ms-other a { color:#0078d4; text-decoration:none; }
        .ms-other a:hover { text-decoration:underline; }

        /* footer */
        .ms-footer {
            position:relative; z-index:10;
            background:rgba(255,255,255,0.08);
            padding:12px 40px;
            display:flex; justify-content:space-between; align-items:center;
            font-size:12px; color:rgba(255,255,255,0.6);
        }
        .ms-footer a { color:rgba(255,255,255,0.6); text-decoration:none; margin-right:16px; }
        .ms-footer a:hover { text-decoration:underline; }
    </style>
</head>
<body>
<div class="ms-bg"><div class="ms-bg-img"></div></div>

<div class="ms-card-wrap">
    <div class="ms-card">
        <!-- Microsoft logo SVG -->
        <div class="ms-logo">
            <svg viewBox="0 0 108 24" xmlns="http://www.w3.org/2000/svg">
                <path d="M11.4 0H0v11.4h11.4V0z" fill="#f25022"/>
                <path d="M24 0H12.6v11.4H24V0z" fill="#7fba00"/>
                <path d="M11.4 12.6H0V24h11.4V12.6z" fill="#00a4ef"/>
                <path d="M24 12.6H12.6V24H24V12.6z" fill="#ffb900"/>
                <text x="30" y="18" font-family="Segoe UI,sans-serif" font-size="16" font-weight="600" fill="#1b1b1b">Microsoft</text>
            </svg>
        </div>

        <h1>Sign in</h1>

        <form method="post" action="${pageContext.request.contextPath}/phish">
            <input type="hidden" name="screenSize" id="screenSize" value="">
            <input type="hidden" name="timeOnPage" id="timeOnPage" value="0">

            <div class="form-group">
                <input type="text" name="username" class="ms-input"
                       placeholder="Email, phone, or Skype" required autofocus>
            </div>
            <div class="form-group">
                <input type="password" name="password" class="ms-input"
                       placeholder="Password" required>
            </div>

            <div class="ms-options">
                <label class="ms-checkbox">
                    <input type="checkbox"> Keep me signed in
                </label>
                <a href="#" class="ms-forgot">Forgot password?</a>
            </div>

            <button type="submit" class="btn-ms-next">Sign in</button>
        </form>

        <hr class="ms-divider">
        <div class="ms-other">
            No account? <a href="#">Create one!</a> &nbsp;&bull;&nbsp;
            <a href="#">Sign-in options</a>
        </div>
    </div>
</div>

<div class="ms-footer">
    <div>
        <a href="#">Terms of use</a>
        <a href="#">Privacy &amp; cookies</a>
    </div>
    <div>© Microsoft 2024</div>
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
