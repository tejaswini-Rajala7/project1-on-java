package controller;

import dao.ProductDAO;
import dao.CategoryDAO;
import model.Category;
import jakarta.servlet.*;
import jakarta.servlet.http.*;
import jakarta.servlet.annotation.*;
import java.io.IOException;

@WebServlet("/ProductServlet")
public class ProductServlet extends HttpServlet {
    protected void doGet(HttpServletRequest req, HttpServletResponse res)
            throws ServletException, IOException {

        String searchTerm = req.getParameter("q");
        Integer category = parseInt(req.getParameter("category"));
        Double minPrice = parseDouble(req.getParameter("minPrice"));
        Double maxPrice = parseDouble(req.getParameter("maxPrice"));
        Double rating = parseDouble(req.getParameter("rating"));
        int page = parseInt(req.getParameter("page")) != null ? parseInt(req.getParameter("page")) : 1;
        if (page < 1) page = 1;
        int pageSize = 9;
        int offset = (page - 1) * pageSize;

        req.setAttribute("products", ProductDAO.searchProductsWithFilters(
                searchTerm, category, minPrice, maxPrice, rating, offset, pageSize));

        int totalCount = ProductDAO.countProductsWithFilters(searchTerm, category, minPrice, maxPrice, rating);
        int totalPages = (int) Math.ceil(totalCount / (double) pageSize);
        if (totalPages < 1) totalPages = 1;

        req.setAttribute("categories", CategoryDAO.getAllCategories());
        req.setAttribute("searchTerm", searchTerm);
        req.setAttribute("category", category);
        req.setAttribute("minPrice", minPrice);
        req.setAttribute("maxPrice", maxPrice);
        req.setAttribute("rating", rating);
        req.setAttribute("page", page);
        req.setAttribute("totalPages", totalPages);
        
        // Get category name if filtering by category
        if (category != null) {
            Category cat = CategoryDAO.getCategoryById(category);
            if (cat != null) {
                req.setAttribute("categoryName", cat.getName());
            }
        }
        
        req.getRequestDispatcher("products.jsp").forward(req, res);
    }

    private Integer parseInt(String val) {
        try {
            if (val == null || val.isEmpty()) return null;
            return Integer.parseInt(val);
        } catch (NumberFormatException e) {
            return null;
        }
    }

    private Double parseDouble(String val) {
        try {
            if (val == null || val.isEmpty()) return null;
            return Double.parseDouble(val);
        } catch (NumberFormatException e) {
            return null;
        }
    }
}
