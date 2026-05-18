package com.phishproof.model;

import java.time.LocalDateTime;

/**
 * Template — A phishing page template (Google, FB, Bank, etc.)
 */
public class Template {

    public enum Category { SOCIAL, BANKING, CORPORATE, CLOUD, ECOMMERCE }

    private int       id;
    private String    name;
    private Category  category;
    private String    brand;
    private String    description;
    private String    htmlFile;
    private String    previewImg;
    private boolean   isActive;
    private LocalDateTime createdAt;

    public Template() {}

    public int getId()                          { return id; }
    public void setId(int id)                   { this.id = id; }

    public String getName()                     { return name; }
    public void setName(String name)            { this.name = name; }

    public Category getCategory()               { return category; }
    public void setCategory(Category cat)       { this.category = cat; }

    public String getBrand()                    { return brand; }
    public void setBrand(String brand)          { this.brand = brand; }

    public String getDescription()              { return description; }
    public void setDescription(String desc)     { this.description = desc; }

    public String getHtmlFile()                 { return htmlFile; }
    public void setHtmlFile(String file)        { this.htmlFile = file; }

    public String getPreviewImg()               { return previewImg; }
    public void setPreviewImg(String img)       { this.previewImg = img; }

    public boolean isActive()                   { return isActive; }
    public void setActive(boolean active)       { this.isActive = active; }

    public LocalDateTime getCreatedAt()         { return createdAt; }
    public void setCreatedAt(LocalDateTime dt)  { this.createdAt = dt; }

    public String getCategoryBadgeClass() {
        switch (category) {
            case SOCIAL:    return "cat-social";
            case BANKING:   return "cat-banking";
            case CORPORATE: return "cat-corporate";
            case CLOUD:     return "cat-cloud";
            default:        return "cat-ecommerce";
        }
    }
}
