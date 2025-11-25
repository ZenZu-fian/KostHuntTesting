<%-- 
    Document   : addRoom
    Created on : 18 Nov 2025, 20.48.00
    Author     : Ghaisani
--%>

<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.util.List" %>
<%@ page import="model.Kost" %>
<!DOCTYPE html>
<html>
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Tambah Kamar Baru</title>
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

            .btn-danger {
                background-color: #E74C3C;
                color: white;
            }

            .btn-danger:hover {
                background-color: #c0392b;
            }

        </style>
    </head>
    <body>
        <jsp:include page="header.jsp" />

        <!-- Main Content -->
        <div class="container">
            <div class="card">
                <div class="card-header">
                    Tambah Kamar Baru
                </div>
                <div class="card-body">
                    <form action="RoomControllers" method="POST">
                        <input type="hidden" name="action" value="add">

                        <div class="form-group">
                            <label for="kostId">Pilih Kost</label>
                            <select name="kostId" id="kostId" required>
                                <option value="">Pilih Kost</option>
                                <%
                                    List<Kost> kostList = (List<Kost>) request.getAttribute("kostList");
                                    if (kostList != null) {
                                        for (Kost kost : kostList) {
                                %>
                                <option value="<%= kost.getId()%>"><%= kost.getName()%></option>
                                <%
                                        }
                                    }
                                %>
                            </select>
                        </div>

                        <div class="form-group">
                            <label for="roomNumber">Nomor Kamar</label>
                            <input type="text" 
                                   name="roomNumber" 
                                   id="roomNumber" 
                                   placeholder="6767" 
                                   required>
                        </div>

                        <div class="form-group">
                            <label for="roomType">Tipe Kamar</label>
                            <select name="roomType" id="roomType" required>
                                <option value="">Pilih Tipe Kamar</option>
                                <option value="Single">Single</option>
                                <option value="Double">Double</option>
                                <option value="Triple">Triple</option>
                            </select>
                        </div>

                        <div class="form-group">
                            <label for="price">Harga Kamar</label>
                            <input type="number" 
                                   name="price" 
                                   id="price" 
                                   placeholder="1000000" 
                                   required>
                        </div>

                        <div class="button-group">
                            <button type="submit" class="btn btn-primary">
                                Simpan Kamar
                            </button>
                            <button type="button" class="btn btn-danger" onclick="window.location.href = 'RoomControllers?action=list'">
                                Batal
                            </button>
                        </div>
                    </form>
                </div>
            </div>
        </div>
        <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
    </body>
</html>
