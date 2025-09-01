<!-- Footer Start -->
<div class="footer">
    <div class="footer-wave">
        <svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 1440 320"><path fill="var(--primary)" fill-opacity="1" d="M0,192L48,197.3C96,203,192,213,288,229.3C384,245,480,267,576,250.7C672,235,768,181,864,181.3C960,181,1056,235,1152,234.7C1248,235,1344,181,1392,154.7L1440,128L1440,320L1392,320C1344,320,1248,320,1152,320C1056,320,960,320,864,320C768,320,672,320,576,320C480,320,384,320,288,320C192,320,96,320,48,320L0,320Z"></path></svg>
    </div>
    <div class="container">
        <div class="row">
            <div class="col-lg-4 col-md-6 mb-5 mb-lg-0">
                <div class="footer-brand mb-4">
                    <img src="img/logo.jpg" alt="Duck n Wash" class="img-fluid" style="height: 50px;">
                    <h2 class="text-white mt-2">Duck n Wash</h2>
                </div>
                <p class="text-white-50 mb-4">Premium mobile car wash and detailing services that come to your location. Experience the convenience of professional car care.</p>
                <div class="footer-social">
                    <a class="btn btn-social" href="#" aria-label="Twitter"><i class="fab fa-twitter"></i></a>
                    <a class="btn btn-social" href="#" aria-label="Facebook"><i class="fab fa-facebook-f"></i></a>
                    <a class="btn btn-social" href="#" aria-label="Instagram"><i class="fab fa-instagram"></i></a>
                    <a class="btn btn-social" href="#" aria-label="YouTube"><i class="fab fa-youtube"></i></a>
                    <a class="btn btn-social" href="#" aria-label="LinkedIn"><i class="fab fa-linkedin-in"></i></a>
                </div>
            </div>
            
            <div class="col-lg-4 col-md-6 mb-5 mb-md-0">
                <div class="footer-contact">
                    <h2 class="footer-heading">Contact Us</h2>
                    <div class="footer-divider"></div>
                    <?php 
                    $sql = "SELECT * from tblpages where type='contact'";
                    $query = $dbh->prepare($sql);
                    $query->execute();
                    $results=$query->fetchAll(PDO::FETCH_OBJ);
                    foreach($results as $result) {       
                    ?>
                    <div class="contact-item">
                        <i class="fas fa-map-marker-alt"></i>
                        <span><?php echo htmlspecialchars($result->detail); ?></span>
                    </div>
                    <div class="contact-item">
                        <i class="fas fa-phone-alt"></i>
                        <span>+<?php echo htmlspecialchars($result->phoneNumber); ?></span>
                    </div>
                    <div class="contact-item">
                        <i class="fas fa-envelope"></i>
                        <span><?php echo htmlspecialchars($result->emailId); ?></span>
                    </div>
                    <?php } ?>
                </div>
            </div>
            
            <div class="col-lg-4 col-md-6">
                <div class="footer-links">
                    <h2 class="footer-heading">Quick Links</h2>
                    <div class="footer-divider"></div>
                    <ul class="list-unstyled">
                        <li><a href="index.php"><i class="fas fa-chevron-right"></i> Home</a></li>
                        <li><a href="about.php"><i class="fas fa-chevron-right"></i> About Us</a></li>
                        <li><a href="washing-plans.php"><i class="fas fa-chevron-right"></i> Washing Plans</a></li>
                        <li><a href="location.php"><i class="fas fa-chevron-right"></i> Service Locations</a></li>
                        <li><a href="contact.php"><i class="fas fa-chevron-right"></i> Contact Us</a></li>
                        <li><a href="faq.php"><i class="fas fa-chevron-right"></i> FAQs</a></li>
                    </ul>
                </div>
            </div>
        </div>
    </div>
    
    <div class="footer-bottom">
        <div class="container">
            <div class="row align-items-center">
                <div class="col-md-6 text-center text-md-left">
                    <p class="mb-0">&copy; <?php echo date("Y"); ?> Duck n Wash. All Rights Reserved.</p>
                </div>
                <div class="col-md-6 text-center text-md-right">
                    <div class="footer-legal">
                        <a href="privacy.php">Privacy Policy</a>
                        <a href="terms.php">Terms of Service</a>
                    </div>
                </div>
            </div>
        </div>
    </div>
</div>
<!-- Footer End -->

<!-- Back to top button -->
<a href="#" class="back-to-top" aria-label="Back to top">
    <i class="fas fa-chevron-up"></i>
</a>

<!-- Pre Loader -->
<div id="loader" class="show">
    <div class="loader-spinner">
        <div class="loader-duck">
            <img src="img/duck-icon-white.png" alt="Loading..." style="height: 60px;">
        </div>
        <div class="loader-wave"></div>
    </div>
</div>

<style>
    /* Footer Styles */
    .footer {
        background: linear-gradient(135deg, var(--dark) 0%, var(--primary) 100%);
        color: white;
        position: relative;
        padding-top: 80px;
        margin-top: 100px;
    }
    
    .footer-wave {
        position: absolute;
        top: -100px;
        left: 0;
        width: 100%;
        height: 100px;
        overflow: hidden;
    }
    
    .footer-wave svg {
        position: absolute;
        top: 0;
        left: 0;
        width: 100%;
        height: 100%;
    }
    
    .footer-brand img {
        transition: all 0.3s ease;
    }
    
    .footer-brand:hover img {
        transform: rotate(-10deg) scale(1.1);
    }
    
    .footer-heading {
        font-family: 'Fredoka One', cursive;
        color: white;
        font-size: 1.5rem;
        margin-bottom: 20px;
        position: relative;
    }
    
    .footer-divider {
        height: 3px;
        width: 60px;
        background: var(--accent);
        margin-bottom: 25px;
    }
    
    .footer-social {
        margin-top: 20px;
    }
    
    .btn-social {
        display: inline-flex;
        align-items: center;
        justify-content: center;
        width: 40px;
        height: 40px;
        border-radius: 50%;
        background: rgba(255,255,255,0.1);
        color: white;
        margin-right: 10px;
        transition: all 0.3s;
    }
    
    .btn-social:hover {
        background: var(--accent);
        color: var(--dark);
        transform: translateY(-3px);
    }
    
    .contact-item {
        display: flex;
        align-items: flex-start;
        margin-bottom: 15px;
    }
    
    .contact-item i {
        color: var(--accent);
        margin-right: 15px;
        margin-top: 3px;
        font-size: 1.1rem;
    }
    
    .contact-item span {
        color: rgba(255,255,255,0.8);
    }
    
    .footer-links ul li {
        margin-bottom: 12px;
    }
    
    .footer-links ul li a {
        color: rgba(255,255,255,0.8);
        transition: all 0.3s;
        display: flex;
        align-items: center;
    }
    
    .footer-links ul li a i {
        margin-right: 8px;
        color: var(--accent);
        font-size: 0.8rem;
    }
    
    .footer-links ul li a:hover {
        color: white;
        padding-left: 5px;
        text-decoration: none;
    }
    
    .footer-bottom {
        background: rgba(0,0,0,0.2);
        padding: 20px 0;
        margin-top: 50px;
    }
    
    .footer-legal a {
        color: rgba(255,255,255,0.7);
        margin-left: 15px;
        transition: all 0.3s;
    }
    
    .footer-legal a:hover {
        color: white;
        text-decoration: none;
    }
    
    /* Back to top button */
    .back-to-top {
        position: fixed;
        bottom: 30px;
        right: 30px;
        width: 50px;
        height: 50px;
        background: var(--primary);
        color: white;
        border-radius: 50%;
        display: flex;
        align-items: center;
        justify-content: center;
        font-size: 1.2rem;
        z-index: 99;
        opacity: 0;
        visibility: hidden;
        transition: all 0.3s;
        box-shadow: 0 5px 15px rgba(0,0,0,0.2);
    }
    
    .back-to-top.active {
        opacity: 1;
        visibility: visible;
    }
    
    .back-to-top:hover {
        background: var(--secondary);
        transform: translateY(-3px);
    }
    
    /* Loader Styles */
    #loader {
        position: fixed;
        top: 0;
        left: 0;
        width: 100%;
        height: 100%;
        background: rgba(0,0,0,0.8);
        display: flex;
        justify-content: center;
        align-items: center;
        z-index: 9999;
        transition: all 0.3s;
    }
    
    .loader-spinner {
        position: relative;
        text-align: center;
    }
    
    .loader-duck {
        animation: duckFloat 1.5s ease-in-out infinite;
    }
    
    .loader-wave {
        width: 100px;
        height: 20px;
        background: url('data:image/svg+xml;utf8,<svg viewBox="0 0 100 20" xmlns="http://www.w3.org/2000/svg"><path d="M0,10 C15,15 30,5 50,10 C70,15 85,5 100,10 L100,20 L0,20 Z" fill="%2300A8E8"/></svg>') repeat-x;
        animation: wave 1.5s linear infinite;
        margin-top: -10px;
    }
    
    @keyframes duckFloat {
        0% { transform: translateY(0px); }
        50% { transform: translateY(-15px); }
        100% { transform: translateY(0px); }
    }
    
    @keyframes wave {
        0% { background-position-x: 0; }
        100% { background-position-x: 100px; }
    }
    
    /* Responsive adjustments */
    @media (max-width: 991px) {
        .footer {
            padding-top: 60px;
        }
        
        .footer-wave {
            top: -80px;
            height: 80px;
        }
    }
    
    @media (max-width: 767px) {
        .footer {
            text-align: center;
            padding-top: 40px;
        }
        
        .footer-wave {
            top: -60px;
            height: 60px;
        }
        
        .footer-divider {
            margin-left: auto;
            margin-right: auto;
        }
        
        .contact-item {
            justify-content: center;
        }
        
        .footer-social {
            justify-content: center;
        }
        
        .footer-bottom .row > div {
            text-align: center !important;
            margin-bottom: 10px;
        }
        
        .footer-legal a {
            margin: 0 8px;
        }
    }
</style>

<script>
    // Back to top button functionality
    $(window).scroll(function() {
        if ($(this).scrollTop() > 300) {
            $('.back-to-top').addClass('active');
        } else {
            $('.back-to-top').removeClass('active');
        }
    });
    
    $('.back-to-top').click(function(e) {
        e.preventDefault();
        $('html, body').animate({scrollTop: 0}, '300');
    });
    
    // Page loader
    $(window).on('load', function() {
        setTimeout(function() {
            $('#loader').fadeOut('slow');
        }, 1000);
    });
</script>