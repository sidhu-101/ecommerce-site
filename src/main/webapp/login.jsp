<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8" import="java.sql.*" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Shopy Grabe - Login</title>
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
        <a href="register.jsp" class="element" id="login">
            <ion-icon name="person-circle-outline" class="login_icon"></ion-icon>
            <label id="login_label">Sign Up</label>
        </a>
    </div>
    <div class="login-page">
      <div class="login-image">
        <h2>Login</h2>
        <div class="box">
          <label class="log-label">Login to get access to your order, wishlist and recommendations</label>
        </div>
        <img src="logo.jpeg" alt="Logo">
      </div>
      <div class="login-content" id="login-element">

        <%
            String message = "";
            if ("POST".equalsIgnoreCase(request.getMethod())) {
                String email = request.getParameter("email");
                String password = request.getParameter("password");

                if (email == null || password == null || email.isEmpty() || password.isEmpty()) {
                    message = "Please enter both email and password.";
                } else {
                    Connection con = null;
                    PreparedStatement stmt = null;
                    ResultSet rs = null;
                    try {
                        Class.forName("com.mysql.cj.jdbc.Driver");
                        con = DriverManager.getConnection("jdbc:mysql://localhost:3306/shopygrabe", "root", "sidhu#123");

                        String sql = "SELECT id, name, type FROM User WHERE email = ? AND password = ?";
                        stmt = con.prepareStatement(sql);
                        stmt.setString(1, email);
                        stmt.setString(2, password); // Password should be hashed in production!

                        rs = stmt.executeQuery();

                        if (rs.next()) {
                            // Authentication successful
                            int id = rs.getInt("id");
                            String name = rs.getString("name");
                            String type = rs.getString("type");

                            // Ensure session is created before setting attributes
                            if (session == null) {
                                session = request.getSession(true);
                            }
                            session.setAttribute("id", id);
                            session.setAttribute("name", name);
                            session.setAttribute("type", type);

                            // Redirect after login success
                            if ("user".equals(type)) {
                                response.sendRedirect("index.jsp");
                            } else if ("admin".equals(type)) {
                                response.sendRedirect("admin.jsp");
                            } else {
                                message = "Unknown user type.";
                            }
                            return;
                        } else {
                            message = "Invalid email or password.";
                        }
                    } catch (Exception e) {
                        message = "Error: " + e.getMessage();
                    } finally {
                        if (rs != null) try { rs.close(); } catch(Exception ignored) {}
                        if (stmt != null) try { stmt.close(); } catch(Exception ignored) {}
                        if (con != null) try { con.close(); } catch(Exception ignored) {}
                    }
                }
            }

            if (!message.isEmpty()) {
        %>
            <div id="errortext" style="color: red;"><%= message %></div>
        <%
            }
        %>

        <form class="login-form" action="" method="post">
            <label for="email" class="_label">Enter Email Id: </label>
            <input type="email" name="email" id="email" required>

            <label for="password" class="_label password">Enter Password: </label>
            <input type="password" name="password" id="password" required>

            <button type="submit" id="signin">Login</button>
        </form>

        <div class="signup_link">
            <a href="register.jsp">New to Shopy Grabe? Create an account</a>
        </div>
      </div>
    </div>

<script type="module" src="javascript/login.js"></script>
</body>
</html>