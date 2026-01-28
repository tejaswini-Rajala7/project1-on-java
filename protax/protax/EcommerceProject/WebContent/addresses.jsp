<%@ include file="includes/amazon-header.jsp" %>
<%@ page import="java.util.*,model.Address" %>

</div>
<!-- Close amazon-main-container from header -->

<div class="amazon-main-container">
<div class="amazon-product-section" style="margin-top: 20px;">
    <div class="amazon-section-header">
        <h2 class="amazon-section-title"><i class="fas fa-map-marker-alt"></i> My Addresses</h2>
    </div>
</div>

<div class="row">
    <div class="col-md-8">
        <%
        List<Address> addresses = (List<Address>) request.getAttribute("addresses");
        if (addresses == null || addresses.isEmpty()) {
        %>
            <div class="alert alert-info">
                <p>No addresses found. Add your first address below.</p>
            </div>
        <%
        } else {
            for (Address addr : addresses) {
        %>
            <div class="card mb-3">
                <div class="card-body">
                    <% if (addr.isDefault()) { %>
                        <span class="badge bg-primary mb-2">Default</span>
                    <% } %>
                    <h5><%=addr.getFullName()%></h5>
                    <p><%=addr.getFullAddress()%></p>
                    <p><strong>Phone:</strong> <%=addr.getPhone()%></p>
                    <form action="address" method="post" class="d-inline">
                        <input type="hidden" name="action" value="delete">
                        <input type="hidden" name="addressId" value="<%=addr.getId()%>">
                        <button type="submit" class="btn btn-danger btn-sm" 
                                onclick="return confirm('Are you sure you want to delete this address?')">
                            <i class="fas fa-trash"></i> Delete
                        </button>
                    </form>
                </div>
            </div>
        <%
            }
        }
        %>
    </div>
    <div class="col-md-4">
        <div class="card">
            <div class="card-header">
                <h5>Add New Address</h5>
            </div>
            <div class="card-body">
                <form action="address" method="post">
                    <input type="hidden" name="action" value="add">
                    <div class="mb-3">
                        <label class="form-label">Full Name</label>
                        <input type="text" name="fullName" class="form-control" required>
                    </div>
                    <div class="mb-3">
                        <label class="form-label">Phone</label>
                        <input type="text" name="phone" class="form-control" required>
                    </div>
                    <div class="mb-3">
                        <label class="form-label">Address Line 1</label>
                        <input type="text" name="addressLine1" class="form-control" required>
                    </div>
                    <div class="mb-3">
                        <label class="form-label">Address Line 2</label>
                        <input type="text" name="addressLine2" class="form-control">
                    </div>
                    <div class="mb-3">
                        <label class="form-label">City</label>
                        <input type="text" name="city" class="form-control" required>
                    </div>
                    <div class="mb-3">
                        <label class="form-label">State</label>
                        <input type="text" name="state" class="form-control" required>
                    </div>
                    <div class="mb-3">
                        <label class="form-label">Pincode</label>
                        <input type="text" name="pincode" class="form-control" required>
                    </div>
                    <div class="mb-3 form-check">
                        <input type="checkbox" name="isDefault" class="form-check-input" id="isDefault">
                        <label class="form-check-label" for="isDefault">Set as default address</label>
                    </div>
                    <button type="submit" class="btn btn-primary w-100">
                        <i class="fas fa-plus"></i> Add Address
                    </button>
                </form>
            </div>
        </div>
    </div>
</div>

</div>
<!-- Close amazon-main-container -->

<div class="container">
<%@ include file="includes/footer.jsp" %>
