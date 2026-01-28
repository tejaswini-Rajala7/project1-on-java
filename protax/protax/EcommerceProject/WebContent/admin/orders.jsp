<%@ page import="java.util.*,model.Order" %>
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
        <h2 class="amazon-section-title"><i class="fas fa-shopping-bag"></i> Manage Orders</h2>
    </div>
</div>

<div class="table-responsive">
    <table class="table table-hover">
        <thead>
            <tr>
                <th>Order ID</th>
                <th>Customer</th>
                <th>Amount</th>
                <th>Status</th>
                <th>Payment</th>
                <th>Date</th>
                <th>Actions</th>
            </tr>
        </thead>
        <tbody>
            <%
            List<Order> orders = (List<Order>) request.getAttribute("orders");
            if (orders != null) {
                for (Order order : orders) {
            %>
            <tr>
                <td>#<%=order.getId()%></td>
                <td><%=order.getUserName()%></td>
                <td class="price">₹<%=String.format("%.2f", order.getTotalAmount())%></td>
                <td>
                    <form action="orders" method="post" class="d-inline">
                        <input type="hidden" name="orderId" value="<%=order.getId()%>">
                        <select name="status" class="form-select form-select-sm" 
                                onchange="this.form.submit()">
                            <option value="pending" <%=order.getStatus().equals("pending") ? "selected" : ""%>>Pending</option>
                            <option value="confirmed" <%=order.getStatus().equals("confirmed") ? "selected" : ""%>>Confirmed</option>
                            <option value="shipped" <%=order.getStatus().equals("shipped") ? "selected" : ""%>>Shipped</option>
                            <option value="delivered" <%=order.getStatus().equals("delivered") ? "selected" : ""%>>Delivered</option>
                            <option value="cancelled" <%=order.getStatus().equals("cancelled") ? "selected" : ""%>>Cancelled</option>
                        </select>
                    </form>
                </td>
                <td>
                    <span class="badge bg-<%=order.getPaymentStatus().equals("paid") ? "success" : "warning"%>">
                        <%=order.getPaymentStatus()%>
                    </span>
                </td>
                <td><%=order.getOrderDate() != null ? order.getOrderDate().toString() : ""%></td>
                <td>
                    <a href="orders?action=details&id=<%=order.getId()%>" class="btn btn-sm btn-primary">
                        <i class="fas fa-eye"></i> View
                    </a>
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
