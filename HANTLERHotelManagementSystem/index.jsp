<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Hantler | Hotel Reservation</title>
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link href="https://fonts.googleapis.com/css2?family=Montserrat:wght@300;400;500;600;700&family=Playfair+Display:wght@400;500;600;700&display=swap" rel="stylesheet">
    <style>
        /* Modern Reset with Smooth Scrolling */
        :root {
            --primary: #2c3e50;
            --secondary: #3498db;
            --accent: #e74c3c;
            --light: #ecf0f1;
            --dark: #2c3e50;
            --text: #2d3748;
            --text-light: #718096;
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
            font-family: 'Montserrat', -apple-system, BlinkMacSystemFont, 'Segoe UI', Roboto, Oxygen, Ubuntu, Cantarell, sans-serif;
            color: var(--text);
            min-height: 100vh;
            display: flex;
            flex-direction: column;
            background-image: url('https://images.unsplash.com/photo-1566073771259-6a8506099945?ixlib=rb-1.2.1&auto=format&fit=crop&w=1350&q=80');
            background-size: cover;
            background-position: center;
            background-repeat: no-repeat;
            background-attachment: fixed;
            line-height: 1.6;
        }

        /* Overlay for better text readability */
        body::before {
            content: '';
            position: absolute;
            top: 0;
            left: 0;
            right: 0;
            bottom: 0;
            background: linear-gradient(135deg, rgba(44, 62, 80, 0.8) 0%, rgba(0, 0, 0, 0.6) 100%);
            z-index: -1;
        }

        /* Navigation Bar - Top */
        .navbar {
            background: rgba(255, 255, 255, 0.1);
            color: white;
            padding: 1rem 2rem;
            display: flex;
            justify-content: space-between;
            align-items: center;
            box-shadow: 0 2px 20px rgba(0, 0, 0, 0.2);
            position: sticky;
            top: 0;
            z-index: 100;
            backdrop-filter: blur(10px);
            border-bottom: 1px solid rgba(255, 255, 255, 0.1);
        }

        .nav-brand {
            font-family: 'Playfair Display', serif;
            font-size: 1.8rem;
            font-weight: 700;
            color: white;
            text-decoration: none;
            letter-spacing: 1px;
            cursor: pointer;
            transition: transform 0.3s ease;
        }

        .nav-brand:hover {
            transform: scale(1.05);
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
            text-shadow: 0 0 5px rgba(255, 255, 255, 0.5);
        }

        .nav-link::after {
            content: '';
            position: absolute;
            bottom: 0;
            left: 0;
            width: 0;
            height: 2px;
            background: var(--secondary);
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
            background: var(--secondary);
        }

        /* Main Content Container */
        .main-container {
            flex: 1;
            padding: 2rem;
            max-width: 1200px;
            margin: 0 auto;
            width: 100%;
            display: flex;
            align-items: center;
            justify-content: center;
        }

        /* Card Design */
        .card {
            background: rgba(255, 255, 255, 0.95);
            border-radius: 16px;
            box-shadow: 0 15px 40px rgba(0, 0, 0, 0.3);
            padding: 3.5rem;
            margin: 2rem auto;
            transition: transform 0.4s ease, box-shadow 0.4s ease;
            border: 1px solid rgba(255, 255, 255, 0.2);
            max-width: 550px;
            width: 100%;
            text-align: center;
            backdrop-filter: blur(5px);
            animation: fadeInUp 0.8s ease-out;
            position: relative;
            overflow: hidden;
        }

        .card::before {
            content: '';
            position: absolute;
            top: -50%;
            left: -50%;
            width: 200%;
            height: 200%;
            background: linear-gradient(
                to bottom right,
                rgba(255, 255, 255, 0.1) 0%,
                rgba(255, 255, 255, 0) 50%,
                rgba(255, 255, 255, 0.1) 100%
            );
            transform: rotate(30deg);
            pointer-events: none;
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

        /* Typography */
        h1, h2, h3 {
            color: var(--dark);
            margin-bottom: 1.5rem;
            font-weight: 700;
            font-family: 'Playfair Display', serif;
        }

        h1 {
            font-size: 2.5rem;
            line-height: 1.2;
            letter-spacing: 0.5px;
        }

        p {
            line-height: 1.7;
            color: var(--text-light);
            margin-bottom: 2rem;
            font-size: 1.05rem;
        }

        .subtitle {
            color: var(--text-light);
            font-size: 1.1rem;
            margin-bottom: 2.5rem;
            font-weight: 300;
            letter-spacing: 0.5px;
        }

        /* Buttons */
        .btn {
            background: var(--secondary);
            color: white;
            border: none;
            padding: 1rem 1.8rem;
            border-radius: 50px;
            font-size: 1rem;
            font-weight: 600;
            cursor: pointer;
            transition: all 0.3s cubic-bezier(0.25, 0.8, 0.25, 1);
            text-align: center;
            display: inline-block;
            text-decoration: none;
            margin: 0.75rem;
            width: 220px;
            letter-spacing: 0.5px;
            text-transform: uppercase;
            box-shadow: 0 4px 15px rgba(52, 152, 219, 0.3);
            position: relative;
            overflow: hidden;
        }

        .btn::before {
            content: '';
            position: absolute;
            top: 0;
            left: -100%;
            width: 100%;
            height: 100%;
            background: linear-gradient(90deg, transparent, rgba(255, 255, 255, 0.2), transparent);
            transition: 0.5s;
        }

        .btn:hover::before {
            left: 100%;
        }

        .btn:hover {
            transform: translateY(-3px);
            box-shadow: 0 8px 25px rgba(52, 152, 219, 0.4);
        }

        .btn:active {
            transform: translateY(-1px);
        }

        .btn-primary {
            background: var(--secondary);
        }

        .btn-secondary {
            background: var(--primary);
            box-shadow: 0 4px 15px rgba(44, 62, 80, 0.3);
        }

        .btn-secondary:hover {
            box-shadow: 0 8px 25px rgba(44, 62, 80, 0.4);
        }

        .btn-block {
            width: 100%;
            padding: 1rem;
            font-size: 1rem;
            margin: 0.75rem 0;
        }

        .button-group {
            display: flex;
            flex-direction: column;
            align-items: center;
            margin-top: 2.5rem;
        }

        /* Responsive Design */
        @media (max-width: 768px) {
            .navbar {
                flex-direction: column;
                padding: 1.2rem;
            }
        
            .nav-links {
                margin-top: 1.2rem;
                flex-wrap: wrap;
                justify-content: center;
                gap: 1rem;
            }
            
            .card {
                padding: 2.5rem 1.8rem;
                margin: 1.5rem;
            }
            
            .main-container {
                padding: 1.5rem;
            }

            h1 {
                font-size: 2rem;
            }

            .btn {
                width: 100%;
                margin: 0.75rem 0;
                padding: 1rem;
            }
        }

        @media (max-width: 480px) {
            .card {
                padding: 2rem 1.5rem;
            }
            
            h1 {
                font-size: 1.8rem;
            }
            
            .subtitle {
                font-size: 1rem;
            }
        }
    </style>
</head>
<body>
    <nav class="navbar">
        <a id="hotelTitle" href="index.jsp" class="nav-brand">Hantler</a>
        <div class="nav-links">
            <a href="index.jsp" class="nav-link active">Home</a>
            <a href="login.jsp" class="nav-link">Guest Login</a>
            <a href="register.jsp" class="nav-link">Register</a>
        </div>
    </nav>
    
    <div class="main-container">
        <div class="card">
            <h1>Experience Unparalleled Luxury</h1>
            <p class="subtitle">Your perfect getaway starts here. Book now for exclusive offers and premium accommodations.</p>
            
            <div class="button-group">
                <a href="register.jsp" class="btn btn-primary">Create Account</a>
                <a href="login.jsp" class="btn btn-secondary">Guest Login</a>
            </div>
        </div>
    </div>

    <script>
        // Add some subtle animations
        document.addEventListener('DOMContentLoaded', function() {
            const buttons = document.querySelectorAll('.btn');
            
            buttons.forEach(button => {
                button.addEventListener('mousemove', function(e) {
                    const x = e.pageX - this.offsetLeft;
                    const y = e.pageY - this.offsetTop;
                    
                    this.style.setProperty('--x', x + 'px');
                    this.style.setProperty('--y', y + 'px');
                });
            });
            
            // Secret admin access by clicking hotel title 3 times
            const hotelTitle = document.getElementById('hotelTitle');
            let clickCount = 0;
            let lastClickTime = 0;
            
            hotelTitle.addEventListener('click', function(e) {
                e.preventDefault();
                const currentTime = new Date().getTime();
                
                // Reset count if more than 1 second between clicks
                if (currentTime - lastClickTime > 1000) {
                    clickCount = 0;
                }
                
                clickCount++;
                lastClickTime = currentTime;
                
                // Visual feedback
                if (clickCount === 1) {
                    this.style.transform = 'scale(1.1) rotate(-2deg)';
                } else if (clickCount === 2) {
                    this.style.transform = 'scale(1.2) rotate(2deg)';
                } else if (clickCount >= 3) {
                    this.style.transform = 'scale(1)';
                    this.style.color = '#e74c3c';
                    setTimeout(() => {
                        this.style.color = 'white';
                    }, 500);
                    
                    // Redirect to admin after 3 quick clicks
                    if (clickCount === 3) {
                        const confirmAdmin = confirm("Admin access granted. Proceed to admin login?");
                        if (confirmAdmin) {
                            window.location.href = "admin_login.jsp";
                        } else {
                            clickCount = 0;
                        }
                    }
                }
                
                // Reset animation after 1 second
                setTimeout(() => {
                    if (clickCount < 3) {
                        this.style.transform = 'scale(1)';
                    }
                }, 1000);
            });
        });
    </script>
</body>
</html>