<%@ page import="java.sql.*" %>
<%@ include file="dbconnection.jsp" %>

<%
// Check if user is logged in
if (session.getAttribute("guest_id") == null) {
    response.sendRedirect("login.jsp");
    return;
}

int guestId = (Integer) session.getAttribute("guest_id");
String message = "";
String status = "error"; // default status

// Check if reservation ID is provided
if (request.getParameter("id") != null) {
    try {
        int reservationId = Integer.parseInt(request.getParameter("id"));
        
        // First verify this reservation belongs to the current user
        String verifySql = "SELECT reservation_id FROM reservations WHERE reservation_id = ? AND guest_id = ?";
        PreparedStatement verifyStmt = conn.prepareStatement(verifySql);
        verifyStmt.setInt(1, reservationId);
        verifyStmt.setInt(2, guestId);
        ResultSet verifyRs = verifyStmt.executeQuery();
        
        if (verifyRs.next()) {
            // Check current status of reservation
            String statusSql = "SELECT payment_status FROM reservations WHERE reservation_id = ?";
            PreparedStatement statusStmt = conn.prepareStatement(statusSql);
            statusStmt.setInt(1, reservationId);
            ResultSet statusRs = statusStmt.executeQuery();
            
            if (statusRs.next()) {
                String currentStatus = statusRs.getString("payment_status");
                
                // Only allow cancellation if status is pending
                if ("pending".equals(currentStatus)) {
                    // Update reservation status to cancelled
                    String updateSql = "UPDATE reservations SET payment_status = 'cancelled' WHERE reservation_id = ?";
                    PreparedStatement updateStmt = conn.prepareStatement(updateSql);
                    updateStmt.setInt(1, reservationId);
                    int rowsAffected = updateStmt.executeUpdate();
                    
                    if (rowsAffected > 0) {
                        message = "Reservation #" + reservationId + " has been successfully cancelled.";
                        status = "success";
                    } else {
                        message = "Failed to cancel reservation. Please try again.";
                    }
                } else {
                    message = "You can only cancel reservations with pending status. Current status: " + currentStatus;
                }
            } else {
                message = "Reservation not found.";
            }
        } else {
            message = "You are not authorized to cancel this reservation or it doesn't exist.";
        }
    } catch (NumberFormatException e) {
        message = "Invalid reservation ID format.";
    } catch (SQLException e) {
        message = "Database error: " + e.getMessage();
    }
} else {
    message = "No reservation ID provided.";
}
%>

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Cancel Reservation | Hotel Reservation</title>
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
            display: flex;
            justify-content: center;
            align-items: center;
            min-height: 100vh;
            padding: 20px;
        }

        .result-container {
            background: var(--white);
            border-radius: 10px;
            box-shadow: 0 5px 20px rgba(0,0,0,0.1);
            padding: 40px;
            max-width: 600px;
            width: 100%;
            text-align: center;
        }

        .result-icon {
            font-size: 4rem;
            margin-bottom: 20px;
        }

        .success {
            color: var(--success);
        }

        .error {
            color: var(--danger);
        }

        .warning {
            color: var(--warning);
        }

        .result-container h2 {
            font-size: 1.8rem;
            margin-bottom: 15px;
            color: var(--dark);
        }

        .result-container p {
            font-size: 1.1rem;
            margin-bottom: 25px;
            color: var(--gray-dark);
        }

        .btn {
            display: inline-flex;
            align-items: center;
            justify-content: center;
            padding: 10px 20px;
            border-radius: 6px;
            font-size: 1rem;
            font-weight: 500;
            cursor: pointer;
            transition: all 0.3s;
            border: none;
            text-decoration: none;
        }

        .btn i {
            margin-right: 8px;
        }

        .btn-primary {
            background: var(--primary);
            color: var(--white);
            box-shadow: 0 2px 5px rgba(67, 97, 238, 0.2);
        }

        .btn-primary:hover {
            background: var(--primary-light);
            transform: translateY(-2px);
            box-shadow: 0 4px 8px rgba(67, 97, 238, 0.3);
        }

        .btn-group {
            display: flex;
            gap: 15px;
            justify-content: center;
            flex-wrap: wrap;
        }

        @media (max-width: 576px) {
            .result-container {
                padding: 30px 20px;
            }
            
            .result-icon {
                font-size: 3rem;
            }
            
            .result-container h2 {
                font-size: 1.5rem;
            }
            
            .result-container p {
                font-size: 1rem;
            }
        }
    </style>
</head>
<body>
    <div class="result-container">
        <% if ("success".equals(status)) { %>
            <div class="result-icon success">
                <i class="fas fa-check-circle"></i>
            </div>
            <h2>Cancellation Successful</h2>
        <% } else { %>
            <div class="result-icon <%= status %>">
                <i class="fas fa-<%= "error".equals(status) ? "times-circle" : "exclamation-triangle" %>"></i>
            </div>
            <h2><%= "error".equals(status) ? "Cancellation Failed" : "Cancellation Not Allowed" %></h2>
        <% } %>
        
        <p><%= message %></p>
        
        <div class="btn-group">
            <a href="my_reservations.jsp" class="btn btn-primary">
                <i class="fas fa-bed"></i> Back to My Reservations
            </a>
            <a href="dashboard.jsp" class="btn btn-primary">
                <i class="fas fa-home"></i> Go to Dashboard
            </a>
        </div>
    </div>
</body>
</html>