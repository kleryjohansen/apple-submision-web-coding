<%@ page import="java.sql.*" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%
    String roomNumber = request.getParameter("room_number");
    String roomType = request.getParameter("room_type");
    String price = request.getParameter("price");
    String status = request.getParameter("status");

    // Validate input
    if (roomNumber == null || roomType == null || price == null || status == null ||
        roomNumber.isEmpty() || roomType.isEmpty() || price.isEmpty() || status.isEmpty()) {
        response.sendRedirect("admin_add_room.jsp?error=All fields are required");
        return;
    }

    try {
        // Load the MySQL JDBC driver
        Class.forName("com.mysql.cj.jdbc.Driver");

        // Connect to the database
        Connection conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/hotel_reservation", "root", "");

        // SQL query to insert a new room
        String sql = "INSERT INTO rooms (room_number, type, price, status) VALUES (?, ?, ?, ?)";
        PreparedStatement stmt = conn.prepareStatement(sql);

        stmt.setString(1, roomNumber);
        stmt.setString(2, roomType);
        stmt.setBigDecimal(3, new java.math.BigDecimal(price));
        stmt.setString(4, status);

        int rowsInserted = stmt.executeUpdate();

        // Redirect to the room management page with success or error message
        if (rowsInserted > 0) {
            response.sendRedirect("admin_rooms.jsp?success=Room added successfully");
        } else {
            response.sendRedirect("admin_add_room.jsp?error=Failed to add room");
        }

        // Close database resources
        stmt.close();
        conn.close();
    } catch (ClassNotFoundException e) {
        // Handle database driver errors
        response.sendRedirect("admin_add_room.jsp?error=Database driver not found: " + e.getMessage());
    } catch (SQLException e) {
        // Handle SQL errors
        response.sendRedirect("admin_add_room.jsp?error=Database error: " + e.getMessage());
    }
%>
