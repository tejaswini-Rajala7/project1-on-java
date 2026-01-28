<%@ include file="includes/amazon-header.jsp" %>
<%@ page import="java.util.*,model.Product,model.Category,dao.ProductDAO,dao.CategoryDAO" %>
<link rel="stylesheet" href="<%=request.getContextPath()%>/css/products.css">

<%
    // Fetch all products and categories
    List<Product> allProducts = ProductDAO.getAllProducts();
    List<Category> allCategories = CategoryDAO.getAllCategories();
    
    // Helper: find category ID by name
    int electronicsCatId = -1;
    int fashionCatId = -1;
    int homeKitchenCatId = -1;
    
    if (allCategories != null) {
        for (Category cat : allCategories) {
            if (cat.getName() != null) {
                String name = cat.getName().toLowerCase();
                if (name.contains("electronic")) electronicsCatId = cat.getId();
                if (name.contains("fashion") || name.contains("clothing") || name.contains("apparel")) fashionCatId = cat.getId();
                if (name.contains("home") || name.contains("kitchen")) homeKitchenCatId = cat.getId();
            }
        }
    }
    
    // Get products by category
    List<Product> electronics = electronicsCatId > 0 ? ProductDAO.getProductsByCategory(electronicsCatId) : new ArrayList<>();
    List<Product> fashion = fashionCatId > 0 ? ProductDAO.getProductsByCategory(fashionCatId) : new ArrayList<>();
    List<Product> homeKitchen = homeKitchenCatId > 0 ? ProductDAO.getProductsByCategory(homeKitchenCatId) : new ArrayList<>();
    
    // Best Sellers - products with highest ratings
    List<Product> bestSellers = new ArrayList<>();
    if (allProducts != null && allProducts.size() > 0) {
        List<Product> sorted = new ArrayList<>(allProducts);
        Collections.sort(sorted, (a, b) -> Double.compare(b.getRating(), a.getRating()));
        bestSellers = sorted.subList(0, Math.min(10, sorted.size()));
    }
    
    // Today's Deals
    List<Product> todaysDeals = allProducts != null && allProducts.size() > 10
        ? new ArrayList<>(allProducts.subList(10, Math.min(20, allProducts.size())))
        : (allProducts != null && allProducts.size() > 0 
            ? new ArrayList<>(allProducts.subList(0, Math.min(10, allProducts.size()))) 
            : new ArrayList<>());
    
    // Fallback for category sections
    if (electronics.isEmpty() && allProducts != null && allProducts.size() > 0) {
        electronics = new ArrayList<>(allProducts.subList(0, Math.min(8, allProducts.size())));
    }
    if (fashion.isEmpty() && allProducts != null && allProducts.size() > 8) {
        fashion = new ArrayList<>(allProducts.subList(8, Math.min(16, allProducts.size())));
    } else if (fashion.isEmpty() && allProducts != null && allProducts.size() > 0) {
        fashion = new ArrayList<>(allProducts.subList(0, Math.min(8, allProducts.size())));
    }
    if (homeKitchen.isEmpty() && allProducts != null && allProducts.size() > 16) {
        homeKitchen = new ArrayList<>(allProducts.subList(16, Math.min(24, allProducts.size())));
    } else if (homeKitchen.isEmpty() && allProducts != null && allProducts.size() > 0) {
        homeKitchen = new ArrayList<>(allProducts.subList(0, Math.min(8, allProducts.size())));
    }
    
    // Recommended for You
    List<Product> recommended = new ArrayList<>();
    if (allProducts != null && allProducts.size() > 0) {
        int start = allProducts.size() > 24 ? 24 : 0;
        int end = Math.min(start + 10, allProducts.size());
        if (end > start) {
            recommended = new ArrayList<>(allProducts.subList(start, end));
        } else {
            recommended = new ArrayList<>(allProducts.subList(0, Math.min(10, allProducts.size())));
        }
    }
%>

<!-- Hero Banner Carousel -->
<div class="amazon-hero-carousel">
    <div class="amazon-carousel-container">
        <div class="amazon-carousel-slide active">
            <div class="amazon-hero-content">
                <h2>Welcome to Protax Store</h2>
                <p>Discover amazing deals on thousands of products</p>
                <a href="<%=request.getContextPath()%>/ProductServlet" class="amazon-hero-btn">Shop Now</a>
            </div>
        </div>
        <div class="amazon-carousel-slide">
            <div class="amazon-hero-content">
                <h2>Best Deals of the Season</h2>
                <p>Up to 50% off on selected items</p>
                <a href="<%=request.getContextPath()%>/ProductServlet" class="amazon-hero-btn">Explore Deals</a>
            </div>
        </div>
        <div class="amazon-carousel-slide">
            <div class="amazon-hero-content">
                <h2>Free Shipping on Orders Over ₹500</h2>
                <p>Shop now and get free delivery</p>
                <a href="<%=request.getContextPath()%>/ProductServlet" class="amazon-hero-btn">Start Shopping</a>
            </div>
        </div>
        <button class="carousel-rounded-button carousel-prev" onclick="changeSlide(-1)" aria-label="Previous slide">
            <i class="fas fa-chevron-left"></i>
        </button>
        <button class="carousel-rounded-button carousel-next" onclick="changeSlide(1)" aria-label="Next slide">
            <i class="fas fa-chevron-right"></i>
        </button>
        <div class="amazon-carousel-dots">
            <span class="dot active" onclick="currentSlide(1)"></span>
            <span class="dot" onclick="currentSlide(2)"></span>
            <span class="dot" onclick="currentSlide(3)"></span>
        </div>
    </div>
</div>

<%!
    // Helper method to render product card
    String renderProductCard(Product p, String contextPath, boolean showDiscount) {
        String img = p.getImageUrl();
        String imgSrc = null;
        if (img != null && !img.trim().isEmpty()) {
            if (img.startsWith("http://") || img.startsWith("https://")) {
                imgSrc = img;
            } else if (img.startsWith("/")) {
                imgSrc = contextPath + img;
            } else {
                imgSrc = contextPath + "/" + img;
            }
        }
        
        int discount = showDiscount ? (int)(Math.random() * 20 + 10) : 0;
        double originalPrice = p.getPrice();
        double discountedPrice = showDiscount ? originalPrice * (1 - discount / 100.0) : originalPrice;
        
        StringBuilder card = new StringBuilder();
        card.append("<a href=\"").append(contextPath).append("/product-detail?id=").append(p.getId())
            .append("\" class=\"amazon-product-card amazon-product-card-scroll\">");
        
        if (showDiscount && discount > 0) {
            card.append("<div class=\"amazon-discount-badge\">").append(discount).append("% OFF</div>");
        }
        
        card.append("<div class=\"amazon-product-image-container\" style=\"width: 100%; height: 250px; min-height: 250px; background: #fff; border: 1px solid #e7e7e7; border-radius: 8px; display: flex; align-items: center; justify-content: center; overflow: hidden; position: relative;\">");
        if (imgSrc != null && !imgSrc.isEmpty()) {
            card.append("<img src=\"").append(imgSrc).append("\" alt=\"").append(p.getName())
                .append("\" class=\"amazon-product-image\" style=\"width: 100%; height: 100%; object-fit: contain; padding: 15px; display: block;\"")
                .append(" onerror=\"this.style.display='none'; this.nextElementSibling.style.display='flex';\"")
                .append(" onload=\"this.style.display='block'; this.nextElementSibling.style.display='none';\">");
            card.append("<div class=\"amazon-product-image-placeholder\" style=\"display: none; width: 100%; height: 100%; background: linear-gradient(135deg, #f5f7fa 0%, #e8ecf1 100%); display: flex; align-items: center; justify-content: center; font-size: 4rem; opacity: 0.4;\">📦</div>");
        } else {
            card.append("<div class=\"amazon-product-image-placeholder\" style=\"width: 100%; height: 100%; background: linear-gradient(135deg, #f5f7fa 0%, #e8ecf1 100%); display: flex; align-items: center; justify-content: center; font-size: 4rem; opacity: 0.4; color: #cbd5e0;\">📦</div>");
        }
        card.append("</div>");
        
        card.append("<div class=\"amazon-product-category\">")
            .append(p.getCategoryName() != null ? p.getCategoryName() : "Uncategorized")
            .append("</div>");
        
        card.append("<div class=\"amazon-product-title\">").append(p.getName()).append("</div>");
        
        if (p.getRating() > 0) {
            card.append("<div class=\"amazon-product-rating\">");
            card.append("<span class=\"amazon-product-stars\">");
            for (int i = 0; i < 5; i++) {
                card.append("<i class=\"fas fa-star").append(i < (int)p.getRating() ? "" : "-o").append("\"></i>");
            }
            card.append("</span>");
            card.append("<span class=\"amazon-product-rating-text\">(")
                .append(String.format("%.1f", p.getRating())).append(")</span>");
            card.append("</div>");
        }
        
        card.append("<div class=\"amazon-product-price-container\">");
        if (showDiscount && discount > 0) {
            card.append("<span class=\"amazon-product-price-original\">₹")
                .append(String.format("%.2f", originalPrice)).append("</span>");
            card.append("<span class=\"amazon-product-price\">₹")
                .append(String.format("%.2f", discountedPrice)).append("</span>");
            card.append("<span class=\"amazon-product-discount\">Save ").append(discount).append("%</span>");
        } else {
            card.append("<div class=\"amazon-product-price\" style=\"font-size: 1.25rem; font-weight: 700; color: #0f1111; margin-bottom: 5px;\">₹")
                .append(String.format("%.2f", originalPrice)).append("</div>");
        }
        card.append("<div class=\"amazon-product-prime\">Prime</div>");
        card.append("</div>");
        
        card.append("</a>");
        return card.toString();
    }
%>

<!-- Best Sellers Section -->
<div class="amazon-product-section">
    <div class="amazon-section-header">
        <h2 class="amazon-section-title">Best Sellers</h2>
        <a href="<%=request.getContextPath()%>/ProductServlet" class="amazon-section-link">See more</a>
    </div>
    <div class="amazon-products-scroll">
        <%
        if (bestSellers != null && !bestSellers.isEmpty()) {
            for (Product p : bestSellers) {
                out.print(renderProductCard(p, request.getContextPath(), false));
            }
        } else {
        %>
        <div style="padding: 40px; text-align: center; color: #565959;">
            <p>No products available at the moment.</p>
        </div>
        <%
        }
        %>
    </div>
</div>

<!-- Today's Deals Section -->
<div class="amazon-product-section amazon-deals-section">
    <div class="amazon-section-header">
        <h2 class="amazon-section-title">Today's Deals</h2>
        <a href="<%=request.getContextPath()%>/ProductServlet" class="amazon-section-link">See all deals</a>
    </div>
    <div class="amazon-products-scroll">
        <%
        if (todaysDeals != null && !todaysDeals.isEmpty()) {
            for (Product p : todaysDeals) {
                out.print(renderProductCard(p, request.getContextPath(), true));
            }
        } else if (bestSellers != null && !bestSellers.isEmpty()) {
            for (Product p : bestSellers) {
                out.print(renderProductCard(p, request.getContextPath(), true));
            }
        }
        %>
    </div>
</div>

<!-- Electronics Section -->
<div class="amazon-product-section">
    <div class="amazon-section-header">
        <h2 class="amazon-section-title">Electronics</h2>
        <%
        if (electronicsCatId > 0) {
        %>
        <a href="<%=request.getContextPath()%>/ProductServlet?category=<%=electronicsCatId%>" class="amazon-section-link">See more</a>
        <% } else { %>
        <a href="<%=request.getContextPath()%>/ProductServlet" class="amazon-section-link">See more</a>
        <% } %>
    </div>
    <div class="amazon-products-scroll">
        <%
        if (electronics != null && !electronics.isEmpty()) {
            for (Product p : electronics) {
                out.print(renderProductCard(p, request.getContextPath(), false));
            }
        } else if (allProducts != null && allProducts.size() > 0) {
            for (int i = 0; i < Math.min(8, allProducts.size()); i++) {
                out.print(renderProductCard(allProducts.get(i), request.getContextPath(), false));
            }
        }
        %>
    </div>
</div>

<!-- Fashion Section -->
<div class="amazon-product-section">
    <div class="amazon-section-header">
        <h2 class="amazon-section-title">Fashion</h2>
        <%
        if (fashionCatId > 0) {
        %>
        <a href="<%=request.getContextPath()%>/ProductServlet?category=<%=fashionCatId%>" class="amazon-section-link">See more</a>
        <% } else { %>
        <a href="<%=request.getContextPath()%>/ProductServlet" class="amazon-section-link">See more</a>
        <% } %>
    </div>
    <div class="amazon-products-scroll">
        <%
        if (fashion != null && !fashion.isEmpty()) {
            for (Product p : fashion) {
                out.print(renderProductCard(p, request.getContextPath(), false));
            }
        } else if (allProducts != null && allProducts.size() > 8) {
            for (int i = 8; i < Math.min(16, allProducts.size()); i++) {
                out.print(renderProductCard(allProducts.get(i), request.getContextPath(), false));
            }
        }
        %>
    </div>
</div>

<!-- Home & Kitchen Section -->
<div class="amazon-product-section">
    <div class="amazon-section-header">
        <h2 class="amazon-section-title">Home & Kitchen</h2>
        <%
        if (homeKitchenCatId > 0) {
        %>
        <a href="<%=request.getContextPath()%>/ProductServlet?category=<%=homeKitchenCatId%>" class="amazon-section-link">See more</a>
        <% } else { %>
        <a href="<%=request.getContextPath()%>/ProductServlet" class="amazon-section-link">See more</a>
        <% } %>
    </div>
    <div class="amazon-products-scroll">
        <%
        if (homeKitchen != null && !homeKitchen.isEmpty()) {
            for (Product p : homeKitchen) {
                out.print(renderProductCard(p, request.getContextPath(), false));
            }
        } else if (allProducts != null && allProducts.size() > 16) {
            for (int i = 16; i < Math.min(24, allProducts.size()); i++) {
                out.print(renderProductCard(allProducts.get(i), request.getContextPath(), false));
            }
        }
        %>
    </div>
</div>

<!-- Recommended for You Section -->
<div class="amazon-product-section">
    <div class="amazon-section-header">
        <h2 class="amazon-section-title">Recommended for You</h2>
        <a href="<%=request.getContextPath()%>/ProductServlet" class="amazon-section-link">See more</a>
    </div>
    <div class="amazon-products-scroll">
        <%
        if (recommended != null && !recommended.isEmpty()) {
            for (Product p : recommended) {
                out.print(renderProductCard(p, request.getContextPath(), false));
            }
        } else if (bestSellers != null && !bestSellers.isEmpty()) {
            for (Product p : bestSellers) {
                out.print(renderProductCard(p, request.getContextPath(), false));
            }
        }
        %>
    </div>
</div>

</div>
<!-- Close amazon-main-container -->

<script>
// Carousel functionality
let slideIndex = 0;
const slides = document.querySelectorAll('.amazon-carousel-slide');
const dots = document.querySelectorAll('.dot');

function showSlide(n) {
    if (n >= slides.length) slideIndex = 0;
    if (n < 0) slideIndex = slides.length - 1;
    
    slides.forEach(slide => slide.classList.remove('active'));
    dots.forEach(dot => dot.classList.remove('active'));
    
    if (slides[slideIndex]) slides[slideIndex].classList.add('active');
    if (dots[slideIndex]) dots[slideIndex].classList.add('active');
}

function changeSlide(n) {
    slideIndex += n;
    showSlide(slideIndex);
}

function currentSlide(n) {
    slideIndex = n - 1;
    showSlide(slideIndex);
}

// Auto-advance carousel
setInterval(() => {
    changeSlide(1);
}, 5000);

// Initialize
showSlide(slideIndex);
</script>

<div class="container">
<%@ include file="includes/footer.jsp" %>
