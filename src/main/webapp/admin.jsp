<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Insert title here</title>
<link rel="stylesheet" href="styleadmin.css">
</head>
<body>
   <div class="header">
        <div class="element">
            <a class="name" href="./">Shopy Grabe</a>
        </div>
        <div class="elem">
            <a class="name" href="./addproduct.jsp">Add Products</a>
        </div>
        <div class="elem">
           <a class="name" href="./logout.jsp">Log Out</a>
        </div>
        <div class="elem">
           <a class="name" href="./viewproduct.jsp">View Product</a>
        </div>
    </div>
    <div class="user" id="used">
        <div class="users fix" id="users">
            
        </div>
        <!-- <div class="users-details fix" id="user-details">
            <!-- <strong>Select the user to show the details</strong> --  
            <h2>Order Details</h2>
            <div class="orders">
                <div class="order" id="order">
                    <strong>Name:</strong>
                    <strong>Phone No</strong>
                    <strong>City</strong>
                    <strong>Address</strong>
                    <strong>Landmark</strong>
                    <strong>Pincode</strong>
                    <strong>State</strong>
                </div>
                <div class="details" id="details">
                 
                </div>
            </div>
        </div>     -->
    </div>
</body>
<script>
    // Pass server-side session to JS variable
    var sessionUserId = '<%= session.getAttribute("id") != null ? session.getAttribute("id") : "" %>';
    var type = '<%= session.getAttribute("type") != null ? session.getAttribute("type"): "" %>';
 // This code goes in your <script> tag or login.js
    if !(sessionUserId && sessionUserId !== "" && type == "admin") {
        response.sendRedirect("login.jsp");
    }

</script>
</html>