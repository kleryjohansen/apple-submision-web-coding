<%@ page import="java.sql.*" %>
<%@ include file="dbconnection.jsp" %>

<%
if (session.getAttribute("guest_id") == null) {
    response.sendRedirect("login.jsp");
    return;
}
String guestName = (String) session.getAttribute("guest_name");
%>

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Guest Dashboard | Hotel Reservation</title>
    <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@300;400;500;600;700&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <style>
        :root {
            --primary: #4361ee;
            --primary-light: #3a56d5;
            --primary-dark: #3a0ca3;
            --secondary: #7209b7;
            --success: #4cc9f0;
            --danger: #ef233c;
            --warning: #f8961e;
            --info: #4895ef;
            --light: #f8f9fa;
            --dark: #1b263b;
            --gray: #adb5bd;
            --gray-light: #e9ecef;
            --gray-dark: #495057;
            --white: #ffffff;
            --black: #000000;
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
            line-height: 1.6;
        }

        .sidebar {
            width: 280px;
            background: var(--white);
            box-shadow: 0 0 20px rgba(0,0,0,0.1);
            height: 100vh;
            position: fixed;
            transition: all 0.3s ease;
            z-index: 1000;
            overflow-y: auto;
        }
        
        .sidebar.collapsed {
            width: 80px;
            overflow: hidden;
        }
        
        .sidebar.collapsed .sidebar-header h3,
        .sidebar.collapsed .sidebar-menu a span,
        .sidebar.collapsed .user-info {
            display: none;
        }
        
        .sidebar.collapsed .sidebar-menu a {
            justify-content: center;
            padding: 15px 0;
            border-left: none;
        }
        
        .sidebar.collapsed .sidebar-menu a i {
            margin-right: 0;
            font-size: 1.2rem;
        }
        
        .sidebar.collapsed .user-profile {
            justify-content: center;
            padding: 20px 0;
        }
        
        .sidebar.collapsed .user-profile img {
            margin-right: 0;
        }

        .sidebar-header {
            padding: 20px;
            background: linear-gradient(135deg, var(--primary), var(--primary-dark));
            color: var(--white);
            display: flex;
            align-items: center;
            justify-content: space-between;
            position: sticky;
            top: 0;
            z-index: 1;
        }

        .sidebar-header h3 {
            font-weight: 600;
            font-size: 1.2rem;
        }

        .user-profile {
            display: flex;
            align-items: center;
            padding: 20px;
            border-bottom: 1px solid rgba(0,0,0,0.05);
            background: var(--white);
            transition: all 0.3s;
        }

        .user-profile:hover {
            background: var(--gray-light);
        }

        .user-profile img {
            width: 50px;
            height: 50px;
            border-radius: 50%;
            margin-right: 15px;
            object-fit: cover;
            border: 3px solid rgba(67, 97, 238, 0.2);
        }

        .user-info h4 {
            font-size: 1rem;
            font-weight: 600;
            margin-bottom: 3px;
            color: var(--dark);
        }

        .user-info p {
            font-size: 0.8rem;
            color: var(--gray-dark);
        }

        .sidebar-menu {
            padding: 15px 0;
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
            padding: 12px 25px;
            color: var(--gray-dark);
            text-decoration: none;
            transition: all 0.3s;
            font-size: 0.95rem;
            font-weight: 500;
            border-left: 4px solid transparent;
        }

        .sidebar-menu a i {
            margin-right: 12px;
            width: 20px;
            text-align: center;
            font-size: 1rem;
            color: var(--gray);
        }

        .sidebar-menu a:hover, 
        .sidebar-menu a.active {
            background: rgba(67, 97, 238, 0.1);
            color: var(--primary);
            border-left: 4px solid var(--primary);
        }

        .sidebar-menu a:hover i,
        .sidebar-menu a.active i {
            color: var(--primary);
        }

        .main-content {
            flex: 1;
            margin-left: 280px;
            transition: all 0.3s;
            min-height: 100vh;
        }
        
        .main-content.collapsed {
            margin-left: 80px;
        }

        .top-nav {
            display: flex;
            justify-content: space-between;
            align-items: center;
            padding: 15px 30px;
            background: var(--white);
            box-shadow: 0 2px 15px rgba(0,0,0,0.05);
            position: sticky;
            top: 0;
            z-index: 999;
        }

        .search-box {
            position: relative;
            width: 350px;
        }

        .search-box i {
            position: absolute;
            left: 15px;
            top: 50%;
            transform: translateY(-50%);
            color: var(--gray);
        }

        .search-box input {
            width: 100%;
            padding: 10px 15px 10px 40px;
            border: 1px solid #e0e0e0;
            border-radius: 30px;
            outline: none;
            font-size: 0.9rem;
            transition: all 0.3s;
            background: var(--gray-light);
        }

        .search-box input:focus {
            border-color: var(--primary);
            box-shadow: 0 0 0 3px rgba(67, 97, 238, 0.2);
            background: var(--white);
        }

        .user-menu {
            display: flex;
            align-items: center;
        }

        .user-menu .dropdown-toggle {
            display: flex;
            align-items: center;
            cursor: pointer;
        }

        .user-menu img {
            width: 40px;
            height: 40px;
            border-radius: 50%;
            margin-right: 10px;
            object-fit: cover;
            border: 2px solid var(--primary);
        }

        .user-menu .name {
            font-weight: 500;
            font-size: 0.9rem;
        }

        .content-wrapper {
            padding: 30px;
        }

        .page-header {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 30px;
            flex-wrap: wrap;
            gap: 15px;
        }

        .page-header h2 {
            font-size: 1.8rem;
            font-weight: 600;
            color: var(--dark);
        }

        .breadcrumb {
            display: flex;
            list-style: none;
            padding: 0;
            margin: 0;
            font-size: 0.9rem;
        }

        .breadcrumb li:not(:last-child)::after {
            content: '/';
            margin: 0 8px;
            color: var(--gray);
        }

        .breadcrumb a {
            color: var(--primary);
            text-decoration: none;
            transition: color 0.3s;
        }

        .breadcrumb a:hover {
            color: var(--primary-dark);
            text-decoration: underline;
        }

        .card {
            background: var(--white);
            border-radius: 10px;
            box-shadow: 0 5px 20px rgba(0,0,0,0.05);
            margin-bottom: 30px;
            border: none;
            overflow: hidden;
            transition: transform 0.3s, box-shadow 0.3s;
        }

        .card:hover {
            transform: translateY(-3px);
            box-shadow: 0 8px 25px rgba(0,0,0,0.1);
        }

        .card-header {
            padding: 18px 25px;
            border-bottom: 1px solid rgba(0,0,0,0.05);
            display: flex;
            justify-content: space-between;
            align-items: center;
            background: var(--white);
        }

        .card-header h3 {
            font-size: 1.2rem;
            font-weight: 600;
            color: var(--dark);
            margin: 0;
        }

        .card-body {
            padding: 25px;
        }

        /* Stats Cards */
        .stats-grid {
            display: grid;
            grid-template-columns: repeat(auto-fill, minmax(200px, 1fr));
            gap: 20px;
            margin-bottom: 30px;
        }

        .stat-card {
            background: var(--white);
            border-radius: 10px;
            padding: 20px;
            box-shadow: 0 5px 15px rgba(0,0,0,0.05);
            display: flex;
            align-items: center;
            transition: transform 0.3s, box-shadow 0.3s;
        }

        .stat-card:hover {
            transform: translateY(-3px);
            box-shadow: 0 8px 25px rgba(0,0,0,0.1);
        }

        .stat-icon {
            width: 50px;
            height: 50px;
            border-radius: 50%;
            display: flex;
            align-items: center;
            justify-content: center;
            margin-right: 15px;
            font-size: 1.2rem;
            color: white;
        }

        .stat-icon.blue {
            background: var(--primary);
        }

        .stat-icon.green {
            background: var(--success);
        }

        .stat-icon.orange {
            background: var(--warning);
        }

        .stat-icon.red {
            background: var(--danger);
        }

        .stat-info h3 {
            font-size: 1.5rem;
            font-weight: 700;
            margin-bottom: 5px;
            color: var(--dark);
        }

        .stat-info p {
            font-size: 0.8rem;
            color: var(--gray-dark);
            margin: 0;
        }

        /* Tables */
        .table-responsive {
            overflow-x: auto;
            -webkit-overflow-scrolling: touch;
        }

        .table {
            width: 100%;
            border-collapse: collapse;
            min-width: 800px;
        }

        .table th {
            background: var(--gray-light);
            color: var(--gray-dark);
            font-weight: 600;
            font-size: 0.85rem;
            text-transform: uppercase;
            letter-spacing: 0.5px;
            padding: 15px;
            text-align: left;
            border-bottom: 1px solid #e0e0e0;
        }

        .table td {
            padding: 15px;
            border-bottom: 1px solid #f0f0f0;
            font-size: 0.9rem;
            color: var(--gray-dark);
            vertical-align: middle;
        }

        .table tr:last-child td {
            border-bottom: none;
        }

        .table tr:hover td {
            background: rgba(67, 97, 238, 0.03);
        }

        .status {
            display: inline-block;
            padding: 6px 12px;
            border-radius: 20px;
            font-size: 0.75rem;
            font-weight: 600;
            letter-spacing: 0.5px;
            text-transform: capitalize;
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

        /* Buttons */
        .btn {
            display: inline-flex;
            align-items: center;
            justify-content: center;
            padding: 8px 16px;
            border-radius: 6px;
            font-size: 0.85rem;
            font-weight: 500;
            cursor: pointer;
            transition: all 0.3s;
            border: none;
            text-decoration: none;
            white-space: nowrap;
        }

        .btn i {
            margin-right: 6px;
            font-size: 0.9rem;
        }

        .btn-sm {
            padding: 6px 12px;
            font-size: 0.8rem;
        }

        .btn-sm i {
            font-size: 0.8rem;
            margin-right: 4px;
        }

        .btn-primary {
            background: var(--primary);
            color: var(--white);
            box-shadow: 0 2px 5px rgba(67, 97, 238, 0.2);
        }

        .btn-primary:hover {
            background: var(--primary-light);
            transform: translateY(-2px);
            box-shadow: 0 4px 8px rgba(67, 97, 238, 0.3);
        }

        .btn-outline-primary {
            background: transparent;
            color: var(--primary);
            border: 1px solid var(--primary);
        }

        .btn-outline-primary:hover {
            background: rgba(67, 97, 238, 0.1);
        }

        /* Quick Actions */
        .quick-actions {
            display: grid;
            grid-template-columns: repeat(auto-fill, minmax(200px, 1fr));
            gap: 15px;
        }

        .action-btn {
            display: flex;
            flex-direction: column;
            align-items: center;
            justify-content: center;
            padding: 20px;
            border-radius: 8px;
            text-align: center;
            transition: all 0.3s;
            cursor: pointer;
            text-decoration: none;
        }

        .action-btn i {
            font-size: 1.5rem;
            margin-bottom: 10px;
            color: var(--primary);
        }

        .action-btn.primary {
            background: var(--primary);
            color: var(--white);
        }

        .action-btn.primary i {
            color: var(--white);
        }

        .action-btn:hover {
            transform: translateY(-3px);
            box-shadow: 0 5px 15px rgba(0,0,0,0.1);
        }

        /* Sidebar toggle button */
        .sidebar-toggle {
            position: absolute;
            right: 15px;
            top: 15px;
            background: rgba(255,255,255,0.2);
            border: none;
            color: white;
            width: 30px;
            height: 30px;
            border-radius: 50%;
            display: flex;
            align-items: center;
            justify-content: center;
            cursor: pointer;
            transition: all 0.3s;
        }
        
        .sidebar-toggle:hover {
            background: rgba(255,255,255,0.3);
        }

        /* Floating action button for mobile */
        .fab {
            position: fixed;
            bottom: 30px;
            right: 30px;
            width: 60px;
            height: 60px;
            border-radius: 50%;
            background: var(--primary);
            color: var(--white);
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 1.5rem;
            box-shadow: 0 4px 15px rgba(67, 97, 238, 0.4);
            cursor: pointer;
            z-index: 99;
            transition: all 0.3s;
            display: none;
        }

        .fab:hover {
            transform: scale(1.1);
            background: var(--primary-light);
        }

        /* Responsive styles */
        @media (max-width: 1200px) {
            .sidebar {
                width: 250px;
            }
            
            .sidebar.collapsed {
                width: 80px;
            }
            
            .main-content {
                margin-left: 250px;
            }
            
            .main-content.collapsed {
                margin-left: 80px;
            }
        }

        @media (max-width: 992px) {
            .search-box {
                width: 250px;
            }
        }

        @media (max-width: 768px) {
            .top-nav {
                padding: 12px 20px;
            }
            .content-wrapper {
                padding: 20px;
            }
            .search-box {
                width: 200px;
            }
            .stats-grid {
                grid-template-columns: repeat(2, 1fr);
            }
            .fab {
                display: flex;
            }
        }

        @media (max-width: 576px) {
            .sidebar {
                transform: translateX(-100%);
                position: fixed;
                width: 280px;
                z-index: 1000;
            }
            
            .sidebar.active {
                transform: translateX(0);
            }
            
            .sidebar.collapsed {
                width: 280px;
            }
            
            .main-content {
                margin-left: 0;
            }
            
            .main-content.collapsed {
                margin-left: 0;
            }
            
            .search-box {
                width: 150px;
            }
            
            .user-menu .name {
                display: none;
            }
            
            .stats-grid {
                grid-template-columns: 1fr;
            }
            
            .quick-actions {
                grid-template-columns: 1fr;
            }
        }

        /* Animation */
        @keyframes fadeIn {
            from { opacity: 0; transform: translateY(10px); }
            to { opacity: 1; transform: translateY(0); }
        }

        .stats-grid .stat-card {
            animation: fadeIn 0.3s ease forwards;
            opacity: 0;
        }

        .stats-grid .stat-card:nth-child(1) { animation-delay: 0.1s; }
        .stats-grid .stat-card:nth-child(2) { animation-delay: 0.2s; }
        .stats-grid .stat-card:nth-child(3) { animation-delay: 0.3s; }
        .stats-grid .stat-card:nth-child(4) { animation-delay: 0.4s; }
    </style>
</head>
<body>
    <div class="sidebar" id="sidebar">
        <div class="sidebar-header">
            <h3>Hotel Guest</h3>
            <button class="sidebar-toggle" id="sidebarToggle">
                <i class="fas fa-chevron-left"></i>
            </button>
        </div>
        
        <div class="user-profile">
            <img src="https://ui-avatars.com/api/?name=<%= guestName %>&background=4361ee&color=fff" alt="<%= guestName %>">
            <div class="user-info">
                <h4><%= guestName %></h4>
                <p>Guest Member</p>
            </div>
        </div>
        
        <div class="sidebar-menu">
            <ul>
                <li><a href="dashboard.jsp" class="active"><i class="fas fa-tachometer-alt"></i><span>Dashboard</span></a></li>
                <li><a href="book_room.jsp"><i class="fas fa-calendar-check"></i><span>Book Room</span></a></li>
                <li><a href="my_reservations.jsp"><i class="fas fa-bed"></i><span>My Reservations</span></a></li>
                <li><a href="payment.jsp"><i class="fas fa-credit-card"></i><span>Payments</span></a></li>
                <li><a href="profile.jsp"><i class="fas fa-user"></i><span>My Profile</span></a></li>
                <li><a href="logout.jsp"><i class="fas fa-sign-out-alt"></i><span>Logout</span></a></li>
            </ul>
        </div>
    </div>

    <div class="main-content" id="mainContent">
        <div class="top-nav">
            <div class="search-box">
                <i class="fas fa-search"></i>
                <input type="text" placeholder="Search...">
            </div>
            <div class="user-menu">
                <div class="dropdown-toggle">
                    <img src="https://ui-avatars.com/api/?name=<%= guestName %>&background=4361ee&color=fff" alt="<%= guestName %>">
                    <span class="name"><%= guestName %></span>
                </div>
            </div>
        </div>

        <div class="content-wrapper">
            <div class="page-header">
                <h2>Dashboard Overview</h2>
                <ul class="breadcrumb">
                    <li><a href="dashboard.jsp">Home</a></li>
                    <li>Dashboard</li>
                </ul>
            </div>

            <!-- Stats Cards -->
            <div class="stats-grid">
                <div class="stat-card">
                    <div class="stat-icon blue">
                        <i class="fas fa-calendar-check"></i>
                    </div>
                    <div class="stat-info">
                        <h3>
                            <%
                            try {
                                int guestId = (Integer) session.getAttribute("guest_id");
                                PreparedStatement ps = conn.prepareStatement("SELECT COUNT(*) AS total FROM reservations WHERE guest_id = ?");
                                ps.setInt(1, guestId);
                                ResultSet rs = ps.executeQuery();
                                if(rs.next()) {
                                    out.print(rs.getInt("total"));
                                }
                            } catch(SQLException e) {
                                out.print("0");
                            }
                            %>
                        </h3>
                        <p>Total Reservations</p>
                    </div>
                </div>
                
                <div class="stat-card">
                    <div class="stat-icon green">
                        <i class="fas fa-check-circle"></i>
                    </div>
                    <div class="stat-info">
                        <h3>
                            <%
                            try {
                                int guestId = (Integer) session.getAttribute("guest_id");
                                PreparedStatement ps = conn.prepareStatement("SELECT COUNT(*) AS total FROM reservations WHERE guest_id = ? AND payment_status = 'completed'");
                                ps.setInt(1, guestId);
                                ResultSet rs = ps.executeQuery();
                                if(rs.next()) {
                                    out.print(rs.getInt("total"));
                                }
                            } catch(SQLException e) {
                                out.print("0");
                            }
                            %>
                        </h3>
                        <p>Confirmed Bookings</p>
                    </div>
                </div>
                
                <div class="stat-card">
                    <div class="stat-icon orange">
                        <i class="fas fa-clock"></i>
                    </div>
                    <div class="stat-info">
                        <h3>
                            <%
                            try {
                                int guestId = (Integer) session.getAttribute("guest_id");
                                PreparedStatement ps = conn.prepareStatement("SELECT COUNT(*) AS total FROM reservations WHERE guest_id = ? AND payment_status = 'pending'");
                                ps.setInt(1, guestId);
                                ResultSet rs = ps.executeQuery();
                                if(rs.next()) {
                                    out.print(rs.getInt("total"));
                                }
                            } catch(SQLException e) {
                                out.print("0");
                            }
                            %>
                        </h3>
                        <p>Pending Payments</p>
                    </div>
                </div>
                
                <div class="stat-card">
                    <div class="stat-icon red">
                        <i class="fas fa-times-circle"></i>
                    </div>
                    <div class="stat-info">
                        <h3>
                            <%
                            try {
                                int guestId = (Integer) session.getAttribute("guest_id");
                                PreparedStatement ps = conn.prepareStatement("SELECT COUNT(*) AS total FROM reservations WHERE guest_id = ? AND payment_status = 'cancelled'");
                                ps.setInt(1, guestId);
                                ResultSet rs = ps.executeQuery();
                                if(rs.next()) {
                                    out.print(rs.getInt("total"));
                                }
                            } catch(SQLException e) {
                                out.print("0");
                            }
                            %>
                        </h3>
                        <p>Cancelled Bookings</p>
                    </div>
                </div>
            </div>

            <!-- Upcoming Reservations Card -->
            <div class="card">
                <div class="card-header">
                    <h3>Upcoming Reservations</h3>
                    <a href="my_reservations.jsp" class="btn btn-outline-primary btn-sm">
                        <i class="fas fa-eye"></i> View All
                    </a>
                </div>
                <div class="card-body">
                    <div class="table-responsive">
                        <table class="table">
                            <thead>
                                <tr>
                                    <th>Reservation ID</th>
                                    <th>Room Type</th>
                                    <th>Check-In</th>
                                    <th>Check-Out</th>
                                    <th>Amount</th>
                                    <th>Status</th>
                                    <th>Actions</th>
                                </tr>
                            </thead>
                            <tbody>
                                <%
                                try {
                                    int guestId = (Integer) session.getAttribute("guest_id");
                                    String sql = "SELECT r.reservation_id, rm.type, r.check_in, r.check_out, " +
                                                 "p.amount, r.payment_status " +
                                                 "FROM reservations r " +
                                                 "JOIN rooms rm ON r.room_id = rm.room_id " +
                                                 "LEFT JOIN payments p ON r.reservation_id = p.reservation_id " +
                                                 "WHERE r.guest_id = ? AND r.check_out >= CURDATE() " +
                                                 "ORDER BY r.check_in ASC LIMIT 3";
                                    PreparedStatement ps = conn.prepareStatement(sql);
                                    ps.setInt(1, guestId);
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
                                    <td><%= rs.getString("type") %></td>
                                    <td><%= rs.getDate("check_in") %></td>
                                    <td><%= rs.getDate("check_out") %></td>
                                    <td>Rp<%= rs.getBigDecimal("amount") != null ? rs.getBigDecimal("amount") : "0" %></td>
                                    <td><span class="status <%= statusClass %>"><%= rs.getString("payment_status") %></span></td>
                                    <td>
                                        <a href="view_reservation.jsp?id=<%= rs.getInt("reservation_id") %>" class="btn btn-primary btn-sm">
                                            <i class="fas fa-eye"></i> View
                                        </a>
                                    </td>
                                </tr>
                                <%
                                    }
                                } catch(SQLException e) {
                                    out.println("<tr><td colspan='7' style='text-align: center; color: var(--danger);'>Error loading reservations: " + e.getMessage() + "</td></tr>");
                                }
                                %>
                            </tbody>
                        </table>
                    </div>
                </div>
            </div>

            <!-- Quick Actions Card -->
            <div class="card">
                <div class="card-header">
                    <h3>Quick Actions</h3>
                </div>
                <div class="card-body">
                    <div class="quick-actions">
                        <a href="book_room.jsp" class="action-btn primary">
                            <i class="fas fa-calendar-plus"></i>
                            <span>Book a Room</span>
                        </a>
                        <a href="my_reservations.jsp" class="action-btn">
                            <i class="fas fa-bed"></i>
                            <span>My Reservations</span>
                        </a>
                        <a href="payment.jsp" class="action-btn">
                            <i class="fas fa-credit-card"></i>
                            <span>Make Payment</span>
                        </a>
                        <a href="profile.jsp" class="action-btn">
                            <i class="fas fa-user-cog"></i>
                            <span>Update Profile</span>
                        </a>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <div class="fab" id="mobileSidebarToggle">
        <i class="fas fa-bars"></i>
    </div>

    <script>
        document.addEventListener('DOMContentLoaded', function() {
            const sidebar = document.getElementById('sidebar');
            const mainContent = document.getElementById('mainContent');
            const sidebarToggle = document.getElementById('sidebarToggle');
            const mobileSidebarToggle = document.getElementById('mobileSidebarToggle');
            
            // Toggle sidebar collapse
            sidebarToggle.addEventListener('click', function() {
                sidebar.classList.toggle('collapsed');
                mainContent.classList.toggle('collapsed');
                
                // Change the icon based on state
                const icon = sidebarToggle.querySelector('i');
                if(sidebar.classList.contains('collapsed')) {
                    icon.classList.remove('fa-chevron-left');
                    icon.classList.add('fa-chevron-right');
                } else {
                    icon.classList.remove('fa-chevron-right');
                    icon.classList.add('fa-chevron-left');
                }
                
                // Save state to localStorage
                localStorage.setItem('sidebarCollapsed', sidebar.classList.contains('collapsed'));
            });
            
            // Toggle sidebar on mobile
            mobileSidebarToggle.addEventListener('click', function() {
                sidebar.classList.toggle('active');
            });
            
            // Show/hide FAB based on screen size
            function updateFabVisibility() {
                if(window.innerWidth <= 768) {
                    mobileSidebarToggle.style.display = 'flex';
                } else {
                    mobileSidebarToggle.style.display = 'none';
                    sidebar.classList.remove('active');
                }
            }
            
            window.addEventListener('resize', updateFabVisibility);
            updateFabVisibility();
            
            // Check for collapsed state in localStorage
            if(localStorage.getItem('sidebarCollapsed') === 'true') {
                sidebar.classList.add('collapsed');
                mainContent.classList.add('collapsed');
                const icon = sidebarToggle.querySelector('i');
                icon.classList.remove('fa-chevron-left');
                icon.classList.add('fa-chevron-right');
            }
        });
    </script>
</body>
</html>