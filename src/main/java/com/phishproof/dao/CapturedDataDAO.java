package com.phishproof.dao;

import com.phishproof.model.CapturedData;
import com.phishproof.util.DBConnection;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

/**
 * CapturedDataDAO — Saves and retrieves phishing credential captures.
 */
public class CapturedDataDAO {

    public boolean insert(CapturedData data) {
        String sql = "INSERT INTO captured_data " +
                     "(link_id, fake_username, fake_password, ip_address, user_agent, screen_size, referrer, time_on_page) " +
                     "VALUES (?,?,?,?,?,?,?,?)";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, data.getLinkId());
            ps.setString(2, data.getFakeUsername());
            ps.setString(3, data.getFakePassword());
            ps.setString(4, data.getIpAddress());
            ps.setString(5, data.getUserAgent());
            ps.setString(6, data.getScreenSize());
            ps.setString(7, data.getReferrer());
            ps.setInt(8, data.getTimeOnPage());
            return ps.executeUpdate() > 0;
        } catch (SQLException e) { e.printStackTrace(); return false; }
    }

    public CapturedData findByLinkId(int linkId) {
        String sql = "SELECT cd.*, u.name AS uname, u.email AS uemail, c.name AS cname " +
                     "FROM captured_data cd " +
                     "JOIN phish_links pl ON cd.link_id = pl.id " +
                     "JOIN users u ON pl.user_id = u.id " +
                     "JOIN campaigns c ON pl.campaign_id = c.id " +
                     "WHERE cd.link_id = ? ORDER BY cd.id DESC LIMIT 1";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, linkId);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) return map(rs);
            }
        } catch (SQLException e) { e.printStackTrace(); }
        return null;
    }

    public List<CapturedData> findByCampaign(int campaignId) {
        List<CapturedData> list = new ArrayList<>();
        String sql = "SELECT cd.*, u.name AS uname, u.email AS uemail, c.name AS cname " +
                     "FROM captured_data cd " +
                     "JOIN phish_links pl ON cd.link_id = pl.id " +
                     "JOIN users u ON pl.user_id = u.id " +
                     "JOIN campaigns c ON pl.campaign_id = c.id " +
                     "WHERE pl.campaign_id = ? ORDER BY cd.captured_at DESC";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, campaignId);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) list.add(map(rs));
            }
        } catch (SQLException e) { e.printStackTrace(); }
        return list;
    }

    public int countTotal() {
        String sql = "SELECT COUNT(*) FROM captured_data";
        try (Connection conn = DBConnection.getConnection();
             Statement st = conn.createStatement();
             ResultSet rs = st.executeQuery(sql)) {
            if (rs.next()) return rs.getInt(1);
        } catch (SQLException e) { e.printStackTrace(); }
        return 0;
    }

    private CapturedData map(ResultSet rs) throws SQLException {
        CapturedData d = new CapturedData();
        d.setId(rs.getInt("id"));
        d.setLinkId(rs.getInt("link_id"));
        d.setFakeUsername(rs.getString("fake_username"));
        d.setFakePassword(rs.getString("fake_password"));
        d.setIpAddress(rs.getString("ip_address"));
        d.setUserAgent(rs.getString("user_agent"));
        d.setScreenSize(rs.getString("screen_size"));
        d.setReferrer(rs.getString("referrer"));
        d.setTimeOnPage(rs.getInt("time_on_page"));
        Timestamp cap = rs.getTimestamp("captured_at");
        if (cap != null) d.setCapturedAt(cap.toLocalDateTime());
        try {
            d.setUserName(rs.getString("uname"));
            d.setUserEmail(rs.getString("uemail"));
            d.setCampaignName(rs.getString("cname"));
        } catch (SQLException ignored) {}
        return d;
    }
}
