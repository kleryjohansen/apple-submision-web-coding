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
        <title>Duck n Wash | Premium Washing Plans</title>
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <meta name="description" content="Choose from our premium car wash and detailing packages. We offer various plans to keep your vehicle looking its best.">

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
                background: linear-gradient(rgba(45, 48, 71, 0.9), rgba(45, 48, 71, 0.9)), url('img/carousel-2.jpg') no-repeat center center;
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
            
            /* Price Section */
            .price {
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
                        <h2>Our Washing Plans</h2>
                    </div>
                    <div class="col-12">
                        <nav aria-label="breadcrumb">
                            <ol class="breadcrumb justify-content-center">
                                <li class="breadcrumb-item"><a href="index.php">Home</a></li>
                                <li class="breadcrumb-item active" aria-current="page">Washing Plans</li>
                            </ol>
                        </nav>
                    </div>
                </div>
            </div>
        </div>
        <!-- Page Header End -->
        
        <!-- Price Start -->
        <div class="price">
            <div class="container">
                <div class="section-header text-center">
                    <p>Choose Your Perfect Plan</p>
                    <h2>Our Washing Packages</h2>
                </div>
                <div class="row">
                    <!-- Basic Wash -->
                    <div class="col-lg-3 col-md-6 mb-4">
                        <div class="price-item">
                            <div class="price-header">
                                <h3>Basic Wash</h3>
                                <h2><span>$</span><strong>5</strong><span>.99</span></h2>
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
                    
                    <!-- Standard Wash -->
                    <div class="col-lg-3 col-md-6 mb-4">
                        <div class="price-item">
                            <div class="price-header">
                                <h3>Standard Wash</h3>
                                <h2><span>$</span><strong>7</strong><span>.99</span></h2>
                            </div>
                            <div class="price-body">
                                <ul>
                                    <li><i class="far fa-check-circle"></i>Basic Wash Included</li>
                                    <li><i class="far fa-check-circle"></i>Complete Interior Vacuum</li>
                                    <li><i class="far fa-check-circle"></i>Dashboard & Console Clean</li>
                                    <li><i class="far fa-times-circle"></i>Seat Shampoo</li>
                                    <li><i class="far fa-times-circle"></i>Carpet Cleaning</li>
                                </ul>
                            </div>
                            <div class="price-footer">
                                <a class="btn btn-custom" data-toggle="modal" data-target="#myModal">Book Now</a>
                            </div>
                        </div>
                    </div>
                    
                    <!-- Premium Detail (Featured) -->
                    <div class="col-lg-3 col-md-6 mb-4">
                        <div class="price-item featured-item">
                            <div class="price-header">
                                <h3>Premium Detail</h3>
                                <h2><span>$</span><strong>12</strong><span>.99</span></h2>
                                <div class="featured-badge">Popular</div>
                            </div>
                            <div class="price-body">
                                <ul>
                                    <li><i class="far fa-check-circle"></i>Standard Wash Included</li>
                                    <li><i class="far fa-check-circle"></i>Seat Shampoo</li>
                                    <li><i class="far fa-check-circle"></i>Carpet Cleaning</li>
                                    <li><i class="far fa-check-circle"></i>Door Jambs Wipe</li>
                                    <li><i class="far fa-times-circle"></i>Wax Application</li>
                                </ul>
                            </div>
                            <div class="price-footer">
                                <a class="btn btn-custom" data-toggle="modal" data-target="#myModal">Book Now</a>
                            </div>
                        </div>
                    </div>
                    
                    <!-- Ultimate Detail -->
                    <div class="col-lg-3 col-md-6 mb-4">
                        <div class="price-item">
                            <div class="price-header">
                                <h3>Ultimate Detail</h3>
                                <h2><span>$</span><strong>19</strong><span>.99</span></h2>
                            </div>
                            <div class="price-body">
                                <ul>
                                    <li><i class="far fa-check-circle"></i>Premium Detail Included</li>
                                    <li><i class="far fa-check-circle"></i>Premium Wax Application</li>
                                    <li><i class="far fa-check-circle"></i>Headlight Restoration</li>
                                    <li><i class="far fa-check-circle"></i>Leather Conditioning</li>
                                    <li><i class="far fa-check-circle"></i>Odor Elimination</li>
                                </ul>
                            </div>
                            <div class="price-footer">
                                <a class="btn btn-custom" data-toggle="modal" data-target="#myModal">Book Now</a>
                            </div>
                        </div>
                    </div>
                    
                    <!-- Monthly Membership -->
                    <div class="col-lg-4 col-md-6 mb-4">
                        <div class="price-item">
                            <div class="price-header">
                                <h3>Monthly Basic</h3>
                                <h2><span>$</span><strong>25</strong><span>.99</span></h2>
                                <small>per month</small>
                            </div>
                            <div class="price-body">
                                <ul>
                                    <li><i class="far fa-check-circle"></i>4 Basic Washes</li>
                                    <li><i class="far fa-check-circle"></i>10% Discount on Other Services</li>
                                    <li><i class="far fa-check-circle"></i>Priority Booking</li>
                                    <li><i class="far fa-times-circle"></i>Interior Services</li>
                                    <li><i class="far fa-times-circle"></i>Premium Upgrades</li>
                                </ul>
                            </div>
                            <div class="price-footer">
                                <a class="btn btn-custom" data-toggle="modal" data-target="#myModal">Subscribe Now</a>
                            </div>
                        </div>
                    </div>
                    
                    <!-- Premium Membership -->
                    <div class="col-lg-4 col-md-6 mb-4">
                        <div class="price-item featured-item">
                            <div class="price-header">
                                <h3>Monthly Premium</h3>
                                <h2><span>$</span><strong>45</strong><span>.99</span></h2>
                                <small>per month</small>
                                <div class="featured-badge">Best Value</div>
                            </div>
                            <div class="price-body">
                                <ul>
                                    <li><i class="far fa-check-circle"></i>4 Premium Details</li>
                                    <li><i class="far fa-check-circle"></i>15% Discount on Other Services</li>
                                    <li><i class="far fa-check-circle"></i>Priority Booking</li>
                                    <li><i class="far fa-check-circle"></i>Free Wax Application</li>
                                    <li><i class="far fa-check-circle"></i>Free Odor Elimination</li>
                                </ul>
                            </div>
                            <div class="price-footer">
                                <a class="btn btn-custom" data-toggle="modal" data-target="#myModal">Subscribe Now</a>
                            </div>
                        </div>
                    </div>
                    
                    <!-- Family Plan -->
                    <div class="col-lg-4 col-md-6 mb-4">
                        <div class="price-item">
                            <div class="price-header">
                                <h3>Family Plan</h3>
                                <h2><span>$</span><strong>65</strong><span>.99</span></h2>
                                <small>per month</small>
                            </div>
                            <div class="price-body">
                                <ul>
                                    <li><i class="far fa-check-circle"></i>6 Premium Details</li>
                                    <li><i class="far fa-check-circle"></i>Up to 3 Vehicles</li>
                                    <li><i class="far fa-check-circle"></i>20% Discount on Other Services</li>
                                    <li><i class="far fa-check-circle"></i>Priority Booking</li>
                                    <li><i class="far fa-check-circle"></i>Free Interior Refresh</li>
                                </ul>
                            </div>
                            <div class="price-footer">
                                <a class="btn btn-custom" data-toggle="modal" data-target="#myModal">Subscribe Now</a>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
        <!-- Price End -->
        
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
                                    <option value="1">Basic Wash ($5.99)</option>
                                    <option value="2">Standard Wash ($7.99)</option>
                                    <option value="3">Premium Detail ($12.99)</option>
                                    <option value="4">Ultimate Detail ($19.99)</option>
                                    <option value="5">Monthly Basic ($25.99)</option>
                                    <option value="6">Monthly Premium ($45.99)</option>
                                    <option value="7">Family Plan ($65.99)</option>
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