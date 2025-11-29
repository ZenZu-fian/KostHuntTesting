<%-- 
    Document   : ownerDashboard
    Created on : 30 Okt 2025, 20.05.56
    Author     : Ghaisani
--%>

<%@page import="model.Kost"%>
<%@page import="java.util.List"%>
<%@page import="java.util.Map"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="id">
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Owner Dashboard - Impalkost</title>
        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
        <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css" rel="stylesheet">
        <link href="https://fonts.googleapis.com/css2?family=Plus+Jakarta+Sans:wght@300;400;500;600;700&display=swap" rel="stylesheet">
        <style>
            :root {
                --primary-color: #2563eb;
                --primary-dark: #1d4ed8;
                --secondary-color: #64748b;
                --accent-color: #f59e0b;
                --text-color: #1e293b;
                --light-bg: #f8fafc;
                --white: #ffffff;
                --success: #22c55e;
                --warning: #f59e0b;
                --danger: #ef4444;
                --info: #3b82f6;
                --shadow-sm: 0 1px 2px 0 rgb(0 0 0 / 0.05);
                --shadow: 0 4px 6px -1px rgb(0 0 0 / 0.1);
                --shadow-lg: 0 10px 15px -3px rgb(0 0 0 / 0.1);
            }

            body {
                margin: 0;
                font-family: 'Plus Jakarta Sans', sans-serif;
                background-color: var(--light-bg);
                color: var(--text-color);
                min-height: 100vh;
            }

            .main-container {
                padding: 2rem;
                max-width: 1400px;
                margin: 0 auto;
            }

            .dashboard-header {
                display: flex;
                justify-content: space-between;
                align-items: center;
                margin-bottom: 2rem;
                padding-bottom: 1rem;
                border-bottom: 2px solid rgba(0, 0, 0, 0.1);
            }

            .dashboard-header h2 {
                font-size: 1.75rem;
                font-weight: 700;
                color: var(--text-color);
                margin: 0;
            }

            .btn-add {
                background-color: var(--primary-color);
                color: var(--white);
                padding: 0.75rem 1.5rem;
                border-radius: 0.75rem;
                font-weight: 600;
                text-decoration: none;
                display: inline-flex;
                align-items: center;
                gap: 0.5rem;
                transition: all 0.3s cubic-bezier(0.4, 0, 0.2, 1);
                border: none;
                font-size: 0.875rem;
                position: relative;
                overflow: hidden;
            }

            .btn-add::after {
                content: '';
                position: absolute;
                top: 50%;
                left: 50%;
                width: 0;
                height: 0;
                background: rgba(255, 255, 255, 0.2);
                border-radius: 50%;
                transform: translate(-50%, -50%);
                transition: width 0.6s ease, height 0.6s ease;
            }

            .btn-add:hover::after {
                width: 300px;
                height: 300px;
            }

            .btn-add:hover {
                background-color: var(--primary-dark);
                transform: translateY(-2px);
                color: var(--white);
            }

            .kost-container {
                display: grid;
                grid-template-columns: repeat(auto-fill, minmax(320px, 1fr));
                gap: 1.5rem;
                margin-top: 1.5rem;
            }

            .kost-card {
                background-color: var(--white);
                border-radius: 1rem;
                overflow: hidden;
                box-shadow: var(--shadow);
                transition: all 0.3s cubic-bezier(0.4, 0, 0.2, 1);
                display: flex;
                flex-direction: column;
                height: 100%;
                transform: translateY(0);
                animation: fadeIn 0.5s ease-out;
            }

            .kost-card:hover {
                transform: translateY(-5px);
                box-shadow: var(--shadow-lg);
            }

            .kost-card-img {
                width: 100%;
                height: 200px;
                object-fit: cover;
                transition: transform 0.3s cubic-bezier(0.4, 0, 0.2, 1);
            }

            .kost-card:hover .kost-card-img {
                transform: scale(1.05);
            }

            .kost-card-body {
                padding: 1.25rem;
                flex-grow: 1;
            }

            .kost-card-body h4 {
                margin: 0 0 0.5rem 0;
                font-size: 1.25rem;
                font-weight: 600;
                color: var(--text-color);
            }

            .kost-card-body p {
                margin: 0;
                color: var(--secondary-color);
                font-size: 0.875rem;
                line-height: 1.5;
            }

            .kost-card-footer {
                background-color: var(--light-bg);
                padding: 1rem;
                display: flex;
                justify-content: flex-end;
                gap: 0.75rem;
                border-top: 1px solid rgba(0, 0, 0, 0.1);
            }

            .btn-action {
                text-decoration: none;
                color: var(--white);
                padding: 0.5rem 1rem;
                border-radius: 0.5rem;
                font-size: 0.875rem;
                font-weight: 500;
                display: inline-flex;
                align-items: center;
                gap: 0.375rem;
                transition: all 0.3s cubic-bezier(0.4, 0, 0.2, 1);
                position: relative;
                overflow: hidden;
                border: none;
            }

            .btn-action::after {
                content: '';
                position: absolute;
                top: 50%;
                left: 50%;
                width: 0;
                height: 0;
                background: rgba(255, 255, 255, 0.2);
                border-radius: 50%;
                transform: translate(-50%, -50%);
                transition: width 0.6s ease, height 0.6s ease;
            }

            .btn-action:hover::after {
                width: 300px;
                height: 300px;
            }

            .btn-action:hover {
                transform: translateY(-2px);
                color: var(--white);
            }

            .btn-info {
                background-color: var(--info);
            }

            .btn-info:hover {
                background-color: #2563eb;
            }

            .btn-edit {
                background-color: var(--warning);
            }

            .btn-edit:hover {
                background-color: #d97706;
            }

            .btn-delete {
                background-color: var(--danger);
            }

            .btn-delete:hover {
                background-color: #dc2626;
            }

            @keyframes fadeIn {
                from {
                    opacity: 0;
                    transform: translateY(20px);
                }
                to {
                    opacity: 1;
                    transform: translateY(0);
                }
            }

            .empty-state {
                text-align: center;
                padding: 3rem;
                background-color: var(--white);
                border-radius: 1rem;
                box-shadow: var(--shadow);
                margin-top: 2rem;
                animation: fadeIn 0.5s ease-out;
            }

            .empty-state p {
                color: var(--secondary-color);
                font-size: 1rem;
                margin-bottom: 1.5rem;
            }

            .tenant-section {
                margin-top: 3rem;
                animation: fadeIn 0.5s ease-out;
            }

            .tenant-section h2 {
                font-size: 1.75rem;
                font-weight: 700;
                color: var(--text-color);
                margin-bottom: 1.5rem;
            }

            .tenant-table {
                background-color: var(--white);
                border-radius: 1rem;
                box-shadow: var(--shadow);
                overflow: hidden;
            }

            .tenant-table th {
                background-color: var(--light-bg);
                font-weight: 600;
                padding: 1rem;
                color: var(--text-color);
            }

            .tenant-table td {
                padding: 1rem;
                vertical-align: middle;
            }

            .tenant-table tr:hover {
                background-color: var(--light-bg);
            }

            .tenant-kost {
                font-weight: 600;
                color: var(--primary-color);
            }

            .tenant-room {
                font-weight: 500;
                color: var(--text-color);
            }

            .btn-whatsapp {
                background-color: #25D366;
                border-color: #25D366;
                color: white;
            }

            .btn-whatsapp:hover {
                background-color: #1DAE53;
                border-color: #1DAE53;
                color: white;
            }
            
            /* Riwayat Pembayaran Section */
            .payment-section {
                margin-top: 3rem;
                animation: fadeIn 0.5s ease-out;
            }
            
            .payment-section-header {
                background-color: var(--primary-color);
                color: white;
                padding: 1rem 1.5rem;
                border-radius: 1rem 1rem 0 0;
                font-weight: 600;
                font-size: 1.1rem;
            }
            
            .payment-table-container {
                background-color: var(--white);
                border-radius: 0 0 1rem 1rem;
                box-shadow: var(--shadow);
                overflow: hidden;
            }

            @media (max-width: 768px) {
                .main-container {
                    padding: 1rem;
                }

                .dashboard-header {
                    flex-direction: column;
                    gap: 1rem;
                    align-items: flex-start;
                }

                .kost-container {
                    grid-template-columns: 1fr;
                }

                .kost-card-footer {
                    flex-wrap: wrap;
                }

                .btn-action {
                    flex: 1;
                    justify-content: center;
                }

                .tenant-table {
                    display: block;
                    overflow-x: auto;
                    white-space: nowrap;
                }
            }
        </style>
    </head>
    <body>
        <jsp:include page="header.jsp" />

        <div class="main-container">
            <% if (request.getParameter("success") != null) { 
                String successType = request.getParameter("success");
                String message = "";
                if ("add".equals(successType)) {
                    message = "Kost berhasil ditambahkan!";
                } else if ("edit".equals(successType)) {
                    message = "Kost berhasil diupdate!";
                } else if ("delete".equals(successType)) {
                    message = "Kost berhasil dihapus!";
                }
            %>
                <div class="alert alert-success alert-dismissible fade show" role="alert">
                    <i class="fas fa-check-circle me-2"></i><%= message %>
                    <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
                </div>
            <% } %>
            
            <% if (request.getParameter("error") != null) { %>
                <div class="alert alert-danger alert-dismissible fade show" role="alert">
                    <i class="fas fa-exclamation-circle me-2"></i>Terjadi kesalahan. Silakan coba lagi.
                    <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
                </div>
            <% } %>

            <div class="dashboard-header">
                <h2>Kelola Kost Anda</h2>
                <a href="kost?action=showAdd" class="btn-add">
                    <i class="fas fa-plus"></i>
                    Tambah Kost
                </a>
            </div>

            <div class="kost-container">
                <%
                    List<Kost> kostList = (List<Kost>) request.getAttribute("kostList");
                    if (kostList != null && !kostList.isEmpty()) {
                        for (Kost kost : kostList) {
                %>
                <div class="kost-card">
                    <img class="kost-card-img" 
                         src="<%= kost.getImageUrl() != null && !kost.getImageUrl().isEmpty() ? kost.getImageUrl() : "https://placehold.co/600x400/2563eb/FFFFFF?text=" + java.net.URLEncoder.encode(kost.getName(), "UTF-8") %>" 
                         alt="Foto <%= kost.getName() %>">
                    <div class="kost-card-body">
                        <div class="d-flex justify-content-between align-items-baseline mb-2">
                            <h4><%= kost.getName() %></h4>
                            <span class="d-flex align-items-center" style="color: #ffc107;">
                                <i class="fas fa-star fa-sm me-1"></i>
                                <span class="fw-bold"><%= String.format("%.1f", kost.getAvgRating()) %></span>
                            </span>
                        </div>
                        <p class="mb-3"><i class="fas fa-map-marker-alt me-1"></i><%= kost.getAddress() %></p>
                        
                        <!-- Tombol Lihat Detail -->
                        <a href="kost?action=detail&id=<%= kost.getId() %>" class="btn btn-outline-primary w-100">
                            Lihat Detail
                        </a>
                    </div>
                    <div class="kost-card-footer">
                        <a href="RoomControllers?action=list&kostId=<%= kost.getId() %>" class="btn-action btn-info">
                            <i class="fas fa-door-open"></i>
                            Kelola Kamar
                        </a>
                            
                        <a href="kost?action=showEdit&id=<%= kost.getId() %>" class="btn-action btn-edit">
                            <i class="fas fa-pencil-alt"></i>
                            Edit
                        </a>
                        <form action="kost" method="POST" class="d-inline" 
                              onsubmit="return confirm('Apakah Anda yakin ingin menghapus kost ini? Tindakan ini tidak dapat dibatalkan.');">
                            <input type="hidden" name="action" value="delete">
                            <input type="hidden" name="id" value="<%= kost.getId() %>">
                            <button type="submit" class="btn-action btn-delete">
                                <i class="fas fa-trash-alt"></i>
                                Hapus
                            </button>
                        </form>
                    </div>
                </div>
                <%
                        }
                    } else {
                %>
                <div class="empty-state" style="grid-column: 1 / -1;">
                    <i class="fas fa-home fa-4x mb-3" style="color: var(--secondary-color); opacity: 0.3;"></i>
                    <p>Anda belum memiliki data kos. Silakan klik tombol 'Tambah Kost' untuk memulai.</p>
                    <a href="kost?action=showAdd" class="btn-add">
                        <i class="fas fa-plus"></i>
                        Tambah Kost
                    </a>
                </div>
                <%
                    }
                %>
            </div>

            <div class="tenant-section">
                <h2>Daftar Penyewa</h2>
                <%
                    List<Map<String, Object>> tenantList = (List<Map<String, Object>>) request.getAttribute("tenantList");
                    if (tenantList != null && !tenantList.isEmpty()) {
                %>
                <div class="tenant-table">
                    <table class="table table-hover mb-0">
                        <thead>
                            <tr>
                                <th>Nama Penyewa</th>
                                <th>Kost</th>
                                <th>No. Kamar</th>
                                <th>Tipe Kamar</th>
                                <th>Email</th>
                                <th>No. Telepon</th>
                            </tr>
                        </thead>
                        <tbody>
                            <% for (Map<String, Object> tenant : tenantList) { %>
                            <tr>
                                <td><strong><%= tenant.get("name") %></strong></td>
                                <td>
                                    <div class="tenant-kost"><%= tenant.get("kostName") %></div>
                                    <div class="text-muted small"><%= tenant.get("kostAddress") %></div>
                                </td>
                                <td><span class="tenant-room"><%= tenant.get("roomNumber") %></span></td>
                                <td><%= tenant.get("roomType") %></td>
                                <td><%= tenant.get("email") %></td>
                                <td>
                                    <% if (tenant.get("phone") != null && !tenant.get("phone").toString().isEmpty()) { %>
                                        <a href="https://wa.me/<%= tenant.get("phone").toString().replaceAll("[^0-9]", "") %>" 
                                           class="btn btn-whatsapp btn-sm" target="_blank">
                                            <i class="fab fa-whatsapp"></i> <%= tenant.get("phone") %>
                                        </a>
                                    <% } else { %>
                                        <span class="text-muted">-</span>
                                    <% } %>
                                </td>
                            </tr>
                            <% } %>
                        </tbody>
                    </table>
                </div>
                <% } else { %>
                <div class="empty-state">
                    <i class="fas fa-users fa-4x mb-3" style="color: var(--secondary-color); opacity: 0.3;"></i>
                    <p>Belum ada penyewa yang terdaftar di kost Anda.</p>
                </div>
                <% } %>
            </div>

            <!-- Riwayat Pembayaran -->
            <div class="payment-section">
                <div class="payment-section-header">
                    Riwayat Pembayaran
                </div>
                <div class="payment-table-container">
                    <% 
                        List<Map<String, Object>> unpaidTenantList = (List<Map<String, Object>>) request.getAttribute("unpaidTenantList");
                        if (unpaidTenantList != null && !unpaidTenantList.isEmpty()) {
                    %>
                    <table class="table table-hover mb-0">
                        <thead>
                            <tr>
                                <th>Tanggal Pembayaran</th>
                                <th>Nama Tenant</th>
                                <th>Kamar</th>
                                <th>Jumlah</th>
                            </tr>
                        </thead>
                        <tbody>
                            <% for (Map<String, Object> payment : unpaidTenantList) { %>
                            <tr>
                                <td><%= payment.get("lastPaymentDate") != null ? payment.get("lastPaymentDate") : "Belum ada" %></td>
                                <td><%= payment.get("name") %></td>
                                <td><%= payment.get("roomNumber") %></td>
                                <td>Rp <%= String.format("%,d", 1000000) %></td>
                            </tr>
                            <% } %>
                        </tbody>
                    </table>
                    <% } else { %>
                    <div class="empty-state">
                        <i class="fas fa-check-circle fa-4x mb-3" style="color: var(--success);"></i>
                        <p>Semua penyewa sudah membayar tepat waktu. Hebat!</p>
                    </div>
                    <% } %>
                </div>
            </div>
        </div>

        <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
        <script>
            // Auto dismiss alerts after 5 seconds
            setTimeout(function() {
                const alerts = document.querySelectorAll('.alert');
                alerts.forEach(alert => {
                    const bsAlert = new bootstrap.Alert(alert);
                    bsAlert.close();
                });
            }, 5000);
        </script>
    </body>
</html>
