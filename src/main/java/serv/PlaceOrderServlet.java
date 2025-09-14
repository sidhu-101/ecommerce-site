package serv;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.sql.*;
import java.math.BigDecimal;

@WebServlet("/PlaceOrderServlet")
public class PlaceOrderServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    public PlaceOrderServlet() {
        super();
    }

    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        response.getWriter().append("Served at: ").append(request.getContextPath());
    }

    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        if(session == null || session.getAttribute("id") == null) {
            response.sendRedirect("login.jsp");
            return;
        }
        String userId = session.getAttribute("id").toString();

        String addressIdStr = request.getParameter("delivery_address");
        String paymentMethod = request.getParameter("payment_method");
        String productIdStr = request.getParameter("product_id");
        String quantityStr = request.getParameter("quantity");

        if(addressIdStr == null || paymentMethod == null || productIdStr == null || quantityStr == null) {
            response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Missing order parameters.");
            return;
        }

        int addressId = Integer.parseInt(addressIdStr);
        int productId = Integer.parseInt(productIdStr);
        int quantity = Integer.parseInt(quantityStr);

        try (Connection conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/shopygrabe", "root", "sidhu#123")) {
            conn.setAutoCommit(false);

            BigDecimal price = BigDecimal.ZERO;
            try (PreparedStatement psPrice = conn.prepareStatement("SELECT price FROM products WHERE id = ?")) {
                psPrice.setInt(1, productId);
                try (ResultSet rs = psPrice.executeQuery()) {
                    if(rs.next()) {
                        price = rs.getBigDecimal("price");
                    } else {
                        throw new SQLException("Product not found.");
                    }
                }
            }

            BigDecimal totalAmount = price.multiply(new BigDecimal(quantity));

            String insertOrderSQL = "INSERT INTO orders (user_id, address_id, total_amount, status, payment_method) VALUES (?, ?, ?, ?, ?)";
            int orderId = -1;
            try (PreparedStatement psOrder = conn.prepareStatement(insertOrderSQL, Statement.RETURN_GENERATED_KEYS)) {
                psOrder.setString(1, userId);
                psOrder.setInt(2, addressId);
                psOrder.setBigDecimal(3, totalAmount);
                psOrder.setString(4, "Pending");
                psOrder.setString(5, paymentMethod);
                psOrder.executeUpdate();
                try(ResultSet generatedKeys = psOrder.getGeneratedKeys()) {
                    if(generatedKeys.next()) {
                        orderId = generatedKeys.getInt(1);
                    } else {
                        throw new SQLException("Creating order failed, no ID obtained.");
                    }
                }
            }

            String insertItemSQL = "INSERT INTO order_items (order_id, product_id, quantity, price) VALUES (?, ?, ?, ?)";
            try (PreparedStatement psItem = conn.prepareStatement(insertItemSQL)) {
                psItem.setInt(1, orderId);
                psItem.setInt(2, productId);
                psItem.setInt(3, quantity);
                psItem.setBigDecimal(4, price);
                psItem.executeUpdate();
            }

            conn.commit();

            // Redirect to home after order placement
            response.sendRedirect("index.jsp");

        } catch(Exception e) {
            e.printStackTrace();
            response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, "Failed to place order.");
        }
    }
}
