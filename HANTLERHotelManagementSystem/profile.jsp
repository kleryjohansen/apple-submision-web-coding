<%@ page import="java.sql.*" %>
<%@ include file="dbconnection.jsp" %>

<%
if (session.getAttribute("guest_id") == null) {
    response.sendRedirect("login.jsp");
    return;
}

String guestName = (String) session.getAttribute("guest_name");
String guestEmail = "";
String guestPhone = "";
String guestAddress = "";

try {
    int guestId = (Integer) session.getAttribute("guest_id");
    PreparedStatement ps = conn.prepareStatement("SELECT * FROM guests WHERE guest_id = ?");
    ps.setInt(1, guestId);
    ResultSet rs = ps.executeQuery();
    
    if(rs.next()) {
        guestEmail = rs.getString("email");
        guestPhone = rs.getString("phone");
        guestAddress = rs.getString("address");
    }
} catch(SQLException e) {
    out.println("Error loading profile: " + e.getMessage());
}

// Handle form submission
if("POST".equalsIgnoreCase(request.getMethod())) {
    String name = request.getParameter("name");
    String email = request.getParameter("email");
    String phone = request.getParameter("phone");
    String address = request.getParameter("address");
    String password = request.getParameter("password");
    String confirmPassword = request.getParameter("confirmPassword");
    
    // Basic validation
    if(password != null && !password.isEmpty() && !password.equals(confirmPassword)) {
        response.sendRedirect("profile.jsp?error=Passwords do not match");
        return;
    }
    
    try {
        int guestId = (Integer) session.getAttribute("guest_id");
        String sql;
        PreparedStatement ps;
        
        if(password != null && !password.trim().isEmpty()) {
            // In production: Use proper password hashing like BCrypt
            // String hashedPassword = BCrypt.hashpw(password, BCrypt.gensalt());
            String hashedPassword = password; // Replace with actual hashing
            
            sql = "UPDATE guests SET name=?, email=?, phone=?, address=?, password=? WHERE guest_id=?";
            ps = conn.prepareStatement(sql);
            ps.setString(1, name);
            ps.setString(2, email);
            ps.setString(3, phone);
            ps.setString(4, address);
            ps.setString(5, hashedPassword);
            ps.setInt(6, guestId);
        } else {
            sql = "UPDATE guests SET name=?, email=?, phone=?, address=? WHERE guest_id=?";
            ps = conn.prepareStatement(sql);
            ps.setString(1, name);
            ps.setString(2, email);
            ps.setString(3, phone);
            ps.setString(4, address);
            ps.setInt(5, guestId);
        }
        
        int rowsAffected = ps.executeUpdate();
        if(rowsAffected > 0) {
            session.setAttribute("guest_name", name);
            response.sendRedirect("profile.jsp?success=Profile updated successfully");
            return;
        } else {
            response.sendRedirect("profile.jsp?error=Failed to update profile");
            return;
        }
    } catch(SQLException e) {
        response.sendRedirect("profile.jsp?error=Database error: " + e.getMessage());
        return;
    }
}
%>

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>My Profile | Hotel Reservation</title>
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
        }

        .sidebar {
            width: 280px;
            background: var(--white);
            box-shadow: 0 0 20px rgba(0,0,0,0.1);
            height: 100vh;
            position: fixed;
            transition: all 0.3s ease;
            z-index: 1000;
            overflow-y: auto;
        }
        
        .sidebar.collapsed {
            width: 80px;
            overflow: hidden;
        }
        
        .sidebar.collapsed .sidebar-header h3,
        .sidebar.collapsed .sidebar-menu a span,
        .sidebar.collapsed .user-info {
            display: none;
        }
        
        .sidebar.collapsed .sidebar-menu a {
            justify-content: center;
            padding: 15px 0;
            border-left: none;
        }
        
        .sidebar.collapsed .sidebar-menu a i {
            margin-right: 0;
            font-size: 1.2rem;
        }
        
        .sidebar.collapsed .user-profile {
            justify-content: center;
            padding: 20px 0;
        }
        
        .sidebar.collapsed .user-profile img {
            margin-right: 0;
        }

        .sidebar-header {
            padding: 20px;
            background: linear-gradient(135deg, var(--primary), var(--primary-dark));
            color: var(--white);
            display: flex;
            align-items: center;
            justify-content: space-between;
            position: sticky;
            top: 0;
            z-index: 1;
        }

        .sidebar-header h3 {
            font-weight: 600;
            font-size: 1.2rem;
        }

        .user-profile {
            display: flex;
            align-items: center;
            padding: 20px;
            border-bottom: 1px solid rgba(0,0,0,0.05);
            background: var(--white);
            transition: all 0.3s;
        }

        .user-profile:hover {
            background: var(--gray-light);
        }

        .user-profile img {
            width: 50px;
            height: 50px;
            border-radius: 50%;
            margin-right: 15px;
            object-fit: cover;
            border: 3px solid rgba(67, 97, 238, 0.2);
        }

        .user-info h4 {
            font-size: 1rem;
            font-weight: 600;
            margin-bottom: 3px;
            color: var(--dark);
        }

        .user-info p {
            font-size: 0.8rem;
            color: var(--gray-dark);
        }

        .sidebar-menu {
            padding: 15px 0;
        }

        .sidebar-menu ul {
            list-style: none;
        }

        .sidebar-menu li {
            margin-bottom: 5px;
        }

        .sidebar-menu a {
            display: flex;
            align-items: center;
            padding: 12px 25px;
            color: var(--gray-dark);
            text-decoration: none;
            transition: all 0.3s;
            font-size: 0.95rem;
            font-weight: 500;
            border-left: 4px solid transparent;
        }

        .sidebar-menu a i {
            margin-right: 12px;
            width: 20px;
            text-align: center;
            font-size: 1rem;
            color: var(--gray);
        }

        .sidebar-menu a:hover, 
        .sidebar-menu a.active {
            background: rgba(67, 97, 238, 0.1);
            color: var(--primary);
            border-left: 4px solid var(--primary);
        }

        .sidebar-menu a:hover i,
        .sidebar-menu a.active i {
            color: var(--primary);
        }

        .main-content {
            flex: 1;
            margin-left: 280px;
            transition: all 0.3s;
            min-height: 100vh;
        }
        
        .main-content.collapsed {
            margin-left: 80px;
        }

        .top-nav {
            display: flex;
            justify-content: space-between;
            align-items: center;
            padding: 15px 30px;
            background: var(--white);
            box-shadow: 0 2px 15px rgba(0,0,0,0.05);
            position: sticky;
            top: 0;
            z-index: 999;
        }

        .search-box {
            position: relative;
            width: 350px;
        }

        .search-box i {
            position: absolute;
            left: 15px;
            top: 50%;
            transform: translateY(-50%);
            color: var(--gray);
        }

        .search-box input {
            width: 100%;
            padding: 10px 15px 10px 40px;
            border: 1px solid #e0e0e0;
            border-radius: 30px;
            outline: none;
            font-size: 0.9rem;
            transition: all 0.3s;
            background: var(--gray-light);
        }

        .search-box input:focus {
            border-color: var(--primary);
            box-shadow: 0 0 0 3px rgba(67, 97, 238, 0.2);
            background: var(--white);
        }

        .user-menu {
            display: flex;
            align-items: center;
        }

        .user-menu .dropdown-toggle {
            display: flex;
            align-items: center;
            cursor: pointer;
        }

        .user-menu img {
            width: 40px;
            height: 40px;
            border-radius: 50%;
            margin-right: 10px;
            object-fit: cover;
            border: 2px solid var(--primary);
        }

        .user-menu .name {
            font-weight: 500;
            font-size: 0.9rem;
        }

        .content-wrapper {
            padding: 30px;
        }

        .page-header {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 30px;
            flex-wrap: wrap;
            gap: 15px;
        }

        .page-header h2 {
            font-size: 1.8rem;
            font-weight: 600;
            color: var(--dark);
        }

        .breadcrumb {
            display: flex;
            list-style: none;
            padding: 0;
            margin: 0;
            font-size: 0.9rem;
        }

        .breadcrumb li:not(:last-child)::after {
            content: '/';
            margin: 0 8px;
            color: var(--gray);
        }

        .breadcrumb a {
            color: var(--primary);
            text-decoration: none;
            transition: color 0.3s;
        }

        .breadcrumb a:hover {
            color: var(--primary-dark);
            text-decoration: underline;
        }

        .card {
            background: var(--white);
            border-radius: 10px;
            box-shadow: 0 5px 20px rgba(0,0,0,0.05);
            margin-bottom: 30px;
            border: none;
            overflow: hidden;
            transition: transform 0.3s, box-shadow 0.3s;
        }

        .card:hover {
            transform: translateY(-3px);
            box-shadow: 0 8px 25px rgba(0,0,0,0.1);
        }

        .card-header {
            padding: 18px 25px;
            border-bottom: 1px solid rgba(0,0,0,0.05);
            display: flex;
            justify-content: space-between;
            align-items: center;
            background: var(--white);
        }

        .card-header h3 {
            font-size: 1.2rem;
            font-weight: 600;
            color: var(--dark);
            margin: 0;
        }

        .card-body {
            padding: 25px;
        }

        .form-group {
            margin-bottom: 20px;
        }

        .form-group label {
            display: block;
            margin-bottom: 8px;
            font-weight: 500;
            color: var(--gray-dark);
        }

        .form-control {
            width: 100%;
            padding: 10px 15px;
            border: 1px solid #e0e0e0;
            border-radius: 5px;
            font-size: 0.9rem;
            transition: all 0.3s;
        }

        .form-control:focus {
            border-color: var(--primary);
            box-shadow: 0 0 0 3px rgba(67, 97, 238, 0.2);
            outline: none;
        }

        .btn {
            display: inline-flex;
            align-items: center;
            justify-content: center;
            padding: 10px 20px;
            border-radius: 6px;
            font-size: 0.9rem;
            font-weight: 500;
            cursor: pointer;
            transition: all 0.3s;
            border: none;
            text-decoration: none;
            white-space: nowrap;
        }

        .btn i {
            margin-right: 6px;
            font-size: 0.9rem;
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

        .alert {
            padding: 15px;
            border-radius: 6px;
            margin-bottom: 20px;
            font-size: 0.9rem;
        }

        .alert-success {
            background: #d4edda;
            color: #155724;
            border: 1px solid #c3e6cb;
        }

        .alert-danger {
            background: #f8d7da;
            color: #721c24;
            border: 1px solid #f5c6cb;
        }

        .profile-picture {
            text-align: center;
            margin-bottom: 25px;
        }

        .profile-picture img {
            width: 150px;
            height: 150px;
            border-radius: 50%;
            object-fit: cover;
            border: 5px solid white;
            box-shadow: 0 5px 15px rgba(0,0,0,0.1);
        }

        .password-toggle {
            position: relative;
        }

        .password-toggle input {
            padding-right: 40px;
        }

        .password-toggle .toggle-icon {
            position: absolute;
            right: 10px;
            top: 50%;
            transform: translateY(-50%);
            cursor: pointer;
            color: var(--gray);
        }

        .text-danger {
            color: var(--danger);
        }

        textarea.form-control {
            min-height: 100px;
            resize: vertical;
        }

        /* Sidebar toggle button */
        .sidebar-toggle {
            position: absolute;
            right: 15px;
            top: 15px;
            background: rgba(255,255,255,0.2);
            border: none;
            color: white;
            width: 30px;
            height: 30px;
            border-radius: 50%;
            display: flex;
            align-items: center;
            justify-content: center;
            cursor: pointer;
            transition: all 0.3s;
        }
        
        .sidebar-toggle:hover {
            background: rgba(255,255,255,0.3);
        }

        /* Floating action button for mobile */
        .fab {
            position: fixed;
            bottom: 30px;
            right: 30px;
            width: 60px;
            height: 60px;
            border-radius: 50%;
            background: var(--primary);
            color: var(--white);
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 1.5rem;
            box-shadow: 0 4px 15px rgba(67, 97, 238, 0.4);
            cursor: pointer;
            z-index: 99;
            transition: all 0.3s;
            display: none;
        }

        .fab:hover {
            transform: scale(1.1);
            background: var(--primary-light);
        }

        /* Responsive styles */
        @media (max-width: 1200px) {
            .sidebar {
                width: 250px;
            }
            
            .sidebar.collapsed {
                width: 80px;
            }
            
            .main-content {
                margin-left: 250px;
            }
            
            .main-content.collapsed {
                margin-left: 80px;
            }
        }

        @media (max-width: 992px) {
            .search-box {
                width: 250px;
            }
        }

        @media (max-width: 768px) {
            .top-nav {
                padding: 12px 20px;
            }
            .content-wrapper {
                padding: 20px;
            }
            .search-box {
                width: 200px;
            }
            .fab {
                display: flex;
            }
        }

        @media (max-width: 576px) {
            .sidebar {
                transform: translateX(-100%);
                position: fixed;
                width: 280px;
                z-index: 1000;
            }
            
            .sidebar.active {
                transform: translateX(0);
            }
            
            .sidebar.collapsed {
                width: 280px;
            }
            
            .main-content {
                margin-left: 0;
            }
            
            .main-content.collapsed {
                margin-left: 0;
            }
            
            .search-box {
                width: 150px;
            }
            
            .user-menu .name {
                display: none;
            }
        }
    </style>
</head>
<body>
    <div class="sidebar" id="sidebar">
        <div class="sidebar-header">
            <h3>Hotel Guest</h3>
            <button class="sidebar-toggle" id="sidebarToggle">
                <i class="fas fa-chevron-left"></i>
            </button>
        </div>
        
        <div class="user-profile">
            <img src="https://ui-avatars.com/api/?name=<%= guestName %>&background=4361ee&color=fff" alt="<%= guestName %>">
            <div class="user-info">
                <h4><%= guestName %></h4>
                <p>Guest Member</p>
            </div>
        </div>
        
        <div class="sidebar-menu">
            <ul>
                <li><a href="dashboard.jsp"><i class="fas fa-tachometer-alt"></i><span>Dashboard</span></a></li>
                <li><a href="book_room.jsp"><i class="fas fa-calendar-check"></i><span>Book Room</span></a></li>
                <li><a href="my_reservations.jsp"><i class="fas fa-bed"></i><span>My Reservations</span></a></li>
                <li><a href="payment.jsp"><i class="fas fa-credit-card"></i><span>Payments</span></a></li>
                <li><a href="profile.jsp" class="active"><i class="fas fa-user"></i><span>My Profile</span></a></li>
                <li><a href="logout.jsp"><i class="fas fa-sign-out-alt"></i><span>Logout</span></a></li>
            </ul>
        </div>
    </div>

    <div class="main-content" id="mainContent">
        <div class="top-nav">
            <div class="search-box">
           
            
            </div>
            <div class="user-menu">
                <div class="dropdown-toggle">
                    <img src="https://ui-avatars.com/api/?name=<%= guestName %>&background=4361ee&color=fff" alt="<%= guestName %>">
                    <span class="name"><%= guestName %></span>
                </div>
            </div>
        </div>

        <div class="content-wrapper">
            <div class="page-header">
                <h2>My Profile</h2>
                <ul class="breadcrumb">
                    <li><a href="dashboard.jsp">Home</a></li>
                    <li>Profile</li>
                </ul>
            </div>

            <% if(request.getParameter("success") != null) { %>
                <div class="alert alert-success">
                    <%= request.getParameter("success") %>
                </div>
            <% } %>
            
            <% if(request.getParameter("error") != null) { %>
                <div class="alert alert-danger">
                    <%= request.getParameter("error") %>
                </div>
            <% } %>

            <div class="card">
                <div class="card-header">
                    <h3>Profile Information</h3>
                </div>
                <div class="card-body">
                    <form method="POST" action="profile.jsp" onsubmit="return validateForm()">
                        <div class="profile-picture">
                            <img src="https://ui-avatars.com/api/?name=<%= guestName %>&background=4361ee&color=fff&size=150" alt="<%= guestName %>">
                        </div>
                        
                        <div class="form-group">
                            <label for="name">Full Name</label>
                            <input type="text" class="form-control" id="name" name="name" value="<%= guestName %>" required>
                        </div>
                        
                        <div class="form-group">
                            <label for="email">Email Address</label>
                            <input type="email" class="form-control" id="email" name="email" value="<%= guestEmail %>" required>
                        </div>
                        
                        <div class="form-group">
                            <label for="phone">Phone Number</label>
                            <input type="tel" class="form-control" id="phone" name="phone" value="<%= guestPhone %>">
                        </div>
                        
                        <div class="form-group">
                            <label for="address">Address</label>
                            <textarea class="form-control" id="address" name="address" rows="3"><%= guestAddress %></textarea>
                        </div>
                        
                        <div class="form-group password-toggle">
                            <label for="password">New Password (leave blank to keep current)</label>
                            <input type="password" class="form-control" id="password" name="password">
                            <i class="fas fa-eye toggle-icon" id="togglePassword"></i>
                        </div>
                        
                        <div class="form-group password-toggle" id="confirmPasswordGroup" style="display:none;">
                            <label for="confirmPassword">Confirm New Password</label>
                            <input type="password" class="form-control" id="confirmPassword" name="confirmPassword">
                            <i class="fas fa-eye toggle-icon" id="toggleConfirmPassword"></i>
                            <small id="passwordMatchError" class="text-danger" style="display:none;">Passwords do not match</small>
                        </div>
                        
                        <button type="submit" class="btn btn-primary">
                            <i class="fas fa-save"></i> Update Profile
                        </button>
                    </form>
                </div>
            </div>
        </div>
    </div>

    <div class="fab" id="mobileSidebarToggle">
        <i class="fas fa-bars"></i>
    </div>

    <script>
        document.addEventListener('DOMContentLoaded', function() {
            const sidebar = document.getElementById('sidebar');
            const mainContent = document.getElementById('mainContent');
            const sidebarToggle = document.getElementById('sidebarToggle');
            const mobileSidebarToggle = document.getElementById('mobileSidebarToggle');
            
            // Toggle sidebar collapse
            sidebarToggle.addEventListener('click', function() {
                sidebar.classList.toggle('collapsed');
                mainContent.classList.toggle('collapsed');
                
                // Change the icon based on state
                const icon = sidebarToggle.querySelector('i');
                if(sidebar.classList.contains('collapsed')) {
                    icon.classList.remove('fa-chevron-left');
                    icon.classList.add('fa-chevron-right');
                } else {
                    icon.classList.remove('fa-chevron-right');
                    icon.classList.add('fa-chevron-left');
                }
                
                // Save state to localStorage
                localStorage.setItem('sidebarCollapsed', sidebar.classList.contains('collapsed'));
            });
            
            // Toggle sidebar on mobile
            mobileSidebarToggle.addEventListener('click', function() {
                sidebar.classList.toggle('active');
            });
            
            // Password toggle functionality
            const togglePassword = document.querySelector('#togglePassword');
            const password = document.querySelector('#password');
            const toggleConfirmPassword = document.querySelector('#toggleConfirmPassword');
            const confirmPassword = document.querySelector('#confirmPassword');
            
            togglePassword.addEventListener('click', function() {
                const type = password.getAttribute('type') === 'password' ? 'text' : 'password';
                password.setAttribute('type', type);
                this.classList.toggle('fa-eye-slash');
            });
            
            if(toggleConfirmPassword) {
                toggleConfirmPassword.addEventListener('click', function() {
                    const type = confirmPassword.getAttribute('type') === 'password' ? 'text' : 'password';
                    confirmPassword.setAttribute('type', type);
                    this.classList.toggle('fa-eye-slash');
                });
            }
            
            // Show confirm password field when password field is not empty
            password.addEventListener('input', function() {
                if(this.value.trim() !== '') {
                    document.getElementById('confirmPasswordGroup').style.display = 'block';
                } else {
                    document.getElementById('confirmPasswordGroup').style.display = 'none';
                }
            });
            
            // Show/hide FAB based on screen size
            function updateFabVisibility() {
                if(window.innerWidth <= 768) {
                    mobileSidebarToggle.style.display = 'flex';
                } else {
                    mobileSidebarToggle.style.display = 'none';
                    sidebar.classList.remove('active');
                }
            }
            
            window.addEventListener('resize', updateFabVisibility);
            updateFabVisibility();
            
            // Check for collapsed state in localStorage
            if(localStorage.getItem('sidebarCollapsed') === 'true') {
                sidebar.classList.add('collapsed');
                mainContent.classList.add('collapsed');
                const icon = sidebarToggle.querySelector('i');
                icon.classList.remove('fa-chevron-left');
                icon.classList.add('fa-chevron-right');
            }
        });

        function validateForm() {
            const password = document.getElementById('password').value;
            const confirmPassword = document.getElementById('confirmPassword').value;
            const passwordMatchError = document.getElementById('passwordMatchError');
            
            if(password.trim() !== '') {
                if(password !== confirmPassword) {
                    passwordMatchError.style.display = 'block';
                    return false;
                } else {
                    passwordMatchError.style.display = 'none';
                }
            }
            
            return true;
        }
    </script>
</body>
</html>