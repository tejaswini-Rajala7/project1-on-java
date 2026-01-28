<%@ page import="dao.OrderDAO,dao.ProductDAO,dao.UserDAO" %>
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
        <h2 class="amazon-section-title"><i class="fas fa-tachometer-alt"></i> Admin Dashboard</h2>
    </div>
</div>

<div class="row">
    <div class="col-md-3 mb-4">
        <div class="card text-center">
            <div class="card-body">
                <i class="fas fa-box fa-3x text-primary mb-3"></i>
                <h3><%=ProductDAO.getAllProducts().size()%></h3>
                <p>Total Products</p>
                <a href="products" class="btn btn-primary">Manage Products</a>
                <a href="seed-products" class="btn btn-success mt-2" style="display: block;">🌱 Seed Products</a>
            </div>
        </div>
    </div>
    <div class="col-md-3 mb-4">
        <div class="card text-center">
            <div class="card-body">
                <i class="fas fa-shopping-bag fa-3x text-success mb-3"></i>
                <h3><%=OrderDAO.getAllOrders().size()%></h3>
                <p>Total Orders</p>
                <a href="orders" class="btn btn-success">Manage Orders</a>
            </div>
        </div>
    </div>
    <div class="col-md-3 mb-4">
        <div class="card text-center">
            <div class="card-body">
                <i class="fas fa-users fa-3x text-info mb-3"></i>
                <h3>Users</h3>
                <p>Customer Management</p>
                <a href="#" class="btn btn-info">View Users</a>
            </div>
        </div>
    </div>
    <div class="col-md-3 mb-4">
        <div class="card text-center">
            <div class="card-body">
                <i class="fas fa-chart-line fa-3x text-warning mb-3"></i>
                <h3>Reports</h3>
                <p>Sales & Analytics</p>
                <a href="#" class="btn btn-warning">View Reports</a>
            </div>
        </div>
    </div>
</div>

<div class="row mt-4">
    <div class="col-md-12">
        <div class="card">
            <div class="card-header">
                <h5>Recent Orders</h5>
            </div>
            <div class="card-body">
                <div class="table-responsive">
                    <table class="table">
                        <thead>
                            <tr>
                                <th>Order ID</th>
                                <th>Customer</th>
                                <th>Amount</th>
                                <th>Status</th>
                                <th>Date</th>
                                <th>Actions</th>
                            </tr>
                        </thead>
                        <tbody>
                            <%
                            java.util.List<model.Order> recentOrders = OrderDAO.getAllOrders();
                            int count = 0;
                            for (model.Order order : recentOrders) {
                                if (count++ >= 5) break;
                            %>
                            <tr>
                                <td>#<%=order.getId()%></td>
                                <td><%=order.getUserName()%></td>
                                <td class="price">₹<%=String.format("%.2f", order.getTotalAmount())%></td>
                                <td>
                                    <span class="badge bg-<%=order.getStatus().equals("delivered") ? "success" : 
                                        order.getStatus().equals("cancelled") ? "danger" : "warning"%>">
                                        <%=order.getStatus()%>
                                    </span>
                                </td>
                                <td><%=order.getOrderDate() != null ? order.getOrderDate().toString() : ""%></td>
                                <td>
                                    <a href="orders?action=details&id=<%=order.getId()%>" class="btn btn-sm btn-primary">
                                        <i class="fas fa-eye"></i>
                                    </a>
                                </td>
                            </tr>
                            <% } %>
                        </tbody>
                    </table>
                </div>
            </div>
        </div>
    </div>
</div>

</div>
<!-- Close amazon-main-container -->

<div class="container">
<%@ include file="../includes/footer.jsp" %>
