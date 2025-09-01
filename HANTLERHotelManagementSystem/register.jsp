<%@ include file="dbconnection.jsp" %>
<%@ page import="java.sql.*" %>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Register | Hantler Hotel</title>
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@300;400;500;600;700&family=Playfair+Display:wght@400;500;600;700&display=swap" rel="stylesheet">
    <style>
        :root {
            --primary: #3b82f6;
            --primary-dark: #2563eb;
            --secondary: #1e293b;
            --accent: #f59e0b;
            --light: #f8fafc;
            --dark: #0f172a;
            --text: #334155;
            --text-light: #64748b;
            --error: #ef4444;
            --success: #10b981;
            --border: #e2e8f0;
            --shadow: 0 4px 6px -1px rgba(0, 0, 0, 0.1), 0 2px 4px -1px rgba(0, 0, 0, 0.06);
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

        /* Navigation Bar */
        .navbar {
            background: var(--secondary);
            color: white;
            padding: 1.2rem 3rem;
            display: flex;
            justify-content: space-between;
            align-items: center;
            box-shadow: var(--shadow);
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

        /* Main Content */
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

        /* Card Design */
        .card {
            background: white;
            border-radius: 16px;
            box-shadow: 0 20px 25px -5px rgba(0, 0, 0, 0.1), 0 10px 10px -5px rgba(0, 0, 0, 0.04);
            padding: 3.5rem;
            margin: 2rem auto;
            transition: all 0.4s cubic-bezier(0.175, 0.885, 0.32, 1.275);
            border: 1px solid var(--border);
            max-width: 500px;
            width: 100%;
            position: relative;
            overflow: hidden;
            animation: fadeInUp 0.6s ease-out;
        }

        @keyframes fadeInUp {
            from {
                opacity: 0;
                transform: translateY(20px);
            }
            to {
                opacity: 1;
                transform: translateY(0);
            }
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

        /* Typography */
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

        /* Form Elements */
        .auth-form {
            display: flex;
            flex-direction: column;
            gap: 1.75rem;
        }

        .form-group {
            display: flex;
            flex-direction: column;
            gap: 0.75rem;
            position: relative;
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
            border: 1px solid var(--border);
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
            box-shadow: 0 0 0 3px rgba(59, 130, 246, 0.1);
            background: white;
        }

        .password-toggle {
            position: absolute;
            right: 1.25rem;
            top: 50%;
            transform: translateY(-50%);
            color: var(--text-light);
            cursor: pointer;
            width: 24px;
            height: 24px;
            display: flex;
            align-items: center;
            justify-content: center;
            transition: color 0.2s;
        }

        .password-toggle:hover {
            color: var(--primary);
        }

        .password-toggle svg {
            width: 20px;
            height: 20px;
        }

        .hint {
            color: var(--text-light);
            font-size: 0.85rem;
            margin-top: 0.25rem;
        }

        .password-strength {
            height: 4px;
            background: #e2e8f0;
            border-radius: 2px;
            margin-top: 0.5rem;
            overflow: hidden;
        }

        .strength-meter {
            height: 100%;
            width: 0%;
            background: var(--error);
            transition: all 0.3s ease;
        }

        /* Buttons */
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
            box-shadow: var(--shadow);
            position: relative;
            overflow: hidden;
        }

        .btn:hover {
            background: var(--primary-dark);
            transform: translateY(-2px);
            box-shadow: 0 10px 15px -3px rgba(59, 130, 246, 0.3), 0 4px 6px -2px rgba(59, 130, 246, 0.1);
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

        /* Auth Footer */
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

        /* Alert Messages */
        .alert {
            padding: 1.25rem;
            border-radius: 10px;
            margin: 1.5rem 0;
            font-size: 0.95rem;
            display: flex;
            align-items: center;
            gap: 0.75rem;
            border-left: 4px solid;
            animation: fadeIn 0.4s ease-out;
        }

        @keyframes fadeIn {
            from { opacity: 0; transform: translateY(-10px); }
            to { opacity: 1; transform: translateY(0); }
        }

        .alert-danger {
            background-color: #fef2f2;
            color: var(--error);
            border-color: var(--error);
        }

        .alert-success {
            background-color: #ecfdf5;
            color: var(--success);
            border-color: var(--success);
        }

        .alert-icon {
            font-size: 1.25rem;
        }

        /* Responsive Design */
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
            <a href="login.jsp" class="nav-link">Login</a>
            <a href="register.jsp" class="nav-link active">Register</a>
        </div>
    </nav>
    
    <div class="main-container">
        <div class="card">
            <div class="card-header">
                <h1>Create Your Account</h1>
                <p class="subtitle">Join Hantler Hotel for exclusive benefits</p>
            </div>
            
            <form method="post" class="auth-form">
                <div class="form-group">
                    <label for="name">Full Name</label>
                    <div class="input-wrapper">
                        <input type="text" id="name" name="name" placeholder="John Doe" required>
                    </div>
                </div>
                
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
                        <span class="password-toggle" onclick="togglePassword()">
                            <svg id="eye-icon" xmlns="http://www.w3.org/2000/svg" viewBox="0 0 24 24" fill="currentColor">
                                <path d="M12 15a3 3 0 100-6 3 3 0 000 6z" />
                                <path fill-rule="evenodd" d="M1.323 11.447C2.811 6.976 7.028 3.75 12.001 3.75c4.97 0 9.185 3.223 10.675 7.69.12.362.12.752 0 1.113-1.487 4.471-5.705 7.697-10.677 7.697-4.97 0-9.186-3.223-10.675-7.69a1.762 1.762 0 010-1.113zM17.25 12a5.25 5.25 0 11-10.5 0 5.25 5.25 0 0110.5 0z" clip-rule="evenodd" />
                            </svg>
                            <svg id="eye-slash-icon" xmlns="http://www.w3.org/2000/svg" viewBox="0 0 24 24" fill="currentColor" style="display: none;">
                                <path d="M3.53 2.47a.75.75 0 00-1.06 1.06l18 18a.75.75 0 101.06-1.06l-18-18zM22.676 12.553a11.249 11.249 0 01-2.631 3.31l-3.099-3.099a5.25 5.25 0 00-6.71-6.71L7.759 4.577a11.217 11.217 0 014.242-.827c4.97 0 9.185 3.223 10.675 7.69.12.362.12.752 0 1.113z" />
                                <path d="M15.75 12c0 .18-.013.357-.037.53l-4.244-4.243A3.75 3.75 0 0115.75 12zM12.53 15.713l-4.243-4.244a3.75 3.75 0 004.243 4.243z" />
                                <path d="M6.75 12c0-.619.107-1.213.304-1.764l-3.1-3.1a11.25 11.25 0 00-2.63 3.31c-.12.362-.12.752 0 1.114 1.489 4.467 5.704 7.69 10.675 7.69 1.5 0 2.933-.294 4.242-.827l-2.477-2.477A5.25 5.25 0 016.75 12z" />
                            </svg>
                        </span>
                    </div>
                    <div class="password-strength">
                        <div class="strength-meter" id="strength-meter"></div>
                    </div>
                    <p class="hint">Minimum 8 characters with at least 1 number</p>
                </div>
                
                <div class="form-group">
                    <label for="phone">Phone Number</label>
                    <div class="input-wrapper">
                        <input type="tel" id="phone" name="phone" placeholder="+62 851-0000-0000" required>
                    </div>
                </div>
                
                <button type="submit" class="btn btn-block">Create Account</button>
                
                <div class="auth-footer">
                    Already have an account? <a href="login.jsp">Sign in here</a>
                </div>
            </form>

            <%
                if(request.getMethod().equals("POST")) {
                    String name = request.getParameter("name");
                    String email = request.getParameter("email");
                    String password = request.getParameter("password");
                    String phone = request.getParameter("phone");

                    try {
                        if (conn == null) {
                            out.println("<div class='alert alert-danger'>" +
                                       "<span class='alert-icon'></span>" +
                                       "<span>Database connection is not available.</span>" +
                                       "</div>");
                            return;
                        }

                        PreparedStatement checkEmail = conn.prepareStatement("SELECT * FROM guests WHERE email = ?");
                        checkEmail.setString(1, email);
                        ResultSet rs = checkEmail.executeQuery();

                        if (rs.next()) {
                            out.println("<div class='alert alert-danger'>" +
                                       "<span class='alert-icon'></span>" +
                                       "<span>Email already exists Please use a different email</span>" +
                                       "</div>");
                        } else {
                            PreparedStatement ps = conn.prepareStatement("INSERT INTO guests (name, email, password, phone) VALUES (?, ?, ?, ?)");
                            ps.setString(1, name);
                            ps.setString(2, email);
                            ps.setString(3, password);
                            ps.setString(4, phone);

                            if (ps.executeUpdate() > 0) {
                                out.println("<div class='alert alert-success'>" +
                                        
                                           "<span>Registration successful! You can now <a href='login.jsp'>login</a></span>" +
                                           "</div>");
                            } else {
                                out.println("<div class='alert alert-danger'>" +
                                           
                                           "<span>Registration failed Please try again</span>" +
                                           "</div>");
                            }
                        }
                    } catch (SQLException e) {
                        out.println("<div class='alert alert-danger'>" +
                                  
                                   "<span>Error: " + e.getMessage() + "</span>" +
                                   "</div>");
                    }
                }
            %>
        </div>
    </div>

    <script>
        // Password toggle visibility
        function togglePassword() {
            const passwordField = document.getElementById('password');
            const eyeIcon = document.getElementById('eye-icon');
            const eyeSlashIcon = document.getElementById('eye-slash-icon');
            
            if (passwordField.type === 'password') {
                passwordField.type = 'text';
                eyeIcon.style.display = 'none';
                eyeSlashIcon.style.display = 'block';
            } else {
                passwordField.type = 'password';
                eyeIcon.style.display = 'block';
                eyeSlashIcon.style.display = 'none';
            }
        }

        // Password strength meter
        document.getElementById('password').addEventListener('input', function() {
            const password = this.value;
            const strengthMeter = document.getElementById('strength-meter');
            let strength = 0;
            
            // Check for length
            if (password.length >= 8) strength += 1;
            
            // Check for numbers
            if (/\d/.test(password)) strength += 1;
            
            // Check for special characters
            if (/[!@#$%^&*(),.?":{}|<>]/.test(password)) strength += 1;
            
            // Check for uppercase letters
            if (/[A-Z]/.test(password)) strength += 1;
            
            // Update strength meter
            switch(strength) {
                case 0:
                    strengthMeter.style.width = '0%';
                    strengthMeter.style.background = 'var(--error)';
                    break;
                case 1:
                    strengthMeter.style.width = '25%';
                    strengthMeter.style.background = '#ef4444';
                    break;
                case 2:
                    strengthMeter.style.width = '50%';
                    strengthMeter.style.background = '#f59e0b';
                    break;
                case 3:
                    strengthMeter.style.width = '75%';
                    strengthMeter.style.background = '#84cc16';
                    break;
                case 4:
                    strengthMeter.style.width = '100%';
                    strengthMeter.style.background = 'var(--success)';
                    break;
            }
        });

        // Add focus effects to form inputs
        document.addEventListener('DOMContentLoaded', function() {
            const inputs = document.querySelectorAll('input');
            
            inputs.forEach(input => {
                input.addEventListener('focus', function() {
                    this.parentElement.style.boxShadow = '0 0 0 3px rgba(59, 130, 246, 0.2)';
                });
                
                input.addEventListener('blur', function() {
                    this.parentElement.style.boxShadow = 'none';
                });
            });
        });
    </script>
</body>
</html>