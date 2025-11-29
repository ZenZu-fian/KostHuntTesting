<%-- 
    Document   : editRoom
    Created on : 18 Nov 2025, 20.52.26
    Author     : Ghaisani
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="model.Room" %>
<!DOCTYPE html>
<html>
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Edit Kamar</title>
        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
        <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css" rel="stylesheet">
        <link href="https://fonts.googleapis.com/css2?family=Plus+Jakarta+Sans:wght@300;400;500;600;700&display=swap" rel="stylesheet">
        <style>
            * {
                margin: 0;
                padding: 0;
                box-sizing: border-box;
            }

            body {
                font-family: -apple-system, BlinkMacSystemFont, 'Segoe UI', Roboto, Arial, sans-serif;
                background-color: #f5f5f5;
            }


            .container {
                max-width: 500px;
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
                align-items: center;
                gap: 10px;
            }

            .card-header::before {
                font-size: 24px;
            }

            .card-body {
                padding: 30px;
            }

            .form-group {
                margin-bottom: 20px;
            }

            label {
                display: block;
                margin-bottom: 8px;
                color: #333;
                font-size: 14px;
            }

            input[type="text"],
            input[type="number"],
            select {
                width: 100%;
                padding: 12px;
                border: 1px solid #ddd;
                border-radius: 4px;
                font-size: 14px;
                transition: border-color 0.3s;
            }

            input:focus,
            select:focus {
                outline: none;
                border-color: #4A90E2;
            }

            select {
                appearance: none;
                background-image: url("data:image/svg+xml,%3Csvg xmlns='http://www.w3.org/2000/svg' width='12' height='12' viewBox='0 0 12 12'%3E%3Cpath fill='%23333' d='M6 9L1 4h10z'/%3E%3C/svg%3E");
                background-repeat: no-repeat;
                background-position: right 12px center;
                cursor: pointer;
            }

            .button-group {
                display: flex;
                gap: 10px;
                margin-top: 30px;
            }

            .btn {
                flex: 1;
                padding: 12px 24px;
                border: none;
                border-radius: 4px;
                font-size: 14px;
                cursor: pointer;
                transition: all 0.3s;
                display: flex;
                align-items: center;
                justify-content: center;
                gap: 8px;
            }

            .btn-primary {
                background-color: #4A90E2;
                color: white;
            }

            .btn-primary:hover {
                background-color: #3a7bc8;
            }


            .btn-cancel {
                background-color: #E74C3C;
                color: white;
            }

            .btn-cancel:hover {
                background-color: #c0392b;
            }

        </style>
    </head>
    <body>
        <jsp:include page="header.jsp" />

        <!-- Main Content -->
        <div class="container">
            <% Room room = (Room) request.getAttribute("room"); %>
            <% if (room != null) {%>
            <div class="card">
                <div class="card-header">
                    Edit Kamar Nomor: <%= room.getNumber()%>
                </div>
                <div class="card-body">
                    <form action="RoomControllers" method="POST">
                        <input type="hidden" name="action" value="edit">
                        <input type="hidden" name="roomId" value="<%= room.getId()%>">

                        <div class="form-group">
                            <label for="roomNumber">Nomor Kamar</label>
                            <input type="text" 
                                   name="roomNumber" 
                                   id="roomNumber" 
                                   value="<%= room.getNumber()%>"
                                   required>
                        </div>

                        <div class="form-group">
                            <label for="roomType">Tipe Kamar</label>
                            <select name="roomType" id="roomType" required>
                                <option value="Single" <%= "Single".equals(room.getType()) ? "selected" : ""%>>Single</option>
                                <option value="Double" <%= "Double".equals(room.getType()) ? "selected" : ""%>>Double</option>
                                <option value="Triple" <%= "Triple".equals(room.getType()) ? "selected" : ""%>>Triple</option>
                            </select>
                        </div>

                        <div class="form-group">
                            <label for="price">Harga Kamar</label>
                            <input type="number" 
                                   name="price" 
                                   id="price" 
                                   value="<%= room.getPrice()%>"
                                   required>
                        </div>

                        <input type="hidden" name="status" value="<%= room.getStatus()%>">

                        <div class="button-group">
                            <button type="submit" class="btn btn-primary">
                                Simpan Perubahan
                            </button>
                            <button type="button" class="btn btn-cancel" onclick="window.location.href = 'RoomControllers?action=list'">
                                Batal
                            </button>
                        </div>
                    </form>
                </div>
            </div>
            <% } else { %>
            <div class="card">
                <div class="card-body">
                    <p style="text-align: center; color: #666;">Data kamar tidak ditemukan.</p>
                </div>
            </div>
            <% }%>
        </div>
        <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
    </body>
</html>
