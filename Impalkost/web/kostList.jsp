<%-- 
    Document   : kostList
    Created on : 20 Nov 2025, 23.09.59
    Author     : Ghaisani
--%>
<%@page import="model.Kost"%>
<%@page import="java.util.List"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="id">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Hasil Pencarian - KostHunt</title>
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
            --border: #e2e8f0;
        }

        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
        }

        body {
            font-family: 'Plus Jakarta Sans', sans-serif;
            background-color: var(--light-bg);
            color: var(--text-color);
        }

        /* Navbar */
        .navbar {
            background-color: var(--primary-color);
            padding: 1rem 2rem;
            box-shadow: 0 2px 8px rgba(0,0,0,0.1);
        }

        .navbar-content {
            max-width: 1400px;
            margin: 0 auto;
            display: flex;
            justify-content: space-between;
            align-items: center;
        }

        .navbar-brand {
            color: white;
            font-size: 1.5rem;
            font-weight: 700;
            text-decoration: none;
        }

        .navbar-right {
            display: flex;
            align-items: center;
            gap: 1.5rem;
        }

        .search-box {
            position: relative;
        }

        .search-box input {
            padding: 0.5rem 2.5rem 0.5rem 1rem;
            border: none;
            border-radius: 0.5rem;
            width: 250px;
            font-size: 0.875rem;
        }

        .search-box button {
            position: absolute;
            right: 0.5rem;
            top: 50%;
            transform: translateY(-50%);
            background: none;
            border: none;
            color: var(--primary-color);
            cursor: pointer;
        }

        .navbar-user {
            color: white;
            display: flex;
            align-items: center;
            gap: 0.5rem;
            cursor: pointer;
        }

        /* Main Container */
        .main-container {
            max-width: 1400px;
            margin: 2rem auto;
            padding: 0 2rem;
        }

        /* Page Header */
        .page-header {
            margin-bottom: 2rem;
        }

        .page-title {
            font-size: 2rem;
            font-weight: 700;
            margin-bottom: 1.5rem;
        }

        /* Filters */
        .filters-row {
            background: white;
            padding: 1.5rem;
            border-radius: 1rem;
            box-shadow: 0 2px 8px rgba(0,0,0,0.08);
            margin-bottom: 2rem;
        }

        .filters-grid {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(200px, 1fr));
            gap: 1rem;
            align-items: end;
        }

        .filter-group {
            display: flex;
            flex-direction: column;
            gap: 0.5rem;
        }

        .filter-label {
            font-size: 0.875rem;
            font-weight: 600;
            color: var(--text-color);
        }

        .filter-input,
        .filter-select {
            padding: 0.75rem 1rem;
            border: 1px solid var(--border);
            border-radius: 0.5rem;
            font-size: 0.875rem;
            font-family: inherit;
        }

        .filter-input:focus,
        .filter-select:focus {
            outline: none;
            border-color: var(--primary-color);
        }

        .btn-filter {
            padding: 0.75rem 2rem;
            background-color: var(--primary-color);
            color: white;
            border: none;
            border-radius: 0.5rem;
            font-weight: 600;
            cursor: pointer;
            transition: all 0.3s;
        }

        .btn-filter:hover {
            background-color: var(--primary-dark);
        }

        /* Results Info */
        .results-info {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 1.5rem;
        }

        .results-count {
            font-size: 0.95rem;
            color: var(--secondary-color);
        }

        .sort-dropdown {
            padding: 0.5rem 1rem;
            border: 1px solid var(--border);
            border-radius: 0.5rem;
            font-size: 0.875rem;
            cursor: pointer;
        }

        /* Kost Grid */
        .kost-grid {
            display: grid;
            grid-template-columns: repeat(auto-fill, minmax(320px, 1fr));
            gap: 1.5rem;
            margin-bottom: 2rem;
        }

        /* Kost Card */
        .kost-card {
            background: white;
            border-radius: 1rem;
            overflow: hidden;
            box-shadow: 0 2px 8px rgba(0,0,0,0.08);
            transition: all 0.3s;
            cursor: pointer;
        }

        .kost-card:hover {
            transform: translateY(-4px);
            box-shadow: 0 8px 16px rgba(0,0,0,0.12);
        }

        .kost-image {
            width: 100%;
            height: 200px;
            object-fit: cover;
            background: var(--border);
            display: flex;
            align-items: center;
            justify-content: center;
            color: var(--secondary-color);
            font-size: 0.875rem;
        }

        .kost-image img {
            width: 100%;
            height: 100%;
            object-fit: cover;
        }

        .kost-content {
            padding: 1.25rem;
        }

        .kost-name {
            font-size: 1.125rem;
            font-weight: 700;
            margin-bottom: 0.5rem;
            color: var(--text-color);
        }

        .kost-location {
            display: flex;
            align-items: center;
            gap: 0.5rem;
            color: var(--secondary-color);
            font-size: 0.875rem;
            margin-bottom: 0.75rem;
        }

        .kost-location i {
            color: var(--primary-color);
        }

        .kost-rating {
            display: flex;
            align-items: center;
            gap: 0.25rem;
            margin-bottom: 1rem;
        }

        .kost-rating i {
            color: #f59e0b;
        }

        .rating-value {
            font-weight: 600;
            color: var(--text-color);
        }

        .kost-price {
            font-size: 1.25rem;
            font-weight: 700;
            color: var(--primary-color);
            margin-bottom: 1rem;
        }

        .kost-price span {
            font-size: 0.875rem;
            font-weight: 400;
            color: var(--secondary-color);
        }

        .btn-detail {
            width: 100%;
            padding: 0.75rem;
            background: white;
            color: var(--primary-color);
            border: 2px solid var(--primary-color);
            border-radius: 0.5rem;
            font-weight: 600;
            cursor: pointer;
            transition: all 0.3s;
            text-decoration: none;
            display: block;
            text-align: center;
        }

        .btn-detail:hover {
            background: var(--primary-color);
            color: white;
        }

        /* Empty State */
        .empty-state {
            text-align: center;
            padding: 4rem 2rem;
            background: white;
            border-radius: 1rem;
            box-shadow: 0 2px 8px rgba(0,0,0,0.08);
        }

        .empty-state i {
            font-size: 4rem;
            color: var(--secondary-color);
            opacity: 0.5;
            margin-bottom: 1rem;
        }

        .empty-state h3 {
            font-size: 1.5rem;
            font-weight: 700;
            margin-bottom: 0.5rem;
        }

        .empty-state p {
            color: var(--secondary-color);
        }

        @media (max-width: 768px) {
            .kost-grid {
                grid-template-columns: 1fr;
            }

            .filters-grid {
                grid-template-columns: 1fr;
            }

            .results-info {
                flex-direction: column;
                gap: 1rem;
                align-items: stretch;
            }
        }
    </style>
</head>
<body>
    <jsp:include page="header.jsp" />

    <!-- Main Container -->
    <div class="main-container">
        <!-- Page Header -->
        <div class="page-header">
            <h1 class="page-title">Hasil Pencarian</h1>
        </div>

        <!-- Filters -->
        <div class="filters-row">
            <form action="kost" method="GET" class="filters-grid">
                <input type="hidden" name="action" value="search">
                
                <div class="filter-group">
                    <label class="filter-label">Cari Nama/Alamat</label>
                    <input type="text" 
                           name="query" 
                           class="filter-input" 
                           placeholder="Contoh: Kost Mawar"
                           value="<%= request.getParameter("query") != null ? request.getParameter("query") : "" %>">
                </div>

                <div class="filter-group">
                    <label class="filter-label">Lokasi</label>
                    <input type="text" 
                           name="location" 
                           class="filter-input" 
                           placeholder="Contoh: Depok"
                           value="<%= request.getParameter("location") != null ? request.getParameter("location") : "" %>">
                </div>

                <div class="filter-group">
                    <label class="filter-label">Rentang Harga</label>
                    <select name="priceRange" class="filter-select">
                        <option value="">Semua Harga</option>
                        <option value="0-1000000">< Rp 1.000.000</option>
                        <option value="1000000-2000000">Rp 1.000.000 - 2.000.000</option>
                        <option value="2000000-5000000">Rp 2.000.000 - 5.000.000</option>
                        <option value="5000000-999999999">> Rp 5.000.000</option>
                    </select>
                </div>

                <div class="filter-group">
                    <label class="filter-label" style="opacity: 0;">Action</label>
                    <button type="submit" class="btn-filter">Cari</button>
                </div>
            </form>
        </div>

        <%
            List<Kost> kostList = (List<Kost>) request.getAttribute("kostList");
            String searchKeyword = (String) request.getAttribute("searchKeyword");
        %>

        <!-- Results Info -->
        <div class="results-info">
            <div class="results-count">
                Menampilkan <%= kostList != null ? kostList.size() : 0 %> dari <%= kostList != null ? kostList.size() : 0 %> hasil
            </div>
            <select class="sort-dropdown">
                <option>Urutkan...</option>
                <option>Harga Terendah</option>
                <option>Harga Tertinggi</option>
                <option>Rating Tertinggi</option>
            </select>
        </div>

        <!-- Kost Grid -->
        <% if (kostList != null && !kostList.isEmpty()) { %>
        <div class="kost-grid">
            <% for (Kost kost : kostList) { %>
            <div class="kost-card" onclick="window.location.href='kost?action=detail&id=<%= kost.getId() %>'">
                <div class="kost-image">
                    <% if (kost.getImageUrl() != null && !kost.getImageUrl().isEmpty()) { %>
                        <img src="<%= kost.getImageUrl() %>" alt="<%= kost.getName() %>">
                    <% } else { %>
                        <div style="width: 100%; height: 100%; display: flex; align-items: center; justify-content: center; background: #e2e8f0;">
                            No Image
                        </div>
                    <% } %>
                </div>
                
                <div class="kost-content">
                    <h3 class="kost-name"><%= kost.getName() %></h3>
                    
                    <div class="kost-location">
                        <i class="fas fa-map-marker-alt"></i>
                        <span><%= kost.getLocation() %></span>
                    </div>
                    
                    <div class="kost-rating">
                        <i class="fas fa-star"></i>
                        <span class="rating-value"><%= String.format("%.1f", kost.getAvgRating()) %></span>
                    </div>
                    
                    <div class="kost-price">
                        Rp <%= String.format("%,.0f", kost.getPrice()) %> <span>/ bulan</span>
                    </div>
                    
                    <a href="kost?action=detail&id=<%= kost.getId() %>" class="btn-detail" onclick="event.stopPropagation()">
                        Lihat Detail
                    </a>
                </div>
            </div>
            <% } %>
        </div>
        <% } else { %>
        <!-- Empty State -->
        <div class="empty-state">
            <i class="fas fa-search"></i>
            <h3>Tidak Ada Hasil</h3>
            <p>Tidak ditemukan kost yang sesuai dengan pencarian Anda.</p>
            <p>Coba gunakan kata kunci lain atau ubah filter pencarian.</p>
        </div>
        <% } %>
    </div>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
