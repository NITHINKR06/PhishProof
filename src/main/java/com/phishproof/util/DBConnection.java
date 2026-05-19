package com.phishproof.util;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;

public class DBConnection {

    // Reads from Railway environment variables automatically
    // Falls back to localhost for local development
    private static final String DB_HOST = System.getenv("MYSQLHOST")     != null ? System.getenv("MYSQLHOST")     : "localhost";
    private static final String DB_PORT = System.getenv("MYSQLPORT")     != null ? System.getenv("MYSQLPORT")     : "3306";
    private static final String DB_NAME = System.getenv("MYSQLDATABASE") != null ? System.getenv("MYSQLDATABASE") : "phishproof_db";
    private static final String DB_USER = System.getenv("MYSQLUSER")     != null ? System.getenv("MYSQLUSER")     : "root";
    private static final String DB_PASS = System.getenv("MYSQLPASSWORD") != null ? System.getenv("MYSQLPASSWORD") : "your_local_password";

    private static final String DB_URL = "jdbc:mysql://" + DB_HOST + ":" + DB_PORT + "/" + DB_NAME
            + "?useSSL=false&serverTimezone=UTC&allowPublicKeyRetrieval=true";

    static {
        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
        } catch (ClassNotFoundException e) {
            throw new RuntimeException("MySQL JDBC Driver not found", e);
        }
    }

    public static Connection getConnection() throws SQLException {
        return DriverManager.getConnection(DB_URL, DB_USER, DB_PASS);
    }

    public static void close(Connection conn) {
        if (conn != null) {
            try { conn.close(); } catch (SQLException ignored) {}
        }
    }
}
