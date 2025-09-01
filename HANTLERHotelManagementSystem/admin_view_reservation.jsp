<%@ page import="java.sql.*" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <title>Reservation Detail</title>
    <style>
        body {
            font-family: Arial, sans-serif;
            background-color: #f4f7f9;
            margin: 0;
            padding: 0;
        }

        .container {
            width: 90%;
            margin: 30px auto;
        }

        h2 {
            text-align: center;
            margin-bottom: 30px;
            color: #333;
        }

        .card {
            background: #fff;
            border-radius: 10px;
            margin-bottom: 20px;
            box-shadow: 0 2px 8px rgba(0,0,0,0.1);
            padding: 20px;
        }

        .section-title {
            font-size: 18px;
            font-weight: bold;
            margin-bottom: 10px;
            color: #444;
        }

        .info-table {
            width: 100%;
            border-collapse: collapse;
        }

        .info-table td {
            padding: 8px 10px;
            border-bottom: 1px solid #eee;
        }

        .info-table tr:last-child td {
            border-bottom: none;
        }

        .info-table td.label {
            font-weight: bold;
            width: 200px;
            color: #555;
        }

        .back-button {
            display: block;
            margin: 20px auto;
            text-align: center;
        }

        .back-button a {
            background: #007bff;
            color: white;
            padding: 10px 20px;
            border-radius: 8px;
            text-decoration: none;
        }

        .back-button a:hover {
            background: #0056b3;
        }
    </style>
</head>
<body>
<div class="container">
<%
    String reservationIdParam = request.getParameter("reservation_id");

    if (reservationIdParam == null || reservationIdParam.isEmpty()) {
%>
    <h2>No reservation selected.</h2>
<%
    } else {
        Connection conn = null;
        PreparedStatement pstmt = null;
        ResultSet rs = null;

        try {
            int reservationId = Integer.parseInt(reservationIdParam);

            Class.forName("com.mysql.jdbc.Driver"); // pakai com.mysql.cj.jdbc.Driver jika MySQL 8
            conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/hotel_reservation", "root", "");

            String query = "SELECT r.reservation_id, r.check_in, r.check_out, r.payment_status, " +
                           "g.name AS guest_name, g.email, g.phone, " +
                           "rm.room_number, rm.type AS room_type, rm.price " +
                           "FROM reservations r " +
                           "JOIN guests g ON r.guest_id = g.guest_id " +
                           "JOIN rooms rm ON r.room_id = rm.room_id " +
                           "WHERE r.reservation_id = ?";

            pstmt = conn.prepareStatement(query);
            pstmt.setInt(1, reservationId);
            rs = pstmt.executeQuery();

            if (rs.next()) {
%>
    <h2>Reservation Details</h2>
    <div class="card">
        <div class="section-title">Guest Information</div>
        <table class="info-table">
            <tr><td class="label">Name</td><td><%= rs.getString("guest_name") %></td></tr>
            <tr><td class="label">Email</td><td><%= rs.getString("email") %></td></tr>
            <tr><td class="label">Phone</td><td><%= rs.getString("phone") %></td></tr>
        </table>

        <div class="section-title" style="margin-top: 20px;">Room Information</div>
        <table class="info-table">
            <tr><td class="label">Room Number</td><td><%= rs.getString("room_number") %></td></tr>
            <tr><td class="label">Room Type</td><td><%= rs.getString("room_type") %></td></tr>
            <tr><td class="label">Price</td><td>$<%= rs.getDouble("price") %></td></tr>
            <tr><td class="label">Check-In</td><td><%= rs.getDate("check_in") %></td></tr>
            <tr><td class="label">Check-Out</td><td><%= rs.getDate("check_out") %></td></tr>
            <tr><td class="label">Payment Status</td><td><%= rs.getString("payment_status") %></td></tr>
        </table>
    </div>
    <div class="back-button">
        <a href="admin_reservations.jsp">← Back to Reservation List</a>
    </div>
<%
            } else {
%>
    <h2>No reservation found for ID <%= reservationId %>.</h2>
<%
            }
        } catch (Exception e) {
            out.println("<p style='color:red;'>Error: " + e.getMessage() + "</p>");
        } finally {
            if(rs != null) try { rs.close(); } catch (SQLException ignore) {}
            if(pstmt != null) try { pstmt.close(); } catch (SQLException ignore) {}
            if(conn != null) try { conn.close(); } catch (SQLException ignore) {}
        }
    }
%>
</div>
</body>
</html>
