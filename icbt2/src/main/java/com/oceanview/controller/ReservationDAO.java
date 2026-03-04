package com.oceanview.controller;

import com.oceanview.util.DBConnection;
import java.sql.*;
import java.util.*;
import java.util.logging.Level;
import java.util.logging.Logger;

public class ReservationDAO {

    private static final Logger LOGGER = Logger.getLogger(ReservationDAO.class.getName());

    // 1. සියලුම කාමර ලබා ගැනීම
    public List<Map<String, String>> getAllRooms() {
        List<Map<String, String>> rooms = new ArrayList<>();
        String sql = "SELECT * FROM rooms";
        try (Connection conn = DBConnection.getInstance().getConnection();
             Statement st = conn.createStatement();
             ResultSet rs = st.executeQuery(sql)) {
            while (rs.next()) {
                Map<String, String> room = new HashMap<>();
                room.put("id", rs.getString("room_id"));
                room.put("type", rs.getString("room_type"));
                room.put("price", rs.getString("price_per_night"));
                room.put("status", rs.getString("status"));
                rooms.add(room);
            }
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error fetching rooms", e);
        }
        return rooms;
    }

    // 2. අලුත් Reservation එකක් ඇතුළත් කිරීම
    public boolean addReservation(String resId, String name, String nic, String address, String email,
                                  String contact, int roomNo, String checkIn, String checkOut,
                                  double svcTotal, double grandTotal) {
        String sqlRes = "INSERT INTO reservations (res_id, guest_name, nic_passport, address, email, contact, room_no, check_in, check_out, extra_services_total, grand_total) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)";
        String sqlRoom = "UPDATE rooms SET status = 'Occupied' WHERE room_id = ?";
        Connection conn = null;
        try {
            conn = DBConnection.getInstance().getConnection();
            conn.setAutoCommit(false);
            try (PreparedStatement psRes = conn.prepareStatement(sqlRes);
                 PreparedStatement psRoom = conn.prepareStatement(sqlRoom)) {
                psRes.setString(1, resId); psRes.setString(2, name); psRes.setString(3, nic);
                psRes.setString(4, address); psRes.setString(5, email); psRes.setString(6, contact);
                psRes.setInt(7, roomNo); psRes.setString(8, checkIn); psRes.setString(9, checkOut);
                psRes.setDouble(10, svcTotal); psRes.setDouble(11, grandTotal);
                psRes.executeUpdate();

                psRoom.setInt(1, roomNo);
                psRoom.executeUpdate();

                conn.commit();
                return true;
            } catch (SQLException e) {
                if (conn != null) conn.rollback();
                return false;
            }
        } catch (SQLException e) { return false; }
    }

    // 3. බිල්පත සඳහා විස්තර ලබා ගැනීම (Fix for HTTP 500)
    public Map<String, Object> getBillingDetails(String resId) {
        Map<String, Object> data = new HashMap<>();
        String sql = "SELECT r.*, rm.room_type, rm.price_per_night FROM reservations r " +
                "JOIN rooms rm ON r.room_no = rm.room_id WHERE r.res_id = ?";
        try (Connection conn = DBConnection.getInstance().getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, resId);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                data.put("res_id", rs.getString("res_id"));
                data.put("guest", rs.getString("guest_name"));
                data.put("type", rs.getString("room_type"));
                data.put("price", rs.getDouble("price_per_night"));
                data.put("check_in", rs.getString("check_in"));
                data.put("check_out", rs.getString("check_out"));
                data.put("grand_total", rs.getDouble("grand_total"));

                long diff = java.sql.Date.valueOf(rs.getString("check_out")).getTime() -
                        java.sql.Date.valueOf(rs.getString("check_in")).getTime();
                int nights = (int) (diff / (1000 * 60 * 60 * 24));
                data.put("nights", nights > 0 ? nights : 1);
            }
        } catch (SQLException e) { LOGGER.log(Level.SEVERE, "Billing detail error", e); }
        return data;
    }

    // 4. Dashboard Stats (Fix for ReportServlet Error)
    public Map<String, Object> getDashboardStats() {
        Map<String, Object> stats = new HashMap<>();
        try (Connection conn = DBConnection.getInstance().getConnection()) {
            String q1 = "SELECT COUNT(*) FROM rooms WHERE status = 'Occupied'";
            String q2 = "SELECT COUNT(*) FROM rooms WHERE status = 'Available'";
            String q3 = "SELECT COUNT(*) FROM reservations WHERE check_in = CURRENT_DATE";
            String q4 = "SELECT IFNULL(SUM(grand_total), 0) FROM reservations";

            Statement st = conn.createStatement();
            ResultSet rs1 = st.executeQuery(q1); rs1.next(); stats.put("occupied", rs1.getInt(1));
            ResultSet rs2 = st.executeQuery(q2); rs2.next(); stats.put("available", rs2.getInt(1));
            ResultSet rs3 = st.executeQuery(q3); rs3.next(); stats.put("arrivals", rs3.getInt(1));
            ResultSet rs4 = st.executeQuery(q4); rs4.next(); stats.put("revenue", rs4.getDouble(1));
        } catch (SQLException e) { LOGGER.log(Level.SEVERE, "Stats error", e); }
        return stats;
    }

    // 5. Monthly Revenue (Fix for ReportServlet Error)
    public Map<String, Double> getMonthlyRevenue() {
        Map<String, Double> revenueData = new LinkedHashMap<>();
        String sql = "SELECT DATE_FORMAT(check_in, '%b') AS month, SUM(grand_total) AS total " +
                "FROM reservations GROUP BY month ORDER BY check_in ASC LIMIT 6";
        try (Connection conn = DBConnection.getInstance().getConnection();
             Statement st = conn.createStatement();
             ResultSet rs = st.executeQuery(sql)) {
            while (rs.next()) {
                revenueData.put(rs.getString("month"), rs.getDouble("total"));
            }
        } catch (SQLException e) { LOGGER.log(Level.SEVERE, "Revenue chart error", e); }
        return revenueData;
    }

    // 6. සියලුම Reservations ලබා ගැනීම
    public List<Map<String, String>> getAllReservations() {
        List<Map<String, String>> list = new ArrayList<>();
        String sql = "SELECT r.*, rm.room_type FROM reservations r JOIN rooms rm ON r.room_no = rm.room_id";
        try (Connection conn = DBConnection.getInstance().getConnection();
             Statement st = conn.createStatement();
             ResultSet rs = st.executeQuery(sql)) {
            while (rs.next()) {
                Map<String, String> guest = new HashMap<>();
                guest.put("res_id", rs.getString("res_id"));
                guest.put("guest_name", rs.getString("guest_name"));
                guest.put("room_no", rs.getString("room_no"));
                guest.put("grand_total", String.valueOf(rs.getDouble("grand_total")));
                list.add(guest);
            }
        } catch (SQLException e) { LOGGER.log(Level.SEVERE, "Fetch list error", e); }
        return list;
    }

    // 7. Search, Checkout, සහ අනෙකුත් මෙතඩ්ස්
    public Map<String, String> searchReservation(String term) {
        Map<String, String> data = new HashMap<>();
        String sql = "SELECT r.*, rm.room_type FROM reservations r JOIN rooms rm ON r.room_no = rm.room_id WHERE r.res_id = ? OR r.guest_name LIKE ?";
        try (Connection conn = DBConnection.getInstance().getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, term); ps.setString(2, "%" + term + "%");
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                data.put("res_id", rs.getString("res_id")); data.put("guest_name", rs.getString("guest_name"));
                data.put("room_no", rs.getString("room_no")); data.put("room_type", rs.getString("room_type"));
            }
        } catch (SQLException e) { e.printStackTrace(); }
        return data;
    }

    public boolean finalizeCheckout(int roomNo) {
        String sql = "UPDATE rooms SET status = 'Available' WHERE room_id = ?";
        try (Connection conn = DBConnection.getInstance().getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, roomNo); return ps.executeUpdate() > 0;
        } catch (SQLException e) { return false; }
    }
}