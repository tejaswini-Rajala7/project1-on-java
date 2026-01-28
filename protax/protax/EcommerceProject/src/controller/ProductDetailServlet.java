package controller;

import dao.ProductDAO;
import dao.ReviewDAO;
import model.Product;
import jakarta.servlet.*;
import jakarta.servlet.http.*;
import jakarta.servlet.annotation.*;
import java.io.IOException;

@WebServlet("/product-detail")
public class ProductDetailServlet extends HttpServlet {
    protected void doGet(HttpServletRequest req, HttpServletResponse res)
            throws ServletException, IOException {
        
        // Set UTF-8 encoding to prevent rupee symbol corruption
        res.setContentType("text/html; charset=UTF-8");
        res.setCharacterEncoding("UTF-8");
        req.setCharacterEncoding("UTF-8");

        try {
            int productId = Integer.parseInt(req.getParameter("id"));
            Product product = ProductDAO.getProductById(productId);
            
            if (product != null) {
                req.setAttribute("product", product);
                req.setAttribute("reviews", ReviewDAO.getReviewsByProduct(productId));
                req.getRequestDispatcher("product-detail.jsp").forward(req, res);
            } else {
                res.sendRedirect("ProductServlet");
            }
        } catch (Exception e) {
            res.sendRedirect("ProductServlet");
        }
    }
}
