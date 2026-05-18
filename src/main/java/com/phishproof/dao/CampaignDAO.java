package com.phishproof.dao;

import com.phishproof.model.Campaign;
import com.phishproof.util.DBConnection;

import java.sql.*;
import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.List;

/**
 * CampaignDAO — CRUD and stats queries for the campaigns table.
 */
public class CampaignDAO {

    public List<Campaign> findAll() {
        List<Campaign> list = new ArrayList<>();
        String sql = "SELECT c.*, t.name AS tname, u.name AS uname, " +
                     "COUNT(DISTINCT pl.id) AS total, " +
                     "SUM(pl.clicked) AS clicks, SUM(pl.submitted) AS subs " +
                     "FROM campaigns c " +
                     "JOIN templates t ON c.template_id = t.id " +
                     "JOIN users u ON c.created_by = u.id " +
                     "LEFT JOIN phish_links pl ON pl.campaign_id = c.id " +
                     "GROUP BY c.id ORDER BY c.created_at DESC";
        try (Connection conn = DBConnection.getConnection();
             Statement st = conn.createStatement();
             ResultSet rs = st.executeQuery(sql)) {
            while (rs.next()) list.add(map(rs, true));
        } catch (SQLException e) { e.printStackTrace(); }
        return list;
    }

    public Campaign findById(int id) {
        String sql = "SELECT c.*, t.name AS tname, u.name AS uname, " +
                     "COUNT(DISTINCT pl.id) AS total, " +
                     "SUM(pl.clicked) AS clicks, SUM(pl.submitted) AS subs " +
                     "FROM campaigns c " +
                     "JOIN templates t ON c.template_id = t.id " +
                     "JOIN users u ON c.created_by = u.id " +
                     "LEFT JOIN phish_links pl ON pl.campaign_id = c.id " +
                     "WHERE c.id = ? GROUP BY c.id";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, id);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) return map(rs, true);
            }
        } catch (SQLException e) { e.printStackTrace(); }
        return null;
    }

    public int insert(Campaign c) {
        String sql = "INSERT INTO campaigns (name, description, template_id, created_by, status, difficulty) " +
                     "VALUES (?,?,?,?,?,?)";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {
            ps.setString(1, c.getName());
            ps.setString(2, c.getDescription());
            ps.setInt(3, c.getTemplateId());
            ps.setInt(4, c.getCreatedBy());
            ps.setString(5, c.getStatus().name());
            ps.setString(6, c.getDifficulty().name());
            ps.executeUpdate();
            try (ResultSet keys = ps.getGeneratedKeys()) {
                if (keys.next()) return keys.getInt(1);
            }
        } catch (SQLException e) { e.printStackTrace(); }
        return -1;
    }

    public boolean updateStatus(int id, Campaign.Status status) {
        String sql = "UPDATE campaigns SET status = ?, " +
                     (status == Campaign.Status.ACTIVE ? "launched_at = NOW(), " : "") +
                     (status == Campaign.Status.COMPLETED ? "ended_at = NOW(), " : "") +
                     "id = id WHERE id = ?";
        // Clean approach for status update:
        String cleanSql = "UPDATE campaigns SET status = ? WHERE id = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(cleanSql)) {
            ps.setString(1, status.name());
            ps.setInt(2, id);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) { e.printStackTrace(); return false; }
    }

    public boolean delete(int id) {
        String sql = "DELETE FROM campaigns WHERE id = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, id);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) { e.printStackTrace(); return false; }
    }

    public int countActive() {
        String sql = "SELECT COUNT(*) FROM campaigns WHERE status = 'ACTIVE'";
        try (Connection conn = DBConnection.getConnection();
             Statement st = conn.createStatement();
             ResultSet rs = st.executeQuery(sql)) {
            if (rs.next()) return rs.getInt(1);
        } catch (SQLException e) { e.printStackTrace(); }
        return 0;
    }

    private Campaign map(ResultSet rs, boolean withStats) throws SQLException {
        Campaign c = new Campaign();
        c.setId(rs.getInt("id"));
        c.setName(rs.getString("name"));
        c.setDescription(rs.getString("description"));
        c.setTemplateId(rs.getInt("template_id"));
        c.setCreatedBy(rs.getInt("created_by"));
        c.setStatus(Campaign.Status.valueOf(rs.getString("status")));
        c.setDifficulty(Campaign.Difficulty.valueOf(rs.getString("difficulty")));
        Timestamp created = rs.getTimestamp("created_at");
        if (created != null) c.setCreatedAt(created.toLocalDateTime());
        try {
            c.setTemplateName(rs.getString("tname"));
            c.setCreatedByName(rs.getString("uname"));
        } catch (SQLException ignored) {}
        if (withStats) {
            try {
                c.setTotalTargets(rs.getInt("total"));
                c.setClicked(rs.getInt("clicks"));
                c.setSubmitted(rs.getInt("subs"));
            } catch (SQLException ignored) {}
        }
        return c;
    }
}
