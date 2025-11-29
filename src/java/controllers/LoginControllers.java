/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package controllers;
import java.io.*;
import javax.servlet.*;
import javax.servlet.http.*;
import java.sql.*;
import classes.JDBC;
/**
 *
 * @author Ghaisani
 */
public class LoginControllers extends HttpServlet{
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String email = request.getParameter("email");
        String password = request.getParameter("password");

        // Print out email sama password
        System.out.println("Email: " + email + ", Password: " + password);
        
        String query = "SELECT * FROM Users WHERE email = ? AND password = ?";

        // pake JDBC class untuk dapat koneksi
        JDBC db = new JDBC();
        db.connect();  // 

        // Cek jika koneksi sukses
        if (!db.isConnected()) {
            System.out.println("Database connection failed: " + db.getMessage());
            request.setAttribute("errorMessage", "Database connection failed.");
            request.getRequestDispatcher("login.jsp").forward(request, response);
            return;
        }

        try {
            // Prepare menggunakan koneksi dari JDBC
            PreparedStatement stmt = db.getConnection().prepareStatement(query);
            stmt.setString(1, email);
            stmt.setString(2, password);

            // hasil set
            ResultSet rs = stmt.executeQuery();

            if (rs.next()) {
                //jika user tidak ketemu, set sesi atribut
                HttpSession session = request.getSession();
                session.setAttribute("user", rs.getString("email"));
                session.setAttribute("role", rs.getString("role"));
                session.setAttribute("userName", rs.getString("name"));

                // cek jika user adalah Owner atau Tenant
                String role = rs.getString("role");
                if ("Owner".equals(role)) {
                    System.out.println("Redirecting to ownerDashboard.jsp");
                    response.sendRedirect("ownerDashboard"); // Redirect ke Owner dashboard 
                } else if ("Tenant".equals(role)) {
                    System.out.println("Redirecting to index.jsp");
                    response.sendRedirect("tenantDashboard"); // Redirect ke Tenant dashboard
                } else {
                    request.setAttribute("errorMessage", "Invalid user role.");
                    request.getRequestDispatcher("login.jsp").forward(request, response);
                }
            } else {
                // tidak ada user yang ketemu dengan credential
                System.out.println("No user found with these credentials.");
                request.setAttribute("errorMessage", "Invalid login credentials.");
                request.getRequestDispatcher("login.jsp").forward(request, response);
            }
        } catch (SQLException e) {
            // Handle SQL exceptions
            e.printStackTrace();
            request.setAttribute("errorMessage", "Database error: " + e.getMessage());
            request.getRequestDispatcher("login.jsp").forward(request, response);
        } finally {
            // untuk disconnect
            db.disconnect();
        }
    }
}
