<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<%


    String productIdStr = request.getParameter("id");
    if (productIdStr == null) {
        response.sendRedirect("index.jsp"); // or product list page
        return;
    }
    
    int productId = Integer.parseInt(productIdStr);
    String name="", price="", category="", details="", imgPath="";
    
    try {
        Class.forName("com.mysql.cj.jdbc.Driver");
        Connection con = DriverManager.getConnection("jdbc:mysql://localhost:3306/shopygrabe", "root", "sidhu#123");
        PreparedStatement ps = con.prepareStatement("SELECT * FROM products WHERE id=?");
        ps.setInt(1, productId);
        ResultSet rs = ps.executeQuery();
        if (rs.next()) {
            name = rs.getString("name");
            price = rs.getString("price");
            category = rs.getString("category");
            details = rs.getString("details");
            imgPath = rs.getString("image_path");
        } else {
            response.sendRedirect("index.jsp"); // Product not found
            return;
        }
        rs.close();
        ps.close();
        con.close();
    } catch(Exception e) {
        out.println("Database Error: " + e.getMessage());
    }
%>

<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title><%= name %> - Shopy Grabe</title>
<link rel="stylesheet" href="style.css">
<style>
   /* Overall Body */
body.product_body {
    font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
    background: #f7f8fa;
    margin: 0;
    padding: 0;
    color: #333;
}

/* Product Details Wrapper */
.product_details_descriptionpart {
    display: flex;
    gap: 50px;
    max-width: 1100px;
    margin: 40px auto;
    padding: 0 20px;
}

/* Left Column - Image + Icons + Buttons */
.product_item_column {
    flex: 1;
    max-width: 420px;
    background: white;
    padding: 20px;
    border-radius: 10px;
    box-shadow: 0 2px 15px rgba(0,0,0,0.1);
}

.items img#product_img {
    width: 100%;
    border-radius: 8px;
    display: block;
    margin-bottom: 15px;
}

/* Wishlist Icon */
#wishlist {
    font-size: 40px;
    color: #888;
    cursor: pointer;
    margin-bottom: 20px;
    transition: color 0.3s ease;
}

#wishlist:hover {
    color: #e91e63;
}

/* Buttons container */
.items2 {
    display: flex;
    justify-content: space-between;
    gap: 15px;
    margin-top: 10px;
}

.items2 form {
    flex: 1;
    margin: 0;
}

.items2 button {
    width: 100%;
    padding: 12px 15px;
    font-size: 16px;
    font-weight: 600;
    border-radius: 6px;
    border: none;
    cursor: pointer;
    color: white;
    transition: background-color 0.3s ease, transform 0.15s ease;
    box-shadow: 0 2px 6px rgba(0,0,0,0.15);
}

#add_to_wishlist {
    background-color: #e91e63;
}

#add_to_wishlist:hover {
    background-color: #c2185b;
    transform: translateY(-2px);
}

#add_to_cart {
    background-color: #007bff;
}

#add_to_cart:hover {
    background-color: #0056b3;
    transform: translateY(-2px);
}

#buy_now {
    background-color: #28a745;
}

#buy_now:hover {
    background-color: #1e7e34;
    transform: translateY(-2px);
}

/* Right Column - Product Info */
.product_details_column {
    flex: 2;
    background: white;
    border-radius: 10px;
    padding: 30px 35px;
    box-shadow: 0 2px 15px rgba(0,0,0,0.1);
}

.product_details_column h1 {
    font-size: 2.5rem;
    margin-top: 0;
    color: #222;
}

.product_details_column h2 {
    font-size: 1.8rem;
    color: #28a745;
    margin-top: 10px;
    margin-bottom: 25px;
}

.product_details_column h3 {
    margin-top: 20px;
    margin-bottom: 8px;
    font-weight: 700;
    color: #333;
}

.product_details_column p {
    line-height: 1.6;
    font-size: 1rem;
    color: #555;
}

/* Responsive Design */
@media (max-width: 900px) {
    .product_details_descriptionpart {
        flex-direction: column;
        margin: 20px;
    }
    .product_item_column,
    .product_details_column {
        max-width: 100%;
    }
    .items2 {
        flex-direction: column;
    }
    .items2 form {
        margin-bottom: 15px;
    }
    .items2 button {
        width: 100%;
    }
}
   
</style>
</head>
<body class="product_body">
    <div class="header">
    <div class="element">
            <a class="name" href="./">Shopy Grabe</a>
        </div>
        <div class="element">
            <ion-icon name="search" class="search_icon"></ion-icon>
            <input type="search" name="search" id="search" placeholder="Search for Products, Brands and More">
            <ion-icon name="close" class="clear_icon"></ion-icon>
        </div>
        <a href="profile.html" class="element" id="profile">
            <ion-icon name="person-circle-outline" class="login_icon"></ion-icon>
            <label id="login_label">Profile</label>
        </a>
        <a href="cart.html" class="element" id="cart">
            <ion-icon name="cart-outline"></ion-icon>
            <label id="login_label">Cart</label>
        </a>
        <!-- <a href="login.html" class="element" id="login">
            <ion-icon name="person-circle-outline" class="login_icon"></ion-icon>
            <label id="login_label">Login</label>
        </a> -->
    </div>
    <div class="product_details_descriptionpart">
       <div class="product_item_column">
        <div class="items">
            <img src="<%= imgPath %>" alt="<%= name %>" id="product_img">
            <ion-icon name="heart-circle-outline" id="wishlist"></ion-icon>
        </div>
        <div class="items2">

           <!-- Form to add product to wishlist -->
           <form action="AddToWishlistServlet" method="post" style="display:inline;">
               <input type="hidden" name="productId" value="<%= productId %>">
               <button type="submit" id="add_to_wishlist">Add to Wishlist</button>
           </form>

           <!-- Form to buy/add product to cart -->
           <form action="AddToCartServlet" method="post" style="display:inline;">
               <input type="hidden" name="productId" value="<%= productId %>">
               <button type="submit" id="add_to_cart">Add to Cart</button>
           </form>

           <form action="Buynow.jsp" method="post" style="display:inline;">
               <input type="hidden" name="productId" value="<%= productId %>">
               <button type="submit" id="buy_now">Buy Now</button>
           </form>

        </div>
       </div>
       <div class="product_details_column">
         <h1 id="product_name"><%= name %></h1>
         <h2 id="product_price">₹<%= price %></h2>
         <div id="product_description">
            <h3>Category</h3>
            <p><%= category %></p>
            <h3>Description</h3>
            <p><%= details %></p>
         </div>
       </div>
    </div>
    <script type="module" src="https://cdn.jsdelivr.net/npm/ionicons@7.1.0/dist/ionicons/ionicons.esm.js"></script>
    <script nomodule src="https://cdn.jsdelivr.net/npm/ionicons@7.1.0/dist/ionicons/ionicons.js"></script>
</body>
</html>
