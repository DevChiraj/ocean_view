package com.oceanview.dao;

import com.oceanview.util.DBConnection;
import java.sql.*;
import java.util.*;
import java.util.logging.Level;
import java.util.logging.Logger;

public class RoomDAO {

    // 1. සියලුම කාමර වල විස්තර ලබා ගැනීම
    public List<Map<String, String>> getAllRooms() {
        List<Map<String, String>> rooms = new ArrayList<>();
        String sql = "SELECT * FROM rooms ORDER BY room_id ASC";

        try (Connection conn = DBConnection.getInstance().getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {

            while (rs.next()) {
                Map<String, String> room = new HashMap<>();
                room.put("id", rs.getString("room_id"));
                room.put("type", rs.getString("room_type"));
                room.put("price", rs.getString("price_per_night"));
                room.put("status", rs.getString("status"));
                rooms.add(room);
            }
        } catch (SQLException e) {
            Logger.getLogger(RoomDAO.class.getName()).log(Level.SEVERE, null, e);
        }
        return rooms;
    }

    // 2. කාමරයක තත්ත්වය (Available/Occupied) වෙනස් කිරීම
    public boolean updateRoomStatus(int roomId, String status) {
        String sql = "UPDATE rooms SET status = ? WHERE room_id = ?";
        try (Connection conn = DBConnection.getInstance().getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, status);
            ps.setInt(2, roomId);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            Logger.getLogger(RoomDAO.class.getName()).log(Level.SEVERE, null, e);
            return false;
        }
    }
}