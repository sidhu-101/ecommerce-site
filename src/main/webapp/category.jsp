<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8" import="java.sql.*" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8" />
<title>Shopy Grabe - Products by Category</title>
<link rel="stylesheet" href="style.css" />
<style>
.product-container {
    margin-top: 70px;
    display: flex;
    flex-wrap: wrap;
    gap: 20px;
}
.product-item {
    border: 1px solid #ccc;
    border-radius: 6px;
    width: 220px;
    text-align: center;
    padding: 10px;
    box-sizing: border-box;
}
.product-item img {
    width: 200px;
    height: 200px;
    object-fit: contain;
    margin-bottom: 8px;
}
.product-name {
    font-weight: bold;
    font-size: 1.1em;
    margin-bottom: 5px;
}
.product-price {
    color: #388e3c;
    font-weight: bold;
    margin-bottom: 8px;
}
.product-category {
    font-size: 0.9em;
    color: #777;
}
</style>
</head>
<body>
   <div class="header">
        <div class="element">
            <a class="name" href="./">Shopy Grabe</a>
        </div>
        <div class="element">
            <ion-icon name="search" class="search_icon"></ion-icon>
            <input type="search" name="search" id="search" placeholder="Search for Products, Brands and More" />
            <ion-icon name="close" class="clear_icon"></ion-icon>
        </div>
        <a href="profile.jsp" class="element" id="profile">
            <ion-icon name="person-circle-outline" class="login_icon"></ion-icon>
            <label id="login_label">Profile</label>
        </a>
        <a href="cart.jsp" class="element" id="cart">
            <ion-icon name="cart-outline"></ion-icon>
            <label id="login_label">Cart</label>
        </a>
        <a href="login.jsp" class="element" id="login">
            <ion-icon name="person-circle-outline" class="login_icon"></ion-icon>
            <label id="login_label">Login</label>
        </a>
    </div>
    <div class="product-container">
    <%
        String inputType = request.getParameter("type");
        String filterType = (inputType != null && !inputType.trim().isEmpty()) ? inputType.trim().toLowerCase() : "phone";

        Connection conn = null;
        PreparedStatement ps = null;
        ResultSet rs = null;

        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
            conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/shopygrabe", "root", "230625");

            // Use LOWER for case-insensitive match in SQL
            String sql = "SELECT id, name, price, image_path, category FROM products WHERE LOWER(category) = ? ORDER BY name";
            ps = conn.prepareStatement(sql);
            ps.setString(1, filterType);
            rs = ps.executeQuery();

            boolean found = false;
            while (rs.next()) {
                found = true;
                int id = rs.getInt("id");
                String name = rs.getString("name");
                double price = rs.getDouble("price");
                String image = rs.getString("image_path");
                String category = rs.getString("category");
    %>
        <div class="product-item">
            <a href="productDetails.jsp?id=<%=id%>">
                <img src="<%= (image != null && !image.isEmpty()) ? image : "images/default.png" %>" alt="<%=name%>" />
                <div class="product-name"><%=name%></div>
                <div class="product-price">₹<%=price%></div>
                <div class="product-category"><small><em><%=category%></em></small></div>
            </a>
        </div>
    <%
            }
            if (!found) {
    %>
        <p>No products found for category '<%= filterType %>'.</p>
    <%
            }
        } catch (Exception e) {
            out.println("<p>Error loading products: " + e.getMessage() + "</p>");
            e.printStackTrace();
        } finally {
            if (rs != null) try { rs.close(); } catch (Exception ignore) {}
            if (ps != null) try { ps.close(); } catch (Exception ignore) {}
            if (conn != null) try { conn.close(); } catch (Exception ignore) {}
        }
    %>
    </div>

<script type="module" src="https://cdn.jsdelivr.net/npm/ionicons@7.1.0/dist/ionicons/ionicons.esm.js"></script>
<script nomodule src="https://cdn.jsdelivr.net/npm/ionicons@7.1.0/dist/ionicons/ionicons.js"></script>
<script>
    var sessionUserId = '<%= session.getAttribute("id") != null ? session.getAttribute("id") : "" %>';
    var typeUser = '<%= session.getAttribute("type") != null ? session.getAttribute("type") : "" %>';
    if (sessionUserId && sessionUserId !== "" && typeUser === "user") {
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
