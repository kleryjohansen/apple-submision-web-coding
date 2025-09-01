<%@ page import="java.sql.*" %>
<%@ page import="java.math.BigDecimal" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Edit Room</title>
    <style>
        * {
            box-sizing: border-box;
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
        }
        body {
            background-color: #f8f9fa;
            margin: 0;
            padding: 0;
            color: #333;
        }
        .container {
            max-width: 800px;
            margin: 40px auto;
            background: white;
            padding: 40px;
            border-radius: 12px;
            box-shadow: 0 4px 20px rgba(0, 0, 0, 0.08);
        }
        h1 {
            color: #2c3e50;
            margin-top: 0;
            margin-bottom: 25px;
            padding-bottom: 15px;
            border-bottom: 1px solid #eee;
            font-weight: 600;
            display: flex;
            align-items: center;
            justify-content: space-between;
        }
        .form-group {
            margin-bottom: 25px;
        }
        label {
            display: block;
            margin-bottom: 8px;
            font-weight: 600;
            color: #495057;
            font-size: 14px;
        }
        input[type="text"],
        input[type="number"],
        select {
            width: 100%;
            padding: 12px 15px;
            border: 1px solid #ced4da;
            border-radius: 6px;
            font-size: 15px;
            transition: all 0.3s;
            background-color: #f8f9fa;
        }
        input[type="text"]:focus,
        input[type="number"]:focus,
        select:focus {
            border-color: #4dabf7;
            outline: none;
            box-shadow: 0 0 0 3px rgba(77, 171, 247, 0.2);
            background-color: white;
        }
        .button-group {
            display: flex;
            gap: 15px;
            margin-top: 30px;
        }
        .btn {
            padding: 12px 25px;
            font-size: 15px;
            border-radius: 6px;
            cursor: pointer;
            transition: all 0.3s;
            font-weight: 500;
            border: none;
            display: inline-flex;
            align-items: center;
            justify-content: center;
        }
        .btn-primary {
            background-color: #4dabf7;
            color: white;
        }
        .btn-primary:hover {
            background-color: #339af0;
            transform: translateY(-1px);
        }
        .btn-secondary {
            background-color: #f1f3f5;
            color: #495057;
            text-decoration: none;
        }
        .btn-secondary:hover {
            background-color: #e9ecef;
            transform: translateY(-1px);
        }
        .error-message {
            color: #e03131;
            padding: 12px 15px;
            background-color: #fff5f5;
            border-radius: 6px;
            margin-bottom: 25px;
            border: 1px solid #ffc9c9;
            font-size: 14px;
        }
        .back-link {
            display: inline-flex;
            align-items: center;
            color: #4dabf7;
            text-decoration: none;
            font-weight: 500;
            margin-bottom: 5px;
        }
        .back-link svg {
            margin-right: 8px;
            width: 18px;
            height: 18px;
        }
    </style>
</head>
<body>
    <div class="container">
        <%
            int roomId = Integer.parseInt(request.getParameter("id"));
            String roomNumber = "", roomType = "", roomStatus = "";
            BigDecimal roomPrice = BigDecimal.ZERO;

            try {
                Class.forName("com.mysql.cj.jdbc.Driver");
                Connection conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/hotel_reservation", "root", "");
                PreparedStatement ps = conn.prepareStatement("SELECT * FROM rooms WHERE room_id = ?");
                ps.setInt(1, roomId);
                ResultSet rs = ps.executeQuery();

                if (rs.next()) {
                    roomNumber = rs.getString("room_number");
                    roomType = rs.getString("type");
                    roomPrice = rs.getBigDecimal("price");
                    roomStatus = rs.getString("status");
                }

                rs.close();
                ps.close();
                conn.close();
            } catch (Exception e) {
                out.println("<div class='error-message'>Error: " + e.getMessage() + "</div>");
            }
        %>

        <h1>
            <span>Edit Room</span>
        </h1>
        
        <a href="admin_rooms.jsp" class="back-link">
            <svg xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24" stroke="currentColor">
                <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M10 19l-7-7m0 0l7-7m-7 7h18" />
            </svg>
            Back to Rooms
        </a>
        
        <form method="post" action="update_room.jsp">
            <input type="hidden" name="room_id" value="<%= roomId %>" />
            
            <div class="form-group">
                <label for="room_number">Room Number:</label>
                <input type="text" id="room_number" name="room_number" value="<%= roomNumber %>" required />
            </div>
            
            <div class="form-group">
                <label for="room_type">Room Type:</label>
                <select id="room_type" name="room_type" required>
                    <option value="Single" <%= "Single".equals(roomType) ? "selected" : "" %>>Single</option>
                    <option value="Suite" <%= "Suite".equals(roomType) ? "selected" : "" %>>Suite</option>
                    <option value="Deluxe" <%= "Deluxe".equals(roomType) ? "selected" : "" %>>Deluxe</option>
                    <option value="Executive" <%= "Executive".equals(roomType) ? "selected" : "" %>>Executive</option>
                </select>
            </div>
            
            <div class="form-group">
                <label for="room_price">Room Price:</label>
                <input type="number" id="room_price" step="0.01" name="room_price" value="<%= roomPrice %>" required />
            </div>
            
            <div class="form-group">
                <label for="room_status">Room Status:</label>
                <select id="room_status" name="room_status">
                    <option value="available" <%= "available".equals(roomStatus) ? "selected" : "" %>>Available</option>
                    <option value="booked" <%= "booked".equals(roomStatus) ? "selected" : "" %>>Booked</option>
                    <option value="maintenance" <%= "maintenance".equals(roomStatus) ? "selected" : "" %>>Maintenance</option>
                </select>
            </div>
            
            <div class="button-group">
                <button type="submit" class="btn btn-primary">Save Changes</button>
                <a href="manage_rooms.jsp" class="btn btn-secondary">Cancel</a>
            </div>
        </form>
    </div>
</body>
</html>