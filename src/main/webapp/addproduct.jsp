<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Add Product - Shopy Grabe</title>
<link rel="stylesheet" href="styleadmi.css">
</head>
<body>
   <h1>Shopy Grabe Add Product Panel</h1>
   <form action="AddProductServlet" method="post" enctype="multipart/form-data">
      <div class="body">
         <div class="part1">
            <img src="" alt="" id="display_image" style="display:none;width:200px;height:200px;margin-bottom:10px;">
            <input type="file" name="productImage" id="product_image" required>
            <br><br>
            <input type="submit" value="Submit" id="submit">
         </div>
         <div class="part2">
            <input type="text" name="name" id="product_name" placeholder="Enter Product Name" required>
            <input type="number" name="price" id="product_price" placeholder="Enter Product Price" required>
            <select name="category" id="product_category" required>
                <option value="Grocery">Grocery</option>
                <option value="Mobiles">Mobiles</option>
                <option value="Fashion">Fashion</option>
                <option value="Electronics">Electronics</option>
                <option value="Home & Furniture">Home and Furniture</option>
                <option value="Appliances">Appliances</option>
                <option value="Beauty Toys & More">Beauty Toys and More</option>
                <option value="Two Wheelers">Two Wheelers</option>
            </select>
            <textarea name="details" id="details" placeholder="Enter Product Other Details" required></textarea>
         </div>
      </div>
   </form>
   <div class="load" id="load">
      <div class="loader"></div>
   </div>
   <%
    if(session.getAttribute("id")==null || !"admin".equals(""+session.getAttribute("type"))) {
        response.sendRedirect("login.jsp");
    }
   %>
</body>
<script>
// Image preview
var display_image = document.getElementById("display_image");
document.getElementById("product_image").addEventListener('change', function(event) {
    if (event.target.files && event.target.files) {
        var selectedFile = event.target.files;
        var reader = new FileReader();
        reader.onload = function(e) {
            display_image.src = e.target.result;
            display_image.style.display = 'block';
        };
        reader.readAsDataURL(selectedFile);
    }
});
</script>
</html>
