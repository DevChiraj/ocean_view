package com.oceanview.util;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;
import java.util.logging.Level;
import java.util.logging.Logger;

public class DBConnection {
    // 1. එකම Instance එක සහ Connection එක static ලෙස තබා ගැනීම
    private static DBConnection instance;
    private static Connection connection;

    // ඩේටාබේස් විස්තර (XAMPP/MySQL සඳහා)
    private static final String URL = "jdbc:mysql://localhost:3306/ocean_view?useSSL=false&allowPublicKeyRetrieval=true";
    private static final String USER = "root";
    private static final String PASS = "";

    // 2. Private Constructor: පිටතින් අලුත් Object සෑදීම වැළැක්වීමට
    private DBConnection() throws SQLException {
        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
            connection = DriverManager.getConnection(URL, USER, PASS);
        } catch (ClassNotFoundException e) {
            Logger.getLogger(DBConnection.class.getName()).log(Level.SEVERE, "Driver Not Found", e);
            throw new SQLException(e);
        }
    }

    // 3. Singleton Instance එක ලබා දෙන මෙතඩ් එක
    public static DBConnection getInstance() throws SQLException {
        if (instance == null) {
            instance = new DBConnection();
        } else if (connection == null || connection.isClosed()) {
            instance = new DBConnection();
        }
        return instance;
    }

    // 4. දැනට පවතින Connection එක ලබා දෙන මෙතඩ් එක
    public static Connection getConnection() {
        return connection;
    }
}