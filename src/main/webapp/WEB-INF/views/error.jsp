<%@ page contentType="text/html;charset=UTF-8" language="java" isErrorPage="true" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>PhishProof — Error</title>
    <link href="https://fonts.googleapis.com/css2?family=Share+Tech+Mono&family=Rajdhani:wght@700&display=swap" rel="stylesheet">
    <style>
        body { background:#07090f; color:#c8dce8; font-family:'Rajdhani',sans-serif; display:flex; align-items:center; justify-content:center; min-height:100vh; text-align:center; }
        .code { font-family:'Share Tech Mono',monospace; font-size:100px; color:#1e3a5f; line-height:1; }
        h1 { font-size:28px; color:#fff; margin:12px 0 8px; }
        p  { color:#3a5a72; font-size:15px; margin-bottom:24px; }
        a  { color:#00b4ff; border:1px solid #00b4ff; padding:10px 28px; text-decoration:none; font-size:13px; letter-spacing:2px; font-family:'Share Tech Mono',monospace; border-radius:2px; }
        a:hover { background:#00b4ff; color:#000; }
    </style>
</head>
<body>
<div>
    <div class="code"><%=request.getAttribute("javax.servlet.error.status_code") != null ? request.getAttribute("javax.servlet.error.status_code") : "ERR"%></div>
    <h1><%= request.getAttribute("message") != null ? request.getAttribute("message") : "Something went wrong" %></h1>
    <p>The requested resource could not be found or an internal error occurred.</p>
    <a href="${pageContext.request.contextPath}/login">← Return to Login</a>
</div>
</body>
</html>
