<%@ page import="java.sql.*" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Admin - Room Management</title>
    <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@300;400;500;600;700&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css">
    <style>
        :root {
            --primary: #4361ee;
            --primary-light: #3f37c9;
            --secondary: #3a0ca3;
            --success: #4cc9f0;
            --danger: #ef233c;
            --warning: #f8961e;
            --light: #f8f9fa;
            --dark: #1b263b;
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
            padding: 8px 12px;
            border-radius: 4px;
            transition: background-color 0.2s;
        }

        .user-menu .dropdown-toggle:hover {
            background-color: rgba(0, 0, 0, 0.05);
        }

        .user-menu .dropdown-toggle i {
            margin-left: 5px;
            font-size: 0.8rem;
            transition: transform 0.2s;
        }

        .user-menu .dropdown-toggle.active i {
            transform: rotate(180deg);
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
            transform: translateY(-10px);
        }

        .user-menu .dropdown-menu.show {
            opacity: 1;
            visibility: visible;
            transform: translateY(0);
        }

        .dropdown-menu a {
            display: flex;
            align-items: center;
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

        .dropdown-menu a i {
            margin-right: 10px;
            width: 20px;
            text-align: center;
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

        /* Room Management Specific Styles */
        .status-badge {
            display: inline-block;
            padding: 5px 10px;
            border-radius: 20px;
            font-size: 0.75rem;
            font-weight: 500;
            text-transform: capitalize;
        }

        .status-available {
            background: rgba(16, 185, 129, 0.1);
            color: #065f46;
        }

        .status-booked {
            background: rgba(239, 68, 68, 0.1);
            color: #b91c1c;
        }

        .status-maintenance {
            background: rgba(245, 158, 11, 0.1);
            color: #92400e;
        }

        .status-pending {
            background: rgba(245, 158, 11, 0.1);
            color: #92400e;
        }

        .status-completed {
            background: rgba(16, 185, 129, 0.1);
            color: #065f46;
        }

        .status-cancelled {
            background: rgba(239, 68, 68, 0.1);
            color: #b91c1c;
        }

        .table-responsive {
            border-radius: 0.5rem;
            overflow: hidden;
            box-shadow: 0 0.5rem 1rem rgba(0,0,0,0.05);
        }

        .table thead {
            background-color: var(--primary);
            color: white;
        }

        .table th {
            font-weight: 500;
            text-transform: uppercase;
            font-size: 0.75rem;
            letter-spacing: 0.5px;
        }

        .table-hover tbody tr:hover {
            background-color: rgba(67, 97, 238, 0.05);
        }

        .action-btn {
            padding: 0.25rem 0.5rem;
            font-size: 0.75rem;
        }

        .room-type {
            font-weight: 600;
            color: var(--secondary);
        }

        .no-booking {
            color: #6b7280;
            font-style: italic;
        }

        .filter-controls {
            background-color: white;
            padding: 1rem;
            border-radius: 0.5rem;
            margin-bottom: 1.5rem;
            box-shadow: 0 0.125rem 0.25rem rgba(0,0,0,0.05);
        }

        .stats-card {
            border-radius: 0.5rem;
            padding: 1rem;
            margin-bottom: 1.5rem;
            background-color: white;
            box-shadow: 0 0.125rem 0.25rem rgba(0,0,0,0.05);
        }

        .stats-card h5 {
            font-size: 0.875rem;
            color: #6b7280;
            margin-bottom: 0.5rem;
        }

        .stats-card h3 {
            font-weight: 700;
            color: var(--dark);
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
            
            .table thead {
                display: none;
            }
            
            .table tbody tr {
                display: block;
                margin-bottom: 1rem;
                border-radius: 8px;
                box-shadow: 0 1px 3px 0 rgba(0,0,0,0.1), 0 1px 2px 0 rgba(0,0,0,0.06);
            }
            
            .table tbody td {
                display: flex;
                justify-content: space-between;
                align-items: center;
                padding: 0.75rem 1rem;
                border-bottom: 1px solid #e2e8f0;
            }
            
            .table tbody td:before {
                content: attr(data-label);
                font-weight: 600;
                color: #64748b;
                margin-right: 1rem;
            }
            
            .table tbody td:last-child {
                border-bottom: none;
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
                    <a href="admin_dashboard.jsp">
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
                    <a href="admin_rooms.jsp" class="active">
                        <i class="fas fa-bed"></i>
                        <span>Room Management</span>
                    </a>
                </li>
                <%-- <li>
                    <a href="admin_guests.jsp">
                        <i class="fas fa-users"></i>
                        <span>Guests</span>
                    </a>
                </li> --%>
            </ul>
        </div>
    </div>

    <!-- Main Content -->
    <div class="main-content" id="mainContent">
        <!-- Top Navigation -->
        <div class="top-nav">
            <div class="search-box">
                <i class="fas fa-search"></i>
                <input type="text" placeholder="Search...">
            </div>
            <div class="user-menu">
                <img src="https://ui-avatars.com/api/?name=Admin&background=4361ee&color=fff" alt="Admin">
                <div class="dropdown">
                    <div class="dropdown-toggle" id="userDropdown">
                        <span class="name">Admin</span>
                        <i class="fas fa-chevron-down"></i>
                    </div>
                    <div class="dropdown-menu">
                      
                        <div class="dropdown-divider"></div>
                        <a href="logout.jsp"><i class="fas fa-sign-out-alt me-2"></i>Logout</a>
                    </div>
                </div>
            </div>
        </div>

        <!-- Content Wrapper -->
        <div class="content-wrapper">
            <div class="row mb-4">
                <div class="col-md-3">
                    <div class="stats-card">
                        <h5>Total Rooms</h5>
                        <h3>
                            <%
                            try {
                                Class.forName("com.mysql.cj.jdbc.Driver");
                                Connection conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/hotel_reservation", "root", "");
                                Statement stmt = conn.createStatement();
                                ResultSet rs = stmt.executeQuery("SELECT COUNT(*) AS total FROM rooms");
                                if (rs.next()) {
                                    out.print(rs.getInt("total"));
                                }
                                rs.close();
                                stmt.close();
                                conn.close();
                            } catch (Exception e) {
                                out.print("0");
                            }
                            %>
                        </h3>
                    </div>
                </div>
                <div class="col-md-3">
                    <div class="stats-card">
                        <h5>Available Rooms</h5>
                        <h3>
                            <%
                            try {
                                Class.forName("com.mysql.cj.jdbc.Driver");
                                Connection conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/hotel_reservation", "root", "");
                                Statement stmt = conn.createStatement();
                                ResultSet rs = stmt.executeQuery("SELECT COUNT(*) AS available FROM rooms WHERE status = 'available'");
                                if (rs.next()) {
                                    out.print(rs.getInt("available"));
                                }
                                rs.close();
                                stmt.close();
                                conn.close();
                            } catch (Exception e) {
                                out.print("0");
                            }
                            %>
                        </h3>
                    </div>
                </div>
                <div class="col-md-3">
                    <div class="stats-card">
                        <h5>Booked Rooms</h5>
                        <h3>
                            <%
                            try {
                                Class.forName("com.mysql.cj.jdbc.Driver");
                                Connection conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/hotel_reservation", "root", "");
                                Statement stmt = conn.createStatement();
                                ResultSet rs = stmt.executeQuery("SELECT COUNT(*) AS booked FROM rooms WHERE status = 'booked'");
                                if (rs.next()) {
                                    out.print(rs.getInt("booked"));
                                }
                                rs.close();
                                stmt.close();
                                conn.close();
                            } catch (Exception e) {
                                out.print("0");
                            }
                            %>
                        </h3>
                    </div>
                </div>
                <div class="col-md-3">
                    <div class="stats-card">
                        <h5>Maintenance</h5>
                        <h3>
                            <%
                            try {
                                Class.forName("com.mysql.cj.jdbc.Driver");
                                Connection conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/hotel_reservation", "root", "");
                                Statement stmt = conn.createStatement();
                                ResultSet rs = stmt.executeQuery("SELECT COUNT(*) AS maintenance FROM rooms WHERE status = 'maintenance'");
                                if (rs.next()) {
                                    out.print(rs.getInt("maintenance"));
                                }
                                rs.close();
                                stmt.close();
                                conn.close();
                            } catch (Exception e) {
                                out.print("0");
                            }
                            %>
                        </h3>
                    </div>
                </div>
            </div>

            <div class="filter-controls">
                <div class="row">
                    <div class="col-md-4 mb-2">
                        <label for="statusFilter" class="form-label">Filter by Status</label>
                        <select class="form-select form-select-sm" id="statusFilter">
                            <option value="all">All Statuses</option>
                            <option value="available">Available</option>
                            <option value="booked">Booked</option>
                            <option value="maintenance">Maintenance</option>
                        </select>
                    </div>
                    <div class="col-md-4 mb-2">
                        <label for="typeFilter" class="form-label">Filter by Room Type</label>
                        <select class="form-select form-select-sm" id="typeFilter">
                            <option value="all">All Types</option>
                            <%
                            try {
                                Class.forName("com.mysql.cj.jdbc.Driver");
                                Connection conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/hotel_reservation", "root", "");
                                Statement stmt = conn.createStatement();
                                ResultSet rs = stmt.executeQuery("SELECT DISTINCT type FROM rooms");
                                while (rs.next()) {
                                    out.print("<option value='" + rs.getString("type") + "'>" + rs.getString("type") + "</option>");
                                }
                                rs.close();
                                stmt.close();
                                conn.close();
                            } catch (Exception e) {
                                out.print("<option value=''>Error loading types</option>");
                            }
                            %>
                        </select>
                    </div>
                    <div class="col-md-4 mb-2 d-flex align-items-end">
                        <button class="btn btn-primary btn-sm me-2" id="applyFilter">
                            <i class="fas fa-filter me-1"></i>Apply Filters
                        </button>
                        <button class="btn btn-outline-secondary btn-sm" id="resetFilter">
                            <i class="fas fa-sync-alt me-1"></i>Reset
                        </button>
                    </div>
                </div>
            </div>

            <div class="d-flex justify-content-between align-items-center mb-3">
                <h2 class="h4 mb-0">
                    <i class="fas fa-bed me-2"></i>Room Management
                </h2>
                <a href="admin_add_room.jsp" class="btn btn-primary btn-sm">
                    <i class="fas fa-plus me-1"></i>Add New Room
                </a>
            </div>

            <div class="table-responsive">
                <table class="table table-hover">
                    <thead class="table-dark">
                        <tr>
                            <th>Room ID</th>
                            <th>Room Number</th>
                            <th>Type</th>
                            <th>Price</th>
                            <th>Status</th>
                            <th>Booking Info</th>
                            <th>Payment Status</th>
                            <th>Actions</th>
                        </tr>
                    </thead>
                    <tbody>
                    <%
                    try {
                        Class.forName("com.mysql.cj.jdbc.Driver");
                        Connection conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/hotel_reservation", "root", "");

                        // Enhanced query to get room and reservation details
                        String sql = "SELECT r.room_id, r.room_number, r.type, r.price, r.status, " +
                                     "res.reservation_id, res.check_in, res.check_out, res.payment_status, " +
                                     "g.name AS guest_name " +
                                     "FROM rooms r " +
                                     "LEFT JOIN reservations res ON r.room_id = res.room_id AND res.check_out >= CURDATE() " +
                                     "LEFT JOIN guests g ON res.guest_id = g.guest_id " +
                                     "ORDER BY r.room_number ASC";
                        Statement stmt = conn.createStatement();
                        ResultSet rs = stmt.executeQuery(sql);

                        while (rs.next()) {
                            String status = rs.getString("status");
                            String statusClass = "";
                            String statusText = "";
                            
                            switch(status) {
                                case "available":
                                    statusClass = "status-available";
                                    statusText = "Available";
                                    break;
                                case "booked":
                                    statusClass = "status-booked";
                                    statusText = "Booked";
                                    break;
                                case "maintenance":
                                    statusClass = "status-maintenance";
                                    statusText = "Maintenance";
                                    break;
                                default:
                                    statusClass = "status-secondary";
                                    statusText = status;
                            }
                            
                            String paymentStatus = rs.getString("payment_status");
                            String paymentClass = "";
                            String paymentText = "N/A";
                            
                            if (paymentStatus != null) {
                                switch(paymentStatus) {
                                    case "pending":
                                        paymentClass = "status-pending";
                                        paymentText = "Pending";
                                        break;
                                    case "completed":
                                        paymentClass = "status-completed";
                                        paymentText = "Completed";
                                        break;
                                    case "cancelled":
                                        paymentClass = "status-cancelled";
                                        paymentText = "Cancelled";
                                        break;
                                }
                            }
                            
                            String bookingInfo = "<span class='no-booking'>No active booking</span>";
                            if (rs.getString("check_in") != null) {
                                bookingInfo = "<strong>" + rs.getString("guest_name") + "</strong><br>" +
                                              rs.getDate("check_in") + " to " + rs.getDate("check_out");
                            }
                    %>
                        <tr data-status="<%= status %>" data-type="<%= rs.getString("type") %>">
                            <td><%= rs.getInt("room_id") %></td>
                            <td><strong><%= rs.getString("room_number") %></strong></td>
                            <td><span class="room-type"><%= rs.getString("type") %></span></td>
                            <td>$<%= rs.getBigDecimal("price") %></td>
                            <td><span class="status-badge <%= statusClass %>"><%= statusText %></span></td>
                            <td><%= bookingInfo %></td>
                            <td>
                                <% if (paymentStatus != null) { %>
                                    <span class="status-badge <%= paymentClass %>"><%= paymentText %></span>
                                <% } else { %>
                                    <span class="no-booking">N/A</span>
                                <% } %>
                            </td>
                            <td>
                                <div class="d-flex gap-2">
                                    <a href="admin_edit_room.jsp?id=<%= rs.getInt("room_id") %>" 
                                       class="btn btn-sm btn-outline-primary action-btn" 
                                       title="Edit Room">
                                        <i class="fas fa-edit"></i>
                                    </a>
                                    <% if (status.equals("booked")) { %>
                                        <a href="admin_view_reservation.jsp?id=<%= rs.getInt("reservation_id") %>" 
                                           class="btn btn-sm btn-outline-secondary action-btn" 
                                           title="View Booking">
                                            <i class="fas fa-calendar-alt"></i>
                                        </a>
                                    <% } %>
                                    <% if (!status.equals("booked")) { %>
                                        <a href="admin_change_status.jsp?id=<%= rs.getInt("room_id") %>&status=<%= status.equals("available") ? "maintenance" : "available" %>" 
                                           class="btn btn-sm btn-outline-<%= status.equals("available") ? "warning" : "success" %> action-btn" 
                                           title="<%= status.equals("available") ? "Set to Maintenance" : "Set to Available" %>">
                                            <i class="fas fa-<%= status.equals("available") ? "tools" : "check" %>"></i>
                                        </a>
                                    <% } %>
                                </div>
                            </td>
                        </tr>
                    <%
                        }
                        rs.close();
                        stmt.close();
                        conn.close();
                    } catch (Exception e) {
                        out.println("<tr><td colspan='8' class='text-center text-danger py-4'>Error loading room data: " + e.getMessage() + "</td></tr>");
                    }
                    %>
                    </tbody>
                </table>
            </div>
        </div>
    </div>

    <button class="mobile-menu-btn" id="mobileMenuBtn">
        <i class="fas fa-bars"></i>
    </button>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
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

        // User dropdown functionality
        const userDropdown = document.getElementById('userDropdown');
        const dropdownMenu = document.querySelector('.dropdown-menu');

        userDropdown.addEventListener('click', function(e) {
            e.stopPropagation();
            this.classList.toggle('active');
            dropdownMenu.classList.toggle('show');
        });

        // Close dropdown when clicking outside
        document.addEventListener('click', function() {
            userDropdown.classList.remove('active');
            dropdownMenu.classList.remove('show');
        });

        // Prevent dropdown from closing when clicking inside
        dropdownMenu.addEventListener('click', function(e) {
            e.stopPropagation();
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

        // Search functionality
        document.querySelector('.search-box input').addEventListener('input', function() {
            const searchValue = this.value.toLowerCase();
            const rows = document.querySelectorAll('tbody tr');
            
            rows.forEach(row => {
                const rowText = row.textContent.toLowerCase();
                if (rowText.includes(searchValue)) {
                    row.style.display = '';
                } else {
                    row.style.display = 'none';
                }
            });
        });

        // Filter functionality
        document.getElementById('applyFilter').addEventListener('click', function() {
            const statusFilter = document.getElementById('statusFilter').value;
            const typeFilter = document.getElementById('typeFilter').value;
            
            document.querySelectorAll('tbody tr').forEach(row => {
                const rowStatus = row.getAttribute('data-status');
                const rowType = row.getAttribute('data-type');
                
                const statusMatch = statusFilter === 'all' || rowStatus === statusFilter;
                const typeMatch = typeFilter === 'all' || rowType === typeFilter;
                
                if (statusMatch && typeMatch) {
                    row.style.display = '';
                } else {
                    row.style.display = 'none';
                }
            });
        });
        
        document.getElementById('resetFilter').addEventListener('click', function() {
            document.getElementById('statusFilter').value = 'all';
            document.getElementById('typeFilter').value = 'all';
            
            document.querySelectorAll('tbody tr').forEach(row => {
                row.style.display = '';
            });
        });
    </script>
</body>
</html>