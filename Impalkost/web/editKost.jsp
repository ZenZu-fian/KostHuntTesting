<%-- 
    Document   : editKost
    Created on : 20 Nov 2025, 21.43.54
    Author     : Ghaisani
--%>

<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="model.Kost" %>
<!DOCTYPE html>
<html lang="id">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Edit Kost - KostHunt</title>
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

        .navbar-user {
            color: white;
            display: flex;
            align-items: center;
            gap: 0.5rem;
        }

        .container-main {
            max-width: 800px;
            margin: 2rem auto;
            padding: 0 1.5rem;
        }

        .form-card {
            background: white;
            border-radius: 1rem;
            box-shadow: 0 4px 12px rgba(0,0,0,0.1);
            overflow: hidden;
        }

        .form-header {
            background-color: var(--primary-color);
            color: white;
            padding: 1.5rem 2rem;
        }

        .form-header h2 {
            margin: 0;
            font-size: 1.5rem;
            font-weight: 600;
            display: flex;
            align-items: center;
            gap: 0.75rem;
        }

        .form-location {
            display: flex;
            align-items: center;
            gap: 0.5rem;
            margin-top: 0.5rem;
            font-size: 0.875rem;
            opacity: 0.9;
        }

        .form-body {
            padding: 2rem;
        }

        .form-group {
            margin-bottom: 1.5rem;
        }

        .form-label {
            font-weight: 600;
            margin-bottom: 0.5rem;
            display: block;
            color: var(--text-color);
        }

        .form-control, .form-select {
            width: 100%;
            padding: 0.75rem 1rem;
            border: 1px solid #e2e8f0;
            border-radius: 0.5rem;
            font-size: 0.875rem;
            transition: all 0.3s;
        }

        .form-control:focus, .form-select:focus {
            outline: none;
            border-color: var(--primary-color);
            box-shadow: 0 0 0 3px rgba(74, 144, 226, 0.1);
        }

        textarea.form-control {
            resize: vertical;
            min-height: 100px;
        }

        .image-upload-area {
            border: 2px dashed #cbd5e1;
            border-radius: 0.5rem;
            padding: 1.5rem;
            text-align: center;
            transition: all 0.3s;
            cursor: pointer;
            background-color: #f8fafc;
        }

        .image-upload-area:hover {
            border-color: var(--primary-color);
            background-color: #eff6ff;
        }

        .image-preview {
            max-width: 100%;
            height: 200px;
            object-fit: cover;
            border-radius: 0.5rem;
            margin-bottom: 1rem;
        }

        .upload-icon {
            font-size: 3rem;
            color: var(--primary-color);
            margin-bottom: 0.5rem;
        }

        .upload-text {
            color: var(--primary-color);
            font-weight: 500;
            margin-bottom: 0.25rem;
        }

        .upload-hint {
            color: var(--secondary-color);
            font-size: 0.75rem;
        }

        .input-group-text {
            background-color: var(--light-bg);
            border: 1px solid #e2e8f0;
            color: var(--text-color);
        }

        .form-hint {
            font-size: 0.75rem;
            color: var(--secondary-color);
            margin-top: 0.25rem;
        }

        .facilities-grid {
            display: grid;
            grid-template-columns: repeat(3, 1fr);
            gap: 0.75rem;
        }

        .facility-checkbox {
            display: flex;
            align-items: center;
            gap: 0.5rem;
        }

        .facility-checkbox input[type="checkbox"] {
            width: 18px;
            height: 18px;
            cursor: pointer;
            accent-color: var(--primary-color);
        }

        .facility-checkbox label {
            cursor: pointer;
            margin: 0;
            user-select: none;
        }

        .form-actions {
            display: flex;
            gap: 1rem;
            margin-top: 2rem;
            padding-top: 2rem;
            border-top: 1px solid #e2e8f0;
        }

        .btn-submit {
            flex: 1;
            background-color: var(--primary-color);
            color: white;
            padding: 0.875rem 2rem;
            border: none;
            border-radius: 0.5rem;
            font-weight: 600;
            cursor: pointer;
            transition: all 0.3s;
            display: flex;
            align-items: center;
            justify-content: center;
            gap: 0.5rem;
        }

        .btn-submit:hover {
            background-color: var(--primary-dark);
            transform: translateY(-2px);
        }

        .btn-cancel {
            flex: 1;
            background-color: var(--danger);
            color: white;
            padding: 0.875rem 2rem;
            border: none;
            border-radius: 0.5rem;
            font-weight: 600;
            cursor: pointer;
            transition: all 0.3s;
            display: flex;
            align-items: center;
            justify-content: center;
            gap: 0.5rem;
        }

        .btn-cancel:hover {
            background-color: #dc2626;
            transform: translateY(-2px);
        }

        @media (max-width: 768px) {
            .facilities-grid {
                grid-template-columns: repeat(2, 1fr);
            }

            .form-actions {
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
            if (kost == null) {
                response.sendRedirect("ownerDashboard");
                return;
            }
        %>

        <form action="kost" method="POST" id="editKostForm">
            <input type="hidden" name="action" value="edit">
            <input type="hidden" name="id" value="<%= kost.getId() %>">
            
            <div class="form-card">
                <!-- Header -->
                <div class="form-header">
                    <h2>
                        <i class="fas fa-edit"></i>
                        Edit Kost: <%= kost.getName() %>
                    </h2>
                    <div class="form-location">
                        <i class="fas fa-map-marker-alt"></i>
                        <%= kost.getLocation() %>
                    </div>
                </div>

                <!-- Body -->
                <div class="form-body">
                    <!-- Foto Kost -->
                    <div class="form-group">
                        <label class="form-label">Foto Kost</label>
                        
                        <% if (kost.getImageUrl() != null && !kost.getImageUrl().isEmpty()) { %>
                        <img src="<%= kost.getImageUrl() %>" alt="Current Image" class="image-preview">
                        <% } %>
                        
                        <div class="image-upload-area" onclick="document.getElementById('imageUrlInput').focus()">
                            <div class="upload-icon">☁️</div>
                            <div class="upload-text">Klik untuk mengubah foto kost</div>
                            <div class="upload-hint">Format: JPG, PNG, atau GIF (Max. 5MB)</div>
                        </div>
                        <input type="text" 
                               class="form-control mt-2" 
                               id="imageUrlInput"
                               name="imageUrl" 
                               value="<%= kost.getImageUrl() != null ? kost.getImageUrl() : "" %>"
                               placeholder="Masukkan URL gambar">
                    </div>

                    <!-- Nama Kost -->
                    <div class="form-group">
                        <label class="form-label">Nama Kost</label>
                        <input type="text" 
                               class="form-control" 
                               name="name" 
                               value="<%= kost.getName() %>"
                               required>
                    </div>

                    <!-- Lokasi Kost -->
                    <div class="form-group">
                        <label class="form-label">Lokasi Kost</label>
                        <input type="text" 
                               class="form-control" 
                               name="location" 
                               value="<%= kost.getLocation() %>"
                               placeholder="Contoh: Jakarta, Bandung, Surabaya"
                               required>
                        <div class="form-hint">Masukkan nama kota saja (Contoh: Jakarta, Bandung, Surabaya)</div>
                    </div>

                    <!-- Alamat Kost -->
                    <div class="form-group">
                        <label class="form-label">Alamat Kost</label>
                        <textarea class="form-control" 
                                  name="address" 
                                  required><%= kost.getAddress() %></textarea>
                    </div>

                    <!-- Deskripsi Kost -->
                    <div class="form-group">
                        <label class="form-label">Deskripsi Kost</label>
                        <textarea class="form-control" 
                                  name="description"><%= kost.getDescription() != null ? kost.getDescription() : "" %></textarea>
                    </div>

                    <!-- Tipe Kost -->
                    <div class="form-group">
                        <label class="form-label">Tipe Kost</label>
                        <select class="form-select" name="type" required>
                            <option value="">Pilih Tipe</option>
                            <option value="Putra" <%= "Putra".equals(kost.getType()) ? "selected" : "" %>>Putra</option>
                            <option value="Putri" <%= "Putri".equals(kost.getType()) ? "selected" : "" %>>Putri</option>
                            <option value="Campur" <%= "Campur".equals(kost.getType()) ? "selected" : "" %>>Campur</option>
                        </select>
                    </div>

                    <!-- Harga per Bulan -->
                    <div class="form-group">
                        <label class="form-label">Harga per Bulan</label>
                        <div class="input-group">
                            <span class="input-group-text">Rp</span>
                            <input type="number" 
                                   class="form-control" 
                                   name="price" 
                                   value="<%= (long) kost.getPrice() %>"
                                   step="50000"
                                   required>
                        </div>
                    </div>

                    <!-- Fasilitas -->
                    <div class="form-group">
                        <label class="form-label">Fasilitas</label>
                        <div class="facilities-grid">
                            <%
                                String facilities = kost.getFacilities();
                                String[] selectedFacilities = facilities != null ? facilities.split(",") : new String[0];
                                
                                // Helper method to check if facility is selected
                                boolean hasKamarMandi = false;
                                boolean hasAC = false;
                                boolean hasWiFi = false;
                                boolean hasKasur = false;
                                boolean hasLemari = false;
                                boolean hasMeja = false;
                                
                                for (String fac : selectedFacilities) {
                                    String trimmed = fac.trim();
                                    if (trimmed.equals("Kamar Mandi Dalam")) hasKamarMandi = true;
                                    if (trimmed.equals("AC")) hasAC = true;
                                    if (trimmed.equals("WiFi")) hasWiFi = true;
                                    if (trimmed.equals("Kasur")) hasKasur = true;
                                    if (trimmed.equals("Lemari")) hasLemari = true;
                                    if (trimmed.equals("Meja")) hasMeja = true;
                                }
                            %>
                            
                            <div class="facility-checkbox">
                                <input type="checkbox" id="kamarMandi" name="facility" value="Kamar Mandi Dalam" <%= hasKamarMandi ? "checked" : "" %>>
                                <label for="kamarMandi">Kamar Mandi Dalam</label>
                            </div>
                            
                            <div class="facility-checkbox">
                                <input type="checkbox" id="ac" name="facility" value="AC" <%= hasAC ? "checked" : "" %>>
                                <label for="ac">AC</label>
                            </div>
                            
                            <div class="facility-checkbox">
                                <input type="checkbox" id="wifi" name="facility" value="WiFi" <%= hasWiFi ? "checked" : "" %>>
                                <label for="wifi">WiFi</label>
                            </div>
                            
                            <div class="facility-checkbox">
                                <input type="checkbox" id="kasur" name="facility" value="Kasur" <%= hasKasur ? "checked" : "" %>>
                                <label for="kasur">Kasur</label>
                            </div>
                            
                            <div class="facility-checkbox">
                                <input type="checkbox" id="lemari" name="facility" value="Lemari" <%= hasLemari ? "checked" : "" %>>
                                <label for="lemari">Lemari</label>
                            </div>
                            
                            <div class="facility-checkbox">
                                <input type="checkbox" id="meja" name="facility" value="Meja" <%= hasMeja ? "checked" : "" %>>
                                <label for="meja">Meja</label>
                            </div>
                        </div>
                        <input type="hidden" name="facilities" id="facilitiesInput">
                    </div>

                    <!-- Action Buttons -->
                    <div class="form-actions">
                        <button type="submit" class="btn-submit">
                            <i class="fas fa-save"></i>
                            Simpan Perubahan
                        </button>
                        <button type="button" class="btn-cancel" onclick="window.location.href='ownerDashboard'">
                            <i class="fas fa-times"></i>
                            Batal
                        </button>
                    </div>
                </div>
            </div>
        </form>
    </div>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
    <script>
        // Handle facilities checkboxes
        document.getElementById('editKostForm').addEventListener('submit', function(e) {
            const checkboxes = document.querySelectorAll('input[name="facility"]:checked');
            const facilities = Array.from(checkboxes).map(cb => cb.value).join(', ');
            document.getElementById('facilitiesInput').value = facilities;
        });
    </script>
</body>
</html>
