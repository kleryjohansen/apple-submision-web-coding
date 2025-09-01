<?php error_reporting(0);
include('includes/config.php');

if(isset($_POST['submit']))
{
$name=$_POST['name'];
$email=$_POST['email'];   
$subject=$_POST['subject'];
$message=$_POST['message'];

$sql="INSERT INTO tblenquiry(FullName,EmailId,Subject,Description) VALUES(:name,:email,:subject,:message)";
$query = $dbh->prepare($sql);
$query->bindParam(':name',$name,PDO::PARAM_STR);
$query->bindParam(':email',$email,PDO::PARAM_STR);
$query->bindParam(':subject',$subject,PDO::PARAM_STR);
$query->bindParam(':message',$message,PDO::PARAM_STR);
$query->execute();
$lastInsertId = $dbh->lastInsertId();
if($lastInsertId)
{
 echo "<script>alert('Query sent successfully');</script>";
 echo "<script>window.location.href ='contact.php'</script>";
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
        <title>CWMS | Contact Us</title>
        <!-- Favicon -->
        <link href="img/favicon.ico" rel="icon">

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
            
            .page-header {
                background: linear-gradient(135deg, var(--primary) 0%, var(--dark) 100%);
                padding: 100px 0 60px;
                color: white;
                text-align: center;
                position: relative;
                overflow: hidden;
            }
            
            .page-header h2 {
                font-size: 3rem;
                color: white;
                margin-bottom: 20px;
            }
            
            .page-header a {
                color: rgba(255,255,255,0.8);
                transition: all 0.3s;
            }
            
            .page-header a:hover {
                color: var(--accent);
                text-decoration: none;
            }
            
            .contact {
                padding: 100px 0;
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
            
            .contact-info {
                background: white;
                padding: 40px;
                border-radius: 15px;
                box-shadow: 0 10px 30px rgba(0,0,0,0.05);
                height: 100%;
                position: relative;
                overflow: hidden;
                z-index: 1;
            }
            
            .contact-info:before {
                content: '';
                position: absolute;
                top: 0;
                left: 0;
                width: 100%;
                height: 5px;
                background: linear-gradient(90deg, var(--primary), var(--secondary));
            }
            
            .contact-info h2 {
                margin-bottom: 30px;
                color: var(--dark);
            }
            
            .contact-info-item {
                display: flex;
                align-items: flex-start;
                margin-bottom: 30px;
            }
            
            .contact-info-icon {
                width: 50px;
                height: 50px;
                display: flex;
                align-items: center;
                justify-content: center;
                background: rgba(0, 168, 232, 0.1);
                border-radius: 50%;
                margin-right: 20px;
                color: var(--primary);
                font-size: 20px;
            }
            
            .contact-info-text h3 {
                font-size: 1.2rem;
                margin-bottom: 5px;
                color: var(--dark);
            }
            
            .contact-info-text p {
                margin: 0;
                color: #666;
            }
            
            .contact-form {
                background: white;
                padding: 40px;
                border-radius: 15px;
                box-shadow: 0 10px 30px rgba(0,0,0,0.05);
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
            
            textarea.form-control {
                border-radius: 15px;
                min-height: 150px;
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
            
            /* Responsive Adjustments */
            @media (max-width: 991px) {
                .page-header h2 {
                    font-size: 2.5rem;
                }
            }
            
            @media (max-width: 767px) {
                .page-header h2 {
                    font-size: 2rem;
                }
                
                .contact-info,
                .contact-form {
                    padding: 30px 20px;
                }
                
                .contact-info-item {
                    flex-direction: column;
                }
                
                .contact-info-icon {
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
                        <h2>Contact Us</h2>
                    </div>
                    <div class="col-12">
                        <a href="index.php">Home</a>
                        <a href="contact.php">Contact</a>
                    </div>
                </div>
            </div>
        </div>
        <!-- Page Header End -->
        
        
        <!-- Contact Start -->
        <div class="contact">
            <div class="container">
                <div class="section-header text-center">
                    <p>Get In Touch</p>
                    <h2>Contact for any query</h2>
                </div>
                <div class="row">
                    <?php 
                    $sql = "SELECT * from tblpages where type='contact'";
                    $query = $dbh -> prepare($sql);
                    $query->execute();
                    $results=$query->fetchAll(PDO::FETCH_OBJ);
                    foreach($results as $result)
                    {       
                    ?>
                    <div class="col-md-4">
                        <div class="contact-info">
                            <h2>Quick Contact Info</h2>
                            <div class="contact-info-item">
                                <div class="contact-info-icon">
                                    <i class="fa fa-map-marker-alt"></i>
                                </div>
                                <div class="contact-info-text">
                                    <h3>Address</h3>
                                    <p><?php echo $result->detail; ?></p>
                                </div>
                            </div>
                            <div class="contact-info-item">
                                <div class="contact-info-icon">
                                    <i class="far fa-clock"></i>
                                </div>
                                <div class="contact-info-text">
                                    <h3>Opening Hour</h3>
                                    <p><?php echo $result->openignHrs; ?></p>
                                </div>
                            </div>
                            <div class="contact-info-item">
                                <div class="contact-info-icon">
                                    <i class="fa fa-phone-alt"></i>
                                </div>
                                <div class="contact-info-text">
                                    <h3>Call Us</h3>
                                    <p>+<?php echo $result->phoneNumber; ?></p>
                                </div>
                            </div>
                            <div class="contact-info-item">
                                <div class="contact-info-icon">
                                    <i class="far fa-envelope"></i>
                                </div>
                                <div class="contact-info-text">
                                    <h3>Email Us</h3>
                                    <p><?php echo $result->emailId; ?></p>
                                </div>
                            </div>
                        </div>
                    </div>
                    <?php } ?>
                    <div class="col-md-8">
                        <div class="contact-form">
                            <div id="success"></div>
                            <form name="sentMessage" id="contactForm" method="post">
                                <div class="form-group">
                                    <input type="text" class="form-control" id="name" placeholder="Your Name" required="required" name="name" />
                                </div>
                                <div class="form-group">
                                    <input type="email" class="form-control" id="email" placeholder="Your Email" name="email" required="required" />
                                </div>
                                <div class="form-group">
                                    <input type="text" class="form-control" id="subject" placeholder="Subject" required="required" name="subject" />
                                </div>
                                <div class="form-group">
                                    <textarea class="form-control" id="message" placeholder="Message" required="required" name="message"></textarea>
                                </div>
                                <div class="form-group">
                                    <button class="btn btn-custom btn-block" type="submit" id="sendMessageButton" name="submit">Send Message</button>
                                </div>
                            </form>
                        </div>
                    </div>
                </div>
            </div>
        </div>
        <!-- Contact End -->

        <!-- Footer Start -->
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