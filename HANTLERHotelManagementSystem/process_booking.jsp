<%@ page import="java.sql.*, java.time.LocalDate, java.io.PrintWriter" %>
<%@ include file="dbconnection.jsp" %>

<% 
// Check if user is logged in
if (session.getAttribute("guest_id") == null) {
    response.sendRedirect("login.jsp");
    return;
}

// Only process POST requests
if ("POST".equals(request.getMethod())) {
    // Get form parameters
    int guestId = 0;
    int roomId = 0;
    String checkIn = "";
    String checkOut = "";
    int numGuests = 2; // Default to 2 guests
    
    try {
        guestId = (Integer) session.getAttribute("guest_id");
        roomId = Integer.parseInt(request.getParameter("room_id"));
        checkIn = request.getParameter("check_in");
        checkOut = request.getParameter("check_out");
        
        // Get number of guests with null check
        if (request.getParameter("num_guests") != null) {
            numGuests = Integer.parseInt(request.getParameter("num_guests"));
        }
        
        // Validate dates
        if (checkIn == null || checkOut == null || checkIn.isEmpty() || checkOut.isEmpty()) {
            session.setAttribute("booking_error", "Please select both check-in and check-out dates");
            response.sendRedirect("book_room.jsp");
            return;
        }
        
        // Ensure check-out is after check-in
        if (LocalDate.parse(checkOut).isBefore(LocalDate.parse(checkIn))) {
            session.setAttribute("booking_error", "Check-out date must be after check-in date");
            response.sendRedirect("book_room.jsp");
            return;
        }

        // Begin transaction
        conn.setAutoCommit(false);

        // Check room availability
        String checkAvailable = "SELECT 1 FROM rooms WHERE room_id = ? AND status = 'available' AND " +
                              "NOT EXISTS (SELECT 1 FROM reservations WHERE room_id = ? AND " +
                              "((check_in <= ? AND check_out >= ?)))";
        PreparedStatement psCheck = conn.prepareStatement(checkAvailable);
        psCheck.setInt(1, roomId);
        psCheck.setInt(2, roomId);
        psCheck.setString(3, checkOut);
        psCheck.setString(4, checkIn);

        ResultSet rsCheck = psCheck.executeQuery();
        if (!rsCheck.next()) {
            session.setAttribute("booking_error", "Room is no longer available for the selected dates");
            response.sendRedirect("book_room.jsp");
            return;
        }

        // Get room price
        String priceQuery = "SELECT price FROM rooms WHERE room_id = ?";
        PreparedStatement psPrice = conn.prepareStatement(priceQuery);
        psPrice.setInt(1, roomId);
        ResultSet rsPrice = psPrice.executeQuery();
        
        if (!rsPrice.next()) {
            session.setAttribute("booking_error", "Could not retrieve room information");
            response.sendRedirect("book_room.jsp");
            return;
        }
        
        double price = rsPrice.getDouble("price");
        
        // Calculate total amount (including 12% tax)
        long nights = java.time.temporal.ChronoUnit.DAYS.between(
            LocalDate.parse(checkIn), LocalDate.parse(checkOut));
        double totalAmount = price * nights * 1.12;

        // Create reservation
        String insertReservation = "INSERT INTO reservations (guest_id, room_id, check_in, check_out, " +
                                 "total_amount, payment_status, num_guests) VALUES (?, ?, ?, ?, ?, ?, ?)";
        PreparedStatement psInsert = conn.prepareStatement(insertReservation, Statement.RETURN_GENERATED_KEYS);
        psInsert.setInt(1, guestId);
        psInsert.setInt(2, roomId);
        psInsert.setString(3, checkIn);
        psInsert.setString(4, checkOut);
        psInsert.setDouble(5, totalAmount);
        psInsert.setString(6, "pending");
        psInsert.setInt(7, numGuests);
        
        int affectedRows = psInsert.executeUpdate();
        
        if (affectedRows == 0) {
            conn.rollback();
            session.setAttribute("booking_error", "Failed to create reservation");
            response.sendRedirect("book_room.jsp");
            return;
        }

        // Update room status
        String updateRoom = "UPDATE rooms SET status = 'occupied' WHERE room_id = ?";
        PreparedStatement psUpdate = conn.prepareStatement(updateRoom);
        psUpdate.setInt(1, roomId);
        psUpdate.executeUpdate();

        // Commit transaction
        conn.commit();

        // Get the reservation ID
        ResultSet rsKeys = psInsert.getGeneratedKeys();
        int reservationId = rsKeys.next() ? rsKeys.getInt(1) : 0;
        
        // Set success message and redirect to payment
        session.setAttribute("booking_success", "Reservation successful! Your reservation ID: " + reservationId);
        response.sendRedirect("payment.jsp?reservation_id=" + reservationId);
        return;
        
    } catch (NumberFormatException e) {
        try { conn.rollback(); } catch (SQLException ex) {}
        session.setAttribute("booking_error", "Invalid room or guest information");
        response.sendRedirect("book_room.jsp");
        return;
    } catch (SQLException e) {
        try { conn.rollback(); } catch (SQLException ex) {}
        session.setAttribute("booking_error", "Database error: " + e.getMessage());
        response.sendRedirect("book_room.jsp");
        return;
    } catch (Exception e) {
        try { conn.rollback(); } catch (SQLException ex) {}
        session.setAttribute("booking_error", "Error processing booking: " + e.getMessage());
        response.sendRedirect("book_room.jsp");
        return;
    } finally {
        try {
            conn.setAutoCommit(true);
        } catch (SQLException e) {
            // Use application log instead of System.err
            application.log("Error resetting autocommit: " + e.getMessage());
        }
    }
}

// If not a POST request or any other case, redirect back
response.sendRedirect("book_room.jsp");
%>