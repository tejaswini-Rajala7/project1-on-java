<%@ page import="model.Product,java.util.*,model.Category" %>
<%
    HttpSession session = request.getSession(false);
    if (session == null || !"admin".equals(session.getAttribute("userRole"))) {
        response.sendRedirect("../login.jsp");
        return;
    }
    Product product = (Product) request.getAttribute("product");
    List<Category> categories = (List<Category>) request.getAttribute("categories");
    boolean isEdit = product != null;
%>
<%@ include file="../includes/amazon-header.jsp" %>

</div>
<!-- Close amazon-main-container from header -->

<div class="amazon-main-container">
<div class="amazon-product-section" style="margin-top: 20px;">
    <div class="amazon-section-header">
        <h2 class="amazon-section-title"><i class="fas fa-<%=isEdit ? "edit" : "plus"%>"></i> <%=isEdit ? "Edit" : "Add"%> Product</h2>
    </div>
</div>

<div class="row justify-content-center">
    <div class="col-md-8">
        <div class="card">
            <div class="card-body">
                <form action="products" method="post" enctype="multipart/form-data">
                    <input type="hidden" name="action" value="<%=isEdit ? "update" : "add"%>">
                    <% if (isEdit) { %>
                        <input type="hidden" name="id" value="<%=product.getId()%>">
                    <% } %>
                    
                    <div class="mb-3">
                        <label class="form-label">Product Name</label>
                        <input type="text" name="name" class="form-control" 
                               value="<%=isEdit ? product.getName() : ""%>" required>
                    </div>
                    
                    <div class="mb-3">
                        <label class="form-label">Description</label>
                        <textarea name="description" class="form-control" rows="3" required><%=isEdit ? product.getDescription() : ""%></textarea>
                    </div>
                    
                    <div class="row">
                        <div class="col-md-6 mb-3">
                            <label class="form-label">Price</label>
                            <input type="number" step="0.01" name="price" class="form-control" 
                                   value="<%=isEdit ? product.getPrice() : ""%>" required>
                        </div>
                        <div class="col-md-6 mb-3">
                            <label class="form-label">Stock</label>
                            <input type="number" name="stock" class="form-control" 
                                   value="<%=isEdit ? product.getStock() : ""%>" required>
                        </div>
                    </div>
                    
                    <div class="row">
                        <div class="col-md-6 mb-3">
                            <label class="form-label">Category</label>
                            <select name="categoryId" class="form-select" required>
                                <option value="">Select Category</option>
                                <% if (categories != null) {
                                    for (Category cat : categories) {
                                %>
                                    <option value="<%=cat.getId()%>" 
                                            <%=isEdit && product.getCategoryId() == cat.getId() ? "selected" : ""%>>
                                        <%=cat.getName()%>
                                    </option>
                                <% } } %>
                            </select>
                        </div>
                        <div class="col-md-6 mb-3">
                            <label class="form-label">Brand</label>
                            <input type="text" name="brand" class="form-control" 
                                   value="<%=isEdit ? product.getBrand() : ""%>">
                        </div>
                    </div>
                    
                    <div class="row">
                        <div class="col-md-6 mb-3">
                            <label class="form-label">Upload Image</label>
                            <input type="file" name="imageFile" class="form-control" accept="image/*">
                            <small class="text-muted">Upload will override image URL if both are provided.</small>
                        </div>
                        <div class="col-md-6 mb-3">
                            <label class="form-label">Image URL</label>
                            <input type="url" name="imageUrl" class="form-control"
                                   value="<%=isEdit ? product.getImageUrl() : ""%>"
                                   placeholder="https://example.com/image.jpg">
                        </div>
                    </div>
                    <% if (isEdit && product.getImageUrl() != null && !product.getImageUrl().isEmpty()) {
                        String img = product.getImageUrl();
                        String imgSrc = null;
                        if (img.startsWith("http://") || img.startsWith("https://")) {
                            imgSrc = img;
                        } else if (img.startsWith("/")) {
                            imgSrc = request.getContextPath() + img;
                        } else {
                            imgSrc = request.getContextPath() + "/" + img;
                        }
                    %>
                        <div class="mb-3">
                            <label class="form-label">Current Image</label><br>
                            <div class="amazon-product-image-container" style="max-width: 200px; height: 200px;">
                                <% if (imgSrc != null) { %>
                                <img src="<%=imgSrc%>" alt="Current image" class="amazon-product-image"
                                     onerror="this.style.display='none'; this.nextElementSibling.style.display='flex';">
                                <div class="amazon-product-image-placeholder" style="display: none;">📦</div>
                                <% } else { %>
                                <div class="amazon-product-image-placeholder">📦</div>
                                <% } %>
                            </div>
                        </div>
                    <% } %>
                    
                    <button type="submit" class="btn btn-primary">
                        <i class="fas fa-save"></i> <%=isEdit ? "Update" : "Add"%> Product
                    </button>
                    <a href="products" class="btn btn-secondary">Cancel</a>
                </form>
            </div>
        </div>
    </div>
</div>

</div>
<!-- Close amazon-main-container -->

<div class="container">
<%@ include file="../includes/footer.jsp" %>
