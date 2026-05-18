<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>PhishProof — Security Alert: You Were Phished</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://fonts.googleapis.com/css2?family=Share+Tech+Mono&family=Rajdhani:wght@400;600;700&display=swap" rel="stylesheet">
    <style>
        :root {
            --bg-primary:   #07090f;
            --bg-card:      #0d1426;
            --border-dim:   #1a2a45;
            --border-mid:   #1e3a5f;
            --accent-blue:  #00b4ff;
            --accent-red:   #dc3545;
            --accent-green: #1aaa5c;
            --accent-yellow:#e6a817;
            --text-primary: #c8dce8;
            --text-muted:   #3a5a72;
            --font-mono:    'Share Tech Mono', monospace;
            --font-ui:      'Rajdhani', sans-serif;
        }
        * { box-sizing: border-box; margin: 0; padding: 0; }
        body {
            background: var(--bg-primary);
            color: var(--text-primary);
            font-family: var(--font-ui);
            min-height: 100vh;
        }

        /* ── Warning banner ──────────────────────────── */
        .warning-banner {
            background: var(--accent-red);
            color: #fff;
            text-align: center;
            padding: 14px;
            font-size: 15px;
            font-weight: 700;
            letter-spacing: 3px;
            text-transform: uppercase;
            font-family: var(--font-mono);
            animation: blink-border 1.5s step-end infinite;
        }
        @keyframes blink-border {
            0%,100% { background: var(--accent-red); }
            50%      { background: #a00020; }
        }

        /* ── Layout ──────────────────────────────────── */
        .reveal-container { max-width: 900px; margin: 0 auto; padding: 40px 20px 60px; }

        /* ── Hero section ────────────────────────────── */
        .reveal-hero {
            text-align: center;
            padding: 50px 20px 40px;
            position: relative;
        }
        .hook-icon {
            font-size: 80px;
            display: block;
            animation: swing 1.5s ease-in-out infinite alternate;
        }
        @keyframes swing {
            from { transform: rotate(-10deg); }
            to   { transform: rotate(10deg); }
        }
        .reveal-hero h1 {
            font-size: 44px;
            font-weight: 700;
            color: var(--accent-red);
            letter-spacing: 3px;
            margin: 20px 0 8px;
            text-transform: uppercase;
        }
        .reveal-hero p {
            font-size: 18px;
            color: #7a9bb5;
            max-width: 560px;
            margin: 0 auto;
            line-height: 1.7;
        }

        /* ── What we captured card ───────────────────── */
        .captured-card {
            background: var(--bg-card);
            border: 2px solid var(--accent-red);
            border-radius: 6px;
            overflow: hidden;
            margin-bottom: 28px;
        }
        .captured-card-header {
            background: rgba(220,53,69,0.15);
            padding: 14px 20px;
            font-family: var(--font-mono);
            font-size: 13px;
            letter-spacing: 2px;
            color: var(--accent-red);
            display: flex;
            align-items: center;
            gap: 10px;
            border-bottom: 1px solid rgba(220,53,69,0.3);
        }
        .captured-row {
            display: flex;
            align-items: center;
            padding: 16px 20px;
            border-bottom: 1px solid var(--border-dim);
            gap: 16px;
        }
        .captured-row:last-child { border-bottom: none; }
        .captured-label {
            font-size: 11px;
            font-weight: 700;
            letter-spacing: 2px;
            text-transform: uppercase;
            color: #3a5a72;
            width: 140px;
            flex-shrink: 0;
        }
        .captured-value {
            font-family: var(--font-mono);
            font-size: 15px;
            color: #ff6b7a;
            word-break: break-all;
        }
        .captured-value.safe { color: var(--accent-green); }

        /* ── Red flags section ───────────────────────── */
        .section-title {
            font-size: 18px;
            font-weight: 700;
            color: #fff;
            letter-spacing: 2px;
            text-transform: uppercase;
            margin-bottom: 16px;
            padding-bottom: 10px;
            border-bottom: 1px solid var(--border-dim);
        }
        .red-flags-grid {
            display: grid;
            grid-template-columns: repeat(auto-fill, minmax(260px, 1fr));
            gap: 14px;
            margin-bottom: 28px;
        }
        .red-flag-card {
            background: var(--bg-card);
            border: 1px solid var(--border-mid);
            border-radius: 4px;
            padding: 18px;
            position: relative;
            overflow: hidden;
            transition: border-color 0.2s;
        }
        .red-flag-card:hover { border-color: var(--accent-yellow); }
        .red-flag-card::before {
            content: '';
            position: absolute;
            top: 0; left: 0; width: 3px; height: 100%;
            background: var(--accent-red);
        }
        .red-flag-icon  { font-size: 26px; margin-bottom: 10px; }
        .red-flag-title { font-size: 14px; font-weight: 700; color: var(--accent-yellow); margin-bottom: 6px; }
        .red-flag-desc  { font-size: 13px; color: #7a9bb5; line-height: 1.6; }

        /* ── Tips section ────────────────────────────── */
        .tips-list { list-style: none; margin-bottom: 28px; }
        .tips-list li {
            display: flex;
            align-items: flex-start;
            gap: 14px;
            padding: 14px 18px;
            background: var(--bg-card);
            border: 1px solid var(--border-dim);
            border-radius: 4px;
            margin-bottom: 10px;
            font-size: 14px;
            color: var(--text-primary);
            line-height: 1.6;
        }
        .tips-list li .tip-num {
            font-family: var(--font-mono);
            font-size: 11px;
            color: var(--accent-green);
            background: rgba(26,170,92,0.1);
            border: 1px solid rgba(26,170,92,0.2);
            padding: 2px 8px;
            border-radius: 2px;
            flex-shrink: 0;
            margin-top: 2px;
        }

        /* ── Score card ──────────────────────────────── */
        .score-card {
            background: var(--bg-card);
            border: 1px solid var(--border-mid);
            border-radius: 6px;
            padding: 30px;
            text-align: center;
            margin-bottom: 28px;
        }
        .score-label { font-size: 12px; letter-spacing: 3px; text-transform: uppercase; color: var(--text-muted); margin-bottom: 10px; }
        .score-value {
            font-size: 72px;
            font-weight: 700;
            line-height: 1;
            font-family: var(--font-mono);
        }
        .score-value.score-low    { color: var(--accent-red); }
        .score-value.score-medium { color: var(--accent-yellow); }
        .score-value.score-high   { color: var(--accent-green); }
        .score-desc { font-size: 14px; color: #7a9bb5; margin-top: 12px; }

        /* ── Data timeline ───────────────────────────── */
        .data-timeline { margin-bottom: 28px; }
        .timeline-item {
            display: flex;
            align-items: flex-start;
            gap: 14px;
            padding: 14px 0;
            border-bottom: 1px solid var(--border-dim);
        }
        .timeline-item:last-child { border-bottom: none; }
        .timeline-dot {
            width: 12px; height: 12px; border-radius: 50%;
            flex-shrink: 0; margin-top: 4px;
        }
        .dot-red    { background: var(--accent-red); box-shadow: 0 0 6px var(--accent-red); }
        .dot-yellow { background: var(--accent-yellow); }
        .dot-green  { background: var(--accent-green); }
        .timeline-text { font-size: 14px; color: var(--text-primary); }
        .timeline-time { font-family: var(--font-mono); font-size: 11px; color: var(--text-muted); margin-top: 2px; }

        /* ── CTA buttons ─────────────────────────────── */
        .cta-row { display: flex; gap: 14px; justify-content: center; flex-wrap: wrap; margin-top: 36px; }
        .btn-safe {
            background: var(--accent-green);
            color: #fff;
            border: none;
            padding: 14px 36px;
            font-family: var(--font-mono);
            font-size: 13px;
            letter-spacing: 2px;
            text-transform: uppercase;
            border-radius: 3px;
            cursor: pointer;
            text-decoration: none;
            display: inline-block;
            transition: all 0.2s;
        }
        .btn-safe:hover { background: #147a42; color: #fff; text-decoration: none; }
        .btn-outline-cyber {
            background: transparent;
            color: var(--accent-blue);
            border: 1px solid var(--accent-blue);
            padding: 14px 36px;
            font-family: var(--font-mono);
            font-size: 13px;
            letter-spacing: 2px;
            text-transform: uppercase;
            border-radius: 3px;
            cursor: pointer;
            text-decoration: none;
            display: inline-block;
            transition: all 0.2s;
        }
        .btn-outline-cyber:hover {
            background: var(--accent-blue); color: #000;
            text-decoration: none;
        }

        /* ── Progress bar animation ──────────────────── */
        .awareness-bar-wrap { margin: 20px 0; }
        .awareness-bar-label {
            display: flex;
            justify-content: space-between;
            font-size: 12px;
            color: var(--text-muted);
            margin-bottom: 6px;
        }
        .awareness-track {
            height: 10px;
            background: var(--border-dim);
            border-radius: 5px;
            overflow: hidden;
        }
        .awareness-fill {
            height: 100%;
            border-radius: 5px;
            transition: width 1.5s ease;
            background: linear-gradient(90deg, var(--accent-red), var(--accent-yellow));
        }
        .awareness-fill.fill-high {
            background: linear-gradient(90deg, var(--accent-yellow), var(--accent-green));
        }
    </style>
</head>
<body>

<!-- ── Warning banner ──────────────────────────────────────── -->
<div class="warning-banner">
    ⚠&nbsp;&nbsp;PHISHING SIMULATION — THIS WAS A TRAINING EXERCISE&nbsp;&nbsp;⚠
</div>

<div class="reveal-container">

    <!-- ── Hero ──────────────────────────────────────────────── -->
    <div class="reveal-hero">
        <span class="hook-icon">🎣</span>
        <h1>You Were Phished!</h1>
        <p>
            Don't worry — this was a <strong style="color:#fff">controlled training simulation</strong>.
            No real credentials were stolen. But in the real world, this could have been dangerous.
            Let's break down exactly what happened.
        </p>
    </div>

    <!-- ── What we captured ──────────────────────────────────── -->
    <c:if test="${captured != null}">
    <div class="captured-card">
        <div class="captured-card-header">
            🔓 &nbsp;DATA WE CAPTURED FROM YOU
        </div>
        <div class="captured-row">
            <div class="captured-label">Username / Email</div>
            <div class="captured-value">
                <c:choose>
                    <c:when test="${not empty captured.fakeUsername}">${captured.fakeUsername}</c:when>
                    <c:otherwise>(not entered)</c:otherwise>
                </c:choose>
            </div>
        </div>
        <div class="captured-row">
            <div class="captured-label">Password</div>
            <div class="captured-value">
                <c:choose>
                    <c:when test="${not empty captured.fakePassword}">
                        <span id="pwHidden">${captured.maskedPassword} &nbsp;
                            <button onclick="togglePw()" style="background:none;border:1px solid #3a5a72;color:#7a9bb5;padding:2px 8px;font-size:11px;border-radius:2px;cursor:pointer;font-family:var(--font-mono)">REVEAL</button>
                        </span>
                        <span id="pwVisible" style="display:none;color:#ff6b7a">${captured.fakePassword} &nbsp;
                            <button onclick="togglePw()" style="background:none;border:1px solid #3a5a72;color:#7a9bb5;padding:2px 8px;font-size:11px;border-radius:2px;cursor:pointer;font-family:var(--font-mono)">HIDE</button>
                        </span>
                    </c:when>
                    <c:otherwise class="safe">(not entered)</c:otherwise>
                </c:choose>
            </div>
        </div>
        <div class="captured-row">
            <div class="captured-label">IP Address</div>
            <div class="captured-value">${captured.ipAddress}</div>
        </div>
        <div class="captured-row">
            <div class="captured-label">Browser / OS</div>
            <div class="captured-value" style="font-size:12px">${captured.userAgent}</div>
        </div>
        <div class="captured-row">
            <div class="captured-label">Screen Size</div>
            <div class="captured-value">
                <c:choose>
                    <c:when test="${not empty captured.screenSize}">${captured.screenSize}</c:when>
                    <c:otherwise>—</c:otherwise>
                </c:choose>
            </div>
        </div>
        <div class="captured-row">
            <div class="captured-label">Time on Page</div>
            <div class="captured-value">${captured.timeOnPage} seconds before submitting</div>
        </div>
    </div>
    </c:if>

    <!-- ── Awareness score ───────────────────────────────────── -->
    <div class="score-card">
        <div class="score-label">Phishing Awareness Score</div>
        <div class="score-value score-low" id="scoreDisplay">0</div>
        <div class="awareness-bar-wrap">
            <div class="awareness-bar-label">
                <span>Vulnerable</span>
                <span>Aware</span>
                <span>Expert</span>
            </div>
            <div class="awareness-track">
                <div class="awareness-fill" id="awareFill" style="width:0%"></div>
            </div>
        </div>
        <div class="score-desc" id="scoreDesc">Calculating your awareness score...</div>
    </div>

    <!-- ── Red flags you missed ──────────────────────────────── -->
    <div class="section-title">🚩 Red Flags You Missed</div>
    <div class="red-flags-grid">
        <div class="red-flag-card">
            <div class="red-flag-icon">🌐</div>
            <div class="red-flag-title">Suspicious URL / Domain</div>
            <div class="red-flag-desc">
                The real site uses an official domain like <code>google.com</code> or <code>yourbank.com</code>.
                Attackers register lookalike domains (e.g. <code>accounts-verify.net</code>, <code>g00gle-login.com</code>).
                Always check the address bar first.
            </div>
        </div>
        <div class="red-flag-card">
            <div class="red-flag-icon">⚠️</div>
            <div class="red-flag-title">Urgency &amp; Fear Tactics</div>
            <div class="red-flag-desc">
                "Your account will be suspended in 24 hours!" — Phishers create panic to bypass your critical thinking.
                Legitimate companies rarely demand immediate action under threat of account loss.
            </div>
        </div>
        <div class="red-flag-card">
            <div class="red-flag-icon">📧</div>
            <div class="red-flag-title">Spoofed Sender Address</div>
            <div class="red-flag-desc">
                The sender email looked official but wasn't from the real domain.
                Always expand the sender details and check the full email address, not just the display name.
            </div>
        </div>
        <div class="red-flag-card">
            <div class="red-flag-icon">🔗</div>
            <div class="red-flag-title">Misleading Hyperlinks</div>
            <div class="red-flag-desc">
                Hover over links before clicking — the visible text can say one thing while the actual URL goes elsewhere.
                Look for URL shorteners, random token parameters, or unexpected domains.
            </div>
        </div>
        <div class="red-flag-card">
            <div class="red-flag-icon">🔒</div>
            <div class="red-flag-title">HTTPS ≠ Safe</div>
            <div class="red-flag-desc">
                A padlock icon means the connection is encrypted — it does NOT mean the site is legitimate.
                Attackers routinely use HTTPS on phishing pages. Always verify the domain itself.
            </div>
        </div>
        <div class="red-flag-card">
            <div class="red-flag-icon">🖥️</div>
            <div class="red-flag-title">Near-Identical Clone UI</div>
            <div class="red-flag-desc">
                The page looked exactly like the real site because it was copied from it.
                Pixel-perfect design means nothing — the only trustworthy indicator is the URL in the browser bar.
            </div>
        </div>
    </div>

    <!-- ── How to protect yourself ───────────────────────────── -->
    <div class="section-title">🛡️ How to Protect Yourself Next Time</div>
    <ul class="tips-list">
        <li>
            <span class="tip-num">01</span>
            <span><strong style="color:#fff">Always check the URL first.</strong> Before entering any credentials, look at the browser address bar. The domain must exactly match the legitimate service — no extra words, hyphens, or different TLDs.</span>
        </li>
        <li>
            <span class="tip-num">02</span>
            <span><strong style="color:#fff">Use a Password Manager.</strong> Password managers auto-fill credentials only on the exact registered domain. If it doesn't auto-fill, that's a red flag the URL isn't what you think it is.</span>
        </li>
        <li>
            <span class="tip-num">03</span>
            <span><strong style="color:#fff">Enable Multi-Factor Authentication (MFA).</strong> Even if a phisher captures your password, MFA ensures they still can't access your account without the second factor.</span>
        </li>
        <li>
            <span class="tip-num">04</span>
            <span><strong style="color:#fff">Pause before you click.</strong> Urgency is a manipulation tactic. If an email pressures you to act immediately, stop, take a breath, and verify through an official channel — not through the link in the email.</span>
        </li>
        <li>
            <span class="tip-num">05</span>
            <span><strong style="color:#fff">Verify unexpected requests directly.</strong> If your "bank" emails you about suspicious activity, close the email and navigate to your bank's website directly or call the number on the back of your card.</span>
        </li>
        <li>
            <span class="tip-num">06</span>
            <span><strong style="color:#fff">Report suspicious emails.</strong> Use your email client's "Report Phishing" feature. This helps protect everyone in your organisation. When in doubt, report it to your IT/security team.</span>
        </li>
    </ul>

    <!-- ── Attack timeline ───────────────────────────────────── -->
    <div class="section-title">⏱ Attack Timeline — What Just Happened</div>
    <div class="data-timeline">
        <div class="timeline-item">
            <div class="timeline-dot dot-yellow"></div>
            <div>
                <div class="timeline-text">📩 You received a simulated phishing email in your training inbox</div>
                <div class="timeline-time">Step 1 — Lure delivered</div>
            </div>
        </div>
        <div class="timeline-item">
            <div class="timeline-dot dot-red"></div>
            <div>
                <div class="timeline-text">👆 You clicked the phishing link — your click was logged with timestamp &amp; IP</div>
                <div class="timeline-time">Step 2 — Hook set</div>
            </div>
        </div>
        <div class="timeline-item">
            <div class="timeline-dot dot-red"></div>
            <div>
                <div class="timeline-text">🎭 You were shown a cloned login page — indistinguishable from the real site</div>
                <div class="timeline-time">Step 3 — Fake page rendered</div>
            </div>
        </div>
        <c:if test="${captured != null}">
        <div class="timeline-item">
            <div class="timeline-dot dot-red"></div>
            <div>
                <div class="timeline-text">🔑 You submitted credentials — username &amp; password captured instantly</div>
                <div class="timeline-time">Step 4 — Credentials harvested</div>
            </div>
        </div>
        </c:if>
        <div class="timeline-item">
            <div class="timeline-dot" style="background:#00b4ff;box-shadow:0 0 6px #00b4ff"></div>
            <div>
                <div class="timeline-text" style="color:#00b4ff">🛡️ In reality: attacker would now own your account. In this simulation: you're safe and learning.</div>
                <div class="timeline-time">Step 5 — Awareness unlocked</div>
            </div>
        </div>
    </div>

    <!-- ── CTA ───────────────────────────────────────────────── -->
    <div class="cta-row">
        <a href="${pageContext.request.contextPath}/user/inbox" class="btn-outline-cyber">
            ← Back to Inbox
        </a>
        <a href="${pageContext.request.contextPath}/user/score" class="btn-safe">
            📊 View My Full Score
        </a>
    </div>

</div><!-- /reveal-container -->

<script>
// Animate the awareness score counter
(function () {
    const hasCreds = ${captured != null ? 'true' : 'false'};
    // Score: 0 if submitted creds (worst), 30 if only clicked, 70 if no click
    let finalScore = hasCreds ? Math.floor(Math.random() * 20) + 5 : 30;

    const el      = document.getElementById('scoreDisplay');
    const fill    = document.getElementById('awareFill');
    const desc    = document.getElementById('scoreDesc');
    let current   = 0;

    const timer = setInterval(() => {
        current += 2;
        if (current >= finalScore) {
            current = finalScore;
            clearInterval(timer);
        }
        el.textContent = current + '/100';
        fill.style.width = current + '%';
    }, 30);

    setTimeout(() => {
        if (finalScore < 30) {
            el.className = 'score-value score-low';
            desc.textContent = 'High Risk — You submitted credentials without checking the URL. Review all red flags above.';
        } else if (finalScore < 60) {
            el.className = 'score-value score-medium';
            desc.textContent = 'Moderate Risk — You clicked the link. Next time, inspect the URL before clicking anything.';
            fill.classList.add('fill-high');
        } else {
            el.className = 'score-value score-high';
            desc.textContent = 'Good Awareness — You caught some red flags, but there\'s still room to improve.';
            fill.classList.add('fill-high');
        }
    }, 1200);
})();

function togglePw() {
    const h = document.getElementById('pwHidden');
    const v = document.getElementById('pwVisible');
    if (h && v) {
        const isHidden = h.style.display !== 'none';
        h.style.display = isHidden ? 'none' : 'inline';
        v.style.display = isHidden ? 'inline' : 'none';
    }
}
</script>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
