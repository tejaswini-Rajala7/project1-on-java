<%@ include file="includes/amazon-header.jsp" %>

</div>
<!-- Close amazon-main-container from header -->

<div class="amazon-main-container">
<div class="row justify-content-center" style="margin-top: 40px;">
    <div class="col-md-5">
        <div class="card">
            <div class="card-body">
                <h2 class="text-center mb-4"><i class="fas fa-sign-in-alt"></i> Login</h2>
                
                <% if (request.getAttribute("error") != null) { %>
                    <div class="alert alert-danger">
                        <%= request.getAttribute("error") %>
                    </div>
                <% } %>

                <form action="login" method="post">
                    <div class="mb-3">
                        <label class="form-label">Email</label>
                        <input type="email" name="email" class="form-control" required>
                    </div>
                    <div class="mb-3">
                        <label class="form-label">Password</label>
                        <input type="password" name="password" class="form-control" required>
                    </div>
                    <button type="submit" class="btn btn-primary w-100">
                        <i class="fas fa-sign-in-alt"></i> Login
                    </button>
                </form>

                <hr>
                <p class="text-center">
                    Don't have an account? <a href="register.jsp">Register here</a>
                </p>
            </div>
        </div>
    </div>
</div>

</div>
<!-- Close amazon-main-container -->

<div class="container">
<%@ include file="includes/footer.jsp" %>
