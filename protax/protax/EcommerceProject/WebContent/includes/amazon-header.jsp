<%@ page import="jakarta.servlet.http.HttpSession,java.util.*,model.Product,model.Category,dao.ProductDAO,dao.CategoryDAO,dao.CartDAO" %>
<%
    HttpSession userSession = request.getSession(false);
    String userName = userSession != null ? (String) userSession.getAttribute("userName") : null;
    String userRole = userSession != null ? (String) userSession.getAttribute("userRole") : null;
    Integer userId = userSession != null ? (Integer) userSession.getAttribute("userId") : null;
    String contextPath = request.getContextPath();
    
    // Get cart count
    int cartCount = 0;
    if (userId != null) {
        try {
            cartCount = CartDAO.getCartByUser(userId).size();
        } catch (Exception e) {
            cartCount = 0;
        }
    }
    
    // Get categories for menu
    List<Category> categories = CategoryDAO.getAllCategories();
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Protax Store - E-Commerce Platform</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <link rel="stylesheet" href="<%=contextPath%>/css/style.css">
    <link rel="stylesheet" href="<%=contextPath%>/css/amazon-home.css">
    <link rel="stylesheet" href="<%=contextPath%>/css/amazon-carousel.css">
    <link rel="stylesheet" href="<%=contextPath%>/css/product-images-fix.css">
    <link rel="stylesheet" href="<%=contextPath%>/css/fix-duplicate-rupee.css">
    <!-- Enhanced CSS disabled for better performance - uncomment if needed -->
    <!-- <link rel="stylesheet" href="<%=contextPath%>/css/enhanced.css"> -->
    <style>
        /* Dropdown Menu Styles */
        .amazon-nav-item-dropdown {
            position: relative;
        }
        .amazon-dropdown-menu {
            position: absolute;
            top: 100%;
            right: 0;
            background: white;
            border: 1px solid #ddd;
            border-radius: 4px;
            box-shadow: 0 4px 12px rgba(0,0,0,0.15);
            min-width: 250px;
            z-index: 1000;
            margin-top: 5px;
        }
        .amazon-dropdown-menu a {
            display: block;
            padding: 8px 15px;
            color: #0f1111;
            text-decoration: none;
            font-size: 0.875rem;
        }
        .amazon-dropdown-menu a:hover {
            background: #f7f7f7;
        }
        .amazon-nav-item-dropdown:hover .amazon-dropdown-menu {
            display: block !important;
        }
        .amazon-dropdown-menu i {
            width: 20px;
            text-align: center;
            margin-right: 8px;
        }
        
        /* Active category link styling */
        .amazon-category-link-active {
            background: #ffa41c !important;
            color: #0f1111 !important;
            font-weight: 600 !important;
        }
        
        .amazon-category-link:hover {
            background: rgba(255, 255, 255, 0.1);
        }
        
        /* Enhanced Product Image Container */
        .amazon-product-image-container {
            width: 100% !important;
            height: 250px !important;
            min-height: 250px !important;
            margin-bottom: 15px;
            display: flex !important;
            align-items: center;
            justify-content: center;
            background: #ffffff !important;
            border: 1px solid #e7e7e7;
            border-radius: 8px;
            overflow: hidden;
            position: relative;
            transition: all 0.3s ease;
        }
        
        .amazon-product-card:hover .amazon-product-image-container {
            border-color: #ffa41c;
            box-shadow: 0 2px 8px rgba(0,0,0,0.1);
        }
        
        .amazon-product-image {
            width: 100% !important;
            height: 100% !important;
            object-fit: contain !important;
            padding: 15px;
            transition: transform 0.3s ease;
            background: #ffffff;
            display: block !important;
        }
        
        .amazon-product-card:hover .amazon-product-image {
            transform: scale(1.05);
        }
        
        .amazon-product-image-placeholder {
            width: 100% !important;
            height: 100% !important;
            background: linear-gradient(135deg, #f5f7fa 0%, #e8ecf1 100%);
            display: flex !important;
            align-items: center;
            justify-content: center;
            font-size: 4rem;
            opacity: 0.4;
            color: #cbd5e0;
        }
        
        /* Ensure all prices show in rupees - Global price formatting */
        .amazon-product-price,
        .price,
        .product-price {
            font-size: 1.25rem;
            font-weight: 700;
            color: #0f1111;
            margin-bottom: 5px;
        }
        
        /* CRITICAL: Remove ALL CSS-generated rupee symbols to prevent encoding issues */
        .product-price::before,
        .product-price::after,
        .amazon-product-price::before,
        .amazon-product-price::after,
        .amazon-product-price-container::before,
        .amazon-product-price-container::after,
        .amazon-product-price-original::before,
        .amazon-product-price-original::after,
        .price::before,
        .price::after,
        [class*="price"]::before,
        [class*="price"]::after,
        *[class*="price"]::before,
        *[class*="price"]::after {
            content: "" !important;
            content: none !important;
            display: none !important;
            visibility: hidden !important;
            width: 0 !important;
            height: 0 !important;
            font-size: 0 !important;
            line-height: 0 !important;
            margin: 0 !important;
            padding: 0 !important;
        }
        
        /* Ensure price class shows rupees properly */
        .price {
            color: #0f1111;
            font-weight: 700;
        }
        
        /* Format all price displays consistently */
        td.price,
        strong.price,
        p.price,
        span.price {
            font-weight: 700;
            color: #0f1111;
        }
        
        /* Ensure all price-related text shows ₹ symbol */
        [class*="price"]:not([class*="original"]):not([class*="discount"]) {
            font-family: -apple-system, BlinkMacSystemFont, 'Segoe UI', Roboto, sans-serif;
        }
        
        /* Make sure price values are clearly visible */
        .amazon-product-price,
        .price,
        .product-price,
        td.price {
            font-weight: 700;
            color: #0f1111;
            white-space: nowrap;
        }
        
        /* Remove any CSS that adds duplicate ₹ symbols */
        .product-price::before {
            content: none !important;
        }
    </style>
    <script src="<%=contextPath%>/js/image-handler.js" defer></script>
    <script src="<%=contextPath%>/js/fix-rupee-encoding.js"></script>
    <script src="<%=contextPath%>/js/price-formatter.js" defer></script>
</head>
<body>
    <!-- Amazon-Style Top Navigation -->
    <nav class="amazon-navbar">
        <div class="amazon-navbar-top">
            <!-- Logo -->
            <a href="<%=contextPath%>/index.jsp" class="amazon-logo">
                <i class="fas fa-shopping-bag"></i>
                <span>Protax Store</span>
            </a>
            
            <!-- Search Bar -->
            <div class="amazon-search-container">
                <form action="<%=contextPath%>/search" method="get" class="amazon-search-form">
                    <select name="category" class="amazon-search-select">
                        <option value="">All</option>
                        <%
                        if (categories != null) {
                            for (Category cat : categories) {
                        %>
                        <option value="<%=cat.getId()%>"><%=cat.getName()%></option>
                        <%
                            }
                        }
                        %>
                    </select>
                    <input type="text" name="q" class="amazon-search-input" placeholder="Search Protax Store">
                    <button type="submit" class="amazon-search-button">
                        <i class="fas fa-search"></i>
                    </button>
                </form>
            </div>
            
            <!-- Right Navigation -->
            <div class="amazon-nav-right">
                <% if (userName != null) { %>
                    <div class="amazon-nav-item-dropdown" style="position: relative;">
                        <a href="#" class="amazon-nav-item" id="accountDropdown">
                            <span class="amazon-nav-item-main">Hello, <%=userName%></span>
                            <span>Account & Lists <i class="fas fa-caret-down" style="font-size: 0.7rem; margin-left: 3px;"></i></span>
                        </a>
                        <div class="amazon-dropdown-menu" id="accountMenu" style="display: none;">
                            <div style="padding: 15px; border-bottom: 1px solid #e7e7e7;">
                                <div style="font-weight: 600; margin-bottom: 5px;"><%=userName%></div>
                                <div style="font-size: 0.75rem; color: #565959;"><%=userRole != null && userRole.equals("admin") ? "Administrator" : "Customer"%></div>
                            </div>
                            <div style="padding: 10px 0;">
                                <a href="<%=contextPath%>/order?action=history" style="display: block; padding: 8px 15px; color: #0f1111; text-decoration: none; font-size: 0.875rem;">
                                    <i class="fas fa-box" style="width: 20px;"></i> My Orders
                                </a>
                                <a href="<%=contextPath%>/wishlist" style="display: block; padding: 8px 15px; color: #0f1111; text-decoration: none; font-size: 0.875rem;">
                                    <i class="fas fa-heart" style="width: 20px;"></i> My Wishlist
                                </a>
                                <a href="<%=contextPath%>/address" style="display: block; padding: 8px 15px; color: #0f1111; text-decoration: none; font-size: 0.875rem;">
                                    <i class="fas fa-map-marker-alt" style="width: 20px;"></i> My Addresses
                                </a>
                                <% if ("admin".equals(userRole)) { %>
                                <a href="<%=contextPath%>/admin/dashboard.jsp" style="display: block; padding: 8px 15px; color: #0f1111; text-decoration: none; font-size: 0.875rem;">
                                    <i class="fas fa-cog" style="width: 20px;"></i> Admin Dashboard
                                </a>
                                <% } %>
                                <hr style="margin: 10px 0; border: none; border-top: 1px solid #e7e7e7;">
                                <a href="<%=contextPath%>/logout" style="display: block; padding: 8px 15px; color: #0f1111; text-decoration: none; font-size: 0.875rem;">
                                    <i class="fas fa-sign-out-alt" style="width: 20px;"></i> Sign Out
                                </a>
                            </div>
                        </div>
                    </div>
                    <a href="<%=contextPath%>/order?action=history" class="amazon-nav-item">
                        <span class="amazon-nav-item-main">Returns</span>
                        <span>& Orders</span>
                    </a>
                    <a href="<%=contextPath%>/cart" class="amazon-cart">
                        <i class="fas fa-shopping-cart fa-lg"></i>
                        <span>Cart</span>
                        <% if (cartCount > 0) { %>
                        <span class="amazon-cart-count"><%=cartCount%></span>
                        <% } %>
                    </a>
                <% } else { %>
                    <a href="<%=contextPath%>/login.jsp" class="amazon-nav-item">
                        <span class="amazon-nav-item-main">Hello, Sign in</span>
                        <span>Account & Lists</span>
                    </a>
                    <a href="<%=contextPath%>/register.jsp" class="amazon-nav-item">
                        <span class="amazon-nav-item-main">New customer?</span>
                        <span>Start here</span>
                    </a>
                    <a href="<%=contextPath%>/cart" class="amazon-cart">
                        <i class="fas fa-shopping-cart fa-lg"></i>
                        <span>Cart</span>
                    </a>
                <% } %>
            </div>
        </div>
        
        <!-- Category Menu -->
        <div class="amazon-category-menu">
            <div class="amazon-category-menu-inner">
                <a href="<%=contextPath%>/index.jsp" class="amazon-category-link">
                    <i class="fas fa-bars"></i> All
                </a>
                <a href="<%=contextPath%>/ProductServlet" class="amazon-category-link">Products</a>
                <%
                // Get current category from request parameter or attribute (for highlighting active category)
                Integer currentCategoryId = null;
                String categoryParam = request.getParameter("category");
                if (categoryParam != null && !categoryParam.isEmpty()) {
                    try {
                        currentCategoryId = Integer.parseInt(categoryParam);
                    } catch (NumberFormatException e) {
                        // Ignore
                    }
                } else {
                    // Check if category is set as attribute (from ProductServlet)
                    Object categoryAttr = request.getAttribute("category");
                    if (categoryAttr != null) {
                        currentCategoryId = (Integer) categoryAttr;
                    }
                }
                
                if (categories != null && categories.size() > 0) {
                    int count = 0;
                    for (Category cat : categories) {
                        if (count++ >= 8) break; // Limit to 8 categories
                        boolean isActive = currentCategoryId != null && currentCategoryId.equals(cat.getId());
                %>
                <a href="<%=contextPath%>/ProductServlet?category=<%=cat.getId()%>" 
                   class="amazon-category-link <%=isActive ? "amazon-category-link-active" : ""%>">
                   <%=cat.getName()%>
                </a>
                <%
                    }
                }
                %>
                <% if (userName != null) { %>
                    <a href="<%=contextPath%>/wishlist" class="amazon-category-link">Wishlist</a>
                    <% if ("admin".equals(userRole)) { %>
                    <a href="<%=contextPath%>/admin/dashboard.jsp" class="amazon-category-link">Admin</a>
                    <% } %>
                <% } %>
            </div>
        </div>
    </nav>
    
    <!-- Main Container (will be closed in footer or page) -->
    <div class="amazon-main-container">
