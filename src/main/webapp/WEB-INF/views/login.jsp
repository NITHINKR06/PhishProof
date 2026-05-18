<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>PhishProof — Login</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://fonts.googleapis.com/css2?family=Share+Tech+Mono&family=Rajdhani:wght@400;600;700&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/main.css">
    <style>
        body {
            background: #0a0e1a;
            min-height: 100vh;
            display: flex;
            align-items: center;
            justify-content: center;
            font-family: 'Rajdhani', sans-serif;
            overflow: hidden;
        }
        .matrix-bg {
            position: fixed; top:0; left:0; width:100%; height:100%;
            z-index: 0; opacity: 0.08; pointer-events: none;
        }
        .login-card {
            background: #0d1226;
            border: 1px solid #1e3a5f;
            border-radius: 4px;
            padding: 40px;
            width: 420px;
            position: relative;
            z-index: 10;
            box-shadow: 0 0 40px rgba(0, 180, 255, 0.08);
        }
        .login-card::before {
            content: '';
            position: absolute; top: 0; left: 0; right: 0;
            height: 2px;
            background: linear-gradient(90deg, transparent, #00b4ff, transparent);
        }
        .brand-logo {
            text-align: center;
            margin-bottom: 32px;
        }
        .brand-logo .shield-icon {
            font-size: 48px;
            margin-bottom: 8px;
        }
        .brand-logo h1 {
            font-size: 28px;
            font-weight: 700;
            color: #fff;
            letter-spacing: 4px;
            text-transform: uppercase;
        }
        .brand-logo span {
            color: #00b4ff;
        }
        .brand-logo p {
            font-family: 'Share Tech Mono', monospace;
            font-size: 11px;
            color: #4a6580;
            letter-spacing: 2px;
            margin: 0;
        }
        .form-label {
            color: #7a9bb5;
            font-size: 12px;
            letter-spacing: 2px;
            text-transform: uppercase;
            font-weight: 600;
        }
        .form-control {
            background: #070b16;
            border: 1px solid #1e3a5f;
            border-radius: 2px;
            color: #c8dce8;
            font-family: 'Share Tech Mono', monospace;
            padding: 12px 16px;
        }
        .form-control:focus {
            background: #070b16;
            border-color: #00b4ff;
            box-shadow: 0 0 0 2px rgba(0,180,255,0.1);
            color: #fff;
        }
        .form-control::placeholder { color: #2a4a60; }
        .btn-login {
            width: 100%;
            background: transparent;
            border: 1px solid #00b4ff;
            color: #00b4ff;
            font-family: 'Share Tech Mono', monospace;
            font-size: 13px;
            letter-spacing: 3px;
            text-transform: uppercase;
            padding: 14px;
            transition: all 0.2s;
            border-radius: 2px;
        }
        .btn-login:hover {
            background: #00b4ff;
            color: #000;
            box-shadow: 0 0 20px rgba(0,180,255,0.3);
        }
        .alert-danger {
            background: rgba(220, 53, 69, 0.1);
            border: 1px solid rgba(220,53,69,0.3);
            color: #ff6b7a;
            border-radius: 2px;
            font-family: 'Share Tech Mono', monospace;
            font-size: 12px;
        }
        .demo-creds {
            margin-top: 24px;
            padding: 16px;
            background: rgba(0,180,255,0.04);
            border: 1px solid #1e3a5f;
            border-radius: 2px;
        }
        .demo-creds p {
            font-family: 'Share Tech Mono', monospace;
            font-size: 11px;
            color: #4a6580;
            margin: 2px 0;
        }
        .demo-creds .label { color: #2a5a7a; }
        .demo-creds .cred  { color: #00b4ff; }
        .scanline {
            position: fixed; top:0; left:0; width:100%; height:100%;
            background: repeating-linear-gradient(0deg, transparent, transparent 2px, rgba(0,0,0,0.05) 2px, rgba(0,0,0,0.05) 4px);
            pointer-events: none; z-index: 5;
        }
    </style>
</head>
<body>
<canvas class="matrix-bg" id="matrixCanvas"></canvas>
<div class="scanline"></div>

<div class="login-card">
    <div class="brand-logo">
        <div class="shield-icon">🛡️</div>
        <h1>Phish<span>Proof</span></h1>
        <p>[ SECURITY AWARENESS PLATFORM ]</p>
    </div>

    <% if (request.getAttribute("error") != null) { %>
    <div class="alert alert-danger mb-3">
        ⚠ &nbsp;<%= request.getAttribute("error") %>
    </div>
    <% } %>

    <form method="post" action="${pageContext.request.contextPath}/login">
        <div class="mb-3">
            <label class="form-label">Access Email</label>
            <input type="email" name="email" class="form-control" placeholder="user@domain.com" required autofocus>
        </div>
        <div class="mb-4">
            <label class="form-label">Password</label>
            <input type="password" name="password" class="form-control" placeholder="••••••••" required>
        </div>
        <button type="submit" class="btn btn-login">⟶ &nbsp;AUTHENTICATE</button>
    </form>

    <div class="demo-creds">
        <p><span class="label">ADMIN ▶</span>&nbsp;
           <span class="cred">admin@phishproof.local</span>&nbsp;/&nbsp;
           <span class="cred">Admin@123</span></p>
        <p><span class="label">USER &nbsp;▶</span>&nbsp;
           <span class="cred">alice@phishproof.local</span>&nbsp;/&nbsp;
           <span class="cred">Test@1234</span></p>
    </div>
</div>

<script>
    // Matrix rain background
    const canvas = document.getElementById('matrixCanvas');
    const ctx = canvas.getContext('2d');
    canvas.width = window.innerWidth;
    canvas.height = window.innerHeight;
    const cols = Math.floor(canvas.width / 20);
    const drops = Array(cols).fill(1);
    const chars = '01アイウエオカキクケコサシスセソ';
    function drawMatrix() {
        ctx.fillStyle = 'rgba(10,14,26,0.05)';
        ctx.fillRect(0, 0, canvas.width, canvas.height);
        ctx.fillStyle = '#00b4ff';
        ctx.font = '14px Share Tech Mono';
        drops.forEach((y, x) => {
            ctx.fillText(chars[Math.floor(Math.random() * chars.length)], x * 20, y * 20);
            if (y * 20 > canvas.height && Math.random() > 0.975) drops[x] = 0;
            drops[x]++;
        });
    }
    setInterval(drawMatrix, 60);
</script>
</body>
</html>
