package controller;

import dao.AddressDAO;
import model.Address;
import jakarta.servlet.*;
import jakarta.servlet.http.*;
import jakarta.servlet.annotation.*;
import java.io.IOException;

@WebServlet("/address")
public class AddressServlet extends HttpServlet {

    protected void doGet(HttpServletRequest req, HttpServletResponse res)
            throws ServletException, IOException {

        HttpSession session = req.getSession(false);
        if (session == null || session.getAttribute("userId") == null) {
            res.sendRedirect("login.jsp");
            return;
        }

        int userId = (Integer) session.getAttribute("userId");
        req.setAttribute("addresses", AddressDAO.getAddressesByUser(userId));
        req.getRequestDispatcher("addresses.jsp").forward(req, res);
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

        if ("add".equals(action)) {
            Address address = new Address();
            address.setUserId(userId);
            address.setFullName(req.getParameter("fullName"));
            address.setPhone(req.getParameter("phone"));
            address.setAddressLine1(req.getParameter("addressLine1"));
            address.setAddressLine2(req.getParameter("addressLine2"));
            address.setCity(req.getParameter("city"));
            address.setState(req.getParameter("state"));
            address.setPincode(req.getParameter("pincode"));
            address.setDefault(req.getParameter("isDefault") != null);

            if (AddressDAO.addAddress(address)) {
                res.sendRedirect("address?success=added");
            } else {
                res.sendRedirect("address?error=add");
            }
        } else if ("delete".equals(action)) {
            int addressId = Integer.parseInt(req.getParameter("addressId"));
            if (AddressDAO.deleteAddress(addressId)) {
                res.sendRedirect("address?success=deleted");
            } else {
                res.sendRedirect("address?error=delete");
            }
        } else {
            res.sendRedirect("address");
        }
    }
}
