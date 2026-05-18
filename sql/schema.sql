-- ============================================================
-- PhishProof Database Schema
-- Run this script in MySQL to set up the database
-- ============================================================

CREATE DATABASE IF NOT EXISTS phishproof_db;
USE phishproof_db;

-- ============================================================
-- TABLE: users
-- ============================================================
CREATE TABLE IF NOT EXISTS users (
    id          INT AUTO_INCREMENT PRIMARY KEY,
    name        VARCHAR(100) NOT NULL,
    email       VARCHAR(150) NOT NULL UNIQUE,
    password    VARCHAR(255) NOT NULL,          -- BCrypt hashed
    role        ENUM('ADMIN','LEARNER') NOT NULL DEFAULT 'LEARNER',
    department  VARCHAR(100),
    avatar_url  VARCHAR(255),
    is_active   TINYINT(1) DEFAULT 1,
    created_at  DATETIME DEFAULT CURRENT_TIMESTAMP,
    last_login  DATETIME
);

-- ============================================================
-- TABLE: templates
-- ============================================================
CREATE TABLE IF NOT EXISTS templates (
    id          INT AUTO_INCREMENT PRIMARY KEY,
    name        VARCHAR(100) NOT NULL,
    category    ENUM('SOCIAL','BANKING','CORPORATE','CLOUD','ECOMMERCE') NOT NULL,
    brand       VARCHAR(100),
    description TEXT,
    html_file   VARCHAR(255) NOT NULL,          -- path to JSP template
    preview_img VARCHAR(255),
    is_active   TINYINT(1) DEFAULT 1,
    created_at  DATETIME DEFAULT CURRENT_TIMESTAMP
);

-- ============================================================
-- TABLE: campaigns
-- ============================================================
CREATE TABLE IF NOT EXISTS campaigns (
    id           INT AUTO_INCREMENT PRIMARY KEY,
    name         VARCHAR(200) NOT NULL,
    description  TEXT,
    template_id  INT NOT NULL,
    created_by   INT NOT NULL,
    status       ENUM('DRAFT','ACTIVE','PAUSED','COMPLETED') DEFAULT 'DRAFT',
    difficulty   ENUM('EASY','MEDIUM','HARD') DEFAULT 'MEDIUM',
    created_at   DATETIME DEFAULT CURRENT_TIMESTAMP,
    launched_at  DATETIME,
    ended_at     DATETIME,
    FOREIGN KEY (template_id) REFERENCES templates(id),
    FOREIGN KEY (created_by)  REFERENCES users(id)
);

-- ============================================================
-- TABLE: phish_links
-- ============================================================
CREATE TABLE IF NOT EXISTS phish_links (
    id           INT AUTO_INCREMENT PRIMARY KEY,
    token        VARCHAR(64) NOT NULL UNIQUE,   -- unique per user per campaign
    campaign_id  INT NOT NULL,
    user_id      INT NOT NULL,
    clicked      TINYINT(1) DEFAULT 0,
    submitted    TINYINT(1) DEFAULT 0,
    clicked_at   DATETIME,
    submitted_at DATETIME,
    expires_at   DATETIME,
    FOREIGN KEY (campaign_id) REFERENCES campaigns(id),
    FOREIGN KEY (user_id)     REFERENCES users(id)
);

-- ============================================================
-- TABLE: captured_data
-- ============================================================
CREATE TABLE IF NOT EXISTS captured_data (
    id             INT AUTO_INCREMENT PRIMARY KEY,
    link_id        INT NOT NULL,
    fake_username  VARCHAR(255),
    fake_password  VARCHAR(255),
    ip_address     VARCHAR(45),
    user_agent     TEXT,
    screen_size    VARCHAR(50),
    referrer       VARCHAR(500),
    time_on_page   INT,                          -- seconds spent before submitting
    captured_at    DATETIME DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (link_id) REFERENCES phish_links(id)
);

-- ============================================================
-- TABLE: awareness_scores
-- ============================================================
CREATE TABLE IF NOT EXISTS awareness_scores (
    id           INT AUTO_INCREMENT PRIMARY KEY,
    user_id      INT NOT NULL,
    campaign_id  INT NOT NULL,
    score        INT DEFAULT 0,                  -- 0-100
    caught_phish TINYINT(1) DEFAULT 0,           -- 1 if user identified it as phish
    feedback     TEXT,
    red_flags    JSON,                           -- array of missed red flags
    evaluated_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (user_id)     REFERENCES users(id),
    FOREIGN KEY (campaign_id) REFERENCES campaigns(id)
);

-- ============================================================
-- TABLE: inbox_messages  (simulated email inbox)
-- ============================================================
CREATE TABLE IF NOT EXISTS inbox_messages (
    id           INT AUTO_INCREMENT PRIMARY KEY,
    recipient_id INT NOT NULL,
    campaign_id  INT NOT NULL,
    phish_link_id INT NOT NULL,
    subject      VARCHAR(300),
    sender_name  VARCHAR(150),
    sender_email VARCHAR(150),
    body_html    TEXT,
    is_read      TINYINT(1) DEFAULT 0,
    sent_at      DATETIME DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (recipient_id)  REFERENCES users(id),
    FOREIGN KEY (campaign_id)   REFERENCES campaigns(id),
    FOREIGN KEY (phish_link_id) REFERENCES phish_links(id)
);

-- ============================================================
-- DEFAULT DATA: Admin user (password = Admin@123)
-- ============================================================
INSERT INTO users (name, email, password, role, department) VALUES
('System Admin', 'admin@phishproof.local',
 '$2a$12$8K1p/a0dR1xqM8K3eXtZ5.5aJmKO4Xv9y6dR2P1sN7mL3qE0wH4Wy',
 'ADMIN', 'IT Security');

-- ============================================================
-- DEFAULT DATA: Sample learner users (password = Test@1234)
-- ============================================================
INSERT INTO users (name, email, password, role, department) VALUES
('Alice Johnson',  'alice@phishproof.local',  '$2a$12$LQv3c1yqBWVHxkd0LQ/H8.IrQVb2CUpPvGFbXkBRkLNkbBqJzR5Sm', 'LEARNER', 'Finance'),
('Bob Martinez',   'bob@phishproof.local',    '$2a$12$LQv3c1yqBWVHxkd0LQ/H8.IrQVb2CUpPvGFbXkBRkLNkbBqJzR5Sm', 'LEARNER', 'HR'),
('Carol White',    'carol@phishproof.local',  '$2a$12$LQv3c1yqBWVHxkd0LQ/H8.IrQVb2CUpPvGFbXkBRkLNkbBqJzR5Sm', 'LEARNER', 'Engineering'),
('David Lee',      'david@phishproof.local',  '$2a$12$LQv3c1yqBWVHxkd0LQ/H8.IrQVb2CUpPvGFbXkBRkLNkbBqJzR5Sm', 'LEARNER', 'Marketing');

-- ============================================================
-- DEFAULT DATA: Phishing templates
-- ============================================================
INSERT INTO templates (name, category, brand, description, html_file, preview_img) VALUES
('Google Sign-In Clone',     'SOCIAL',    'Google',    'Fake Google login page with branding',           'google-login.jsp',    'google-preview.png'),
('Facebook Login Clone',     'SOCIAL',    'Facebook',  'Fake Facebook login with blue theme',            'facebook-login.jsp',  'facebook-preview.png'),
('Online Banking Portal',    'BANKING',   'Generic',   'Generic bank login page',                        'bank-login.jsp',      'bank-preview.png'),
('Microsoft 365 Login',      'CLOUD',     'Microsoft', 'Fake Microsoft 365 / Outlook login',             'microsoft-login.jsp', 'microsoft-preview.png'),
('Corporate VPN Portal',     'CORPORATE', 'Internal',  'Fake corporate IT / VPN login page',             'corporate-login.jsp', 'corporate-preview.png');
