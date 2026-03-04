package com.oceanview.dao;

import com.oceanview.util.DBConnection;
import java.sql.*;
import java.util.*;
import java.util.logging.Level;
import java.util.logging.Logger;

public class UserDAO {

    private static final Logger LOGGER = Logger.getLogger(UserDAO.class.getName());

    // 1. පරිශීලකයා පද්ධතියට ඇතුළු වීම පරීක්ෂා කිරීම (Login)
    public String checkUser(String username, String password, String role) {
        String sql = "SELECT full_name FROM users WHERE username = ? AND password = ? AND role = ?";
        try (Connection conn = DBConnection.getInstance().getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, username);
            ps.setString(2, password);
            ps.setString(3, role);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                return rs.getString("full_name");
            }
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Login error for user: " + username, e);
        }
        return null;
    }

    // 2. අලුත් පරිශීලකයෙකු ලියාපදිංචි කිරීම
    public boolean registerUser(String name, String user, String pass, String role) {
        String sql = "INSERT INTO users (full_name, username, password, role) VALUES (?, ?, ?, ?)";
        try (Connection conn = DBConnection.getInstance().getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, name);
            ps.setString(2, user);
            ps.setString(3, pass);
            ps.setString(4, role);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Registration error for user: " + user, e);
            return false;
        }
    }

    // 3. පද්ධතියේ සිටින සියලුම පරිශීලකයන් ලබා ගැනීම
    public List<Map<String, String>> getAllUsers() {
        List<Map<String, String>> users = new ArrayList<>();
        // ඩේටාබේස් එකේ column නම id ලෙස පරීක්ෂා කරන්න
        String sql = "SELECT full_name, username, role FROM users ORDER BY id DESC";
        try (Connection conn = DBConnection.getInstance().getConnection();
             Statement st = conn.createStatement();
             ResultSet rs = st.executeQuery(sql)) {
            while (rs.next()) {
                Map<String, String> u = new HashMap<>();
                u.put("fullName", rs.getString("full_name"));
                u.put("username", rs.getString("username"));
                u.put("role", rs.getString("role"));
                users.add(u);
            }
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error fetching user list", e);
        }
        return users;
    }
    // UserDAO.java ඇතුළත
    public boolean updateUserDetails(String fullName, String email, String phone, String username) {
        String sql = "UPDATE users SET full_name = ?, email = ?, contact = ? WHERE username = ?";
        try (Connection conn = DBConnection.getInstance().getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setString(1, fullName);
            ps.setString(2, email);
            ps.setString(3, phone);
            ps.setString(4, username);

            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            java.util.logging.Logger.getLogger(this.getClass().getName()).log(java.util.logging.Level.SEVERE, null, e);
            return false;
        }
    }
}