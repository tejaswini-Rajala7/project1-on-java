# 📋 Quick Reference: Backend vs Frontend

## 🔵 BACKEND (Server-Side Java Code)

```
src/
├── model/          → Data structures (Product, User, Order, etc.)
├── dao/            → Database operations (SQL queries)
├── controller/     → Request handlers (Servlets)
├── util/           → Helper services (Email, Payment)
├── filter/         → Request interceptors (Logging)
└── main/resources/ → Configuration files
```

**Key Files:**
- `ProductServlet.java` - Handles product requests
- `ProductDAO.java` - Queries product database
- `Product.java` - Product data structure
- `DBConnection.java` - Database connection
- `EmailService.java` - Sends emails
- `PaymentService.java` - Processes payments

**What Backend Does:**
- ✅ Connects to PostgreSQL database
- ✅ Executes SQL queries
- ✅ Processes business logic
- ✅ Validates user input
- ✅ Handles authentication
- ✅ Sends emails
- ✅ Processes payments

---

## 🟢 FRONTEND (What User Sees)

```
WebContent/
├── *.jsp           → Dynamic HTML pages
├── css/            → Styling files
├── includes/       → Reusable components (header, footer)
├── uploads/        → Product images
└── WEB-INF/        → Configuration
```

**Key Files:**
- `index.jsp` - Homepage
- `products.jsp` - Product listing
- `cart.jsp` - Shopping cart
- `checkout.jsp` - Checkout page
- `login.jsp` - Login form
- `css/style.css` - Custom styles

**What Frontend Does:**
- ✅ Displays HTML pages
- ✅ Shows product listings
- ✅ Collects user input (forms)
- ✅ Styles the website (CSS)
- ✅ Provides user interface
- ✅ Shows images and icons

---

## 🔄 Data Flow

```
USER BROWSER
    ↓ (clicks link)
FRONTEND (JSP)
    ↓ (sends HTTP request)
BACKEND (Servlet)
    ↓ (calls DAO)
DATABASE (PostgreSQL)
    ↓ (returns data)
BACKEND (Servlet)
    ↓ (sets in request)
FRONTEND (JSP)
    ↓ (generates HTML)
USER BROWSER (sees page)
```

---

## 📝 Code Examples

### Backend Example (Java):
```java
// ProductServlet.java - BACKEND
@WebServlet("/ProductServlet")
public class ProductServlet extends HttpServlet {
    protected void doGet(HttpServletRequest req, HttpServletResponse res) {
        // Get data from database
        List<Product> products = ProductDAO.getAllProducts();
        
        // Set data for frontend
        req.setAttribute("products", products);
        
        // Forward to JSP page
        req.getRequestDispatcher("products.jsp").forward(req, res);
    }
}
```

### Frontend Example (JSP):
```jsp
<!-- products.jsp - FRONTEND -->
<%@ page import="model.Product" %>
<%
    // Get data from backend
    List<Product> products = (List<Product>) request.getAttribute("products");
%>

<% for (Product p : products) { %>
    <!-- Display to user -->
    <div class="card">
        <h5><%= p.getName() %></h5>
        <p>Price: ₹<%= p.getPrice() %></p>
    </div>
<% } %>
```

---

## 🎯 Simple Rule

- **Backend** = Java files (`.java`) = Runs on server = Handles data
- **Frontend** = JSP files (`.jsp`) = Runs in browser = Shows UI

---

## 📂 File Location Guide

| Component | Location | Type |
|-----------|----------|------|
| Models | `src/model/*.java` | Backend |
| Database Access | `src/dao/*.java` | Backend |
| Request Handlers | `src/controller/*.java` | Backend |
| Web Pages | `WebContent/*.jsp` | Frontend |
| Styles | `WebContent/css/*.css` | Frontend |
| Images | `WebContent/uploads/*` | Frontend |

---

## 🔍 How to Identify

**Backend if:**
- File extension is `.java`
- Contains `package`, `import`, `class`
- Has `@WebServlet` annotation
- Executes SQL queries
- Located in `src/` folder

**Frontend if:**
- File extension is `.jsp`, `.html`, `.css`
- Contains HTML tags: `<div>`, `<form>`, `<button>`
- Has JSP tags: `<%`, `<%=`, `<%@`
- Displays data to users
- Located in `WebContent/` folder

---

## 💡 Remember

**Backend** = Brain (thinks, processes, stores)
**Frontend** = Face (shows, displays, interacts)

Both work together to create the complete e-commerce website! 🛒
