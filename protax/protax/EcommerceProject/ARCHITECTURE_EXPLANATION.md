# 🏗️ Project Architecture: Backend vs Frontend

## Overview
This is a **Java-based web application** using the **MVC (Model-View-Controller) pattern** with **JSP (JavaServer Pages)** for the frontend.

---

## 🔵 **BACKEND** (Server-Side)

### 📁 Location: `src/` directory

### 1. **Models** (`src/model/`)
**Purpose**: Data structures representing database entities

**Files**:
- `User.java` - User account data
- `Product.java` - Product information
- `Cart.java` - Shopping cart items
- `Order.java` - Order details
- `OrderItem.java` - Individual items in an order
- `Address.java` - Delivery addresses
- `Category.java` - Product categories
- `Review.java` - Product reviews
- `Wishlist.java` - User wishlist items
- `Coupon.java` - Discount coupons

**What they do**: Plain Java classes (POJOs) with getters/setters to hold data

---

### 2. **DAO (Data Access Object)** (`src/dao/`)
**Purpose**: Database operations - CRUD (Create, Read, Update, Delete)

**Files**:
- `DBConnection.java` - Establishes PostgreSQL database connection
- `UserDAO.java` - User database operations (login, register, get user)
- `ProductDAO.java` - Product operations (get all, search, filter, pagination)
- `CartDAO.java` - Shopping cart operations (add, update, remove, get total)
- `OrderDAO.java` - Order operations (create order, get order history)
- `AddressDAO.java` - Address management
- `CategoryDAO.java` - Category operations
- `ReviewDAO.java` - Review operations
- `WishlistDAO.java` - Wishlist operations
- `CouponDAO.java` - Coupon validation and discount calculation

**What they do**: 
- Execute SQL queries
- Connect to PostgreSQL database
- Return data as Java objects
- Handle database transactions

**Example**:
```java
// Backend: ProductDAO.java
public static List<Product> getAllProducts() {
    // Connects to database
    // Executes SQL: SELECT * FROM products
    // Returns list of Product objects
}
```

---

### 3. **Controllers/Servlets** (`src/controller/`)
**Purpose**: Handle HTTP requests, process business logic, coordinate between DAO and View

**Files**:
- `ProductServlet.java` - Handles product listing, search, filters
- `ProductDetailServlet.java` - Shows individual product details
- `CartServlet.java` - Manages shopping cart (add, update, remove)
- `CheckoutServlet.java` - Handles checkout page
- `OrderServlet.java` - Processes order placement
- `LoginServlet.java` - User authentication
- `RegisterServlet.java` - User registration
- `WishlistServlet.java` - Wishlist management
- `SearchServlet.java` - Product search
- `ReviewServlet.java` - Product reviews
- `AddressServlet.java` - Address management
- `LogoutServlet.java` - User logout
- `HealthServlet.java` - Health check endpoint
- `DBTestServlet.java` - Database connection test
- `admin/AdminProductServlet.java` - Admin product management
- `admin/AdminOrderServlet.java` - Admin order management

**What they do**:
- Receive HTTP requests (GET, POST)
- Extract parameters from requests
- Call DAO methods to get/save data
- Process business logic (calculations, validations)
- Set data in request attributes
- Forward to JSP pages for display

**Example Flow**:
```
User clicks "View Products" 
→ Browser sends GET request to /ProductServlet
→ ProductServlet.doGet() executes
→ Calls ProductDAO.getAllProducts()
→ Gets data from database
→ Sets products in request: req.setAttribute("products", list)
→ Forwards to products.jsp: req.getRequestDispatcher("products.jsp").forward()
```

---

### 4. **Utilities** (`src/util/`)
**Purpose**: Helper services for cross-cutting concerns

**Files**:
- `EmailService.java` - Sends order confirmation emails
- `PaymentService.java` - Processes payments (stubbed for demo)

**What they do**: Provide reusable services used by controllers

---

### 5. **Filters** (`src/filter/`)
**Purpose**: Intercept requests for logging, security, etc.

**Files**:
- `LoggingFilter.java` - Logs all HTTP requests

**What they do**: Execute before/after servlets for cross-cutting concerns

---

### 6. **Configuration** (`src/main/resources/`)
**Files**:
- `db.properties` - Database connection configuration

---

## 🟢 **FRONTEND** (Client-Side / Presentation Layer)

### 📁 Location: `WebContent/` directory

### 1. **JSP Pages** (`WebContent/*.jsp`)
**Purpose**: Dynamic HTML pages that display data from backend

**Files**:
- `index.jsp` - Homepage
- `products.jsp` - Product listing page
- `product-detail.jsp` - Individual product details
- `cart.jsp` - Shopping cart page
- `checkout.jsp` - Checkout page
- `login.jsp` - Login form
- `register.jsp` - Registration form
- `order-history.jsp` - User's order history
- `order-details.jsp` - Order details page
- `addresses.jsp` - Address management
- `wishlist.jsp` - Wishlist page
- `admin/dashboard.jsp` - Admin dashboard
- `admin/products.jsp` - Admin product management
- `admin/product-form.jsp` - Add/edit product form
- `admin/orders.jsp` - Admin order management
- `admin/order-details.jsp` - Admin order details

**What they do**:
- Display HTML content
- Use JSP tags to embed Java code: `<% ... %>`
- Access data from backend: `<%= request.getAttribute("products") %>`
- Include reusable components: `<%@ include file="includes/header.jsp" %>`
- Generate dynamic HTML based on data

**Example**:
```jsp
<!-- Frontend: products.jsp -->
<%
    // This Java code runs on SERVER before sending HTML to browser
    List<Product> list = (List<Product>) request.getAttribute("products");
%>
<% for (Product p : list) { %>
    <!-- This HTML is sent to browser -->
    <div class="card">
        <h5><%= p.getName() %></h5>
        <p>₹<%= p.getPrice() %></p>
    </div>
<% } %>
```

---

### 2. **Static Assets** (`WebContent/css/`, `WebContent/uploads/`)
**Purpose**: Static files served directly to browser

**Files**:
- `css/style.css` - Custom styling
- `uploads/` - Uploaded product images

**What they do**: 
- CSS files style the HTML
- Images are displayed in product listings
- Served directly by web server (no Java processing)

---

### 3. **Reusable Components** (`WebContent/includes/`)
**Purpose**: Common page elements

**Files**:
- `header.jsp` - Navigation bar (included in all pages)
- `footer.jsp` - Footer (included in all pages)

**What they do**: 
- Provide consistent navigation and footer across all pages
- Included using: `<%@ include file="includes/header.jsp" %>`

---

### 4. **Configuration** (`WebContent/WEB-INF/`)
**Files**:
- `web.xml` - Web application configuration (welcome files, servlet mappings, etc.)

---

## 🔄 **How Backend and Frontend Work Together**

### Request Flow Example: Viewing Products

```
1. USER ACTION (Frontend)
   ↓
   User clicks "View Products" link in index.jsp
   Browser sends: GET http://localhost:8081/ProductServlet

2. BACKEND PROCESSING
   ↓
   ProductServlet.doGet() receives request
   ↓
   Calls ProductDAO.getAllProducts()
   ↓
   Executes SQL: SELECT * FROM products
   ↓
   Returns List<Product> from database
   ↓
   Sets in request: req.setAttribute("products", productList)
   ↓
   Forwards to: products.jsp

3. FRONTEND RENDERING
   ↓
   products.jsp receives request with data
   ↓
   JSP processes: <% for (Product p : products) { %>
   ↓
   Generates HTML with product cards
   ↓
   Sends HTML to browser

4. USER SEES (Frontend)
   ↓
   Browser displays styled product listing page
```

---

## 📊 **Technology Stack Summary**

### Backend Technologies:
- **Java 11** - Programming language
- **Jakarta Servlets** - HTTP request handling
- **PostgreSQL** - Database
- **JDBC** - Database connectivity
- **Jakarta Mail** - Email sending
- **Maven** - Build tool

### Frontend Technologies:
- **JSP (JavaServer Pages)** - Dynamic HTML generation
- **HTML5** - Page structure
- **CSS3** - Styling (Bootstrap 5)
- **JavaScript** - Client-side interactivity (Bootstrap JS)
- **Font Awesome** - Icons

---

## 🎯 **Key Differences**

| Aspect | Backend | Frontend |
|--------|---------|----------|
| **Location** | `src/` directory | `WebContent/` directory |
| **Language** | Java | JSP, HTML, CSS, JavaScript |
| **Runs On** | Server | Browser (after server processes) |
| **Purpose** | Business logic, data access | User interface, presentation |
| **Access** | Direct database access | No database access |
| **Processing** | Server-side | Client-side (after server sends HTML) |

---

## 🔍 **Quick Identification Guide**

### ✅ **Backend Files** (Java code that runs on server):
- All `.java` files in `src/`
- Files that contain: `package`, `import`, `class`, `@WebServlet`
- Files that execute SQL queries
- Files that handle HTTP requests/responses

### ✅ **Frontend Files** (What user sees):
- All `.jsp` files in `WebContent/`
- All `.css` files
- All `.html` files
- Files that contain: `<html>`, `<div>`, `<%@`, `<%=`
- Files that display data to users

---

## 💡 **Example: Complete Request-Response Cycle**

**User wants to add product to cart:**

1. **Frontend** (`cart.jsp`): User clicks "Add to Cart" button
   ```html
   <form action="cart" method="post">
       <input type="hidden" name="action" value="add">
       <input type="hidden" name="productId" value="123">
   </form>
   ```

2. **Backend** (`CartServlet.java`): Receives POST request
   ```java
   String action = req.getParameter("action"); // "add"
   int productId = Integer.parseInt(req.getParameter("productId")); // 123
   CartDAO.addToCart(userId, productId); // Saves to database
   res.sendRedirect("cart"); // Redirects to cart page
   ```

3. **Backend** (`CartDAO.java`): Database operation
   ```java
   INSERT INTO cart(user_id, product_id, quantity) VALUES(?, ?, 1)
   ```

4. **Backend** (`CartServlet.java`): Loads updated cart
   ```java
   List<Cart> items = CartDAO.getCartByUser(userId);
   req.setAttribute("cartList", items);
   req.getRequestDispatcher("cart.jsp").forward(req, res);
   ```

5. **Frontend** (`cart.jsp`): Displays cart items
   ```jsp
   <% for (Cart item : cartList) { %>
       <div><%= item.getProductName() %></div>
   <% } %>
   ```

6. **User sees**: Updated cart with new item

---

## 🎓 **Summary**

- **Backend** = `src/` = Java code = Server-side logic = Database operations
- **Frontend** = `WebContent/` = JSP/HTML/CSS = What user sees = Presentation layer

The backend processes requests and prepares data, while the frontend displays that data in a user-friendly way!
