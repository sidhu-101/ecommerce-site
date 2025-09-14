package serv;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.sql.*;

@WebServlet("/AddToWishlistServlet")
public class AddToWishlistServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    public AddToWishlistServlet() {
        super();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        // You can choose to redirect GET requests to product listing or show error
        response.sendRedirect("index.jsp");
    }

    @Override
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
                        "jdbc:mysql://localhost:3306/shopygrabe", "root", "sidhu#123")) {

                // Check if the product is already in wishlist
                try (PreparedStatement checkStmt = con.prepareStatement(
                        "SELECT COUNT(*) FROM wishlist WHERE user_id = ? AND product_id = ?")) {

                    checkStmt.setInt(1, userId);
                    checkStmt.setInt(2, productId);
                    ResultSet rs = checkStmt.executeQuery();
                    if (rs.next() && rs.getInt(1) > 0) {
                        // Already in wishlist, redirect without adding again
                        rs.close();
                        response.sendRedirect("productDetails.jsp?id=" + productId);
                        return;
                    }
                    rs.close();
                }

                // Insert into wishlist
                try (PreparedStatement insertStmt = con.prepareStatement(
                        "INSERT INTO wishlist (user_id, product_id) VALUES (?, ?)")) {

                    insertStmt.setInt(1, userId);
                    insertStmt.setInt(2, productId);
                    insertStmt.executeUpdate();
                }
            }

            // Redirect back to the product details page
            response.sendRedirect("productDetails.jsp?id=" + productId);
        } catch (Exception e) {
            e.printStackTrace();
            response.getWriter().println("Error adding to wishlist: " + e.getMessage());
        }
    }
}
