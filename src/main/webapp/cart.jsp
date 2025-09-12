<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" import="java.sql.*,java.util.*" %>
<%
    Integer userId = (Integer) session.getAttribute("id");
    if (userId == null) {
        response.sendRedirect("login.jsp");
        return;
    }

    Connection con = null;
    PreparedStatement ps = null;
    ResultSet rs = null;
    double totalPrice = 0;

%>
<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="UTF-8" />
<meta name="viewport" content="width=device-width, initial-scale=1" />
<title>Shopy Grabe Cart</title>
<link rel="stylesheet" href="style.css" />
<style>
.table-cart {
    width: 100%;
    border-collapse: collapse;
}
.table-cart th, .table-cart td {
    border: 1px solid #ccc;
    padding: 10px;
    text-align: left;
}
.table-cart img {
    max-width: 80px;
    max-height: 80px;
    object-fit: cover;
}
.delete-button {
    background-color: #f44336;
    color: white;
    border: none;
    padding: 6px 10px;
    cursor: pointer;
    border-radius: 4px;
}
.delete-button:hover {
    background-color: #d32f2f;
}
.purchace_button {
    margin-top: 20px;
    font-size: 1.2em;
}
</style>
</head>
<body>
<div class="header">
    <!-- header here -->
</div>

<div class="cart">
<%
    try {
        Class.forName("com.mysql.cj.jdbc.Driver");
        con = DriverManager.getConnection("jdbc:mysql://localhost:3306/shopygrabe","root","230625");

        String cartSql = "SELECT c.product_id, c.quantity, p.name, p.price, p.image_path " + 
                         "FROM cart c JOIN products p ON c.product_id = p.id " + 
                         "WHERE c.user_id = ?";
        ps = con.prepareStatement(cartSql);
        ps.setInt(1, userId);
        rs = ps.executeQuery();

        if (!rs.isBeforeFirst()) {
%>
            <p>Your cart is empty.</p>
<%
        } else {
%>
<table class="table-cart">
    <thead>
        <tr>
            <th>Image</th>
            <th>Product Name</th>
            <th>Quantity</th>
            <th>Price (each)</th>
            <th>Total</th>
            <th>Action</th>
        </tr>
    </thead>
    <tbody>
<%
            while(rs.next()) {
                int productId = rs.getInt("product_id");
                String productName = rs.getString("name");
                int quantity = rs.getInt("quantity");
                double price = rs.getDouble("price");
                String imgPath = rs.getString("image_path");
                double totalItemPrice = price * quantity;
                totalPrice += totalItemPrice;
%>
        <tr data-productid="<%= productId %>">
            <td><img src="<%= imgPath %>" alt="<%= productName %>"></td>
            <td><%= productName %></td>
            <td><%= quantity %></td>
            <td>₹<%= String.format("%.2f", price) %></td>
            <td>₹<%= String.format("%.2f", totalItemPrice) %></td>
            <td>
                <form action="RemoveFromCartServlet" method="post" onsubmit="return confirm('Remove this item from cart?');">
                    <input type="hidden" name="productId" value="<%= productId %>"/>
                    <button type="submit" class="delete-button">Delete</button>
                </form>
            </td>
        </tr>
<%
            }
%>
    </tbody>
</table>
<div class="purchace_button">
    <strong>Total Price: ₹<span id="total-price"><%= String.format("%.2f", totalPrice) %></span></strong>
    <form action="BuyNowServlet" method="post" style="display:inline;">
        <button type="submit" id="buy_now">Buy Now</button>
    </form>
</div>
<%
        }
    } catch(Exception e) {
        out.println("Error loading cart: " + e.getMessage());
        e.printStackTrace();
    } finally {
        if (rs != null) try { rs.close(); } catch(Exception ignored) {}
        if (ps != null) try { ps.close(); } catch(Exception ignored) {}
        if (con != null) try { con.close(); } catch(Exception ignored) {}
    }
%>
</div>

<script type="module" src="https://cdn.jsdelivr.net/npm/ionicons@7.1.0/dist/ionicons/ionicons.esm.js"></script>
<script nomodule src="https://cdn.jsdelivr.net/npm/ionicons@7.1.0/dist/ionicons/ionicons.js"></script>
<script type="module" src="script/searchinput.js"></script>

</body>
</html>
