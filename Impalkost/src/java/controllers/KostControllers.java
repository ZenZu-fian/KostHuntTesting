/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package controllers;
import classes.JDBC;
import model.Kost;
import java.io.IOException;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.util.ArrayList;
import java.util.List;
import javax.servlet.RequestDispatcher;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.util.Map;
import java.util.HashMap;
/**
 *
 * @author Ghaisani
 */
public class KostControllers extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        String action = request.getParameter("action");
        if (action == null) action = "list";
        
        switch (action) {
            case "list":
                listKost(request, response);
                break;
            case "detail":
                detailKost(request, response);
                break;
            case "search":
                searchKost(request, response);
                break;
            case "showAdd":
                showAddForm(request, response);
                break;
            case "showEdit":
                showEditForm(request, response);
                break;
            case "manage":
                manageKost(request, response);
                break;
            default:
                listKost(request, response);
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        String action = request.getParameter("action");
        
        switch (action) {
            case "add":
                addKost(request, response);
                break;
            case "edit":
                updateKost(request, response);
                break;
            case "delete":
                deleteKost(request, response);
                break;
            default:
                response.sendRedirect("kost?action=list");
        }
    }
    
   
    /**
     * Menampilkan daftar semua kost (untuk tenant)
     * FR-09: Menampilkan daftar kos
     */
    private void listKost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        List<Kost> kostList = new ArrayList<>();
        JDBC db = new JDBC();
        db.connect();
        
        String query = "SELECT k.id, k.name, k.address, k.description, k.price, " +
                      "k.location, k.type, k.facilities, k.avg_rating, k.image_url " +
                      "FROM kost k " +
                      "ORDER BY k.name";
        
        try (PreparedStatement stmt = db.getConnection().prepareStatement(query);
             ResultSet rs = stmt.executeQuery()) {
            
            while (rs.next()) {
                Kost kost = new Kost();
                kost.setId(rs.getInt("id"));
                kost.setName(rs.getString("name"));
                kost.setAddress(rs.getString("address"));
                kost.setDescription(rs.getString("description"));
                kost.setPrice(rs.getDouble("price"));
                kost.setLocation(rs.getString("location"));
                kost.setType(rs.getString("type"));
                kost.setFacilities(rs.getString("facilities"));
                kost.setAvgRating(rs.getDouble("avg_rating"));
                kost.setImageUrl(rs.getString("image_url"));
                kostList.add(kost);
            }
            
        } catch (SQLException e) {
            e.printStackTrace();
        } finally {
            db.disconnect();
        }
        
        request.setAttribute("kostList", kostList);
        RequestDispatcher dispatcher = request.getRequestDispatcher("kostList.jsp");
        dispatcher.forward(request, response);
    }
    
    /**
     * Menampilkan detail kost beserta kamar-kamar yang tersedia
     * FR-10: Menampilkan detail kos
     */
    private void detailKost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        String kostIdStr = request.getParameter("id");
        
        if (kostIdStr == null || kostIdStr.isEmpty()) {
            response.sendRedirect("ownerDashboard");
            return;
        }
        
        int kostId = Integer.parseInt(kostIdStr);
        
        JDBC db = new JDBC();
        db.connect();
        
        try {
            // 1. Get kost details with owner info
            String kostQuery = "SELECT k.idKost as id, k.nameKost as name, k.address, k.description, " +
                             "k.price, k.location, k.type, k.facilities, k.rating as avgRating, k.image_url, " +
                             "u.id as owner_id, u.name as owner_name, u.email as owner_email, u.phone as owner_phone " +
                             "FROM kosts k " +
                             "JOIN owners o ON k.owner_id = o.idOwner " +
                             "JOIN users u ON o.user_id = u.id " +
                             "WHERE k.idKost = ?";
            
            Kost kost = null;
            Map<String, Object> ownerInfo = new HashMap<>();
            
            try (PreparedStatement stmt = db.getConnection().prepareStatement(kostQuery)) {
                stmt.setInt(1, kostId);
                try (ResultSet rs = stmt.executeQuery()) {
                    if (rs.next()) {
                        // Set kost data
                        kost = new Kost();
                        kost.setId(rs.getInt("id"));
                        kost.setName(rs.getString("name"));
                        kost.setAddress(rs.getString("address"));
                        kost.setDescription(rs.getString("description"));
                        kost.setPrice(rs.getDouble("price"));
                        kost.setLocation(rs.getString("location"));
                        kost.setType(rs.getString("type"));
                        kost.setFacilities(rs.getString("facilities"));
                        kost.setAvgRating(rs.getDouble("avgRating"));
                        kost.setImageUrl(rs.getString("image_url"));
                        
                        // Set owner data
                        ownerInfo.put("id", rs.getInt("owner_id"));
                        ownerInfo.put("name", rs.getString("owner_name"));
                        ownerInfo.put("email", rs.getString("owner_email"));
                        ownerInfo.put("phone", rs.getString("owner_phone"));
                    }
                }
            }
            
            if (kost == null) {
                response.sendRedirect("ownerDashboard");
                return;
            }
            
            // 2. Get available rooms
            String roomQuery = "SELECT idRoom as id, roomNumber, type, price, status, rating " +
                              "FROM rooms WHERE kost_id = ? ORDER BY roomNumber";
            
            List<Map<String, Object>> rooms = new ArrayList<>();
            
            try (PreparedStatement stmt = db.getConnection().prepareStatement(roomQuery)) {
                stmt.setInt(1, kostId);
                try (ResultSet rs = stmt.executeQuery()) {
                    while (rs.next()) {
                        Map<String, Object> room = new HashMap<>();
                        room.put("id", rs.getInt("id"));
                        room.put("roomNumber", rs.getString("roomNumber"));
                        room.put("type", rs.getString("type"));
                        room.put("price", rs.getDouble("price"));
                        room.put("status", rs.getString("status"));
                        room.put("rating", rs.getDouble("rating"));
                        rooms.add(room);
                    }
                }
            }
            
            // Set attributes
            request.setAttribute("kost", kost);
            request.setAttribute("ownerInfo", ownerInfo);
            request.setAttribute("rooms", rooms);
            
            // Forward to JSP
            RequestDispatcher dispatcher = request.getRequestDispatcher("kostDetail.jsp");
            dispatcher.forward(request, response);
            
        } catch (SQLException e) {
            e.printStackTrace();
            response.sendRedirect("ownerDashboard?error=database");
        } finally {
            db.disconnect();
        }
    }
    
    /**
     * Mencari kost berdasarkan keyword
     * FR-16: Menyediakan fitur pencarian kos
     */
    private void searchKost(HttpServletRequest request, HttpServletResponse response) 
        throws ServletException, IOException {
    
    String keyword = request.getParameter("query");  // ← Ganti dari "keyword" ke "query"
    String type = request.getParameter("type");
    String priceRange = request.getParameter("priceRange");
    
    System.out.println("=== SEARCH DEBUG ===");
    System.out.println("Keyword: " + keyword);
    System.out.println("Type: " + type);
    System.out.println("Price Range: " + priceRange);
    
    List<Kost> kostList = new ArrayList<>();
    JDBC db = new JDBC();
    db.connect();
    
    // Pakai nama tabel dan kolom BARU
    StringBuilder query = new StringBuilder(
        "SELECT idKost as id, nameKost as name, address, description, price, " +
        "location, type, facilities, rating as avgRating, image_url " +
        "FROM kosts WHERE status = 1"
    );
    
    if (keyword != null && !keyword.trim().isEmpty()) {
        query.append(" AND (LOWER(nameKost) LIKE LOWER(?) OR LOWER(address) LIKE LOWER(?) OR LOWER(location) LIKE LOWER(?) OR LOWER(description) LIKE LOWER(?))");
    }
    if (type != null && !type.isEmpty()) {
        query.append(" AND type = ?");
    }
    if (priceRange != null && !priceRange.isEmpty()) {
        String[] range = priceRange.split("-");
        if (range.length == 2) {
            query.append(" AND price BETWEEN ? AND ?");
        }
    }
    query.append(" ORDER BY nameKost");
    
    System.out.println("SQL: " + query.toString());
    
    try (PreparedStatement stmt = db.getConnection().prepareStatement(query.toString())) {
        int paramIndex = 1;
        
        if (keyword != null && !keyword.trim().isEmpty()) {
            String searchPattern = "%" + keyword.trim() + "%";
            stmt.setString(paramIndex++, searchPattern);
            stmt.setString(paramIndex++, searchPattern);
            stmt.setString(paramIndex++, searchPattern);
            stmt.setString(paramIndex++, searchPattern);
            System.out.println("Search Pattern: " + searchPattern);
        }
        if (type != null && !type.isEmpty()) {
            stmt.setString(paramIndex++, type);
        }
        if (priceRange != null && !priceRange.isEmpty()) {
            String[] range = priceRange.split("-");
            if (range.length == 2) {
                stmt.setDouble(paramIndex++, Double.parseDouble(range[0]));
                stmt.setDouble(paramIndex++, Double.parseDouble(range[1]));
            }
        }
        
        try (ResultSet rs = stmt.executeQuery()) {
            int count = 0;
            while (rs.next()) {
                Kost kost = new Kost();
                kost.setId(rs.getInt("id"));
                kost.setName(rs.getString("name"));
                kost.setAddress(rs.getString("address"));
                kost.setDescription(rs.getString("description"));
                kost.setPrice(rs.getDouble("price"));
                kost.setLocation(rs.getString("location"));
                kost.setType(rs.getString("type"));
                kost.setFacilities(rs.getString("facilities"));
                kost.setAvgRating(rs.getDouble("avgRating"));
                kost.setImageUrl(rs.getString("image_url"));
                kostList.add(kost);
                count++;
                
                System.out.println("Found #" + count + ": " + kost.getName() + " (" + kost.getLocation() + ")");
            }
            System.out.println("Total: " + count + " results");
            System.out.println("===================");
        }
        
    } catch (SQLException e) {
        System.out.println("SQL ERROR: " + e.getMessage());
        e.printStackTrace();
    } finally {
        db.disconnect();
    }
    
    request.setAttribute("kostList", kostList);
    request.setAttribute("searchKeyword", keyword);
    request.getRequestDispatcher("kostList.jsp").forward(request, response);
}
    
    
    /**
     * Menampilkan daftar kost milik owner (untuk manage)
     */
    private void manageKost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        HttpSession session = request.getSession(false);
        if (session == null || !"Owner".equals(session.getAttribute("role"))) {
            response.sendRedirect("login.jsp");
            return;
        }
        
        String ownerEmail = (String) session.getAttribute("user");
        List<Kost> kostList = new ArrayList<>();
        JDBC db = new JDBC();
        db.connect();
        
        String query = "SELECT k.id, k.name, k.address, k.description, k.price, " +
                      "k.location, k.type, k.facilities, k.avg_rating, k.image_url " +
                      "FROM kost k " +
                      "JOIN users u ON k.owner_id = u.id " +
                      "WHERE u.email = ? " +
                      "ORDER BY k.name";
        
        try (PreparedStatement stmt = db.getConnection().prepareStatement(query)) {
            stmt.setString(1, ownerEmail);
            try (ResultSet rs = stmt.executeQuery()) {
                while (rs.next()) {
                    Kost kost = new Kost();
                    kost.setId(rs.getInt("id"));
                    kost.setName(rs.getString("name"));
                    kost.setAddress(rs.getString("address"));
                    kost.setDescription(rs.getString("description"));
                    kost.setPrice(rs.getDouble("price"));
                    kost.setLocation(rs.getString("location"));
                    kost.setType(rs.getString("type"));
                    kost.setFacilities(rs.getString("facilities"));
                    kost.setAvgRating(rs.getDouble("avg_rating"));
                    kost.setImageUrl(rs.getString("image_url"));
                    kostList.add(kost);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        } finally {
            db.disconnect();
        }
        
        request.setAttribute("kostList", kostList);
        RequestDispatcher dispatcher = request.getRequestDispatcher("manageKost.jsp");
        dispatcher.forward(request, response);
    }
    
    /**
     * Menampilkan form tambah kost
     */
    private void showAddForm(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        HttpSession session = request.getSession(false);
        if (session == null || !"Owner".equals(session.getAttribute("role"))) {
            response.sendRedirect("login.jsp");
            return;
        }
        
        RequestDispatcher dispatcher = request.getRequestDispatcher("addKost.jsp");
        dispatcher.forward(request, response);
    }
    
    /**
     * Menambahkan kost baru
     * FR-03: Menambahkan data kos baru
     */
    private void addKost(HttpServletRequest request, HttpServletResponse response) 
        throws ServletException, IOException {
    
    HttpSession session = request.getSession(false);
    if (session == null || !"Owner".equals(session.getAttribute("role"))) {
        response.sendRedirect("login.jsp");
        return;
    }
    
    String ownerEmail = (String) session.getAttribute("user");
    String name = request.getParameter("name");
    String address = request.getParameter("address");
    String description = request.getParameter("description");
    double price = Double.parseDouble(request.getParameter("price"));
    String location = request.getParameter("location");
    String type = request.getParameter("type");
    String facilities = request.getParameter("facilities");
    String imageUrl = request.getParameter("imageUrl");
    
    JDBC db = new JDBC();
    db.connect();
    
    try {
        // 1. Get user_id
        int userId = 0;
        String getUserQuery = "SELECT id FROM users WHERE email = ?";
        
        try (PreparedStatement stmt = db.getConnection().prepareStatement(getUserQuery)) {
            stmt.setString(1, ownerEmail);
            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) userId = rs.getInt("id");
            }
        }
        
        // 2. Check/create owner
        int ownerId = 0;
        String checkOwnerQuery = "SELECT idOwner FROM owners WHERE user_id = ?";
        
        try (PreparedStatement stmt = db.getConnection().prepareStatement(checkOwnerQuery)) {
            stmt.setInt(1, userId);
            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    ownerId = rs.getInt("idOwner");
                }
            }
        }
        
        if (ownerId == 0) {
            String insertOwnerQuery = "INSERT INTO owners (user_id) VALUES (?)";
            try (PreparedStatement stmt = db.getConnection().prepareStatement(insertOwnerQuery, Statement.RETURN_GENERATED_KEYS)) {
                stmt.setInt(1, userId);
                stmt.executeUpdate();
                
                try (ResultSet keys = stmt.getGeneratedKeys()) {
                    if (keys.next()) ownerId = keys.getInt(1);
                }
            }
        }
        
        // 3. Insert kost
        String insertQuery = "INSERT INTO kosts (owner_id, nameKost, address, description, price, location, type, facilities, image_url, rating, status) " +
                           "VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, 0.0, 1)";
        
        try (PreparedStatement stmt = db.getConnection().prepareStatement(insertQuery)) {
            stmt.setInt(1, ownerId);
            stmt.setString(2, name);
            stmt.setString(3, address);
            stmt.setString(4, description);
            stmt.setDouble(5, price);
            stmt.setString(6, location);
            stmt.setString(7, type);
            stmt.setString(8, facilities);
            stmt.setString(9, imageUrl);
            
            int result = stmt.executeUpdate();
            
            if (result > 0) {
                response.sendRedirect("ownerDashboard");
            } else {
                response.sendRedirect("kost?action=showAdd&error=true");
            }
        }
        
    } catch (SQLException e) {
        e.printStackTrace();
        response.sendRedirect("kost?action=showAdd&error=true");
    } finally {
        db.disconnect();
    }
}
    
    /**
    * Menampilkan form edit kost
    * FR-11: Mengedit Data Kos
    */
    private void showEditForm(HttpServletRequest request, HttpServletResponse response) 
        throws ServletException, IOException {
    
    HttpSession session = request.getSession(false);
    if (session == null || !"Owner".equals(session.getAttribute("role"))) {
        response.sendRedirect("login.jsp");
        return;
    }
    
    String kostIdStr = request.getParameter("id");
    
    if (kostIdStr == null || kostIdStr.isEmpty()) {
        response.sendRedirect("ownerDashboard");
        return;
    }
    
    int kostId = Integer.parseInt(kostIdStr);
    
    JDBC db = new JDBC();
    db.connect();
    
    try {
        // Query BENAR dengan nama tabel dan kolom baru
        String query = "SELECT k.idKost as id, k.nameKost as name, k.address, k.description, " +
                     "k.price, k.location, k.type, k.facilities, k.rating as avgRating, k.image_url " +
                     "FROM kosts k " +
                     "JOIN owners o ON k.owner_id = o.idOwner " +
                     "JOIN users u ON o.user_id = u.id " +
                     "WHERE k.idKost = ? AND u.email = ?";
        
        Kost kost = null;
        
        try (PreparedStatement stmt = db.getConnection().prepareStatement(query)) {
            stmt.setInt(1, kostId);
            stmt.setString(2, (String) session.getAttribute("user"));
            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    kost = new Kost();
                    kost.setId(rs.getInt("id"));
                    kost.setName(rs.getString("name"));
                    kost.setAddress(rs.getString("address"));
                    kost.setDescription(rs.getString("description"));
                    kost.setPrice(rs.getDouble("price"));
                    kost.setLocation(rs.getString("location"));
                    kost.setType(rs.getString("type"));
                    kost.setFacilities(rs.getString("facilities"));
                    kost.setAvgRating(rs.getDouble("avgRating"));
                    kost.setImageUrl(rs.getString("image_url"));
                }
            }
        }
        
        if (kost == null) {
            response.sendRedirect("ownerDashboard?error=kost_not_found");
            return;
        }
        
        request.setAttribute("kost", kost);
        RequestDispatcher dispatcher = request.getRequestDispatcher("editKost.jsp");
        dispatcher.forward(request, response);
        
    } catch (SQLException e) {
        e.printStackTrace();
        response.sendRedirect("ownerDashboard?error=database");
    } finally {
        db.disconnect();
    }
}
    /**
    * di form edit kost
    * Update data kost setelah melakukan perubahan
    */
    private void updateKost(HttpServletRequest request, HttpServletResponse response) 
    throws ServletException, IOException {
    
    HttpSession session = request.getSession(false);
    if (session == null || !"Owner".equals(session.getAttribute("role"))) {
        response.sendRedirect("login.jsp");
        return;
    }
    
    int kostId = Integer.parseInt(request.getParameter("id"));
    String name = request.getParameter("name");
    String address = request.getParameter("address");
    String description = request.getParameter("description");
    double price = Double.parseDouble(request.getParameter("price"));
    String location = request.getParameter("location");
    String type = request.getParameter("type");
    String facilities = request.getParameter("facilities");
    String imageUrl = request.getParameter("imageUrl");
    
    JDBC db = new JDBC();
    db.connect();
    
    try {
        String updateQuery = "UPDATE kosts SET nameKost = ?, address = ?, description = ?, " +
                           "price = ?, location = ?, type = ?, facilities = ?, image_url = ? " +
                           "WHERE idKost = ?";
        
        try (PreparedStatement stmt = db.getConnection().prepareStatement(updateQuery)) {
            stmt.setString(1, name);
            stmt.setString(2, address);
            stmt.setString(3, description);
            stmt.setDouble(4, price);
            stmt.setString(5, location);
            stmt.setString(6, type);
            stmt.setString(7, facilities);
            stmt.setString(8, imageUrl);
            stmt.setInt(9, kostId);
            
            int result = stmt.executeUpdate();
            
            if (result > 0) {
                response.sendRedirect("ownerDashboard?success=edit");
            } else {
                response.sendRedirect("kost?action=showEdit&id=" + kostId + "&error=update_failed");
            }
        }
        
    } catch (SQLException e) {
        e.printStackTrace();
        response.sendRedirect("kost?action=showEdit&id=" + kostId + "&error=database");
    } finally {
        db.disconnect();
    }
}
    
    
    /**
     * Hapus kost
     * FR-12: Menghapus data kos
     */
    private void deleteKost(HttpServletRequest request, HttpServletResponse response) 
        throws ServletException, IOException {
    
    HttpSession session = request.getSession(false);
    if (session == null || !"Owner".equals(session.getAttribute("role"))) {
        response.sendRedirect("login.jsp");
        return;
    }
    
    String kostIdStr = request.getParameter("id");
    
    if (kostIdStr == null || kostIdStr.isEmpty()) {
        response.sendRedirect("ownerDashboard");
        return;
    }
    
    int kostId = Integer.parseInt(kostIdStr);
    
    JDBC db = new JDBC();
    db.connect();
    
    try {
        String deleteQuery = "DELETE FROM kosts WHERE idKost = ?";
        
        try (PreparedStatement stmt = db.getConnection().prepareStatement(deleteQuery)) {
            stmt.setInt(1, kostId);
            stmt.executeUpdate();
            response.sendRedirect("ownerDashboard?success=delete");  // ← PENTING!
        }
        
    } catch (SQLException e) {
        e.printStackTrace();
        response.sendRedirect("ownerDashboard?error=database");
    } finally {
        db.disconnect();
    }
}
}