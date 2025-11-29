/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package controllers;
import classes.JDBC;
import java.io.*;
import javax.servlet.*;
import javax.servlet.http.*;
import java.sql.*;
/**
 *
 * @author Ghaisani
 */
public class RegisterControllers extends HttpServlet {
    // Menampilkan form register (GET request)
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        RequestDispatcher dispatcher = request.getRequestDispatcher("register.jsp");
        dispatcher.forward(request, response);
    }
    
    // Menangani proses registrasi (POST request)
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String name = request.getParameter("name");
        String email = request.getParameter("email");
        String password = request.getParameter("password");
        String role = request.getParameter("role");  // Bisa "Owner" atau "Tenant"
        
        // Validasi data input
        if (name == null || email == null || password == null || role == null || name.isEmpty() || email.isEmpty() || password.isEmpty() || role.isEmpty()) {
            request.setAttribute("errorMessage", "All fields are required.");
            request.getRequestDispatcher("register.jsp").forward(request, response);
            return;
        }

        // Cek apakah email sudah terdaftar
        String checkEmailQuery = "SELECT * FROM Users WHERE email = ?";
        try (Connection con = DriverManager.getConnection("jdbc:mysql://localhost:3306/dbkost", "root", "");
             PreparedStatement stmt = con.prepareStatement(checkEmailQuery)) {
            
            stmt.setString(1, email);
            ResultSet rs = stmt.executeQuery();
            if (rs.next()) {
                request.setAttribute("errorMessage", "Email is already registered.");
                request.getRequestDispatcher("register.jsp").forward(request, response);
                return;
            }
        } catch (SQLException e) {
            e.printStackTrace();
            request.setAttribute("errorMessage", "Database error: " + e.getMessage());
            request.getRequestDispatcher("register.jsp").forward(request, response);
            return;
        }
        
        // Menyimpan pengguna baru ke dalam database
        String insertQuery = "INSERT INTO Users (name, email, password, role) VALUES (?, ?, ?, ?)";
        
        try (Connection con = DriverManager.getConnection("jdbc:mysql://localhost:3306/dbkost", "root", "");
             PreparedStatement stmt = con.prepareStatement(insertQuery)) {
            
            stmt.setString(1, name);
            stmt.setString(2, email);
            stmt.setString(3, password);  // Anda dapat mengenkripsi password sebelum menyimpannya
            stmt.setString(4, role);
            
            int result = stmt.executeUpdate();
            
            if (result > 0) {
                response.sendRedirect("login.jsp");  // Redirect ke halaman login setelah registrasi berhasil
            } else {
                request.setAttribute("errorMessage", "Registration failed. Please try again.");
                request.getRequestDispatcher("register.jsp").forward(request, response);
            }
        } catch (SQLException e) {
            e.printStackTrace();
            request.setAttribute("errorMessage", "Database error: " + e.getMessage());
            request.getRequestDispatcher("register.jsp").forward(request, response);
        }
    }
}

