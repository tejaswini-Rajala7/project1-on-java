package controller.admin;

import dao.ProductDAO;
import dao.CategoryDAO;
import model.Product;
import jakarta.servlet.*;
import jakarta.servlet.http.*;
import jakarta.servlet.annotation.*;
import java.io.IOException;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.util.UUID;

@WebServlet("/admin/products")
@MultipartConfig
public class AdminProductServlet extends HttpServlet {

    protected void doGet(HttpServletRequest req, HttpServletResponse res)
            throws ServletException, IOException {

        HttpSession session = req.getSession(false);
        if (session == null || !"admin".equals(session.getAttribute("userRole"))) {
            res.sendRedirect("../login.jsp");
            return;
        }

        String action = req.getParameter("action");
        if ("edit".equals(action)) {
            int productId = Integer.parseInt(req.getParameter("id"));
            Product product = ProductDAO.getProductById(productId);
            req.setAttribute("product", product);
            req.setAttribute("categories", CategoryDAO.getAllCategories());
            req.getRequestDispatcher("../admin/product-form.jsp").forward(req, res);
        } else if ("add".equals(action)) {
            req.setAttribute("categories", CategoryDAO.getAllCategories());
            req.getRequestDispatcher("../admin/product-form.jsp").forward(req, res);
        } else {
            req.setAttribute("products", ProductDAO.getAllProducts());
            req.getRequestDispatcher("../admin/products.jsp").forward(req, res);
        }
    }

    protected void doPost(HttpServletRequest req, HttpServletResponse res)
            throws ServletException, IOException {

        HttpSession session = req.getSession(false);
        if (session == null || !"admin".equals(session.getAttribute("userRole"))) {
            res.sendRedirect("../login.jsp");
            return;
        }

        String action = req.getParameter("action");
        if ("add".equals(action)) {
            Product product = buildProductFromRequest(req, null);
            if (ProductDAO.addProduct(product)) {
                res.sendRedirect("products?success=added");
            } else {
                res.sendRedirect("products?error=add");
            }
        } else if ("update".equals(action)) {
            int productId = Integer.parseInt(req.getParameter("id"));
            Product existing = ProductDAO.getProductById(productId);
            Product product = buildProductFromRequest(req, existing);
            product.setId(productId);

            if (ProductDAO.updateProduct(product)) {
                res.sendRedirect("products?success=updated");
            } else {
                res.sendRedirect("products?error=update");
            }
        } else if ("delete".equals(action)) {
            int productId = Integer.parseInt(req.getParameter("id"));
            if (ProductDAO.deleteProduct(productId)) {
                res.sendRedirect("products?success=deleted");
            } else {
                res.sendRedirect("products?error=delete");
            }
        }
    }

    private Product buildProductFromRequest(HttpServletRequest req, Product existing) throws IOException, ServletException {
        Product product = new Product();
        product.setName(req.getParameter("name"));
        product.setDescription(req.getParameter("description"));
        product.setPrice(Double.parseDouble(req.getParameter("price")));
        product.setCategoryId(Integer.parseInt(req.getParameter("categoryId")));
        product.setStock(Integer.parseInt(req.getParameter("stock")));
        product.setBrand(req.getParameter("brand"));

        String imageUrlParam = req.getParameter("imageUrl");
        String uploadedPath = handleImageUpload(req);
        String finalImage = uploadedPath;
        if ((finalImage == null || finalImage.isEmpty()) && imageUrlParam != null && !imageUrlParam.isEmpty()) {
            finalImage = imageUrlParam;
        }
        if ((finalImage == null || finalImage.isEmpty()) && existing != null) {
            finalImage = existing.getImageUrl();
        }
        product.setImageUrl(finalImage);
        return product;
    }

    private String handleImageUpload(HttpServletRequest req) throws IOException, ServletException {
        Part imagePart = req.getPart("imageFile");
        if (imagePart == null || imagePart.getSize() == 0) {
            return null;
        }

        String submitted = Paths.get(imagePart.getSubmittedFileName()).getFileName().toString();
        String ext = "";
        int dot = submitted.lastIndexOf('.');
        if (dot > -1) {
            ext = submitted.substring(dot).toLowerCase();
        }
        String safeName = "prod-" + UUID.randomUUID() + ext;

        String uploadDir = req.getServletContext().getRealPath("/uploads");
        Path uploadPath = Paths.get(uploadDir);
        if (!Files.exists(uploadPath)) {
            Files.createDirectories(uploadPath);
        }

        Path destination = uploadPath.resolve(safeName);
        imagePart.write(destination.toString());
        return "uploads/" + safeName;
    }
}
