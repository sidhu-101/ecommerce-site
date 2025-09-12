<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8" import="java.sql.*" %>
<%
    Integer userId = (Integer) session.getAttribute("id");
    if (userId == null) {
        response.sendRedirect("login.jsp");
        return;
    }

    String userName = "";
    String userPhone = "";
    int orderId = 0;
    if (request.getParameter("orderId") != null) {
        try {
            orderId = Integer.parseInt(request.getParameter("orderId"));
        } catch (NumberFormatException e) {
            orderId = 0;
        }
    }

    Connection con = null;
    PreparedStatement ps = null;
    ResultSet rs = null;

    StringBuilder deliveryAddressesHtml = new StringBuilder();
    StringBuilder orderSummaryHtml = new StringBuilder();
    double totalAmount = 0;

    try {
        Class.forName("com.mysql.cj.jdbc.Driver");
        con = DriverManager.getConnection("jdbc:mysql://localhost:3306/shopygrabe", "root", "230625");

        // Fetch user name and phone
        ps = con.prepareStatement("SELECT name, phone FROM User WHERE id = ?");
        ps.setInt(1, userId);
        rs = ps.executeQuery();
        if (rs.next()) {
            userName = rs.getString("name");
            userPhone = rs.getString("phone");
        }
        rs.close();
        ps.close();

        // Fetch user delivery addresses with radio buttons
        ps = con.prepareStatement("SELECT id, name, number, address, city, state, pincode FROM Address WHERE user_id = ?");
        ps.setInt(1, userId);
        rs = ps.executeQuery();
        while (rs.next()) {
            deliveryAddressesHtml.append("<label style='display:block; margin-bottom: 10px;'>")
                .append("<input type='radio' name='addressId' value='").append(rs.getInt("id")).append("' required> ")
                .append("<strong>").append(rs.getString("name")).append("</strong>, ")
                .append(rs.getString("address")).append(", ")
                .append(rs.getString("city")).append(", ")
                .append(rs.getString("state")).append(" - ")
                .append(rs.getString("pincode")).append(", Phone: ")
                .append(rs.getString("number"))
                .append("</label>");
        }
        rs.close();
        ps.close();

        // Fetch order summary if orderId present
        if (orderId > 0) {
            ps = con.prepareStatement(
                "SELECT oi.quantity, oi.price, p.name FROM order_items oi JOIN products p ON oi.product_id = p.id WHERE oi.order_id = ?");
            ps.setInt(1, orderId);
            rs = ps.executeQuery();
            orderSummaryHtml.append("<ul style='padding-left: 20px;'>");
            while (rs.next()) {
                int quantity = rs.getInt("quantity");
                double price = rs.getDouble("price");
                String productName = rs.getString("name");
                double itemTotal = price * quantity;
                totalAmount += itemTotal;

                orderSummaryHtml.append("<li>")
                    .append(productName)
                    .append(" - Qty: ").append(quantity)
                    .append(" - ₹").append(String.format("%.2f", itemTotal))
                    .append("</li>");
            }
            orderSummaryHtml.append("</ul>");
            rs.close();
            ps.close();
        }

        con.close();
    } catch (Exception e) {
        e.printStackTrace();
    }
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Shopy Grabe : Secure Payment</title>
    <link rel="stylesheet" href="style.css">
</head>
<body>
    <div class="header">
        <div class="element">
            <a class="name" href="./">Shopy Grabe</a>
        </div>
    </div>
    <div class="payable">
        <div class="payment_page">
            <div class="personal_details marg">
                <h1>LOGIN</h1>
                <div class="details">
                    <h2>Name: <%= userName %></h2> 
                    <h2>Phone NO: <%= userPhone %></h2>
                </div>
            </div>

            <form method="post" action="ConfirmOrderServlet">
                <div class="address_selection marg" id="address_selected">
                    <h1>Select Delivery Address</h1>
                    <%= deliveryAddressesHtml.toString() %>
                </div>

                <div class="item_shop marg" id="item_shop">
                    <h1>ORDER SUMMARY</h1>
                    <%= orderSummaryHtml.toString() %>
                    <strong>Total Amount: ₹<%= String.format("%.2f", totalAmount) %></strong>
                    <input type="hidden" name="totalAmount" value="<%= totalAmount %>" />
                </div>

                <div class="payment_pg marg" id="payment_pg">
                    <h1>Payment Options</h1>
                    <div class="payment-options">
                        <div class="opt">
                            <input type="radio" id="upi" name="paymentMethod" value="UPI" required>
                            <label for="upi">UPI</label>
                        </div>
                        <div class="opt">
                            <input type="radio" id="card" name="paymentMethod" value="Card" required>
                            <label for="card">Card</label>
                        </div>
                        <div class="opt">
                            <input type="radio" id="cod" name="paymentMethod" value="COD" required>
                            <label for="cod">Cash on Delivery</label>
                        </div>
                    </div>
                </div>

                <div class="but" style="margin-top: 20px;">
                    <button type="submit" id="order">Confirm Order</button>
                </div>
            </form>
        </div>
        <div class="price_card" id="price_card">
        </div>
    </div>
    <div class="loading" id="loading">
        <div class="loader"></div>
    </div>
</body>
<script type="module" src="Server_config/payment.js"></script>
</html>
