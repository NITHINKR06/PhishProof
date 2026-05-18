package com.phishproof.model;

import java.time.LocalDateTime;

/**
 * CapturedData — Credentials entered on a phishing page, stored for awareness feedback.
 */
public class CapturedData {

    private int           id;
    private int           linkId;
    private String        fakeUsername;
    private String        fakePassword;
    private String        ipAddress;
    private String        userAgent;
    private String        screenSize;
    private String        referrer;
    private int           timeOnPage;     // seconds
    private LocalDateTime capturedAt;

    // ── Joined fields ──────────────────────────────────────────────────────
    private String        userName;
    private String        userEmail;
    private String        campaignName;

    public CapturedData() {}

    // ── Getters & Setters ─────────────────────────────────────────────────

    public int getId()                          { return id; }
    public void setId(int id)                   { this.id = id; }

    public int getLinkId()                      { return linkId; }
    public void setLinkId(int linkId)           { this.linkId = linkId; }

    public String getFakeUsername()             { return fakeUsername; }
    public void setFakeUsername(String u)       { this.fakeUsername = u; }

    public String getFakePassword()             { return fakePassword; }
    public void setFakePassword(String p)       { this.fakePassword = p; }

    public String getIpAddress()                { return ipAddress; }
    public void setIpAddress(String ip)         { this.ipAddress = ip; }

    public String getUserAgent()                { return userAgent; }
    public void setUserAgent(String ua)         { this.userAgent = ua; }

    public String getScreenSize()               { return screenSize; }
    public void setScreenSize(String size)      { this.screenSize = size; }

    public String getReferrer()                 { return referrer; }
    public void setReferrer(String ref)         { this.referrer = ref; }

    public int getTimeOnPage()                  { return timeOnPage; }
    public void setTimeOnPage(int t)            { this.timeOnPage = t; }

    public LocalDateTime getCapturedAt()        { return capturedAt; }
    public void setCapturedAt(LocalDateTime dt) { this.capturedAt = dt; }

    public String getUserName()                 { return userName; }
    public void setUserName(String n)           { this.userName = n; }

    public String getUserEmail()                { return userEmail; }
    public void setUserEmail(String e)          { this.userEmail = e; }

    public String getCampaignName()             { return campaignName; }
    public void setCampaignName(String n)       { this.campaignName = n; }

    /** Masks password for display: shows length but not content */
    public String getMaskedPassword() {
        if (fakePassword == null || fakePassword.isEmpty()) return "—";
        return "•".repeat(Math.min(fakePassword.length(), 12));
    }
}
