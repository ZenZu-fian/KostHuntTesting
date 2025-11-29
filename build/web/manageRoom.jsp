<%-- 
    Document   : manageRoom
    Created on : 18 Nov 2025, 20.57.52
    Author     : Ghaisani
--%>

<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.util.List" %>
<%@ page import="java.util.Map" %>
<%@ page import="java.util.HashMap" %>
<%@ page import="model.Room" %>
<!DOCTYPE html>
<html>
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Kelola Kamar</title>
        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
        <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css" rel="stylesheet">
        <link href="https://fonts.googleapis.com/css2?family=Plus+Jakarta+Sans:wght@300;400;500;600;700&display=swap" rel="stylesheet">
        <style>
            * {
                margin: 0;
                padding: 0;
                box-sizing: border-box;
            }

            html, body {
                margin: 0;
                padding: 0;
                height: 100%;
            }

            body {
                font-family: 'Plus Jakarta Sans', sans-serif;
                background-color: #f5f7fa;
            }

            .container {
                max-width: 750px;
                margin: 50px auto;
                padding: 0 20px;
            }

            .card {
                background: white;
                border-radius: 8px;
                box-shadow: 0 2px 8px rgba(0,0,0,0.1);
                overflow: hidden;
            }

            .card-header {
                background-color: #4A90E2;
                color: white;
                padding: 15px 20px;
                display: flex;
                justify-content: space-between;
                align-items: center;
            }

            .card-header-left {
                display: flex;
                align-items: center;
                gap: 10px;
            }

            .card-header-left::before {
                font-size: 24px;
            }

            .btn-add {
                background-color: white;
                color: #4A90E2;
                padding: 8px 16px;
                border: none;
                border-radius: 4px;
                cursor: pointer;
                font-size: 14px;
                display: flex;
                align-items: center;
                gap: 6px;
                text-decoration: none;
                transition: all 0.3s;
            }

            .btn-add:hover {
                background-color: #f0f0f0;
            }

            .btn-add::before {
                font-size: 18px;
            }

            .card-body {
                padding: 25px;
            }

            .kost-section {
                margin-bottom: 20px;
            }

            .kost-title {
                color: #4A90E2;
                font-size: 16px;
                font-weight: 600;
                margin-bottom: 15px;
            }

            table {
                width: 100%;
                border-collapse: collapse;
            }

            thead {
                background-color: #4A90E2;
                color: white;
            }

            th {
                padding: 12px;
                text-align: left;
                font-weight: 500;
                font-size: 14px;
            }

            th:first-child {
                width: 50px;
                text-align: center;
            }

            th:last-child {
                width: 100px;
                text-align: center;
            }

            tbody tr {
                border-bottom: 1px solid #e0e0e0;
            }

            tbody tr:hover {
                background-color: #f9f9f9;
            }

            td {
                padding: 12px;
                font-size: 14px;
                color: #333;
            }

            td:first-child {
                text-align: center;
                font-weight: 500;
            }

            td:last-child {
                text-align: center;
            }

            .btn-edit {
                background-color: #F5A623;
                color: white;
                padding: 6px 16px;
                border: none;
                border-radius: 4px;
                cursor: pointer;
                font-size: 13px;
                text-decoration: none;
                display: inline-flex;
                align-items: center;
                gap: 5px;
                transition: all 0.3s;
            }

            .btn-edit:hover {
                background-color: #e09615;
            }

            .btn-edit::before {
                content: "✎";
            }

            .btn-back {
                background-color: #4A90E2;
                color: white;
                padding: 10px 20px;
                border: none;
                border-radius: 4px;
                cursor: pointer;
                font-size: 14px;
                margin-top: 20px;
                display: inline-flex;
                align-items: center;
                gap: 8px;
                text-decoration: none;
                transition: all 0.3s;
            }

            .btn-back:hover {
                background-color: #3a7bc8;
            }

        </style>
    </head>
    <body>
        <jsp:include page="header.jsp" />

        <!-- Main Content -->
        <div class="container">
            <div class="card">
                <div class="card-header">
                    <div class="card-header-left">
                        Kelola Kamar
                    </div>
                    <a href="RoomControllers?action=add" class="btn-add">
                        Tambah Kamar
                    </a>
                </div>
                <div class="card-body">
                    <%
                        List<Room> roomList = (List<Room>) request.getAttribute("roomList");

                        // Group rooms by kost
                        Map<String, List<Room>> roomsByKost = new HashMap<>();
                        if (roomList != null) {
                            for (Room room : roomList) {
                                String kostName = room.getKostName();
                                if (!roomsByKost.containsKey(kostName)) {
                                    roomsByKost.put(kostName, new java.util.ArrayList<Room>());
                                }
                                roomsByKost.get(kostName).add(room);
                            }
                        }

                        // Display rooms grouped by kost
                        for (Map.Entry<String, List<Room>> entry : roomsByKost.entrySet()) {
                            String kostName = entry.getKey();
                            List<Room> rooms = entry.getValue();
                    %>

                    <div class="kost-section">
                        <div class="kost-title">Kost: <%= kostName%></div>

                        <table>
                            <thead>
                                <tr>
                                    <th>#</th>
                                    <th>Nomor Kamar</th>
                                    <th>Tipe Kamar</th>
                                    <th>Harga Kamar</th>
                                    <th>Aksi</th>
                                </tr>
                            </thead>
                            <tbody>
                                <%
                                    int counter = 1;
                                    for (Room room : rooms) {
                                %>
                                <tr>
                                    <td><%= counter++%></td>
                                    <td><%= room.getNumber()%></td>
                                    <td><%= room.getType()%></td>
                                    <td><%= room.getPrice()%></td>
                                    <td>
                                        <a href="RoomControllers?action=edit&roomId=<%= room.getId()%>" class="btn-edit">
                                            Edit
                                        </a>
                                    </td>
                                </tr>
                                <% } %>
                            </tbody>
                        </table>
                    </div>

                    <% } %>

                    <% if (roomList == null || roomList.isEmpty()) { %>
                    <div style="text-align: center; padding: 40px; color: #999;">
                        Belum ada kamar yang tersedia.
                    </div>
                    <% }%>

                    <a href="ownerDashboard" class="btn-back">
                        Kembali ke Dashboard
                    </a>
                </div>
            </div>
        </div>

        <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
    </body>
</html>
