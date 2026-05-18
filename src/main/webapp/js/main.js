/* ============================================================
   PhishProof — main.js
   Shared JavaScript utilities for the admin panel
   ============================================================ */

'use strict';

/* ── Toast notifications ─────────────────────────────────── */
const Toast = {
    container: null,

    init() {
        if (!this.container) {
            this.container = document.createElement('div');
            this.container.className = 'toast-container';
            document.body.appendChild(this.container);
        }
    },

    show(message, type = 'info', duration = 3500) {
        this.init();
        const toast = document.createElement('div');
        toast.className = `toast-cyber toast-${type}`;
        toast.textContent = message;
        this.container.appendChild(toast);
        setTimeout(() => {
            toast.style.opacity = '0';
            toast.style.transition = 'opacity 0.3s';
            setTimeout(() => toast.remove(), 300);
        }, duration);
    },

    success(msg) { this.show('✔ ' + msg, 'success'); },
    error(msg)   { this.show('⚠ ' + msg, 'error'); },
    info(msg)    { this.show('ℹ ' + msg, 'info'); }
};

/* ── Copy to clipboard with toast feedback ───────────────── */
function copyUrl(url) {
    if (navigator.clipboard && navigator.clipboard.writeText) {
        navigator.clipboard.writeText(url).then(() => {
            Toast.success('Phish URL copied to clipboard!');
        }).catch(() => fallbackCopy(url));
    } else {
        fallbackCopy(url);
    }
}

function fallbackCopy(text) {
    const ta = document.createElement('textarea');
    ta.value = text;
    ta.style.position = 'fixed';
    ta.style.opacity  = '0';
    document.body.appendChild(ta);
    ta.select();
    try {
        document.execCommand('copy');
        Toast.success('Phish URL copied!');
    } catch (e) {
        Toast.error('Copy failed — use Ctrl+C manually');
    }
    document.body.removeChild(ta);
}

/* ── Confirm delete ──────────────────────────────────────── */
function confirmDelete(name) {
    return confirm('Delete "' + name + '"?\n\nThis action cannot be undone.');
}

/* ── Active nav highlighting ─────────────────────────────── */
document.addEventListener('DOMContentLoaded', function () {
    const current = window.location.pathname;
    document.querySelectorAll('.sidebar-nav .nav-link').forEach(link => {
        if (link.getAttribute('href') && current.includes(link.getAttribute('href').split('/').pop())) {
            link.classList.add('active');
        }
    });
});

/* ── Rate bar animation on page load ─────────────────────── */
document.addEventListener('DOMContentLoaded', function () {
    document.querySelectorAll('.rate-fill').forEach(bar => {
        const target = bar.style.width;
        bar.style.width = '0';
        setTimeout(() => { bar.style.width = target; }, 150);
    });
});

/* ── Auto-dismiss alerts ─────────────────────────────────── */
document.addEventListener('DOMContentLoaded', function () {
    document.querySelectorAll('.alert-success').forEach(el => {
        setTimeout(() => {
            el.style.transition = 'opacity 0.5s';
            el.style.opacity    = '0';
            setTimeout(() => el.remove(), 500);
        }, 4000);
    });
});

/* ── Template card radio selection highlight ─────────────── */
document.addEventListener('DOMContentLoaded', function () {
    document.querySelectorAll('.template-card input[type=radio]').forEach(radio => {
        radio.addEventListener('change', function () {
            document.querySelectorAll('.template-card').forEach(c => c.classList.remove('selected'));
            this.closest('.template-card').classList.add('selected');
        });
    });
});

/* ── Campaign status polling (admin dashboard) ───────────── */
function startStatusPolling(campaignId, intervalMs = 15000) {
    setInterval(() => {
        fetch(`/PhishProof/admin/reports/data?id=${campaignId}`)
            .then(r => r.json())
            .then(data => {
                const clickEl = document.querySelector(`[data-campaign-clicks="${campaignId}"]`);
                const subEl   = document.querySelector(`[data-campaign-subs="${campaignId}"]`);
                if (clickEl) clickEl.textContent = data.clicked;
                if (subEl)   subEl.textContent   = data.submitted;
            })
            .catch(() => {}); // silent fail
    }, intervalMs);
}
