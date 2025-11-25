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
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
/**
 *
 * @author Ghaisani
 */
@WebServlet("/payment")
public class PaymentControllers extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        HttpSession session = request.getSession(false);
        if (session == null || !"Tenant".equals(session.getAttribute("role"))) {
            response.sendRedirect("login.jsp");
            return;
        }

        String action = request.getParameter("action");
        
        if (action == null) action = "history";
        
        switch (action) {
            case "showForm":
                showPaymentForm(request, response);
                break;
            case "history":
                showPaymentHistory(request, response);
                break;
            default:
                showPaymentHistory(request, response);
                break;
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
            createPayment(request, response);
        } else {
            response.sendRedirect("tenantDashboard");
        }
    }

    /**
     * Show payment form with room and kost details
     */
    private void showPaymentForm(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        String roomIdStr = request.getParameter("roomId");
        String kostIdStr = request.getParameter("kostId");
        
        if (roomIdStr == null || kostIdStr == null) {
            response.sendRedirect("kost?action=list");
            return;
        }
        
        int roomId = Integer.parseInt(roomIdStr);
        int kostId = Integer.parseInt(kostIdStr);
        
        JDBC db = new JDBC();
        db.connect();
        
        try {
            // Get room and kost details
            String query = "SELECT r.idRoom as room_id, r.roomNumber as room_number, r.type as room_type, " +
                         "r.price as room_price, r.status, " +
                         "k.idKost as kost_id, k.nameKost as kost_name, k.address, k.location, k.image_url, " +
                         "u.id as owner_id, u.name as owner_name, u.email as owner_email " +
                         "FROM rooms r " +
                         "JOIN kosts k ON r.kost_id = k.idKost " +
                         "JOIN owners o ON k.owner_id = o.idOwner " +
                         "JOIN users u ON o.user_id = u.id " +
                         "WHERE r.idRoom = ? AND k.idKost = ?";
            
            Map<String, Object> bookingData = new HashMap<>();
            
            try (PreparedStatement stmt = db.getConnection().prepareStatement(query)) {
                stmt.setInt(1, roomId);
                stmt.setInt(2, kostId);
                try (ResultSet rs = stmt.executeQuery()) {
                    if (rs.next()) {
                        bookingData.put("room_id", rs.getInt("room_id"));
                        bookingData.put("room_number", rs.getString("room_number"));
                        bookingData.put("room_type", rs.getString("room_type"));
                        bookingData.put("room_price", rs.getDouble("room_price"));
                        bookingData.put("status", rs.getString("status"));
                        bookingData.put("kost_id", rs.getInt("kost_id"));
                        bookingData.put("kost_name", rs.getString("kost_name"));
                        bookingData.put("address", rs.getString("address"));
                        bookingData.put("location", rs.getString("location"));
                        bookingData.put("image_url", rs.getString("image_url"));
                        bookingData.put("owner_name", rs.getString("owner_name"));
                    }
                }
            }
            
            // Check if room is still available
            if (!"Available".equals(bookingData.get("status"))) {
                response.sendRedirect("kost?action=detail&id=" + kostId + "&error=room_occupied");
                return;
            }
            
            request.setAttribute("bookingData", bookingData);
            request.getRequestDispatcher("paymentForm.jsp").forward(request, response);
            
        } catch (SQLException e) {
            e.printStackTrace();
            response.sendRedirect("kost?action=list&error=database");
        } finally {
            db.disconnect();
        }
    }

    /**
     * Create payment and update room status
     * FR-07: Mencatat Pembayaran
     * FR-15: Mendaftar Kos
     */
    private void createPayment(HttpServletRequest request, HttpServletResponse response) 
        throws ServletException, IOException {
    
    HttpSession session = request.getSession();
    String tenantEmail = (String) session.getAttribute("user");
    String tenantName = (String) session.getAttribute("userName"); // Get tenant name from session
    
    int roomId = Integer.parseInt(request.getParameter("roomId"));
    int kostId = Integer.parseInt(request.getParameter("kostId"));
    double amount = Double.parseDouble(request.getParameter("amount"));
    String paymentMethod = request.getParameter("paymentMethod");
    
    JDBC db = new JDBC();
    db.connect();
    
    try {
        db.getConnection().setAutoCommit(false);
        
        // 1. Get tenant ID and user name
        int tenantId = 0;
        int ownerId = 0;
        String payerName = tenantName != null ? tenantName : tenantEmail;
        
        String getTenantQuery = "SELECT t.idTenant, u.name FROM tenants t " +
                               "JOIN users u ON t.user_id = u.id WHERE u.email = ?";
        
        try (PreparedStatement stmt = db.getConnection().prepareStatement(getTenantQuery)) {
            stmt.setString(1, tenantEmail);
            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    tenantId = rs.getInt("idTenant");
                    String userName = rs.getString("name");
                    if (userName != null && !userName.isEmpty()) {
                        payerName = userName;
                    }
                }
            }
        }
        
        // If tenant record doesn't exist, create one
        if (tenantId == 0) {
            String getUserIdQuery = "SELECT id, name FROM users WHERE email = ?";
            int userId = 0;
            
            try (PreparedStatement stmt = db.getConnection().prepareStatement(getUserIdQuery)) {
                stmt.setString(1, tenantEmail);
                try (ResultSet rs = stmt.executeQuery()) {
                    if (rs.next()) {
                        userId = rs.getInt("id");
                        String userName = rs.getString("name");
                        if (userName != null && !userName.isEmpty()) {
                            payerName = userName;
                        }
                    }
                }
            }
            
            String insertTenantQuery = "INSERT INTO tenants (user_id) VALUES (?)";
            try (PreparedStatement stmt = db.getConnection().prepareStatement(insertTenantQuery, Statement.RETURN_GENERATED_KEYS)) {
                stmt.setInt(1, userId);
                stmt.executeUpdate();
                
                try (ResultSet keys = stmt.getGeneratedKeys()) {
                    if (keys.next()) {
                        tenantId = keys.getInt(1);
                    }
                }
            }
        }
        
        // 2. Get owner ID
        String getOwnerQuery = "SELECT o.idOwner FROM owners o " +
                              "JOIN kosts k ON k.owner_id = o.idOwner " +
                              "WHERE k.idKost = ?";
        
        try (PreparedStatement stmt = db.getConnection().prepareStatement(getOwnerQuery)) {
            stmt.setInt(1, kostId);
            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    ownerId = rs.getInt("idOwner");
                }
            }
        }
        
        // 3. Check room availability
        String checkRoomQuery = "SELECT status FROM rooms WHERE idRoom = ? FOR UPDATE";
        String roomStatus = "";
        
        try (PreparedStatement stmt = db.getConnection().prepareStatement(checkRoomQuery)) {
            stmt.setInt(1, roomId);
            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    roomStatus = rs.getString("status");
                }
            }
        }
        
        if (!"Available".equals(roomStatus)) {
            db.getConnection().rollback();
            response.sendRedirect("kost?action=detail&id=" + kostId + "&error=room_occupied");
            return;
        }
        
        // 4. Insert payment record - MATCH ACTUAL TABLE STRUCTURE
        String insertPaymentQuery = "INSERT INTO payments (tenant_id, owner_id, room_id, namaPembayar, tanggal, amount, method, status) " +
                                   "VALUES (?, ?, ?, ?, NOW(), ?, ?, 'Completed')";
        
        System.out.println("=== PAYMENT INSERT DEBUG ===");
        System.out.println("Tenant ID: " + tenantId);
        System.out.println("Owner ID: " + ownerId);
        System.out.println("Room ID: " + roomId);
        System.out.println("Payer Name: " + payerName);
        System.out.println("Amount: " + amount);
        System.out.println("Method: " + paymentMethod);
        
        try (PreparedStatement stmt = db.getConnection().prepareStatement(insertPaymentQuery)) {
            stmt.setInt(1, tenantId);
            stmt.setInt(2, ownerId);
            stmt.setInt(3, roomId);
            stmt.setString(4, payerName);
            stmt.setDouble(5, amount);
            stmt.setString(6, paymentMethod);
            
            int rowsInserted = stmt.executeUpdate();
            System.out.println("Rows inserted: " + rowsInserted);
            System.out.println("===========================");
        }
        
        // 5. Update room status to Occupied
        String updateRoomQuery = "UPDATE rooms SET status = 'Occupied' WHERE idRoom = ?";
        
        try (PreparedStatement stmt = db.getConnection().prepareStatement(updateRoomQuery)) {
            stmt.setInt(1, roomId);
            stmt.executeUpdate();
        }
        
        db.getConnection().commit();
        
        // Success - redirect to tenant dashboard
        response.sendRedirect("tenantDashboard?success=payment");
        
    } catch (SQLException e) {
        try {
            db.getConnection().rollback();
        } catch (SQLException ex) {
            ex.printStackTrace();
        }
        System.err.println("SQL ERROR: " + e.getMessage());
        e.printStackTrace();
        response.sendRedirect("payment?action=showForm&roomId=" + roomId + "&kostId=" + kostId + "&error=true");
    } finally {
        try {
            db.getConnection().setAutoCommit(true);
        } catch (SQLException e) {
            e.printStackTrace();
        }
        db.disconnect();
    }
}

    /**
     * Show payment history for tenant
     * FR-08: Histori Pembayaran
     */
    private void showPaymentHistory(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        HttpSession session = request.getSession();
        String tenantEmail = (String) session.getAttribute("user");
        
        List<Map<String, Object>> paymentList = new ArrayList<>();
        
        JDBC db = new JDBC();
        db.connect();
        
        String query = "SELECT p.idPayment as id, p.amount, p.payment_method, p.payment_date, " +
                      "p.duration_months, p.status, " +
                      "r.roomNumber as room_number, r.type as room_type, " +
                      "k.nameKost as kost_name, k.location " +
                      "FROM payments p " +
                      "JOIN rooms r ON p.room_id = r.idRoom " +
                      "JOIN kosts k ON r.kost_id = k.idKost " +
                      "JOIN tenants t ON p.tenant_id = t.idTenant " +
                      "JOIN users u ON t.user_id = u.id " +
                      "WHERE u.email = ? " +
                      "ORDER BY p.payment_date DESC";
        
        try (PreparedStatement stmt = db.getConnection().prepareStatement(query)) {
            stmt.setString(1, tenantEmail);
            try (ResultSet rs = stmt.executeQuery()) {
                while (rs.next()) {
                    Map<String, Object> payment = new HashMap<>();
                    payment.put("id", rs.getInt("id"));
                    payment.put("amount", rs.getDouble("amount"));
                    payment.put("payment_method", rs.getString("payment_method"));
                    payment.put("payment_date", rs.getTimestamp("payment_date"));
                    payment.put("duration_months", rs.getInt("duration_months"));
                    payment.put("status", rs.getString("status"));
                    payment.put("room_number", rs.getString("room_number"));
                    payment.put("room_type", rs.getString("room_type"));
                    payment.put("kost_name", rs.getString("kost_name"));
                    payment.put("location", rs.getString("location"));
                    paymentList.add(payment);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        } finally {
            db.disconnect();
        }
        
        request.setAttribute("paymentList", paymentList);
        request.getRequestDispatcher("paymentHistory.jsp").forward(request, response);
    }
}