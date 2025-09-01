<%@ include file="dbconnection.jsp" %>
<%@ page import="java.sql.*, java.time.LocalDate" %>

<% if (session.getAttribute("guest_id") == null) {
    response.sendRedirect("login.jsp");
    return;
}

int roomId = 0;
try {
    roomId = Integer.parseInt(request.getParameter("room_id"));
} catch (NumberFormatException e) {
    response.sendRedirect("book_room.jsp");
    return;
}

// Fetch room details
String roomQuery = "SELECT * FROM rooms WHERE room_id = ?";
PreparedStatement psRoom = conn.prepareStatement(roomQuery);
psRoom.setInt(1, roomId);
ResultSet rsRoom = psRoom.executeQuery();

if (!rsRoom.next()) {
    response.sendRedirect("book_room.jsp");
    return;
}

String roomNumber = rsRoom.getString("room_number");
String type = rsRoom.getString("type");
double price = rsRoom.getDouble("price");
String status = rsRoom.getString("status");
String description = rsRoom.getString("description");

// Check if user has stayed in this room before
boolean canReview = false;
int guestId = (Integer) session.getAttribute("guest_id");
String reviewCheckQuery = "SELECT 1 FROM reservations WHERE guest_id = ? AND room_id = ? AND check_out < CURDATE() AND payment_status = 'completed'";
PreparedStatement psReviewCheck = conn.prepareStatement(reviewCheckQuery);
psReviewCheck.setInt(1, guestId);
psReviewCheck.setInt(2, roomId);
canReview = psReviewCheck.executeQuery().next();

// Check if user has already reviewed this room
boolean hasReviewed = false;
String existingReviewQuery = "SELECT 1 FROM reviews WHERE guest_id = ? AND room_id = ?";
PreparedStatement psExistingReview = conn.prepareStatement(existingReviewQuery);
psExistingReview.setInt(1, guestId);
psExistingReview.setInt(2, roomId);
hasReviewed = psExistingReview.executeQuery().next();

// Process review submission
if (request.getMethod().equals("POST") && request.getParameter("submit_review") != null && canReview && !hasReviewed) {
    int rating = Integer.parseInt(request.getParameter("rating"));
    String comment = request.getParameter("comment");
    
    String insertReview = "INSERT INTO reviews (guest_id, room_id, rating, comment, review_date) VALUES (?, ?, ?, ?, CURDATE())";
    PreparedStatement psInsertReview = conn.prepareStatement(insertReview);
    psInsertReview.setInt(1, guestId);
    psInsertReview.setInt(2, roomId);
    psInsertReview.setInt(3, rating);
    psInsertReview.setString(4, comment);
    psInsertReview.executeUpdate();
    
    // Refresh the page to show the new review
    response.sendRedirect("room_details.jsp?room_id=" + roomId);
    return;
}

// Get all reviews for this room
String reviewsQuery = "SELECT r.*, g.name FROM reviews r JOIN guests g ON r.guest_id = g.guest_id WHERE room_id = ? ORDER BY review_date DESC";
PreparedStatement psReviews = conn.prepareStatement(reviewsQuery);
psReviews.setInt(1, roomId);
ResultSet rsReviews = psReviews.executeQuery();
%>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title><%= type %> Room | LuxeStay Hotels</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css" rel="stylesheet">
    <style>
        :root {
            --primary-color: #3a86ff;
            --secondary-color: #8338ec;
            --accent-color: #ff006e;
            --light-gray: #f8f9fa;
            --dark-gray: #343a40;
        }
        
        body {
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
            background-color: #ffffff;
            color: #333;
        }
        
        .room-header {
            background: linear-gradient(135deg, rgba(58,134,255,0.05) 0%, rgba(131,56,236,0.05) 100%);
            padding: 4rem 0;
            margin-bottom: 3rem;
            border-bottom: 1px solid rgba(0,0,0,0.05);
        }
        
        .room-gallery-main {
            height: 500px;
            object-fit: cover;
            border-radius: 12px;
            width: 100%;
            box-shadow: 0 5px 15px rgba(0,0,0,0.1);
        }
        
        .room-gallery-thumb {
            height: 100px;
            object-fit: cover;
            border-radius: 8px;
            cursor: pointer;
            transition: all 0.3s ease;
            border: 2px solid transparent;
        }
        
        .room-gallery-thumb:hover {
            transform: scale(1.05);
            border-color: var(--primary-color);
        }
        
        .room-gallery-thumb.active {
            border-color: var(--primary-color);
        }
        
        .booking-card {
            border-radius: 12px;
            box-shadow: 0 10px 30px rgba(0,0,0,0.08);
            position: sticky;
            top: 20px;
            border: none;
        }
        
        .amenity-icon {
            width: 48px;
            height: 48px;
            background: rgba(58,134,255,0.08);
            border-radius: 12px;
            display: flex;
            align-items: center;
            justify-content: center;
            margin-right: 15px;
            color: var(--primary-color);
            font-size: 1.2rem;
        }
        
        .price-highlight {
            font-size: 2.2rem;
            font-weight: 700;
            color: var(--primary-color);
        }
        
        .btn-book {
            background: linear-gradient(45deg, var(--primary-color), var(--secondary-color));
            color: white;
            border: none;
            padding: 12px 30px;
            border-radius: 50px;
            font-weight: 600;
            transition: all 0.3s ease;
            box-shadow: 0 4px 15px rgba(58,134,255,0.2);
        }
        
        .btn-book:hover {
            transform: translateY(-3px);
            box-shadow: 0 10px 25px rgba(58,134,255,0.3);
            color: white;
        }
        
        .review-card {
            border-radius: 12px;
            border: 1px solid rgba(0,0,0,0.05);
            transition: all 0.3s ease;
        }
        
        .review-card:hover {
            box-shadow: 0 5px 15px rgba(0,0,0,0.05);
            transform: translateY(-2px);
        }
        
        .rating-stars {
            color: #ffc107;
            font-size: 1.1rem;
        }
        
        .review-form {
            background-color: var(--light-gray);
            border-radius: 12px;
            padding: 2rem;
        }
        
        .status-badge {
            padding: 6px 12px;
            border-radius: 20px;
            font-weight: 600;
            font-size: 0.9rem;
        }
        
        .status-available {
            background-color: rgba(40, 167, 69, 0.1);
            color: #28a745;
        }
        
        .status-occupied {
            background-color: rgba(220, 53, 69, 0.1);
            color: #dc3545;
        }
        
        .feature-divider {
            width: 60px;
            height: 3px;
            background: linear-gradient(45deg, var(--primary-color), var(--secondary-color));
            margin: 1.5rem 0;
            border-radius: 3px;
        }
        
        .pricing-summary {
            background-color: rgba(248, 249, 250, 0.8);
            border-radius: 10px;
            padding: 1.5rem;
        }
        
        .review-restriction {
            background-color: #fff3cd;
            border-left: 4px solid #ffc107;
            padding: 1rem;
            border-radius: 4px;
            margin-bottom: 1.5rem;
        }
    </style>
</head>
<body>
    <nav class="navbar navbar-expand-lg navbar-light bg-white shadow-sm">
        <div class="container">
            <a class="navbar-brand fw-bold text-primary" href="index.jsp">LuxeStay</a>
            <a href="book_room.jsp" class="btn btn-outline-primary ms-auto">
                <i class="fas fa-arrow-left me-2"></i>Back to Rooms
            </a>
        </div>
    </nav>

    <div class="room-header">
        <div class="container">
            <div class="row align-items-center">
                <div class="col-md-8">
                    <h1 class="display-4 fw-bold mb-3"><%= type %> Room</h1>
                    <div class="d-flex align-items-center mb-3">
                        <span class="status-badge status-<%= status.equals("available") ? "available" : "occupied" %> me-3">
                            <%= status.equals("available") ? "Available" : "Occupied" %>
                        </span>
                        <div class="rating-stars">
                            <i class="fas fa-star"></i>
                            <i class="fas fa-star"></i>
                            <i class="fas fa-star"></i>
                            <i class="fas fa-star"></i>
                            <i class="fas fa-star-half-alt"></i>
                            <span class="text-dark ms-2">4.7 (120 reviews)</span>
                        </div>
                    </div>
                    <p class="lead text-muted"><%= description != null ? description : "This beautiful " + type + " room offers all the modern amenities you need for a comfortable stay." %></p>
                </div>
                <div class="col-md-4 text-md-end">
                    <h3 class="price-highlight mb-0">$<%= price %><small class="text-muted fs-6"> / night</small></h3>
                </div>
            </div>
        </div>
    </div>

    <div class="container mb-5">
        <div class="row">
            <div class="col-lg-8">
                <div class="mb-4">
                    <img id="mainImage" src="https://images.unsplash.com/photo-<%= roomId % 2 == 0 ? "1582719478250-c89cae4dc85b" : "1566669437685-1f8b728b1d1a" %>?ixlib=rb-1.2.1&auto=format&fit=crop&w=1000&q=80" 
                         class="room-gallery-main" alt="<%= type %> Room">
                </div>
                
                <div class="row g-3 mb-5">
                    <div class="col-4 col-md-3">
                        <img src="https://images.unsplash.com/photo-<%= roomId % 2 == 0 ? "1582719478250-c89cae4dc85b" : "1566669437685-1f8b728b1d1a" %>?ixlib=rb-1.2.1&auto=format&fit=crop&w=500&q=60" 
                             class="room-gallery-thumb active" onclick="changeImage(this)">
                    </div>
                    <div class="col-4 col-md-3">
                        <img src="https://images.unsplash.com/photo-1522771739844-6a9f6d5f14af?ixlib=rb-1.2.1&auto=format&fit=crop&w=500&q=60" 
                             class="room-gallery-thumb" onclick="changeImage(this)">
                    </div>
                    <div class="col-4 col-md-3">
                        <img src="https://images.unsplash.com/photo-1554995207-c18c203602cb?ixlib=rb-1.2.1&auto=format&fit=crop&w=500&q=60" 
                             class="room-gallery-thumb" onclick="changeImage(this)">
                    </div>
                    <div class="col-4 col-md-3">
                        <img src="https://images.unsplash.com/photo-1598928631835-15b42c4f1e3a?ixlib=rb-1.2.1&auto=format&fit=crop&w=500&q=60" 
                             class="room-gallery-thumb" onclick="changeImage(this)">
                    </div>
                </div>
                
                <div class="mb-5">
                    <h3 class="mb-4">About This Room</h3>
                    <div class="feature-divider"></div>
                    <p class="lead"><%= description != null ? description : "This beautiful " + type + " room offers all the modern amenities you need for a comfortable stay. Spacious and well-appointed, it's perfect for both business and leisure travelers." %></p>
                </div>
                
                <div class="row mb-5">
                    <div class="col-md-6 mb-4 mb-md-0">
                        <h4 class="mb-4">Room Features</h4>
                        <div class="feature-divider"></div>
                        <div class="d-flex align-items-center mb-3">
                            <div class="amenity-icon">
                                <i class="fas fa-bed"></i>
                            </div>
                            <div>
                                <h6 class="mb-0">Comfortable Bedding</h6>
                                <p class="text-muted mb-0"><%= type.contains("Suite") ? "King size bed with premium linens" : "Queen or King size bed options" %></p>
                            </div>
                        </div>
                        <div class="d-flex align-items-center mb-3">
                            <div class="amenity-icon">
                                <i class="fas fa-wifi"></i>
                            </div>
                            <div>
                                <h6 class="mb-0">High-Speed Internet</h6>
                                <p class="text-muted mb-0">Free WiFi throughout your stay</p>
                            </div>
                        </div>
                        <div class="d-flex align-items-center mb-3">
                            <div class="amenity-icon">
                                <i class="fas fa-tv"></i>
                            </div>
                            <div>
                                <h6 class="mb-0">Entertainment</h6>
                                <p class="text-muted mb-0">55" Smart TV with streaming</p>
                            </div>
                        </div>
                    </div>
                    <div class="col-md-6">
                        <h4 class="mb-4">Services</h4>
                        <div class="feature-divider"></div>
                        <div class="d-flex align-items-center mb-3">
                            <div class="amenity-icon">
                                <i class="fas fa-concierge-bell"></i>
                            </div>
                            <div>
                                <h6 class="mb-0">Room Service</h6>
                                <p class="text-muted mb-0">24-hour dining options</p>
                            </div>
                        </div>
                        <div class="d-flex align-items-center mb-3">
                            <div class="amenity-icon">
                                <i class="fas fa-spa"></i>
                            </div>
                            <div>
                                <h6 class="mb-0">Spa Access</h6>
                                <p class="text-muted mb-0">Discounts on spa treatments</p>
                            </div>
                        </div>
                        <div class="d-flex align-items-center mb-3">
                            <div class="amenity-icon">
                                <i class="fas fa-swimming-pool"></i>
                            </div>
                            <div>
                                <h6 class="mb-0">Pool & Gym</h6>
                                <p class="text-muted mb-0">Complimentary access</p>
                            </div>
                        </div>
                    </div>
                </div>
                
                <div class="mb-5" id="reviews">
                    <h4 class="mb-4">Guest Reviews</h4>
                    <div class="feature-divider"></div>
                    
                    <% if (rsReviews.next()) { %>
                        <% do { %>
                        <div class="card review-card mb-3">
                            <div class="card-body">
                                <div class="d-flex justify-content-between mb-3">
                                    <div>
                                        <h5 class="mb-1"><%= rsReviews.getString("name") %></h5>
                                        <div class="rating-stars mb-2">
                                            <% for (int i = 1; i <= 5; i++) { %>
                                                <% if (i <= rsReviews.getInt("rating")) { %>
                                                    <i class="fas fa-star"></i>
                                                <% } else if (i == rsReviews.getInt("rating") + 0.5) { %>
                                                    <i class="fas fa-star-half-alt"></i>
                                                <% } else { %>
                                                    <i class="far fa-star"></i>
                                                <% } %>
                                            <% } %>
                                        </div>
                                    </div>
                                    <small class="text-muted"><%= rsReviews.getDate("review_date") %></small>
                                </div>
                                <p class="mb-0"><%= rsReviews.getString("comment") %></p>
                            </div>
                        </div>
                        <% } while (rsReviews.next()); %>
                    <% } else { %>
                        <p class="text-muted">No reviews yet. Be the first to review!</p>
                    <% } %>
                    
                    <% if (canReview) { %>
                        <% if (hasReviewed) { %>
                            <div class="alert alert-success mt-4">
                                <i class="fas fa-check-circle me-2"></i> Thank you for your review!
                            </div>
                        <% } else { %>
                            <div class="review-form mt-4">
                                <h5 class="mb-4">Leave a Review</h5>
                                <form method="post">
                                    <input type="hidden" name="submit_review" value="true">
                                    <input type="hidden" name="room_id" value="<%= roomId %>">
                                    
                                    <div class="mb-3">
                                        <label class="form-label">Your Rating</label>
                                        <div class="rating-stars fs-3">
                                            <% for (int i = 1; i <= 5; i++) { %>
                                                <i class="far fa-star" data-rating="<%= i %>" onclick="setRating(this)"></i>
                                            <% } %>
                                            <input type="hidden" name="rating" id="ratingValue" value="5" required>
                                        </div>
                                    </div>
                                    
                                    <div class="mb-3">
                                        <label class="form-label">Your Review</label>
                                        <textarea class="form-control" name="comment" rows="4" required 
                                                  placeholder="Share your experience..."></textarea>
                                    </div>
                                    
                                    <button type="submit" class="btn btn-primary">
                                        <i class="fas fa-paper-plane me-2"></i>Submit Review
                                    </button>
                                </form>
                            </div>
                        <% } %>
                    <% } else if (!hasReviewed) { %>
                        <div class="review-restriction mt-4">
                            <h5><i class="fas fa-info-circle me-2"></i>Review Restrictions</h5>
                            <p class="mb-0">You can only leave a review for this room after you've completed your stay. 
                                Book this room and check out to share your experience!</p>
                        </div>
                    <% } %>
                </div>
            </div>
            
            <div class="col-lg-4">
                <div class="card booking-card p-4">
                    <h4 class="mb-4">Book This Room</h4>
                    
                    <% if (status.equals("available")) { %>
                    <form method="post" action="process_booking.jsp">
                        <input type="hidden" name="room_id" value="<%= roomId %>">
                        
                        <div class="mb-3">
                            <label class="form-label">Check-in Date</label>
                            <input type="date" class="form-control" name="check_in" required 
                                   min="<%= LocalDate.now() %>" id="checkInDate">
                        </div>
                        
                        <div class="mb-3">
                            <label class="form-label">Check-out Date</label>
                            <input type="date" class="form-control" name="check_out" required 
                                   min="<%= LocalDate.now().plusDays(1) %>" id="checkOutDate">
                        </div>
                        
                        <div class="mb-3">
                            <label class="form-label">Guests</label>
                            <select class="form-select" name="guests">
                                <option value="1">1 Guest</option>
                                <option value="2" selected>2 Guests</option>
                                <option value="3">3 Guests</option>
                                <option value="4">4 Guests</option>
                            </select>
                        </div>
                        
                        <div class="mb-4">
                            <label class="form-label">Special Requests</label>
                            <textarea class="form-control" rows="3" name="special_requests" 
                                      placeholder="Any special requirements?"></textarea>
                        </div>
                        
                        <div class="d-grid">
                            <button type="submit" class="btn btn-book">
                                <i class="fas fa-calendar-check me-2"></i>Book Now
                            </button>
                        </div>
                        
                        <div class="text-center mt-3">
                            <small class="text-muted">You won't be charged until checkout</small>
                        </div>
                    </form>
                    <% } else { %>
                    <div class="alert alert-warning">
                        <i class="fas fa-exclamation-circle me-2"></i>
                        This room is currently not available for the selected dates.
                    </div>
                    <a href="book_room.jsp" class="btn btn-outline-primary">
                        <i class="fas fa-search me-2"></i>Find Available Rooms
                    </a>
                    <% } %>
                    
                    <hr class="my-4">
                    
                    <div class="pricing-summary">
                        <h5 class="mb-3">Pricing Summary</h5>
                        <div class="d-flex justify-content-between mb-2">
                            <span>$<%= price %> x <span id="nightsCount">1</span> nights</span>
                            <span>$<span id="subtotal"><%= price %></span></span>
                        </div>
                        <div class="d-flex justify-content-between mb-2">
                            <span>Taxes & Fees</span>
                            <span>$<span id="taxes"><%= String.format("%.2f", price * 0.12) %></span></span>
                        </div>
                        <hr>
                        <div class="d-flex justify-content-between fw-bold">
                            <span>Total</span>
                            <span>$<span id="total"><%= String.format("%.2f", price * 1.12) %></span></span>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
    <script>
        // Image gallery functionality
        function changeImage(element) {
            document.getElementById('mainImage').src = element.src;
            document.querySelectorAll('.room-gallery-thumb').forEach(thumb => {
                thumb.classList.remove('active');
            });
            element.classList.add('active');
        }
        
        // Calculate pricing based on dates
        function calculatePricing() {
            const checkIn = new Date(document.getElementById('checkInDate').value);
            const checkOut = new Date(document.getElementById('checkOutDate').value);
            
            if (checkIn && checkOut && checkOut > checkIn) {
                const nights = Math.ceil((checkOut - checkIn) / (1000 * 60 * 60 * 24));
                const pricePerNight = <%= price %>;
                const subtotal = pricePerNight * nights;
                const taxes = subtotal * 0.12;
                const total = subtotal + taxes;
                
                document.getElementById('nightsCount').textContent = nights;
                document.getElementById('subtotal').textContent = subtotal.toFixed(2);
                document.getElementById('taxes').textContent = taxes.toFixed(2);
                document.getElementById('total').textContent = total.toFixed(2);
            }
        }
        
        // Rating stars functionality
        function setRating(star) {
            const rating = parseInt(star.getAttribute('data-rating'));
            document.getElementById('ratingValue').value = rating;
            
            const stars = document.querySelectorAll('.rating-stars i[data-rating]');
            stars.forEach((s, index) => {
                if (index < rating) {
                    s.classList.remove('far');
                    s.classList.add('fas');
                } else {
                    s.classList.remove('fas');
                    s.classList.add('far');
                }
            });
        }
        
        // Add event listeners for date changes
        document.getElementById('checkInDate').addEventListener('change', function() {
            const checkInDate = new Date(this.value);
            const checkOutDateInput = document.getElementById('checkOutDate');
            
            if (this.value) {
                const minCheckOut = new Date(checkInDate);
                minCheckOut.setDate(minCheckOut.getDate() + 1);
                checkOutDateInput.min = minCheckOut.toISOString().split('T')[0];
                
                if (new Date(checkOutDateInput.value) < minCheckOut) {
                    checkOutDateInput.value = '';
                }
            }
            
            calculatePricing();
        });
        
        document.getElementById('checkOutDate').addEventListener('change', calculatePricing);
        
        // Initialize rating stars
        document.addEventListener('DOMContentLoaded', function() {
            // Set default rating to 5 stars
            const stars = document.querySelectorAll('.rating-stars i[data-rating]');
            if (stars.length > 0) {
                stars.forEach((star, index) => {
                    if (index < 5) {
                        star.classList.remove('far');
                        star.classList.add('fas');
                    }
                });
            }
        });
    </script>
</body>
</html>