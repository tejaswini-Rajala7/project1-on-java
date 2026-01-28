package controller;

import dao.ProductDAO;
import jakarta.servlet.*;
import jakarta.servlet.http.*;
import jakarta.servlet.annotation.*;
import java.io.IOException;

@WebServlet("/search")
public class SearchServlet extends HttpServlet {
    protected void doGet(HttpServletRequest req, HttpServletResponse res)
            throws ServletException, IOException {

        String searchTerm = req.getParameter("q");
        if (searchTerm != null && !searchTerm.trim().isEmpty()) {
            res.sendRedirect("ProductServlet?q=" + java.net.URLEncoder.encode(searchTerm, "UTF-8"));
        } else {
            res.sendRedirect("ProductServlet");
        }
    }
}
