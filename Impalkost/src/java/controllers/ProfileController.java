package controllers;

import java.io.IOException;
import java.sql.*;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

/**
 * Controller untuk menangani update profile pengguna
 */
@WebServlet("/profile")
public class ProfileController extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        // Set encoding untuk handle karakter Indonesia
        request.setCharacterEncoding("UTF-8");
        response.setCharacterEncoding("UTF-8");
        
        // Cek session
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("user") == null) {
            response.sendRedirect("login.jsp");
            return;
        }

        // Ambil data dari form
        String id = request.getParameter("id");
        String name = request.getParameter("name");
        String phone = request.getParameter("phone");
        String password = request.getParameter("password");
        
        System.out.println("=== PROFILE UPDATE DEBUG ===");
        System.out.println("User ID: " + id);
        System.out.println("Name: " + name);
        System.out.println("Phone: " + phone);
        System.out.println("Password: " + (password != null && !password.isEmpty() ? "***" : "not changed"));
        
        Connection conn = null;
        PreparedStatement stmt = null;
        
        try {
            // Koneksi langsung ke database dbkost
            String dbUrl = "jdbc:mysql://localhost:3306/dbkost";
            String dbUser = "root";
            String dbPassword = "";
            
            Class.forName("com.mysql.cj.jdbc.Driver");
            conn = DriverManager.getConnection(dbUrl, dbUser, dbPassword);
            
            System.out.println("Database connected successfully!");
            
            String sql;
            
            // Cek apakah password diubah
            if (password != null && !password.trim().isEmpty()) {
                // Update dengan password baru
                sql = "UPDATE users SET name = ?, phone = ?, password = ? WHERE id = ?";
                stmt = conn.prepareStatement(sql);
                stmt.setString(1, name);
                stmt.setString(2, phone);
                stmt.setString(3, password); // Dalam production, harus di-hash!
                stmt.setInt(4, Integer.parseInt(id));
                System.out.println("SQL: UPDATE with password");
            } else {
                // Update tanpa mengubah password
                sql = "UPDATE users SET name = ?, phone = ? WHERE id = ?";
                stmt = conn.prepareStatement(sql);
                stmt.setString(1, name);
                stmt.setString(2, phone);
                stmt.setInt(3, Integer.parseInt(id));
                System.out.println("SQL: UPDATE without password");
            }
            
            int rowsAffected = stmt.executeUpdate();
            
            System.out.println("Rows affected: " + rowsAffected);
            
            if (rowsAffected > 0) {
                System.out.println("Profile updated successfully");
                response.sendRedirect("profile.jsp?update=success");
            } else {
                System.out.println("No rows updated - ID might not exist");
                response.sendRedirect("profile.jsp?update=error");
            }
            
        } catch (SQLException e) {
            System.err.println("SQL Error in ProfileController: " + e.getMessage());
            e.printStackTrace();
            response.sendRedirect("profile.jsp?update=error");
        } catch (ClassNotFoundException e) {
            System.err.println("JDBC Driver not found: " + e.getMessage());
            e.printStackTrace();
            response.sendRedirect("profile.jsp?update=error");
        } catch (NumberFormatException e) {
            System.err.println("Invalid ID format: " + e.getMessage());
            e.printStackTrace();
            response.sendRedirect("profile.jsp?update=error");
        } finally {
            // Close resources
            try {
                if (stmt != null) stmt.close();
                if (conn != null) conn.close();
                System.out.println("Database connection closed");
            } catch (SQLException e) {
                System.err.println("Error closing connection: " + e.getMessage());
            }
        }
    }
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        // Redirect GET requests ke profile.jsp
        response.sendRedirect("profile.jsp");
    }
}