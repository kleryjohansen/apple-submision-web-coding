<%@ page import="java.sql.*" %>
<%@ page import="java.math.BigDecimal" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Update Room Status</title>
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@300;400;500;600&display=swap" rel="stylesheet">
    <style>
        * {
            box-sizing: border-box;
            margin: 0;
            padding: 0;
            font-family: 'Poppins', sans-serif;
        }
        
        body {
            background-color: #f8f9fa;
            display: flex;
            justify-content: center;
            align-items: center;
            min-height: 100vh;
            padding: 20px;
        }
        
        .container {
            background-color: white;
            border-radius: 12px;
            box-shadow: 0 8px 30px rgba(0, 0, 0, 0.1);
            padding: 40px;
            width: 100%;
            max-width: 500px;
            text-align: center;
            animation: fadeIn 0.5s ease-in-out;
        }
        
        h1 {
            color: #2c3e50;
            margin-bottom: 24px;
            font-weight: 600;
        }
        
        .status-card {
            padding: 20px;
            border-radius: 8px;
            margin-bottom: 30px;
        }
        
        .success {
            background-color: #e8f5e9;
            border-left: 4px solid #4caf50;
        }
        
        .error {
            background-color: #ffebee;
            border-left: 4px solid #f44336;
        }
        
        .status-icon {
            font-size: 48px;
            margin-bottom: 15px;
        }
        
        .success .status-icon {
            color: #4caf50;
        }
        
        .error .status-icon {
            color: #f44336;
        }
        
        .btn {
            display: inline-block;
            background-color: #3498db;
            color: white;
            text-decoration: none;
            padding: 12px 24px;
            border-radius: 6px;
            font-weight: 500;
            transition: all 0.3s ease;
            border: none;
            cursor: pointer;
            font-size: 16px;
            margin-top: 10px;
        }
        
        .btn:hover {
            background-color: #2980b9;
            transform: translateY(-2px);
            box-shadow: 0 4px 12px rgba(41, 128, 185, 0.2);
        }
        
        .room-details {
            text-align: left;
            margin: 25px 0;
            padding: 20px;
            background-color: #f8f9fa;
            border-radius: 8px;
        }
        
        .detail-row {
            display: flex;
            margin-bottom: 10px;
        }
        
        .detail-label {
            font-weight: 500;
            color: #555;
            width: 120px;
        }
        
        .detail-value {
            color: #2c3e50;
            font-weight: 400;
        }
        
        @keyframes fadeIn {
            from { opacity: 0; transform: translateY(20px); }
            to { opacity: 1; transform: translateY(0); }
        }
    </style>
</head>
<body>
    <div class="container">
        <%
            int roomId = Integer.parseInt(request.getParameter("room_id"));
            String roomNumber = request.getParameter("room_number");
            String roomType = request.getParameter("room_type");
            BigDecimal roomPrice = new BigDecimal(request.getParameter("room_price"));
            String roomStatus = request.getParameter("room_status");
            boolean success = false;
            Exception error = null;

            try {
                Class.forName("com.mysql.cj.jdbc.Driver");
                Connection conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/hotel_reservation", "root", "");
                PreparedStatement ps = conn.prepareStatement("UPDATE rooms SET room_number = ?, type = ?, price = ?, status = ? WHERE room_id = ?");
                ps.setString(1, roomNumber);
                ps.setString(2, roomType);
                ps.setBigDecimal(3, roomPrice);
                ps.setString(4, roomStatus);
                ps.setInt(5, roomId);

                int rowsUpdated = ps.executeUpdate();
                success = rowsUpdated > 0;

                ps.close();
                conn.close();
            } catch (Exception e) {
                error = e;
                out.println("<div class='status-card error'><div class='status-icon'>❌</div><h2>Update Failed</h2><p>" + e.getMessage() + "</p></div>");
            }
        %>

        <% if (success) { %>
            <div class="status-card success">
                <div class="status-icon">✓</div>
                <h2>Room Updated Successfully!</h2>
                <p>The room details have been updated in the system.</p>
            </div>
            
            <div class="room-details">
                <h3>Updated Room Details</h3>
                <div class="detail-row">
                    <span class="detail-label">Room ID:</span>
                    <span class="detail-value"><%= roomId %></span>
                </div>
                <div class="detail-row">
                    <span class="detail-label">Room Number:</span>
                    <span class="detail-value"><%= roomNumber %></span>
                </div>
                <div class="detail-row">
                    <span class="detail-label">Room Type:</span>
                    <span class="detail-value"><%= roomType %></span>
                </div>
                <div class="detail-row">
                    <span class="detail-label">Price:</span>
                    <span class="detail-value">$<%= String.format("%.2f", roomPrice) %></span>
                </div>
                <div class="detail-row">
                    <span class="detail-label">Status:</span>
                    <span class="detail-value" style="text-transform: capitalize;"><%= roomStatus %></span>
                </div>
            </div>
        <% } else if (!success && error == null) { %>
            <div class="status-card error">
                <div class="status-icon">❌</div>
                <h2>Update Failed</h2>
                <p>The room could not be found or updated.</p>
            </div>
        <% } %>

        <a href="admin_rooms.jsp" class="btn">Back to Room List</a>
    </div>
</body>
</html>