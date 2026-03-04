package com.oceanview.dao;

import com.oceanview.util.DBConnection;
import java.sql.*;
import java.util.HashMap;
import java.util.Map;

public class DashboardDAO {
    public Map<String, Object> getStats() {
        Map<String, Object> data = new HashMap<>();
        try (Connection conn = DBConnection.getInstance().getConnection()) {
            // Total Revenue
            ResultSet rs1 = conn.createStatement().executeQuery("SELECT SUM(total_bill) FROM reservations");
            if(rs1.next()) data.put("revenue", rs1.getDouble(1));

            // Active Guests
            ResultSet rs2 = conn.createStatement().executeQuery("SELECT COUNT(*) FROM reservations WHERE check_out >= CURDATE()");
            if(rs2.next()) data.put("active", rs2.getInt(1));

        } catch (SQLException e) { e.printStackTrace(); }
        return data;
    }
}