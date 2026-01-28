package controller.admin;

import dao.ProductDAO;
import dao.CategoryDAO;
import model.Product;
import model.Category;
import jakarta.servlet.*;
import jakarta.servlet.http.*;
import jakarta.servlet.annotation.*;
import java.io.IOException;
import java.io.PrintWriter;
import java.util.List;

/**
 * Servlet to seed the database with initial products
 * Access via: /admin/seed-products
 */
@WebServlet("/admin/seed-products")
public class SeedProductsServlet extends HttpServlet {

    protected void doGet(HttpServletRequest req, HttpServletResponse res)
            throws ServletException, IOException {
        
        HttpSession session = req.getSession(false);
        if (session == null || !"admin".equals(session.getAttribute("userRole"))) {
            res.sendRedirect("../login.jsp");
            return;
        }

        res.setContentType("text/html;charset=UTF-8");
        PrintWriter out = res.getWriter();
        
        out.println("<!DOCTYPE html>");
        out.println("<html><head>");
        out.println("<title>Seed Products</title>");
        out.println("<style>");
        out.println("body { font-family: Arial, sans-serif; padding: 20px; background: #f5f5f5; }");
        out.println(".container { max-width: 800px; margin: 0 auto; background: white; padding: 20px; border-radius: 8px; box-shadow: 0 2px 10px rgba(0,0,0,0.1); }");
        out.println("h1 { color: #333; }");
        out.println(".success { color: green; padding: 10px; background: #d4edda; border-radius: 4px; margin: 10px 0; }");
        out.println(".error { color: red; padding: 10px; background: #f8d7da; border-radius: 4px; margin: 10px 0; }");
        out.println(".info { color: #0c5460; padding: 10px; background: #d1ecf1; border-radius: 4px; margin: 10px 0; }");
        out.println("a { display: inline-block; margin-top: 20px; padding: 10px 20px; background: #007bff; color: white; text-decoration: none; border-radius: 4px; }");
        out.println("a:hover { background: #0056b3; }");
        out.println("</style>");
        out.println("</head><body>");
        out.println("<div class='container'>");
        out.println("<h1>🌱 Product Seeder</h1>");
        
        try {
            // Get all categories
            List<Category> categories = CategoryDAO.getAllCategories();
            out.println("<div class='info'>Found " + categories.size() + " categories in database</div>");
            
            // Create products array mapped to the local uploads
            Product[] products = {
                // Electronics
                createProduct("Laptop", "High-performance laptop with 16GB RAM", 
                    59999.00, "Electronics", "uploads/laptop.jpg", 50, "TechBrand", 4.7),
                
                createProduct("Smartphone", "Latest smartphone with 128GB storage", 
                    29999.00, "Electronics", "uploads/smartphone.jpg", 100, "TechBrand", 4.5),
                
                // Fashion/Clothing
                createProduct("T-Shirt", "Cotton t-shirt, comfortable fit", 
                    599.00, "Clothing", "uploads/tshirt.jpg", 200, "FashionBrand", 4.2),
                
                createProduct("Jeans", "Denim jeans, classic fit", 
                    1999.00, "Clothing", "uploads/jeans.jpg", 150, "FashionBrand", 4.3),
                
                // Books
                createProduct("Java Programming Book", "Complete guide to Java programming", 
                    899.00, "Books", "uploads/java-book.jpg", 75, "TechBooks", 4.6),
                
                // Home & Kitchen
                createProduct("Coffee Maker", "Automatic coffee maker", 
                    3499.00, "Home & Kitchen", "uploads/coffee-maker.jpg", 30, "HomeBrand", 4.4),
                
                // Sports
                createProduct("Football", "Professional football", 
                    999.00, "Sports", "uploads/football.jpg", 100, "SportsBrand", 4.5)
            };
            
            // Insert products
            int successCount = 0;
            int failCount = 0;
            int skipCount = 0;
            
            out.println("<h2>Inserting Products...</h2>");
            out.println("<ul>");
            
            for (Product product : products) {
                if (product != null) {
                    try {
                        if (ProductDAO.addProduct(product)) {
                            out.println("<li class='success'>✓ Added: " + product.getName() + " - ₹" + String.format("%.2f", product.getPrice()) + "</li>");
                            successCount++;
                        } else {
                            out.println("<li class='error'>✗ Failed to add: " + product.getName() + " (may already exist)</li>");
                            failCount++;
                        }
                    } catch (Exception e) {
                        out.println("<li class='error'>✗ Error adding " + product.getName() + ": " + e.getMessage() + "</li>");
                        failCount++;
                    }
                } else {
                    out.println("<li class='error'>✗ Skipped product (category not found)</li>");
                    skipCount++;
                }
            }
            
            out.println("</ul>");
            
            out.println("<h2>Summary</h2>");
            out.println("<div class='success'>Successfully added: " + successCount + " products</div>");
            if (failCount > 0) {
                out.println("<div class='error'>Failed/Skipped: " + (failCount + skipCount) + " products</div>");
            }
            
            if (successCount > 0) {
                out.println("<div class='info'>Products have been added to the database. You can view them in the <a href='products'>Manage Products</a> page.</div>");
            }
            
        } catch (Exception e) {
            out.println("<div class='error'>Error during seeding: " + e.getMessage() + "</div>");
            out.println("<pre>");
            e.printStackTrace(out);
            out.println("</pre>");
        }
        
        out.println("<a href='products'>← Back to Manage Products</a>");
        out.println("<a href='dashboard.jsp' style='margin-left: 10px;'>← Back to Dashboard</a>");
        out.println("</div>");
        out.println("</body></html>");
        out.close();
    }
    
    private Product createProduct(String name, String description, double price, 
                                  String categoryName, String imageUrl, int stock, 
                                  String brand, double rating) {
        try {
            // Find category by name
            List<Category> categories = CategoryDAO.getAllCategories();
            Integer categoryId = null;
            
            for (Category cat : categories) {
                if (cat.getName().equalsIgnoreCase(categoryName)) {
                    categoryId = cat.getId();
                    break;
                }
            }
            
            if (categoryId == null) {
                return null;
            }
            
            Product product = new Product();
            product.setName(name);
            product.setDescription(description);
            product.setPrice(price);
            product.setCategoryId(categoryId);
            product.setImageUrl(imageUrl);
            product.setStock(stock);
            product.setBrand(brand);
            product.setRating(rating);
            
            return product;
        } catch (Exception e) {
            return null;
        }
    }
}
