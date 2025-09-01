<!-- Top Bar Start -->
<div class="top-header">
    <div class="container">
        <div class="header-content">
            <!-- Logo with animated duck -->
            <div class="logo-container">
                <a href="index.php" class="logo" id="logo-click">
                    <div class="logo-duck">
                        <img src="img/logo.jpg" alt="Duck n Wash Logo" class="duck-icon">
                    </div>
                    <h1 class="logo-text">Duck n <span>Wash</span></h1>
                </a>
            </div>

            <?php 
            $sql = "SELECT * from tblpages where type='contact'";
            $query = $dbh->prepare($sql);
            $query->execute();
            $results=$query->fetchAll(PDO::FETCH_OBJ);
            foreach($results as $result) {       
            ?>
            <!-- Contact Info -->
            <div class="header-contact-info">
                <div class="contact-item">
                    <div class="contact-icon">
                        <i class="far fa-clock"></i>
                    </div>
                    <div class="contact-details">
                        <h4>Opening Hours</h4>
                        <p><?php echo htmlspecialchars($result->openignHrs); ?></p>
                    </div>
                </div>
                
                <div class="contact-item">
                    <div class="contact-icon">
                        <i class="fa fa-phone-alt"></i>
                    </div>
                    <div class="contact-details">
                        <h4>Call Us</h4>
                        <p>+<?php echo htmlspecialchars($result->phoneNumber); ?></p>
                    </div>
                </div>
                
                <div class="contact-item">
                    <div class="contact-icon">
                        <i class="far fa-envelope"></i>
                    </div>
                    <div class="contact-details">
                        <h4>Email Us</h4>
                        <p><?php echo htmlspecialchars($result->emailId); ?></p>
                    </div>
                </div>
            </div>
            <?php } ?>
            
            <!-- Appointment Button - Visible on mobile -->
            <div class="mobile-appointment">
                <a href="contact.php" class="btn btn-appointment">
                    <i class="fa fa-calendar-alt"></i>
                </a>
            </div>
        </div>
    </div>
</div>
<!-- Top Bar End -->

<!-- Navigation Bar Start -->
<nav class="main-navbar">
    <div class="container">
        <div class="navbar-container">
            <!-- Mobile Menu Toggle -->
            <button class="navbar-toggler" aria-label="Menu">
                <span class="toggler-icon"></span>
                <span class="toggler-icon"></span>
                <span class="toggler-icon"></span>
            </button>

            <!-- Main Navigation -->
            <div class="navbar-menu">
                <ul class="nav-list">
                    <li class="nav-item"><a href="index.php" class="nav-link active">Home</a></li>
                    <li class="nav-item"><a href="about.php" class="nav-link">About</a></li>
                    <li class="nav-item"><a href="washing-plans.php" class="nav-link">Washing Plans</a></li>
                    <li class="nav-item"><a href="location.php" class="nav-link">Locations</a></li>
                    <li class="nav-item"><a href="contact.php" class="nav-link">Contact</a></li>
                </ul>
                
                <!-- Appointment Button - Desktop -->
                <div class="nav-appointment">
                    <a href="contact.php" class="btn btn-appointment">
                        <i class="fa fa-calendar-alt"></i> Get Appointment
                    </a>
                </div>
            </div>
        </div>
    </div>
</nav>
<!-- Navigation Bar End -->

<style>
    /* Header Styles */
    .top-header {
        background-color: var(--dark);
        color: white;
        padding: 15px 0;
        position: relative;
        z-index: 1000;
    }
    
    .header-content {
        display: flex;
        align-items: center;
        justify-content: space-between;
        flex-wrap: wrap;
    }
    
    /* Logo Styles */
    .logo-container {
        display: flex;
        align-items: center;
    }
    
    .logo {
        display: flex;
        align-items: center;
        text-decoration: none;
        transition: all 0.3s ease;
    }
    
    .logo:hover {
        transform: translateY(-2px);
    }
    
    .logo-duck {
        margin-right: 15px;
        animation: duckFloat 4s ease-in-out infinite;
    }
    
    .duck-icon {
        height: 50px;
        transition: all 0.3s ease;
    }
    
    .logo:hover .duck-icon {
        transform: rotate(-10deg);
    }
    
    .logo-text {
        font-family: 'Fredoka One', cursive;
        color: white;
        font-size: 1.8rem;
        margin: 0;
        transition: all 0.3s ease;
    }
    
    .logo-text span {
        color: var(--accent);
    }
    
    /* Contact Info Styles */
    .header-contact-info {
        display: flex;
        gap: 30px;
    }
    
    .contact-item {
        display: flex;
        align-items: center;
        gap: 15px;
    }
    
    .contact-icon {
        width: 40px;
        height: 40px;
        background: rgba(255,255,255,0.1);
        border-radius: 50%;
        display: flex;
        align-items: center;
        justify-content: center;
        color: var(--accent);
        font-size: 1.1rem;
    }
    
    .contact-details h4 {
        font-size: 0.9rem;
        margin: 0;
        color: var(--accent);
        font-weight: 600;
    }
    
    .contact-details p {
        font-size: 0.9rem;
        margin: 0;
        color: rgba(255,255,255,0.8);
    }
    
    /* Navigation Styles */
    .main-navbar {
        background: linear-gradient(135deg, var(--primary) 0%, var(--secondary) 100%);
        box-shadow: 0 5px 20px rgba(0,0,0,0.1);
        position: sticky;
        top: 0;
        z-index: 999;
    }
    
    .navbar-container {
        display: flex;
        justify-content: space-between;
        align-items: center;
        padding: 10px 0;
    }
    
    .navbar-toggler {
        background: transparent;
        border: none;
        padding: 10px;
        display: none;
        flex-direction: column;
        justify-content: space-between;
        height: 30px;
        cursor: pointer;
    }
    
    .toggler-icon {
        display: block;
        width: 25px;
        height: 3px;
        background: white;
        border-radius: 3px;
        transition: all 0.3s ease;
    }
    
    .navbar-menu {
        display: flex;
        align-items: center;
    }
    
    .nav-list {
        display: flex;
        list-style: none;
        margin: 0;
        padding: 0;
    }
    
    .nav-item {
        position: relative;
    }
    
    .nav-link {
        color: white;
        text-decoration: none;
        font-weight: 500;
        padding: 15px 20px;
        display: block;
        transition: all 0.3s ease;
        position: relative;
    }
    
    .nav-link:hover, .nav-link.active {
        color: var(--accent);
    }
    
    .nav-link.active:after {
        content: '';
        position: absolute;
        bottom: 0;
        left: 20px;
        right: 20px;
        height: 3px;
        background: var(--accent);
        border-radius: 3px 3px 0 0;
    }
    
    /* Appointment Button */
    .btn-appointment {
        background: var(--accent);
        color: var(--dark);
        border: none;
        padding: 10px 20px;
        border-radius: 50px;
        font-weight: 600;
        text-transform: uppercase;
        font-size: 0.9rem;
        display: inline-flex;
        align-items: center;
        gap: 8px;
        transition: all 0.3s ease;
        box-shadow: 0 4px 15px rgba(255, 209, 102, 0.3);
    }
    
    .btn-appointment:hover {
        background: white;
        transform: translateY(-3px);
        box-shadow: 0 8px 25px rgba(255, 209, 102, 0.4);
    }
    
    .nav-appointment {
        margin-left: 30px;
    }
    
    .mobile-appointment {
        display: none;
    }
    
    /* Animations */
    @keyframes duckFloat {
        0% { transform: translateY(0px) rotate(0deg); }
        50% { transform: translateY(-10px) rotate(5deg); }
        100% { transform: translateY(0px) rotate(0deg); }
    }
    
    /* Admin Access Easter Egg */
    #logo-click {
        transition: all 0.3s ease;
    }
    
    /* Responsive Styles */
    @media (max-width: 1199px) {
        .header-contact-info {
            gap: 20px;
        }
    }
    
    @media (max-width: 991px) {
        .header-contact-info {
            display: none;
        }
        
        .mobile-appointment {
            display: block;
        }
        
        .btn-appointment span {
            display: none;
        }
    }
    
    @media (max-width: 767px) {
        .navbar-toggler {
            display: flex;
        }
        
        .navbar-menu {
            position: fixed;
            top: 0;
            left: -100%;
            width: 80%;
            max-width: 300px;
            height: 100vh;
            background: var(--dark);
            flex-direction: column;
            justify-content: flex-start;
            padding: 80px 20px 20px;
            transition: all 0.3s ease;
            z-index: 1000;
        }
        
        .navbar-menu.active {
            left: 0;
        }
        
        .nav-list {
            flex-direction: column;
            width: 100%;
        }
        
        .nav-item {
            width: 100%;
        }
        
        .nav-link {
            padding: 15px;
            border-bottom: 1px solid rgba(255,255,255,0.1);
        }
        
        .nav-appointment {
            margin: 20px 0 0;
            width: 100%;
        }
        
        .btn-appointment {
            width: 100%;
            justify-content: center;
        }
        
        .btn-appointment span {
            display: inline;
        }
    }
</style>

<script>
    // Mobile Menu Toggle
    document.querySelector('.navbar-toggler').addEventListener('click', function() {
        document.querySelector('.navbar-menu').classList.toggle('active');
    });
    
    // Close menu when clicking outside
    document.addEventListener('click', function(event) {
        const navbar = document.querySelector('.navbar-menu');
        const toggler = document.querySelector('.navbar-toggler');
        
        if (!navbar.contains(event.target) && !toggler.contains(event.target)) {
            navbar.classList.remove('active');
        }
    });
    
    // Admin Easter Egg
    let clickCount = 0;
    const logo = document.getElementById('logo-click');
    const logoText = document.querySelector('.logo-text');
    const resetTimer = 3000; // 3 seconds to click 5 times
    
    logo.addEventListener('click', function(e) {
        e.preventDefault(); // Prevent default link behavior
        
        clickCount++;
        
        // Increase logo size with each click (up to 5 clicks)
        const scaleFactor = 1 + (clickCount * 0.15);
        logoText.style.transform = `scale(${scaleFactor})`;
        
        // Reset counter and size if too much time passes between clicks
        if (clickCount === 1) {
            setTimeout(() => {
                clickCount = 0;
                logoText.style.transform = 'scale(1)';
            }, resetTimer);
        }
        
        // If reached 5 clicks, go to admin
        if (clickCount >= 5) {
            // Add a fun effect before redirecting
            logoText.style.transition = 'all 0.5s ease';
            logoText.style.transform = 'scale(1.5) rotate(360deg)';
            setTimeout(() => {
                window.location.href = 'admin';
            }, 500);
        }
    });
</script>