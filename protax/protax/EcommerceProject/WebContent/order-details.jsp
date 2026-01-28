<%@ include file="includes/amazon-header.jsp" %>
<%@ page import="model.Order,java.util.*,model.OrderItem" %>

<%
Order order = (Order) request.getAttribute("order");
List<OrderItem> items = (List<OrderItem>) request.getAttribute("items");
if (items == null) items = new ArrayList<>();
%>

</div>
<!-- Close amazon-main-container from header -->

<div class="amazon-main-container">
<div class="amazon-product-section" style="margin-top: 20px;">
    <div class="amazon-section-header">
        <h2 class="amazon-section-title"><i class="fas fa-receipt"></i> Order Details</h2>
    </div>
</div>

<% if (order != null) { %>
<div class="row">
    <div class="col-md-8">
        <div class="card mb-4">
            <div class="card-header">
                <h5>Order Information</h5>
            </div>
            <div class="card-body">
                <p><strong>Order ID:</strong> #<%=order.getId()%></p>
                <p><strong>Order Date:</strong> <%=order.getOrderDate() != null ? order.getOrderDate().toString() : ""%></p>
                <p><strong>Status:</strong> 
                    <span class="badge bg-<%=order.getStatus().equals("delivered") ? "success" : 
                        order.getStatus().equals("cancelled") ? "danger" : "warning"%>">
                        <%=order.getStatus()%>
                    </span>
                </p>
                <p><strong>Payment Method:</strong> <%=order.getPaymentMethod()%></p>
                <p><strong>Payment Status:</strong> 
                    <span class="badge bg-<%=order.getPaymentStatus().equals("paid") ? "success" : "warning"%>">
                        <%=order.getPaymentStatus()%>
                    </span>
                </p>
            </div>
        </div>

        <div class="card">
            <div class="card-header">
                <h5>Delivery Address</h5>
            </div>
            <div class="card-body">
                <p><%=order.getAddressDetails() != null ? order.getAddressDetails() : ""%></p>
            </div>
        </div>

        <div class="card mt-4">
            <div class="card-header">
                <h5>Order Items</h5>
            </div>
            <div class="card-body">
                <div class="table-responsive">
                    <table class="table">
                        <thead>
                            <tr>
                                <th>Product</th>
                                <th>Quantity</th>
                                <th>Price</th>
                                <th>Subtotal</th>
                            </tr>
                        </thead>
                        <tbody>
                            <% for (OrderItem item : items) { %>
                            <tr>
                                <td>
                                    <div class="d-flex align-items-center">
                                        <%
                                        String itemImg = item.getProductImage();
                                        boolean itemAbs = itemImg != null && (itemImg.startsWith("http://") || itemImg.startsWith("https://"));
                                        String itemImgSrc = itemImg != null ? (itemAbs ? itemImg : request.getContextPath() + "/" + itemImg) : null;
                                        %>
                                        <% if (itemImgSrc != null) { %>
                                        <img src="<%=itemImgSrc%>" 
                                             class="img-thumbnail me-2" style="width: 50px; height: 50px; object-fit: contain;">
                                        <% } else { %>
                                        <div class="amazon-product-image-placeholder me-2" style="width: 50px; height: 50px; font-size: 1.5rem;">📦</div>
                                        <% } %>
                                        <%=item.getProductName()%>
                                    </div>
                                </td>
                                <td><%=item.getQuantity()%></td>
                                <td>₹<%=String.format("%.2f", item.getPrice())%></td>
                                <td>₹<%=String.format("%.2f", item.getSubtotal())%></td>
                            </tr>
                            <% } %>
                        </tbody>
                    </table>
                </div>
            </div>
        </div>
    </div>

    <div class="col-md-4">
        <div class="card">
            <div class="card-header">
                <h5>Order Summary</h5>
            </div>
            <div class="card-body">
                <div class="d-flex justify-content-between mb-2">
                    <span>Subtotal:</span>
                    <span>₹<%=String.format("%.2f", order.getTotalAmount() - 50)%></span>
                </div>
                <div class="d-flex justify-content-between mb-2">
                    <span>Shipping:</span>
                    <span>₹50.00</span>
                </div>
                <hr>
                <div class="d-flex justify-content-between mb-3">
                    <strong>Total:</strong>
                    <strong class="price">₹<%=String.format("%.2f", order.getTotalAmount())%></strong>
                </div>
                <a href="order?action=history" class="btn btn-outline-secondary w-100">
                    <i class="fas fa-arrow-left"></i> Back to Orders
                </a>
            </div>
        </div>
    </div>
    </div>
<% } else { %>
    <div class="amazon-product-section">
        <div class="alert alert-danger">
            Order not found.
        </div>
    </div>
<% } %>

</div>
<!-- Close amazon-main-container -->

<div class="container">
<%@ include file="includes/footer.jsp" %>
