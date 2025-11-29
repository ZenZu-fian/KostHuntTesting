<%@ page import="java.sql.*" %>
<%@ page import="java.util.*" %>
<%
    String user = (String) session.getAttribute("user");
    Map<String, String> userData = new HashMap<String, String>();
    
    if (user != null) {
        try {
            String dbUrl = "jdbc:mysql://localhost:3306/dbkost";
            String dbUser = "root";
            String dbPassword = "";
            
            Class.forName("com.mysql.cj.jdbc.Driver");
            Connection conn = DriverManager.getConnection(dbUrl, dbUser, dbPassword);
            
            String sql = "SELECT name, role FROM users WHERE email = ?";
            PreparedStatement stmt = conn.prepareStatement(sql);
            stmt.setString(1, user);
            ResultSet rs = stmt.executeQuery();
            
            if (rs.next()) {
                userData.put("name", rs.getString("name"));
                userData.put("role", rs.getString("role"));
            }
            
            rs.close();
            stmt.close();
            conn.close();
        } catch (Exception e) {
            e.printStackTrace();
        }
    }
%>

<style>
    :root {
        --primary-color: #4A90E2;
        --secondary-color: #357ab7;
        --text-color: #333;
        --light-gray: #f8f9fa;
    }

    /* CRITICAL FIX: Prevent horizontal overflow */
    body {
        margin: 0;
        padding: 0;
        overflow-x: hidden;
    }

    .navbar {
        background-color: var(--primary-color);
        padding: 1rem 0;
        box-shadow: 0 2px 4px rgba(0,0,0,0.1);
        width: 100%;
        position: relative;
    }

    /* FIXED: Container should not exceed viewport */
    .navbar .container {
        max-width: 100%;
        width: 100%;
        margin: 0 auto;
        padding: 0 2rem;
        box-sizing: border-box;
    }

    .navbar-brand {
        font-size: 1.8rem;
        font-weight: 700;
        color: white !important;
        text-decoration: none;
    }

    .nav-link {
        color: white !important;
        font-weight: 500;
        margin: 0 0.5rem;
        transition: all 0.3s ease;
        text-decoration: none;
    }

    .nav-link:hover {
        opacity: 0.8;
    }

    .dropdown-menu {
        border: none;
        box-shadow: 0 2px 4px rgba(0,0,0,0.1);
    }

    .dropdown-item {
        padding: 0.5rem 1rem;
        color: var(--text-color);
        text-decoration: none;
    }

    .dropdown-item:hover {
        background-color: var(--light-gray);
    }

    .dropdown-item i {
        margin-right: 0.5rem;
        color: var(--primary-color);
    }

    /* Search Bar Styles */
    .search-form {
        position: relative;
        width: 300px;
        margin: 0 1rem;
        max-width: 100%;
    }

    .search-input {
        width: 100%;
        padding: 0.5rem 2.5rem 0.5rem 1rem;
        border: 2px solid rgba(255, 255, 255, 0.3);
        border-radius: 25px;
        background-color: rgba(255, 255, 255, 0.1);
        color: white;
        font-size: 0.95rem;
        transition: all 0.3s ease;
        box-sizing: border-box;
    }

    .search-input::placeholder {
        color: rgba(255, 255, 255, 0.7);
    }

    .search-input:focus {
        outline: none;
        background-color: white;
        color: var(--text-color);
        border-color: white;
    }

    .search-input:focus::placeholder {
        color: #999;
    }

    .search-btn {
        position: absolute;
        right: 5px;
        top: 50%;
        transform: translateY(-50%);
        background: none;
        border: none;
        color: white;
        padding: 0.5rem;
        cursor: pointer;
        transition: all 0.3s ease;
    }

    .search-input:focus + .search-btn {
        color: var(--primary-color);
    }

    .search-btn:hover {
        opacity: 0.8;
    }

    /* Responsive Design */
    @media (max-width: 991px) {
        .navbar .container {
            padding: 0 1rem;
        }

        .search-form {
            width: 100%;
            margin: 1rem 0;
        }

        .navbar-brand {
            font-size: 1.5rem;
        }
    }

    @media (max-width: 576px) {
        .navbar {
            padding: 0.75rem 0;
        }

        .navbar .container {
            padding: 0 0.75rem;
        }

        .navbar-brand {
            font-size: 1.3rem;
        }
    }
</style>

<!-- Navigation -->
<nav class="navbar navbar-expand-lg sticky-top">
    <div class="container">
        <a class="navbar-brand" href="<%= request.getContextPath() %>/index.jsp">KostHunt</a>
        <button class="navbar-toggler" type="button" data-bs-toggle="collapse" data-bs-target="#navbarNav" 
                style="background-color: white; border: none; padding: 0.5rem;">
            <span class="navbar-toggler-icon" style="filter: invert(1);"></span>
        </button>
        <div class="collapse navbar-collapse" id="navbarNav">
            <!-- Search Form -->
            <form class="search-form d-flex ms-auto" action="<%= request.getContextPath() %>/kost" method="GET">
                <input type="hidden" name="action" value="search">
                <input class="search-input" type="search" name="query" placeholder="Cari kost..." aria-label="Search">
                <button class="search-btn" type="submit">
                    <i class="fas fa-search"></i>
                </button>
            </form>

            <ul class="navbar-nav">
                <% if (user != null) { %>
                    <li class="nav-item dropdown">
                        <a class="nav-link dropdown-toggle" href="#" id="navbarDropdown" role="button" 
                           data-bs-toggle="dropdown" aria-expanded="false">
                            <i class="fas fa-user"></i> <%= userData.get("name") != null ? userData.get("name") : user %>
                        </a>
                        <ul class="dropdown-menu dropdown-menu-end" aria-labelledby="navbarDropdown">
                            <li><a class="dropdown-item" href="<%= request.getContextPath() %>/profile.jsp">
                                <i class="fas fa-user-circle"></i> Profile
                            </a></li>
                            <% if ("Owner".equals(userData.get("role"))) { %>
                                <li><a class="dropdown-item" href="<%= request.getContextPath() %>/ownerDashboard">
                                    <i class="fas fa-home"></i> Dashboard
                                </a></li>
                            <% } %>
                            <% if ("Tenant".equals(userData.get("role"))) { %>
                                <li><a class="dropdown-item" href="<%= request.getContextPath() %>/tenantDashboard">
                                    <i class="fas fa-home"></i> Dashboard
                                </a></li>
                            <% } %>
                            <li><hr class="dropdown-divider"></li>
                            <li><a class="dropdown-item" href="<%= request.getContextPath() %>/logout.jsp">
                                <i class="fas fa-sign-out-alt"></i> Logout
                            </a></li>
                        </ul>
                    </li>
                <% } else { %>
                    <li class="nav-item">
                        <a class="nav-link" href="<%= request.getContextPath() %>/login.jsp">
                            <i class="fas fa-sign-in-alt"></i> Masuk
                        </a>
                    </li>
                <% } %>
            </ul>
        </div>
    </div>
</nav>