<%@ page import="java.sql.*" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%
    String roomId = request.getParameter("id");
    String newStatus = request.getParameter("status");
    
    if (roomId == null || roomId.isEmpty() || newStatus == null || newStatus.isEmpty()) {
        response.sendRedirect("admin_rooms.jsp?error=Invalid parameters");
        return;
    }
    
    try {
        Class.forName("com.mysql.cj.jdbc.Driver");
        Connection conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/hotel_reservation", "root", "");
        
        // Check if the room is currently booked
        String checkSql = "SELECT status FROM rooms WHERE room_id = ?";
        PreparedStatement checkStmt = conn.prepareStatement(checkSql);
        checkStmt.setInt(1, Integer.parseInt(roomId));
        ResultSet rs = checkStmt.executeQuery();
        
        if (rs.next()) {
            String currentStatus = rs.getString("status");
            
            // Don't allow changing from booked to maintenance directly
            if (currentStatus.equals("booked")) {
                response.sendRedirect("admin_rooms.jsp?error=Cannot change status of a booked room");
                return;
            }
            
            // Update the status
            String updateSql = "UPDATE rooms SET status = ? WHERE room_id = ?";
            PreparedStatement updateStmt = conn.prepareStatement(updateSql);
            updateStmt.setString(1, newStatus);
            updateStmt.setInt(2, Integer.parseInt(roomId));
            
            int rowsAffected = updateStmt.executeUpdate();
            updateStmt.close();
            
            if (rowsAffected > 0) {
                response.sendRedirect("admin_rooms.jsp?success=Room status updated successfully");
            } else {
                response.sendRedirect("admin_rooms.jsp?error=Failed to update room status");
            }
        } else {
            response.sendRedirect("admin_rooms.jsp?error=Room not found");
        }
        
        rs.close();
        checkStmt.close();
        conn.close();
    } catch (Exception e) {
        e.printStackTrace();
        response.sendRedirect("admin_rooms.jsp?error=Database error: " + e.getMessage());
    }
%>
