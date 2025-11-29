<%-- 
    Document   : addKost
    Created on : 31 Okt 2025, 02.13.29
    Author     : Ghaisani
--%>

<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Tambah Kost Baru</title>
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
        
        .navbar {
            background-color: #4A90E2;
            padding: 15px 30px;
            display: flex;
            justify-content: space-between;
            align-items: center;
            box-shadow: 0 2px 4px rgba(0,0,0,0.1);
        }
        
        .navbar-brand {
            color: white;
            font-size: 24px;
            font-weight: bold;
        }
        
        .navbar-user {
            color: white;
            display: flex;
            align-items: center;
            gap: 8px;
        }
        
        .navbar-user::before {
            content: "👤";
        }
        
        .navbar-user::after {
            content: "▼";
            font-size: 12px;
        }
        
        .container {
            max-width: 700px;
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
            content: "⊕";
            font-size: 24px;
        }
        
        .card-body {
            padding: 30px;
        }
        
        .form-row {
            display: grid;
            grid-template-columns: 1fr 1fr;
            gap: 15px;
            margin-bottom: 20px;
        }
        
        .form-group {
            margin-bottom: 20px;
        }
        
        .form-group-full {
            grid-column: 1 / -1;
        }
        
        label {
            display: block;
            margin-bottom: 8px;
            color: #333;
            font-size: 14px;
        }
        
        input[type="text"],
        input[type="number"],
        textarea,
        select {
            width: 100%;
            padding: 12px;
            border: 1px solid #ddd;
            border-radius: 4px;
            font-size: 14px;
            transition: border-color 0.3s;
        }
        
        input:focus,
        textarea:focus,
        select:focus {
            outline: none;
            border-color: #4A90E2;
        }
        
        textarea {
            resize: vertical;
            min-height: 80px;
        }
        
        select {
            appearance: none;
            background-image: url("data:image/svg+xml,%3Csvg xmlns='http://www.w3.org/2000/svg' width='12' height='12' viewBox='0 0 12 12'%3E%3Cpath fill='%23333' d='M6 9L1 4h10z'/%3E%3C/svg%3E");
            background-repeat: no-repeat;
            background-position: right 12px center;
            cursor: pointer;
        }
        
        .facilities-grid {
            display: grid;
            grid-template-columns: repeat(3, 1fr);
            gap: 15px;
            margin-top: 10px;
        }
        
        .checkbox-item {
            display: flex;
            align-items: center;
            gap: 8px;
        }
        
        .checkbox-item input[type="checkbox"] {
            width: 18px;
            height: 18px;
            cursor: pointer;
        }
        
        .checkbox-item label {
            margin: 0;
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
        
        .btn-primary::before {
            content: "💾";
        }
        
        .btn-danger {
            background-color: #E74C3C;
            color: white;
        }
        
        .btn-danger:hover {
            background-color: #c0392b;
        }
        
        .btn-danger::before {
            content: "✕";
        }
        
        @media (max-width: 768px) {
            .form-row {
                grid-template-columns: 1fr;
            }
            
            .facilities-grid {
                grid-template-columns: 1fr;
            }
        }
    </style>
</head>
<body>
    <!-- Navbar -->
    <div class="navbar">
        <div class="navbar-brand">KostHunt</div>
        <div class="navbar-user">
            <%= session.getAttribute("userName") != null ? session.getAttribute("userName") : "John Doe" %>
        </div>
    </div>

    <!-- Main Content -->
    <div class="container">
        <div class="card">
            <div class="card-header">
                Tambah Kost Baru
            </div>
            <div class="card-body">
                <form action="kost" method="POST">
                    <input type="hidden" name="action" value="add">
                    
                    <div class="form-row">
                        <div class="form-group">
                            <label for="name">Nama Kost</label>
                            <input type="text" 
                                   name="name" 
                                   id="name" 
                                   required>
                        </div>
                        
                        <div class="form-group">
                            <label for="type">Tipe Kost</label>
                            <select name="type" id="type" required>
                                <option value="">Pilih Tipe</option>
                                <option value="Putra">Putra</option>
                                <option value="Putri">Putri</option>
                                <option value="Campur">Campur</option>
                            </select>
                        </div>
                    </div>
                    
                    <div class="form-group">
                        <label for="address">Alamat Lengkap</label>
                        <textarea name="address" 
                                  id="address" 
                                  required></textarea>
                    </div>
                    
                    <div class="form-group">
                        <label for="location">Lokasi (Area)</label>
                        <input type="text" 
                               name="location" 
                               id="location" 
                               required>
                    </div>
                    
                    <div class="form-group">
                        <label for="description">Deskripsi</label>
                        <textarea name="description" 
                                  id="description" 
                                  required></textarea>
                    </div>
                    
                    <div class="form-row">
                        <div class="form-group">
                            <label for="price">Harga per Bulan</label>
                            <input type="number" 
                                   name="price" 
                                   id="price" 
                                   placeholder="Rp" 
                                   min="0"
                                   required>
                        </div>
                        
                        <div class="form-group">
                            <label for="imageUrl">Gambar Kost (URL)</label>
                            <input type="text" 
                                   name="imageUrl" 
                                   id="imageUrl" 
                                   placeholder="https://example.com/gambar-kost.jpg">
                        </div>
                    </div>
                    
                    <div class="form-group">
                        <label>Fasilitas</label>
                        <div class="facilities-grid">
                            <div class="checkbox-item">
                                <input type="checkbox" name="facility" value="Kamar Mandi Dalam" id="kmDalam">
                                <label for="kmDalam">Kamar Mandi Dalam</label>
                            </div>
                            <div class="checkbox-item">
                                <input type="checkbox" name="facility" value="AC" id="ac">
                                <label for="ac">AC</label>
                            </div>
                            <div class="checkbox-item">
                                <input type="checkbox" name="facility" value="WiFi" id="wifi">
                                <label for="wifi">WiFi</label>
                            </div>
                            <div class="checkbox-item">
                                <input type="checkbox" name="facility" value="Dapur" id="dapur">
                                <label for="dapur">Dapur</label>
                            </div>
                            <div class="checkbox-item">
                                <input type="checkbox" name="facility" value="Parkir" id="parkir">
                                <label for="parkir">Parkir</label>
                            </div>
                            <div class="checkbox-item">
                                <input type="checkbox" name="facility" value="CCTV" id="cctv">
                                <label for="cctv">CCTV</label>
                            </div>
                        </div>
                    </div>
                    
                    <input type="hidden" name="facilities" id="facilitiesInput">
                    
                    <div class="button-group">
                        <button type="submit" class="btn btn-primary">
                            Simpan Kost
                        </button>
                        <button type="button" class="btn btn-danger" onclick="window.location.href='ownerDashboard'">
                            Batal
                        </button>
                    </div>
                </form>
            </div>
        </div>
    </div>

    <script>
        // Handle facilities checkboxes
        document.querySelector('form').addEventListener('submit', function(e) {
            const checkboxes = document.querySelectorAll('input[name="facility"]:checked');
            const facilities = Array.from(checkboxes).map(cb => cb.value).join(', ');
            document.getElementById('facilitiesInput').value = facilities;
        });
    </script>
</body>
</html>
