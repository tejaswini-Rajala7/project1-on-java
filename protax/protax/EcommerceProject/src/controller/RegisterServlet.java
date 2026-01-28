package controller;

import dao.UserDAO;
import jakarta.servlet.*;
import jakarta.servlet.http.*;
import jakarta.servlet.annotation.*;
import java.io.IOException;

@WebServlet("/register")
public class RegisterServlet extends HttpServlet {
    protected void doPost(HttpServletRequest req, HttpServletResponse res)
            throws ServletException, IOException {

        UserDAO.register(
            req.getParameter("name"),
            req.getParameter("email"),
            req.getParameter("password")
        );
        res.sendRedirect("login.jsp");
    }
}
