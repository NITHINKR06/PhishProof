package com.phishproof.dao;

import com.phishproof.model.Template;
import com.phishproof.util.DBConnection;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

/**
 * TemplateDAO — Retrieves phishing page templates from the database.
 */
public class TemplateDAO {

    public List<Template> findAll() {
        List<Template> list = new ArrayList<>();
        String sql = "SELECT * FROM templates WHERE is_active = 1 ORDER BY category, name";
        try (Connection conn = DBConnection.getConnection();
             Statement st = conn.createStatement();
             ResultSet rs = st.executeQuery(sql)) {
            while (rs.next()) list.add(map(rs));
        } catch (SQLException e) { e.printStackTrace(); }
        return list;
    }

    public Template findById(int id) {
        String sql = "SELECT * FROM templates WHERE id = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, id);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) return map(rs);
            }
        } catch (SQLException e) { e.printStackTrace(); }
        return null;
    }

    private Template map(ResultSet rs) throws SQLException {
        Template t = new Template();
        t.setId(rs.getInt("id"));
        t.setName(rs.getString("name"));
        t.setCategory(Template.Category.valueOf(rs.getString("category")));
        t.setBrand(rs.getString("brand"));
        t.setDescription(rs.getString("description"));
        t.setHtmlFile(rs.getString("html_file"));
        t.setPreviewImg(rs.getString("preview_img"));
        t.setActive(rs.getBoolean("is_active"));
        Timestamp created = rs.getTimestamp("created_at");
        if (created != null) t.setCreatedAt(created.toLocalDateTime());
        return t;
    }
}
