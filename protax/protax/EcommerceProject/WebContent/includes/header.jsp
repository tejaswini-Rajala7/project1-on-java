<%@ page import="jakarta.servlet.http.HttpSession,java.util.*,model.Product,dao.ProductDAO" %>
<%
    HttpSession userSession = request.getSession(false);
    String userName = userSession != null ? (String) userSession.getAttribute("userName") : null;
    String userRole = userSession != null ? (String) userSession.getAttribute("userRole") : null;
    Integer userId = userSession != null ? (Integer) userSession.getAttribute("userId") : null;
    String contextPath = request.getContextPath();
    
    // Fetch featured products for header dropdown (limit to 6)
    List<Product> headerProducts = ProductDAO.getAllProducts();
    if (headerProducts != null && headerProducts.size() > 6) {
        headerProducts = headerProducts.subList(0, 6);
    }
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Protax Store - E-Commerce Platform</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <link rel="stylesheet" href="<%=contextPath%>/css/style.css">
    <link rel="stylesheet" href="<%=contextPath%>/css/enhanced.css">
    <link rel="stylesheet" href="<%=contextPath%>/css/products.css">
    <link rel="stylesheet" href="<%=contextPath%>/css/header-products.css">
</head>
<body>
    <nav class="navbar navbar-expand-lg">
        <div class="container">
            <a class="navbar-brand" href="<%=contextPath%>/index.jsp">
                <i class="fas fa-shopping-bag"></i> Protax Store
            </a>
            <button class="navbar-toggler" type="button" data-bs-toggle="collapse" data-bs-target="#navbarNav">
                <span class="navbar-toggler-icon"></span>
            </button>
            <div class="collapse navbar-collapse" id="navbarNav">
                <ul class="navbar-nav ms-auto">
                    <li class="nav-item">
                        <a class="nav-link" href="<%=contextPath%>/index.jsp"><i class="fas fa-home"></i> Home</a>
                    </li>
                    <li class="nav-item dropdown mega-menu">
                        <a class="nav-link dropdown-toggle" href="#" id="productsDropdown" role="button" data-bs-toggle="dropdown" aria-expanded="false">
                            <i class="fas fa-box"></i> Products
                        </a>
                        <ul class="dropdown-menu mega-menu-content" aria-labelledby="productsDropdown">
                            <li>
                                <div class="mega-menu-wrapper">
                                    <div class="mega-menu-header">
                                        <h5>Featured Products</h5>
                                        <a href="<%=contextPath%>/ProductServlet" class="view-all-link">View All <i class="fas fa-arrow-right"></i></a>
                                    </div>
                                    <div class="mega-menu-products">
                                        <%
                                        if (headerProducts != null && !headerProducts.isEmpty()) {
                                            for (Product p : headerProducts) {
                                        %>
                                        <a href="<%=contextPath%>/product-detail?id=<%=p.getId()%>" class="mega-menu-product-card">
                                            <div class="mega-menu-product-image">
                                                <div class="product-image-placeholder" style="height: 120px;"></div>
                                            </div>
                                            <div class="mega-menu-product-info">
                                                <span class="mega-menu-product-category"><%=p.getCategoryName() != null ? p.getCategoryName() : "Uncategorized"%></span>
                                                <h6 class="mega-menu-product-title"><%=p.getName()%></h6>
                                                <div class="mega-menu-product-price">₹<%=String.format("%.2f", p.getPrice())%></div>
                                            </div>
                                        </a>
                                        <%
                                            }
                                        }
                                        %>
                                    </div>
                                </div>
                            </li>
                        </ul>
                    </li>
                    <% if (userName != null) { %>
                        <li class="nav-item">
                            <a class="nav-link" href="<%=contextPath%>/wishlist"><i class="fas fa-heart"></i> Wishlist</a>
                        </li>
                        <li class="nav-item">
                            <a class="nav-link" href="<%=contextPath%>/cart"><i class="fas fa-shopping-cart"></i> Cart</a>
                        </li>
                        <li class="nav-item">
                            <a class="nav-link" href="<%=contextPath%>/order?action=history"><i class="fas fa-history"></i> Orders</a>
                        </li>
                        <% if ("admin".equals(userRole)) { %>
                            <li class="nav-item">
                                <a class="nav-link" href="<%=contextPath%>/admin/dashboard.jsp"><i class="fas fa-cog"></i> Admin</a>
                            </li>
                        <% } %>
                        <li class="nav-item dropdown">
                            <a class="nav-link dropdown-toggle" href="#" id="userDropdown" role="button" data-bs-toggle="dropdown">
                                <i class="fas fa-user"></i> <%= userName %>
                            </a>
                            <ul class="dropdown-menu">
                                <li><a class="dropdown-item" href="<%=contextPath%>/address"><i class="fas fa-map-marker-alt"></i> Addresses</a></li>
                                <li><hr class="dropdown-divider"></li>
                                <li><a class="dropdown-item" href="<%=contextPath%>/logout"><i class="fas fa-sign-out-alt"></i> Logout</a></li>
                            </ul>
                        </li>
                    <% } else { %>
                        <li class="nav-item">
                            <a class="nav-link" href="<%=contextPath%>/login.jsp"><i class="fas fa-sign-in-alt"></i> Login</a>
                        </li>
                        <li class="nav-item">
                            <a class="nav-link" href="<%=contextPath%>/register.jsp"><i class="fas fa-user-plus"></i> Register</a>
                        </li>
                    <% } %>
                </ul>
            </div>
        </div>
    </nav>
    <div class="container">
