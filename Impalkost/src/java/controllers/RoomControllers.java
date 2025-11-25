/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package controllers;
import classes.JDBC;
import model.Room;
import java.io.IOException;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;
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

@WebServlet("/RoomControllers")
public class RoomControllers extends HttpServlet {

    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        HttpSession session = request.getSession(false);
        if (session == null || !"Owner".equals(session.getAttribute("role"))) {
            response.sendRedirect("login.jsp");
            return;
        }

        String action = request.getParameter("action");
        if (action == null) action = "list";

        switch (action) {
            case "list":
                showRoomList(request, response);
                break;
            case "add":
                showAddForm(request, response);
                break;
            case "edit":
                showEditForm(request, response);
                break;
            default:
                showRoomList(request, response);
        }
    }

    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        HttpSession session = request.getSession(false);
        if (session == null || !"Owner".equals(session.getAttribute("role"))) {
            response.sendRedirect("login.jsp");
            return;
        }

        String action = request.getParameter("action");
        
        if ("add".equals(action)) {
            addRoom(request, response);
        } else if ("edit".equals(action)) {
            editRoom(request, response);
        }
    }

    private void addRoom(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        String kostId = request.getParameter("kostId");
        String roomNumber = request.getParameter("roomNumber");
        String roomType = request.getParameter("roomType");
        String price = request.getParameter("price");

        JDBC db = new JDBC();
        db.connect();

        try {
            String query = "INSERT INTO rooms (kost_id, roomNumber, type, price, status) VALUES (?, ?, ?, ?, 'Available')";
            PreparedStatement stmt = db.getConnection().prepareStatement(query);
            stmt.setInt(1, Integer.parseInt(kostId));
            stmt.setString(2, roomNumber);
            stmt.setString(3, roomType);
            stmt.setDouble(4, Double.parseDouble(price));
            
            stmt.executeUpdate();
            response.sendRedirect("roomController?action=list&success=add");
            
        } catch (SQLException e) {
            e.printStackTrace();
            response.sendRedirect("roomController?action=add&error=true");
        } finally {
            db.disconnect();
        }
    }

    private void editRoom(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        String roomId = request.getParameter("roomId");
        String roomNumber = request.getParameter("roomNumber");
        String roomType = request.getParameter("roomType");
        String price = request.getParameter("price");
        String status = request.getParameter("status");

        JDBC db = new JDBC();
        db.connect();

        try {
            String query = "UPDATE rooms SET roomNumber = ?, type = ?, price = ?, status = ? WHERE idRoom = ?";
            PreparedStatement stmt = db.getConnection().prepareStatement(query);
            stmt.setString(1, roomNumber);
            stmt.setString(2, roomType);
            stmt.setDouble(3, Double.parseDouble(price));
            stmt.setString(4, status);
            stmt.setInt(5, Integer.parseInt(roomId));
            
            stmt.executeUpdate();
            response.sendRedirect("roomController?action=list&success=edit");
            
        } catch (SQLException e) {
            e.printStackTrace();
            response.sendRedirect("roomController?action=edit&roomId=" + roomId + "&error=true");
        } finally {
            db.disconnect();
        }
    }

    private void showRoomList(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        HttpSession session = request.getSession();
        String ownerEmail = (String) session.getAttribute("user");
        List<Room> roomList = new ArrayList<>();
        
        JDBC db = new JDBC();
        db.connect();

        String query = "SELECT r.idRoom as id, r.roomNumber as number, r.type, r.price, r.status, r.rating, " +
              "r.kost_id, k.nameKost as kost_name " +
              "FROM rooms r " +
              "JOIN kosts k ON r.kost_id = k.idKost " +
              "JOIN owners o ON k.owner_id = o.idOwner " +
              "JOIN users u ON o.user_id = u.id " +
              "WHERE u.email = ? ORDER BY k.nameKost, r.roomNumber";
        
        try {
            PreparedStatement stmt = db.getConnection().prepareStatement(query);
            stmt.setString(1, ownerEmail);
            ResultSet rs = stmt.executeQuery();
            
            while (rs.next()) {
                Room room = new Room();
                room.setId(rs.getInt("id"));
                room.setNumber(rs.getString("number"));
                room.setType(rs.getString("type"));
                room.setPrice(rs.getDouble("price"));
                room.setStatus(rs.getString("status"));
                room.setKostId(rs.getInt("kost_id"));
                room.setKostName(rs.getString("kost_name"));
                roomList.add(room);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        } finally {
            db.disconnect();
        }

        request.setAttribute("roomList", roomList);
        request.getRequestDispatcher("manageRoom.jsp").forward(request, response);
    }

    private void showAddForm(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        HttpSession session = request.getSession();
        String ownerEmail = (String) session.getAttribute("user");
        List<model.Kost> kostList = new ArrayList<>();
        
        JDBC db = new JDBC();
        db.connect();

        String query = "SELECT k.idKost as id, k.nameKost as name " +
              "FROM kosts k " +
              "JOIN owners o ON k.owner_id = o.idOwner " +
              "JOIN users u ON o.user_id = u.id " +
              "WHERE u.email = ?";

        try {
            PreparedStatement stmt = db.getConnection().prepareStatement(query);
            stmt.setString(1, ownerEmail);
            ResultSet rs = stmt.executeQuery();
            
            while (rs.next()) {
                model.Kost kost = new model.Kost();
                kost.setId(rs.getInt("id"));
                kost.setName(rs.getString("name"));
                kostList.add(kost);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        } finally {
            db.disconnect();
        }

        request.setAttribute("kostList", kostList);
        request.getRequestDispatcher("addRoom.jsp").forward(request, response);
    }

    private void showEditForm(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        String roomId = request.getParameter("roomId");
        Room room = null;
        
        JDBC db = new JDBC();
        db.connect();

        String query = "SELECT r.idRoom as id, r.roomNumber as number, r.type, r.price, r.status, " +
              "r.kost_id, k.nameKost as kost_name " +
              "FROM rooms r " +
              "JOIN kosts k ON r.kost_id = k.idKost " +
              "WHERE r.idRoom = ?";

        try {
            PreparedStatement stmt = db.getConnection().prepareStatement(query);
            stmt.setInt(1, Integer.parseInt(roomId));
            ResultSet rs = stmt.executeQuery();
            
            if (rs.next()) {
                room = new Room();
                room.setId(rs.getInt("id"));
                room.setNumber(rs.getString("number"));
                room.setType(rs.getString("type"));
                room.setPrice(rs.getDouble("price"));
                room.setStatus(rs.getString("status"));
                room.setKostId(rs.getInt("kost_id"));
                room.setKostName(rs.getString("kost_name"));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        } finally {
            db.disconnect();
        }

        request.setAttribute("room", room);
        request.getRequestDispatcher("editRoom.jsp").forward(request, response);
    }
}