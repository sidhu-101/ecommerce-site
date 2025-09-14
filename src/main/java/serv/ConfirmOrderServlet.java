package serv;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.sql.*;

@WebServlet("/ConfirmOrderServlet")
public class ConfirmOrderServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    public ConfirmOrderServlet() {
        super();
    }

    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        // Optional handling, typically you want to do POST only
        response.getWriter().append("Do POST method to confirm order.");
    }

    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("id") == null) {
            response.sendRedirect("login.jsp");
            return;
        }

        int userId = (int) session.getAttribute("id");
        String paymentMethod = request.getParameter("paymentMethod");
        String addressIdStr = request.getParameter("addressId");
        String totalAmountStr = request.getParameter("totalAmount");

        if (paymentMethod == null || addressIdStr == null || totalAmountStr == null) {
            response.getWriter().println("Missing payment or address information.");
            return;
        }

        int addressId;
        double totalAmount;

        try {
            addressId = Integer.parseInt(addressIdStr);
            totalAmount = Double.parseDouble(totalAmountStr);
        } catch (NumberFormatException e) {
            response.getWriter().println("Invalid numeric value.");
            return;
        }

        Connection con = null;
        PreparedStatement psOrder = null, psOrderItems = null, psCartItems = null, psClearCart = null;
        ResultSet rsCartItems = null;

        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
            con = DriverManager.getConnection("jdbc:mysql://localhost:3306/shopygrabe", "root", "sidhu#123");
            con.setAutoCommit(false);

            // Insert order
            String insertOrderSql = "INSERT INTO orders (user_id, address_id, total_amount, order_date, status, payment_method) VALUES (?, ?, ?, NOW(), ?, ?)";
            psOrder = con.prepareStatement(insertOrderSql, Statement.RETURN_GENERATED_KEYS);
            psOrder.setInt(1, userId);
            psOrder.setInt(2, addressId);
            psOrder.setDouble(3, totalAmount);
            psOrder.setString(4, "Pending");
            psOrder.setString(5, paymentMethod);
            psOrder.executeUpdate();

            ResultSet generatedKeys = psOrder.getGeneratedKeys();
            int orderId = 0;
            if (generatedKeys.next()) {
                orderId = generatedKeys.getInt(1);
            } else {
                con.rollback();
                response.getWriter().println("Failed to obtain order ID.");
                return;
            }

            // Fetch cart items
            String getCartSql = "SELECT product_id, quantity FROM cart WHERE user_id = ?";
            psCartItems = con.prepareStatement(getCartSql);
            psCartItems.setInt(1, userId);
            rsCartItems = psCartItems.executeQuery();

            // Insert order items
            String insertOrderItemSql = "INSERT INTO order_items (order_id, product_id, quantity, price) VALUES (?, ?, ?, (SELECT price FROM products WHERE id = ?))";
            psOrderItems = con.prepareStatement(insertOrderItemSql);

            while (rsCartItems.next()) {
                int productId = rsCartItems.getInt("product_id");
                int quantity = rsCartItems.getInt("quantity");
                psOrderItems.setInt(1, orderId);
                psOrderItems.setInt(2, productId);
                psOrderItems.setInt(3, quantity);
                psOrderItems.setInt(4, productId);
                psOrderItems.addBatch();
            }
            psOrderItems.executeBatch();

            // Clear user's cart
            String clearCartSql = "DELETE FROM cart WHERE user_id = ?";
            psClearCart = con.prepareStatement(clearCartSql);
            psClearCart.setInt(1, userId);
            psClearCart.executeUpdate();

            con.commit();

            // Redirect to order confirmation page with order ID
            response.sendRedirect("orderConfirmation.jsp?orderId=" + orderId);

        } catch (Exception e) {
            if (con != null) try { con.rollback(); } catch (Exception ignored) {}
            e.printStackTrace();
            response.getWriter().println("Failed to place order: " + e.getMessage());
        } finally {
            try { if (rsCartItems != null) rsCartItems.close(); } catch(Exception ignored){}
            try { if (psOrder != null) psOrder.close(); } catch(Exception ignored){}
            try { if (psOrderItems != null) psOrderItems.close(); } catch(Exception ignored){}
            try { if (psCartItems != null) psCartItems.close(); } catch(Exception ignored){}
            try { if (psClearCart != null) psClearCart.close(); } catch(Exception ignored){}
            try { if (con != null) con.close(); } catch(Exception ignored){}
        }
    }
}
