<%-- <%@ include file="dbconnection.jsp" %>
<%@ page import="java.sql.*" %>

<%
if(session.getAttribute("guest_id") == null) {
    response.sendRedirect("login.jsp");
    return;
}

int reservationId = 0;
try {
    reservationId = Integer.parseInt(request.getParameter("reservation_id"));
} catch (NumberFormatException e) {
    response.sendRedirect("payment.jsp");
    return;
}
%>

<!DOCTYPE html>
<html>
<head>
    <title>Reservation Confirmation</title>
    <style>
        body {
            font-family: 'Inter', -apple-system, BlinkMacSystemFont, 'Segoe UI', Roboto, Oxygen, Ubuntu, Cantarell, sans-serif;
            background: linear-gradient(135deg, #f5f7fa 0%, #e4e8eb 100%);
            color: #2d3748;
            margin: 0;
            padding: 0;
        }
        .container {
            max-width: 800px;
            margin: 0 auto;
            padding: 20px;
        }
        .card {
            background: white;
            border-radius: 12px;
            box-shadow: 0 10px 30px rgba(0, 0, 0, 0.05);
            padding: 2.5rem;
            margin: 2rem auto;
        }
        h1, h2 {
            color: #2c3e50;
        }
        .confirmation-header {
            text-align: center;
            margin-bottom: 30px;
        }
        .confirmation-details {
            margin: 20px 0;
        }
        .detail-row {
            display: flex;
            margin-bottom: 15px;
            padding-bottom: 15px;
            border-bottom: 1px solid #e2e8f0;
        }
        .detail-label {
            font-weight: 600;
            width: 200px;
            color: #4a5568;
        }
        .detail-value {
            flex: 1;
        }
        .btn {
            background: #3498db;
            color: white;
            border: none;
            padding: 10px 20px;
            border-radius: 5px;
            text-decoration: none;
            display: inline-block;
            margin-top: 20px;
        }
        .btn:hover {
            background: #2980b9;
        }
    </style>
</head>
<body>
    <nav class="navbar">
        <a href="index.jsp" class="nav-brand">Hotel Reservation</a>
        <div class="nav-links">
          <a href="index.jsp" class="nav-link">Home</a>
          <% if(session.getAttribute("guest_id") != null) { %>
            <a href="dashboard.jsp" class="nav-link">Dashboard</a>
            <a href="book_room.jsp" class="nav-link">Book Room</a>
            <a href="payment.jsp" class="nav-link">Payments</a>
          <% } %>

          <% if(session.getAttribute("guest_id") == null && session.getAttribute("admin") == null) { %>
            <a href="login.jsp" class="nav-link">Login</a>
            <a href="register.jsp" class="nav-link">Register</a>
          <% } else { %>
            <a href="logout.jsp" class="nav-link">Logout</a>
          <% } %>
        </div>
      </nav>

    <div class="container">
        <div class="card">
            <div class="confirmation-header">
                <h1>Reservation Confirmed</h1>
                <p>Thank you for your booking! Here are your reservation details.</p>
            </div>

            <div class="confirmation-details">
                <%
                try {
                    String sql = "SELECT r.reservation_id, g.name AS guest_name, g.email, " +
                                 "rm.room_number, rm.type, rm.price, " +
                                 "r.check_in, r.check_out, " +
                                 "DATEDIFF(r.check_out, r.check_in) AS nights, " +
                                 "DATEDIFF(r.check_out, r.check_in) * rm.price AS total_amount, " +
                                 "p.payment_method, p.payment_date " +
                                 "FROM reservations r " +
                                 "JOIN guests g ON r.guest_id = g.guest_id " +
                                 "JOIN rooms rm ON r.room_id = rm.room_id " +
                                 "LEFT JOIN payments p ON r.reservation_id = p.reservation_id " +
                                 "WHERE r.reservation_id = ?";
                    
                    PreparedStatement ps = conn.prepareStatement(sql);
                    ps.setInt(1, reservationId);
                    ResultSet rs = ps.executeQuery();
                    
                    if (rs.next()) {
                %>
                        <div class="detail-row">
                            <div class="detail-label">Reservation ID:</div>
                            <div class="detail-value"><%= rs.getInt("reservation_id") %></div>
                        </div>
                        
                        <div class="detail-row">
                            <div class="detail-label">Guest Name:</div>
                            <div class="detail-value"><%= rs.getString("guest_name") %></div>
                        </div>
                        
                        <div class="detail-row">
                            <div class="detail-label">Room Details:</div>
                            <div class="detail-value">
                                Room <%= rs.getString("room_number") %> (<%= rs.getString("type") %>)
                                - Rp<%= rs.getBigDecimal("price") %> per night
                            </div>
                        </div>
                        
                        <div class="detail-row">
                            <div class="detail-label">Stay Duration:</div>
                            <div class="detail-value">
                                <%= rs.getDate("check_in") %> to <%= rs.getDate("check_out") %>
                                (<%= rs.getInt("nights") %> nights)
                            </div>
                        </div>
                        
                        <div class="detail-row">
                            <div class="detail-label">Total Amount:</div>
                            <div class="detail-value">Rp<%= rs.getBigDecimal("total_amount") %></div>
                        </div>
                        
                        <div class="detail-row">
                            <div class="detail-label">Payment Method:</div>
                            <div class="detail-value"><%= rs.getString("payment_method") %></div>
                        </div>
                        
                        <div class="detail-row">
                            <div class="detail-label">Payment Date:</div>
                            <div class="detail-value"><%= rs.getDate("payment_date") %></div>
                        </div>
                <%
                    } else {
                        out.println("<p>Reservation not found.</p>");
                    }
                } catch (SQLException e) {
                    out.println("<p>Error retrieving reservation details: " + e.getMessage() + "</p>");
                }
                %>
            </div>

            <a href="payment.jsp" class="btn">Back to payment</a>
            <a href="#" class="btn" onclick="window.print()">Print Confirmation</a>
        </div>
    </div>
</body>
</html> --%>