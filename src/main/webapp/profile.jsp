<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8" import="java.sql.*,java.util.*"%>
<%
  Integer userId = (Integer) session.getAttribute("id");

  if (userId == null) {
      response.sendRedirect("login.jsp");
      return;
  }

  String errorMsg = null;
  String successMsg = null;

  // Handle delete order if requested
  if ("POST".equalsIgnoreCase(request.getMethod()) && request.getParameter("delete_order_id") != null) {
      String deleteOrderIdStr = request.getParameter("delete_order_id");
      try {
          int deleteOrderId = Integer.parseInt(deleteOrderIdStr);

          Class.forName("com.mysql.cj.jdbc.Driver");
          try (Connection conDel = DriverManager.getConnection("jdbc:mysql://localhost:3306/shopygrabe", "root", "230625")) {

              // Delete order items first due to FK constraints
              try (PreparedStatement psDelItems = conDel.prepareStatement("DELETE FROM order_items WHERE order_id = ?")) {
                  psDelItems.setInt(1, deleteOrderId);
                  psDelItems.executeUpdate();
              }

              // Then delete order record, ensuring ownership by user
              try (PreparedStatement psDelOrder = conDel.prepareStatement("DELETE FROM orders WHERE id = ? AND user_id = ?")) {
                  psDelOrder.setInt(1, deleteOrderId);
                  psDelOrder.setInt(2, userId);
                  int rowsDeleted = psDelOrder.executeUpdate();
                  if(rowsDeleted > 0) {
                      successMsg = "Order deleted successfully!";
                  } else {
                      errorMsg = "Order not found or unauthorized to delete.";
                  }
              }
          }
      } catch (Exception e) {
          errorMsg = "Failed to delete order: " + e.getMessage();
          e.printStackTrace();
      }
  }

  String name = "", email = "", phone = "";
  Connection con = null;
  PreparedStatement ps = null;
  ResultSet rs = null;

  try {
      Class.forName("com.mysql.cj.jdbc.Driver");
      con = DriverManager.getConnection("jdbc:mysql://localhost:3306/shopygrabe", "root", "230625");

      // Load user details
      ps = con.prepareStatement("SELECT name, email, phone FROM User WHERE id = ?");
      ps.setInt(1, userId);
      rs = ps.executeQuery();
      if (rs.next()) {
          name = rs.getString("name");
          email = rs.getString("email");
          phone = rs.getString("phone");
      }
      rs.close();
      ps.close();

  } catch (Exception e) {
      errorMsg = "Failed to load user details: " + e.getMessage();
      e.printStackTrace();
  }
%>

<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Profile</title>
<link rel="stylesheet" href="style.css">
<style>
  .form {
    display: inline;
    margin: 0;
    padding: 0;
  }
  .form button {
    background-color: transparent;
    border: none;
    cursor: pointer;
    font-size: 1.2rem;
    color: #f44336;
    padding: 5px;
    transition: color 0.3s ease;
  }
  .form button:hover {
    color: #d32f2f;
  }
  .add_con1 {
    display: flex;
    align-items: center;
    gap: 10px;
  }
  .add_con1 strong {
    font-weight: bold;
  }
  .add_con1 label {
    margin-right: 10px;
  }
  .wishlist-item {
  display: flex;
  align-items: center;
  border: 1px solid #ccc;
  padding: 10px;
  margin-bottom: 10px;
  border-radius: 6px;
  gap: 15px;
}
.wishlist-item img {
  border-radius: 5px;
}
.wishlist-details h3 {
  margin: 0 0 5px;
}
.wishlist-details a {
  text-decoration: none;
  color: #007bff;
}
.wishlist-details a:hover {
  text-decoration: underline;
}
.order-block {
  margin-bottom: 20px; 
  border: 1px solid #ccc; 
  padding: 15px; 
  border-radius: 5px;
}
.order-items ul {
  margin-left: 20px;
  font-size: 0.9em;
  padding-left: 20px;
}
.delete-order-btn {
  background-color:#f44336; 
  color:white; 
  border:none; 
  padding:5px 10px; 
  border-radius:3px; 
  cursor:pointer;
  margin-top: 10px;
}
</style>
</head>
<body>

<script>
  window.onload = function() {
    <% if (successMsg != null) { %>
      alert('<%= successMsg.replaceAll("'", "\\\'") %>');
    <% } %>
    <% if (errorMsg != null) { %>
      alert('<%= errorMsg.replaceAll("'", "\\\'") %>');
    <% } %>
  };
</script>

<div class="header">
  <div class="element">
      <a class="name" href="./">Shopy Grabe</a>
  </div>
  <div class="element">
      <ion-icon name="search" class="search_icon"></ion-icon>
      <input type="search" name="search" id="search" placeholder="Search for Products, Brands and More">
      <ion-icon name="close" class="clear_icon"></ion-icon>
  </div>
  <a href="./" class="element" id="profile">
      <ion-icon name="home" class="login_icon"></ion-icon>
      <label id="login_label">Home</label>
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

<div class="profile-section">
  <div class="col1">
    <div class="profile_name">
      <h2>Hello</h2>
      <h1 id="profile_name"><%=name%></h1>
    </div>
    <div class="user_details_list">
      <h2><a href="orders.jsp">My Orders</a> ></h2>
      <div class="account_details">
        <h2 class="set" id="account-setting"><ion-icon name="person-sharp"></ion-icon>Account Settings</h2>
        <h2 id="profile_information" class="set set_data">Profile information</h2>
        <h2 id="manage_address" class="set set_data">Manage Address</h2>
      </div>
    </div>
    <div class="user_details_list">
      <h2 class="set" id="wishlist"><ion-icon name="heart"></ion-icon>My wishlist</h2>
    </div>
    <div class="user_details_list">
      <h2 class="set" id="orders">My Orders</h2>
    </div>
    <div class="user_details_list">
      <a href="logout.jsp" class="set" id="logout"><ion-icon name="log-out-outline"></ion-icon>Logout</a>
    </div>
  </div>
  
  <div class="col2" id="profile-detail">
    <h1 class="h">User Name <button class="edit" id="edit-name">Edit</button></h1>
    <div class="con">
      <input type="text" name="name" id="name" value="<%=name %>" disabled> 
      <button type="submit" class="save" id="save-name">Save</button>
    </div>

    <h1 class="h">Email Address<button class="edit" id="edit-email">Edit</button></h1>
    <div class="con">
      <input type="text" name="email" id="email" value="<%=email %>" disabled> 
      <button type="submit" class="save" id="save-email">Save</button>
    </div>

    <h1 class="h">Phone NO<button class="edit" id="edit-phone">Edit</button></h1>
    <div class="con">
      <input type="text" name="phone" id="phoneno" value="<%=phone %>" disabled> 
      <button type="submit" class="save" id="save-phone">Save</button>
    </div>
  </div>

  <div class="col2" id="manage_add">
    <button type="submit" class="add_address" id="add_address">
      <strong>Add Address</strong> 
      <ion-icon name="add-outline"></ion-icon>
    </button>
    <div class="address_holder" id="address_holder">
      <%
        if(userId != null) {
          try {
            Class.forName("com.mysql.cj.jdbc.Driver");
            con = DriverManager.getConnection("jdbc:mysql://localhost:3306/shopygrabe", "root", "230625");

            String sql = "SELECT id, name, number, email, address, landmark, city, state, pincode FROM Address WHERE user_id = ?";
            ps = con.prepareStatement(sql);
            ps.setInt(1, userId);
            rs = ps.executeQuery();

            while (rs.next()) {
      %>
      <div class="add_con">
        <div class="add_con1">
          <strong><%= rs.getString("name") %></strong> 
          <label><%= rs.getString("number") %></label> 
          <form class="form" action="profile.jsp" method="post" onsubmit="return confirm('Are you sure you want to delete this address?');">
            <input type="hidden" name="delete_id" value="<%= rs.getInt("id") %>"/>
            <button type="submit" title="Delete Address">
              <ion-icon name="close-outline"></ion-icon>
            </button>
          </form>
        </div>
        <div class="add_con2">
          <label><%= rs.getString("email") %></label>
        </div>
        <div class="add_con2">
          <label><%= rs.getString("address") %></label>
          <label><%= rs.getString("landmark") %></label>
          <label><%= rs.getString("city") %></label>
          <label><%= rs.getString("state") %></label>
          <label><%= rs.getString("pincode") %></label>
        </div>
      </div>
      <%
            }

            rs.close();
            ps.close();
            con.close();
          } catch(Exception e) {
            e.printStackTrace();
          }
        }
      %>
    </div>
  </div>

<div class="col2" id="fav">
  <h1>Wishlist</h1>
  <div class="fav-items" id="fav-items">
    <%
      if (userId != null) {
        try {
          Class.forName("com.mysql.cj.jdbc.Driver");
          Connection conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/shopygrabe", "root", "230625");
          String wishlistSql = "SELECT p.id, p.name, p.price, p.image_path FROM wishlist w JOIN products p ON w.product_id = p.id WHERE w.user_id = ?";
          PreparedStatement wishlistPs = conn.prepareStatement(wishlistSql);
          wishlistPs.setInt(1, userId);
          ResultSet wishlistRs = wishlistPs.executeQuery();

          while (wishlistRs.next()) {
            int productId = wishlistRs.getInt("id");
            String productName = wishlistRs.getString("name");
            String productPrice = wishlistRs.getString("price");
            String productImage = wishlistRs.getString("image_path");
    %>
        <div class="wishlist-item">
          <img src="<%=productImage%>" alt="<%=productName%>" style="width:100px;height:100px;object-fit:cover;">
          <div class="wishlist-details">
            <h3><a href="productDetails.jsp?id=<%=productId%>"><%= productName %></a></h3>
            <p>Price: ₹<%= productPrice %></p>
          </div>
        </div>
    <%
          }
          wishlistRs.close();
          wishlistPs.close();
          conn.close();
        } catch (Exception e) {
          out.println("Error loading wishlist: " + e.getMessage());
          e.printStackTrace();
        }
      }
    %>
  </div>
</div>

  <div class="col2" id="order">
    <h1>My Orders</h1>
    <div class="order" id="myorders">
    <%
        Connection connOrders = null;
        PreparedStatement psOrders = null;
        PreparedStatement psItems = null;
        ResultSet rsOrders = null;
        ResultSet rsItems = null;

        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
            connOrders = DriverManager.getConnection("jdbc:mysql://localhost:3306/shopygrabe", "root", "230625");

            String orderSql = "SELECT id, order_date, status, payment_method, total_amount FROM orders WHERE user_id = ? ORDER BY order_date DESC";
            psOrders = connOrders.prepareStatement(orderSql);
            psOrders.setInt(1, userId);
            rsOrders = psOrders.executeQuery();

            while(rsOrders.next()) {
                int orderId = rsOrders.getInt("id");
                Timestamp orderDate = rsOrders.getTimestamp("order_date");
                String status = rsOrders.getString("status");
                String paymentMethod = rsOrders.getString("payment_method");
                double totalAmount = rsOrders.getDouble("total_amount");
    %>
        <div class="order-block">
            <h3>Order ID: <%= orderId %></h3>
            <p><strong>Date:</strong> <%= orderDate %></p>
            <p><strong>Status:</strong> <%= status %></p>
            <p><strong>Payment Method:</strong> <%= paymentMethod %></p>
            <p><strong>Total Amount:</strong> ₹<%= totalAmount %></p>
            <h4>Items:</h4>
            <ul class="order-items">
                <%
                    String itemsSql = "SELECT oi.quantity, oi.price, p.name FROM order_items oi JOIN products p ON oi.product_id = p.id WHERE oi.order_id = ?";
                    psItems = connOrders.prepareStatement(itemsSql);
                    psItems.setInt(1, orderId);
                    rsItems = psItems.executeQuery();
                    while(rsItems.next()) {
                        String prodName = rsItems.getString("name");
                        int qty = rsItems.getInt("quantity");
                        double price = rsItems.getDouble("price");
                %>
                    <li><%= prodName %> — Quantity: <%= qty %>, Price per unit: ₹<%= price %></li>
                <%
                    }
                    rsItems.close();
                    psItems.close();
                %>
            </ul>
            <form method="post" action="profile.jsp" onsubmit="return confirm('Are you sure you want to delete this order?');" style="margin-top:10px;">
                <input type="hidden" name="delete_order_id" value="<%= orderId %>" />
                <button type="submit" class="delete-order-btn">Delete Order</button>
            </form>
        </div>
    <%
            }
        } catch(Exception e) {
            out.println("Failed to load orders: " + e.getMessage());
            e.printStackTrace();
        } finally {
            if(rsOrders != null) try { rsOrders.close(); } catch(Exception ignored) {}
            if(psOrders != null) try { psOrders.close(); } catch(Exception ignored) {}
            if(connOrders != null) try { connOrders.close(); } catch(Exception ignored) {}
        }
    %>
    </div>
  </div>
</div>

<div class="add_address_pannel" id="add_address_pannel" style="display:none;">
  <!-- Address add form here as per your original code -->
  <!-- ... -->
</div>

<div class="loading" id="loading">
  <div class="loader"></div>
</div>

<script type="module" src="https://cdn.jsdelivr.net/npm/ionicons@7.1.0/dist/ionicons/ionicons.esm.js"></script>
<script nomodule src="https://cdn.jsdelivr.net/npm/ionicons@7.1.0/dist/ionicons/ionicons.js"></script>
<script type="module" src="javascript/profile.js"></script>

<script>
    var sessionUserId = '<%= userId %>';
    var type = '<%= session.getAttribute("type") != null ? session.getAttribute("type") : "" %>';

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
