<%-- 
    Document   : register
    Created on : 14 Okt 2025, 15.51.46
    Author     : Ghaisani
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="id">
<head>
    <meta charset="UTF-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0"/>
    <title>Register - KostHunt</title>
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
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
            --shadow-sm: 0 1px 2px 0 rgb(0 0 0 / 0.05);
            --shadow: 0 4px 6px -1px rgb(0 0 0 / 0.1);
            --shadow-lg: 0 10px 15px -3px rgb(0 0 0 / 0.1);
        }

        body {
            margin: 0;
            font-family: 'Plus Jakarta Sans', sans-serif;
            background: linear-gradient(135deg, var(--primary-color) 0%, var(--primary-dark) 100%);
            min-height: 100vh;
            display: flex;
            flex-direction: column;
            position: relative;
            overflow: hidden;
        }

        body::before {
            content: '';
            position: absolute;
            top: 0;
            left: 0;
            right: 0;
            bottom: 0;
            background: url('https://images.unsplash.com/photo-1560518883-ce09059eeffa?ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D&auto=format&fit=crop&w=2073&q=80') center/cover;
            opacity: 0.1;
            z-index: 0;
        }

        .navbar {
            background-color: var(--primary-color);
            padding: 1rem 2rem;
            box-shadow: var(--shadow-sm);
            position: sticky;
            top: 0;
            z-index: 1000;
        }

        .navbar-brand {
            font-size: 1.25rem;
            font-weight: 700;
            color: var(--white) !important;
            letter-spacing: -0.5px;
        }

        .container-register {
            flex: 1;
            display: flex;
            align-items: center;
            justify-content: center;
            padding: 2rem;
            position: relative;
            z-index: 1;
            min-height: calc(100vh - 72px); /* Subtract navbar height */
        }

        .register-card {
            background: var(--white);
            padding: 1.75rem;
            border-radius: 1.25rem;
            box-shadow: var(--shadow-lg);
            width: 100%;
            max-width: 400px;
            margin: 0 auto; /* Remove top/bottom margin */
            transition: all 0.3s ease;
            animation: fadeInUp 0.8s ease-out;
        }

        .register-card:hover {
            transform: translateY(-5px);
            box-shadow: 0 20px 25px -5px rgb(0 0 0 / 0.1), 0 8px 10px -6px rgb(0 0 0 / 0.1);
        }

        .register-card h2 {
            margin-bottom: 1.25rem;
            font-size: 1.25rem;
            text-align: center;
            color: var(--text-color);
            font-weight: 600;
        }

        .form-label {
            font-weight: 500;
            color: var(--text-color);
            margin-bottom: 0.25rem;
            font-size: 0.8125rem;
        }

        .form-control, .form-select {
            padding: 0.625rem 0.875rem;
            border: 2px solid #e2e8f0;
            border-radius: 0.75rem;
            font-size: 0.8125rem;
            transition: all 0.3s ease;
        }

        .form-control:focus, .form-select:focus {
            border-color: var(--primary-color);
            box-shadow: 0 0 0 4px rgba(37, 99, 235, 0.1);
        }

        .btn-primary {
            background-color: var(--primary-color);
            border: none;
            padding: 0.625rem 1.25rem;
            border-radius: 0.75rem;
            font-weight: 600;
            transition: all 0.3s ease;
            width: 100%;
            margin-top: 1rem;
            font-size: 0.8125rem;
        }

        .btn-primary:hover {
            background-color: var(--primary-dark);
            transform: translateY(-2px);
        }

        .footer-text {
            text-align: center;
            margin-top: 1.25rem;
            color: var(--secondary-color);
            font-size: 0.8125rem;
        }

        .footer-text a {
            color: var(--primary-color);
            text-decoration: none;
            font-weight: 600;
            transition: all 0.3s ease;
        }

        .footer-text a:hover {
            color: var(--primary-dark);
        }

        .alert {
            border-radius: 0.75rem;
            padding: 0.625rem 1rem;
            margin-bottom: 1rem;
            border: none;
            display: flex;
            align-items: center;
            gap: 0.625rem;
            font-size: 0.8125rem;
        }

        .alert-danger {
            background-color: #fee2e2;
            color: #dc2626;
        }

        .alert i {
            font-size: 0.875rem;
        }

        @keyframes fadeInUp {
            from {
                opacity: 0;
                transform: translateY(20px);
            }
            to {
                opacity: 1;
                transform: translateY(0);
            }
        }

        @media (max-width: 768px) {
            .register-card {
                padding: 1.25rem;
                margin: 1rem;
                max-width: 350px;
            }

            .register-card h2 {
                font-size: 1.125rem;
            }

            .form-control, .form-select {
                padding: 0.5rem 0.75rem;
                font-size: 0.8125rem;
            }
        }
    </style>
</head>
<body>
    <nav class="navbar navbar-expand-lg">
        <div class="container">
            <a class="navbar-brand" href="<%= request.getContextPath() %>/index.jsp">KostHunt</a>
        </div>
    </nav>

    <div class="container-register">
        <div class="register-card">
            <h2>Daftarkan Akun Anda</h2>
            <%
                String errorMessage = (String) request.getAttribute("errorMessage");
                if (errorMessage != null && !errorMessage.isEmpty()) {
            %>
                <div class="alert alert-danger">
                    <i class="fas fa-exclamation-circle"></i>
                    <%= errorMessage %>
                </div>
            <% } %>
            <form action="<%= request.getContextPath() %>/RegisterControllers" method="post" onsubmit="return validatePassword()">
                <div class="mb-3">
                    <label for="name" class="form-label">Nama</label>
                    <input type="text" class="form-control" id="name" name="name" placeholder="Masukkan nama" required />
                </div>
                <div class="mb-3">
                    <label for="email" class="form-label">Email</label>
                    <input type="email" class="form-control" id="email" name="email" placeholder="Masukkan email" required />
                </div>
                <div class="mb-3">
                    <label for="password" class="form-label">Kata Sandi</label>
                    <input type="password" class="form-control" id="password" name="password" placeholder="Masukkan kata sandi" required />
                </div>
                <div class="mb-3">
                    <label for="confirm_password" class="form-label">Konfirmasi Kata Sandi</label>
                    <input type="password" class="form-control" id="confirm_password" name="confirm_password" placeholder="Ketik ulang kata sandi" required />
                </div>
                <div class="mb-3">
                    <label for="role" class="form-label">Daftar sebagai</label>
                    <select class="form-select" id="role" name="role" required>
                        <option value="" disabled selected>Pilih Peran</option>
                        <option value="Owner">Owner (Pemilik Kost)</option>
                        <option value="Tenant">Tenant (Pencari Kost)</option>
                    </select>
                </div>
                <button type="submit" class="btn btn-primary">Daftar</button>
            </form>
            <div class="footer-text">
                Sudah punya akun? <a href="login.jsp">Masuk di sini</a>
            </div>
        </div>
    </div>
    
    <script>
        function validatePassword() {
            var password = document.getElementById("password").value;
            var confirmPassword = document.getElementById("confirm_password").value;
            if (password !== confirmPassword) {
                alert("Konfirmasi kata sandi tidak cocok. Silakan coba lagi.");
                return false;
            }
            return true;
        }
    </script>
</body>
</html>
