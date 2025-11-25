<%-- 
    Document   : paymentForm
    Created on : 21 Nov 2025, 22.38.34
    Author     : Ghaisani
--%>

<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.util.Map" %>
<!DOCTYPE html>
<html lang="id">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Konfirmasi Pembayaran - KostHunt</title>
    <style>
        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
        }
        
        body {
            font-family: -apple-system, BlinkMacSystemFont, 'Segoe UI', Roboto, 'Helvetica Neue', Arial, sans-serif;
            background-color: #f5f7fa;
            min-height: 100vh;
            display: flex;
            flex-direction: column;
        }
        
        /* Navbar */
        .navbar {
            background-color: #4A90E2;
            padding: 15px 40px;
            display: flex;
            justify-content: space-between;
            align-items: center;
            box-shadow: 0 2px 8px rgba(0,0,0,0.1);
        }
        
        .navbar-brand {
            color: white;
            font-size: 24px;
            font-weight: 700;
            text-decoration: none;
        }
        
        .navbar-search {
            display: flex;
            align-items: center;
            gap: 10px;
        }
        
        .search-box {
            background: rgba(255,255,255,0.2);
            padding: 8px 16px;
            border-radius: 20px;
            color: white;
            border: none;
            width: 200px;
        }
        
        .search-box::placeholder {
            color: rgba(255,255,255,0.7);
        }
        
        .navbar-user {
            color: white;
            display: flex;
            align-items: center;
            gap: 8px;
            cursor: pointer;
        }
        
        .navbar-user::before {
            content: "👤";
            font-size: 20px;
        }
        
        /* Main Container */
        .container {
            flex: 1;
            display: flex;
            justify-content: center;
            align-items: center;
            padding: 40px 20px;
        }
        
        /* Payment Card */
        .payment-card {
            background: white;
            border-radius: 12px;
            box-shadow: 0 4px 20px rgba(0,0,0,0.08);
            max-width: 450px;
            width: 100%;
            overflow: hidden;
        }
        
        .payment-header {
            background: white;
            padding: 30px;
            text-align: center;
            border-bottom: 1px solid #e5e7eb;
        }
        
        .payment-header h1 {
            font-size: 24px;
            color: #1f2937;
            margin-bottom: 15px;
            font-weight: 600;
        }
        
        .room-info {
            color: #6b7280;
            font-size: 15px;
        }
        
        .payment-body {
            padding: 30px;
        }
        
        /* Total Box */
        .total-box {
            background: linear-gradient(135deg, #a7f3d0 0%, #6ee7b7 100%);
            padding: 25px;
            border-radius: 10px;
            text-align: center;
            margin-bottom: 25px;
        }
        
        .total-label {
            color: #065f46;
            font-size: 14px;
            margin-bottom: 8px;
            font-weight: 500;
        }
        
        .total-amount {
            color: #064e3b;
            font-size: 36px;
            font-weight: 700;
            letter-spacing: -1px;
        }
        
        /* Form Group */
        .form-group {
            margin-bottom: 20px;
        }
        
        .form-label {
            display: block;
            color: #374151;
            font-size: 14px;
            font-weight: 500;
            margin-bottom: 8px;
        }
        
        .form-input {
            width: 100%;
            padding: 12px 16px;
            border: 1px solid #d1d5db;
            border-radius: 8px;
            font-size: 15px;
            transition: all 0.3s;
            background: #f9fafb;
        }
        
        .form-input:focus {
            outline: none;
            border-color: #4A90E2;
            background: white;
            box-shadow: 0 0 0 3px rgba(74, 144, 226, 0.1);
        }
        
        .form-example {
            color: #9ca3af;
            font-size: 12px;
            margin-top: 5px;
        }
        
        /* Submit Button */
        .btn-submit {
            width: 100%;
            padding: 15px;
            background: #4A90E2;
            color: white;
            border: none;
            border-radius: 8px;
            font-size: 16px;
            font-weight: 600;
            cursor: pointer;
            transition: all 0.3s;
            margin-top: 10px;
        }
        
        .btn-submit:hover {
            background: #357ab7;
            transform: translateY(-1px);
            box-shadow: 0 4px 12px rgba(74, 144, 226, 0.3);
        }
        
        .btn-submit:active {
            transform: translateY(0);
        }
        
        /* Cancel Link */
        .cancel-link {
            display: block;
            text-align: center;
            color: #6b7280;
            text-decoration: none;
            margin-top: 15px;
            font-size: 14px;
        }
        
        .cancel-link:hover {
            color: #374151;
        }
        
        /* Kost Details */
        .kost-details {
            background: #f9fafb;
            padding: 15px;
            border-radius: 8px;
            margin-bottom: 25px;
            border: 1px solid #e5e7eb;
        }
        
        .kost-name {
            font-weight: 600;
            color: #1f2937;
            margin-bottom: 8px;
        }
        
        .kost-detail-row {
            display: flex;
            justify-content: space-between;
            padding: 5px 0;
            font-size: 14px;
            color: #6b7280;
        }
        
        .kost-detail-label {
            font-weight: 500;
        }
        
        /* Responsive */
        @media (max-width: 768px) {
            .navbar {
                padding: 15px 20px;
            }
            
            .search-box {
                display: none;
            }
            
            .container {
                padding: 20px 15px;
            }
            
            .total-amount {
                font-size: 28px;
            }
        }
    </style>
</head>
<body>
    <%
        Map<String, Object> bookingData = (Map<String, Object>) request.getAttribute("bookingData");
        if (bookingData == null) {
            response.sendRedirect("kost?action=list");
            return;
        }
        
        String userName = (String) session.getAttribute("user");
        if (userName == null) {
            userName = "Guest";
        }
    %>
    
    <jsp:include page="header.jsp" />
    
    <!-- Main Content -->
    <div class="container">
        <div class="payment-card">
            <!-- Header -->
            <div class="payment-header">
                <h1>Konfirmasi Pembayaran Sewa</h1>
                <p class="room-info">Anda akan menyewa Kamar Nomor <strong><%= bookingData.get("room_number") %></strong></p>
            </div>
            
            <!-- Body -->
            <div class="payment-body">
                <!-- Kost Details -->
                <div class="kost-details">
                    <div class="kost-name"><%= bookingData.get("kost_name") %></div>
                    <div class="kost-detail-row">
                        <span class="kost-detail-label">Lokasi:</span>
                        <span><%= bookingData.get("location") %></span>
                    </div>
                    <div class="kost-detail-row">
                        <span class="kost-detail-label">Tipe Kamar:</span>
                        <span><%= bookingData.get("room_type") %></span>
                    </div>
                    <div class="kost-detail-row">
                        <span class="kost-detail-label">Harga/Bulan:</span>
                        <span><strong>Rp <%= String.format("%,.0f", (Double) bookingData.get("room_price")) %></strong></span>
                    </div>
                </div>
                
                <!-- Total Box -->
                <div class="total-box">
                    <div class="total-label">Total Tagihan Bulan Pertama</div>
                    <div class="total-amount" id="totalDisplay">Rp 0</div>
                </div>
                
                <!-- Form -->
                <form action="payment" method="POST" id="paymentForm">
                    <input type="hidden" name="action" value="create">
                    <input type="hidden" name="roomId" value="<%= bookingData.get("room_id") %>">
                    <input type="hidden" name="kostId" value="<%= bookingData.get("kost_id") %>">
                    <input type="hidden" name="amount" id="amountHidden" value="<%= bookingData.get("room_price") %>">
                    <input type="hidden" name="duration" value="1">
                    <input type="hidden" name="paymentMethod" value="Transfer Bank">
                    
                    <!-- Payment Amount Input -->
                    <div class="form-group">
                        <label class="form-label">Masukkan Jumlah Pembayaran Sesuai Tagihan</label>
                        <input type="number" 
                               name="paymentAmount" 
                               class="form-input" 
                               placeholder="Contoh: 1500000"
                               required
                               min="<%= bookingData.get("room_price") %>"
                               id="paymentInput">
                        <div class="form-example">Contoh: <%= String.format("%.0f", (Double) bookingData.get("room_price")) %></div>
                    </div>
                    
                    <!-- Submit Button -->
                    <button type="submit" class="btn-submit">Bayar Sekarang</button>
                </form>
                
                <a href="kost?action=detail&id=<%= bookingData.get("kost_id") %>" class="cancel-link">Batal</a>
            </div>
        </div>
    </div>
    
    <script>
        const pricePerMonth = <%= bookingData.get("room_price") %>;
        
        // Display total
        function updateTotal() {
            document.getElementById('totalDisplay').textContent = 'Rp ' + pricePerMonth.toLocaleString('id-ID');
            document.getElementById('amountHidden').value = pricePerMonth;
        }
        
        updateTotal();
        
        // Form validation
        document.getElementById('paymentForm').addEventListener('submit', function(e) {
            const paymentInput = document.getElementById('paymentInput').value;
            const paymentAmount = parseFloat(paymentInput);
            
            if (paymentAmount < pricePerMonth) {
                e.preventDefault();
                alert('Jumlah pembayaran tidak sesuai!\nHarus minimal: Rp ' + pricePerMonth.toLocaleString('id-ID'));
                return;
            }
            
            if (paymentAmount > pricePerMonth) {
                if (!confirm('Anda membayar lebih dari tagihan (Rp ' + paymentAmount.toLocaleString('id-ID') + '). Lanjutkan?')) {
                    e.preventDefault();
                    return;
                }
            }
            
            // Final confirmation
            if (!confirm('Konfirmasi pembayaran sebesar Rp ' + paymentAmount.toLocaleString('id-ID') + '?')) {
                e.preventDefault();
            }
        });
    </script>
</body>
</html>
