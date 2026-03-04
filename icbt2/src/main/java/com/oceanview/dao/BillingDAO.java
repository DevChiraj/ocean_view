package com.oceanview.dao;

import com.oceanview.util.DBConnection;
import java.sql.*;
import java.util.*;

public class BillingDAO {
    public Map<String, String> getBillDetails(String resId) {
        Map<String, String> data = new HashMap<>();
        // ඩේටාබේස් එකේ reservations.room_no සහ rooms.room_id සම්බන්ධ කිරීම
        String query = "SELECT res.res_id, res.guest_name, res.check_in, res.check_out, rm.room_type, rm.price_per_night " +
                "FROM reservations res " +
                "JOIN rooms rm ON res.room_no = rm.room_id " +
                "WHERE res.res_id = ?";

        try (Connection conn = DBConnection.getInstance().getConnection();
             PreparedStatement pst = conn.prepareStatement(query)) {
            pst.setString(1, resId);
            ResultSet rs = pst.executeQuery();
            if (rs.next()) {
                data.put("res_id", rs.getString("res_id"));
                data.put("guest", rs.getString("guest_name"));
                data.put("in", rs.getString("check_in"));
                data.put("out", rs.getString("check_out"));
                data.put("type", rs.getString("room_type"));
                data.put("price", rs.getString("price_per_night"));
                return data;
            }
        } catch (SQLException e) { e.printStackTrace(); }
        return null;
    }
}