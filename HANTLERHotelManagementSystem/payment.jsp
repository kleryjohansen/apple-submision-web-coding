<%@ include file="dbconnection.jsp" %>
<%@ page import="java.sql.*" %>
<%@ page import="java.time.LocalDate" %>

<%
if(session.getAttribute("guest_id") == null) {
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
    <title>Payment | Hotel Reservation</title>
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

        /* Payment Details */
        .payment-details {
            background: #f8fafd;
            border-radius: 8px;
            padding: 20px;
            margin-bottom: 20px;
            border-left: 4px solid var(--primary);
        }

        .payment-details h4 {
            color: var(--primary);
            margin-bottom: 15px;
            display: flex;
            align-items: center;
        }

        .payment-details h4 i {
            margin-right: 10px;
        }

        .payment-details p {
            margin-bottom: 8px;
        }

        .payment-details strong {
            color: var(--dark);
            min-width: 150px;
            display: inline-block;
            font-weight: 500;
        }

        /* Payment Methods */
        .payment-methods {
            display: grid;
            grid-template-columns: repeat(auto-fill, minmax(150px, 1fr));
            gap: 15px;
            margin: 20px 0;
        }

        .payment-method {
            border: 1px solid #e0e0e0;
            border-radius: 8px;
            padding: 15px;
            text-align: center;
            cursor: pointer;
            transition: all 0.3s;
            background: white;
        }

        .payment-method:hover {
            border-color: var(--primary);
            box-shadow: 0 5px 15px rgba(0,0,0,0.05);
        }

        .payment-method.active {
            border: 2px solid var(--primary);
            background: rgba(67, 97, 238, 0.05);
        }

        .payment-method i {
            font-size: 2rem;
            margin-bottom: 10px;
            color: var(--primary);
        }

        .payment-method div {
            font-weight: 500;
            color: var(--dark);
        }

        /* QRIS Container */
        .qris-container {
            margin: 20px 0;
            text-align: center;
            display: none;
        }

        .qris-code {
            max-width: 250px;
            margin: 0 auto;
            padding: 15px;
            background: white;
            border-radius: 8px;
            box-shadow: 0 5px 15px rgba(0,0,0,0.05);
        }

        .qris-code img {
            width: 100%;
            height: auto;
            border-radius: 5px;
        }

        .payment-instructions {
            background: #f8fafd;
            border-radius: 8px;
            padding: 15px;
            margin-top: 15px;
            font-size: 0.9rem;
            border-left: 3px solid var(--primary);
        }

        .payment-instructions p {
            font-weight: 500;
            color: var(--primary);
            margin-bottom: 10px;
        }

        .payment-instructions ol {
            padding-left: 20px;
            margin-bottom: 0;
        }

        .payment-instructions li {
            margin-bottom: 5px;
        }

        /* Form Elements */
        .form-group {
            margin-bottom: 20px;
        }

        .form-label {
            font-weight: 500;
            color: var(--dark);
            margin-bottom: 8px;
            display: block;
        }

        .form-control {
            width: 100%;
            padding: 10px 15px;
            border: 1px solid #e0e0e0;
            border-radius: 5px;
            font-size: 0.9rem;
            transition: all 0.3s;
        }

        .form-control:focus {
            border-color: var(--primary);
            box-shadow: 0 0 0 3px rgba(67, 97, 238, 0.2);
            outline: none;
        }

        .amount-input {
            position: relative;
        }

        .amount-input span {
            position: absolute;
            left: 15px;
            top: 50%;
            transform: translateY(-50%);
            font-weight: 500;
            color: var(--primary);
        }

        .amount-input input {
            padding-left: 40px !important;
            font-weight: 500;
            color: var(--primary);
        }

        /* Buttons */
        .btn {
            display: inline-flex;
            align-items: center;
            justify-content: center;
            padding: 10px 20px;
            border-radius: 6px;
            font-size: 0.9rem;
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

        /* Success Message */
        .alert-success {
            background: rgba(76, 201, 240, 0.1);
            color: #0c5460;
            padding: 15px;
            border-radius: 5px;
            margin-bottom: 20px;
            border-left: 4px solid var(--success);
            display: flex;
            align-items: center;
        }

        .alert-success i {
            margin-right: 10px;
            color: var(--success);
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
            
            .payment-methods {
                grid-template-columns: repeat(2, 1fr);
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
            
            .payment-methods {
                grid-template-columns: 1fr;
            }
        }
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
                <li><a href="my_reservations.jsp"><i class="fas fa-bed"></i><span>My Reservations</span></a></li>
                <li><a href="payment.jsp" class="active"><i class="fas fa-credit-card"></i><span>Payments</span></a></li>
                <li><a href="profile.jsp"><i class="fas fa-user"></i><span>My Profile</span></a></li>
                <li><a href="logout.jsp"><i class="fas fa-sign-out-alt"></i><span>Logout</span></a></li>
            </ul>
        </div>
    </div>

    <div class="main-content" id="mainContent">
        <div class="top-nav">
            <div class="search-box">
               
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
                <h2><i class="fas fa-credit-card"></i> Make Payment</h2>
                <ul class="breadcrumb">
                    <li><a href="dashboard.jsp">Dashboard</a></li>
                    <li>Payments</li>
                </ul>
            </div>

            <div class="card">
                <div class="card-header">
                    <h3>Payment Information</h3>
                </div>
                <div class="card-body">
                    <% if(request.getParameter("success") != null) { %>
                        <div class="alert-success">
                            <i class="fas fa-check-circle"></i>
                            Payment processed successfully! Your reservation is now confirmed.
                        </div>
                    <% } %>

                    <form method="post" id="paymentForm">
                        <div class="form-group">
                            <label class="form-label">Choose Reservation:</label>
                            <select name="reservation_id" id="reservationSelect" class="form-control" required onchange="updatePaymentDetails()">
                                <option value="">-- Select Reservation --</option>
                                <%
                                int guestId = (Integer) session.getAttribute("guest_id");
                                try {
                                    PreparedStatement resQuery = conn.prepareStatement(
                                        "SELECT r.reservation_id, r.room_id, rm.room_number, rm.type, rm.price, " +
                                        "r.check_in, r.check_out, " +
                                        "DATEDIFF(r.check_out, r.check_in) * rm.price AS total_amount " +
                                        "FROM reservations r " +
                                        "JOIN rooms rm ON r.room_id = rm.room_id " +
                                        "WHERE r.guest_id=? AND r.payment_status = 'pending'"
                                    );
                                    resQuery.setInt(1, guestId);
                                    ResultSet resRs = resQuery.executeQuery();

                                    boolean hasReservation = false;
                                    while(resRs.next()) {
                                        hasReservation = true;
                                        double totalAmount = resRs.getDouble("total_amount");
                                %>
                                        <option value="<%= resRs.getInt("reservation_id") %>" 
                                                data-room="<%= resRs.getInt("room_id") %>"
                                                data-roomnum="<%= resRs.getString("room_number") %>"
                                                data-type="<%= resRs.getString("type") %>"
                                                data-price="<%= resRs.getDouble("price") %>"
                                                data-checkin="<%= resRs.getDate("check_in") %>"
                                                data-checkout="<%= resRs.getDate("check_out") %>"
                                                data-total="<%= totalAmount %>">
                                            Reservation #<%= resRs.getInt("reservation_id") %> - 
                                            Room <%= resRs.getString("room_number") %> (<%= resRs.getString("type") %>)
                                        </option>
                                <%
                                    }
                                    if (!hasReservation) {
                                %>
                                        <option disabled selected>No unpaid reservations</option>
                                <%
                                    }
                                } catch (SQLException e) {
                                    out.println("<div class='alert alert-danger'>Error loading reservations: " + e.getMessage() + "</div>");
                                }
                                %>
                            </select>
                        </div>

                        <div id="paymentDetails" class="payment-details">
                            <h4><i class="fas fa-receipt"></i> Payment Details</h4>
                            <p><strong>Room:</strong> <span id="roomInfo">-</span></p>
                            <p><strong>Dates:</strong> <span id="stayDates">-</span></p>
                            <p><strong>Nightly Rate:</strong> Rp<span id="roomPrice">0</span></p>
                            <p><strong>Total Nights:</strong> <span id="totalNights">0</span></p>
                            <p><strong>Total Amount Due:</strong> Rp<span id="totalAmount">0</span></p>
                        </div>

                        <div class="form-group">
                            <label class="form-label">Payment Method:</label>
                            <input type="hidden" name="payment_method" id="selectedPaymentMethod" required>
                            
                            <div class="payment-methods">
                                <div class="payment-method" onclick="selectPaymentMethod('QRIS', this)">
                                    <i class="fas fa-qrcode"></i>
                                    <div>QRIS</div>
                                </div>
                                <div class="payment-method" onclick="selectPaymentMethod('Credit Card', this)">
                                    <i class="far fa-credit-card"></i>
                                    <div>Credit Card</div>
                                </div>
                                <div class="payment-method" onclick="selectPaymentMethod('Debit Card', this)">
                                    <i class="fas fa-credit-card"></i>
                                    <div>Debit Card</div>
                                </div>
                                <div class="payment-method" onclick="selectPaymentMethod('Bank Transfer', this)">
                                    <i class="fas fa-university"></i>
                                    <div>Bank Transfer</div>
                                </div>
                                <div class="payment-method" onclick="selectPaymentMethod('E-Wallet', this)">
                                    <i class="fas fa-wallet"></i>
                                    <div>E-Wallet</div>
                                </div>
                                <div class="payment-method" onclick="selectPaymentMethod('Cash', this)">
                                    <i class="fas fa-money-bill-wave"></i>
                                    <div>Cash</div>
                                </div>
                            </div>
                        </div>

                        <div id="qrisContainer" class="qris-container">
                            <h4><i class="fas fa-qrcode"></i> Scan QRIS Code</h4>
                            <div class="qris-code">
                                <img src="https://api.qrserver.com/v1/create-qr-code/?size=300x300&data=LuxuryStays-Payment-ReservationID:12345-Amount:1000000" alt="QRIS Code">
                            </div>
                            <div class="payment-instructions">
                                <p><strong>How to pay with QRIS:</strong></p>
                                <ol>
                                    <li>Open your mobile banking or e-wallet app</li>
                                    <li>Select QRIS payment option</li>
                                    <li>Scan the QR code above</li>
                                    <li>Confirm the payment amount</li>
                                    <li>Complete the transaction</li>
                                </ol>
                            </div>
                        </div>

                        <div class="form-group amount-input">
                            <label class="form-label">Payment Amount:</label>
                            <span>Rp</span>
                            <input type="number" step="1000" name="amount" id="paymentAmount" class="form-control" required readonly>
                        </div>

                        <button type="submit" class="btn btn-primary">
                            <i class="fas fa-check-circle"></i> Process Payment
                        </button>
                    </form>
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
            
            // Initialize payment details
            updatePaymentDetails();
            
            // Set first payment method as default if none selected
            if (!document.getElementById('selectedPaymentMethod').value) {
                const firstMethod = document.querySelector('.payment-method');
                if (firstMethod) {
                    firstMethod.click();
                }
            }
        });

        function updatePaymentDetails() {
            const select = document.getElementById('reservationSelect');
            const selectedOption = select.options[select.selectedIndex];
            
            if (selectedOption.value) {
                document.getElementById('roomInfo').textContent = 
                    'Room ' + selectedOption.getAttribute('data-roomnum') + 
                    ' (' + selectedOption.getAttribute('data-type') + ')';
                    
                document.getElementById('stayDates').textContent = 
                    selectedOption.getAttribute('data-checkin') + ' to ' + 
                    selectedOption.getAttribute('data-checkout');
                    
                const price = parseFloat(selectedOption.getAttribute('data-price'));
                const total = parseFloat(selectedOption.getAttribute('data-total'));
                const nights = Math.round(total / price);
                
                document.getElementById('roomPrice').textContent = price.toLocaleString('id-ID');
                document.getElementById('totalNights').textContent = nights;
                document.getElementById('totalAmount').textContent = total.toLocaleString('id-ID');
                document.getElementById('paymentAmount').value = total.toFixed(2);
                
                // Update QRIS code with current reservation and amount
                const qrImg = document.querySelector('.qris-code img');
                if (qrImg) {
                    qrImg.src = `https://api.qrserver.com/v1/create-qr-code/?size=300x300&data=LuxuryStays-Payment-ReservationID:${selectedOption.value}-Amount:${total}`;
                }
            }
        }
        
        function selectPaymentMethod(method, element) {
            // Remove active class from all payment methods
            document.querySelectorAll('.payment-method').forEach(el => {
                el.classList.remove('active');
            });
            
            // Add active class to selected method
            element.classList.add('active');
            
            // Set hidden input value
            document.getElementById('selectedPaymentMethod').value = method;
            
            // Show/hide QRIS container
            const qrisContainer = document.getElementById('qrisContainer');
            if (method === 'QRIS') {
                qrisContainer.style.display = 'block';
            } else {
                qrisContainer.style.display = 'none';
            }
        }
    </script>

    <%
    if (request.getMethod().equals("POST")) {
        conn.setAutoCommit(false); // Start transaction
        try {
            int reservationId = Integer.parseInt(request.getParameter("reservation_id"));
            double amount = Double.parseDouble(request.getParameter("amount"));
            String method = request.getParameter("payment_method");

            // 1. Record payment
            PreparedStatement ps = conn.prepareStatement(
                "INSERT INTO payments (reservation_id, amount, payment_method, payment_date) " +
                "VALUES (?, ?, ?, CURRENT_DATE())");
            ps.setInt(1, reservationId);
            ps.setDouble(2, amount);
            ps.setString(3, method);
            int result = ps.executeUpdate();

            if (result > 0) {
                // 2. Update reservation status
                PreparedStatement updateReservation = conn.prepareStatement(
                    "UPDATE reservations SET payment_status='completed' WHERE reservation_id=?");
                updateReservation.setInt(1, reservationId);
                updateReservation.executeUpdate();
                
                // 3. Update room status if check-out date is in future
                PreparedStatement updateRoom = conn.prepareStatement(
                    "UPDATE rooms r JOIN reservations res ON r.room_id = res.room_id " +
                    "SET r.status = CASE WHEN res.check_out > CURRENT_DATE() THEN 'available' ELSE r.status END " +
                    "WHERE res.reservation_id = ?");
                updateRoom.setInt(1, reservationId);
                updateRoom.executeUpdate();
                
                conn.commit();
                response.sendRedirect("payment.jsp?success=true");
                return;
            } else {
                conn.rollback();
                out.println("<div class='alert alert-danger'>Payment processing failed. Please try again.</div>");
            }
        } catch (SQLException e) {
            conn.rollback();
            out.println("<div class='alert alert-danger'>Database error: " + e.getMessage() + "</div>");
        } catch (NumberFormatException e) {
            conn.rollback();
            out.println("<div class='alert alert-danger'>Invalid amount format. Please enter a valid number.</div>");
        } catch (Exception e) {
            conn.rollback();
            out.println("<div class='alert alert-danger'>Error: " + e.getMessage() + "</div>");
        } finally {
            conn.setAutoCommit(true);
        }
    }
    %>
</body>
</html>