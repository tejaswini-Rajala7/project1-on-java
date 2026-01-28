<%@ include file="includes/amazon-header.jsp" %>
<%@ page import="java.util.*,model.Order" %>

</div>
<!-- Close amazon-main-container from header -->

<div class="amazon-main-container">
<div class="amazon-product-section" style="margin-top: 20px;">
    <div class="amazon-section-header">
        <h2 class="amazon-section-title"><i class="fas fa-history"></i> Order History</h2>
    </div>
</div>

<%
List<Order> orders = (List<Order>) request.getAttribute("orders");
if (orders == null || orders.isEmpty()) {
%>
    <div class="alert alert-info text-center">
        <i class="fas fa-shopping-bag fa-3x mb-3"></i>
        <h3>No orders yet</h3>
        <p>Start shopping to see your orders here!</p>
        <a href="ProductServlet" class="btn btn-primary">Browse Products</a>
    </div>
<%
} else {
%>
<div class="table-responsive">
    <table class="table table-hover">
        <thead>
            <tr>
                <th>Order ID</th>
                <th>Date</th>
                <th>Total Amount</th>
                <th>Status</th>
                <th>Payment</th>
                <th>Actions</th>
            </tr>
        </thead>
        <tbody>
            <% for (Order order : orders) { %>
            <tr>
                <td>#<%=order.getId()%></td>
                <td><%=order.getOrderDate() != null ? order.getOrderDate().toString() : ""%></td>
                <td class="price">₹<%=String.format("%.2f", order.getTotalAmount())%></td>
                <td>
                    <span class="badge bg-<%=order.getStatus().equals("delivered") ? "success" : 
                        order.getStatus().equals("cancelled") ? "danger" : "warning"%>">
                        <%=order.getStatus()%>
                    </span>
                </td>
                <td>
                    <span class="badge bg-<%=order.getPaymentStatus().equals("paid") ? "success" : "warning"%>">
                        <%=order.getPaymentStatus()%>
                    </span>
                </td>
                <td>
                    <a href="order?action=details&orderId=<%=order.getId()%>" class="btn btn-sm btn-primary">
                        <i class="fas fa-eye"></i> View Details
                    </a>
                </td>
            </tr>
            <% } %>
        </tbody>
    </table>
</div>
<%
}
%>

</div>
<!-- Close amazon-main-container -->

<div class="container">
<%@ include file="includes/footer.jsp" %>
