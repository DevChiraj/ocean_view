package com.oceanview.dao;

import com.oceanview.util.DBConnection;
import java.sql.*;
import java.util.LinkedHashMap;
import java.util.Map;

public class ReportDAO {
    public Map<String, Double> getMonthlyIncome() {
        Map<String, Double> incomeData = new LinkedHashMap<>();
        // මාසය අනුව ආදායම එකතු කර ලබා ගැනීම (Grouping by Month)
        String sql = "SELECT MONTHNAME(check_in_date) as month, SUM(total_bill) as total " +
                "FROM reservations GROUP BY MONTH(check_in_date)";

        try (Connection conn = DBConnection.getInstance().getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {

            while (rs.next()) {
                incomeData.put(rs.getString("month"), rs.getDouble("total"));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return incomeData;
    }
}