package serv;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.MultipartConfig;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.Part;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.File;
import java.io.IOException;
import java.nio.file.Paths;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;

/**
 * Servlet implementation class AddProductServlet
 */
@WebServlet("/AddProductServlet")
@MultipartConfig
public class AddProductServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    public AddProductServlet() {
        super();
    }

    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String name = request.getParameter("name");
        String price = request.getParameter("price");
        String category = request.getParameter("category");
        String details = request.getParameter("details");

        // Handle file upload
        Part filePart = request.getPart("productImage");
        String fileName = Paths.get(filePart.getSubmittedFileName()).getFileName().toString();

        String uploadPath = getServletContext().getRealPath("") + File.separator + "product image";
        File uploadDir = new File(uploadPath);
        if (!uploadDir.exists()) uploadDir.mkdir();

        String savedFilePath = uploadPath + File.separator + fileName;
        filePart.write(savedFilePath);
        String imgPath = "product image/" + fileName;

        // Insert product details and image path into MySQL
        try {
            // Load JDBC Driver (adjust if using another driver)
            Class.forName("com.mysql.cj.jdbc.Driver");
            Connection con = DriverManager.getConnection(
                "jdbc:mysql://localhost:3306/shopygrabe", "root", "sidhu#123");
            String query = "INSERT INTO products (name, price, category, details, image_path) VALUES (?, ?, ?, ?, ?)";
            PreparedStatement ps = con.prepareStatement(query);
            ps.setString(1, name);
            ps.setString(2, price);
            ps.setString(3, category);
            ps.setString(4, details);
            ps.setString(5, imgPath);

            int row = ps.executeUpdate();
            if (row > 0) {
                response.sendRedirect("success.jsp");
            } else {
                response.getWriter().println("Failed to insert product!");
            }
        } catch (Exception e) {
            e.printStackTrace();
            response.getWriter().println("Database Insert Error: " + e.getMessage());
        }
    }

    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.getWriter().append("Served at: ").append(request.getContextPath());
    }
}
