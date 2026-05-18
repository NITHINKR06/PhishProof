package com.phishproof.model;

import java.time.LocalDateTime;

/**
 * AwarenessScore — Records a learner's score after completing a campaign simulation.
 */
public class AwarenessScore {

    private int           id;
    private int           userId;
    private int           campaignId;
    private int           score;           // 0–100
    private boolean       caughtPhish;     // true if user reported it as phishing
    private String        feedback;
    private String        redFlags;        // JSON array of missed red flags
    private LocalDateTime evaluatedAt;

    // Joined fields
    private String userName;
    private String campaignName;

    public AwarenessScore() {}

    // ── Score helpers ─────────────────────────────────────────────────────

    public String getScoreLabel() {
        if (score >= 80) return "Expert";
        if (score >= 60) return "Aware";
        if (score >= 40) return "Learning";
        return "Novice";
    }

    public String getScoreCssClass() {
        if (score >= 80) return "score-high";
        if (score >= 60) return "score-medium";
        return "score-low";
    }

    // ── Getters & Setters ─────────────────────────────────────────────────

    public int getId()                          { return id; }
    public void setId(int id)                   { this.id = id; }

    public int getUserId()                      { return userId; }
    public void setUserId(int userId)           { this.userId = userId; }

    public int getCampaignId()                  { return campaignId; }
    public void setCampaignId(int campaignId)   { this.campaignId = campaignId; }

    public int getScore()                       { return score; }
    public void setScore(int score)             { this.score = Math.max(0, Math.min(100, score)); }

    public boolean isCaughtPhish()              { return caughtPhish; }
    public void setCaughtPhish(boolean caught)  { this.caughtPhish = caught; }

    public String getFeedback()                 { return feedback; }
    public void setFeedback(String feedback)    { this.feedback = feedback; }

    public String getRedFlags()                 { return redFlags; }
    public void setRedFlags(String flags)       { this.redFlags = flags; }

    public LocalDateTime getEvaluatedAt()       { return evaluatedAt; }
    public void setEvaluatedAt(LocalDateTime dt){ this.evaluatedAt = dt; }

    public String getUserName()                 { return userName; }
    public void setUserName(String n)           { this.userName = n; }

    public String getCampaignName()             { return campaignName; }
    public void setCampaignName(String n)       { this.campaignName = n; }
}
