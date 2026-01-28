package controller;

import dao.AddressDAO;
import dao.CartDAO;
import dao.CouponDAO;
import model.Coupon;
import jakarta.servlet.*;
import jakarta.servlet.http.*;
import jakarta.servlet.annotation.*;
import java.io.IOException;

@WebServlet("/checkout")
public class CheckoutServlet extends HttpServlet {
    protected void doGet(HttpServletRequest req, HttpServletResponse res)
            throws ServletException, IOException {

        HttpSession session = req.getSession(false);
        if (session == null || session.getAttribute("userId") == null) {
            res.sendRedirect("login.jsp");
            return;
        }

        int userId = (Integer) session.getAttribute("userId");
        
        // Check if cart is empty
        if (CartDAO.getCartByUser(userId).isEmpty()) {
            res.sendRedirect("cart?error=empty");
            return;
        }

        double subtotal = CartDAO.getCartTotal(userId);
        String couponCode = req.getParameter("coupon");
        Coupon coupon = null;
        double discount = 0.0;
        if (couponCode != null && !couponCode.trim().isEmpty()) {
            coupon = CouponDAO.findActiveByCode(couponCode.trim().toUpperCase());
            if (coupon != null) {
                discount = CouponDAO.calculateDiscount(coupon, subtotal);
                req.setAttribute("coupon", coupon);
                req.setAttribute("discount", discount);
            } else {
                req.setAttribute("couponError", "Invalid or expired coupon code");
            }
        }
        double shipping = 50.0;
        double total = Math.max(0, subtotal - discount + shipping);

        req.setAttribute("cartList", CartDAO.getCartByUser(userId));
        req.setAttribute("subtotal", subtotal);
        req.setAttribute("discount", discount);
        req.setAttribute("shipping", shipping);
        req.setAttribute("total", total);
        req.setAttribute("couponCode", couponCode);
        req.setAttribute("addresses", AddressDAO.getAddressesByUser(userId));
        req.getRequestDispatcher("checkout.jsp").forward(req, res);
    }
}
