<%@ include file="dbconnection.jsp" %>
<%@ page import="java.sql.*, java.time.LocalDate" %>

<% if (session.getAttribute("guest_id") == null) {
    response.sendRedirect("login.jsp");
    return;
} %>

<% 
    // Booking processing logic
    if(request.getMethod().equals("POST") && request.getParameter("room_id") != null) {
        conn.setAutoCommit(false);
        try {
            int guestId = (int) session.getAttribute("guest_id");
            int roomId = Integer.parseInt(request.getParameter("room_id"));
            String checkIn = request.getParameter("check_in");
            String checkOut = request.getParameter("check_out");
            
            // Validate required parameters
            if (checkIn == null || checkOut == null) {
                session.setAttribute("booking_error", "Please select check-in and check-out dates");
                response.sendRedirect("book_room.jsp");
                return;
            }

            // Validate dates
            if (LocalDate.parse(checkOut).isBefore(LocalDate.parse(checkIn)) || 
                LocalDate.parse(checkIn).isBefore(LocalDate.now())) {
                session.setAttribute("booking_error", "Invalid date selection");
                response.sendRedirect("book_room.jsp");
                return;
            }

            // Check room availability
            String checkAvailable = "SELECT 1 FROM rooms WHERE room_id = ? AND status = 'available' AND NOT EXISTS (" +
                "SELECT 1 FROM reservations WHERE room_id = ? AND ((check_in <= ? AND check_out >= ?)))";
            PreparedStatement psCheck = conn.prepareStatement(checkAvailable);
            psCheck.setInt(1, roomId);
            psCheck.setInt(2, roomId);
            psCheck.setString(3, checkOut);
            psCheck.setString(4, checkIn);

            ResultSet rsCheck = psCheck.executeQuery();
            if (!rsCheck.next()) {
                session.setAttribute("booking_error", "Room is no longer available");
                response.sendRedirect("book_room.jsp");
                return;
            }

            // Get room price
            String priceQuery = "SELECT price FROM rooms WHERE room_id = ?";
            PreparedStatement psPrice = conn.prepareStatement(priceQuery);
            psPrice.setInt(1, roomId);
            ResultSet rsPrice = psPrice.executeQuery();
            rsPrice.next();
            double price = rsPrice.getDouble("price");
            
            // Calculate total amount
            long nights = java.time.temporal.ChronoUnit.DAYS.between(
                LocalDate.parse(checkIn), LocalDate.parse(checkOut));
            double totalAmount = price * nights * 1.12; // Including 12% tax

            // Create reservation
            PreparedStatement psInsert = conn.prepareStatement(
                "INSERT INTO reservations (guest_id, room_id, check_in, check_out, total_amount, payment_status) VALUES (?, ?, ?, ?, ?, ?)",
                Statement.RETURN_GENERATED_KEYS);
            psInsert.setInt(1, guestId);
            psInsert.setInt(2, roomId);
            psInsert.setString(3, checkIn);
            psInsert.setString(4, checkOut);
            psInsert.setDouble(5, totalAmount);
            psInsert.setString(6, "pending");
            psInsert.executeUpdate();

            // Update room status
            PreparedStatement psUpdate = conn.prepareStatement("UPDATE rooms SET status = 'occupied' WHERE room_id = ?");
            psUpdate.setInt(1, roomId);
            psUpdate.executeUpdate();

            conn.commit();
            
            // Get the reservation ID
            ResultSet rsKeys = psInsert.getGeneratedKeys();
            int reservationId = rsKeys.next() ? rsKeys.getInt(1) : 0;
            
            session.setAttribute("booking_success", "Reservation successful! Your ID: " + reservationId);
            response.sendRedirect("payment.jsp?reservation_id=" + reservationId);
            return;
            
        } catch (Exception e) {
            conn.rollback();
            session.setAttribute("booking_error", "Error processing booking: " + e.getMessage());
            response.sendRedirect("book_room.jsp");
            return;
        } finally {
            conn.setAutoCommit(true);
        }
    }
%>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Book a Room | LuxeStay Hotels</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.10.5/font/bootstrap-icons.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/animate.css/4.1.1/animate.min.css">
    <style>
        :root {
            --primary-color: #3a86ff;
            --secondary-color: #8338ec;
            --accent-color: #ff006e;
            --light-bg: #f8f9fa;
            --dark-bg: #212529;
        }
        
        body {
            background-color: var(--light-bg);
            font-family: 'Poppins', sans-serif;
            color: #333;
        }
        
        .navbar-brand {
            font-weight: 700;
            background: linear-gradient(45deg, var(--primary-color), var(--secondary-color));
            -webkit-background-clip: text;
            -webkit-text-fill-color: transparent;
            font-size: 1.8rem;
        }
        
        .hero-section {
            background: linear-gradient(135deg, rgba(58,134,255,0.1) 0%, rgba(131,56,236,0.1) 100%);
            border-radius: 20px;
            padding: 3rem;
            margin-bottom: 3rem;
            position: relative;
            overflow: hidden;
        }
        
        .hero-section::before {
            content: "";
            position: absolute;
            top: -50%;
            left: -50%;
            width: 200%;
            height: 200%;
            background: radial-gradient(circle, rgba(255,255,255,0.8) 0%, rgba(255,255,255,0) 70%);
            z-index: -1;
            animation: pulse 15s infinite alternate;
        }
        
        @keyframes pulse {
            0% { transform: rotate(0deg); }
            100% { transform: rotate(360deg); }
        }
        
        .room-card {
            border: none;
            border-radius: 16px;
            box-shadow: 0 10px 20px rgba(0,0,0,0.08);
            transition: all 0.4s cubic-bezier(0.175, 0.885, 0.32, 1.275);
            overflow: hidden;
            position: relative;
            background: white;
            margin-bottom: 1.5rem;
        }
        
        .room-card:hover {
            transform: translateY(-10px) scale(1.02);
            box-shadow: 0 15px 30px rgba(0,0,0,0.12);
        }
        
        .room-card.available {
            border-left: 5px solid #28a745;
        }
        
        .room-card.occupied {
            border-left: 5px solid #dc3545;
            opacity: 0.85;
        }
        
        .room-card .card-img-top {
            height: 200px;
            object-fit: cover;
            transition: transform 0.5s ease;
        }
        
        .room-card:hover .card-img-top {
            transform: scale(1.1);
        }
        
        .room-card .price-badge {
            position: absolute;
            top: 15px;
            right: 15px;
            background: rgba(0,0,0,0.7);
            color: white;
            padding: 5px 15px;
            border-radius: 20px;
            font-weight: 600;
        }
        
        .room-card .type-badge {
            position: absolute;
            top: 15px;
            left: 15px;
            background: var(--primary-color);
            color: white;
            padding: 5px 15px;
            border-radius: 20px;
            font-weight: 600;
        }
        
        .btn-gradient {
            background: linear-gradient(45deg, var(--primary-color), var(--secondary-color));
            color: white;
            border: none;
            padding: 10px 25px;
            border-radius: 30px;
            font-weight: 600;
            transition: all 0.3s ease;
            box-shadow: 0 4px 15px rgba(58,134,255,0.3);
        }
        
        .btn-gradient:hover {
            transform: translateY(-3px);
            box-shadow: 0 8px 25px rgba(58,134,255,0.4);
            color: white;
        }
        
        .date-input {
            border-radius: 10px;
            padding: 12px 15px;
            border: 2px solid #e9ecef;
            transition: all 0.3s ease;
        }
        
        .date-input:focus {
            border-color: var(--primary-color);
            box-shadow: 0 0 0 0.25rem rgba(58,134,255,0.25);
        }
        
        .section-title {
            position: relative;
            display: inline-block;
            margin-bottom: 2rem;
        }
        
        .section-title::after {
            content: "";
            position: absolute;
            bottom: -10px;
            left: 0;
            width: 50px;
            height: 4px;
            background: linear-gradient(45deg, var(--primary-color), var(--secondary-color));
            border-radius: 2px;
        }
        
        .status-indicator {
            width: 12px;
            height: 12px;
            border-radius: 50%;
            display: inline-block;
            margin-right: 5px;
        }
        
        .status-available {
            background-color: #28a745;
        }
        
        .status-occupied {
            background-color: #dc3545;
        }
        
        .room-features {
            list-style: none;
            padding: 0;
            margin: 0;
        }
        
        .room-features li {
            display: inline-block;
            margin-right: 10px;
            margin-bottom: 5px;
            font-size: 0.85rem;
            color: #6c757d;
        }
        
        .room-features li i {
            color: var(--primary-color);
            margin-right: 3px;
        }
        
        .floating-alert {
            position: fixed;
            top: 20px;
            right: 20px;
            z-index: 1000;
            animation: slideInRight 0.5s forwards, fadeOut 0.5s 4.5s forwards;
        }
        
        @keyframes slideInRight {
            from { transform: translateX(100%); opacity: 0; }
            to { transform: translateX(0); opacity: 1; }
        }
        
        @keyframes fadeOut {
            from { opacity: 1; }
            to { opacity: 0; }
        }
        
        .room-gallery {
            display: grid;
            grid-template-columns: repeat(3, 1fr);
            gap: 10px;
            margin-top: 15px;
        }
        
        .room-gallery img {
            width: 100%;
            height: 80px;
            object-fit: cover;
            border-radius: 8px;
            cursor: pointer;
            transition: all 0.3s ease;
        }
        
        .room-gallery img:hover {
            transform: scale(1.05);
        }
        
        .action-buttons {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-top: 15px;
        }
        
        .btn-view {
            background: transparent;
            border: 1px solid var(--primary-color);
            color: var(--primary-color);
            transition: all 0.3s ease;
        }
        
        .btn-view:hover {
            background: var(--primary-color);
            color: white;
        }
    </style>
</head>
<body>

<nav class="navbar navbar-expand-lg navbar-light bg-white shadow-sm py-3">
    <div class="container">
        <a class="navbar-brand" href="index.jsp">LuxeStay</a>
        <button class="navbar-toggler" type="button" data-bs-toggle="collapse" data-bs-target="#navbarNav">
            <span class="navbar-toggler-icon"></span>
        </button>
        <div class="collapse navbar-collapse" id="navbarNav">
            <ul class="navbar-nav ms-auto">
                
                <% if(session.getAttribute("guest_id") != null) { %>
                    <li class="nav-item"><a class="nav-link" href="dashboard.jsp">Dashboard</a></li>
                    <li class="nav-item"><a class="nav-link active fw-bold" href="book_room.jsp">Book Room</a></li>
                    <li class="nav-item"><a class="nav-link" href="payment.jsp">Payments</a></li>
                <% } %>
                <li class="nav-item"><a class="nav-link btn btn-outline-primary ms-2" href="logout.jsp">Logout</a></li>
            </ul>
        </div>
    </div>
</nav>

<div class="container py-4">
    <% if (session.getAttribute("booking_error") != null) { %>
        <div id="bookingAlert" class="floating-alert alert alert-danger alert-dismissible fade show">
            <i class="bi bi-exclamation-triangle-fill me-2"></i> <%= session.getAttribute("booking_error") %>
            <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
        </div>
        <% session.removeAttribute("booking_error"); %>
    <% } %>
    
    <% if (session.getAttribute("booking_success") != null) { %>
        <div id="bookingAlert" class="floating-alert alert alert-success alert-dismissible fade show">
            <i class="bi bi-check-circle-fill me-2"></i> <%= session.getAttribute("booking_success") %>
            <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
        </div>
        <% session.removeAttribute("booking_success"); %>
    <% } %>

    <div class="hero-section animate__animated animate__fadeIn">
        <div class="row align-items-center">
            <div class="col-lg-6">
                <h1 class="display-5 fw-bold mb-3">Find Your Perfect Stay</h1>
                <p class="lead mb-4">Discover our luxurious rooms and suites designed for your ultimate comfort and relaxation.</p>
                <div class="d-flex align-items-center">
                    <i class="bi bi-star-fill text-warning me-2"></i>
                    <span class="me-3">4.9/5 (1,200+ reviews)</span>
                    <i class="bi bi-geo-alt-fill text-primary me-2"></i>
                    <span>Prime Downtown Location</span>
                </div>
            </div>
            <div class="col-lg-6 d-none d-lg-block">
                <img src="https://images.unsplash.com/photo-1566073771259-6a8506099945?ixlib=rb-1.2.1&auto=format&fit=crop&w=500&q=60" 
                     alt="Luxury Hotel" class="img-fluid rounded-3 shadow">
            </div>
        </div>
    </div>

    <div class="card p-4 shadow-sm border-0 animate__animated animate__fadeInUp">
        <h2 class="section-title">Book Your Stay</h2>
        <form method="post" class="row g-3 needs-validation" novalidate>
            <div class="col-md-3">
                <label class="form-label fw-bold">Check-in Date</label>
                <input type="date" class="form-control date-input" name="check_in" required min="<%= LocalDate.now() %>">
                <div class="invalid-feedback">
                    Please select a valid check-in date.
                </div>
            </div>
            <div class="col-md-3">
                <label class="form-label fw-bold">Check-out Date</label>
                <input type="date" class="form-control date-input" name="check_out" required min="<%= LocalDate.now().plusDays(1) %>">
                <div class="invalid-feedback">
                    Please select a valid check-out date.
                </div>
            </div>
            <div class="col-md-3">
                <label class="form-label fw-bold">Guests</label>
                <select class="form-select date-input" name="guests">
                    <option value="1">1 Guest</option>
                    <option value="2" selected>2 Guests</option>
                    <option value="3">3 Guests</option>
                    <option value="4">4 Guests</option>
                </select>
            </div>
            <div class="col-md-3 d-flex align-items-end">
                <button type="submit" class="btn btn-gradient w-100">
                    <i class="bi bi-search me-2"></i>Check Availability
                </button>
            </div>

            <div class="col-12 mt-4">
                <h4 class="section-title">Available Rooms</h4>
                <div class="row g-4">
                    <%
                        String checkDate = request.getParameter("check_in");
                        String endDate = request.getParameter("check_out");

                        try {
                            String roomQuery = "SELECT r.* FROM rooms r " +
                                "WHERE r.room_id NOT IN (" +
                                "SELECT res.room_id FROM reservations res " +
                                "WHERE (res.check_in <= ? AND res.check_out >= ?)) AND r.status = 'available'";

                            PreparedStatement psRooms = conn.prepareStatement(roomQuery);

                            if (checkDate != null && endDate != null) {
                                psRooms.setString(1, endDate);
                                psRooms.setString(2, checkDate);
                            } else {
                                psRooms.setString(1, LocalDate.now().toString());
                                psRooms.setString(2, LocalDate.now().toString());
                            }

                            ResultSet rsRooms = psRooms.executeQuery();

                            while (rsRooms.next()) {
                                int roomId = rsRooms.getInt("room_id");
                                String roomNumber = rsRooms.getString("room_number");
                                String type = rsRooms.getString("type");
                                double price = rsRooms.getDouble("price");
                                String status = rsRooms.getString("status");
                                String description = rsRooms.getString("description");
                                
                                // Generate a different image based on room type for demo purposes
                                String imgUrl = "https://images.unsplash.com/photo-";
                                if (type.toLowerCase().contains("deluxe")) {
                                    imgUrl += "1578683010236-d716f9a3f461";
                                } else if (type.toLowerCase().contains("suite")) {
                                    imgUrl += "1566669437685-1f8b728b1d1a";
                                } else {
                                    imgUrl += "1598928506311-c55ded91a20c";
                                }
                                imgUrl += "?ixlib=rb-1.2.1&auto=format&fit=crop&w=500&q=60";
                                
                                // Generate sample amenities based on room type
                                String amenities = "";
                                if (type.toLowerCase().contains("deluxe")) {
                                    amenities = "King Bed, Air Conditioning, TV, Mini Bar, Free WiFi";
                                } else if (type.toLowerCase().contains("suite")) {
                                    amenities = "King Bed, Living Area, Kitchenette, Air Conditioning, TV, Free WiFi";
                                } else {
                                    amenities = "Queen Bed, Air Conditioning, TV, Free WiFi";
                                }
                    %>
                    <div class="col-md-6 col-lg-4">
                        <div class="card room-card <%= status.equals("available") ? "available" : "occupied" %>">
                            <img src="<%= imgUrl %>" class="card-img-top" alt="<%= type %> Room">
                            <span class="price-badge">$<%= price %>/night</span>
                            <span class="type-badge"><%= type %></span>
                            <div class="card-body">
                                <h5 class="card-title">Room <%= roomNumber %></h5>
                                <p class="card-text text-muted"><%= description != null ? description : "Comfortable " + type + " room with modern amenities" %></p>
                                
                                <ul class="room-features">
                                    <% if (!amenities.isEmpty()) { 
                                        String[] amenityList = amenities.split(",");
                                        for (String amenity : amenityList) {
                                    %>
                                    <li><i class="bi bi-check-circle"></i><%= amenity.trim() %></li>
                                    <% } } %>
                                </ul>
                                
                                <div class="room-gallery">
                                    <img src="<%= imgUrl %>" alt="Room View 1">
                                    <img src="https://images.unsplash.com/photo-1522771739844-6a9f6d5f14af?ixlib=rb-1.2.1&auto=format&fit=crop&w=500&q=60" alt="Room View 2">
                                    <img src="https://images.unsplash.com/photo-1554995207-c18c203602cb?ixlib=rb-1.2.1&auto=format&fit=crop&w=500&q=60" alt="Bathroom">
                                </div>
                                
                                <div class="action-buttons">
                                    <div>
                                        <span class="status-indicator status-<%= status.equals("available") ? "available" : "occupied" %>"></span>
                                        <span><%= status.equals("available") ? "Available" : "Occupied" %></span>
                                    </div>
                                    <div>
                                        <a href="room_details.jsp?room_id=<%= roomId %>" class="btn btn-sm btn-view me-2">
                                            <i class="bi bi-eye-fill"></i> View Details
                                        </a>
                                        <% if (status.equals("available")) { %>
                                        <form method="post" action="book_room.jsp" class="d-inline">
                                            <input type="hidden" name="room_id" value="<%= roomId %>">
                                            <% if (checkDate != null && endDate != null) { %>
                                                <input type="hidden" name="check_in" value="<%= checkDate %>">
                                                <input type="hidden" name="check_out" value="<%= endDate %>">
                                                <input type="hidden" name="guests" value="<%= request.getParameter("guests") != null ? request.getParameter("guests") : "2" %>">
                                            <% } else { %>
                                                <input type="hidden" name="check_in" value="<%= LocalDate.now().toString() %>">
                                                <input type="hidden" name="check_out" value="<%= LocalDate.now().plusDays(1).toString() %>">
                                                <input type="hidden" name="guests" value="2">
                                            <% } %>
                                            <button type="submit" class="btn btn-sm btn-primary">
                                                <i class="bi bi-bookmark-check-fill"></i> Book Now
                                            </button>
                                        </form>
                                        <% } %>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                    <% }
                        } catch (SQLException e) {
                            out.println("<div class='alert alert-danger'>Error loading rooms: " + e.getMessage() + "</div>");
                        }
                    %>
                </div>
            </div>
        </form>
    </div>

    <div class="card p-4 shadow-sm border-0 mt-5 animate__animated animate__fadeIn">
        <h4 class="section-title">Currently Booked Rooms</h4>
        <p class="text-muted mb-4">Take a look at our recently booked rooms</p>
        <div class="row g-4">
        <%
            try {
                String bookedRoomsQuery = "SELECT r.room_number, r.type, r.price, res.check_in, res.check_out, g.name AS guest_name, " +
                                        "DATEDIFF(res.check_out, res.check_in) AS nights " +
                                        "FROM reservations res " +
                                        "JOIN rooms r ON res.room_id = r.room_id " +
                                        "JOIN guests g ON res.guest_id = g.guest_id " +
                                        "WHERE res.check_out >= CURDATE() " +
                                        "ORDER BY res.check_in DESC LIMIT 6";

                PreparedStatement psBooked = conn.prepareStatement(bookedRoomsQuery);
                ResultSet rsBooked = psBooked.executeQuery();

                while (rsBooked.next()) {
                    String roomNum = rsBooked.getString("room_number");
                    String roomType = rsBooked.getString("type");
                    double price = rsBooked.getDouble("price");
                    String checkInDate = rsBooked.getString("check_in");
                    String checkOutDate = rsBooked.getString("check_out");
                    String guestName = rsBooked.getString("guest_name");
                    int nights = rsBooked.getInt("nights");
                    
                    // Generate different images for variety
                    String imgUrl = "https://images.unsplash.com/photo-";
                    if (roomType.toLowerCase().contains("deluxe")) {
                        imgUrl += "1578683010236-d716f9a3f461";
                    } else if (roomType.toLowerCase().contains("suite")) {
                        imgUrl += "1566669437685-1f8b728b1d1a";
                    } else {
                        imgUrl += "1598928506311-c55ded91a20c";
                    }
                    imgUrl += "?ixlib=rb-1.2.1&auto=format&fit=crop&w=500&q=60";
        %>
            <div class="col-md-6 col-lg-4">
                <div class="card room-card occupied">
                    <img src="<%= imgUrl %>" class="card-img-top" alt="<%= roomType %> Room">
                    <div class="card-body">
                        <h5 class="card-title">Room <%= roomNum %></h5>
                        <p class="card-text text-muted">Booked by <%= guestName %></p>
                        
                        <div class="d-flex justify-content-between mb-3">
                            <div>
                                <small class="text-muted">Check-in</small>
                                <p class="mb-0 fw-bold"><%= checkInDate %></p>
                            </div>
                            <div class="text-center">
                                <small class="text-muted">Nights</small>
                                <p class="mb-0 fw-bold"><%= nights %></p>
                            </div>
                            <div>
                                <small class="text-muted">Check-out</small>
                                <p class="mb-0 fw-bold"><%= checkOutDate %></p>
                            </div>
                        </div>
                        
                        <div class="d-flex justify-content-between align-items-center">
                            <span class="badge bg-primary"><%= roomType %></span>
                            <span class="fw-bold">$<%= price * nights %> total</span>
                        </div>
                    </div>
                </div>
            </div>
        <%
                }
            } catch (SQLException e) {
                out.println("<div class='alert alert-danger'>Error loading booked rooms: " + e.getMessage() + "</div>");
            }
        %>
        </div>
    </div>
</div>

<footer class="bg-dark text-white py-5 mt-5">
    <div class="container">
        <div class="row">
            <div class="col-lg-4 mb-4">
                <h5 class="fw-bold mb-4">LuxeStay Hotels</h5>
                <p>Experience unparalleled luxury and comfort at our premium locations worldwide.</p>
                <div class="social-icons mt-3">
                    <a href="#" class="text-white me-3"><i class="bi bi-facebook"></i></a>
                    <a href="#" class="text-white me-3"><i class="bi bi-twitter"></i></a>
                    <a href="#" class="text-white me-3"><i class="bi bi-instagram"></i></a>
                </div>
            </div>
            <div class="col-lg-2 col-md-6 mb-4">
                <h6 class="text-uppercase fw-bold mb-4">Company</h6>
                <ul class="list-unstyled">
                    <li class="mb-2"><a href="#" class="text-white-50">About Us</a></li>
                    <li class="mb-2"><a href="#" class="text-white-50">Careers</a></li>
                    <li class="mb-2"><a href="#" class="text-white-50">Press</a></li>
                </ul>
            </div>
            <div class="col-lg-2 col-md-6 mb-4">
                <h6 class="text-uppercase fw-bold mb-4">Support</h6>
                <ul class="list-unstyled">
                    <li class="mb-2"><a href="#" class="text-white-50">Contact</a></li>
                    <li class="mb-2"><a href="#" class="text-white-50">FAQs</a></li>
                    <li class="mb-2"><a href="#" class="text-white-50">Privacy Policy</a></li>
                </ul>
            </div>
            <div class="col-lg-4 mb-4">
                <h6 class="text-uppercase fw-bold mb-4">Newsletter</h6>
                <p>Subscribe to receive updates and special offers.</p>
                <div class="input-group mb-3">
                    <input type="email" class="form-control" placeholder="Your email">
                    <button class="btn btn-primary" type="button">Subscribe</button>
                </div>
            </div>
        </div>
        <hr class="my-4 bg-secondary">
        <div class="text-center">
            <p class="mb-0">&copy; 2023 LuxeStay Hotels. All rights reserved.</p>
        </div>
    </div>
</footer>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
<script>
    // Form validation
    (function () {
        'use strict'
        
        var forms = document.querySelectorAll('.needs-validation')
        
        Array.prototype.slice.call(forms)
            .forEach(function (form) {
                form.addEventListener('submit', function (event) {
                    if (!form.checkValidity()) {
                        event.preventDefault()
                        event.stopPropagation()
                    }
                    
                    form.classList.add('was-validated')
                }, false)
            })
    })()
    
    // Animate elements when they come into view
    const animateOnScroll = function() {
        const elements = document.querySelectorAll('.animate__animated');
        
        elements.forEach(element => {
            const elementPosition = element.getBoundingClientRect().top;
            const windowHeight = window.innerHeight;
            
            if (elementPosition < windowHeight - 100) {
                element.style.opacity = '1';
            }
        });
    };
    
    // Set initial state
    document.querySelectorAll('.animate__animated').forEach(el => {
        el.style.opacity = '0';
    });
    
    // Add scroll event listener
    window.addEventListener('scroll', animateOnScroll);
    
    // Trigger once on page load
    animateOnScroll();
    
    // Auto-close floating alerts after 5 seconds
    setTimeout(function() {
        const alerts = document.querySelectorAll('.floating-alert');
        alerts.forEach(alert => {
            const bsAlert = new bootstrap.Alert(alert);
            bsAlert.close();
        });
    }, 5000);
</script>
</body>
</html>