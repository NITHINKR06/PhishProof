package com.phishproof.model;

import java.time.LocalDateTime;

/**
 * PhishLink — A unique tracked phishing URL token assigned to one user in one campaign.
 */
public class PhishLink {

    private int           id;
    private String        token;
    private int           campaignId;
    private int           userId;
    private String        userName;       // joined
    private String        userEmail;      // joined
    private boolean       clicked;
    private boolean       submitted;
    private LocalDateTime clickedAt;
    private LocalDateTime submittedAt;
    private LocalDateTime expiresAt;

    public PhishLink() {}

    // ── Helpers ──────────────────────────────────────────────────────────

    public boolean isExpired() {
        return expiresAt != null && LocalDateTime.now().isAfter(expiresAt);
    }

    public String buildUrl(String baseUrl) {
        return baseUrl + "/phish?t=" + token;
    }

    // ── Getters & Setters ─────────────────────────────────────────────────

    public int getId()                          { return id; }
    public void setId(int id)                   { this.id = id; }

    public String getToken()                    { return token; }
    public void setToken(String token)          { this.token = token; }

    public int getCampaignId()                  { return campaignId; }
    public void setCampaignId(int id)           { this.campaignId = id; }

    public int getUserId()                      { return userId; }
    public void setUserId(int id)               { this.userId = id; }

    public String getUserName()                 { return userName; }
    public void setUserName(String name)        { this.userName = name; }

    public String getUserEmail()                { return userEmail; }
    public void setUserEmail(String email)      { this.userEmail = email; }

    public boolean isClicked()                  { return clicked; }
    public void setClicked(boolean clicked)     { this.clicked = clicked; }

    public boolean isSubmitted()                { return submitted; }
    public void setSubmitted(boolean submitted) { this.submitted = submitted; }

    public LocalDateTime getClickedAt()         { return clickedAt; }
    public void setClickedAt(LocalDateTime dt)  { this.clickedAt = dt; }

    public LocalDateTime getSubmittedAt()       { return submittedAt; }
    public void setSubmittedAt(LocalDateTime dt){ this.submittedAt = dt; }

    public LocalDateTime getExpiresAt()         { return expiresAt; }
    public void setExpiresAt(LocalDateTime dt)  { this.expiresAt = dt; }
}
