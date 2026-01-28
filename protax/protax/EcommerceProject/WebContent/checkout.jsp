<%@ include file="includes/amazon-header.jsp" %>
<%@ page import="java.util.*,model.Cart,model.Address" %>

</div>
<!-- Close amazon-main-container from header -->

<div class="amazon-main-container">
<div class="amazon-product-section" style="margin-top: 20px;">
    <div class="amazon-section-header">
        <h2 class="amazon-section-title"><i class="fas fa-credit-card"></i> Checkout</h2>
    </div>
</div>

<%
List<Cart> cartList = (List<Cart>) request.getAttribute("cartList");
List<Address> addresses = (List<Address>) request.getAttribute("addresses");
Double subtotal = (Double) request.getAttribute("subtotal");
Double discount = (Double) request.getAttribute("discount");
Double shipping = (Double) request.getAttribute("shipping");
Double total = (Double) request.getAttribute("total");
String couponCode = (String) request.getAttribute("couponCode");
if (subtotal == null) subtotal = 0.0;
if (discount == null) discount = 0.0;
if (shipping == null) shipping = 50.0;
if (total == null) total = Math.max(0, subtotal - discount + shipping);
%>

<div class="row">
    <div class="col-md-8">
        <div class="card mb-4">
            <div class="card-header">
                <h5><i class="fas fa-map-marker-alt"></i> Select Delivery Address</h5>
            </div>
            <div class="card-body">
                <% if (addresses == null || addresses.isEmpty()) { %>
                    <div class="alert alert-warning">
                        <p>No address found. Please add an address first.</p>
                        <a href="address" class="btn btn-primary">Add Address</a>
                    </div>
                <% } else { %>
                    <form action="order" method="post">
                        <input type="hidden" name="action" value="place">
                        <div class="mb-3">
                            <% for (Address addr : addresses) { %>
                            <div class="form-check mb-3">
                                <input class="form-check-input" type="radio" name="addressId" 
                                       value="<%=addr.getId()%>" id="addr<%=addr.getId()%>" 
                                       <%=addr.isDefault() ? "checked" : ""%> required>
                                <label class="form-check-label" for="addr<%=addr.getId()%>">
                                    <strong><%=addr.getFullName()%></strong><br>
                                    <%=addr.getFullAddress()%><br>
                                    Phone: <%=addr.getPhone()%>
                                    <% if (addr.isDefault()) { %>
                                        <span class="badge bg-primary">Default</span>
                                    <% } %>
                                </label>
                            </div>
                            <% } %>
                        </div>
                        <a href="address" class="btn btn-outline-primary">
                            <i class="fas fa-plus"></i> Add New Address
                        </a>
                        
                        <div class="card mt-4">
                            <div class="card-header">
                                <h5><i class="fas fa-money-bill-wave"></i> Payment Method</h5>
                            </div>
                            <div class="card-body">
                                <div class="form-check mb-2">
                                    <input class="form-check-input" type="radio" name="paymentMethod" 
                                           value="Cash on Delivery" id="cod" checked required>
                                    <label class="form-check-label" for="cod">
                                        <i class="fas fa-money-bill"></i> Cash on Delivery
                                    </label>
                                </div>
                                <div class="form-check mb-2">
                                    <input class="form-check-input" type="radio" name="paymentMethod" 
                                           value="Credit Card" id="card">
                                    <label class="form-check-label" for="card">
                                        <i class="fas fa-credit-card"></i> Credit Card
                                    </label>
                                </div>
                                <div class="form-check mb-2">
                                    <input class="form-check-input" type="radio" name="paymentMethod" 
                                           value="UPI" id="upi">
                                    <label class="form-check-label" for="upi">
                                        <i class="fas fa-mobile-alt"></i> UPI
                                    </label>
                                </div>
                                <div class="form-check mb-2">
                                    <input class="form-check-input" type="radio" name="paymentMethod"
                                           value="Stripe Test" id="stripe">
                                    <label class="form-check-label" for="stripe">
                                        <i class="fas fa-credit-card"></i> Stripe Test (auto-approve)
                                    </label>
                                </div>
                                <div class="form-check mb-2">
                                    <input class="form-check-input" type="radio" name="paymentMethod"
                                           value="Razorpay Test" id="razorpay">
                                    <label class="form-check-label" for="razorpay">
                                        <i class="fas fa-credit-card"></i> Razorpay Test (auto-approve)
                                    </label>
                                </div>
                            </div>
                        </div>
                <% } %>
            </div>
        </div>
    </div>

    <div class="col-md-4">
        <div class="card">
            <div class="card-header">
                <h5>Order Summary</h5>
            </div>
            <div class="card-body">
                <%
                if (cartList != null) {
                    for (Cart c : cartList) {
                %>
                <div class="d-flex justify-content-between mb-2">
                    <span><%=c.getProductName()%> x <%=c.getQuantity()%></span>
                    <span>₹<%=String.format("%.2f", c.getSubtotal())%></span>
                </div>
                <%
                    }
                }
                %>
                <hr>
                <div class="mb-3">
                    <div class="input-group">
                        <input type="text" class="form-control" name="coupon" placeholder="Enter coupon code"
                               value="<%=couponCode != null ? couponCode : ""%>">
                        <button class="btn btn-outline-secondary" type="submit" formaction="checkout" formmethod="get" formnovalidate>Apply</button>
                    </div>
                    <% if (request.getAttribute("couponError") != null) { %>
                        <small class="text-danger"><%=request.getAttribute("couponError")%></small>
                    <% } else if (discount > 0) { %>
                        <small class="text-success">Coupon applied. You saved ₹<%=String.format("%.2f", discount)%></small>
                    <% } %>
                </div>
                <div class="d-flex justify-content-between mb-2">
                    <span>Subtotal:</span>
                    <span>₹<%=String.format("%.2f", subtotal)%></span>
                </div>
                <div class="d-flex justify-content-between mb-2">
                    <span>Discount:</span>
                    <span class="text-success">-₹<%=String.format("%.2f", discount)%></span>
                </div>
                <div class="d-flex justify-content-between mb-2">
                    <span>Shipping:</span>
                    <span>₹<%=String.format("%.2f", shipping)%></span>
                </div>
                <hr>
                <div class="d-flex justify-content-between mb-3">
                    <strong>Total:</strong>
                    <strong class="price">₹<%=String.format("%.2f", total)%></strong>
                </div>
                <% if (addresses != null && !addresses.isEmpty()) { %>
                    <input type="hidden" name="couponCode" value="<%=couponCode != null ? couponCode : ""%>">
                    <button type="submit" class="btn btn-primary w-100">
                        <i class="fas fa-check"></i> Place Order
                    </button>
                <% } %>
                </form>
            </div>
        </div>
    </div>
</div>

</div>
<!-- Close amazon-main-container -->

<div class="container">
<%@ include file="includes/footer.jsp" %>
