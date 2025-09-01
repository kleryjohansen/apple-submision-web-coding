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
    <title>My Reservations | Hotel Reservation</title>
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

        .status-completed {
            background: #cce5ff;
            color: #004085;
        }

        .status-cancelled {
            background: #f8d7da;
            color: #721c24;
        }

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

        .btn-danger {
            background: var(--danger);
            color: var(--white);
            box-shadow: 0 2px 5px rgba(239, 35, 60, 0.2);
        }

        .btn-danger:hover {
            background: #dc3545;
            transform: translateY(-2px);
            box-shadow: 0 4px 8px rgba(239, 35, 60, 0.3);
        }

        .btn-review {
            background: #ffc107;
            color: #000;
            box-shadow: 0 2px 5px rgba(255, 193, 7, 0.2);
        }

        .btn-review:hover {
            background: #e0a800;
            transform: translateY(-2px);
            box-shadow: 0 4px 8px rgba(255, 193, 7, 0.3);
            color: #000;
        }

        .btn-info {
            background: var(--info);
            color: var(--white);
            box-shadow: 0 2px 5px rgba(72, 149, 239, 0.2);
        }

        .btn-info:hover {
            background: #3d8bfd;
            transform: translateY(-2px);
            box-shadow: 0 4px 8px rgba(72, 149, 239, 0.3);
        }

        .btn-group {
            display: flex;
            gap: 8px;
            flex-wrap: wrap;
        }

        .no-reservations {
            text-align: center;
            padding: 40px;
            color: var(--gray-dark);
        }

        .no-reservations i {
            font-size: 3rem;
            color: var(--gray);
            margin-bottom: 15px;
        }

        .no-reservations h4 {
            font-size: 1.2rem;
            margin-bottom: 10px;
            color: var(--dark);
        }

        .no-reservations p {
            margin-bottom: 20px;
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
            .card-header {
                flex-direction: column;
                align-items: flex-start;
                gap: 10px;
            }
            .fab {
                display: flex;
            }
            .btn-group {
                flex-direction: column;
                gap: 5px;
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
        }

        /* Animation */
        @keyframes fadeIn {
            from { opacity: 0; transform: translateY(10px); }
            to { opacity: 1; transform: translateY(0); }
        }

        .table tr {
            animation: fadeIn 0.3s ease forwards;
            opacity: 0;
        }

        .table tr:nth-child(1) { animation-delay: 0.1s; }
        .table tr:nth-child(2) { animation-delay: 0.2s; }
        .table tr:nth-child(3) { animation-delay: 0.3s; }
        .table tr:nth-child(4) { animation-delay: 0.4s; }
        .table tr:nth-child(5) { animation-delay: 0.5s; }
        .table tr:nth-child(6) { animation-delay: 0.6s; }
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
                <li><a href="dashboard.jsp"><i class="fas fa-tachometer-alt"></i><span>Dashboard</span></a></li>
                <li><a href="book_room.jsp"><i class="fas fa-calendar-check"></i><span>Book Room</span></a></li>
                <li><a href="my_reservations.jsp" class="active"><i class="fas fa-bed"></i><span>My Reservations</span></a></li>
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
                <input type="text" placeholder="Search reservations..." id="searchInput">
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
                <h2>My Reservations</h2>
                <ul class="breadcrumb">
                    <li><a href="dashboard.jsp">Home</a></li>
                    <li>My Reservations</li>
                </ul>
            </div>

            <div class="card">
                <div class="card-header">
                    <h3>All Reservations</h3>
                    <a href="book_room.jsp" class="btn btn-primary">
                        <i class="fas fa-plus"></i> New Reservation
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
                                    <th>Nights</th>
                                    <th>Amount</th>
                                    <th>Status</th>
                                    <th>Review</th>
                                    <th>Actions</th>
                                </tr>
                            </thead>
                            <tbody>
                                <%
                                try {
                                    int guestId = (Integer) session.getAttribute("guest_id");
                                    String sql = "SELECT r.reservation_id, rm.type, r.check_in, r.check_out, " +
                                            "rm.price, p.amount, r.payment_status, r.room_id, rm.room_id " +
                                            "FROM reservations r " +
                                            "JOIN rooms rm ON r.room_id = rm.room_id " +
                                            "LEFT JOIN payments p ON r.reservation_id = p.reservation_id " +
                                            "WHERE r.guest_id = ? " +
                                            "ORDER BY r.check_in DESC";
                                    PreparedStatement ps = conn.prepareStatement(sql);
                                    ps.setInt(1, guestId);
                                    ResultSet rs = ps.executeQuery();

                                    boolean hasReservations = false;
                                    
                                    while(rs.next()) {
                                        hasReservations = true;
                                        String statusClass = "";
                                        String statusText = rs.getString("payment_status");
                                        switch(statusText) {
                                            case "pending": 
                                                statusClass = "status-pending"; 
                                                statusText = "Pending Payment";
                                                break;
                                            case "completed": 
                                                statusClass = "status-confirmed"; 
                                                statusText = "Confirmed";
                                                break;
                                            case "cancelled": 
                                                statusClass = "status-cancelled"; 
                                                statusText = "Cancelled";
                                                break;
                                            case "paid": 
                                                statusClass = "status-completed"; 
                                                statusText = "Paid";
                                                break;
                                        }
                                        
                                        // Calculate nights stayed
                                        java.sql.Date checkIn = rs.getDate("check_in");
                                        java.sql.Date checkOut = rs.getDate("check_out");
                                        long diffInMillies = checkOut.getTime() - checkIn.getTime();
                                        int nightsStayed = (int) (diffInMillies / (1000 * 60 * 60 * 24));
                                        
                                        // Calculate total amount
                                        double totalAmount = nightsStayed * rs.getDouble("price");
                                        if(rs.getDouble("amount") > 0) {
                                            totalAmount = rs.getDouble("amount");
                                        }
                                        
                                        // Check if stay is completed for review
                                        java.util.Date today = new java.util.Date();
                                        boolean stayCompleted = checkOut.before(today);
                                %>
                                <tr>
                                    <td>#<%= rs.getInt("reservation_id") %></td>
                                    <td><%= rs.getString("type") %></td>
                                    <td><%= checkIn %></td>
                                    <td><%= checkOut %></td>
                                    <td><%= nightsStayed %></td>
                                    <td>Rp <%= String.format("%,.2f", totalAmount) %></td>
                                    <td><span class="status <%= statusClass %>"><%= statusText %></span></td>
                                    <td>
                                        <%
                                        if (stayCompleted) {
                                            // Check if review already exists
                                            String reviewCheckSql = "SELECT 1 FROM reviews WHERE guest_id = ? AND room_id = ?";
                                            PreparedStatement psReviewCheck = conn.prepareStatement(reviewCheckSql);
                                            psReviewCheck.setInt(1, guestId);
                                            psReviewCheck.setInt(2, rs.getInt("room_id"));
                                            boolean hasReviewed = psReviewCheck.executeQuery().next();
                                            
                                            if (hasReviewed) {
                                        %>
                                                <span class="status status-completed">Reviewed</span>
                                        <%
                                            } else {
                                        %>
                                                <a href="room_details.jsp?room_id=<%= rs.getInt("room_id") %>#reviews" 
                                                   class="btn btn-review btn-sm">
                                                    <i class="fas fa-star"></i> Review
                                                </a>
                                        <%
                                            }
                                        } else {
                                        %>
                                            <span class="text-muted">After stay</span>
                                        <%
                                        }
                                        %>
                                    </td>
                                    <td>
                                        <div class="btn-group">
                                            <a href="view_reservation.jsp?id=<%= rs.getInt("reservation_id") %>" class="btn btn-primary btn-sm">
                                                <i class="fas fa-eye"></i> View
                                            </a>
                                            <% if(rs.getString("payment_status").equals("pending")) { %>
                                            <a href="cancel_reservation.jsp?id=<%= rs.getInt("reservation_id") %>" class="btn btn-danger btn-sm" 
                                               onclick="return confirm('Are you sure you want to cancel this reservation?')">
                                                <i class="fas fa-times"></i> Cancel
                                            </a>
                                            <% } %>
                                            <% if(rs.getString("payment_status").equals("completed") || rs.getString("payment_status").equals("paid")) { %>
                                            <a href="extend_reservation.jsp?id=<%= rs.getInt("reservation_id") %>" class="btn btn-info btn-sm">
                                                <i class="fas fa-calendar-plus"></i> Extend
                                            </a>
                                            <% } %>
                                        </div>
                                    </td>
                                </tr>
                                <%
                                    }
                                    
                                    if(!hasReservations) {
                                %>
                                <tr>
                                    <td colspan="9">
                                        <div class="no-reservations">
                                            <i class="fas fa-bed"></i>
                                            <h4>No Reservations Found</h4>
                                            <p>You haven't made any reservations yet. Book a room to get started!</p>
                                            <a href="book_room.jsp" class="btn btn-primary">
                                                <i class="fas fa-calendar-check"></i> Book a Room
                                            </a>
                                        </div>
                                    </td>
                                </tr>
                                <%
                                    }
                                } catch(SQLException e) {
                                %>
                                <tr>
                                    <td colspan="9" style="text-align: center; color: var(--danger); padding: 30px;">
                                        <i class="fas fa-exclamation-triangle fa-2x" style="margin-bottom: 15px;"></i>
                                        <h4>Error Loading Reservations</h4>
                                        <p><%= e.getMessage() %></p>
                                        <a href="javascript:window.location.reload()" class="btn btn-primary">
                                            <i class="fas fa-sync-alt"></i> Try Again
                                        </a>
                                    </td>
                                </tr>
                                <%
                                }
                                %>
                            </tbody>
                        </table>
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
            const searchInput = document.getElementById('searchInput');
            
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
            
            // Search functionality
            searchInput.addEventListener('input', function(e) {
                const searchTerm = e.target.value.toLowerCase().trim();
                const rows = document.querySelectorAll('.table tbody tr');
                let hasVisibleRows = false;
                
                rows.forEach(row => {
                    if(row.querySelector('.no-reservations')) return;
                    
                    const text = row.textContent.toLowerCase();
                    const isVisible = text.includes(searchTerm);
                    row.style.display = isVisible ? '' : 'none';
                    
                    if(isVisible) hasVisibleRows = true;
                });
                
                // Show no results message if no rows match search
                const noResultsMsg = document.querySelector('.no-reservations');
                if(noResultsMsg) {
                    noResultsMsg.style.display = hasVisibleRows ? 'none' : 'block';
                }
            });
            
            // Show/hide FAB based on screen size
            function updateFabVisibility() {
                if(window.innerWidth <= 576) {
                    mobileSidebarToggle.style.display = 'flex';
                } else {
                    mobileSidebarToggle.style.display = 'none';
                    sidebar.classList.remove('active');
                }
            }
            
            window.addEventListener('resize', updateFabVisibility);
            updateFabVisibility();
            
            // Add confirmation for cancel action
            document.querySelectorAll('.btn-danger').forEach(btn => {
                btn.addEventListener('click', function(e) {
                    if(!confirm('Are you sure you want to cancel this reservation?')) {
                        e.preventDefault();
                    }
                });
            });
            
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