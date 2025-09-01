<?php //error_reporting(0);
include('includes/config.php');
?>

<!DOCTYPE html>
<html lang="en">
    <head>
        <meta charset="utf-8">
        <title>About Duck n Wash | Premium Mobile Car Detailing Services</title>
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <meta name="description" content="Learn about Duck n Wash - revolutionizing car care with our mobile washing and detailing services that come to your location.">

        <!-- Favicon -->
        <link href="img/logo.png" rel="icon">

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
                background: linear-gradient(rgba(45, 48, 71, 0.9), rgba(45, 48, 71, 0.9)), url('img/carousel-2.jpg') no-repeat center center;
                background-size: cover;
                padding: 120px 0 80px;
                color: white;
                text-align: center;
                position: relative;
                overflow: hidden;
            }
            
            .page-header h2 {
                font-size: 3.5rem;
                margin-bottom: 20px;
                text-shadow: 2px 2px 4px rgba(0,0,0,0.3);
                animation: fadeInDown 1s ease;
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
            
            /* About Section */
            .about-section {
                padding: 100px 0;
                position: relative;
            }
            
            .about-content {
                position: relative;
                z-index: 1;
            }
            
            .about-img {
                border-radius: 20px;
                overflow: hidden;
                box-shadow: 0 20px 40px rgba(0,0,0,0.1);
                transform: perspective(1000px) rotateY(-5deg);
                transition: all 0.5s cubic-bezier(0.175, 0.885, 0.32, 1.275);
                border: 10px solid white;
            }
            
            .about-img:hover {
                transform: perspective(1000px) rotateY(0deg);
            }
            
            .about-img img {
                width: 100%;
                height: auto;
                transition: all 0.5s ease;
            }
            
            .section-header {
                margin-bottom: 50px;
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
                left: 0;
                width: 80px;
                height: 4px;
                background: linear-gradient(90deg, var(--primary), var(--secondary));
                border-radius: 2px;
            }
            
            .about-features {
                margin-top: 40px;
            }
            
            .about-features ul {
                list-style: none;
                padding: 0;
                display: grid;
                grid-template-columns: repeat(2, 1fr);
                gap: 15px;
            }
            
            .about-features li {
                position: relative;
                padding-left: 35px;
                margin-bottom: 15px;
                font-size: 1.1rem;
            }
            
            .about-features i {
                position: absolute;
                left: 0;
                top: 3px;
                color: var(--primary);
                font-size: 1.3rem;
                transition: all 0.3s;
            }
            
            .about-features li:hover i {
                color: var(--secondary);
                transform: scale(1.2);
            }
            
            /* Team Section */
            .team-section {
                padding: 80px 0;
                background: var(--light);
            }
            
            .team-member {
                background: white;
                border-radius: 15px;
                overflow: hidden;
                box-shadow: 0 10px 30px rgba(0,0,0,0.05);
                margin-bottom: 30px;
                transition: all 0.3s;
            }
            
            .team-member:hover {
                transform: translateY(-10px);
                box-shadow: 0 15px 40px rgba(0,0,0,0.1);
            }
            
            .team-img {
                position: relative;
                overflow: hidden;
            }
            
            .team-img img {
                width: 100%;
                height: auto;
                transition: all 0.5s;
            }
            
            .team-member:hover .team-img img {
                transform: scale(1.05);
            }
            
            .team-social {
                position: absolute;
                bottom: -50px;
                left: 0;
                width: 100%;
                background: rgba(0, 168, 232, 0.8);
                padding: 15px;
                text-align: center;
                transition: all 0.3s;
            }
            
            .team-member:hover .team-social {
                bottom: 0;
            }
            
            .team-social a {
                display: inline-block;
                width: 35px;
                height: 35px;
                line-height: 35px;
                text-align: center;
                background: white;
                color: var(--primary);
                border-radius: 50%;
                margin: 0 5px;
                transition: all 0.3s;
            }
            
            .team-social a:hover {
                background: var(--accent);
                color: var(--dark);
                transform: translateY(-3px);
            }
            
            .team-info {
                padding: 20px;
                text-align: center;
            }
            
            .team-info h4 {
                margin-bottom: 5px;
                color: var(--dark);
            }
            
            .team-info p {
                color: var(--primary);
                font-weight: 500;
                margin-bottom: 0;
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
                overflow: hidden;
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
                
                .about-features ul {
                    grid-template-columns: 1fr;
                }
            }
            
            @media (max-width: 767px) {
                .page-header {
                    padding: 60px 0 40px;
                }
                
                .page-header h2 {
                    font-size: 2rem;
                }
                
                .about-img {
                    margin-bottom: 30px;
                    transform: perspective(1000px) rotateY(0deg);
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
                        <h2>About Duck n Wash</h2>
                    </div>
                    <div class="col-12">
                        <nav aria-label="breadcrumb">
                            <ol class="breadcrumb justify-content-center">
                                <li class="breadcrumb-item"><a href="index.php">Home</a></li>
                                <li class="breadcrumb-item active" aria-current="page">About Us</li>
                            </ol>
                        </nav>
                    </div>
                </div>
            </div>
        </div>
        <!-- Page Header End -->
        

        <!-- About Section Start -->
        <div class="about-section">
            <div class="container">
                <div class="row align-items-center">
                    <div class="col-lg-6">
                        <div class="about-img">
                            <img src="img/about.jpg" alt="Duck n Wash Team" class="img-fluid">
                        </div>
                    </div>
                    <div class="col-lg-6">
                        <div class="section-header text-left">
                            <p>Our Story</p>
                            <h2>Revolutionizing Car Care</h2>
                        </div>
                        <div class="about-content">
                            <?php 
                            $sql = "SELECT type,detail from tblpages where type='aboutus'";
                            $query = $dbh->prepare($sql);
                            $query->execute();
                            $results=$query->fetchAll(PDO::FETCH_OBJ);
                            foreach($results as $result) {       
                            ?>
                            <p><?php echo htmlspecialchars($result->detail); ?></p>
                            <?php } ?>
                            
                            <div class="about-features">
                                <h5 class="mb-4">Why Choose Us:</h5>
                                <ul>
                                    <li><i class="fas fa-check-circle"></i>Mobile service at your location</li>
                                    <li><i class="fas fa-check-circle"></i>Eco-friendly cleaning products</li>
                                    <li><i class="fas fa-check-circle"></i>Certified detailing specialists</li>
                                    <li><i class="fas fa-check-circle"></i>Water-saving techniques</li>
                                    <li><i class="fas fa-check-circle"></i>Premium quality results</li>
                                    <li><i class="fas fa-check-circle"></i>Satisfaction guaranteed</li>
                                </ul>
                            </div>
                            <a href="washing-plans.php" class="btn btn-custom mt-3">View Our Plans</a>
                        </div>
                    </div>
                </div>
            </div>
        </div>
        <!-- About Section End -->

        <!-- Team Section Start -->
        <div class="team-section">
            <div class="container">
                <div class="section-header text-center">
                    <p>Our Team</p>
                    <h2>Meet The Experts</h2>
                </div>
                <div class="row">
                    <div class="col-lg-3 col-md-6">
                        <div class="team-member">
                            <div class="team-img">
                                <img src="img/klery.jpg" alt="Team Member">
                                <div class="team-social">
                                    <a href="https://www.facebook.com/klery.zigiro"><i class="fab fa-facebook-f"></i></a>
                                    
                                    <a href="https://www.instagram.com/clearlyjo?igsh=MWN4MGdxd3h5d203aw=="><i class="fab fa-instagram"></i></a>
                                    <a href="https://www.linkedin.com/in/klery-johansen-silalahi-336737313?utm_source=share&utm_campaign=share_via&utm_content=profile&utm_medium=android_app"><i class="fab fa-linkedin-in"></i></a>
                                </div>
                            </div>
                            <div class="team-info">
                                <h4>Klery silalahi</h4>
                               
                            </div>
                        </div>
                    </div>
                    <div class="col-lg-3 col-md-6">
                        <div class="team-member">
                            <div class="team-img">
                                <img src="img/rafi.jpg" alt="Team Member">
                                <div class="team-social">
                                    <a href="#"><i class="fab fa-facebook-f"></i></a>
                                   
                                    <a href="https://www.instagram.com/rafiiraaa?igsh=MTg2b3Q5anpqZzdh"><i class="fab fa-instagram"></i></a>
                                    <a href="#"><i class="fab fa-linkedin-in"></i></a>
                                </div>
                            </div>
                            <div class="team-info">
                                <h4>M.rafi</h4>
                                
                            </div>
                        </div>
                    </div>
                     <div class="col-lg-3 col-md-6">
                        <div class="team-member">
                            <div class="team-img">
                                <img src="img/anto.jpg" alt="Team Member">
                                <div class="team-social">
                                    <a href="#"><i class="fab fa-facebook-f"></i></a>
                                   
                                    <a href="https://www.instagram.com/antoskskk?igsh=MTN1Y2N1Y3lsbDUwNA=="><i class="fab fa-instagram"></i></a>
                                    <a href="#"><i class="fab fa-linkedin-in"></i></a>
                                </div>
                            </div>
                            <div class="team-info">
                                <h4>Suryanto</h4>
                                
                            </div>
                        </div>
                    </div>
                    <div class="col-lg-3 col-md-6">
                        <div class="team-member">
                            <div class="team-img">
                                <img src="img/rijal.jpg" alt="Team Member">
                                <div class="team-social">
                                    <a href="#"><i class="fab fa-facebook-f"></i></a>
                                    
                                    <a href="https://www.instagram.com/noerjal_?igsh=OTBkOTVndXp3cGR5"><i class="fab fa-instagram"></i></a>
                                    <a href="#"><i class="fab fa-linkedin-in"></i></a>
                                </div>
                            </div>
                            <div class="team-info">
                                <h4>Rijal Nur</h4>
                               
                            </div>
                        </div>
                    </div>
                    <div class="col-lg-3 col-md-6">
                        <div class="team-member">
                            <div class="team-img">
                                <img src="img/bryan.jpg" alt="Team Member">
                                <div class="team-social">
                                    <a href="#"><i class="fab fa-facebook-f"></i></a>
                                   
                                    <a href="#"><i class="fab fa-instagram"></i></a>
                                    <a href="#"><i class="fab fa-linkedin-in"></i></a>
                                </div>
                            </div>
                            <div class="team-info">
                                <h4>Bryan Kusumajaya</h4>
                              
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
        <!-- Team Section End -->

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