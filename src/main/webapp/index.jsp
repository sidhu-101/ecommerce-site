<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8" import="java.sql.*" %>
<%
    // Use implicit session object; do not redeclare
    String sessionName = null;
    if (session != null && session.getAttribute("id") != null) {
        sessionName = (String) session.getAttribute("name");
    }
%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Shopy Grabe</title>
<link rel="stylesheet" href="style.css">
<style>
/* Add this CSS or put in style.css */
.product-list {
    display: flex;
    flex-wrap: wrap;
    gap: 20px;
    justify-content: flex-start;
    margin-top: 20px;
}

.product {
    flex: 1 1 250px;
    max-width: 250px;
    box-sizing: border-box;
    border: 1px solid #ccc;
    padding: 10px;
    background: #fafafa;
    border-radius: 5px;
    transition: box-shadow 0.3s ease;
}

.product:hover {
    box-shadow: 0 0 10px rgba(0,0,0,0.2);
}

.product img {
    max-width: 100%;
    height: auto;
    display: block;
    margin-bottom: 10px;
}

.section-title {
    margin-bottom: 20px;
}
</style>
</head>
<body>
  <div class="header" id="header">
        <div class="element">
            <a class="name" href="./">Shopy Grabe</a>
        </div>
        <div class="element">
            <ion-icon name="search" class="search_icon"></ion-icon>
            <input type="search" name="search" id="search" placeholder="Search for Products, Brands and More">
            <ion-icon name="close" class="clear_icon"></ion-icon>
        </div>
        <a href="profile.jsp" class="element" id="profile" style="display:none;">
            <ion-icon name="person-circle-outline" class="login_icon"></ion-icon>
            <label id="login_label">Profile</label>
        </a>
        <a href="cart.jsp" class="element" id="cart" style="display:none;">
            <ion-icon name="cart-outline" class="login_icon"></ion-icon>
            <label id="login_label">Cart</label>
        </a>
        <a href="login.jsp" class="element" id="login">
            <ion-icon name="person-circle-outline" class="login_icon"></ion-icon>
            <label id="login_label">Login</label>
        </a>
    </div>

  <div class="category">
        <!-- Your category anchors unchanged -->
        <a href="category.jsp?type=grocery" class="category_list">
            <img src="Category/grocery.png">
            <label class="category_label">Grocery</label>
        </a>
        <a href="category.jsp?type=Mobile" class="category_list">
            <img src="Category/phone.png">
            <label class="category_label">Mobiles</label>
        </a>
        <a href="category.jsp?type=fashion" class="category_list">
            <img src="Category/fashion.png">
            <label class="category_label">Fashion</label>
        </a>
        <a href="category.jsp?type=electronics" class="category_list">
            <img src="Category/electronic.png">
            <label class="category_label">Electronic</label>
        </a>
        <a href="category.jsp?type=furniture" class="category_list">
            <img src="Category/furniture.png" id="home">
            <label class="category_label">Home and Furniture</label>
        </a>
        <a href="category.jsp?type=appliance" class="category_list">
            <img src="Category/appliance.png" id="appliance">
            <label class="category_label">Appliances</label>
        </a>
        <a href="category.jsp?type=toys" class="category_list">
            <img src="Category/toys.png" id="toy">
            <label class="category_label">Beauty, Toys and More</label>
        </a>
        <a href="category.jsp?type=bike" class="category_list">
            <img src="Category/bike.png" id="bike">
            <label class="category_label">Two Wheelers</label>
        </a>
    </div>

    <div class="container">
       <div class="body slider-container">
        <div class="body slids">
            <img src="slides/grocery.jpg" alt="">
            <img src="slides/phone.jpg" alt="">
            <img src="slides/fashion.jpeg" alt="">
            <img src="slides/furniture.jpg" alt="">
            <img src="slides/computer.jpg" alt="">
        </div>
    </div>

        <div class="product-section" id="product-section">
        <h2 class="section-title">Featured Products</h2>
        <div class="product-list" id="product-list">
            <%
                String url = "jdbc:mysql://localhost:3306/shopygrabe";
                String user = "root";
                String password = "sidhu#123";

                try {
                    Class.forName("com.mysql.cj.jdbc.Driver");
                    Connection con = DriverManager.getConnection(url, user, password);
                    Statement stmt = con.createStatement();
                    String sql = "SELECT id, name, price, category, details, image_path FROM products";
                    ResultSet rs = stmt.executeQuery(sql);

                    while (rs.next()) {
                        int pid = rs.getInt("id");
                        String pname = rs.getString("name");
                        String pprice = rs.getString("price");
                        String pcategory = rs.getString("category");
                        String pdetails = rs.getString("details");
                        String pimgPath = rs.getString("image_path");
            %>
            <div class="product">
                <img src="<%= pimgPath %>" alt="<%= pname %>">
                <a href="productDetails.jsp?id=<%= pid %>" class="product-name-link"><h3><%= pname %></h3></a>
                <p>Price: ₹<%= pprice %></p>
            </div>
            <%
                    }
                    rs.close();
                    stmt.close();
                    con.close();
                } catch (Exception e) {
                    out.println("Error loading products: " + e.getMessage());
                }
            %>
        </div>
    </div>
  </div>

<script type="module" src="https://cdn.jsdelivr.net/npm/ionicons@7.1.0/dist/ionicons/ionicons.esm.js"></script>
<script nomodule src="https://cdn.jsdelivr.net/npm/ionicons@7.1.0/dist/ionicons/ionicons.js"></script>

<script>
    // Pass server-side session to JS variable
    var sessionUserId = '<%= session.getAttribute("id") != null ? session.getAttribute("id") : "" %>';
    var type = '<%= session.getAttribute("type") != null ? session.getAttribute("type"): "" %>';
    if (sessionUserId && sessionUserId !== "" && type == "user") {
        document.getElementById('profile').style.display = "block";
        document.getElementById('cart').style.display = "block";
        document.getElementById('login').style.display = "none";
    } else {
        document.getElementById('profile').style.display = "none";
        document.getElementById('cart').style.display = "none";
        document.getElementById('login').style.display = "block";
    }
</script>
</body>
</html>
