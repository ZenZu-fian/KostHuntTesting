<%-- 
    Document   : kostDetail
    Created on : 20 Nov 2025, 21.11.54
    Author     : Ghaisani
--%>

<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="model.Kost" %>
<%@ page import="java.util.List" %>
<%@ page import="java.util.Map" %>
<!DOCTYPE html>
<html lang="id">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Detail Kost - KostHunt</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css" rel="stylesheet">
    <link href="https://fonts.googleapis.com/css2?family=Plus+Jakarta+Sans:wght@300;400;500;600;700&display=swap" rel="stylesheet">
    <style>
        :root {
            --primary-color: #4A90E2;
            --primary-dark: #3a7bc8;
            --secondary-color: #64748b;
            --text-color: #1e293b;
            --light-bg: #f8fafc;
            --white: #ffffff;
            --success: #22c55e;
            --warning: #f59e0b;
            --danger: #ef4444;
        }

        body {
            font-family: 'Plus Jakarta Sans', sans-serif;
            background-color: var(--light-bg);
            color: var(--text-color);
        }

        .navbar {
            background-color: var(--primary-color);
            padding: 1rem 2rem;
            box-shadow: 0 2px 8px rgba(0,0,0,0.1);
        }

        .navbar-brand {
            color: white;
            font-size: 1.5rem;
            font-weight: 700;
            text-decoration: none;
        }

        .navbar-search {
            position: relative;
            width: 300px;
        }

        .navbar-search input {
            width: 100%;
            padding: 0.5rem 2.5rem 0.5rem 1rem;
            border-radius: 25px;
            border: none;
            background-color: rgba(255,255,255,0.2);
            color: white;
        }

        .navbar-search input::placeholder {
            color: rgba(255,255,255,0.7);
        }

        .navbar-search i {
            position: absolute;
            right: 1rem;
            top: 50%;
            transform: translateY(-50%);
            color: white;
        }

        .navbar-user {
            color: white;
            display: flex;
            align-items: center;
            gap: 0.5rem;
            cursor: pointer;
        }

        .container-main {
            max-width: 1200px;
            margin: 2rem auto;
            padding: 0 1.5rem;
        }

        .kost-header {
            display: flex;
            justify-content: space-between;
            align-items: flex-start;
            margin-bottom: 1.5rem;
        }

        .kost-title {
            flex: 1;
        }

        .kost-title h1 {
            font-size: 2rem;
            font-weight: 700;
            margin-bottom: 0.5rem;
        }

        .kost-rating {
            color: #ffc107;
            font-size: 1.1rem;
            margin-right: 0.5rem;
        }

        .kost-location {
            color: var(--secondary-color);
            display: flex;
            align-items: center;
            gap: 0.5rem;
        }

        .content-grid {
            display: grid;
            grid-template-columns: 2fr 1fr;
            gap: 2rem;
        }

        .main-image {
            width: 100%;
            height: 400px;
            object-fit: cover;
            border-radius: 1rem;
            box-shadow: 0 4px 12px rgba(0,0,0,0.1);
        }

        .info-card {
            background: white;
            border-radius: 1rem;
            padding: 1.5rem;
            box-shadow: 0 2px 8px rgba(0,0,0,0.1);
            margin-bottom: 1.5rem;
        }

        .price-box {
            text-align: center;
            margin-bottom: 1.5rem;
        }

        .price-label {
            color: var(--secondary-color);
            font-size: 0.875rem;
            margin-bottom: 0.25rem;
        }

        .price-amount {
            color: var(--primary-color);
            font-size: 2rem;
            font-weight: 700;
        }

        .price-period {
            color: var(--secondary-color);
            font-size: 0.875rem;
        }

        .owner-info {
            text-align: center;
        }

        .owner-info h3 {
            font-size: 1rem;
            font-weight: 600;
            margin-bottom: 1rem;
        }

        .owner-avatar {
            width: 80px;
            height: 80px;
            border-radius: 50%;
            margin: 0 auto 1rem;
            object-fit: cover;
        }

        .owner-name {
            font-weight: 600;
            margin-bottom: 0.25rem;
        }

        .owner-email {
            color: var(--secondary-color);
            font-size: 0.875rem;
            margin-bottom: 1rem;
        }

        .btn-whatsapp {
            background-color: #25D366;
            color: white;
            width: 100%;
            padding: 0.75rem;
            border-radius: 0.5rem;
            border: none;
            font-weight: 600;
            display: flex;
            align-items: center;
            justify-content: center;
            gap: 0.5rem;
            transition: all 0.3s;
        }

        .btn-whatsapp:hover {
            background-color: #1DAE53;
            color: white;
            transform: translateY(-2px);
        }

        .section-title {
            font-size: 1.5rem;
            font-weight: 700;
            margin-bottom: 1rem;
        }

        .description-text {
            color: var(--secondary-color);
            line-height: 1.6;
        }

        .facilities-title {
            font-size: 1.25rem;
            font-weight: 600;
            margin-top: 1.5rem;
            margin-bottom: 1rem;
        }

        .facility-badges {
            display: flex;
            flex-wrap: wrap;
            gap: 0.5rem;
        }

        .facility-badge {
            background-color: #E3F2FD;
            color: var(--primary-color);
            padding: 0.5rem 1rem;
            border-radius: 20px;
            font-size: 0.875rem;
            font-weight: 500;
        }

        .rooms-section {
            margin-top: 2rem;
        }

        .rooms-table {
            background: white;
            border-radius: 1rem;
            overflow: hidden;
            box-shadow: 0 2px 8px rgba(0,0,0,0.1);
        }

        .table {
            margin-bottom: 0;
        }

        .table thead {
            background-color: var(--light-bg);
        }

        .table th {
            font-weight: 600;
            padding: 1rem;
            border-bottom: 2px solid #e2e8f0;
        }

        .table td {
            padding: 1rem;
            vertical-align: middle;
        }

        .status-badge {
            padding: 0.375rem 0.75rem;
            border-radius: 20px;
            font-size: 0.75rem;
            font-weight: 600;
        }

        .status-terisi {
            background-color: #fee;
            color: #dc2626;
        }

        .status-tersedia {
            background-color: #d1fae5;
            color: #059669;
        }

        .btn-action {
            padding: 0.5rem 1rem;
            border-radius: 0.5rem;
            border: none;
            font-size: 0.875rem;
            font-weight: 500;
            cursor: pointer;
            transition: all 0.3s;
        }

        .btn-tentisi {
            background-color: #e2e8f0;
            color: var(--secondary-color);
        }

        .btn-sewa {
            background-color: var(--primary-color);
            color: white;
        }

        .btn-sewa:hover {
            background-color: var(--primary-dark);
            color: white;
        }

        @media (max-width: 768px) {
            .content-grid {
                grid-template-columns: 1fr;
            }

            .kost-header {
                flex-direction: column;
            }
        }
    </style>
</head>
<body>
    <jsp:include page="header.jsp" />

    <!-- Main Content -->
    <div class="container-main">
        <%
            Kost kost = (Kost) request.getAttribute("kost");
            Map<String, Object> ownerInfo = (Map<String, Object>) request.getAttribute("ownerInfo");
            List<Map<String, Object>> rooms = (List<Map<String, Object>>) request.getAttribute("rooms");
            
            if (kost != null) {
        %>
        
        <!-- Header -->
        <div class="kost-header">
            <div class="kost-title">
                <h1><%= kost.getName() %> <span class="kost-rating"><i class="fas fa-star"></i> <%= String.format("%.1f", kost.getAvgRating()) %></span></h1>
                <div class="kost-location">
                    <i class="fas fa-map-marker-alt"></i>
                    <span><%= kost.getAddress() %></span>
                </div>
            </div>
        </div>

        <!-- Content Grid -->
        <div class="content-grid">
            <!-- Left Column -->
            <div>
                <!-- Main Image -->
                <img src="<%= kost.getImageUrl() != null && !kost.getImageUrl().isEmpty() ? kost.getImageUrl() : "https://placehold.co/800x400/4A90E2/FFFFFF?text=" + java.net.URLEncoder.encode(kost.getName(), "UTF-8") %>" 
                     alt="<%= kost.getName() %>" 
                     class="main-image">

                <!-- Description -->
                <div class="info-card">
                    <h2 class="section-title">Deskripsi Kost</h2>
                    <p class="description-text">
                        <%= kost.getDescription() != null ? kost.getDescription() : "Kost nyaman dengan fasilitas lengkap dan lokasi strategis" %>
                    </p>

                    <h3 class="facilities-title">Fasilitas</h3>
                    <div class="facility-badges">
                        <%
                            String facilities = kost.getFacilities();
                            if (facilities != null && !facilities.isEmpty()) {
                                String[] facilityArray = facilities.split(",");
                                for (String facility : facilityArray) {
                        %>
                        <span class="facility-badge"><%= facility.trim() %></span>
                        <%
                                }
                            } else {
                        %>
                        <span class="facility-badge">AC</span>
                        <span class="facility-badge">WiFi</span>
                        <span class="facility-badge">Kamar Mandi Dalam</span>
                        <%
                            }
                        %>
                    </div>
                    
                    <!-- Info Tipe Kost -->
                    <h3 class="facilities-title">Tipe Kost</h3>
                    <div class="facility-badges">
                        <span class="facility-badge">
                            <%= kost.getType() != null ? kost.getType() : "Tidak diketahui" %>
                        </span>
                    </div>
                </div>

                <!-- Available Rooms -->
                <div class="rooms-section">
                    <h2 class="section-title">Kamar yang Tersedia</h2>
                    <div class="rooms-table">
                        <table class="table">
                            <thead>
                                <tr>
                                    <th>No. Kamar</th>
                                    <th>Tipe</th>
                                    <th>Harga / Bulan</th>
                                    <th>Status</th>
                                    <th>Aksi</th>
                                </tr>
                            </thead>
                            <tbody>
                                <%
                                    if (rooms != null && !rooms.isEmpty()) {
                                        for (Map<String, Object> room : rooms) {
                                            String status = (String) room.get("status");
                                            boolean isAvailable = "Available".equals(status);
                                %>
                                <tr>
                                    <td><%= room.get("roomNumber") %></td>
                                    <td><%= room.get("type") %></td>
                                    <td>Rp <%= String.format("%,d", ((Number) room.get("price")).longValue()) %></td>
                                    <td>
                                        <span class="status-badge <%= isAvailable ? "status-tersedia" : "status-terisi" %>">
                                            <%= isAvailable ? "Tersedia" : "Terisi" %>
                                        </span>
                                    </td>
                                    <td>
                                        <% if (isAvailable) { %>
                                        <button class="btn-action btn-sewa" 
                                                onclick="sewaKamar(<%= room.get("id") %>, '<%= room.get("roomNumber") %>')">
                                            Sewa Kamar
                                        </button>
                                        <% } else { %>
                                        <button class="btn-action btn-tentisi" disabled>Terisi</button>
                                        <% } %>
                                    </td>
                                </tr>
                                <%
                                        }
                                    } else {
                                %>
                                <tr>
                                    <td colspan="5" class="text-center text-muted">Belum ada kamar tersedia</td>
                                </tr>
                                <%
                                    }
                                %>
                            </tbody>
                        </table>
                    </div>
                </div>
            </div>

            <!-- Right Column - Sidebar -->
            <div>
                <!-- Price Card -->
                <div class="info-card price-box">
                    <div class="price-label">Mulai dari</div>
                    <div class="price-amount">Rp <%= String.format("%,d", (long) kost.getPrice()) %></div>
                    <div class="price-period">/ bulan</div>
                </div>
                    
                 

                <!-- Owner Info Card -->
                <div class="info-card owner-info">
                    <h3>Informasi Pemilik</h3>
                    
                    <%
                        if (ownerInfo != null) {
                    %>
                    <img src="https://ui-avatars.com/api/?name=<%= java.net.URLEncoder.encode((String) ownerInfo.get("name"), "UTF-8") %>&background=4A90E2&color=fff&size=128" 
                         alt="<%= ownerInfo.get("name") %>" 
                         class="owner-avatar">
                    <div class="owner-name"><%= ownerInfo.get("name") %></div>
                    <div class="owner-email"><%= ownerInfo.get("email") %></div>
                    
                    <% if (ownerInfo.get("phone") != null && !ownerInfo.get("phone").toString().isEmpty()) { %>
                    <a href="https://wa.me/<%= ownerInfo.get("phone").toString().replaceAll("[^0-9]", "") %>?text=Halo,%20saya%20tertarik%20dengan%20kost%20<%= java.net.URLEncoder.encode(kost.getName(), "UTF-8") %>" 
                       class="btn-whatsapp" 
                       target="_blank">
                        <i class="fab fa-whatsapp"></i>
                        Hubungi Pemilik
                    </a>
                    <% } else { %>
                    <button class="btn-whatsapp" disabled>
                        <i class="fab fa-whatsapp"></i>
                        Nomor Tidak Tersedia
                    </button>
                    <% } %>
                    
                    <% } else { %>
                    <img src="https://ui-avatars.com/api/?name=John+Doe&background=4A90E2&color=fff&size=128" 
                         alt="Owner" 
                         class="owner-avatar">
                    <div class="owner-name">John Doe</div>
                    <div class="owner-email">john.doe@example.com</div>
                    <button class="btn-whatsapp">
                        <i class="fab fa-whatsapp"></i>
                        Hubungi Pemilik
                    </button>
                    <% } %>
                </div>
            </div>
        </div>

        <% } else { %>
        <div class="alert alert-warning" role="alert">
            <i class="fas fa-exclamation-triangle me-2"></i>
            Data kost tidak ditemukan.
        </div>
        <% } %>
    </div>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
    <script>
    function sewaKamar(roomId, roomNumber) {
        <% 
            String userRole = (String) session.getAttribute("role");
            if (userRole == null) { 
        %>
            // User belum login, redirect ke login
            alert('Silakan login terlebih dahulu untuk menyewa kamar');
            window.location.href = 'login.jsp';
        <% } else { %>
            // User sudah login, lanjut ke booking
            if (confirm('Apakah Anda yakin ingin menyewa kamar ' + roomNumber + '?')) {
                // Redirect to payment/booking page
                window.location.href = 'payment?action=showForm&roomId=' + roomId + '&kostId=<%= kost.getId() %>';
            }
        <% } %>
    }
</script>
</body>
</html>
