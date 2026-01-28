<%@ page import="java.util.*,model.Product" %>
<%
    HttpSession session = request.getSession(false);
    if (session == null || !"admin".equals(session.getAttribute("userRole"))) {
        response.sendRedirect("../login.jsp");
        return;
    }
%>
<%@ include file="../includes/amazon-header.jsp" %>

</div>
<!-- Close amazon-main-container from header -->

<div class="amazon-main-container">
<div class="amazon-product-section" style="margin-top: 20px;">
    <div class="amazon-section-header">
        <h2 class="amazon-section-title"><i class="fas fa-box"></i> Manage Products</h2>
    </div>
</div>

<div class="mb-3">
    <a href="products?action=add" class="btn btn-primary">
        <i class="fas fa-plus"></i> Add New Product
    </a>
</div>

<div class="table-responsive">
    <table class="table table-hover">
        <thead>
            <tr>
                <th>ID</th>
                <th>Image</th>
                <th>Name</th>
                <th>Category</th>
                <th>Price</th>
                <th>Stock</th>
                <th>Rating</th>
                <th>Actions</th>
            </tr>
        </thead>
        <tbody>
            <%
            List<Product> products = (List<Product>) request.getAttribute("products");
            if (products != null) {
                for (Product p : products) {
            %>
            <tr>
                <td><%=p.getId()%></td>
                <td>
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
                    <% if (imgSrc != null) { %>
                    <img src="<%=imgSrc%>" 
                         class="img-thumbnail" style="width: 50px; height: 50px; object-fit: contain;"
                         onerror="this.style.display='none'; this.nextElementSibling.style.display='flex';">
                    <div class="amazon-product-image-placeholder" style="width: 50px; height: 50px; font-size: 1.5rem; display: none;">📦</div>
                    <% } else { %>
                    <div class="amazon-product-image-placeholder" style="width: 50px; height: 50px; font-size: 1.5rem;">📦</div>
                    <% } %>
                </td>
                <td><%=p.getName()%></td>
                <td><%=p.getCategoryName() != null ? p.getCategoryName() : "N/A"%></td>
                <td>₹<%=String.format("%.2f", p.getPrice())%></td>
                <td><%=p.getStock()%></td>
                <td><%=String.format("%.1f", p.getRating())%></td>
                <td>
                    <a href="products?action=edit&id=<%=p.getId()%>" class="btn btn-sm btn-warning">
                        <i class="fas fa-edit"></i> Edit
                    </a>
                    <form action="products" method="post" class="d-inline">
                        <input type="hidden" name="action" value="delete">
                        <input type="hidden" name="id" value="<%=p.getId()%>">
                        <button type="submit" class="btn btn-sm btn-danger" 
                                onclick="return confirm('Are you sure you want to delete this product?')">
                            <i class="fas fa-trash"></i> Delete
                        </button>
                    </form>
                </td>
            </tr>
            <% } } %>
        </tbody>
    </table>
</div>

</div>
<!-- Close amazon-main-container -->

<div class="container">
<%@ include file="../includes/footer.jsp" %>
