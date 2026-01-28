<%@ include file="includes/amazon-header.jsp" %>
<%@ page import="java.util.*,model.Wishlist,model.Product" %>

</div>
<!-- Close amazon-main-container from header -->

<div class="amazon-main-container">
<div class="amazon-product-section" style="margin-top: 20px;">
    <div class="amazon-section-header">
        <h2 class="amazon-section-title"><i class="fas fa-heart"></i> Wishlist</h2>
    </div>
</div>

<div class="amazon-products-grid">
    <%
    List<Wishlist> wishlist = (List<Wishlist>) request.getAttribute("wishlist");
    if (wishlist != null && !wishlist.isEmpty()) {
        for (Wishlist w : wishlist) {
            Product p = w.getProduct();
    %>
        <%
            String img = p.getImageUrl();
            String imgSrc = null;
            if (img != null && !img.trim().isEmpty()) {
                if (img.startsWith("http://") || img.startsWith("https://")) {
                    imgSrc = img;
                } else if (img.startsWith("/")) {
                    imgSrc = request.getContextPath() + img;
                } else {
                    imgSrc = request.getContextPath() + "/" + img;
                }
            }
        %>
        <div class="amazon-product-card">
            <div class="amazon-product-image-container" style="width: 100%; height: 250px; min-height: 250px; background: #fff; border: 1px solid #e7e7e7; border-radius: 8px; display: flex; align-items: center; justify-content: center; overflow: hidden;">
                <% if (imgSrc != null && !imgSrc.isEmpty()) { %>
                <img src="<%=imgSrc%>" alt="<%=p.getName()%>" class="amazon-product-image"
                     style="width: 100%; height: 100%; object-fit: contain; padding: 15px; display: block;"
                     onerror="this.style.display='none'; this.nextElementSibling.style.display='flex';"
                     onload="this.style.display='block'; this.nextElementSibling.style.display='none';">
                <div class="amazon-product-image-placeholder" style="display: none; width: 100%; height: 100%; background: linear-gradient(135deg, #f5f7fa 0%, #e8ecf1 100%); display: flex; align-items: center; justify-content: center; font-size: 4rem; opacity: 0.4;">📦</div>
                <% } else { %>
                <div class="amazon-product-image-placeholder" style="width: 100%; height: 100%; background: linear-gradient(135deg, #f5f7fa 0%, #e8ecf1 100%); display: flex; align-items: center; justify-content: center; font-size: 4rem; opacity: 0.4; color: #cbd5e0;">📦</div>
                <% } %>
            </div>
            <div class="amazon-product-category"><%=p.getCategoryName() != null ? p.getCategoryName() : "Uncategorized"%></div>
            <div class="amazon-product-title"><%=p.getName()%></div>
            <% if (p.getRating() > 0) { %>
            <div class="amazon-product-rating">
                <span class="amazon-product-stars">
                    <% for (int i = 0; i < 5; i++) { %>
                        <i class="fas fa-star<%=i < (int)p.getRating() ? "" : "-o"%>"></i>
                    <% } %>
                </span>
                <span class="amazon-product-rating-text">(<%=String.format("%.1f", p.getRating())%>)</span>
            </div>
            <% } %>
            <div class="amazon-product-price-container">
                <div class="amazon-product-price" style="font-size: 1.25rem; font-weight: 700; color: #0f1111; margin-bottom: 5px;">
                    ₹<%=String.format("%.2f", p.getPrice())%>
                </div>
            </div>
            <div class="d-flex gap-2 mt-3">
                <form action="cart" method="post" class="flex-grow-1">
                    <input type="hidden" name="action" value="add">
                    <input type="hidden" name="productId" value="<%=p.getId()%>">
                    <button type="submit" class="btn btn-primary w-100 btn-sm">
                        <i class="fas fa-cart-plus"></i> Add to Cart
                    </button>
                </form>
                <form action="wishlist" method="post">
                    <input type="hidden" name="action" value="remove">
                    <input type="hidden" name="productId" value="<%=p.getId()%>">
                    <button type="submit" class="btn btn-outline-danger btn-sm">
                        <i class="fas fa-trash"></i>
                    </button>
                </form>
            </div>
        </div>
    <%
        }
    } else {
    %>
    <div class="products-empty" style="grid-column: 1 / -1; text-align: center; padding: 60px 20px;">
        <div class="products-empty-icon">❤️</div>
        <h3>Your Wishlist is Empty</h3>
        <p>Start adding products to your wishlist!</p>
        <a href="ProductServlet" class="btn btn-primary mt-3">Browse Products</a>
    </div>
    <% } %>
</div>

</div>
<!-- Close amazon-main-container -->

<div class="container">
<%@ include file="includes/footer.jsp" %>
