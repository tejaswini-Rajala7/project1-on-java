<%@ include file="includes/amazon-header.jsp" %>
<%@ page import="java.util.*,model.Product,model.Category" %>
<link rel="stylesheet" href="<%=request.getContextPath()%>/css/products.css">
<link rel="stylesheet" href="<%=request.getContextPath()%>/css/fix-duplicate-rupee.css">

</div>
<!-- Close amazon-main-container from header -->

<div class="amazon-main-container">
<div class="amazon-product-section" style="margin-top: 20px;">
    <div class="amazon-section-header">
        <%
        String categoryName = (String) request.getAttribute("categoryName");
        if (categoryName != null && !categoryName.isEmpty()) {
        %>
        <h2 class="amazon-section-title"><%=categoryName%> Products</h2>
        <p style="margin: 0; color: #718096;">Browse our <%=categoryName%> collection</p>
        <% } else { %>
        <h2 class="amazon-section-title">Our Products</h2>
        <p style="margin: 0; color: #718096;">Discover our wide range of quality products</p>
        <% } %>
    </div>
</div>

<div class="amazon-product-section">
    <div style="background: #f7f7f7; padding: 20px; border-radius: 8px; margin-bottom: 20px;">
        <form action="ProductServlet" method="get" class="row g-2">
            <div class="col-md-3">
                <input type="text" name="q" class="form-control" placeholder="Search products..."
                       value="<%=request.getAttribute("searchTerm") != null ? request.getAttribute("searchTerm") : ""%>">
            </div>
            <div class="col-md-2">
                <input type="number" step="0.01" min="0" name="minPrice" class="form-control" placeholder="Min price"
                       value="<%=request.getAttribute("minPrice") != null ? request.getAttribute("minPrice") : ""%>">
            </div>
            <div class="col-md-2">
                <input type="number" step="0.01" min="0" name="maxPrice" class="form-control" placeholder="Max price"
                       value="<%=request.getAttribute("maxPrice") != null ? request.getAttribute("maxPrice") : ""%>">
            </div>
            <div class="col-md-2">
                <select name="category" class="form-select">
                    <option value="">All Categories</option>
                    <%
                    List<Category> filterCategories = (List<Category>) request.getAttribute("categories");
                    Integer selectedCategory = (Integer) request.getAttribute("category");
                    if (filterCategories != null) {
                        for (Category cat : filterCategories) {
                    %>
                    <option value="<%=cat.getId()%>" <%=selectedCategory != null && selectedCategory.equals(cat.getId()) ? "selected" : ""%>><%=cat.getName()%></option>
                    <%
                        }
                    }
                    %>
                </select>
            </div>
            <div class="col-md-2">
                <select name="rating" class="form-select">
                    <option value="">Min rating</option>
                    <% for (int r = 5; r >= 1; r--) { %>
                        <option value="<%=r%>" <%=request.getAttribute("rating") != null && request.getAttribute("rating").toString().equals(String.valueOf(r)) ? "selected" : ""%>><%=r%>+ Stars</option>
                    <% } %>
                </select>
            </div>
            <div class="col-md-1">
                <select name="sort" class="form-select">
                    <option value="">Sort by</option>
                    <option value="price_asc" <%=request.getParameter("sort") != null && request.getParameter("sort").equals("price_asc") ? "selected" : ""%>>Price: Low to High</option>
                    <option value="price_desc" <%=request.getParameter("sort") != null && request.getParameter("sort").equals("price_desc") ? "selected" : ""%>>Price: High to Low</option>
                    <option value="rating_desc" <%=request.getParameter("sort") != null && request.getParameter("sort").equals("rating_desc") ? "selected" : ""%>>Highest Rated</option>
                    <option value="name_asc" <%=request.getParameter("sort") != null && request.getParameter("sort").equals("name_asc") ? "selected" : ""%>>Name: A to Z</option>
                    <option value="name_desc" <%=request.getParameter("sort") != null && request.getParameter("sort").equals("name_desc") ? "selected" : ""%>>Name: Z to A</option>
                </select>
            </div>
            <div class="col-md-1">
                <button type="submit" class="btn btn-warning w-100" style="background: #ffd814; border: none; color: #0f1111;"><i class="fas fa-search"></i></button>
            </div>
        </form>
    </div>

    <div class="row mb-4">
        <div class="col-md-12">
            <%
            Integer activeCategory = (Integer) request.getAttribute("category");
            String categoryName = (String) request.getAttribute("categoryName");
            %>
            <% if (activeCategory != null && categoryName != null) { %>
            <div style="margin-bottom: 15px;">
                <h4 style="margin: 0 0 10px 0;">Filtering by: <strong style="color: #ffa41c;"><%=categoryName%></strong></h4>
                <a href="ProductServlet" class="btn btn-sm btn-outline-secondary" style="text-decoration: none;">
                    <i class="fas fa-times"></i> Clear Filter
                </a>
            </div>
            <% } else { %>
            <h4 style="margin-bottom: 15px;">Browse by Category</h4>
            <% } %>
            <div class="btn-group flex-wrap" role="group" style="gap: 8px;">
                <a href="ProductServlet" class="btn <%=activeCategory == null ? "btn-primary" : "btn-outline-primary"%>" style="margin-bottom: 8px;">All Products</a>
                <%
                List<Category> categories = (List<Category>) request.getAttribute("categories");
                if (categories != null) {
                    for (Category cat : categories) {
                        boolean isActive = activeCategory != null && activeCategory.equals(cat.getId());
                %>
                    <a href="ProductServlet?category=<%=cat.getId()%>" class="btn <%=isActive ? "btn-primary" : "btn-outline-primary"%>" style="margin-bottom: 8px;"><%=cat.getName()%></a>
                <%
                    }
                }
                %>
            </div>
        </div>
    </div>
</div>

<div class="amazon-product-section" style="margin-top: 20px;">
    <%
    List<Product> list = (List<Product>) request.getAttribute("products");
    Integer activeCategory = (Integer) request.getAttribute("category");
    if (list != null && !list.isEmpty()) {
    %>
    <% if (activeCategory != null) { %>
    <div style="margin-bottom: 15px; padding: 10px; background: #f0f8ff; border-left: 4px solid #ffa41c; border-radius: 4px;">
        <strong>Showing <%=list.size()%> product<%=list.size() != 1 ? "s" : ""%> in this category</strong>
    </div>
    <% } %>
    <div class="amazon-products-grid">
        <%
        for (Product p : list) {
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
        <a href="product-detail?id=<%=p.getId()%>" class="amazon-product-card amazon-product-card-scroll" style="text-decoration: none; color: inherit; display: flex; flex-direction: column; height: 100%;">
            <div class="amazon-product-image-container" style="width: 100%; height: 250px; min-height: 250px; background: #fff; border: 1px solid #e7e7e7; border-radius: 8px; display: flex; align-items: center; justify-content: center; overflow: hidden; position: relative;">
                <% if (imgSrc != null && !imgSrc.isEmpty()) { %>
                <img src="<%=imgSrc%>" alt="<%=p.getName()%>" class="amazon-product-image"
                     style="width: 100%; height: 100%; object-fit: contain; padding: 15px; display: block;"
                     onerror="this.style.display='none'; this.nextElementSibling.style.display='flex';"
                     onload="this.style.display='block'; this.nextElementSibling.style.display='none';">
                <div class="amazon-product-image-placeholder" style="display: none; width: 100%; height: 100%; background: linear-gradient(135deg, #f5f7fa 0%, #e8ecf1 100%); align-items: center; justify-content: center; font-size: 4rem; opacity: 0.4;">📦</div>
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
                <div class="amazon-product-prime" style="font-size: 0.75rem; color: #007185; margin-top: 5px; font-weight: 600;">Prime</div>
            </div>
        </a>
        <%
        }
        %>
    </div>
    <%
    } else {
    %>
    <div class="products-empty" style="grid-column: 1 / -1; text-align: center; padding: 60px 20px;">
        <div class="products-empty-icon">📦</div>
        <h3>No Products Found</h3>
        <p>Try adjusting your search or filters</p>
    </div>
    <%
    }
    %>
</div>

<%
Integer page = (Integer) request.getAttribute("page");
Integer totalPages = (Integer) request.getAttribute("totalPages");
if (page == null) page = 1;
if (totalPages == null) totalPages = 1;
if (totalPages < 1) totalPages = 1;
String baseQuery = "";
String searchTerm = (String) request.getAttribute("searchTerm");
Object minPriceVal = request.getAttribute("minPrice");
Object maxPriceVal = request.getAttribute("maxPrice");
Object ratingVal = request.getAttribute("rating");
Object categoryVal = request.getAttribute("category");
java.util.List<String> qs = new java.util.ArrayList<>();
if (searchTerm != null && !searchTerm.isEmpty()) qs.add("q=" + java.net.URLEncoder.encode(searchTerm, "UTF-8"));
if (categoryVal != null) qs.add("category=" + categoryVal);
if (minPriceVal != null) qs.add("minPrice=" + minPriceVal);
if (maxPriceVal != null) qs.add("maxPrice=" + maxPriceVal);
if (ratingVal != null) qs.add("rating=" + ratingVal);
baseQuery = String.join("&", qs);
%>
<div class="amazon-product-section">
    <nav aria-label="Product pages" class="mt-4 mb-4">
        <ul class="pagination">
            <li class="page-item <%=page <= 1 ? "disabled" : ""%>">
                <a class="page-link" href="ProductServlet?<%=baseQuery%><%=baseQuery.isEmpty() ? "" : "&"%>page=<%=page-1%>">Previous</a>
            </li>
            <% for (int i = 1; i <= totalPages; i++) { %>
                <li class="page-item <%=i == page ? "active" : ""%>">
                    <a class="page-link" href="ProductServlet?<%=baseQuery%><%=baseQuery.isEmpty() ? "" : "&"%>page=<%=i%>"><%=i%></a>
                </li>
            <% } %>
            <li class="page-item <%=page >= totalPages ? "disabled" : ""%>">
                <a class="page-link" href="ProductServlet?<%=baseQuery%><%=baseQuery.isEmpty() ? "" : "&"%>page=<%=page+1%>">Next</a>
            </li>
        </ul>
    </nav>
</div>

</div>
<!-- Close amazon-main-container -->

<div class="container">
<%@ include file="includes/footer.jsp" %>
