<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8" import="java.sql.*" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Shopy Grabe Signup</title>
<link rel="stylesheet" href="style.css">
</head>
<body>
   <div class="header">
        <div class="element">
            <a class="name" href="./">Shopy Grabe</a>
        </div>
        <div class="element">
            <ion-icon name="search" class="search_icon"></ion-icon>
            <input type="text" name="search" id="search" placeholder="Search for Products, Brands and More" readonly>
            <ion-icon name="close" class="clear_icon"></ion-icon>
        </div>
        <a href="login.jsp" class="element" id="login">
            <ion-icon name="person-circle-outline" class="login_icon"></ion-icon>
            <label id="login_label">Login Up</label>
        </a>
    </div>

    <div class="login-page">
      <div class="login-image">
        <h2>Signup</h2>
        <div class="box">
            <label class="log-label">Signup to get access to your order, wishlist and recommendations</label>
        </div>
        <img src="logo.jpeg" alt="Logo">
      </div>
      <div class="login-content" id="signup-element">

        <%
            String message = "";
            if ("POST".equalsIgnoreCase(request.getMethod())) {
                String name = request.getParameter("name");
                String phoneno = request.getParameter("number");
                String email = request.getParameter("email");
                String password = request.getParameter("password");
                String confirmPassword = request.getParameter("confirmpassword");

                if (password == null || !password.equals(confirmPassword)) {
                    message = "Passwords do not match.";
                } else {
                    Connection con = null;
                    PreparedStatement stmt = null;
                    try {
                        // Generate a random 8-digit User ID
                        int userId = 10000000 + (int)(Math.random() * 90000000);

                        Class.forName("com.mysql.cj.jdbc.Driver");
                        con = DriverManager.getConnection("jdbc:mysql://localhost:3306/shopygrabe", "root", "sidhu#123");

                        // Table must have columns: id, name, phone, email, password
                        String sql = "INSERT INTO User (id, name, phone, email, password, type) VALUES (?, ?, ?, ?, ?, ?)";
                        stmt = con.prepareStatement(sql);
                        stmt.setInt(1, userId);
                        stmt.setString(2, name);
                        stmt.setString(3, phoneno);
                        stmt.setString(4, email);
                        stmt.setString(5, password); 
                        stmt.setString(6, "user");  // Note: hash password for production

                        int row = stmt.executeUpdate();
                        if (row > 0) {
                            message = "Signup successful! <br>Your User ID is: " + userId;
                        } else {
                            message = "Signup failed";
                        }
                    } catch (Exception e) {
                        message = "Error: " + e.getMessage();
                    } finally {
                        if (stmt != null) try { stmt.close(); } catch (Exception ignored) {}
                        if (con != null) try { con.close(); } catch (Exception ignored) {}
                    }
                }
            }

            if (!message.isEmpty()) {
        %>
            <div id="errortext" style="color: red;"><%= message %></div>
        <%
            }
        %>

        <form class="login-form signup-form" action="" method="post">
            <label for="name" class="_label">Enter name:</label>
            <input type="text" name="name" id="name" required>

            <label for="phoneno" class="_label password">Enter Phone no:</label>
            <input type="number" name="number" id="phoneno" required>

            <label for="email" class="_label password">Enter Email Id:</label>
            <input type="email" name="email" id="email-signup" required>

            <label for="password" class="_label password">Enter Password:</label>
            <input type="password" name="password" id="password-signup" required>

            <label for="confirmpassword" class="_label password">Confirm Password:</label>
            <input type="password" name="confirmpassword" id="confirmpassword-signup" required>

            <button type="submit" id="signup">Signup</button>
        </form>
      </div>
    </div>

<script type="module" src="javascript/login.js"></script>
</body>
</html>
