<%@ include file="dbconnection.jsp" %>
<%@ page import="java.sql.*" %>

<%
if(session.getAttribute("admin") == null) {
    response.sendRedirect("admin_login.jsp");
    return;
}
%>

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Admin Dashboard | Hotel Management</title>
    <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@300;400;500;600;700&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <style>
        :root {
            --primary: #4361ee;
            --primary-light: #3f37c9;
            --secondary: #3a0ca3;
            --dark: #1b263b;
            --light: #f8f9fa;
            --danger: #ef233c;
            --success: #4cc9f0;
            --warning: #f8961e;
            --gray: #adb5bd;
            --gray-dark: #495057;
        }

        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
            font-family: 'Poppins', sans-serif;
        }

        body {
            background-color: #f5f7fb;
            color: var(--dark);
            display: flex;
            min-height: 100vh;
        }

        /* Sidebar Styles */
        .sidebar {
            width: 280px;
            background: white;
            box-shadow: 0 0 10px rgba(0,0,0,0.1);
            height: 100vh;
            position: fixed;
            transition: all 0.3s ease;
            z-index: 100;
            overflow-y: auto;
        }

        .sidebar.collapsed {
            width: 80px;
        }

        .sidebar.collapsed .sidebar-header h3,
        .sidebar.collapsed .sidebar-menu a span {
            display: none;
        }

        .sidebar.collapsed .sidebar-menu a {
            justify-content: center;
            padding: 15px 0;
        }

        .sidebar.collapsed .sidebar-menu a i {
            margin-right: 0;
            font-size: 1.2rem;
        }

        .sidebar-header {
            padding: 20px;
            background: var(--primary);
            color: white;
            display: flex;
            align-items: center;
            justify-content: space-between;
            position: relative;
        }

        .sidebar-header h3 {
            font-weight: 600;
            font-size: 1.2rem;
            transition: all 0.3s;
        }

        .toggle-sidebar {
            background: none;
            border: none;
            color: white;
            font-size: 1.2rem;
            cursor: pointer;
            transition: all 0.3s;
        }

        .toggle-sidebar:hover {
            transform: scale(1.1);
        }

        .sidebar-menu {
            padding: 20px 0;
        }

        .sidebar-menu ul {
            list-style: none;
        }

        .sidebar-menu li {
            margin-bottom: 5px;
        }

        .sidebar-menu a {
            display: flex;
            align-items: center;
            padding: 12px 20px;
            color: var(--gray-dark);
            text-decoration: none;
            transition: all 0.3s;
            font-size: 0.95rem;
        }

        .sidebar-menu a:hover, 
        .sidebar-menu a.active {
            background: rgba(67, 97, 238, 0.1);
            color: var(--primary);
            border-left: 4px solid var(--primary);
        }

        .sidebar-menu a i {
            margin-right: 10px;
            font-size: 1.1rem;
            width: 20px;
            text-align: center;
            transition: all 0.3s;
        }

        /* Main Content Area */
        .main-content {
            flex: 1;
            margin-left: 280px;
            transition: all 0.3s ease;
        }

        .main-content.collapsed {
            margin-left: 80px;
        }

        /* Top Navigation */
        .top-nav {
            display: flex;
            justify-content: space-between;
            align-items: center;
            padding: 15px 25px;
            background: white;
            box-shadow: 0 2px 10px rgba(0,0,0,0.05);
            position: sticky;
            top: 0;
            z-index: 99;
        }

        .search-box {
            position: relative;
            width: 300px;
        }

        .search-box input {
            width: 100%;
            padding: 10px 15px 10px 40px;
            border: 1px solid #e0e0e0;
            border-radius: 30px;
            outline: none;
            font-size: 0.9rem;
            transition: all 0.3s;
        }

        .search-box input:focus {
            border-color: var(--primary);
            box-shadow: 0 0 0 3px rgba(67, 97, 238, 0.2);
        }

        .search-box i {
            position: absolute;
            left: 15px;
            top: 50%;
            transform: translateY(-50%);
            color: var(--gray);
        }

        .user-menu {
            display: flex;
            align-items: center;
        }

        .user-menu img {
            width: 40px;
            height: 40px;
            border-radius: 50%;
            margin-right: 10px;
            object-fit: cover;
        }

        .user-menu .dropdown {
            position: relative;
        }

        .user-menu .dropdown-toggle {
            display: flex;
            align-items: center;
            cursor: pointer;
        }

        .user-menu .dropdown-toggle i {
            margin-left: 5px;
            font-size: 0.8rem;
        }

        .user-menu .dropdown-menu {
            position: absolute;
            right: 0;
            top: 50px;
            background: white;
            width: 200px;
            border-radius: 5px;
            box-shadow: 0 5px 20px rgba(0,0,0,0.1);
            opacity: 0;
            visibility: hidden;
            transition: all 0.3s;
            z-index: 100;
        }

        .user-menu .dropdown:hover .dropdown-menu {
            opacity: 1;
            visibility: visible;
            top: 45px;
        }

        .dropdown-menu a {
            display: block;
            padding: 10px 15px;
            color: var(--gray-dark);
            text-decoration: none;
            font-size: 0.9rem;
            transition: all 0.3s;
        }

        .dropdown-menu a:hover {
            background: rgba(67, 97, 238, 0.1);
            color: var(--primary);
        }

        .dropdown-divider {
            height: 1px;
            background: #f0f0f0;
            margin: 5px 0;
        }

        /* Content Area */
        .content-wrapper {
            padding: 25px;
        }

        .page-header {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 25px;
        }

        .page-header h2 {
            font-size: 1.5rem;
            font-weight: 600;
            color: var(--dark);
        }

        .breadcrumb {
            display: flex;
            list-style: none;
            font-size: 0.9rem;
            color: var(--gray-dark);
        }

        .breadcrumb li {
            margin-right: 10px;
        }

        .breadcrumb li:after {
            content: '/';
            margin-left: 10px;
            color: var(--gray);
        }

        .breadcrumb li:last-child:after {
            content: '';
        }

        .breadcrumb a {
            color: var(--gray-dark);
            text-decoration: none;
        }

        .breadcrumb a:hover {
            color: var(--primary);
        }

        /* Cards */
        .card {
            background: white;
            border-radius: 10px;
            box-shadow: 0 5px 15px rgba(0,0,0,0.05);
            margin-bottom: 25px;
            border: none;
        }

        .card-header {
            padding: 15px 20px;
            border-bottom: 1px solid #f0f0f0;
            display: flex;
            justify-content: space-between;
            align-items: center;
        }

        .card-header h3 {
            font-size: 1.1rem;
            font-weight: 600;
            margin: 0;
        }

        .card-body {
            padding: 20px;
        }

        /* Tables */
        .table-responsive {
            overflow-x: auto;
        }

        .table {
            width: 100%;
            border-collapse: collapse;
        }

        .table th {
            background: #f8f9fa;
            color: var(--gray-dark);
            font-weight: 500;
            font-size: 0.85rem;
            text-transform: uppercase;
            letter-spacing: 0.5px;
            padding: 12px 15px;
            text-align: left;
            border-bottom: 1px solid #e0e0e0;
        }

        .table td {
            padding: 12px 15px;
            border-bottom: 1px solid #f0f0f0;
            font-size: 0.9rem;
            color: var(--gray-dark);
        }

        .table tr:hover td {
            background: #f8fafd;
        }

        .status {
            display: inline-block;
            padding: 5px 10px;
            border-radius: 20px;
            font-size: 0.75rem;
            font-weight: 500;
        }

        .status-pending {
            background: #fff3cd;
            color: #856404;
        }

        .status-confirmed {
            background: #d4edda;
            color: #155724;
        }

        .status-cancelled {
            background: #f8d7da;
            color: #721c24;
        }

        .badge {
            display: inline-block;
            padding: 5px 8px;
            border-radius: 4px;
            font-size: 0.75rem;
            font-weight: 500;
        }

        .badge-primary {
            background: rgba(67, 97, 238, 0.1);
            color: var(--primary);
        }

        .badge-success {
            background: rgba(76, 201, 240, 0.1);
            color: var(--success);
        }

        .badge-warning {
            background: rgba(248, 150, 30, 0.1);
            color: var(--warning);
        }

        /* Buttons */
        .btn {
            display: inline-block;
            padding: 8px 15px;
            border-radius: 5px;
            font-size: 0.85rem;
            font-weight: 500;
            cursor: pointer;
            transition: all 0.3s;
            border: none;
            text-decoration: none;
        }

        .btn-sm {
            padding: 5px 10px;
            font-size: 0.75rem;
        }

        .btn-primary {
            background: var(--primary);
            color: white;
        }

        .btn-primary:hover {
            background: var(--primary-light);
            transform: translateY(-2px);
            box-shadow: 0 3px 10px rgba(67, 97, 238, 0.3);
        }

        .btn-outline-primary {
            background: transparent;
            color: var(--primary);
            border: 1px solid var(--primary);
        }

        .btn-outline-primary:hover {
            background: rgba(67, 97, 238, 0.1);
        }

        .btn-danger {
            background: var(--danger);
            color: white;
        }

        .btn-danger:hover {
            background: #d90429;
            transform: translateY(-2px);
            box-shadow: 0 3px 10px rgba(239, 35, 60, 0.3);
        }

        /* Mobile Menu Button */
        .mobile-menu-btn {
            display: none;
            position: fixed;
            bottom: 20px;
            right: 20px;
            background: var(--primary);
            color: white;
            width: 50px;
            height: 50px;
            border-radius: 50%;
            align-items: center;
            justify-content: center;
            cursor: pointer;
            box-shadow: 0 3px 10px rgba(0,0,0,0.2);
            z-index: 99;
            border: none;
            font-size: 1.2rem;
        }

        /* Responsive */
        @media (max-width: 992px) {
            .sidebar {
                width: 80px;
                overflow: hidden;
            }
            
            .sidebar-header h3,
            .sidebar-menu a span {
                display: none;
            }
            
            .sidebar-menu a {
                justify-content: center;
                padding: 15px 0;
            }
            
            .sidebar-menu a i {
                margin-right: 0;
                font-size: 1.2rem;
            }
            
            .main-content {
                margin-left: 80px;
            }

            .toggle-sidebar {
                display: none;
            }
        }

        @media (max-width: 768px) {
            .search-box {
                width: 200px;
            }
            
            .user-menu .name {
                display: none;
            }
        }

        @media (max-width: 576px) {
            .sidebar {
                transform: translateX(-100%);
                width: 280px;
            }
            
            .sidebar.active {
                transform: translateX(0);
            }
            
            .main-content {
                margin-left: 0;
            }
            
            .mobile-menu-btn {
                display: flex;
            }

            .sidebar.collapsed {
                width: 280px;
            }

            .sidebar.collapsed .sidebar-header h3,
            .sidebar.collapsed .sidebar-menu a span {
                display: block;
            }

            .sidebar.collapsed .sidebar-menu a {
                justify-content: flex-start;
                padding: 12px 20px;
            }

            .sidebar.collapsed .sidebar-menu a i {
                margin-right: 10px;
            }
        }
    </style>
</head>
<body>
    <!-- Sidebar -->
    <div class="sidebar" id="sidebar">
        <div class="sidebar-header">
            <h3>Hotel Admin</h3>
            <button class="toggle-sidebar" id="toggleSidebar">
                <i class="fas fa-chevron-left"></i>
            </button>
        </div>
        <div class="sidebar-menu">
            <ul>
                <li>
                    <a href="admin_dashboard.jsp" class="active">
                        <i class="fas fa-tachometer-alt"></i>
                        <span>Dashboard</span>
                    </a>
                </li>
                <li>
                    <a href="admin_reservations.jsp">
                        <i class="fas fa-calendar-check"></i>
                        <span>Reservations</span>
                    </a>
                </li>
                <li>
                    <a href="admin_rooms.jsp">
                        <i class="fas fa-hotel"></i>
                        <span>Rooms</span>
                    </a>
                </li>

            </ul>
        </div>
    </div>

    <!-- Main Content -->
    <div class="main-content" id="mainContent">
        <!-- Top Navigation -->
        <div class="top-nav">
            <div class="search-box">
              
                
            </div>
           <div class="user-menu">
                <img src="https://ui-avatars.com/api/?name=Admin&background=4361ee&color=fff" alt="Admin">
                <div class="dropdown">
                    <div class="dropdown-toggle">
                        <span class="name">Admin</span>
                        <i class="fas fa-chevron-down"></i>
                    </div>
                    <div class="dropdown-menu">
                       
                        <div class="dropdown-divider"></div>
                        <a href="logout.jsp"><i class="fas fa-sign-out-alt"></i> Logout</a>
                    </div>
                 
                </div>
            </div>
        </div>

        <!-- Content Wrapper -->
        <div class="content-wrapper">
            <!-- Page Header -->
            <div class="page-header">
                <h2>Dashboard Overview</h2>
                <ul class="breadcrumb">
                    <li><a href="admin_dashboard.jsp">Home</a></li>
                    <li>Dashboard</li>
                </ul>
            </div>

            <!-- Stats Cards Row -->
            <div class="row" style="display: flex; gap: 20px; margin-bottom: 25px; flex-wrap: wrap;">
                <div class="card" style="flex: 1; min-width: 200px;">
                    <div class="card-body">
                        <div style="display: flex; align-items: center;">
                            <div style="background: rgba(67, 97, 238, 0.1); width: 50px; height: 50px; border-radius: 50%; display: flex; align-items: center; justify-content: center; margin-right: 15px;">
                                <i class="fas fa-calendar-check" style="color: var(--primary); font-size: 1.2rem;"></i>
                            </div>
                            <div>
                                <h3 style="font-size: 1.5rem; font-weight: 600; margin-bottom: 5px;">
                                    <%
                                    try {
                                        PreparedStatement ps = conn.prepareStatement("SELECT COUNT(*) AS total FROM reservations");
                                        ResultSet rs = ps.executeQuery();
                                        if(rs.next()) {
                                            out.print(rs.getInt("total"));
                                        }
                                    } catch(SQLException e) {
                                        out.print("0");
                                    }
                                    %>
                                </h3>
                                <p style="color: var(--gray-dark); font-size: 0.9rem;">Total Reservations</p>
                            </div>
                        </div>
                    </div>
                </div>
                
                <div class="card" style="flex: 1; min-width: 200px;">
                    <div class="card-body">
                        <div style="display: flex; align-items: center;">
                            <div style="background: rgba(76, 201, 240, 0.1); width: 50px; height: 50px; border-radius: 50%; display: flex; align-items: center; justify-content: center; margin-right: 15px;">
                                <i class="fas fa-hotel" style="color: var(--success); font-size: 1.2rem;"></i>
                            </div>
                            <div>
                                <h3 style="font-size: 1.5rem; font-weight: 600; margin-bottom: 5px;">
                                    <%
                                    try {
                                        PreparedStatement ps = conn.prepareStatement("SELECT COUNT(*) AS total FROM rooms");
                                        ResultSet rs = ps.executeQuery();
                                        if(rs.next()) {
                                            out.print(rs.getInt("total"));
                                        }
                                    } catch(SQLException e) {
                                        out.print("0");
                                    }
                                    %>
                                </h3>
                                <p style="color: var(--gray-dark); font-size: 0.9rem;">Total Rooms</p>
                            </div>
                        </div>
                    </div>
                </div>
                
                <div class="card" style="flex: 1; min-width: 200px;">
                    <div class="card-body">
                        <div style="display: flex; align-items: center;">
                            <div style="background: rgba(248, 150, 30, 0.1); width: 50px; height: 50px; border-radius: 50%; display: flex; align-items: center; justify-content: center; margin-right: 15px;">
                                <i class="fas fa-users" style="color: var(--warning); font-size: 1.2rem;"></i>
                            </div>
                            <div>
                                <h3 style="font-size: 1.5rem; font-weight: 600; margin-bottom: 5px;">
                                    <%
                                    try {
                                        PreparedStatement ps = conn.prepareStatement("SELECT COUNT(*) AS total FROM guests");
                                        ResultSet rs = ps.executeQuery();
                                        if(rs.next()) {
                                            out.print(rs.getInt("total"));
                                        }
                                    } catch(SQLException e) {
                                        out.print("0");
                                    }
                                    %>
                                </h3>
                                <p style="color: var(--gray-dark); font-size: 0.9rem;">Total Guests</p>
                            </div>
                        </div>
                    </div>
                </div>
                
                <div class="card" style="flex: 1; min-width: 200px;">
                    <div class="card-body">
                        <div style="display: flex; align-items: center;">
                            <div style="background: rgba(239, 35, 60, 0.1); width: 50px; height: 50px; border-radius: 50%; display: flex; align-items: center; justify-content: center; margin-right: 15px;">
                                <i class="fas fa-money-bill-wave" style="color: var(--danger); font-size: 1.2rem;"></i>
                            </div>
                            <div>
                                <h3 style="font-size: 1.5rem; font-weight: 600; margin-bottom: 5px;">
                                    <%
                                    try {
                                        PreparedStatement ps = conn.prepareStatement("SELECT SUM(amount) AS total FROM payments");
                                        ResultSet rs = ps.executeQuery();
                                        if(rs.next()) {
                                            out.print("Rp" + rs.getBigDecimal("total"));
                                        }
                                    } catch(SQLException e) {
                                        out.print("Rp0");
                                    }
                                    %>
                                </h3>
                                <p style="color: var(--gray-dark); font-size: 0.9rem;">Total Revenue</p>
                            </div>
                        </div>
                    </div>
                </div>
            </div>

            <!-- Recent Reservations Card -->
            <div class="card">
                <div class="card-header">
                    <h3>Recent Reservations</h3>
                    <a href="admin_reservations.jsp" class="btn btn-outline-primary btn-sm">View All</a>
                </div>
                <div class="card-body">
                    <div class="table-responsive">
                        <table class="table">
                            <thead>
                                <tr>
                                    <th>Reservation ID</th>
                                    <th>Guest Name</th>
                                    <th>Room Number</th>
                                    <th>Room Type</th>
                                    <th>Check-In</th>
                                    <th>Check-Out</th>
                                    <th>Amount</th>
                                    <th>Status</th>
                                    <%-- <th>Actions</th> --%>
                                </tr>
                            </thead>
                            <tbody>
                                <%
                                try {
                                    String sql = "SELECT r.reservation_id, g.name AS guest_name, rm.room_number, rm.type, " +
                                                 "r.check_in, r.check_out, p.amount, r.payment_status " +
                                                 "FROM reservations r " +
                                                 "JOIN guests g ON r.guest_id = g.guest_id " +
                                                 "JOIN rooms rm ON r.room_id = rm.room_id " +
                                                 "LEFT JOIN payments p ON r.reservation_id = p.reservation_id " +
                                                 "ORDER BY r.reservation_id DESC LIMIT 5";

                                    PreparedStatement ps = conn.prepareStatement(sql);
                                    ResultSet rs = ps.executeQuery();

                                    while(rs.next()) {
                                        String statusClass = "";
                                        switch(rs.getString("payment_status")) {
                                            case "pending": statusClass = "status-pending"; break;
                                            case "completed": statusClass = "status-confirmed"; break;
                                            case "cancelled": statusClass = "status-cancelled"; break;
                                        }
                                %>
                                <tr>
                                    <td>#<%= rs.getInt("reservation_id") %></td>
                                    <td><%= rs.getString("guest_name") %></td>
                                    <td><%= rs.getString("room_number") %></td>
                                    <td><span class="badge badge-primary"><%= rs.getString("type") %></span></td>
                                    <td><%= rs.getDate("check_in") %></td>
                                    <td><%= rs.getDate("check_out") %></td>
                                    <td>Rp<%= rs.getBigDecimal("amount") != null ? rs.getBigDecimal("amount") : "0" %></td>
                                    <td><span class="status <%= statusClass %>"><%= rs.getString("payment_status") %></span></td>
                                    
                                </tr>
                                <%
                                    }
                                } catch(SQLException e) {
                                    out.println("<tr><td colspan='9' style='text-align: center; color: var(--danger);'>Error loading reservations: " + e.getMessage() + "</td></tr>");
                                }
                                %>
                            </tbody>
                        </table>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <button class="mobile-menu-btn" id="mobileMenuBtn">
        <i class="fas fa-bars"></i>
    </button>

    <script>
        // Toggle sidebar collapse/expand
        const toggleSidebar = document.getElementById('toggleSidebar');
        const sidebar = document.getElementById('sidebar');
        const mainContent = document.getElementById('mainContent');
        const mobileMenuBtn = document.getElementById('mobileMenuBtn');

        toggleSidebar.addEventListener('click', function() {
            sidebar.classList.toggle('collapsed');
            mainContent.classList.toggle('collapsed');
            
            // Rotate the chevron icon
            const icon = this.querySelector('i');
            if (sidebar.classList.contains('collapsed')) {
                icon.classList.remove('fa-chevron-left');
                icon.classList.add('fa-chevron-right');
            } else {
                icon.classList.remove('fa-chevron-right');
                icon.classList.add('fa-chevron-left');
            }
        });

        // Mobile menu toggle
        mobileMenuBtn.addEventListener('click', function() {
            sidebar.classList.toggle('active');
        });

        // Hide sidebar when clicking outside on mobile
        document.addEventListener('click', function(event) {
            if (window.innerWidth <= 576) {
                const isClickInsideSidebar = sidebar.contains(event.target);
                const isClickOnMobileBtn = mobileMenuBtn.contains(event.target);
                
                if (!isClickInsideSidebar && !isClickOnMobileBtn) {
                    sidebar.classList.remove('active');
                }
            }
        });

        // Responsive adjustments
        function handleResponsive() {
            if (window.innerWidth <= 992) {
                sidebar.classList.add('collapsed');
                mainContent.classList.add('collapsed');
                toggleSidebar.style.display = 'none';
            } else {
                toggleSidebar.style.display = 'block';
            }
            
            if (window.innerWidth > 576) {
                sidebar.classList.remove('active');
            }
        }

        // Initial check
        handleResponsive();
        
        // Check on resize
        window.addEventListener('resize', handleResponsive);
    </script>
</body>
</html>