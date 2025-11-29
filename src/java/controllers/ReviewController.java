/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package controllers;

import classes.JDBC;
import java.io.IOException;
import java.sql.*;
import java.util.*;
import javax.servlet.RequestDispatcher;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;

/**
 *
 * @author Ghaisani
 */
@WebServlet("/review")
public class ReviewController extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        HttpSession session = request.getSession(false);
        if (session == null || !"Tenant".equals(session.getAttribute("role"))) {
            response.sendRedirect("login.jsp");
            return;
        }

        String action = request.getParameter("action");
        
        if ("showForm".equals(action)) {
            showReviewForm(request, response);
        } else {
            response.sendRedirect("tenantDashboard");
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        HttpSession session = request.getSession(false);
        if (session == null || !"Tenant".equals(session.getAttribute("role"))) {
            response.sendRedirect("login.jsp");
            return;
        }

        String action = request.getParameter("action");
        
        if ("create".equals(action)) {
            createReview(request, response);
        } else {
            response.sendRedirect("tenantDashboard");
        }
    }

    /**
     * Show review form
     */
    private void showReviewForm(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        String roomIdStr = request.getParameter("roomId");
        String kostIdStr = request.getParameter("kostId");
        
        if (roomIdStr == null || kostIdStr == null) {
            response.sendRedirect("tenantDashboard");
            return;
        }
        
        int roomId = Integer.parseInt(roomIdStr);
        int kostId = Integer.parseInt(kostIdStr);
        
        HttpSession session = request.getSession();
        String tenantEmail = (String) session.getAttribute("user");
        
        JDBC db = new JDBC();
        db.connect();
        
        try {
            // Get tenant ID
            int tenantId = 0;
            String getTenantQuery = "SELECT idTenant FROM tenants t " +
                                  "JOIN users u ON t.user_id = u.id WHERE u.email = ?";
            
            try (PreparedStatement stmt = db.getConnection().prepareStatement(getTenantQuery)) {
                stmt.setString(1, tenantEmail);
                try (ResultSet rs = stmt.executeQuery()) {
                    if (rs.next()) {
                        tenantId = rs.getInt("idTenant");
                    }
                }
            }
            
            // Check if already reviewed
            String checkReviewQuery = "SELECT idReview FROM reviews WHERE tenant_id = ? AND room_id = ?";
            boolean alreadyReviewed = false;
            
            try (PreparedStatement stmt = db.getConnection().prepareStatement(checkReviewQuery)) {
                stmt.setInt(1, tenantId);
                stmt.setInt(2, roomId);
                try (ResultSet rs = stmt.executeQuery()) {
                    if (rs.next()) {
                        alreadyReviewed = true;
                    }
                }
            }
            
            if (alreadyReviewed) {
                session.setAttribute("errorMessage", "Anda sudah memberikan review untuk kamar ini.");
                response.sendRedirect("tenantDashboard");
                return;
            }
            
            // Get room and kost details
            String query = "SELECT r.idRoom as room_id, r.roomNumber as room_number, " +
                         "r.type as room_type, k.idKost as kost_id, k.nameKost as kost_name, " +
                         "k.location, k.address " +
                         "FROM rooms r " +
                         "JOIN kosts k ON r.kost_id = k.idKost " +
                         "WHERE r.idRoom = ? AND k.idKost = ?";
            
            Map<String, Object> reviewData = new HashMap<>();
            
            try (PreparedStatement stmt = db.getConnection().prepareStatement(query)) {
                stmt.setInt(1, roomId);
                stmt.setInt(2, kostId);
                try (ResultSet rs = stmt.executeQuery()) {
                    if (rs.next()) {
                        reviewData.put("room_id", rs.getInt("room_id"));
                        reviewData.put("room_number", rs.getString("room_number"));
                        reviewData.put("room_type", rs.getString("room_type"));
                        reviewData.put("kost_id", rs.getInt("kost_id"));
                        reviewData.put("kost_name", rs.getString("kost_name"));
                        reviewData.put("location", rs.getString("location"));
                        reviewData.put("address", rs.getString("address"));
                    }
                }
            }
            
            System.out.println("=== DEBUG REVIEW FORM ===");
            System.out.println("Tenant ID: " + tenantId);
            System.out.println("Room ID: " + roomId);
            System.out.println("Kost ID: " + kostId);
            System.out.println("Review Data: " + reviewData);
            System.out.println("========================");
            
            request.setAttribute("reviewData", reviewData);
            RequestDispatcher dispatcher = request.getRequestDispatcher("review.jsp");
            dispatcher.forward(request, response);
            
        } catch (SQLException e) {
            System.err.println("Error showing review form: " + e.getMessage());
            e.printStackTrace();
            response.sendRedirect("tenantDashboard");
        } finally {
            db.disconnect();
        }
    }

    /**
     * Create review and update ratings
     */
    private void createReview(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        HttpSession session = request.getSession();
        String tenantEmail = (String) session.getAttribute("user");
        
        int roomId = Integer.parseInt(request.getParameter("roomId"));
        int kostId = Integer.parseInt(request.getParameter("kostId"));
        double rating = Double.parseDouble(request.getParameter("rating"));
        String comment = request.getParameter("comment");
        
        JDBC db = new JDBC();
        db.connect();
        
        try {
            db.getConnection().setAutoCommit(false);
            
            // Get tenant ID
            int tenantId = 0;
            String getTenantQuery = "SELECT idTenant FROM tenants t " +
                                  "JOIN users u ON t.user_id = u.id WHERE u.email = ?";
            
            try (PreparedStatement stmt = db.getConnection().prepareStatement(getTenantQuery)) {
                stmt.setString(1, tenantEmail);
                try (ResultSet rs = stmt.executeQuery()) {
                    if (rs.next()) {
                        tenantId = rs.getInt("idTenant");
                    }
                }
            }
            
            if (tenantId == 0) {
                throw new Exception("Tenant tidak ditemukan");
            }
            
            // Check if already reviewed
            String checkQuery = "SELECT idReview FROM reviews WHERE tenant_id = ? AND room_id = ?";
            try (PreparedStatement stmt = db.getConnection().prepareStatement(checkQuery)) {
                stmt.setInt(1, tenantId);
                stmt.setInt(2, roomId);
                try (ResultSet rs = stmt.executeQuery()) {
                    if (rs.next()) {
                        db.getConnection().rollback();
                        session.setAttribute("errorMessage", "Anda sudah memberikan review untuk kamar ini.");
                        response.sendRedirect("tenantDashboard");
                        return;
                    }
                }
            }
            
            // Insert review
            String insertQuery = "INSERT INTO reviews (tenant_id, room_id, kost_id, rating, comment) " +
                               "VALUES (?, ?, ?, ?, ?)";
            
            System.out.println("=== DEBUG INSERT REVIEW ===");
            System.out.println("Tenant ID: " + tenantId);
            System.out.println("Room ID: " + roomId);
            System.out.println("Kost ID: " + kostId);
            System.out.println("Rating: " + rating);
            System.out.println("Comment: " + comment);
            
            try (PreparedStatement stmt = db.getConnection().prepareStatement(insertQuery)) {
                stmt.setInt(1, tenantId);
                stmt.setInt(2, roomId);
                stmt.setInt(3, kostId);
                stmt.setDouble(4, rating);
                stmt.setString(5, comment);
                
                int rowsInserted = stmt.executeUpdate();
                System.out.println("Rows inserted: " + rowsInserted);
                System.out.println("==========================");
            }
            
            // Triggers will automatically update room and kost ratings
            
            db.getConnection().commit();
            
            session.setAttribute("successMessage", "Terima kasih atas review Anda!");
            response.sendRedirect("tenantDashboard");
            
        } catch (Exception e) {
            try {
                db.getConnection().rollback();
            } catch (SQLException ex) {
                ex.printStackTrace();
            }
            System.err.println("Error creating review: " + e.getMessage());
            e.printStackTrace();
            
            session.setAttribute("errorMessage", "Gagal menyimpan review: " + e.getMessage());
            response.sendRedirect("tenantDashboard");
            
        } finally {
            try {
                db.getConnection().setAutoCommit(true);
            } catch (SQLException e) {
                e.printStackTrace();
            }
            db.disconnect();
        }
    }
}