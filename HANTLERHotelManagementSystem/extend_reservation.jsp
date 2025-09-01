<%@ page import="java.sql.*" %>
<%@ page import="java.text.SimpleDateFormat" %>
<%@ page import="java.util.Date" %>
<%@ include file="dbconnection.jsp" %>

<%
if (session.getAttribute("guest_id") == null) {
    response.sendRedirect("login.jsp");
    return;
}

int reservationId = Integer.parseInt(request.getParameter("id"));
String error = null;
String success = null;

// Get current reservation details
String reservationSql = "SELECT r.*, rm.type, rm.price, rm.room_id FROM reservations r " +
                       "JOIN rooms rm ON r.room_id = rm.room_id " +
                       "WHERE r.reservation_id = ? AND r.guest_id = ?";
PreparedStatement reservationStmt = conn.prepareStatement(reservationSql);
reservationStmt.setInt(1, reservationId);
reservationStmt.setInt(2, (Integer) session.getAttribute("guest_id"));
ResultSet reservationRs = reservationStmt.executeQuery();

if (!reservationRs.next()) {
    response.sendRedirect("my_reservations.jsp?error=Reservation not found");
    return;
}

Date currentCheckOut = reservationRs.getDate("check_out");
String roomType = reservationRs.getString("type");
double pricePerNight = reservationRs.getDouble("price");
int roomId = reservationRs.getInt("room_id");

// Handle form submission
if ("POST".equalsIgnoreCase(request.getMethod())) {
    try {
        String newCheckOutStr = request.getParameter("new_check_out");
        Date newCheckOut = new SimpleDateFormat("yyyy-MM-dd").parse(newCheckOutStr);
        
        // Validate new check-out date
        if (newCheckOut.before(currentCheckOut)) {
            error = "New check-out date must be after current check-out date (" + currentCheckOut + ")";
        } else {
            // Check room availability for the extension period
            String availabilitySql = "SELECT 1 FROM reservations " +
                                   "WHERE room_id = ? " +
                                   "AND ((check_in < ? AND check_out > ?) " +
                                   "OR (check_in >= ? AND check_in < ?)) " +
                                   "AND reservation_id != ? " +
                                   "AND payment_status != 'cancelled'";
            PreparedStatement availabilityStmt = conn.prepareStatement(availabilitySql);
            availabilityStmt.setInt(1, roomId);
            availabilityStmt.setDate(2, new java.sql.Date(currentCheckOut.getTime()));
            availabilityStmt.setDate(3, new java.sql.Date(newCheckOut.getTime()));
            availabilityStmt.setDate(4, new java.sql.Date(currentCheckOut.getTime()));
            availabilityStmt.setDate(5, new java.sql.Date(newCheckOut.getTime()));
            availabilityStmt.setInt(6, reservationId);
            
            if (availabilityStmt.executeQuery().next()) {
                error = "Room is not available for the selected extension period";
            } else {
                // Calculate additional nights and amount
                long diffInMillies = newCheckOut.getTime() - currentCheckOut.getTime();
                int additionalNights = (int) (diffInMillies / (1000 * 60 * 60 * 24));
                double additionalAmount = additionalNights * pricePerNight;
                
                // Update reservation
                String updateSql = "UPDATE reservations SET check_out = ?, total_amount = total_amount + ? " +
                                  "WHERE reservation_id = ?";
                PreparedStatement updateStmt = conn.prepareStatement(updateSql);
                updateStmt.setDate(1, new java.sql.Date(newCheckOut.getTime()));
                updateStmt.setDouble(2, additionalAmount);
                updateStmt.setInt(3, reservationId);
                updateStmt.executeUpdate();
                
                success = "Reservation successfully extended to " + newCheckOutStr + 
                          ". Additional amount: Rp " + String.format("%,.2f", additionalAmount);
            }
        }
    } catch (Exception e) {
        error = "Error processing extension: " + e.getMessage();
    }
}
%>

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Extend Reservation | Hotel Reservation</title>
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
            border: 2px solid var(--primary);
        }

        .container {
            max-width: 800px;
            margin: 30px auto;
            padding: 20px;
            background: white;
            border-radius: 10px;
            box-shadow: 0 5px 20px rgba(0,0,0,0.05);
        }

        .form-group {
            margin-bottom: 20px;
        }

        label {
            display: block;
            margin-bottom: 8px;
            font-weight: 500;
        }

        input[type="date"] {
            width: 100%;
            padding: 10px 15px;
            border: 1px solid #e0e0e0;
            border-radius: 6px;
            font-size: 1rem;
        }

        .btn {
            display: inline-flex;
            align-items: center;
            justify-content: center;
            padding: 10px 20px;
            border-radius: 6px;
            font-weight: 500;
            cursor: pointer;
            border: none;
            text-decoration: none;
            transition: all 0.3s;
        }

        .btn i {
            margin-right: 6px;
        }

        .btn-primary {
            background: var(--primary);
            color: white;
        }

        .btn-primary:hover {
            background: var(--primary-light);
            transform: translateY(-2px);
            box-shadow: 0 4px 8px rgba(67, 97, 238, 0.3);
        }

        .btn-outline {
            background: transparent;
            border: 1px solid var(--gray);
            color: var(--dark);
        }

        .btn-outline:hover {
            background: var(--gray-light);
        }

        .alert {
            padding: 15px;
            border-radius: 6px;
            margin-bottom: 20px;
            display: flex;
            align-items: center;
        }

        .alert i {
            margin-right: 10px;
        }

        .alert-danger {
            background: #f8d7da;
            color: #721c24;
        }

        .alert-success {
            background: #d4edda;
            color: #155724;
        }

        .reservation-details {
            background: #f8f9fa;
            padding: 20px;
            border-radius: 8px;
            margin-bottom: 30px;
        }

        .detail-row {
            display: flex;
            margin-bottom: 10px;
        }

        .detail-label {
            font-weight: 500;
            width: 150px;
        }

        h2 {
            font-size: 1.8rem;
            font-weight: 600;
            color: var(--dark);
            margin-bottom: 20px;
        }
    </style>
</head>
<body>
    <div class="top-nav">
        <a href="my_reservations.jsp" class="btn btn-outline">
            <i class="fas fa-arrow-left"></i> Back to Reservations
        </a>
        <div class="user-menu">
            <img src="https://ui-avatars.com/api/?name=<%= session.getAttribute("guest_name") %>&background=4361ee&color=fff" 
                 alt="<%= session.getAttribute("guest_name") %>">
        </div>
    </div>

    <div class="container">
        <h2>Extend Reservation #<%= reservationId %></h2>
        
        <% if (error != null) { %>
        <div class="alert alert-danger">
            <i class="fas fa-exclamation-circle"></i> <%= error %>
        </div>
        <% } %>
        
        <% if (success != null) { %>
        <div class="alert alert-success">
            <i class="fas fa-check-circle"></i> <%= success %>
            <p style="margin-top: 10px;">
                <a href="my_reservations.jsp" class="btn btn-primary">
                    <i class="fas fa-arrow-left"></i> Back to My Reservations
                </a>
            </p>
        </div>
        <% } else { %>
        
        <div class="reservation-details">
            <div class="detail-row">
                <div class="detail-label">Room Type:</div>
                <div><%= roomType %></div>
            </div>
            <div class="detail-row">
                <div class="detail-label">Current Check-out:</div>
                <div><%= currentCheckOut %></div>
            </div>
            <div class="detail-row">
                <div class="detail-label">Price per Night:</div>
                <div>Rp <%= String.format("%,.2f", pricePerNight) %></div>
            </div>
        </div>
        
        <form method="POST">
            <div class="form-group">
                <label for="new_check_out">New Check-out Date:</label>
                <input type="date" id="new_check_out" name="new_check_out" 
                       min="<%= new SimpleDateFormat("yyyy-MM-dd").format(new Date(currentCheckOut.getTime() + 24 * 60 * 60 * 1000)) %>" required>
            </div>
            
            <div class="form-group">
                <button type="submit" class="btn btn-primary">
                    <i class="fas fa-calendar-plus"></i> Request Extension
                </button>
                <a href="my_reservations.jsp" class="btn btn-outline" style="margin-left: 10px;">
                    <i class="fas fa-times"></i> Cancel
                </a>
            </div>
        </form>
        <% } %>
    </div>
    
    <script>
        document.addEventListener('DOMContentLoaded', function() {
            // Set minimum date to tomorrow (can't extend to current check-out date)
            const currentCheckOut = new Date('<%= currentCheckOut %>');
            currentCheckOut.setDate(currentCheckOut.getDate() + 1);
            
            const minDate = currentCheckOut.toISOString().split('T')[0];
            document.getElementById('new_check_out').min = minDate;
        });
    </script>
</body>
</html>