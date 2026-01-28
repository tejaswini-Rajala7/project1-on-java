package controller;

import dao.*;
import model.*;
import jakarta.servlet.*;
import jakarta.servlet.http.*;
import jakarta.servlet.annotation.*;
import java.io.IOException;
import java.util.List;
import util.EmailService;
import util.PaymentService;

@WebServlet("/order")
public class OrderServlet extends HttpServlet {

    protected void doGet(HttpServletRequest req, HttpServletResponse res)
            throws ServletException, IOException {

        HttpSession session = req.getSession(false);

        if (session == null || session.getAttribute("userId") == null) {
            res.sendRedirect("login.jsp");
            return;
        }

        int userId = (Integer) session.getAttribute("userId");
        String action = req.getParameter("action");

        if ("history".equals(action)) {
            List<Order> orders = OrderDAO.getOrdersByUser(userId);
            req.setAttribute("orders", orders);
            req.getRequestDispatcher("order-history.jsp").forward(req, res);
        } else if ("details".equals(action)) {
            int orderId = Integer.parseInt(req.getParameter("orderId"));
            Order order = OrderDAO.getOrderById(orderId);
            if (order != null && order.getUserId() == userId) {
                List<OrderItem> items = OrderDAO.getOrderItems(orderId);
                req.setAttribute("order", order);
                req.setAttribute("items", items);
                req.getRequestDispatcher("order-details.jsp").forward(req, res);
            } else {
                res.sendRedirect("order?action=history");
            }
        } else {
            res.sendRedirect("order?action=history");
        }
    }

    protected void doPost(HttpServletRequest req, HttpServletResponse res)
            throws ServletException, IOException {

        HttpSession session = req.getSession(false);

        if (session == null || session.getAttribute("userId") == null) {
            res.sendRedirect("login.jsp");
            return;
        }

        int userId = (Integer) session.getAttribute("userId");
        String action = req.getParameter("action");

        if ("place".equals(action)) {
            // Get cart items
            List<Cart> cartItems = CartDAO.getCartByUser(userId);
            if (cartItems.isEmpty()) {
                res.sendRedirect("cart?error=empty");
                return;
            }

            // Get address
            int addressId = Integer.parseInt(req.getParameter("addressId"));
            Address address = AddressDAO.getAddressById(addressId);
            if (address == null || address.getUserId() != userId) {
                res.sendRedirect("checkout.jsp?error=address");
                return;
            }

            // Calculate total
            double subtotal = CartDAO.getCartTotal(userId);
            String couponCode = req.getParameter("couponCode");
            Coupon coupon = null;
            double discount = 0.0;
            if (couponCode != null && !couponCode.trim().isEmpty()) {
                coupon = CouponDAO.findActiveByCode(couponCode.trim().toUpperCase());
                discount = CouponDAO.calculateDiscount(coupon, subtotal);
            }
            double shipping = 50.0;
            double total = Math.max(0, subtotal - discount + shipping);
            String paymentMethod = req.getParameter("paymentMethod");

            PaymentService.PaymentResult paymentResult = PaymentService.process(paymentMethod, total);
            if (!paymentResult.isSuccess()) {
                res.sendRedirect("checkout?error=payment");
                return;
            }

            // Create order
            int orderId = OrderDAO.createOrder(userId, addressId, total, paymentMethod);
            if (orderId > 0) {
                // Add order items
                for (Cart cartItem : cartItems) {
                    OrderDAO.addOrderItem(orderId, cartItem.getProductId(), 
                                        cartItem.getQuantity(), cartItem.getProductPrice());
                }

                // Clear cart
                CartDAO.clearCart(userId);

                // Update order + payment status
                OrderDAO.updateOrderStatus(orderId, "confirmed");
                OrderDAO.updatePaymentStatus(orderId, paymentResult.getStatus());

                Order order = OrderDAO.getOrderById(orderId);
                List<OrderItem> items = OrderDAO.getOrderItems(orderId);
                User user = UserDAO.getUserById(userId);
                EmailService.sendOrderConfirmation(user, order, items);

                res.sendRedirect("order?action=details&orderId=" + orderId);
            } else {
                res.sendRedirect("checkout.jsp?error=order");
            }
        } else {
            res.sendRedirect("cart");
        }
    }
}
