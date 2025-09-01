<?php
// Error reporting control
error_reporting(E_ALL & ~E_WARNING);
ini_set('display_errors', 0);

session_start();
require_once 'includes/config.php';

// Initialize error variable
$error = '';

if(isset($_POST['login'])) {
    $uname = trim($_POST['username']);
    $password = $_POST['password'];
    
    // Basic input validation
    if(empty($uname) || empty($password)) {
        $error = 'Both username and password are required.';
    } else {
        // Use prepared statement to prevent SQL injection
        $sql = "SELECT UserName, Password FROM admin WHERE UserName = :uname";
        $query = $dbh->prepare($sql);
        $query->bindParam(':uname', $uname, PDO::PARAM_STR);
        $query->execute();
        
        if($query->rowCount() == 1) {
            $result = $query->fetch(PDO::FETCH_OBJ);
            
            // Verify password (using MD5 for compatibility with existing system)
            if(md5($password) === $result->Password) {
                $_SESSION['alogin'] = $uname;
                session_regenerate_id(true); // Security measure
                header("Location: dashboard.php");
                exit();
            } else {
                $error = 'Invalid username or password.';
            }
        } else {
            $error = 'Invalid username or password.';
        }
    }
}
?>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Login - CWMS Admin</title>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
    <link href="css/bootstrap.min.css" rel='stylesheet' type='text/css' />
    <style>
        :root {
            --primary-color: #4fc3f7;
            --secondary-color: #0288d1;
            --accent-color: #ffeb3b;
            --light-color: #e1f5fe;
            --dark-color: #01579b;
            --success-color: #4caf50;
            --warning-color: #ff9800;
            --danger-color: #f44336;
        }
        
        body {
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
            background: linear-gradient(135deg, #87CEEB 0%, #1E88E5 100%);
            margin: 0;
            padding: 0;
            display: flex;
            justify-content: center;
            align-items: center;
            min-height: 100vh;
            color: #fff;
            background-image: url('data:image/svg+xml;utf8,<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 100 100" preserveAspectRatio="none"><circle cx="20" cy="20" r="3" fill="rgba(255,255,255,0.3)"/><circle cx="40" cy="70" r="2" fill="rgba(255,255,255,0.3)"/><circle cx="70" cy="30" r="4" fill="rgba(255,255,255,0.3)"/><circle cx="80" cy="80" r="3" fill="rgba(255,255,255,0.3)"/></svg>'), 
                              linear-gradient(135deg, #87CEEB 0%, #1E88E5 100%);
            background-size: 200px 200px, cover;
        }
        
        .auth-container {
            width: 100%;
            max-width: 1200px;
            padding: 20px;
            animation: fadeIn 0.5s ease-in-out;
        }
        
        .auth-box {
            background: rgba(255, 255, 255, 0.9);
            border-radius: 15px;
            box-shadow: 0 15px 35px rgba(0, 0, 0, 0.2);
            padding: 40px;
            width: 100%;
            max-width: 450px;
            margin: 0 auto;
            transition: all 0.3s ease;
            backdrop-filter: blur(5px);
            border: 1px solid rgba(255, 255, 255, 0.3);
        }
        
        .auth-box:hover {
            transform: translateY(-5px);
            box-shadow: 0 20px 40px rgba(0, 0, 0, 0.25);
        }
        
        .auth-box h1 {
            color: var(--dark-color);
            text-align: center;
            margin-bottom: 30px;
            font-size: 32px;
            font-weight: 700;
            text-shadow: 1px 1px 2px rgba(0,0,0,0.1);
        }
        
        .form-group {
            margin-bottom: 25px;
        }
        
        .form-group label {
            display: block;
            margin-bottom: 10px;
            font-weight: 600;
            color: var(--dark-color);
            font-size: 16px;
        }
        
        .form-group input {
            width: 100%;
            padding: 14px 20px;
            border: 2px solid #ddd;
            border-radius: 8px;
            font-size: 16px;
            transition: all 0.3s;
            background-color: rgba(255,255,255,0.8);
            color: #000; /* Black text for input fields */
        }
        
        .form-group input::placeholder {
            color: #666; /* Dark gray placeholder text */
        }
        
        .form-group input:focus {
            border-color: var(--primary-color);
            outline: none;
            box-shadow: 0 0 0 4px rgba(79, 195, 247, 0.3);
            background-color: white;
        }
        
        .btn {
            display: inline-block;
            background: var(--dark-color);
            color: white;
            border: none;
            padding: 15px 25px;
            border-radius: 8px;
            cursor: pointer;
            font-size: 18px;
            font-weight: 600;
            width: 100%;
            transition: all 0.3s;
            box-shadow: 0 4px 6px rgba(0,0,0,0.1);
        }
        
        .btn:hover {
            background: var(--secondary-color);
            transform: translateY(-3px);
            box-shadow: 0 6px 12px rgba(0,0,0,0.15);
        }
        
        .btn:active {
            transform: translateY(1px);
        }
        
        .auth-links {
            display: flex;
            justify-content: space-between;
            margin-top: 25px;
            font-size: 15px;
        }
        
        .auth-links a {
            color: var(--dark-color);
            text-decoration: none;
            transition: all 0.3s;
            font-weight: 500;
        }
        
        .auth-links a:hover {
            color: var(--secondary-color);
            text-decoration: underline;
        }
        
        .alert {
            padding: 15px 20px;
            margin-bottom: 25px;
            border-radius: 8px;
            font-size: 15px;
        }
        
        .alert-danger {
            background-color: rgba(244, 67, 54, 0.1);
            color: var(--danger-color);
            border-left: 4px solid var(--danger-color);
        }
        
        .logo {
            text-align: center;
            margin-bottom: 20px;
        }
        
        .logo img {
            max-width: 150px;
            height: auto;
            margin-bottom: 15px;
        }
        
        .logo h2 {
            color: var(--dark-color);
            font-size: 28px;
            margin-bottom: 5px;
        }
        
        .logo p {
            color: var(--secondary-color);
            font-size: 16px;
            font-weight: 500;
        }
        
        .admin-notice {
            background-color: rgba(2, 136, 209, 0.1);
            color: var(--secondary-color);
            border-left: 4px solid var(--secondary-color);
            padding: 12px 15px;
            margin-bottom: 20px;
            border-radius: 6px;
            font-size: 14px;
        }
        
        @media (max-width: 480px) {
            .auth-box {
                padding: 30px 20px;
                max-width: 90%;
            }
            
            .logo img {
                max-width: 120px;
            }
            
            .auth-links {
                flex-direction: column;
                align-items: center;
                gap: 10px;
            }
        }
        
        @keyframes fadeIn {
            from { opacity: 0; transform: translateY(20px); }
            to { opacity: 1; transform: translateY(0); }
        }
        
        .bubble {
            position: absolute;
            background: rgba(255, 255, 255, 0.2);
            border-radius: 50%;
            animation: float 15s infinite ease-in-out;
            z-index: -1;
        }
        
        @keyframes float {
            0%, 100% { transform: translateY(0) rotate(0deg); }
            50% { transform: translateY(-20px) rotate(5deg); }
        }
    </style>
</head>
<body>
    <!-- Background bubbles -->
    <div class="bubble" style="width: 100px; height: 100px; top: 10%; left: 10%;"></div>
    <div class="bubble" style="width: 150px; height: 150px; top: 60%; left: 80%;"></div>
    <div class="bubble" style="width: 70px; height: 70px; top: 80%; left: 20%;"></div>
    
    <div class="auth-container">
        <div class="auth-box">
            <div class="logo">
                <!-- Replace 'logo.png' with your actual logo file path -->
                <img src="images/logo.jpg" alt="CWMS Logo">
                
                <p>Admin Portal</p>
            </div>
            <h1>Admin Login</h1>
            
            <div class="admin-notice">
                <i class="fas fa-lock"></i> Restricted access to authorized personnel only.
            </div>
            
            <?php if(!empty($error)): ?>
                <div class="alert alert-danger">
                    <i class="fas fa-exclamation-circle"></i> <?php echo htmlspecialchars($error); ?>
                </div>
            <?php endif; ?>
            
            <form method="post">
                <div class="form-group">
                    <label for="username">Username</label>
                    <input type="text" name="username" id="username" required autofocus placeholder="Enter your username">
                </div>
                
                <div class="form-group">
                    <label for="password">Password</label>
                    <input type="password" name="password" id="password" required placeholder="Enter your password">
                </div>
                
                <div class="form-group">
                    <button type="submit" name="login" class="btn">Login <i class="fas fa-sign-in-alt"></i></button>
                </div>
                
                <div class="auth-links">
                    <a href="../index.php"><i class="fas fa-home"></i> Back to Home</a>
                </div>
            </form>
        </div>
    </div>

    <script>
        // Add more dynamic bubbles
        document.addEventListener('DOMContentLoaded', function() {
            const body = document.body;
            for (let i = 0; i < 5; i++) {
                const bubble = document.createElement('div');
                bubble.className = 'bubble';
                const size = Math.random() * 100 + 50;
                const left = Math.random() * 100;
                const top = Math.random() * 100;
                const delay = Math.random() * 10;
                const duration = Math.random() * 10 + 10;
                
                bubble.style.width = `${size}px`;
                bubble.style.height = `${size}px`;
                bubble.style.left = `${left}%`;
                bubble.style.top = `${top}%`;
                bubble.style.animationDelay = `${delay}s`;
                bubble.style.animationDuration = `${duration}s`;
                
                body.appendChild(bubble);
            }
        });
    </script>
</body>
</html>