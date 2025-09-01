<%@ page import="java.sql.*" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Update Room</title>
</head>
<body>
    <div class="container mt-5">
        <%
            int roomId = Integer.parseInt(request.getParameter("room_id"));
            String roomNumber = request.getParameter("room_number");
            String roomType = request.getParameter("room_type");
            BigDecimal roomPrice = new BigDecimal(request.getParameter("room_price"));
            String roomStatus = request.getParameter("room_status");

            try {
                Class.forName("com.mysql.cj.jdbc.Driver");
                Connection conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/hotel_reservation", "root", "");
                String sql = "UPDATE rooms SET room_number = ?, type = ?, price = ?, status = ? WHERE room_id = ?";
                PreparedStatement stmt = conn.prepareStatement(sql);
                stmt.setString(1, roomNumber);
                stmt.setString(2, roomType);
                stmt.setBigDecimal(3, roomPrice);
                stmt.setString(4, roomStatus);
                stmt.setInt(5, roomId);

                int rowsUpdated = stmt.executeUpdate();

                if (rowsUpdated > 0) {
                    out.println("<p class='text-success'>Room updated successfully!</p>");
                } else {
                    out.println("<p class='text-danger'>No changes were made.</p>");
                }

                stmt.close();
                conn.close();
            } catch (Exception e) {
                out.println("<p class='text-danger'>Error updating room: " + e.getMessage() + "</p>");
            }
        %>
        <a href="admin_rooms.jsp" class="btn btn-primary">Back to Room Management</a>
    </div>
</body>
</html>
