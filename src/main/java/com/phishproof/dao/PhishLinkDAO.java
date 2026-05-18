package com.phishproof.dao;

import com.phishproof.model.PhishLink;
import com.phishproof.util.DBConnection;

import java.sql.*;
import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.List;

/**
 * PhishLinkDAO — Manages phish_links: creation, click/submit tracking, lookups.
 */
public class PhishLinkDAO {

    public int insert(PhishLink link) {
        String sql = "INSERT INTO phish_links (token, campaign_id, user_id, expires_at) VALUES (?,?,?,?)";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {
            ps.setString(1, link.getToken());
            ps.setInt(2, link.getCampaignId());
            ps.setInt(3, link.getUserId());
            if (link.getExpiresAt() != null) {
                ps.setTimestamp(4, Timestamp.valueOf(link.getExpiresAt()));
            } else {
                ps.setNull(4, Types.TIMESTAMP);
            }
            ps.executeUpdate();
            try (ResultSet keys = ps.getGeneratedKeys()) {
                if (keys.next()) return keys.getInt(1);
            }
        } catch (SQLException e) { e.printStackTrace(); }
        return -1;
    }

    public PhishLink findByToken(String token) {
        String sql = "SELECT pl.*, u.name AS uname, u.email AS uemail " +
                     "FROM phish_links pl JOIN users u ON pl.user_id = u.id " +
                     "WHERE pl.token = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, token);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) return map(rs);
            }
        } catch (SQLException e) { e.printStackTrace(); }
        return null;
    }

    public List<PhishLink> findByCampaign(int campaignId) {
        List<PhishLink> list = new ArrayList<>();
        String sql = "SELECT pl.*, u.name AS uname, u.email AS uemail " +
                     "FROM phish_links pl JOIN users u ON pl.user_id = u.id " +
                     "WHERE pl.campaign_id = ? ORDER BY pl.id";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, campaignId);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) list.add(map(rs));
            }
        } catch (SQLException e) { e.printStackTrace(); }
        return list;
    }

    public List<PhishLink> findByUser(int userId) {
        List<PhishLink> list = new ArrayList<>();
        String sql = "SELECT pl.*, u.name AS uname, u.email AS uemail " +
                     "FROM phish_links pl JOIN users u ON pl.user_id = u.id " +
                     "WHERE pl.user_id = ? ORDER BY pl.id DESC";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, userId);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) list.add(map(rs));
            }
        } catch (SQLException e) { e.printStackTrace(); }
        return list;
    }

    public boolean markClicked(String token) {
        String sql = "UPDATE phish_links SET clicked = 1, clicked_at = ? WHERE token = ? AND clicked = 0";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setTimestamp(1, Timestamp.valueOf(LocalDateTime.now()));
            ps.setString(2, token);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) { e.printStackTrace(); return false; }
    }

    public boolean markSubmitted(String token) {
        String sql = "UPDATE phish_links SET submitted = 1, submitted_at = ? WHERE token = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setTimestamp(1, Timestamp.valueOf(LocalDateTime.now()));
            ps.setString(2, token);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) { e.printStackTrace(); return false; }
    }

    public boolean existsForUserCampaign(int userId, int campaignId) {
        String sql = "SELECT COUNT(*) FROM phish_links WHERE user_id = ? AND campaign_id = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, userId);
            ps.setInt(2, campaignId);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) return rs.getInt(1) > 0;
            }
        } catch (SQLException e) { e.printStackTrace(); }
        return false;
    }

    public int countTotalClicks() {
        String sql = "SELECT COUNT(*) FROM phish_links WHERE clicked = 1";
        try (Connection conn = DBConnection.getConnection();
             Statement st = conn.createStatement();
             ResultSet rs = st.executeQuery(sql)) {
            if (rs.next()) return rs.getInt(1);
        } catch (SQLException e) { e.printStackTrace(); }
        return 0;
    }

    private PhishLink map(ResultSet rs) throws SQLException {
        PhishLink link = new PhishLink();
        link.setId(rs.getInt("id"));
        link.setToken(rs.getString("token"));
        link.setCampaignId(rs.getInt("campaign_id"));
        link.setUserId(rs.getInt("user_id"));
        link.setClicked(rs.getBoolean("clicked"));
        link.setSubmitted(rs.getBoolean("submitted"));
        Timestamp ca = rs.getTimestamp("clicked_at");
        if (ca != null) link.setClickedAt(ca.toLocalDateTime());
        Timestamp sa = rs.getTimestamp("submitted_at");
        if (sa != null) link.setSubmittedAt(sa.toLocalDateTime());
        Timestamp ea = rs.getTimestamp("expires_at");
        if (ea != null) link.setExpiresAt(ea.toLocalDateTime());
        try {
            link.setUserName(rs.getString("uname"));
            link.setUserEmail(rs.getString("uemail"));
        } catch (SQLException ignored) {}
        return link;
    }
}
