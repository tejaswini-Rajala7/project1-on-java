package controller;

import dao.WishlistDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import model.Wishlist;

import java.io.IOException;
import java.util.List;

@WebServlet("/wishlist")
public class WishlistServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse res) throws ServletException, IOException {
        HttpSession session = req.getSession(false);
        if (session == null || session.getAttribute("userId") == null) {
            res.sendRedirect("login.jsp");
            return;
        }

        int userId = (Integer) session.getAttribute("userId");
        List<Wishlist> items = WishlistDAO.getWishlist(userId);
        req.setAttribute("wishlist", items);
        req.getRequestDispatcher("wishlist.jsp").forward(req, res);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse res) throws ServletException, IOException {
        HttpSession session = req.getSession(false);
        if (session == null || session.getAttribute("userId") == null) {
            res.sendRedirect("login.jsp");
            return;
        }

        int userId = (Integer) session.getAttribute("userId");
        String action = req.getParameter("action");
        String productIdParam = req.getParameter("productId");
        String redirect = req.getParameter("redirect");
        int productId = productIdParam != null ? Integer.parseInt(productIdParam) : -1;

        if ("add".equals(action) && productId > 0) {
            WishlistDAO.addToWishlist(userId, productId);
        } else if ("remove".equals(action) && productId > 0) {
            WishlistDAO.removeFromWishlist(userId, productId);
        }

        if (redirect != null && !redirect.isEmpty()) {
            res.sendRedirect(redirect);
        } else {
            res.sendRedirect("wishlist");
        }
    }
}
