package com.phishproof.model;

import java.time.LocalDateTime;

/**
 * Campaign — Represents a phishing awareness campaign.
 */
public class Campaign {

    public enum Status     { DRAFT, ACTIVE, PAUSED, COMPLETED }
    public enum Difficulty { EASY, MEDIUM, HARD }

    private int           id;
    private String        name;
    private String        description;
    private int           templateId;
    private String        templateName;   // joined from templates table
    private int           createdBy;
    private String        createdByName;  // joined from users table
    private Status        status;
    private Difficulty    difficulty;
    private LocalDateTime createdAt;
    private LocalDateTime launchedAt;
    private LocalDateTime endedAt;

    // ── Stats (populated by DAO) ──────────────────────────────────────────
    private int totalTargets;
    private int clicked;
    private int submitted;

    public Campaign() {}

    // ── Computed helpers ──────────────────────────────────────────────────

    public double getClickRate() {
        return totalTargets == 0 ? 0 : (clicked * 100.0 / totalTargets);
    }

    public double getSubmitRate() {
        return totalTargets == 0 ? 0 : (submitted * 100.0 / totalTargets);
    }

    public String getStatusBadgeClass() {
        switch (status) {
            case ACTIVE:    return "badge-success";
            case PAUSED:    return "badge-warning";
            case COMPLETED: return "badge-secondary";
            default:        return "badge-info";
        }
    }

    public String getDifficultyBadgeClass() {
        switch (difficulty) {
            case EASY:   return "badge-easy";
            case HARD:   return "badge-hard";
            default:     return "badge-medium";
        }
    }

    // ── Getters & Setters ─────────────────────────────────────────────────

    public int getId()                             { return id; }
    public void setId(int id)                      { this.id = id; }

    public String getName()                        { return name; }
    public void setName(String name)               { this.name = name; }

    public String getDescription()                 { return description; }
    public void setDescription(String desc)        { this.description = desc; }

    public int getTemplateId()                     { return templateId; }
    public void setTemplateId(int templateId)      { this.templateId = templateId; }

    public String getTemplateName()                { return templateName; }
    public void setTemplateName(String name)       { this.templateName = name; }

    public int getCreatedBy()                      { return createdBy; }
    public void setCreatedBy(int createdBy)        { this.createdBy = createdBy; }

    public String getCreatedByName()               { return createdByName; }
    public void setCreatedByName(String name)      { this.createdByName = name; }

    public Status getStatus()                      { return status; }
    public void setStatus(Status status)           { this.status = status; }

    public Difficulty getDifficulty()              { return difficulty; }
    public void setDifficulty(Difficulty d)        { this.difficulty = d; }

    public LocalDateTime getCreatedAt()            { return createdAt; }
    public void setCreatedAt(LocalDateTime dt)     { this.createdAt = dt; }

    public LocalDateTime getLaunchedAt()           { return launchedAt; }
    public void setLaunchedAt(LocalDateTime dt)    { this.launchedAt = dt; }

    public LocalDateTime getEndedAt()              { return endedAt; }
    public void setEndedAt(LocalDateTime dt)       { this.endedAt = dt; }

    public int getTotalTargets()                   { return totalTargets; }
    public void setTotalTargets(int n)             { this.totalTargets = n; }

    public int getClicked()                        { return clicked; }
    public void setClicked(int n)                  { this.clicked = n; }

    public int getSubmitted()                      { return submitted; }
    public void setSubmitted(int n)                { this.submitted = n; }
}
