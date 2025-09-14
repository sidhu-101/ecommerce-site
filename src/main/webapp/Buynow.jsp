<%@ page import="java.sql.*" %>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%
    String productid = request.getParameter("productId");

    Object idObj = session.getAttribute("id");
    String userId = null;
    if(idObj != null) {
        userId = idObj.toString();
    }
    String username = (String) session.getAttribute("name");

    String phone = "";
    StringBuilder addressOptions = new StringBuilder();
    StringBuilder productDetailsHTML = new StringBuilder();

    if(userId != null) {
        Connection conn = null;
        PreparedStatement psUser = null, psAddr = null, psProduct = null;
        ResultSet rsUser = null, rsAddr = null, rsProduct = null;
        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
            conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/shopygrabe", "root", "sidhu#123");

            String sqlUser = "SELECT phone FROM User WHERE id = ?";
            psUser = conn.prepareStatement(sqlUser);
            psUser.setString(1, userId);
            rsUser = psUser.executeQuery();
            if(rsUser.next()) {
                phone = rsUser.getString("phone");
            }

            String sqlAddr = "SELECT id, name, number, pincode, locality, address, city, state, landmark, alt_phone FROM Address WHERE user_id = ?";
            psAddr = conn.prepareStatement(sqlAddr);
            psAddr.setString(1, userId);
            rsAddr = psAddr.executeQuery();

            boolean firstAddress = true;
            while(rsAddr.next()) {
                int addrId = rsAddr.getInt("id");
                String addrName = rsAddr.getString("name");
                String addrNumber = rsAddr.getString("number");
                String pincode = rsAddr.getString("pincode");
                String locality = rsAddr.getString("locality");
                String addrText = rsAddr.getString("address");
                String city = rsAddr.getString("city");
                String state = rsAddr.getString("state");
                String landmark = rsAddr.getString("landmark");
                String altPhone = rsAddr.getString("alt_phone");

                addressOptions.append("<div class='address_option'>");
                addressOptions.append("<input type='radio' name='delivery_address' id='addr_" + addrId + "' value='" + addrId + "'");
                if(firstAddress) {
                    addressOptions.append(" checked");
                    firstAddress = false;
                }
                addressOptions.append(">");
                addressOptions.append("<label for='addr_" + addrId + "'><strong>" + addrName + "</strong><br>");
                addressOptions.append(addrText + ", " + (locality != null ? locality : "") + "<br>");
                if(landmark != null && !landmark.trim().isEmpty()) {
                    addressOptions.append("Landmark: " + landmark + "<br>");
                }
                addressOptions.append(city + ", " + state + " - " + pincode + "<br>");
                addressOptions.append("Phone: " + addrNumber);
                if(altPhone != null && !altPhone.trim().isEmpty()) {
                    addressOptions.append(", Alt Phone: " + altPhone);
                }
                addressOptions.append("</label>");
                addressOptions.append("</div>");
            }

            if(productid != null && !productid.trim().isEmpty()) {
                String sqlProduct = "SELECT name, details, price FROM products WHERE id = ?";
                psProduct = conn.prepareStatement(sqlProduct);
                psProduct.setString(1, productid);
                rsProduct = psProduct.executeQuery();
                if(rsProduct.next()) {
                    String productName = rsProduct.getString("name");
                    String productDetails = rsProduct.getString("details");
                    double price = rsProduct.getDouble("price");

                    productDetailsHTML.append("<div class='product_detail'>");
                    productDetailsHTML.append("<h3>Product: " + productName + "</h3>");
                    productDetailsHTML.append("<p>" + productDetails + "</p>");
                    productDetailsHTML.append("<p>Price: ₹" + price + "</p>");
                    productDetailsHTML.append("</div>");
                } else {
                    productDetailsHTML.append("<p>Product details not found.</p>");
                }
            } else {
                productDetailsHTML.append("<p>No product selected.</p>");
            }

        } catch(Exception e) {
            e.printStackTrace();
        } finally {
            if(rsUser != null) try { rsUser.close(); } catch(Exception ignored) {}
            if(psUser != null) try { psUser.close(); } catch(Exception ignored) {}
            if(rsAddr != null) try { rsAddr.close(); } catch(Exception ignored) {}
            if(psAddr != null) try { psAddr.close(); } catch(Exception ignored) {}
            if(rsProduct != null) try { rsProduct.close(); } catch(Exception ignored) {}
            if(psProduct != null) try { psProduct.close(); } catch(Exception ignored) {}
            if(conn != null) try { conn.close(); } catch(Exception ignored) {}
        }
    }
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1" />
    <title>Shopy Grabe : Secure Payment</title>
    <link rel="stylesheet" href="style.css" />
    <style>
        .address_option {
            margin-bottom: 10px;
            padding: 8px;
            border: 1px solid #ccc;
            border-radius: 5px;
        }
        .address_option input[type="radio"] {
            margin-right: 10px;
        }
        .product_detail {
            border: 1px solid #ccc;
            padding: 10px;
            margin-bottom: 15px;
            border-radius: 5px;
        }
        .but {
            margin-top: 20px;
        }
    </style>
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
                    <h2>Name: <%= username != null ? username : "Guest" %></h2>
                    <h2>Phone NO: <%= phone %></h2>
                </div>
            </div>

            <form action="PlaceOrderServlet" method="post">
                <div class="address_selection marg" id="address_selector" style="display:block;">
                    <h1>Delivery Address</h1>
                    <%= addressOptions.toString() %>
                </div>

                <div class="item_shop marg" id="item_shop">
                    <h1>ORDER SUMMARY</h1>
                    <%= productDetailsHTML.toString() %>
                </div>

                <div class="payment_pg marg" id="payment_pg" style="display:block;">
                    <h1>Payment Options</h1>
                    <div class="payment-options">
                        <div class="opt">
                            <input type="radio" id="upi" name="payment_method" value="upi" required />
                            <label for="upi">UPI</label>
                        </div>
                        <div class="opt">
                            <input type="radio" id="card" name="payment_method" value="card" required />
                            <label for="card">Card</label>
                        </div>
                        <div class="opt">
                            <input type="radio" id="cod" name="payment_method" value="cod" required />
                            <label for="cod">Cash on Delivery</label>
                        </div>
                    </div>
                </div>

                <input type="hidden" name="product_id" value="<%= productid %>" />
                <input type="hidden" name="quantity" value="1" />

                <div class="but" style="margin-top: 20px;">
                    <button type="submit">Confirm Order</button>
                </div>
            </form>

        </div>
    </div>
</body>
<%
    if(session == null || session.getAttribute("id") == null) {
        response.sendRedirect("login.jsp");
        return;
    }
%>

</html>
