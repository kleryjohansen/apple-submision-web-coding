<?php //error_reporting(0);
include('includes/config.php'); 

if(isset($_POST['book']))
{
$ptype=$_POST['packagetype'];
$wpoint=$_POST['washingpoint'];   
$fname=$_POST['fname'];
$mobile=$_POST['contactno'];
$date=$_POST['washdate'];
$time=$_POST['washtime'];
$message=$_POST['message'];
$status='New';
$bno=mt_rand(100000000, 999999999);
$sql="INSERT INTO tblcarwashbooking(bookingId,packageType,carWashPoint,fullName,mobileNumber,washDate,washTime,message,status) VALUES(:bno,:ptype,:wpoint,:fname,:mobile,:date,:time,:message,:status)";
$query = $dbh->prepare($sql);
$query->bindParam(':bno',$bno,PDO::PARAM_STR);
$query->bindParam(':ptype',$ptype,PDO::PARAM_STR);
$query->bindParam(':wpoint',$wpoint,PDO::PARAM_STR);
$query->bindParam(':fname',$fname,PDO::PARAM_STR);
$query->bindParam(':mobile',$mobile,PDO::PARAM_STR);
$query->bindParam(':date',$date,PDO::PARAM_STR);
$query->bindParam(':time',$time,PDO::PARAM_STR);
$query->bindParam(':message',$message,PDO::PARAM_STR);
$query->bindParam(':status',$status,PDO::PARAM_STR);
$query->execute();
$lastInsertId = $dbh->lastInsertId();
if($lastInsertId)
{
 
  echo '<script>alert("Your booking done successfully. Booking number is "+"'.$bno.'")</script>';
 echo "<script>window.location.href ='washing-plans.php'</script>";
}
else 
{
 echo "<script>alert('Something went wrong. Please try again.');</script>";
}

}

?>

<!DOCTYPE html>
<html lang="en">
    <head>
        <meta charset="utf-8">
        <title>Duck n Wash | Premium Mobile Car Detailing</title>
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <meta name="description" content="Professional mobile car wash & detailing services that come to you. Book online for sparkling clean vehicles!">

        <!-- Favicon -->
        <link href="img/logo.jng" rel="icon">

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
            
            body {
                font-family: 'Poppins', sans-serif;
                background-color: var(--light);
                color: #444;
                overflow-x: hidden;
            }
            
            h1, h2, h3, h4, h5, h6 {
                font-family: 'Fredoka One', cursive;
                color: var(--dark);
                letter-spacing: 0.5px;
            }
            
            .btn-custom {
                background-color: var(--primary);
                border: none;
                color: white;
                padding: 12px 25px;
                border-radius: 50px;
                font-weight: 600;
                text-transform: uppercase;
                letter-spacing: 1px;
                transition: all 0.4s cubic-bezier(0.175, 0.885, 0.32, 1.275);
                box-shadow: 0 4px 15px rgba(0, 168, 232, 0.3);
            }
            
            .btn-custom:hover {
                background-color: var(--secondary);
                transform: translateY(-3px) scale(1.02);
                box-shadow: 0 8px 25px rgba(255, 107, 107, 0.4);
                color: white;
            }
            
            /* Gradient Header */
            .navbar {
                background: linear-gradient(135deg, var(--primary) 0%, var(--dark) 100%);
                box-shadow: 0 4px 20px rgba(45, 48, 71, 0.15);
                padding: 15px 0;
                transition: all 0.3s;
            }
            
            .navbar-brand {
                font-family: 'Fredoka One', cursive;
                color: white !important;
                font-size: 1.8rem;
                display: flex;
                align-items: center;
            }
            
            .navbar-brand img {
                height: 50px;
                margin-right: 10px;
                transition: all 0.3s;
            }
            
            .navbar-brand:hover img {
                transform: rotate(-15deg) scale(1.1);
            }
            
            .nav-link {
                color: rgba(255,255,255,0.9) !important;
                font-weight: 500;
                padding: 8px 15px !important;
                margin: 0 5px;
                border-radius: 50px;
                transition: all 0.3s;
            }
            
            .nav-link:hover {
                color: white !important;
                background: rgba(255,255,255,0.15);
                transform: translateY(-2px);
            }
            
            /* Hero Section */
            .carousel {
                position: relative;
                overflow: hidden;
            }
            
            .carousel-item {
                height: 100vh;
                min-height: 600px;
            }
            
            .carousel-img {
                position: absolute;
                width: 100%;
                height: 100%;
                object-fit: cover;
            }
            
            .carousel-img:after {
                content: '';
                position: absolute;
                top: 0;
                left: 0;
                width: 100%;
                height: 100%;
                background: linear-gradient(135deg, rgba(0,168,232,0.85) 0%, rgba(45,48,71,0.9) 100%);
            }
            
            .carousel-text {
                position: absolute;
                top: 50%;
                left: 50%;
                transform: translate(-50%, -50%);
                text-align: center;
                width: 100%;
                z-index: 1;
            }
            
            .carousel-text h1 {
                font-size: 4.5rem;
                color: white;
                text-shadow: 2px 2px 8px rgba(0,0,0,0.2);
                margin-bottom: 20px;
                animation: fadeInUp 1s ease;
            }
            
            .carousel-text h3 {
                color: var(--accent);
                font-size: 2rem;
                margin-bottom: 30px;
                animation: fadeInUp 1s ease 0.2s forwards;
                opacity: 0;
            }
            
            .hero-duck {
                position: absolute;
                bottom: -50px;
                right: 100px;
                height: 200px;
                z-index: 2;
                animation: float 6s ease-in-out infinite;
                filter: drop-shadow(0 10px 15px rgba(0,0,0,0.2));
            }
            
            /* Section Styling */
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
            
            /* About Section */
            .about {
                padding: 100px 0;
                position: relative;
                overflow: hidden;
            }
            
            .about-img {
                position: relative;
                border-radius: 20px;
                overflow: hidden;
                box-shadow: 0 20px 40px rgba(0,0,0,0.15);
                transform: rotate(-2deg);
                transition: all 0.5s ease;
            }
            
            .about-img:hover {
                transform: rotate(0deg) scale(1.02);
            }
            
            .about-img img {
                width: 100%;
                height: auto;
                transition: all 0.5s ease;
            }
            
            .about-img:before {
                content: '';
                position: absolute;
                top: 0;
                left: 0;
                width: 100%;
                height: 100%;
                background: linear-gradient(135deg, rgba(0,168,232,0.3) 0%, rgba(255,214,102,0.3) 100%);
                z-index: 1;
            }
            
            .about-content {
                padding-left: 30px;
            }
            
            .about-content p {
                font-size: 1.1rem;
                line-height: 1.8;
                margin-bottom: 30px;
            }
            
            .about-content ul {
                list-style: none;
                padding: 0;
                margin-bottom: 30px;
            }
            
            .about-content ul li {
                position: relative;
                padding-left: 30px;
                margin-bottom: 15px;
                font-size: 1.1rem;
            }
            
            .about-content ul li i {
                position: absolute;
                left: 0;
                top: 2px;
                color: var(--primary);
                font-size: 1.2rem;
            }
            
            /* Services Section */
            .service {
                padding: 100px 0;
                background-color: white;
                position: relative;
            }
            
            .service-item {
                background: white;
                border-radius: 15px;
                padding: 40px 30px;
                text-align: center;
                margin-bottom: 30px;
                transition: all 0.4s cubic-bezier(0.175, 0.885, 0.32, 1.275);
                box-shadow: 0 10px 30px rgba(0,0,0,0.05);
                border: 1px solid rgba(0,0,0,0.03);
                position: relative;
                overflow: hidden;
                z-index: 1;
            }
            
            .service-item:before {
                content: '';
                position: absolute;
                top: 0;
                left: 0;
                width: 100%;
                height: 5px;
                background: linear-gradient(90deg, var(--primary), var(--secondary));
                transition: all 0.3s;
            }
            
            .service-item:hover {
                transform: translateY(-10px);
                box-shadow: 0 15px 40px rgba(0,0,0,0.1);
            }
            
            .service-item:hover:before {
                height: 10px;
            }
            
            .service-item i {
                font-size: 60px;
                margin-bottom: 25px;
                display: inline-block;
                background: linear-gradient(135deg, var(--primary), var(--secondary));
                -webkit-background-clip: text;
                -webkit-text-fill-color: transparent;
                transition: all 0.3s;
            }
            
            .service-item:hover i {
                transform: scale(1.1) rotate(5deg);
            }
            
            .service-item h3 {
                margin-bottom: 20px;
                font-weight: 700;
            }
            
            /* Facts Section */
            .facts {
                padding: 100px 0;
                background: linear-gradient(135deg, var(--dark) 0%, var(--primary) 100%);
                color: white;
                position: relative;
                overflow: hidden;
            }
            
            .facts:before {
                content: '';
                position: absolute;
                top: -50px;
                left: 0;
                width: 100%;
                height: 100px;
                background: white;
                transform: skewY(-3deg);
                z-index: 1;
            }
            
            .facts:after {
                content: '';
                position: absolute;
                bottom: -50px;
                left: 0;
                width: 100%;
                height: 100px;
                background: white;
                transform: skewY(-3deg);
                z-index: 1;
            }
            
            .facts-item {
                text-align: center;
                padding: 40px 20px;
                background: rgba(255,255,255,0.1);
                border-radius: 15px;
                backdrop-filter: blur(5px);
                margin-bottom: 30px;
                transition: all 0.3s;
                border: 1px solid rgba(255,255,255,0.2);
            }
            
            .facts-item:hover {
                background: rgba(255,255,255,0.15);
                transform: translateY(-5px);
            }
            
            .facts-item i {
                font-size: 50px;
                margin-bottom: 20px;
                color: var(--accent);
            }
            
            .facts-item h3 {
                font-size: 3rem;
                font-weight: 700;
                margin-bottom: 10px;
                color: white;
            }
            
            .facts-item p {
                font-size: 1.2rem;
                opacity: 0.9;
            }
            
            /* Price Section */
            .price {
                padding: 100px 0;
                background-color: var(--light);
            }
            
            .price-item {
                background: white;
                border-radius: 15px;
                overflow: hidden;
                margin-bottom: 30px;
                transition: all 0.4s cubic-bezier(0.175, 0.885, 0.32, 1.275);
                box-shadow: 0 10px 30px rgba(0,0,0,0.05);
                position: relative;
            }
            
            .price-item:hover {
                transform: translateY(-10px);
                box-shadow: 0 15px 40px rgba(0,0,0,0.1);
            }
            
            .price-header {
                padding: 30px;
                text-align: center;
                background: linear-gradient(135deg, var(--primary), var(--dark));
                color: white;
                position: relative;
            }
            
            .price-header h3 {
                font-size: 1.5rem;
                margin-bottom: 10px;
            }
            
            .price-header h2 {
                font-size: 3rem;
                color: white;
                margin-bottom: 0;
            }
            
            .price-header h2 span {
                font-size: 1.5rem;
                vertical-align: top;
                line-height: 3rem;
            }
            
            .price-body {
                padding: 30px;
            }
            
            .price-body ul {
                list-style: none;
                padding: 0;
            }
            
            .price-body ul li {
                padding: 10px 0;
                border-bottom: 1px dashed #eee;
                display: flex;
                align-items: center;
            }
            
            .price-body ul li i {
                margin-right: 10px;
                font-size: 1.2rem;
            }
            
            .price-body ul li .fa-check-circle {
                color: var(--success);
            }
            
            .price-body ul li .fa-times-circle {
                color: #ccc;
            }
            
            .price-footer {
                padding: 20px 30px;
                text-align: center;
                background: rgba(0,0,0,0.02);
            }
            
            .featured-item {
                border: 3px solid var(--accent);
                transform: scale(1.02);
            }
            
            .featured-item .price-header {
                background: linear-gradient(135deg, var(--secondary), var(--accent));
            }
            
            .featured-badge {
                position: absolute;
                top: 20px;
                right: -40px;
                background: var(--accent);
                color: var(--dark);
                padding: 5px 40px;
                font-weight: 700;
                transform: rotate(45deg);
                font-size: 0.8rem;
                box-shadow: 0 2px 10px rgba(0,0,0,0.1);
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
                background: rgba(0, 168, 232, 0.2);
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
            
            /* Duck Animation */
            @keyframes float {
                0% { transform: translateY(0px) rotate(0deg); }
                50% { transform: translateY(-20px) rotate(5deg); }
                100% { transform: translateY(0px) rotate(0deg); }
            }
            
            @keyframes splash {
                0% { transform: scale(0); opacity: 0; }
                50% { transform: scale(1); opacity: 0.6; }
                100% { transform: scale(1.5); opacity: 0; }
            }
            
            /* Modal Styling */
            .modal-content {
                border: none;
                border-radius: 15px;
                overflow: hidden;
                box-shadow: 0 10px 40px rgba(0,0,0,0.2);
            }
            
            .modal-header {
                background: linear-gradient(135deg, var(--primary), var(--dark));
                color: white;
                border-bottom: none;
                padding: 20px 25px;
            }
            
            .modal-title {
                font-family: 'Fredoka One', cursive;
            }
            
            .modal-body {
                padding: 30px;
            }
            
            .form-control {
                border-radius: 50px;
                padding: 12px 20px;
                border: 1px solid #ddd;
                margin-bottom: 20px;
                transition: all 0.3s;
            }
            
            .form-control:focus {
                border-color: var(--primary);
                box-shadow: 0 0 0 0.2rem rgba(0, 168, 232, 0.25);
            }
            
            /* Responsive Adjustments */
            @media (max-width: 991px) {
                .carousel-text h1 {
                    font-size: 3.5rem;
                }
                
                .carousel-text h3 {
                    font-size: 1.5rem;
                }
                
                .hero-duck {
                    height: 150px;
                    right: 50px;
                    bottom: -30px;
                }
            }
            
            @media (max-width: 767px) {
                .carousel-text h1 {
                    font-size: 2.5rem;
                }
                
                .carousel-text h3 {
                    font-size: 1.2rem;
                }
                
                .hero-duck {
                    display: none;
                }
                
                .about-content {
                    padding-left: 0;
                    margin-top: 30px;
                }
                
                .facts:before, .facts:after {
                    height: 50px;
                }
            }
        </style>
    </head>

    <body>
        <!-- Water Drops Animation -->
        <div class="water-drops" id="waterDrops"></div>

        <?php include_once('includes/header.php');?>

        <!-- Carousel Start -->
        <div class="carousel">
            <div class="owl-carousel">
                <div class="carousel-item">
                    <div class="carousel-img" style="background-image: url('img/carousel-1.jpg');"></div>
                    <div class="carousel-text">
                        <h1>Premium Car Care That Comes To You</h1>
                        <h3>Duck n Wash Mobile Service</h3>
                        <a href="#pricing" class="btn btn-custom btn-lg mt-3">Book Now</a>
                    </div>
                    
                </div>
                <div class="carousel-item">
                    <div class="carousel-img" style="background-image: url('img/carousel-2.jpg');"></div>
                    <div class="carousel-text">
                        <h1>Expert Detailing For Your Vehicle</h1>
                        <h3>Interior & Exterior Perfection</h3>
                        <a href="#pricing" class="btn btn-custom btn-lg mt-3">View Plans</a>
                    </div>
                    
                </div>
                <div class="carousel-item">
                    <div class="carousel-img" style="background-image: url('img/carousel-3.jpg');"></div>
                    <div class="carousel-text">
                        <h1>Eco-Friendly Cleaning Solutions</h1>
                        <h3>Safe For Your Car & The Environment</h3>
                        <a href="#services" class="btn btn-custom btn-lg mt-3">Our Services</a>
                    </div>
                   
            </div>
        </div>
        <!-- Carousel End -->
        

        <!-- About Start -->
        <div class="about">
            <div class="container">
                <div class="row align-items-center">
                    <div class="col-lg-6">
                        <div class="about-img">
                            <img src="img/about.jpg" alt="Duck n Wash Team" class="img-fluid">
                            <div class="splash" style="position: absolute; bottom: -30px; right: -30px;">
                                <img src="img/water-splash.png" alt="Water Splash" style="height: 100px;">
                            </div>
                        </div>
                    </div>
                    <div class="col-lg-6">
                        <div class="section-header text-left">
                            <p>About Us</p>
                            <h2>Why Duck n Wash Stands Out</h2>
                        </div>
                        <div class="about-content">
                            <p>
                                At Duck n Wash, we're revolutionizing car care with our innovative mobile service. Our team of certified professionals brings the car wash to your doorstep, using premium eco-friendly products and state-of-the-art equipment to deliver showroom-quality results.
                            </p>
                            <ul>
                                <li><i class="fas fa-check-circle"></i>100% mobile service - we come to your location</li>
                                <li><i class="fas fa-check-circle"></i>Water-saving techniques that conserve resources</li>
                                <li><i class="fas fa-check-circle"></i>Premium eco-friendly cleaning products</li>
                                <li><i class="fas fa-check-circle"></i>Certified detailing specialists</li>
                                <li><i class="fas fa-check-circle"></i>Satisfaction guaranteed on all services</li>
                            </ul>
                            <a class="btn btn-custom mt-3" href="about.php">Our Story</a>
                        </div>
                    </div>
                </div>
            </div>
        </div>
        <!-- About End -->


        <!-- Service Start -->
        <div class="service" id="services">
            <div class="container">
                <div class="section-header text-center">
                    <p>Our Services</p>
                    <h2>Complete Car Care Solutions</h2>
                </div>
                <div class="row">
                    <div class="col-lg-4 col-md-6">
                        <div class="service-item">
                            <i class="flaticon-car-wash-1"></i>
                            <h3>Exterior Wash</h3>
                            <p>Complete exterior cleaning with pH-balanced shampoo and spot-free rinse</p>
                        </div>
                    </div>
                    <div class="col-lg-4 col-md-6">
                        <div class="service-item">
                            <i class="flaticon-car-wash"></i>
                            <h3>Interior Detailing</h3>
                            <p>Deep cleaning of all interior surfaces including dashboard, console, and more</p>
                        </div>
                    </div>
                    <div class="col-lg-4 col-md-6">
                        <div class="service-item">
                            <i class="flaticon-vacuum-cleaner"></i>
                            <h3>Vacuum Service</h3>
                            <p>Thorough vacuuming of seats, carpets, floor mats, and hard-to-reach areas</p>
                        </div>
                    </div>
                    <div class="col-lg-4 col-md-6">
                        <div class="service-item">
                            <i class="flaticon-seat"></i>
                            <h3>Seat Cleaning</h3>
                            <p>Specialized cleaning for leather, fabric, and vinyl seats</p>
                        </div>
                    </div>
                    <div class="col-lg-4 col-md-6">
                        <div class="service-item">
                            <i class="flaticon-car-service"></i>
                            <h3>Window Cleaning</h3>
                            <p>Streak-free window cleaning inside and out for perfect visibility</p>
                        </div>
                    </div>
                    <div class="col-lg-4 col-md-6">
                        <div class="service-item">
                            <i class="flaticon-car-service-2"></i>
                            <h3>Wet Cleaning</h3>
                            <p>Advanced wet cleaning for stubborn stains and spills</p>
                        </div>
                    </div>
                </div>
            </div>
        </div>
        <!-- Service End -->
        
        
        <!-- Facts Start -->
        <div class="facts">
            <div class="container">
                <div class="row">
                    <div class="col-lg-3 col-md-6">
                        <div class="facts-item">
                            <i class="fa fa-map-marker-alt"></i>
                            <div class="facts-text">
                                <h3 data-toggle="counter-up">25</h3>
                                <p>Service Locations</p>
                            </div>
                        </div>
                    </div>
                    <div class="col-lg-3 col-md-6">
                        <div class="facts-item">
                            <i class="fa fa-user"></i>
                            <div class="facts-text">
                                <h3 data-toggle="counter-up">350</h3>
                                <p>Certified Professionals</p>
                            </div>
                        </div>
                    </div>
                    <div class="col-lg-3 col-md-6">
                        <div class="facts-item">
                            <i class="fa fa-users"></i>
                            <div class="facts-text">
                                <h3 data-toggle="counter-up">1500</h3>
                                <p>Happy Clients</p>
                            </div>
                        </div>
                    </div>
                    <div class="col-lg-3 col-md-6">
                        <div class="facts-item">
                            <i class="fa fa-check"></i>
                            <div class="facts-text">
                                <h3 data-toggle="counter-up">5000</h3>
                                <p>Vehicles Cleaned</p>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
        <!-- Facts End -->
        
        
        <!-- Price Start -->
        <div class="price" id="pricing">
            <div class="container">
                <div class="section-header text-center">
                    <p>Washing Plans</p>
                    <h2>Choose Your Perfect Package</h2>
                </div>
                <div class="row">
                    <div class="col-md-4">
                        <div class="price-item">
                            <div class="price-header">
                                <h3>Basic Wash</h3>
                                <h2><span>$</span><strong>10</strong><span>.99</span></h2>
                            </div>
                            <div class="price-body">
                                <ul>
                                    <li><i class="far fa-check-circle"></i>Exterior Hand Wash</li>
                                    <li><i class="far fa-check-circle"></i>Tire & Wheel Clean</li>
                                    <li><i class="far fa-check-circle"></i>Window Cleaning</li>
                                    <li><i class="far fa-times-circle"></i>Interior Vacuum</li>
                                    <li><i class="far fa-times-circle"></i>Dashboard Wipe</li>
                                </ul>
                            </div>
                            <div class="price-footer">
                                <a class="btn btn-custom" data-toggle="modal" data-target="#myModal">Book Now</a>
                            </div>
                        </div>
                    </div>
                    <div class="col-md-4">
                        <div class="price-item featured-item">
                            <div class="price-header">
                                <h3>Premium Detail</h3>
                                <h2><span>$</span><strong>20</strong><span>.99</span></h2>
                                <div class="featured-badge">Popular</div>
                            </div>
                            <div class="price-body">
                                <ul>
                                    <li><i class="far fa-check-circle"></i>Basic Wash Included</li>
                                    <li><i class="far fa-check-circle"></i>Complete Interior Vacuum</li>
                                    <li><i class="far fa-check-circle"></i>Dashboard & Console Clean</li>
                                    <li><i class="far fa-check-circle"></i>Door Jambs Wipe</li>
                                    <li><i class="far fa-times-circle"></i>Seat Shampoo</li>
                                </ul>
                            </div>
                            <div class="price-footer">
                                <a class="btn btn-custom" data-toggle="modal" data-target="#myModal">Book Now</a>
                            </div>
                        </div>
                    </div>
                    <div class="col-md-4">
                        <div class="price-item">
                            <div class="price-header">
                                <h3>Full Detail</h3>
                                <h2><span>$</span><strong>30</strong><span>.99</span></h2>
                            </div>
                            <div class="price-body">
                                <ul>
                                    <li><i class="far fa-check-circle"></i>Premium Detail Included</li>
                                    <li><i class="far fa-check-circle"></i>Seat Shampoo</li>
                                    <li><i class="far fa-check-circle"></i>Carpet Cleaning</li>
                                    <li><i class="far fa-check-circle"></i>Air Freshener</li>
                                    <li><i class="far fa-check-circle"></i>Trim Protectant</li>
                                </ul>
                            </div>
                            <div class="price-footer">
                                <a class="btn btn-custom" data-toggle="modal" data-target="#myModal">Book Now</a>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
        <!-- Price End -->
        
        <!-- Footer Start -->
        <?php include_once('includes/footer.php');?>
        
        <!-- Booking Modal -->
        <div class="modal fade" id="myModal" role="dialog">
            <div class="modal-dialog">
                <div class="modal-content">
                    <div class="modal-header">
                        <h4 class="modal-title">Book Your Wash</h4>
                        <button type="button" class="close" data-dismiss="modal">&times;</button>
                    </div>
                    <div class="modal-body">
                        <form method="post">   
                            <div class="form-group">
                                <select name="packagetype" required class="form-control">
                                    <option value="">Select Package</option>
                                    <option value="1">Basic Wash ($10.99)</option>
                                    <option value="2">Premium Detail ($20.99)</option>
                                    <option value="3">Full Detail ($30.99)</option>
                                </select>
                            </div>
                            
                            <div class="form-group">
                                <select name="washingpoint" required class="form-control">
                                    <option value="">Select Location</option>
                                    <?php $sql = "SELECT * from tblwashingpoints";
                                    $query = $dbh->prepare($sql);
                                    $query->execute();
                                    $results=$query->fetchAll(PDO::FETCH_OBJ);
                                    foreach($results as $result)
                                    {               ?>  
                                        <option value="<?php echo htmlentities($result->id);?>"><?php echo htmlentities($result->washingPointName);?> (<?php echo htmlentities($result->washingPointAddress);?>)</option>
                                    <?php } ?>
                                </select>
                            </div>
                            
                            <div class="form-group">
                                <input type="text" name="fname" class="form-control" required placeholder="Your Full Name">
                            </div>
                            
                            <div class="form-group">
                                <input type="text" name="contactno" class="form-control" pattern="[0-9]{10}" title="10 digit phone number" required placeholder="Mobile Number">
                            </div>
                            
                            <div class="form-group">
                                <label>Preferred Date</label>
                                <input type="date" name="washdate" required class="form-control">
                            </div>
                             
                            <div class="form-group">
                                <label>Preferred Time</label>
                                <input type="time" name="washtime" required class="form-control">
                            </div>
                             
                            <div class="form-group">
                                <textarea name="message" class="form-control" placeholder="Special Instructions (Optional)"></textarea>
                            </div>
                             
                            <div class="form-group">
                                <button type="submit" name="book" class="btn btn-custom btn-block">Confirm Booking</button>
                            </div>
                        </form>
                    </div>
                </div>
            </div>
        </div>

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
            // Water drops animation
            function createDrops() {
                const container = document.getElementById('waterDrops');
                const dropCount = 20;
                
                for (let i = 0; i < dropCount; i++) {
                    const drop = document.createElement('div');
                    drop.className = 'drop';
                    
                    // Random size between 5 and 15px
                    const size = Math.random() * 10 + 5;
                    drop.style.width = `${size}px`;
                    drop.style.height = `${size}px`;
                    
                    // Random position
                    drop.style.left = `${Math.random() * 100}%`;
                    
                    // Random animation duration between 2 and 5s
                    const duration = Math.random() * 3 + 2;
                    drop.style.animationDuration = `${duration}s`;
                    
                    // Random delay
                    drop.style.animationDelay = `${Math.random() * 5}s`;
                    
                    container.appendChild(drop);
                }
            }
            
            // Initialize animations when page loads
            $(document).ready(function(){
                createDrops();
                
                // Add splash effect to duck icon
                $('.hero-duck').hover(function(){
                    $(this).css('animation', 'splash 0.6s ease');
                    setTimeout(() => {
                        $(this).css('animation', 'float 6s ease-in-out infinite');
                    }, 600);
                });
                
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