<%@ page import="java.sql.*" %>
<%
    // Retrieve the connection from application scope (only set it once)
    Connection conn = (Connection) application.getAttribute("conn");

    // If the connection is null, establish a new connection
    if (conn == null) {
        try {
            // Load MySQL JDBC Driver
            Class.forName("com.mysql.cj.jdbc.Driver");

            // Establish connection to the database
            conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/hotel_reservation", "root", "");

            // Store the connection in the application scope
            application.setAttribute("conn", conn);
        } catch (Exception e) {
            out.println("Database Connection Failed: " + e.getMessage());
        }
    }
%>
