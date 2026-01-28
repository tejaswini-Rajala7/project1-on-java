package controller;

import dao.CartDAO;
import jakarta.servlet.*;
import jakarta.servlet.http.*;
import jakarta.servlet.annotation.*;
import java.io.IOException;

@WebServlet("/cart")
public class CartServlet extends HttpServlet {

    // View cart items
    protected void doGet(HttpServletRequest req, HttpServletResponse res)
            throws ServletException, IOException {

        HttpSession session = req.getSession(false);

        if (session == null || session.getAttribute("userId") == null) {
            res.sendRedirect("login.jsp");
            return;
        }

        int userId = (Integer) session.getAttribute("userId");
        req.setAttribute("cartList", CartDAO.getCartByUser(userId));
        req.getRequestDispatcher("cart.jsp").forward(req, res);
    }

    // Add product to cart
    protected void doPost(HttpServletRequest req, HttpServletResponse res)
            throws ServletException, IOException {

        HttpSession session = req.getSession(false);

        if (session == null || session.getAttribute("userId") == null) {
            res.sendRedirect("login.jsp");
            return;
        }

        int userId = (Integer) session.getAttribute("userId");
        String action = req.getParameter("action");

        if ("add".equals(action)) {
            int productId = Integer.parseInt(req.getParameter("productId"));
            CartDAO.addToCart(userId, productId);
            res.sendRedirect("ProductServlet?message=added");
        } else if ("update".equals(action)) {
            int cartId = Integer.parseInt(req.getParameter("cartId"));
            int quantity = Integer.parseInt(req.getParameter("quantity"));
            CartDAO.updateCartQuantity(cartId, quantity);
            res.sendRedirect("cart");
        } else if ("remove".equals(action)) {
            int cartId = Integer.parseInt(req.getParameter("cartId"));
            CartDAO.removeFromCart(cartId);
            res.sendRedirect("cart");
        } else {
            res.sendRedirect("cart");
        }
    }
}
