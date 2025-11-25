<%-- 
    Document   : tenantDashboard
    Created on : 30 Okt 2025, 20.06.30
    Author     : Ghaisani
--%>

<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.util.*" %>
<%@ page import="java.text.SimpleDateFormat" %>
<!DOCTYPE html>
<html lang="id">
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Dashboard Tenant - KostHunt</title>
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

            /* Container */
            .main-container {
                max-width: 1200px;
                margin: 0 auto;
                padding: 2rem 1.5rem;
            }

            .page-title {
                font-size: 1.75rem;
                font-weight: 700;
                color: #1f2937;
                margin-bottom: 2rem;
            }

            /* Rental Card */
            .rental-card {
                background: white;
                border-radius: 12px;
                padding: 25px;
                margin-bottom: 30px;
                box-shadow: 0 2px 8px rgba(0,0,0,0.08);
            }

            .rental-header {
                background: #4A90E2;
                color: white;
                padding: 15px 20px;
                border-radius: 8px 8px 0 0;
                margin: -25px -25px 20px -25px;
                font-size: 18px;
                font-weight: 600;
            }

            .rental-info {
                display: grid;
                grid-template-columns: 1fr 1fr;
                gap: 15px;
                margin-bottom: 20px;
            }

            .info-item {
                display: flex;
                flex-direction: column;
                gap: 5px;
            }

            .info-label {
                color: #6b7280;
                font-size: 14px;
            }

            .info-value {
                color: #1f2937;
                font-size: 16px;
                font-weight: 600;
            }

            .rental-actions {
                display: flex;
                gap: 10px;
                margin-top: 20px;
                flex-wrap: wrap;
            }

            .btn {
                padding: 10px 20px;
                border: none;
                border-radius: 8px;
                font-size: 14px;
                font-weight: 600;
                cursor: pointer;
                text-decoration: none;
                display: inline-flex;
                align-items: center;
                gap: 8px;
                transition: all 0.3s;
            }

            .btn-primary {
                background: #4A90E2;
                color: white;
            }

            .btn-primary:hover {
                background: #357ab7;
                color: white;
            }

            .btn-secondary {
                background: #64748b;
                color: white;
            }

            .btn-secondary:hover {
                background: #475569;
                color: white;
            }

            /* Payment History */
            .history-card {
                background: white;
                border-radius: 12px;
                padding: 25px;
                box-shadow: 0 2px 8px rgba(0,0,0,0.08);
            }

            .history-header {
                background: #4A90E2;
                color: white;
                padding: 15px 20px;
                border-radius: 8px 8px 0 0;
                margin: -25px -25px 20px -25px;
                font-size: 18px;
                font-weight: 600;
            }

            .payment-table {
                width: 100%;
                border-collapse: collapse;
            }

            .payment-table th {
                background: #f9fafb;
                padding: 12px;
                text-align: left;
                font-weight: 600;
                color: #374151;
                border-bottom: 2px solid #e5e7eb;
            }

            .payment-table td {
                padding: 12px;
                border-bottom: 1px solid #e5e7eb;
                color: #6b7280;
            }

            .payment-table tr:hover {
                background: #f9fafb;
            }

            .empty-state {
                text-align: center;
                padding: 40px;
                color: #9ca3af;
            }

            .empty-state i {
                font-size: 48px;
                margin-bottom: 15px;
                color: #d1d5db;
            }

            /* Responsive */
            @media (max-width: 768px) {
                .main-container {
                    padding: 1rem;
                }

                .rental-info {
                    grid-template-columns: 1fr;
                }

                .rental-actions {
                    flex-direction: column;
                }

                .payment-table {
                    font-size: 14px;
                    display: block;
                    overflow-x: auto;
                }

                .payment-table th,
                .payment-table td {
                    padding: 8px;
                }
            }
        </style>
    </head>
    <body>
        <%
            String userName = (String) session.getAttribute("user");
            Map<String, Object> currentRental = (Map<String, Object>) request.getAttribute("currentRental");
            List<Map<String, Object>> paymentHistory = (List<Map<String, Object>>) request.getAttribute("paymentHistory");

            if (userName == null) {
                response.sendRedirect("login.jsp");
                return;
            }
        %>

        <!-- Include Header -->
        <jsp:include page="header.jsp" />

        <!-- Main Content -->
        <div class="main-container">
            <h1 class="page-title">Dashboard Anda</h1>

            <!-- Current Rental -->
            <% if (currentRental != null) {%>
            <div class="rental-card">
                <div class="rental-header">
                    <%= currentRental.get("kost_name")%>
                </div>

                <div class="rental-info">
                    <div class="info-item">
                        <span class="info-label">Kamar Anda:</span>
                        <span class="info-value">Nomor <%= currentRental.get("room_number")%></span>
                    </div>
                    <div class="info-item">
                        <span class="info-label">Tipe Kamar:</span>
                        <span class="info-value"><%= currentRental.get("room_type")%></span>
                    </div>
                    <div class="info-item">
                        <span class="info-label">Lokasi:</span>
                        <span class="info-value"><%= currentRental.get("location")%></span>
                    </div>
                    <div class="info-item">
                        <span class="info-label">Alamat:</span>
                        <span class="info-value"><%= currentRental.get("address")%></span>
                    </div>
                </div>

                <div class="rental-actions">
                    <a href="kost?action=detail&id=<%= currentRental.get("kost_id")%>" class="btn btn-secondary">
                        <i class="fas fa-eye"></i>
                        Lihat Detail Kost
                    </a>
                    <a href="#" class="btn btn-primary" onclick="alert('Fitur pembayaran lanjutan akan segera hadir!'); return false;">
                        <i class="fas fa-credit-card"></i>
                        Pembayaran
                    </a>
                    <a href="#" class="btn btn-secondary" onclick="alert('Fitur review akan segera hadir!'); return false;">
                        <i class="fas fa-star"></i>
                        Beri Ulasan
                    </a>
                </div>
            </div>
            <% } %>

            <!-- Payment History -->
            <div class="history-card">
                <div class="history-header">
                    Riwayat Pembayaran
                </div>

                <% if (paymentHistory != null && !paymentHistory.isEmpty()) { %>
                <table class="payment-table">
                    <thead>
                        <tr>
                            <th>Tanggal</th>
                            <th>Kost</th>
                            <th>Nomor Kamar</th>
                            <th>Jumlah</th>
                        </tr>
                    </thead>
                    <tbody>
                        <%
                            SimpleDateFormat dateFormat = new SimpleDateFormat("dd MMMM yyyy", new Locale("id", "ID"));
                            for (Map<String, Object> payment : paymentHistory) {
                                Date paymentDate = (Date) payment.get("payment_date");
                                String formattedDate = dateFormat.format(paymentDate);
                        %>
                        <tr>
                            <td><%= formattedDate%></td>
                            <td><%= payment.get("kost_name")%></td>
                            <td><%= payment.get("room_number")%></td>
                            <td><strong>Rp <%= String.format("%,.2f", payment.get("amount"))%></strong></td>
                        </tr>
                        <% } %>
                    </tbody>
                </table>
                <% } else { %>
                <div class="empty-state">
                    <i class="fas fa-receipt"></i>
                    <p>Belum ada riwayat pembayaran</p>
                </div>
                <% }%>
            </div>
        </div>

        <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
    </body>
</html>