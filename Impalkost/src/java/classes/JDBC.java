/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package classes;
import java.sql.*;
/**
 *
 * @author Ghaisani
 */
import java.sql.*;

public class JDBC {
    private Connection con;
    private Statement stmt;
    private boolean isConnected;
    private String message;
    
    public void connect() {
        String dbname = "dbkost";  // Database name
        String username = "root";          // MySQL username
        String password = "";              // MySQL password

        try {
            // Load MySQL JDBC Driver
            Class.forName("com.mysql.cj.jdbc.Driver");
            
            // Establish connection to MySQL database
            con = DriverManager.getConnection("jdbc:mysql://localhost:3306/" + dbname, username, password);
            stmt = con.createStatement();
            isConnected = true;
            message = "DB connected";
        } catch (Exception e) {
            isConnected = false;
            message = e.getMessage();
        }
    }

    public Connection getConnection() {
        return con; // Return the current Connection object
    }

    public boolean isConnected() {
        return isConnected;
    }

    public String getMessage() {
        return message;
    }

    public void disconnect() {
        try {
            if (stmt != null) stmt.close();   // Close Statement if not null
            if (con != null) con.close();     // Close Connection if not null
        } catch (Exception e) {
            message = e.getMessage();
        }
    }

    public void runQuery(String query) {
        try {
            connect();
            int result = stmt.executeUpdate(query);
            message = "info: " + result + " rows affected";
        } catch (Exception e) {
            message = e.getMessage();
        } finally {
            disconnect();
        }
    }

    public ResultSet getData(String query) {
        ResultSet rs = null;
        try {
            connect();
            rs = stmt.executeQuery(query);
        } catch (Exception e) {
            message = e.getMessage();
        } finally {
            
        }
        return rs;
    }
}
