<?php error_reporting(0);
include('includes/config.php');
?>
<!DOCTYPE html>
<html lang="en">
    <head>
        <meta charset="utf-8">
        <title>Duck n Wash | Our Locations</title>
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <meta name="description" content="Find our convenient car wash locations. Duck n Wash brings premium car care services to multiple locations near you.">

        <!-- Favicon -->
        <link href="img/duck-logo.png" rel="icon">

        <!-- Google Font -->
        <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@300;400;500;600;700;800&family=Fredoka+One&display=swap" rel="stylesheet">
        
        <!-- CSS Libraries -->
        <link href="https://stackpath.bootstrapcdn.com/bootstrap/4.4.1/css/bootstrap.min.css" rel="stylesheet">
        <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/5.10.0/css/all.min.css" rel="stylesheet">
        <link href="lib/flaticon/font/flaticon.css" rel="stylesheet">
        <link href="lib/animate/animate.min.css" rel="stylesheet">
        <link href="lib/owlcarousel/assets/owl.carousel.min.css" rel="stylesheet">

        <!-- Template Stylesheet -->
        <link href="css/style.css" rel="stylesheet">
        
        <style>
            :root {
                --primary: #00A8E8;  /* Vibrant blue */
                --secondary: #FF6B6B; /* Coral accent */
                --accent: #FFD166;    /* Sunny yellow */
                --dark: #2D3047;      /* Navy blue */
                --light: #F7F9FC;     /* Off-white */
                --success: #06D6A0;   /* Mint green */
            }
            
            /* Page Header */
            .page-header {
                background: linear-gradient(rgba(45, 48, 71, 0.9), rgba(45, 48, 71, 0.9)), url('img/carousel-3.jpg') no-repeat center center;
                background-size: cover;
                padding: 120px 0 80px;
                color: white;
                text-align: center;
                position: relative;
            }
            
            .page-header h2 {
                font-size: 3rem;
                margin-bottom: 20px;
                text-shadow: 2px 2px 4px rgba(0,0,0,0.3);
            }
            
            .page-header .breadcrumb {
                background: transparent;
                justify-content: center;
                padding: 0;
                margin: 0;
            }
            
            .page-header .breadcrumb-item a {
                color: var(--accent);
                text-decoration: none;
                transition: all 0.3s;
            }
            
            .page-header .breadcrumb-item a:hover {
                color: white;
            }
            
            .page-header .breadcrumb-item.active {
                color: rgba(255,255,255,0.7);
            }
            
            .page-header .breadcrumb-item+.breadcrumb-item::before {
                color: rgba(255,255,255,0.5);
            }
            
            /* Location Section */
            .location {
                padding: 100px 0;
                background-color: var(--light);
                position: relative;
            }
            
            .section-header {
                margin-bottom: 60px;
                text-align: center;
            }
            
            .section-header p {
                color: var(--primary);
                font-weight: 600;
                letter-spacing: 2px;
                text-transform: uppercase;
                margin-bottom: 15px;
                font-size: 1.1rem;
            }
            
            .section-header h2 {
                position: relative;
                display: inline-block;
                padding-bottom: 15px;
                color: var(--dark);
            }
            
            .section-header h2:after {
                content: '';
                position: absolute;
                bottom: 0;
                left: 50%;
                transform: translateX(-50%);
                width: 80px;
                height: 4px;
                background: linear-gradient(90deg, var(--primary), var(--secondary));
                border-radius: 2px;
            }
            
            .location-item {
                background: white;
                border-radius: 15px;
                padding: 30px;
                margin-bottom: 30px;
                box-shadow: 0 10px 30px rgba(0,0,0,0.05);
                transition: all 0.3s;
                display: flex;
                align-items: flex-start;
                position: relative;
                overflow: hidden;
            }
            
            .location-item:before {
                content: '';
                position: absolute;
                top: 0;
                left: 0;
                width: 5px;
                height: 100%;
                background: linear-gradient(to bottom, var(--primary), var(--secondary));
                transition: all 0.3s;
            }
            
            .location-item:hover {
                transform: translateY(-5px);
                box-shadow: 0 15px 40px rgba(0,0,0,0.1);
            }
            
            .location-item:hover:before {
                width: 8px;
            }
            
            .location-item i {
                font-size: 2rem;
                color: var(--primary);
                margin-right: 20px;
                flex-shrink: 0;
                transition: all 0.3s;
            }
            
            .location-item:hover i {
                color: var(--secondary);
                transform: scale(1.1);
            }
            
            .location-text h3 {
                color: var(--dark);
                margin-bottom: 10px;
                font-weight: 700;
            }
            
            .location-text p {
                margin-bottom: 5px;
                color: #555;
            }
            
            .location-text p strong {
                color: var(--dark);
            }
            
            /* Water Drops Animation */
            .water-drops {
                position: absolute;
                width: 100%;
                height: 100%;
                top: 0;
                left: 0;
                pointer-events: none;
                z-index: 0;
            }
            
            .drop {
                position: absolute;
                background: rgba(0, 168, 232, 0.1);
                border-radius: 50%;
                animation: drop-fall linear infinite;
                opacity: 0.6;
            }
            
            @keyframes drop-fall {
                0% {
                    transform: translateY(-100px) scale(0.5);
                    opacity: 0;
                }
                10% {
                    opacity: 0.6;
                }
                90% {
                    opacity: 0.6;
                }
                100% {
                    transform: translateY(100vh) scale(1);
                    opacity: 0;
                }
            }
            
            /* Responsive Adjustments */
            @media (max-width: 991px) {
                .page-header {
                    padding: 80px 0 60px;
                }
                
                .page-header h2 {
                    font-size: 2.5rem;
                }
            }
            
            @media (max-width: 767px) {
                .page-header {
                    padding: 60px 0 40px;
                }
                
                .page-header h2 {
                    font-size: 2rem;
                }
                
                .location-item {
                    flex-direction: column;
                    align-items: flex-start;
                }
                
                .location-item i {
                    margin-right: 0;
                    margin-bottom: 15px;
                }
            }
        </style>
    </head>

    <body>
        <!-- Water Drops Animation -->
        <div class="water-drops" id="waterDrops"></div>

        <?php include_once('includes/header.php');?>
        
        <!-- Page Header Start -->
        <div class="page-header">
            <div class="container">
                <div class="row">
                    <div class="col-12">
                        <h2>Our Washing Points</h2>
                    </div>
                    <div class="col-12">
                        <nav aria-label="breadcrumb">
                            <ol class="breadcrumb justify-content-center">
                                <li class="breadcrumb-item"><a href="index.php">Home</a></li>
                                <li class="breadcrumb-item active" aria-current="page">Locations</li>
                            </ol>
                        </nav>
                    </div>
                </div>
            </div>
        </div>
        <!-- Page Header End -->
        
        <!-- Location Section Start -->
        <div class="location">
            <div class="container">
                <div class="row">
                    <div class="col-lg-12">
                        <div class="section-header text-center">
                            <p>Our Locations</p>
                            <h2>Find A Washing Point Near You</h2>
                        </div>
                        <div class="row">
                            <?php 
                            $sql = "SELECT * from tblwashingpoints";
                            $query = $dbh->prepare($sql);
                            $query->execute();
                            $results=$query->fetchAll(PDO::FETCH_OBJ);
                            foreach($results as $result) { ?>  
                            <div class="col-lg-6 col-md-6">
                                <div class="location-item">
                                    <i class="fa fa-map-marker-alt"></i>
                                    <div class="location-text">
                                        <h3><?php echo htmlentities($result->washingPointName);?></h3>
                                        <p><?php echo htmlentities($result->washingPointAddress);?></p>
                                        <p><strong>Call:</strong> <?php echo htmlentities($result->contactNumber);?></p>
                                        <p><strong>Hours:</strong> 8:00 AM - 8:00 PM Daily</p>
                                    </div>
                                </div>
                            </div>
                            <?php } ?>
                        </div>
                    </div>
                </div>
            </div>
        </div>
        <!-- Location Section End -->
        
        <?php include_once('includes/footer.php');?>

        <!-- JavaScript Libraries -->
        <script src="https://code.jquery.com/jquery-3.4.1.min.js"></script>
        <script src="https://stackpath.bootstrapcdn.com/bootstrap/4.4.1/js/bootstrap.bundle.min.js"></script>
        <script src="lib/easing/easing.min.js"></script>
        <script src="lib/owlcarousel/owl.carousel.min.js"></script>
        <script src="lib/waypoints/waypoints.min.js"></script>
        <script src="lib/counterup/counterup.min.js"></script>
        
        <!-- Contact Javascript File -->
        <script src="mail/jqBootstrapValidation.min.js"></script>
        <script src="mail/contact.js"></script>

        <!-- Template Javascript -->
        <script src="js/main.js"></script>
        
        <script>
            // Create water drops dynamically
            $(document).ready(function(){
                const container = $('.water-drops');
                const dropCount = 15;
                
                for(let i = 0; i < dropCount; i++) {
                    const drop = $('<div class="drop"></div>');
                    
                    // Random size between 5 and 15px
                    const size = Math.random() * 10 + 5;
                    drop.css({
                        width: `${size}px`,
                        height: `${size}px`,
                        left: `${Math.random() * 100}%`,
                        animationDuration: `${Math.random() * 5 + 5}s`,
                        animationDelay: `${Math.random() * 5}s`
                    });
                    
                    container.append(drop);
                }
                
                // Smooth scrolling for anchor links
                $('a[href*="#"]').on('click', function(e) {
                    e.preventDefault();
                    $('html, body').animate(
                        {
                            scrollTop: $($(this).attr('href')).offset().top - 70,
                        },
                        500,
                        'linear'
                    );
                });
            });
        </script>
    </body>
</html>