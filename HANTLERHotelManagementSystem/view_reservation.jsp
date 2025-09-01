<%@page import="java.sql.*"%>
<%@page import="javax.naming.*"%>
<%@page import="javax.sql.DataSource"%>
<%@page import="java.text.NumberFormat"%>
<%@page import="java.util.Locale"%>
<%@page import="java.text.SimpleDateFormat"%>
<%
    // Check if user is logged in
    if (session.getAttribute("guest_id") == null) {
        response.sendRedirect("login.jsp");
        return;
    }

    // Get reservation ID from parameter
    String reservationId = request.getParameter("id");
    
    // Initialize data structure
    class ReservationInvoice {
        // Guest Information
        String guestName = "Not Available";
        String guestEmail = "-";
        String guestPhone = "-";
        
        // Room Information
        String roomNumber = "-";
        String roomType = "-";
        double roomPrice = 0.0;
        
        // Reservation Dates
        String checkInDate = "-";
        String checkOutDate = "-";
        int nights = 0;
        
        // Payment Information
        String paymentMethod = "-";
        String paymentDate = "-";
        double amountPaid = 0.0;
        
        // Status
        boolean isPaid = false;
    }
    
    ReservationInvoice invoice = new ReservationInvoice();
    invoice.guestName = (String) session.getAttribute("guest_name");

    if (reservationId != null && !reservationId.isEmpty()) {
        Connection conn = null;
        PreparedStatement ps = null;
        ResultSet rs = null;
        
        try {
            // Get database connection
            Context ctx = new InitialContext();
            DataSource ds = (DataSource) ctx.lookup("java:comp/env/jdbc/hotel_reservation");
            conn = ds.getConnection();
            
            // Query to get reservation details
            String sql = "SELECT r.reservation_id, g.email, g.phone, " +
                         "rm.room_number, rm.type, rm.price, " +
                         "r.check_in, r.check_out, r.payment_status, " +
                         "p.payment_method, p.payment_date, p.amount " +
                         "FROM reservations r " +
                         "JOIN guests g ON r.guest_id = g.guest_id " +
                         "JOIN rooms rm ON r.room_id = rm.room_id " +
                         "LEFT JOIN payments p ON r.reservation_id = p.reservation_id " +
                         "WHERE r.reservation_id = ? AND r.guest_id = ?";
            
            ps = conn.prepareStatement(sql);
            ps.setInt(1, Integer.parseInt(reservationId));
            ps.setInt(2, (Integer) session.getAttribute("guest_id"));
            rs = ps.executeQuery();
            
            if (rs.next()) {
                // Guest Information
                invoice.guestEmail = rs.getString("email");
                invoice.guestPhone = rs.getString("phone");
                
                // Room Information
                invoice.roomNumber = rs.getString("room_number");
                invoice.roomType = rs.getString("type");
                invoice.roomPrice = rs.getDouble("price");
                
                // Reservation Dates
                SimpleDateFormat dateFormat = new SimpleDateFormat("MMMM dd, yyyy");
                invoice.checkInDate = dateFormat.format(rs.getDate("check_in"));
                invoice.checkOutDate = dateFormat.format(rs.getDate("check_out"));
                
                // Calculate stay duration
                long timeDiff = rs.getDate("check_out").getTime() - rs.getDate("check_in").getTime();
                invoice.nights = (int) (timeDiff / (1000 * 60 * 60 * 24));
                
                // Payment Information
                if (rs.getString("payment_status").equals("completed") && rs.getObject("payment_method") != null) {
                    invoice.isPaid = true;
                    invoice.paymentMethod = rs.getString("payment_method");
                    invoice.amountPaid = rs.getDouble("amount");
                    invoice.paymentDate = dateFormat.format(rs.getDate("payment_date"));
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            if (rs != null) try { rs.close(); } catch (SQLException e) {}
            if (ps != null) try { ps.close(); } catch (SQLException e) {}
            if (conn != null) try { conn.close(); } catch (SQLException e) {}
        }
    }
    
    // Currency formatter
    NumberFormat currency = NumberFormat.getCurrencyInstance(Locale.US);
%>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Invoice #<%= reservationId %> | Hotel Reservation</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.10.0/font/bootstrap-icons.css">
    <style>
        body {
            background-color: #f8f9fa;
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
        }
        .invoice-container {
            max-width: 800px;
            margin: 30px auto;
            padding: 30px;
            background: white;
            box-shadow: 0 0 15px rgba(0,0,0,0.1);
            border-radius: 8px;
        }
        .invoice-header {
            border-bottom: 2px solid #eee;
            padding-bottom: 20px;
            margin-bottom: 30px;
        }
        .hotel-logo {
            height: 70px;
            margin-bottom: 10px;
        }
        .section-title {
            color: #2c3e50;
            border-bottom: 1px solid #eee;
            padding-bottom: 8px;
            margin: 20px 0 15px;
        }
        .info-card {
            background-color: #f8f9fa;
            border-radius: 6px;
            padding: 15px;
            margin-bottom: 20px;
        }
        .payment-card {
            background-color: #f0f8ff;
            border-radius: 6px;
            padding: 15px;
            margin-bottom: 20px;
        }
        .total-card {
            background-color: #e8f4ff;
            border-radius: 6px;
            padding: 15px;
        }
        .info-label {
            font-weight: 600;
            color: #34495e;
            min-width: 160px;
            display: inline-block;
        }
        .status-badge {
            display: inline-block;
            padding: 5px 10px;
            border-radius: 20px;
            font-size: 0.75rem;
            font-weight: 500;
        }
        .status-completed {
            background-color: #d4edda;
            color: #155724;
        }
        @media print {
            body {
                background-color: white !important;
            }
            .no-print {
                display: none !important;
            }
            .invoice-container {
                box-shadow: none;
                border: 1px solid #ddd;
            }
        }
    </style>
</head>
<body>
    <div class="container">
        <div class="invoice-container">
            <!-- Invoice Header -->
            <div class="invoice-header">
                <div class="row">
                    <div class="col-md-6">
                        <img src="https://via.placeholder.com/200x70?text=Hotel+Logo" alt="Hotel Logo" class="hotel-logo">
                        <h4>Grand Luxury Hotel</h4>
                        <p class="text-muted mb-0">123 Luxury Avenue, Jakarta</p>
                        <p class="text-muted">Phone: (021) 12345678</p>
                    </div>
                    <div class="col-md-6 text-end">
                        <h2 class="text-primary">INVOICE</h2>
                        <p class="mb-1"><strong>Invoice #<%= reservationId %></strong></p>
                        <p class="text-muted">Date: <%= new SimpleDateFormat("MMM dd, yyyy").format(new java.util.Date()) %></p>
                        <span class="status-badge status-completed">PAID</span>
                    </div>
                </div>
            </div>

            <!-- Guest Information -->
            <div class="mb-4">
                <h5 class="section-title">Guest Information</h5>
                <div class="row">
                    <div class="col-md-6">
                        <p><span class="info-label">Full Name:</span> <%= invoice.guestName %></p>
                        <p><span class="info-label">Email:</span> <%= invoice.guestEmail %></p>
                    </div>
                    <div class="col-md-6">
                        <p><span class="info-label">Phone:</span> <%= invoice.guestPhone %></p>
                    </div>
                </div>
            </div>

            <!-- Reservation Details -->
            <div class="info-card mb-4">
                <h5 class="section-title">Reservation Details</h5>
                <div class="row">
                    <div class="col-md-6">
                        <p><span class="info-label">Check-in Date:</span> <%= invoice.checkInDate %></p>
                        <p><span class="info-label">Check-out Date:</span> <%= invoice.checkOutDate %></p>
                    </div>
                    <div class="col-md-6">
                        <p><span class="info-label">Nights:</span> <%= invoice.nights %></p>
                    </div>
                </div>
            </div>

            <!-- Room Details -->
            <div class="info-card mb-4">
                <h5 class="section-title">Room Details</h5>
                <div class="row">
                    <div class="col-md-6">
                        <p><span class="info-label">Room Number:</span> <%= invoice.roomNumber %></p>
                        <p><span class="info-label">Room Type:</span> <%= invoice.roomType %></p>
                    </div>
                    <div class="col-md-6">
                        <p><span class="info-label">Nightly Rate:</span> <%= currency.format(invoice.roomPrice) %></p>
                        <p><span class="info-label">Total Room Charge:</span> <%= currency.format(invoice.roomPrice * invoice.nights) %></p>
                    </div>
                </div>
            </div>

            <!-- Payment Details -->
            <% if (invoice.isPaid) { %>
            <div class="payment-card mb-4">
                <h5 class="section-title">Payment Details</h5>
                <div class="row">
                    <div class="col-md-6">
                        <p><span class="info-label">Payment Method:</span> <%= invoice.paymentMethod %></p>
                        <p><span class="info-label">Payment Date:</span> <%= invoice.paymentDate %></p>
                    </div>
                    <div class="col-md-6">
                        <p><span class="info-label">Amount Paid:</span> <%= currency.format(invoice.amountPaid) %></p>
                        <p><span class="info-label">Transaction ID:</span> PAY-<%= reservationId %></p>
                    </div>
                </div>
            </div>
            <% } %>

            <!-- Summary -->
            <div class="total-card mb-4">
                <h5 class="section-title">Payment Summary</h5>
                <div class="row">
                    <div class="col-md-8">
                        <p><%= invoice.nights %> Nights × <%= currency.format(invoice.roomPrice) %></p>
                        <p class="text-muted"><small>Period: <%= invoice.checkInDate %> to <%= invoice.checkOutDate %></small></p>
                    </div>
                    <div class="col-md-4 text-end">
                        <h4>Total: <%= currency.format(invoice.roomPrice * invoice.nights) %></h4>
                    </div>
                </div>
            </div>

            <!-- Footer -->
            <div class="mt-4 no-print">
                <div class="d-flex justify-content-between">
                    <button class="btn btn-primary" onclick="window.print()">
                        <i class="bi bi-printer-fill"></i> Print Invoice
                    </button>
                    <a href="my_reservations.jsp" class="btn btn-outline-secondary">
                        <i class="bi bi-arrow-left"></i> Back to Reservations
                    </a>
                </div>
                <div class="mt-3 text-center">
                    <p class="small text-muted">
                        <i class="bi bi-info-circle"></i> This invoice serves as official payment receipt
                    </p>
                </div>
            </div>
        </div>
    </div>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>