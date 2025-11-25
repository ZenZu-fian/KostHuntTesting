<%-- 
    Document   : index
    Created on : 14 Okt 2025, 16.30.35
    Author     : Ghaisani
--%>

<%@page import="model.Kost"%>
<%@page import="model.Kost"%>
<%@page import="java.util.List"%>
<%@page import="java.sql.*"%>
    <!DOCTYPE html>
<html lang="id">
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <meta name="description" content="KostHunt - Platform pencarian dan pemasaran kost terbaik di Indonesia">
        <meta name="keywords" content="kost, boarding house, sewa kost, kost murah, kost nyaman">
        <title>KostHunt - Temukan Kost Impianmu</title>
        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
        <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css" rel="stylesheet">
        <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@300;400;500;600;700&display=swap" rel="stylesheet">
        <style>
            :root {
                --primary-color: #4A90E2;
                --secondary-color: #357ab7;
                --text-color: #333;
                --light-gray: #f8f9fa;
            }

            body {
                font-family: 'Poppins', sans-serif;
                color: var(--text-color);
                background-color: var(--light-gray);
            }

            .navbar {
                background-color: var(--primary-color);
                padding: 1rem 2rem;
                box-shadow: 0 2px 4px rgba(0,0,0,0.1);
            }

            .navbar-brand {
                font-size: 1.8rem;
                font-weight: 700;
                color: white !important;
            }

            .nav-link {
                color: white !important;
                font-weight: 500;
                margin: 0 0.5rem;
                transition: all 0.3s ease;
            }

            .nav-link:hover {
                opacity: 0.8;
            }

            .hero-section {
                padding: 4rem 0;
                background: linear-gradient(135deg, var(--primary-color) 0%, var(--secondary-color) 100%);
                color: white;
            }

            .search-container {
                background: white;
                padding: 2rem;
                border-radius: 10px;
                box-shadow: 0 4px 6px rgba(0,0,0,0.1);
                margin-top: 2rem;
            }

            .search-input {
                border: 2px solid #eee;
                padding: 0.8rem 1rem;
                border-radius: 5px;
                width: 100%;
                transition: all 0.3s ease;
            }

            .search-input:focus {
                border-color: var(--primary-color);
                box-shadow: none;
            }

            .search-button {
                background-color: var(--primary-color);
                color: white;
                border: none;
                padding: 0.8rem 2rem;
                border-radius: 5px;
                font-weight: 500;
                transition: all 0.3s ease;
            }

            .search-button:hover {
                background-color: var(--secondary-color);
                transform: translateY(-2px);
            }

            .area-kos-container {
                padding: 3rem 0;
            }

            .area-kos-container .container {
                padding: 0 2rem;
            }

            .area-kos-container .row {
                margin: 0 -15px;
            }

            .area-kos-container .col-md-4 {
                padding: 0 15px;
                margin-bottom: 30px;
            }

            .area-kos {
                position: relative;
                border-radius: 10px;
                overflow: hidden;
                margin-bottom: 1.5rem;
                box-shadow: 0 4px 6px rgba(0,0,0,0.1);
                transition: all 0.3s ease;
            }

            .area-kos:hover {
                transform: translateY(-5px);
            }

            .area-kos img {
                width: 100%;
                height: 200px;
                object-fit: cover;
            }

            .area-kos-text {
                position: absolute;
                top: 50%;
                left: 50%;
                transform: translate(-50%, -50%);
                padding: 1rem;
                color: white;
                font-size: 20px;
                font-weight: bold;
                text-shadow: 2px 2px 5px rgba(0, 0, 0, 0.6);
                text-align: center;
            }

            .features-section {
                padding: 4rem 0;
                background-color: white;
            }

            .feature-card {
                text-align: center;
                padding: 2rem;
                border-radius: 10px;
                background: var(--light-gray);
                margin-bottom: 1.5rem;
                transition: all 0.3s ease;
            }

            .feature-card:hover {
                transform: translateY(-5px);
                box-shadow: 0 4px 6px rgba(0,0,0,0.1);
            }

            .feature-icon {
                font-size: 2.5rem;
                color: var(--primary-color);
                margin-bottom: 1rem;
            }

            @media (max-width: 768px) {
                .navbar {
                    padding: 1rem;
                }

                .hero-section {
                    padding: 2rem 0;
                }

                .search-container {
                    margin: 1rem;
                }

                .area-kos-container .container {
                    padding: 0 1rem;
                }
                
                .area-kos-container .col-md-4 {
                    padding: 0 10px;
                    margin-bottom: 20px;
                }
            }

            /* Enhanced Kost Card Styles */
            .kost-card {
                background: white;
                border-radius: 12px;
                overflow: hidden;
                box-shadow: 0 4px 15px rgba(0, 0, 0, 0.1);
                transition: transform 0.3s ease, box-shadow 0.3s ease;
                margin-bottom: 30px;
                position: relative;
                height: 100%;
                display: flex;
                flex-direction: column;
            }

            .kost-card:hover {
                transform: translateY(-5px);
                box-shadow: 0 8px 25px rgba(0, 0, 0, 0.15);
            }

            .kost-image-container {
                position: relative;
                height: 200px;
                overflow: hidden;
            }

            .kost-image {
                width: 100%;
                height: 100%;
                object-fit: cover;
                transition: transform 0.3s ease;
            }

            .kost-card:hover .kost-image {
                transform: scale(1.05);
            }

            .kost-overlay {
                position: absolute;
                bottom: 0;
                left: 0;
                right: 0;
                background: linear-gradient(to top, rgba(0,0,0,0.8), transparent);
                padding: 20px;
                color: white;
            }

            .kost-name {
                font-size: 1.4rem;
                font-weight: 600;
                margin: 0;
                text-shadow: 1px 1px 3px rgba(0,0,0,0.3);
            }

            .kost-details {
                padding: 20px;
                flex-grow: 1;
                display: flex;
                flex-direction: column;
            }

            .kost-address {
                color: #666;
                font-size: 0.95rem;
                margin-bottom: 15px;
                display: flex;
                align-items: center;
            }

            .kost-address i {
                color: var(--primary-color);
                margin-right: 8px;
            }

            .kost-price {
                font-size: 1.2rem;
                font-weight: 600;
                color: var(--primary-color);
                margin-top: auto;
            }

            .kost-status {
                position: absolute;
                top: 15px;
                right: 15px;
                background: rgba(255, 255, 255, 0.9);
                padding: 5px 12px;
                border-radius: 20px;
                font-size: 0.8rem;
                font-weight: 500;
                color: var(--primary-color);
                box-shadow: 0 2px 5px rgba(0,0,0,0.1);
            }

            .kost-link {
                text-decoration: none;
                color: inherit;
                display: block;
                height: 100%;
            }

            .kost-link:hover {
                color: inherit;
            }
            
            
        </style>
    </head>
    <body>
        <%@ page session="true" %>

        <!-- Hero Section -->
        <section class="hero-section">
            <div class="container">
                <div class="row align-items-center">
                    <div class="col-lg-6">
                        <h1 class="display-4 fw-bold mb-4">Temukan Kost Impianmu</h1>
                        <p class="lead mb-4">Platform terbaik untuk mencari dan memasarkan kost dengan mudah, aman, dan terpercaya.</p>
                    </div>
                    <div class="col-lg-6">
                        <form action="kost" method="GET">
                            <input type="hidden" name="action" value="search">
                            <div class="input-group mb-3">
                                <input type="text" class="form-control search-input" name="query" placeholder="Cari kost berdasarkan lokasi...">
                                <button class="btn search-button" type="submit">
                                    <i class="fas fa-search"></i> Cari
                                </button>
                            </div>
                        </form>
                    </div>
                </div>
            </div>
        </section>
        
        <!-- Popular Areas Section -->
        <section class="area-kos-container">
            <div class="container">
                <h2 class="text-center mb-5">Area Kost Populer</h2>
                <div class="row">
                    <div class="col-md-4">
                        <div class="area-kos" onclick="window.location.href='<%= request.getContextPath() %>/search?query=bandung'">
                            <img src="https://www.iroamly.com/images/bandung-indonesia-cover.webp" alt="Kost Bandung">
                            <div class="area-kos-text">Kost Bandung</div>
                        </div>
                    </div>
                    <div class="col-md-4">
                        <div class="area-kos" onclick="window.location.href='<%= request.getContextPath() %>/search?query=jogja'">
                            <img src="https://wallpapercave.com/wp/wp9451651.jpg" alt="Kost Jogja">
                            <div class="area-kos-text">Kost Jogja</div>
                        </div>
                    </div>
                    <div class="col-md-4">
                        <div class="area-kos" onclick="window.location.href='<%= request.getContextPath() %>/search?query=solo'">
                            <img src="https://blog.bankmega.com/wp-content/uploads/2023/01/tempat-wisata-di-kota-solo.jpg" alt="Kost Solo">
                            <div class="area-kos-text" style="text-align: center">Kost Solo</div>
                        </div>
                    </div>
                </div>
            </div>
        </section>
        
        <!-- Kost List Section -->
        <section class="area-kos-container">
            <div class="container">
                <h2 class="text-center mb-5">Daftar Kost Tersedia</h2>
                <div class="row">
                    <%
                        List<Kost> kostList = null;
                        try {
                            // Database connection parameters
                            String dbUrl = "jdbc:mysql://localhost:3306/dbkost";
                            String dbUser = "root";
                            String dbPassword = "";
                            
                            Class.forName("com.mysql.cj.jdbc.Driver");
                            Connection conn = DriverManager.getConnection(dbUrl, dbUser, dbPassword);
                            
                            String query = "SELECT id, name, address, status, price, image_url, avg_rating FROM Kost WHERE status != 0";
                            PreparedStatement stmt = conn.prepareStatement(query);
                            ResultSet rs = stmt.executeQuery();
                            
                            while (rs.next()) {
                                String imageUrl = rs.getString("image_url");
                                if (imageUrl == null || imageUrl.trim().isEmpty()) {
                                    imageUrl = "https://placehold.co/600x400/4A90E2/FFFFFF?text=" + java.net.URLEncoder.encode(rs.getString("name"), "UTF-8");
                                }
                    %>
                    <div class="col-md-4">
                        <a href="kostDetail?id=<%= rs.getInt("id") %>" class="kost-link">
                            <div class="kost-card">
                                <div class="kost-image-container">
                                    <img src="<%= imageUrl %>" alt="<%= rs.getString("name") %>" class="kost-image">
                                    <div class="kost-overlay">
                                        <h3 class="kost-name"><%= rs.getString("name") %></h3>
                                    </div>
                                    <div class="kost-status">
                                        <i class="fas fa-check-circle"></i> Tersedia
                                    </div>
                                </div>
                                <div class="kost-details">
                                    <div class="kost-address">
                                        <i class="fas fa-map-marker-alt"></i>
                                        <%= rs.getString("address") %>
                                    </div>

                                    <div class="d-flex align-items-center mb-2">
                                        <i class="fas fa-star text-warning"></i> 
                                        <span class="text-muted ms-1">(<%= String.format("%.1f", rs.getDouble("avg_rating")) %>)</span>
                                    </div>

                                    <div class="kost-price">
                                        Rp <%= String.format("%,d", rs.getInt("price")) %> / bulan
                                    </div>
                                </div>
                            </div>
                        </a>
                    </div>
                    <%
                            }
                            rs.close();
                            stmt.close();
                            conn.close();
                        } catch (Exception e) {
                            e.printStackTrace();
                    %>
                    <div class="col-12 text-center">
                        <p>Terjadi kesalahan saat mengambil data kost.</p>
                    </div>
                    <%
                        }
                    %>
                </div>
            </div>
        </section>
                
        <!-- Features Section -->
        <section class="features-section">
            <div class="container">
                <h2 class="text-center mb-5">Mengapa Memilih KostHunt?</h2>
                <div class="row">
                    <div class="col-md-4">
                        <div class="feature-card">
                            <i class="fas fa-search feature-icon"></i>
                            <h4>Cari Kost Mudah</h4>
                            <p>Temukan kost sesuai kriteria dengan fitur pencarian yang canggih</p>
                        </div>
                    </div>
                    <div class="col-md-4">
                        <div class="feature-card">
                            <i class="fas fa-shield-alt feature-icon"></i>
                            <h4>Aman & Terpercaya</h4>
                            <p>Semua kost telah diverifikasi untuk keamanan dan kenyamanan Anda</p>
                        </div>
                    </div>
                    <div class="col-md-4">
                        <div class="feature-card">
                            <i class="fas fa-map-marker-alt feature-icon"></i>
                            <h4>Lokasi Strategis</h4>
                            <p>Kost dengan lokasi strategis dekat kampus dan fasilitas umum</p>
                        </div>
                    </div>
                </div>
            </div>
        </section>
        

        <!-- Tenant Dashboard Section -->
        <%
            String user = (String) session.getAttribute("user");
            String userRole = (String) session.getAttribute("role");
            if (user != null && "tenant".equals(userRole)) {
        %>
        <section class="main-container">
            <div class="container">
                <h2>Selamat Datang, <%= user %>!</h2>
                <h3>Temukan Kos Impian Anda</h3>
            </div>
        </section>
        <%
            }
        %>

        <!-- Scripts -->
        <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
        <script>
            // Add smooth scrolling
            document.querySelectorAll('a[href^="#"]').forEach(anchor => {
                anchor.addEventListener('click', function (e) {
                    e.preventDefault();
                    document.querySelector(this.getAttribute('href')).scrollIntoView({
                        behavior: 'smooth'
                    });
                });
            });
        </script>
    </body>
</html>