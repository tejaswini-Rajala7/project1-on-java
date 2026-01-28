package controller.admin;

import dao.OrderDAO;
import jakarta.servlet.*;
import jakarta.servlet.http.*;
import jakarta.servlet.annotation.*;
import java.io.IOException;

@WebServlet("/admin/orders")
public class AdminOrderServlet extends HttpServlet {

    protected void doGet(HttpServletRequest req, HttpServletResponse res)
            throws ServletException, IOException {

        HttpSession session = req.getSession(false);
        if (session == null || !"admin".equals(session.getAttribute("userRole"))) {
            res.sendRedirect("../login.jsp");
            return;
        }

        String action = req.getParameter("action");
        if ("details".equals(action)) {
            int orderId = Integer.parseInt(req.getParameter("id"));
            req.setAttribute("order", OrderDAO.getOrderById(orderId));
            req.setAttribute("items", OrderDAO.getOrderItems(orderId));
            req.getRequestDispatcher("../admin/order-details.jsp").forward(req, res);
        } else {
            req.setAttribute("orders", OrderDAO.getAllOrders());
            req.getRequestDispatcher("../admin/orders.jsp").forward(req, res);
        }
    }

    protected void doPost(HttpServletRequest req, HttpServletResponse res)
            throws ServletException, IOException {

        HttpSession session = req.getSession(false);
        if (session == null || !"admin".equals(session.getAttribute("userRole"))) {
            res.sendRedirect("../login.jsp");
            return;
        }

        int orderId = Integer.parseInt(req.getParameter("orderId"));
        String status = req.getParameter("status");
        
        if (OrderDAO.updateOrderStatus(orderId, status)) {
            res.sendRedirect("orders?success=updated");
        } else {
            res.sendRedirect("orders?error=update");
        }
    }
}
