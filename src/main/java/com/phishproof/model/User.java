package com.phishproof.model;

import java.time.LocalDateTime;

/**
 * User — Represents a system user (Admin or Learner).
 */
public class User {

    public enum Role { ADMIN, LEARNER }

    private int           id;
    private String        name;
    private String        email;
    private String        password;       // BCrypt hash
    private Role          role;
    private String        department;
    private String        avatarUrl;
    private boolean       isActive;
    private LocalDateTime createdAt;
    private LocalDateTime lastLogin;

    public User() {}

    public User(int id, String name, String email, Role role, String department) {
        this.id         = id;
        this.name       = name;
        this.email      = email;
        this.role       = role;
        this.department = department;
    }

    // ── Getters & Setters ──────────────────────────────────────────────────

    public int getId()                        { return id; }
    public void setId(int id)                 { this.id = id; }

    public String getName()                   { return name; }
    public void setName(String name)          { this.name = name; }

    public String getEmail()                  { return email; }
    public void setEmail(String email)        { this.email = email; }

    public String getPassword()               { return password; }
    public void setPassword(String password)  { this.password = password; }

    public Role getRole()                     { return role; }
    public void setRole(Role role)            { this.role = role; }

    public String getDepartment()             { return department; }
    public void setDepartment(String dept)    { this.department = dept; }

    public String getAvatarUrl()              { return avatarUrl; }
    public void setAvatarUrl(String url)      { this.avatarUrl = url; }

    public boolean isActive()                 { return isActive; }
    public void setActive(boolean active)     { this.isActive = active; }

    public LocalDateTime getCreatedAt()       { return createdAt; }
    public void setCreatedAt(LocalDateTime dt){ this.createdAt = dt; }

    public LocalDateTime getLastLogin()       { return lastLogin; }
    public void setLastLogin(LocalDateTime dt){ this.lastLogin = dt; }

    public boolean isAdmin() { return role == Role.ADMIN; }

    @Override
    public String toString() {
        return "User{id=" + id + ", name='" + name + "', role=" + role + "}";
    }
}
