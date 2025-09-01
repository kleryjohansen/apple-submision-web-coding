<%@ page import="java.sql.*" %>
<%@ include file="dbconnection.jsp" %>

<%
// Handle login processing
if ("POST".equalsIgnoreCase(request.getMethod())) {
    String email = request.getParameter("email");
    String password = request.getParameter("password");
    
    // Validate inputs
    if (email == null || email.trim().isEmpty() || password == null || password.trim().isEmpty()) {
        response.sendRedirect("login.jsp?error=missing");
        return;
    }
    
    try {
        // Check if connection is valid
        if (conn == null || conn.isClosed()) {
            response.sendRedirect("login.jsp?error=dberror");
            return;
        }

        // Query the database for the user
        String sql = "SELECT * FROM guests WHERE email = ?";
        PreparedStatement pstmt = conn.prepareStatement(sql);
        pstmt.setString(1, email);
        
        ResultSet rs = pstmt.executeQuery();
        
        if (rs.next()) {
            // Verify password (in production, use proper password hashing)
            String storedPassword = rs.getString("password");
            
            if (password.equals(storedPassword)) {
                // Login successful - create session
                session.setAttribute("guest_id", rs.getInt("guest_id"));
                session.setAttribute("guest_name", rs.getString("name"));
                session.setAttribute("guest_email", rs.getString("email"));
                
                // Redirect to dashboard
                response.sendRedirect("dashboard.jsp");
                return;
            }
        }
        
        // If we get here, login failed
        response.sendRedirect("login.jsp?error=invalid");
        return;
        
    } catch (SQLException e) {
        e.printStackTrace();
        response.sendRedirect("login.jsp?error=dberror");
        return;
    }
}
%>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Login | Hantler Hotel</title>
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@300;400;500;600;700&family=Playfair+Display:wght@400;500;600;700&display=swap" rel="stylesheet">
    <style>
        :root {
            --primary: #2563eb;
            --primary-dark: #1d4ed8;
            --secondary: #1e293b;
            --accent: #f59e0b;
            --light: #f8fafc;
            --dark: #0f172a;
            --text: #334155;
            --text-light: #64748b;
            --error: #dc2626;
            --success: #16a34a;
            --overlay: rgba(0, 0, 0, 0.5);
        }

        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
        }

        html {
            scroll-behavior: smooth;
            font-size: 16px;
        }

        body {
            font-family: 'Poppins', -apple-system, BlinkMacSystemFont, 'Segoe UI', Roboto, Oxygen, Ubuntu, Cantarell, sans-serif;
            background: linear-gradient(135deg, #f1f5f9 0%, #e2e8f0 100%);
            color: var(--text);
            min-height: 100vh;
            display: flex;
            flex-direction: column;
            line-height: 1.6;
        }

        .navbar {
            background: var(--secondary);
            color: white;
            padding: 1.2rem 3rem;
            display: flex;
            justify-content: space-between;
            align-items: center;
            box-shadow: 0 4px 6px -1px rgba(0, 0, 0, 0.1), 0 2px 4px -1px rgba(0, 0, 0, 0.06);
            position: sticky;
            top: 0;
            z-index: 100;
            backdrop-filter: blur(8px);
            border-bottom: 1px solid rgba(255, 255, 255, 0.1);
        }

        .nav-brand {
            font-family: 'Playfair Display', serif;
            font-size: 1.8rem;
            font-weight: 700;
            color: white;
            text-decoration: none;
            letter-spacing: 0.5px;
            transition: transform 0.3s ease;
        }

        .nav-brand:hover {
            transform: scale(1.02);
        }

        .nav-links {
            display: flex;
            gap: 2rem;
        }

        .nav-link {
            color: rgba(255, 255, 255, 0.9);
            text-decoration: none;
            font-weight: 500;
            transition: all 0.3s ease;
            padding: 0.5rem 0;
            position: relative;
            font-size: 1rem;
            letter-spacing: 0.5px;
        }

        .nav-link:hover {
            color: white;
        }

        .nav-link::after {
            content: '';
            position: absolute;
            bottom: 0;
            left: 0;
            width: 0;
            height: 2px;
            background: var(--accent);
            transition: width 0.3s ease-out;
        }

        .nav-link:hover::after {
            width: 100%;
        }

        .nav-link.active {
            color: white;
            font-weight: 600;
        }

        .nav-link.active::after {
            width: 100%;
            background: var(--accent);
        }

        .main-container {
            flex: 1;
            padding: 3rem;
            max-width: 1200px;
            margin: 0 auto;
            width: 100%;
            display: flex;
            align-items: center;
            justify-content: center;
        }

        .card {
            background: white;
            border-radius: 16px;
            box-shadow: 0 20px 25px -5px rgba(0, 0, 0, 0.1), 0 10px 10px -5px rgba(0, 0, 0, 0.04);
            padding: 3.5rem;
            margin: 2rem auto;
            transition: all 0.4s cubic-bezier(0.175, 0.885, 0.32, 1.275);
            border: 1px solid rgba(0, 0, 0, 0.05);
            max-width: 500px;
            width: 100%;
            position: relative;
            overflow: hidden;
        }

        .card::before {
            content: '';
            position: absolute;
            top: 0;
            left: 0;
            right: 0;
            height: 6px;
            background: linear-gradient(90deg, var(--primary), var(--accent));
        }

        .card-header {
            text-align: center;
            margin-bottom: 2.5rem;
        }

        h1, h2, h3 {
            color: var(--dark);
            margin-bottom: 1rem;
            font-weight: 700;
            font-family: 'Playfair Display', serif;
        }

        h1 {
            font-size: 2.25rem;
            line-height: 1.2;
            letter-spacing: 0.5px;
        }

        p {
            line-height: 1.7;
            color: var(--text-light);
            margin-bottom: 1.5rem;
            font-size: 1.05rem;
        }

        .subtitle {
            color: var(--text-light);
            font-size: 1.1rem;
            font-weight: 300;
            letter-spacing: 0.5px;
        }

        .auth-form {
            display: flex;
            flex-direction: column;
            gap: 1.75rem;
        }

        .form-group {
            display: flex;
            flex-direction: column;
            gap: 0.75rem;
        }

        .form-group label {
            font-weight: 500;
            color: var(--text);
            font-size: 0.95rem;
        }

        .input-wrapper {
            position: relative;
        }

        input {
            padding: 1rem 1.25rem;
            border: 1px solid #e2e8f0;
            border-radius: 10px;
            font-size: 1rem;
            transition: all 0.3s ease;
            background: var(--light);
            width: 100%;
            font-family: 'Poppins', sans-serif;
        }

        input:focus {
            outline: none;
            border-color: var(--primary);
            box-shadow: 0 0 0 3px rgba(37, 99, 235, 0.1);
            background: white;
        }

        .btn {
            background: var(--primary);
            color: white;
            border: none;
            padding: 1rem 1.5rem;
            border-radius: 10px;
            font-size: 1rem;
            font-weight: 600;
            cursor: pointer;
            transition: all 0.3s cubic-bezier(0.25, 0.8, 0.25, 1);
            text-align: center;
            display: inline-block;
            text-decoration: none;
            letter-spacing: 0.5px;
            box-shadow: 0 4px 6px -1px rgba(37, 99, 235, 0.2), 0 2px 4px -1px rgba(37, 99, 235, 0.1);
        }

        .btn:hover {
            background: var(--primary-dark);
            transform: translateY(-2px);
            box-shadow: 0 10px 15px -3px rgba(37, 99, 235, 0.2), 0 4px 6px -2px rgba(37, 99, 235, 0.1);
        }

        .btn:active {
            transform: translateY(0);
        }

        .btn-block {
            width: 100%;
            padding: 1.1rem;
            font-size: 1rem;
            margin-top: 0.5rem;
        }

        .auth-footer {
            text-align: center;
            margin-top: 1.5rem;
            color: var(--text-light);
            font-size: 0.95rem;
        }

        .auth-footer a {
            color: var(--primary);
            font-weight: 600;
            text-decoration: none;
            transition: color 0.2s;
        }

        .auth-footer a:hover {
            color: var(--primary-dark);
            text-decoration: underline;
        }

        .alert {
            padding: 1.25rem;
            border-radius: 10px;
            margin: 1.5rem 0;
            font-size: 0.95rem;
            display: flex;
            align-items: center;
            gap: 0.75rem;
            border-left: 4px solid;
        }

        .alert-danger {
            background-color: #fef2f2;
            color: var(--error);
            border-color: var(--error);
        }

        .alert-success {
            background-color: #f0fdf4;
            color: var(--success);
            border-color: var(--success);
        }

        .alert-icon {
            font-size: 1.25rem;
        }

        @media (max-width: 768px) {
            .navbar {
                padding: 1rem 1.5rem;
            }
        
            .nav-links {
                gap: 1.25rem;
            }
            
            .card {
                padding: 2.5rem 2rem;
                margin: 1.5rem;
            }
            
            .main-container {
                padding: 1.5rem;
            }

            h1 {
                font-size: 2rem;
            }
        }

        @media (max-width: 480px) {
            .navbar {
                flex-direction: column;
                gap: 1rem;
                padding: 1.25rem;
            }
            
            .nav-links {
                gap: 1rem;
            }
            
            .card {
                padding: 2rem 1.5rem;
            }
            
            h1 {
                font-size: 1.75rem;
            }
        }
    </style>
</head>
<body>
    <nav class="navbar">
        <a href="index.jsp" class="nav-brand">Hantler Hotel</a>
        <div class="nav-links">
            <a href="index.jsp" class="nav-link">Home</a>
            <a href="login.jsp" class="nav-link active">Login</a>
            <a href="register.jsp" class="nav-link">Register</a>
        </div>
    </nav>
    
    <div class="main-container">
        <div class="card">
            <div class="card-header">
                <h1>Welcome Back</h1>
                <p class="subtitle">Sign in to your account to continue</p>
            </div>
            
            <%
                String error = request.getParameter("error");
                if (error != null) {
                    if (error.equals("invalid")) {
                        out.println("<div class='alert alert-danger'>" +
                                  
                                   "<span>Invalid email or password. Please try again.</span>" +
                                   "</div>");
                    } else if (error.equals("missing")) {
                        out.println("<div class='alert alert-danger'>" +
                                  
                                   "<span>Please enter both email and password.</span>" +
                                   "</div>");
                    } else if (error.equals("dberror")) {
                        out.println("<div class='alert alert-danger'>" +
                                  
                                   "<span>Database error occurred. Please try again later.</span>" +
                                   "</div>");
                    }
                }
                
                String success = request.getParameter("success");
                if (success != null && success.equals("registered")) {
                    out.println("<div class='alert alert-success'>" +
                             
                               "<span>Registration successful! Please login with your credentials.</span>" +
                               "</div>");
                }
            %>
            
            <form method="post" action="login.jsp" class="auth-form">
                <div class="form-group">
                    <label for="email">Email Address</label>
                    <div class="input-wrapper">
                        <input type="email" id="email" name="email" placeholder="you@example.com" required>
                    </div>
                </div>
                
                <div class="form-group">
                    <label for="password">Password</label>
                    <div class="input-wrapper">
                        <input type="password" id="password" name="password" placeholder="" required>
                    </div>
                    <p class="hint"></p>
                </div>
                
                <button type="submit" class="btn btn-block">Sign In</button>
                
                <div class="auth-footer">
                    Don't have an account? <a href="register.jsp">Create one</a>
                </div>
            </form>
        </div>
    </div>

    <script>
        document.addEventListener('DOMContentLoaded', function() {
            const inputs = document.querySelectorAll('input');
            
            inputs.forEach(input => {
                input.addEventListener('focus', function() {
                    this.parentElement.style.boxShadow = '0 0 0 3px rgba(37, 99, 235, 0.2)';
                });
                
                input.addEventListener('blur', function() {
                    this.parentElement.style.boxShadow = 'none';
                });
            });
            
            const card = document.querySelector('.card');
            card.style.transform = 'translateY(10px)';
            card.style.opacity = '0';
            
            setTimeout(() => {
                card.style.transform = 'translateY(0)';
                card.style.opacity = '1';
            }, 100);
        });
    </script>
</body>
</html>