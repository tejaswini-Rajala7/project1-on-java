<%@ include file="includes/amazon-header.jsp" %>
<%@ page import="java.util.*,model.Cart,dao.CartDAO" %>

</div>
<!-- Close amazon-main-container from header -->

<div class="amazon-main-container">
<div class="amazon-product-section" style="margin-top: 20px;">
    <div class="amazon-section-header">
        <h2 class="amazon-section-title"><i class="fas fa-shopping-cart"></i> Shopping Cart</h2>
    </div>

<%
List<Cart> list = (List<Cart>) request.getAttribute("cartList");
if (list == null || list.isEmpty()) {
%>
    <div class="alert alert-info text-center">
        <i class="fas fa-shopping-cart fa-3x mb-3"></i>
        <h3>Your cart is empty</h3>
        <p>Start shopping to add items to your cart!</p>
        <a href="ProductServlet" class="btn btn-primary">Browse Products</a>
    </div>
<%
} else {
    double total = 0;
    for (Cart c : list) {
        total += c.getSubtotal();
    }
%>
<div class="row">
    <div class="col-md-8">
        <%
        for (Cart c : list) {
        %>
        <div class="cart-item">
            <div class="row">
                <div class="col-md-2">
                    <%
                        String img = c.getProductImage();
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
                    <div class="amazon-product-image-container" style="height: 120px; width: 120px; flex-shrink: 0;">
                        <% if (imgSrc != null) { %>
                        <img src="<%=imgSrc%>" 
                             class="amazon-product-image" alt="<%=c.getProductName()%>"
                             onerror="this.style.display='none'; this.nextElementSibling.style.display='flex';">
                        <div class="amazon-product-image-placeholder" style="height: 100%; display: none;">📦</div>
                        <% } else { %>
                        <div class="amazon-product-image-placeholder" style="height: 100%;">📦</div>
                        <% } %>
                    </div>
                </div>
                <div class="col-md-6">
                    <h5><%=c.getProductName()%></h5>
                    <p class="text-muted">Price: ₹<%=String.format("%.2f", c.getProductPrice())%></p>
                </div>
                <div class="col-md-2">
                    <form action="cart" method="post" class="d-inline">
                        <input type="hidden" name="action" value="update">
                        <input type="hidden" name="cartId" value="<%=c.getId()%>">
                        <input type="number" name="quantity" value="<%=c.getQuantity()%>" 
                               min="1" class="form-control" onchange="this.form.submit()">
                    </form>
                </div>
                <div class="col-md-2">
                    <p class="price">₹<%=String.format("%.2f", c.getSubtotal())%></p>
                    <form action="cart" method="post" class="d-inline">
                        <input type="hidden" name="action" value="remove">
                        <input type="hidden" name="cartId" value="<%=c.getId()%>">
                        <button type="submit" class="btn btn-danger btn-sm">
                            <i class="fas fa-trash"></i> Remove
                        </button>
                    </form>
                </div>
            </div>
        </div>
        <%
        }
        %>
    </div>
    <div class="col-md-4">
        <div class="card">
            <div class="card-body">
                <h5>Order Summary</h5>
                <hr>
                <div class="d-flex justify-content-between mb-2">
                    <span>Subtotal:</span>
                    <span>₹<%=String.format("%.2f", total)%></span>
                </div>
                <div class="d-flex justify-content-between mb-2">
                    <span>Shipping:</span>
                    <span>₹50.00</span>
                </div>
                <hr>
                <div class="d-flex justify-content-between mb-3">
                    <strong>Total:</strong>
                    <strong class="price">₹<%=String.format("%.2f", total + 50)%></strong>
                </div>
                <a href="checkout" class="btn btn-primary w-100">
                    <i class="fas fa-credit-card"></i> Proceed to Checkout
                </a>
                <a href="ProductServlet" class="btn btn-outline-secondary w-100 mt-2">
                    <i class="fas fa-arrow-left"></i> Continue Shopping
                </a>
            </div>
        </div>
    </div>
</div>
</div>
<%
}
%>

</div>
<!-- Close amazon-main-container -->

<div class="container">
<%@ include file="includes/footer.jsp" %>
