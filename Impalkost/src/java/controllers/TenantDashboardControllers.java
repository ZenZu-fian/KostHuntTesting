/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package controllers;

import classes.JDBC;
import model.*;
import java.io.IOException;
import java.sql.*;
import java.util.*;
import javax.servlet.RequestDispatcher;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
/**
 *
 * @author Ghaisani
 */

@WebServlet("/tenantDashboard")
public class TenantDashboardControllers extends HttpServlet {
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
        throws ServletException, IOException {
    
    HttpSession session = request.getSession(false);
    if (session == null || !"Tenant".equals(session.getAttribute("role"))) {
        response.sendRedirect("login.jsp");
        return;
    }

    String userEmail = (String) session.getAttribute("user");
    
    Map<String, Object> currentRental = null;
    List<Map<String, Object>> paymentHistory = new ArrayList<>();

    JDBC db = new JDBC();
    db.connect();
    
    try {
        // 1. Get current rental - FIXED QUERY
        String rentalQuery = "SELECT r.idRoom as room_id, r.roomNumber as room_number, r.type as room_type, " +
                           "k.idKost as kost_id, k.nameKost as kost_name, k.location, k.address " +
                           "FROM payments p " +
                           "JOIN rooms r ON p.room_id = r.idRoom " +
                           "JOIN kosts k ON r.kost_id = k.idKost " +
                           "JOIN tenants t ON p.tenant_id = t.idTenant " +
                           "JOIN users u ON t.user_id = u.id " +
                           "WHERE u.email = ? AND r.status = 'Occupied' " +
                           "ORDER BY p.tanggal DESC LIMIT 1";
        
        try (PreparedStatement stmt = db.getConnection().prepareStatement(rentalQuery)) {
            stmt.setString(1, userEmail);
            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    currentRental = new HashMap<>();
                    currentRental.put("room_id", rs.getInt("room_id"));
                    currentRental.put("room_number", rs.getString("room_number"));
                    currentRental.put("room_type", rs.getString("room_type"));
                    currentRental.put("kost_id", rs.getInt("kost_id"));
                    currentRental.put("kost_name", rs.getString("kost_name"));
                    currentRental.put("location", rs.getString("location"));
                    currentRental.put("address", rs.getString("address"));
                }
            }
        }

        // 2. Get payment history - FIXED QUERY
        String paymentQuery = "SELECT p.idPayment as id, p.amount, p.tanggal as payment_date, p.method as payment_method, " +
                            "k.nameKost as kost_name, r.roomNumber as room_number " +
                            "FROM payments p " +
                            "JOIN rooms r ON p.room_id = r.idRoom " +
                            "JOIN kosts k ON r.kost_id = k.idKost " +
                            "JOIN tenants t ON p.tenant_id = t.idTenant " +
                            "JOIN users u ON t.user_id = u.id " +
                            "WHERE u.email = ? " +
                            "ORDER BY p.tanggal DESC";
        
        try (PreparedStatement stmt = db.getConnection().prepareStatement(paymentQuery)) {
            stmt.setString(1, userEmail);
            try (ResultSet rs = stmt.executeQuery()) {
                while (rs.next()) {
                    Map<String, Object> payment = new HashMap<>();
                    payment.put("id", rs.getInt("id"));
                    payment.put("amount", rs.getDouble("amount"));
                    payment.put("payment_date", rs.getDate("payment_date"));
                    payment.put("payment_method", rs.getString("payment_method"));
                    payment.put("kost_name", rs.getString("kost_name"));
                    payment.put("room_number", rs.getString("room_number"));
                    paymentHistory.add(payment);
                }
            }
        }
        
        System.out.println("=== TENANT DASHBOARD DEBUG ===");
        System.out.println("User Email: " + userEmail);
        System.out.println("Current Rental: " + (currentRental != null ? currentRental.get("kost_name") : "None"));
        System.out.println("Payment History: " + paymentHistory.size() + " records");
        if (!paymentHistory.isEmpty()) {
            System.out.println("First Payment: " + paymentHistory.get(0));
        }
        System.out.println("==============================");
        
    } catch (SQLException e) {
        System.err.println("SQL Error in TenantDashboard: " + e.getMessage());
        e.printStackTrace();
    } finally {
        db.disconnect();
    }
    
    request.setAttribute("currentRental", currentRental);
    request.setAttribute("paymentHistory", paymentHistory);
    
    RequestDispatcher dispatcher = request.getRequestDispatcher("tenantDashboard.jsp");
    dispatcher.forward(request, response);
}
}

















































