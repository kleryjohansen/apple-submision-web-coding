<%@ page import="java.sql.*" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ include file="dbconnection.jsp" %>
<%
if(session.getAttribute("admin") == null) {
    response.sendRedirect("admin_login.jsp");
    return;
}

String filterStatus = request.getParameter("status");
String filterStartDate = request.getParameter("start_date");
String filterEndDate = request.getParameter("end_date");
String filterRoomType = request.getParameter("room_type");
%>
<!DOCTYPE html>
<html>
<head>
    <title>Admin Reservations | Hotel Management</title>
    <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@300;400;500;600;700&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/animate.css@4.1.1/animate.min.css">
    <!-- Date Range Picker CSS -->
    <link rel="stylesheet" type="text/css" href="https://cdn.jsdelivr.net/npm/daterangepicker/daterangepicker.css" />
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
            flex-direction: column;
        }

        .card-header h3 {
            font-size: 1.1rem;
            font-weight: 600;
            margin: 0;
        }

        .card-body {
            padding: 20px;
        }

        /* Filter Styles */
        .filter-form {
            margin-top: 15px;
            width: 100%;
        }

        .filter-controls {
            display: flex;
            flex-wrap: wrap;
            gap: 15px;
            align-items: flex-end;
        }

        .filter-group {
            flex: 1;
            min-width: 180px;
        }

        .filter-group label {
            display: block;
            margin-bottom: 5px;
            font-size: 0.8rem;
            color: var(--gray-dark);
            font-weight: 500;
        }

        .filter-actions {
            display: flex;
            gap: 10px;
            margin-left: auto;
        }

        .date-range-picker {
            background-color: white;
            cursor: pointer;
        }

        /* Active filter indicators */
        .active-filters {
            display: flex;
            flex-wrap: wrap;
            gap: 10px;
            margin-top: 15px;
        }

        .filter-tag {
            display: inline-flex;
            align-items: center;
            padding: 5px 10px;
            background-color: rgba(67, 97, 238, 0.1);
            border-radius: 20px;
            font-size: 0.75rem;
            color: var(--primary);
        }

        .filter-tag button {
            background: none;
            border: none;
            color: var(--primary);
            margin-left: 5px;
            cursor: pointer;
            font-size: 0.7rem;
        }

        /* Reservation Table Styles */
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

        .status-badge {
            display: inline-block;
            padding: 5px 10px;
            border-radius: 20px;
            font-size: 0.75rem;
            font-weight: 500;
            text-transform: capitalize;
        }

        .status-pending {
            background: rgba(248, 150, 30, 0.1);
            color: var(--warning);
        }

        .status-confirmed {
            background: rgba(16, 185, 129, 0.1);
            color: var(--success);
        }

        .status-cancelled {
            background: rgba(239, 68, 68, 0.1);
            color: var(--danger);
        }

        .guest-info { 
            display: flex; 
            align-items: center; 
            gap: 0.75rem; 
        }
        
        .guest-avatar {
            width: 36px;
            height: 36px;
            background: linear-gradient(135deg, var(--primary), #8b5cf6);
            border-radius: 50%;
            display: flex;
            justify-content: center;
            align-items: center;
            font-weight: 600;
            color: white;
            flex-shrink: 0;
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

        /* Empty State */
        .empty-state {
            padding: 3rem 0;
            text-align: center;
        }

        .empty-state i {
            font-size: 4rem;
            color: #cbd5e1;
            margin-bottom: 1rem;
        }

        .empty-state h3 {
            color: #64748b;
            margin-bottom: 0.5rem;
        }

        .empty-state p {
            color: #94a3b8;
            max-width: 400px;
            margin: 0 auto 1.5rem;
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
            
            .filter-controls {
                flex-direction: column;
            }
            
            .filter-group {
                width: 100%;
            }
            
            .filter-actions {
                margin-left: 0;
                width: 100%;
                justify-content: flex-end;
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
            
            .guest-info {
                justify-content: space-between;
                width: 100%;
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
                    <a href="admin_reservations.jsp" class="active">
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
                <i class="fas fa-search"></i>
                <input type="text" placeholder="Search...">
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
                <h2>Reservation Management</h2>
                <ul class="breadcrumb">
                    <li><a href="admin_dashboard.jsp">Home</a></li>
                    <li>Reservations</li>
                </ul>
            </div>

            <div class="card">
                <div class="card-header">
                    <h3>All Reservations</h3>
                    <form action="admin_reservations.jsp" method="get" class="filter-form">
                        <div class="filter-controls">
                            <div class="filter-group">
                                <label for="status">Status</label>
                                <select id="status" name="status" class="form-select">
                                    <option value="all">All Statuses</option>
                                    <option value="pending" <%= "pending".equals(filterStatus) ? "selected" : "" %>>Pending</option>
                                    <option value="completed" <%= "completed".equals(filterStatus) ? "selected" : "" %>>Completed</option>
                                    <option value="cancelled" <%= "cancelled".equals(filterStatus) ? "selected" : "" %>>Cancelled</option>
                                </select>
                            </div>
                            
                            <div class="filter-group">
                                <label for="room_type">Room Type</label>
                                <select id="room_type" name="room_type" class="form-select">
                                    <option value="all">All Room Types</option>
                                    <option value="Single" <%= "Single".equals(filterRoomType) ? "selected" : "" %>>Single</option>
                                    <option value="Double" <%= "Double".equals(filterRoomType) ? "selected" : "" %>>Double</option>
                                    <option value="Suite" <%= "Suite".equals(filterRoomType) ? "selected" : "" %>>Suite</option>
                                </select>
                            </div>
                            
                            <div class="filter-group">
                                <label for="date_range">Date Range</label>
                                <input type="text" id="date_range" name="date_range" class="form-control date-range-picker" 
                                       placeholder="Select date range" 
                                       value="<%= (filterStartDate != null && filterEndDate != null) ? filterStartDate + " to " + filterEndDate : "" %>">
                                <input type="hidden" id="start_date" name="start_date" value="<%= filterStartDate != null ? filterStartDate : "" %>">
                                <input type="hidden" id="end_date" name="end_date" value="<%= filterEndDate != null ? filterEndDate : "" %>">
                            </div>
                            
                            <div class="filter-actions">
                                <button type="submit" class="btn btn-primary">
                                    <i class="fas fa-filter"></i> Filter
                                </button>
                                <% if (filterStatus != null || filterRoomType != null || filterStartDate != null) { %>
                                <a href="admin_reservations.jsp" class="btn btn-outline-primary">
                                    <i class="fas fa-times"></i> Clear
                                </a>
                                <% } %>
                            </div>
                        </div>
                        
                        <% if (filterStatus != null || filterRoomType != null || filterStartDate != null) { %>
                        <div class="active-filters">
                            <% if (filterStatus != null && !filterStatus.equals("all")) { %>
                            <div class="filter-tag">
                                Status: <%= filterStatus %>
                                <a href="admin_reservations.jsp?<%= 
                                    (filterRoomType != null ? "room_type=" + filterRoomType + "&" : "") + 
                                    (filterStartDate != null ? "start_date=" + filterStartDate + "&end_date=" + filterEndDate : "") 
                                %>" class="remove-filter">
                                    <i class="fas fa-times"></i>
                                </a>
                            </div>
                            <% } %>
                            
                            <% if (filterRoomType != null && !filterRoomType.equals("all")) { %>
                            <div class="filter-tag">
                                Room Type: <%= filterRoomType %>
                                <a href="admin_reservations.jsp?<%= 
                                    (filterStatus != null ? "status=" + filterStatus + "&" : "") + 
                                    (filterStartDate != null ? "start_date=" + filterStartDate + "&end_date=" + filterEndDate : "") 
                                %>" class="remove-filter">
                                    <i class="fas fa-times"></i>
                                </a>
                            </div>
                            <% } %>
                            
                            <% if (filterStartDate != null) { %>
                            <div class="filter-tag">
                                Dates: <%= filterStartDate %> to <%= filterEndDate %>
                                <a href="admin_reservations.jsp?<%= 
                                    (filterStatus != null ? "status=" + filterStatus + "&" : "") + 
                                    (filterRoomType != null ? "room_type=" + filterRoomType : "") 
                                %>" class="remove-filter">
                                    <i class="fas fa-times"></i>
                                </a>
                            </div>
                            <% } %>
                        </div>
                        <% } %>
                    </form>
                </div>
                <div class="card-body">
                    <div class="table-responsive">
                        <table class="table">
                            <thead>
                                <tr>
                                    <th>Reservation ID</th>
                                    <th>Guest</th>
                                    <th>Room</th>
                                    <th>Dates</th>
                                    <th>Payment</th>
                                    <th>Status</th>
                                    <th>Actions</th>
                                </tr>
                            </thead>
                            <tbody>
                            <% 
                            String sql = "SELECT r.reservation_id, g.name AS guest_name, g.email, " +
                                         "rm.room_number, rm.type, rm.price, " +
                                         "r.check_in, r.check_out, r.payment_status, " +
                                         "p.payment_method, p.amount, p.payment_date " +
                                         "FROM reservations r " +
                                         "JOIN guests g ON r.guest_id = g.guest_id " +
                                         "JOIN rooms rm ON r.room_id = rm.room_id " +
                                         "LEFT JOIN payments p ON r.reservation_id = p.reservation_id " +
                                         "WHERE 1=1";

                            if (filterStatus != null && !filterStatus.equals("all")) {
                                sql += " AND r.payment_status = ?";
                            }
                            if (filterStartDate != null && !filterStartDate.isEmpty()) {
                                sql += " AND r.check_in >= ?";
                            }
                            if (filterEndDate != null && !filterEndDate.isEmpty()) {
                                sql += " AND r.check_out <= ?";
                            }
                            if (filterRoomType != null && !filterRoomType.equals("all")) {
                                sql += " AND rm.type = ?";
                            }

                            sql += " ORDER BY r.check_in DESC";

                            try {
                                PreparedStatement stmt = conn.prepareStatement(sql);

                                int paramIndex = 1;
                                if (filterStatus != null && !filterStatus.equals("all")) {
                                    stmt.setString(paramIndex++, filterStatus);
                                }
                                if (filterStartDate != null && !filterStartDate.isEmpty()) {
                                    stmt.setDate(paramIndex++, java.sql.Date.valueOf(filterStartDate));
                                }
                                if (filterEndDate != null && !filterEndDate.isEmpty()) {
                                    stmt.setDate(paramIndex++, java.sql.Date.valueOf(filterEndDate));
                                }
                                if (filterRoomType != null && !filterRoomType.equals("all")) {
                                    stmt.setString(paramIndex++, filterRoomType);
                                }

                                ResultSet rs = stmt.executeQuery();
                                boolean hasResults = false;
                                
                                while (rs.next()) {
                                    hasResults = true;
                                    String statusClass = "";
                                    String statusText = "";
                                    switch (rs.getString("payment_status")) {
                                        case "pending":
                                            statusClass = "status-pending";
                                            statusText = "Pending";
                                            break;
                                        case "completed":
                                            statusClass = "status-confirmed";
                                            statusText = "Confirmed";
                                            break;
                                        case "cancelled":
                                            statusClass = "status-cancelled";
                                            statusText = "Cancelled";
                                            break;
                                    }

                                    String guestInitial = rs.getString("guest_name").substring(0, 1).toUpperCase();
                                    String checkIn = new java.text.SimpleDateFormat("MMM d, yyyy").format(rs.getDate("check_in"));
                                    String checkOut = new java.text.SimpleDateFormat("MMM d, yyyy").format(rs.getDate("check_out"));
                                    String paymentDate = rs.getDate("payment_date") != null ? 
                                        new java.text.SimpleDateFormat("MMM d, yyyy").format(rs.getDate("payment_date")) : "-";
                            %>
                                <tr class="animate__animated animate__fadeIn">
                                    <td data-label="Reservation ID">
                                        <span class="fw-bold">#<%= rs.getInt("reservation_id") %></span>
                                    </td>
                                    <td data-label="Guest">
                                        <div class="guest-info">
                                            <div class="guest-avatar" title="<%= rs.getString("email") %>"><%= guestInitial %></div>
                                            <div>
                                                <div class="fw-bold"><%= rs.getString("guest_name") %></div>
                                                <div class="text-muted small"><%= rs.getString("email") %></div>
                                            </div>
                                        </div>
                                    </td>
                                    <td data-label="Room">
                                        <div class="fw-bold">Room <%= rs.getString("room_number") %></div>
                                        <div class="text-muted small"><%= rs.getString("type") %></div>
                                    </td>
                                    <td data-label="Dates">
                                        <div class="fw-bold"><%= checkIn %></div>
                                        <div class="text-muted small">to <%= checkOut %></div>
                                    </td>
                                    <td data-label="Payment">
                                        <div class="fw-bold">$<%= rs.getBigDecimal("amount") != null ? rs.getBigDecimal("amount") : "0" %></div>
                                        <div class="text-muted small"><%= rs.getString("payment_method") != null ? rs.getString("payment_method") : "-" %></div>
                                    </td>
                                    <td data-label="Status">
                                        <span class="status-badge <%= statusClass %>"><i class="fas <%= 
                                            statusClass.equals("status-pending") ? "fa-clock" : 
                                            statusClass.equals("status-confirmed") ? "fa-check-circle" : 
                                            "fa-times-circle" %> me-1"></i> <%= statusText %></span>
                                    </td>
                                    <td data-label="Actions">
                                        <div class="d-flex gap-2">
                                            <a href="admin_view_reservation.jsp?reservation_id=<%= rs.getInt("reservation_id") %>" class="btn btn-sm btn-primary">
                                                <i class="fas fa-eye"></i>
                                            </a>
                                        </div>
                                    </td>
                                </tr>
                            <% 
                                }
                                
                                if (!hasResults) {
                            %>
                                <tr>
                                    <td colspan="7">
                                        <div class="empty-state">
                                            <i class="fas fa-calendar-times"></i>
                                            <h3>No reservations found</h3>
                                            <p>There are no reservations matching your criteria. Try adjusting your filters.</p>
                                            <button class="btn btn-primary" onclick="document.querySelector('.filter-form').scrollIntoView({ behavior: 'smooth' })">
                                                <i class="fas fa-sliders-h me-1"></i> Adjust Filters
                                            </button>
                                        </div>
                                    </td>
                                </tr>
                            <%
                                }
                                
                                rs.close();
                                stmt.close();
                            } catch (Exception e) {
                                out.println("<tr><td colspan='7' class='text-center text-danger py-4'>Error loading reservations: " + e.getMessage() + "</td></tr>");
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

    <!-- Required Libraries -->
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
    <script type="text/javascript" src="https://cdn.jsdelivr.net/jquery/latest/jquery.min.js"></script>
    <script type="text/javascript" src="https://cdn.jsdelivr.net/momentjs/latest/moment.min.js"></script>
    <script type="text/javascript" src="https://cdn.jsdelivr.net/npm/daterangepicker/daterangepicker.min.js"></script>
    
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

        // Search functionality
        document.querySelector('.search-box input').addEventListener('input', function() {
            const searchValue = this.value.toLowerCase();
            const rows = document.querySelectorAll('tbody tr');
            
            rows.forEach(row => {
                const rowText = row.textContent.toLowerCase();
                if (rowText.includes(searchValue)) {
                    row.style.display = '';
                    row.classList.add('animate__fadeIn');
                } else {
                    row.style.display = 'none';
                }
            });
        });

        // Date range picker initialization
        $(document).ready(function() {
            $('.date-range-picker').daterangepicker({
                opens: 'right',
                autoUpdateInput: false,
                locale: {
                    cancelLabel: 'Clear',
                    format: 'YYYY-MM-DD'
                }
            });

            $('.date-range-picker').on('apply.daterangepicker', function(ev, picker) {
                $(this).val(picker.startDate.format('YYYY-MM-DD') + ' to ' + picker.endDate.format('YYYY-MM-DD'));
                $('#start_date').val(picker.startDate.format('YYYY-MM-DD'));
                $('#end_date').val(picker.endDate.format('YYYY-MM-DD'));
            });

            $('.date-range-picker').on('cancel.daterangepicker', function(ev, picker) {
                $(this).val('');
                $('#start_date').val('');
                $('#end_date').val('');
            });

            // Initialize with existing values if any
            const startDate = $('#start_date').val();
            const endDate = $('#end_date').val();
            if (startDate && endDate) {
                $('.date-range-picker').val(startDate + ' to ' + endDate);
            }
        });

        // Auto-submit when filters change (optional)
        document.querySelectorAll('.filter-form select').forEach(select => {
            select.addEventListener('change', function() {
                this.form.submit();
            });
        });
    </script>
</body>
</html>