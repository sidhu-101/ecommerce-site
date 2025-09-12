package serv;

import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import jakarta.servlet.ServletException;
import java.io.IOException;
import java.sql.*;

@WebServlet("/AddToCartServlet")
public class AddToCartServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    public AddToCartServlet() {
        super();
    }

    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        // Redirect GET to profile or product list to prevent direct GET usage
        response.sendRedirect("index.jsp");
    }

    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("id") == null) {
            // User not logged in, redirect to login page
            response.sendRedirect("login.jsp");
            return;
        }

        int userId = (int) session.getAttribute("id");
        String productIdStr = request.getParameter("productId");
        if (productIdStr == null || productIdStr.trim().isEmpty()) {
            response.sendRedirect("index.jsp");
            return;
        }

        int productId;
        try {
            productId = Integer.parseInt(productIdStr);
        } catch (NumberFormatException e) {
            response.sendRedirect("index.jsp");
            return;
        }

        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
            try (Connection con = DriverManager.getConnection(
                        "jdbc:mysql://localhost:3306/shopygrabe", "root", "230625")) {

                // Check if product already in cart
                try (PreparedStatement checkStmt = con.prepareStatement(
                        "SELECT quantity FROM cart WHERE user_id = ? AND product_id = ?")) {

                    checkStmt.setInt(1, userId);
                    checkStmt.setInt(2, productId);
                    ResultSet rs = checkStmt.executeQuery();

                    if (rs.next()) {
                        int currentQty = rs.getInt("quantity");
                        rs.close();

                        // Update quantity by 1
                        try (PreparedStatement updateStmt = con.prepareStatement(
                                "UPDATE cart SET quantity = ? WHERE user_id = ? AND product_id = ?")) {
                            updateStmt.setInt(1, currentQty + 1);
                            updateStmt.setInt(2, userId);
                            updateStmt.setInt(3, productId);
                            updateStmt.executeUpdate();
                        }
                    } else {
                        rs.close();

                        // Insert new record with quantity 1
                        try (PreparedStatement insertStmt = con.prepareStatement(
                                "INSERT INTO cart (user_id, product_id, quantity) VALUES (?, ?, ?)")) {
                            insertStmt.setInt(1, userId);
                            insertStmt.setInt(2, productId);
                            insertStmt.setInt(3, 1);
                            insertStmt.executeUpdate();
                        }
                    }
                }
            }

            // Redirect back to the product details or cart page
            response.sendRedirect("cart.jsp");
        } catch (Exception e) {
            e.printStackTrace();
            response.getWriter().println("Error adding to cart: " + e.getMessage());
        }
    }
}
