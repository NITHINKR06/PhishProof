package com.phishproof.dao;

import com.phishproof.model.AwarenessScore;
import com.phishproof.util.DBConnection;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

/**
 * AwarenessScoreDAO — Persists and retrieves awareness scores per user per campaign.
 */
public class AwarenessScoreDAO {

    public boolean insert(AwarenessScore s) {
        String sql = "INSERT INTO awareness_scores " +
                     "(user_id, campaign_id, score, caught_phish, feedback, red_flags) " +
                     "VALUES (?,?,?,?,?,?)";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, s.getUserId());
            ps.setInt(2, s.getCampaignId());
            ps.setInt(3, s.getScore());
            ps.setBoolean(4, s.isCaughtPhish());
            ps.setString(5, s.getFeedback());
            ps.setString(6, s.getRedFlags());
            return ps.executeUpdate() > 0;
        } catch (SQLException e) { e.printStackTrace(); return false; }
    }

    public List<AwarenessScore> findByUser(int userId) {
        List<AwarenessScore> list = new ArrayList<>();
        String sql = "SELECT a.*, u.name AS uname, c.name AS cname " +
                     "FROM awareness_scores a " +
                     "JOIN users u ON a.user_id = u.id " +
                     "JOIN campaigns c ON a.campaign_id = c.id " +
                     "WHERE a.user_id = ? ORDER BY a.evaluated_at DESC";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, userId);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) list.add(map(rs));
            }
        } catch (SQLException e) { e.printStackTrace(); }
        return list;
    }

    public List<AwarenessScore> findByCampaign(int campaignId) {
        List<AwarenessScore> list = new ArrayList<>();
        String sql = "SELECT a.*, u.name AS uname, c.name AS cname " +
                     "FROM awareness_scores a " +
                     "JOIN users u ON a.user_id = u.id " +
                     "JOIN campaigns c ON a.campaign_id = c.id " +
                     "WHERE a.campaign_id = ? ORDER BY a.score DESC";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, campaignId);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) list.add(map(rs));
            }
        } catch (SQLException e) { e.printStackTrace(); }
        return list;
    }

    public double getAverageScore(int campaignId) {
        String sql = "SELECT AVG(score) FROM awareness_scores WHERE campaign_id = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, campaignId);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) return rs.getDouble(1);
            }
        } catch (SQLException e) { e.printStackTrace(); }
        return 0;
    }

    private AwarenessScore map(ResultSet rs) throws SQLException {
        AwarenessScore s = new AwarenessScore();
        s.setId(rs.getInt("id"));
        s.setUserId(rs.getInt("user_id"));
        s.setCampaignId(rs.getInt("campaign_id"));
        s.setScore(rs.getInt("score"));
        s.setCaughtPhish(rs.getBoolean("caught_phish"));
        s.setFeedback(rs.getString("feedback"));
        s.setRedFlags(rs.getString("red_flags"));
        Timestamp ev = rs.getTimestamp("evaluated_at");
        if (ev != null) s.setEvaluatedAt(ev.toLocalDateTime());
        try {
            s.setUserName(rs.getString("uname"));
            s.setCampaignName(rs.getString("cname"));
        } catch (SQLException ignored) {}
        return s;
    }
}
