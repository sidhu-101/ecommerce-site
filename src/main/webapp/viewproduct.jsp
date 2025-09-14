<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="java.sql.*, java.util.*" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>View Products</title>
<style>
  .product {
    border: 1px solid #ccc;
    margin: 10px;
    padding: 10px;
    width: 250px;
    float: left;
  }
  .product img {
    max-width: 100%;
    height: auto;
  }
</style>
</head>
<body>
<h1>All Products</h1>
<div>
<%
    String url = "jdbc:mysql://localhost:3306/shopygrabe";
    String user = "root";
    String password = "sidhu#123";

    try {
        Class.forName("com.mysql.cj.jdbc.Driver");
        Connection con = DriverManager.getConnection(url, user, password);
        Statement stmt = con.createStatement();
        // Select id also for deletion use
        String sql = "SELECT id, name, price, category, details, image_path FROM products";
        ResultSet rs = stmt.executeQuery(sql);

        while (rs.next()) {
            int id = rs.getInt("id");
            String name = rs.getString("name");
            String price = rs.getString("price");
            String category = rs.getString("category");
            String details = rs.getString("details");
            String imgPath = rs.getString("image_path");
%>
    <div class="product">
        <img src="<%= imgPath %>" alt="<%= name %> image" />
        <h3><%= name %></h3>
        <p>Price: ₹<%= price %></p>
        <p>Category: <%= category %></p>
        <p>Details: <%= details %></p>
        <form action="DeleteProductServlet" method="post" onsubmit="return confirm('Are you sure to delete this product?');">
            <input type="hidden" name="id" value="<%= id %>" />
            <input type="submit" value="Delete" />
        </form>
    </div>
<%
        }
        rs.close();
        stmt.close();
        con.close();
    } catch (Exception e) {
        out.println("Error: " + e.getMessage());
    }
%>
</div>
</body>
</html>
