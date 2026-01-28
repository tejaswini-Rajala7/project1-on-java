# Protax E-Commerce Project - Structure & Tools Documentation

## 📋 Table of Contents
1. [Project Overview](#project-overview)
2. [Project Structure](#project-structure)
3. [Frontend Technologies](#frontend-technologies)
4. [Backend Technologies](#backend-technologies)
5. [Database](#database)
6. [Server & Deployment](#server--deployment)
7. [Build Tools](#build-tools)
8. [Development Tools](#development-tools)
9. [Architecture Pattern](#architecture-pattern)

---

## 🎯 Project Overview

**Project Name:** Protax E-Commerce Store  
**Type:** Full-stack E-Commerce Web Application  
**Architecture:** MVC (Model-View-Controller) Pattern  
**Java Version:** 11  
**Packaging:** WAR (Web Application Archive)

---

## 📁 Project Structure

```
EcommerceProject/
│
├── src/                                    # Java Source Code
│   ├── controller/                         # Servlet Controllers (MVC Controller)
│   │   ├── admin/                         # Admin Controllers
│   │   │   ├── AdminOrderServlet.java
│   │   │   ├── AdminProductServlet.java
│   │   │   └── SeedProductsServlet.java
│   │   ├── AddressServlet.java
│   │   ├── CartServlet.java
│   │   ├── CheckoutServlet.java
│   │   ├── LoginServlet.java
│   │   ├── LogoutServlet.java
│   │   ├── OrderServlet.java
│   │   ├── ProductDetailServlet.java
│   │   ├── ProductServlet.java
│   │   ├── RegisterServlet.java
│   │   ├── ReviewServlet.java
│   │   ├── SearchServlet.java
│   │   └── WishlistServlet.java
│   │
│   ├── dao/                                # Data Access Objects (Database Layer)
│   │   ├── AddressDAO.java
│   │   ├── CartDAO.java
│   │   ├── CategoryDAO.java
│   │   ├── CouponDAO.java
│   │   ├── DBConnection.java              # Database Connection Manager
│   │   ├── OrderDAO.java
│   │   ├── ProductDAO.java
│   │   ├── ReviewDAO.java
│   │   ├── UserDAO.java
│   │   └── WishlistDAO.java
│   │
│   ├── filter/                             # Servlet Filters
│   │   ├── CharacterEncodingFilter.java   # UTF-8 Encoding Filter
│   │   └── LoggingFilter.java             # Request/Response Logging
│   │
│   ├── model/                              # Data Models (MVC Model)
│   │   ├── Address.java
│   │   ├── Cart.java
│   │   ├── Category.java
│   │   ├── Coupon.java
│   │   ├── Order.java
│   │   ├── OrderItem.java
│   │   ├── Product.java
│   │   ├── Review.java
│   │   ├── User.java
│   │   └── Wishlist.java
│   │
│   ├── util/                               # Utility Classes
│   │   ├── EmailService.java              # Email Sending Service
│   │   ├── ImageUrlUpdater.java           # Database Image URL Updater
│   │   ├── PaymentService.java           # Payment Processing
│   │   └── ProductSeeder.java             # Database Seeder
│   │
│   ├── main/resources/
│   │   └── db.properties                  # Database Configuration
│   │
│   └── test/java/                          # Unit Tests
│       └── dao/
│           └── CouponDAOTest.java
│
├── WebContent/                             # Web Application Root (Deployed as WAR)
│   ├── WEB-INF/
│   │   └── web.xml                        # Servlet Configuration (Jakarta EE 6.0)
│   │
│   ├── includes/                           # JSP Includes (Reusable Components)
│   │   ├── amazon-header.jsp              # Main Header Navigation
│   │   ├── footer.jsp                     # Footer Component
│   │   └── header.jsp                     # Alternative Header
│   │
│   ├── admin/                              # Admin Panel Pages
│   │   ├── dashboard.jsp
│   │   ├── order-details.jsp
│   │   ├── orders.jsp
│   │   ├── product-form.jsp
│   │   └── products.jsp
│   │
│   ├── css/                                # Stylesheets
│   │   ├── amazon-carousel.css            # Carousel Styles
│   │   ├── amazon-home.css                # Home Page Styles
│   │   ├── enhanced.css                   # Enhanced UI Styles
│   │   ├── fix-duplicate-rupee.css        # Currency Fix Styles
│   │   ├── header-products.css            # Header Styles
│   │   ├── home.css                       # Home Page Styles
│   │   ├── product-images-fix.css         # Image Handling Styles
│   │   ├── products.css                   # Product Listing Styles
│   │   └── style.css                      # Global Styles
│   │
│   ├── js/                                 # JavaScript Files
│   │   ├── fix-rupee-encoding.js          # Currency Symbol Fix
│   │   ├── image-handler.js               # Image Loading Handler
│   │   ├── main.js                        # Main JavaScript Logic
│   │   └── price-formatter.js             # Price Formatting Utility
│   │
│   ├── uploads/                            # Product Images Directory
│   │   ├── coffee-maker.jpg
│   │   ├── football.jpg
│   │   ├── java-book.jpg
│   │   ├── jeans.jpg
│   │   ├── laptop.jpg
│   │   ├── smartphone.jpg
│   │   └── tshirt.jpg
│   │
│   ├── assets/images/products/            # Additional Product Assets
│   │
│   ├── index.jsp                           # Home Page
│   ├── products.jsp                        # Product Listing Page
│   ├── product-detail.jsp                  # Product Detail Page
│   ├── cart.jsp                            # Shopping Cart Page
│   ├── checkout.jsp                         # Checkout Page
│   ├── login.jsp                            # Login Page
│   ├── register.jsp                         # Registration Page
│   ├── wishlist.jsp                         # Wishlist Page
│   ├── order-history.jsp                    # Order History Page
│   ├── order-details.jsp                    # Order Details Page
│   └── addresses.jsp                        # Address Management Page
│
├── photos/                                  # Source Product Images (Development)
│
├── target/                                  # Maven Build Output (Compiled Classes)
│
├── pom.xml                                  # Maven Project Configuration
├── db.properties                            # Database Properties (Root)
├── database_schema_postgresql.sql           # Database Schema Script
├── insert_products.sql                      # Product Data Insert Script
├── insert_products_simple.sql               # Simplified Product Data
├── update_product_images.sql                # Image URL Update Script
├── create_database.sql                      # Database Creation Script
│
└── Scripts/                                 # Utility Scripts
    ├── run_server.ps1                       # PowerShell Server Start Script
    ├── run_server.bat                        # Batch Server Start Script
    ├── run-jetty.ps1                         # Jetty Server Script
    ├── run-image-updater.ps1                # Image Updater Script
    ├── run-image-updater.bat                # Image Updater Batch Script
    ├── fix-port-8081.ps1                    # Port Cleanup Script
    └── setup_database.ps1                   # Database Setup Script
```

---

## 🎨 Frontend Technologies

### **Core Technologies**
- **HTML5** - Structure and semantic markup
- **CSS3** - Styling and layout
  - Flexbox & Grid Layout
  - CSS Animations & Transitions
  - Media Queries (Responsive Design)
  - Custom CSS Variables
- **JavaScript (ES6+)** - Client-side interactivity
  - DOM Manipulation
  - Event Handling
  - AJAX/Fetch API
  - MutationObserver API

### **Frontend Frameworks & Libraries**

#### **1. Bootstrap 5.3.0**
- **CDN:** `https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css`
- **Purpose:** Responsive grid system, components, utilities
- **Usage:** Navigation bars, forms, modals, responsive layout

#### **2. Font Awesome 6.4.0**
- **CDN:** `https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css`
- **Purpose:** Icon library
- **Usage:** Navigation icons, product ratings (stars), UI icons

### **Frontend Features**
- ✅ Responsive Design (Mobile, Tablet, Desktop)
- ✅ Dynamic Product Carousel with Auto-advance
- ✅ Real-time Price Formatting
- ✅ Image Lazy Loading & Error Handling
- ✅ Shopping Cart Management
- ✅ Wishlist Functionality
- ✅ Search Functionality
- ✅ Category Filtering
- ✅ Pagination
- ✅ UTF-8 Character Encoding Fixes (Rupee Symbol ₹)

### **Custom JavaScript Modules**
- `main.js` - Core application logic
- `price-formatter.js` - Currency formatting utilities
- `image-handler.js` - Image loading and error handling
- `fix-rupee-encoding.js` - Character encoding fixes

---

## ⚙️ Backend Technologies

### **Core Framework**
- **Java 11** - Programming Language
- **Jakarta EE 6.0** (formerly Java EE)
  - Jakarta Servlet API 6.0.0
  - Jakarta Server Pages (JSP)
  - Jakarta Mail API 2.1.2

### **Backend Architecture**
- **MVC Pattern** (Model-View-Controller)
  - **Model:** `model/` package (Java POJOs)
  - **View:** JSP files in `WebContent/`
  - **Controller:** Servlet classes in `controller/` package

### **Key Backend Components**

#### **1. Servlets (Controllers)**
- Handle HTTP requests/responses
- Process form submissions
- Manage session state
- Route requests to appropriate views

#### **2. DAO Pattern (Data Access Objects)**
- Abstraction layer for database operations
- Located in `dao/` package
- Handles CRUD operations
- Manages database connections

#### **3. Filters**
- `CharacterEncodingFilter` - Ensures UTF-8 encoding globally
- `LoggingFilter` - Logs requests/responses for debugging

#### **4. Utility Services**
- `EmailService` - Email notifications (Jakarta Mail)
- `PaymentService` - Payment processing logic
- `ProductSeeder` - Database seeding utility
- `ImageUrlUpdater` - Database image URL management

### **Session Management**
- HTTP Sessions for user authentication
- Session timeout: 30 minutes
- Secure cookies (http-only)

---

## 🗄️ Database

### **Database System**
- **PostgreSQL** (Version 42.7.4)
- **Driver:** `org.postgresql:postgresql:42.7.4`

### **Database Configuration**
```properties
Host: localhost
Port: 5432
Database Name: ecommerce
User: postgres
```

### **Database Schema**

#### **Core Tables:**
1. **users** - User accounts and authentication
   - id, name, email, password, phone, role, created_at

2. **categories** - Product categories
   - id, name, description

3. **products** - Product catalog
   - id, name, description, price, category_id, image_url, stock, brand, rating, created_at

4. **cart** - Shopping cart items
   - id, user_id, product_id, quantity

5. **orders** - Order records
   - id, user_id, total_amount, status, order_date, shipping_address_id

6. **order_items** - Order line items
   - id, order_id, product_id, quantity, price

7. **addresses** - User shipping addresses
   - id, user_id, street, city, state, zip_code, country, phone

8. **wishlist** - User wishlists
   - id, user_id, product_id

9. **reviews** - Product reviews
   - id, product_id, user_id, rating, comment, created_at

10. **coupons** - Discount coupons
    - id, code, discount_percent, valid_from, valid_to

### **Database Tools**
- **pgAdmin** - PostgreSQL Administration Tool (GUI)
- **SQL Scripts:**
  - `database_schema_postgresql.sql` - Complete schema creation
  - `insert_products.sql` - Sample product data
  - `update_product_images.sql` - Image URL updates
  - `create_database.sql` - Database initialization

---

## 🖥️ Server & Deployment

### **Application Server**
- **Eclipse Jetty 11.0.20**
  - Embedded server via Maven plugin
  - Supports Jakarta EE 6.0
  - JSP support via Apache JSP module
  - Port: **8081**
  - Context Path: `/` (root)

### **Server Configuration**
```xml
<plugin>
    <groupId>org.eclipse.jetty</groupId>
    <artifactId>jetty-maven-plugin</artifactId>
    <version>11.0.20</version>
    <configuration>
        <httpConnector>
            <port>8081</port>
        </httpConnector>
        <webApp>
            <contextPath>/</contextPath>
        </webApp>
    </configuration>
</plugin>
```

### **Running the Server**
```bash
# PowerShell
mvn jetty:run

# Or use provided scripts
.\run-jetty.ps1
.\run_server.ps1
```

### **Access URL**
- **Local:** `http://localhost:8081`
- **Home Page:** `http://localhost:8081/index.jsp`

---

## 🔧 Build Tools

### **Maven 3.x**
- **Project Management:** Dependency management, build automation
- **Packaging:** WAR (Web Application Archive)
- **Java Version:** 11

### **Maven Plugins**

#### **1. Maven Compiler Plugin (3.11.0)**
- Compiles Java source code
- Source/Target: Java 11

#### **2. Maven WAR Plugin (3.3.2)**
- Packages application as WAR file
- Source directory: `WebContent/`

#### **3. Jetty Maven Plugin (11.0.20)**
- Embedded server for development
- Hot reload support
- JSP compilation

#### **4. Exec Maven Plugin (3.1.1)**
- Executes Java utility classes
- Main class: `util.ImageUrlUpdater`

#### **5. Maven Surefire Plugin (3.2.5)**
- Runs unit tests
- JUnit 5 integration

### **Maven Dependencies**

#### **Core Dependencies:**
- **Jakarta Servlet API 6.0.0** - Servlet framework
- **PostgreSQL Driver 42.7.4** - Database connectivity
- **Jakarta Mail API 2.1.2** - Email functionality
- **Angus Mail 2.0.3** - Jakarta Mail implementation
- **SLF4J Simple 2.0.13** - Logging framework

#### **Testing Dependencies:**
- **JUnit Jupiter 5.10.2** - Unit testing framework
- **Mockito 5.12.0** - Mocking framework

---

## 🛠️ Development Tools

### **IDE Support**
- **Eclipse** (`.project`, `.classpath`, `.settings/`)
- Compatible with IntelliJ IDEA, VS Code

### **Version Control**
- Git (`.gitignore` patterns)

### **Scripts & Utilities**

#### **PowerShell Scripts:**
- `run_server.ps1` - Start Jetty server
- `run-jetty.ps1` - Alternative server start
- `run-image-updater.ps1` - Update product images
- `fix-port-8081.ps1` - Kill processes on port 8081
- `setup_database.ps1` - Database setup automation

#### **Batch Scripts:**
- `run_server.bat` - Windows batch server start
- `run-image-updater.bat` - Image updater batch script
- `fix-port-8081.bat` - Port cleanup batch script

### **Development Workflow**
1. **Database Setup:** Run `database_schema_postgresql.sql`
2. **Seed Data:** Run `insert_products.sql` or use `ProductSeeder`
3. **Start Server:** `mvn jetty:run` or use scripts
4. **Access:** `http://localhost:8081`
5. **Hot Reload:** Jetty automatically recompiles JSPs

---

## 🏗️ Architecture Pattern

### **MVC (Model-View-Controller)**

```
┌─────────────────────────────────────────────────────────┐
│                    CLIENT BROWSER                       │
│  (HTML, CSS, JavaScript, Bootstrap, Font Awesome)        │
└────────────────────┬────────────────────────────────────┘
                     │ HTTP Request
                     ▼
┌─────────────────────────────────────────────────────────┐
│              SERVLET CONTROLLERS                        │
│  (ProductServlet, CartServlet, LoginServlet, etc.)      │
│  - Handle HTTP requests                                 │
│  - Process business logic                               │
│  - Manage sessions                                      │
└────────────┬──────────────────────┬─────────────────────┘
             │                      │
             │                      │
    ┌────────▼────────┐    ┌──────▼──────────┐
    │   DAO LAYER      │    │   MODEL LAYER    │
    │  (Data Access)   │◄───┤  (Java POJOs)    │
    │                  │    │                  │
    │  - ProductDAO    │    │  - Product       │
    │  - UserDAO       │    │  - User          │
    │  - CartDAO       │    │  - Cart          │
    │  - OrderDAO      │    │  - Order         │
    └────────┬─────────┘    └──────────────────┘
             │
             │ SQL Queries
             ▼
    ┌─────────────────────┐
    │   POSTGRESQL DB      │
    │   (ecommerce)        │
    └─────────────────────┘
             │
             │
    ┌────────▼─────────┐
    │   JSP VIEWS       │
    │  (index.jsp,      │
    │   products.jsp,   │
    │   cart.jsp, etc.) │
    └──────────────────┘
```

### **Request Flow Example:**
1. **User** clicks "Add to Cart" → JavaScript sends HTTP request
2. **CartServlet** receives request → Validates session → Processes cart logic
3. **CartDAO** → Executes SQL → Updates database
4. **CartServlet** → Forwards to `cart.jsp`
5. **JSP** → Renders HTML with cart data
6. **Response** → Sent back to browser

---

## 📊 Technology Stack Summary

| Category | Technology | Version/Purpose |
|----------|-----------|-----------------|
| **Language** | Java | 11 |
| **Web Framework** | Jakarta EE | 6.0 |
| **View Technology** | JSP (Jakarta Server Pages) | - |
| **Database** | PostgreSQL | 42.7.4 (Driver) |
| **Application Server** | Eclipse Jetty | 11.0.20 |
| **Build Tool** | Apache Maven | 3.x |
| **Frontend Framework** | Bootstrap | 5.3.0 |
| **Icons** | Font Awesome | 6.4.0 |
| **Email** | Jakarta Mail | 2.1.2 |
| **Logging** | SLF4J | 2.0.13 |
| **Testing** | JUnit Jupiter | 5.10.2 |
| **Testing** | Mockito | 5.12.0 |

---

## 🚀 Quick Start Commands

```bash
# 1. Setup Database
psql -U postgres -f database_schema_postgresql.sql

# 2. Start Server
mvn jetty:run
# OR
.\run-jetty.ps1

# 3. Access Application
# Open browser: http://localhost:8081

# 4. Run Utility Classes
mvn exec:java
# OR
.\run-image-updater.ps1

# 5. Build WAR File
mvn clean package
# Output: target/EcommerceProject-1.0.war
```

---

## 📝 Notes

- **Character Encoding:** UTF-8 enforced globally via `CharacterEncodingFilter`
- **Image Storage:** Product images stored in `WebContent/uploads/`
- **Session Management:** 30-minute timeout, secure cookies
- **Error Handling:** Custom error pages configured in `web.xml`
- **Development Mode:** Jetty hot-reload enabled for JSP changes
- **Production Deployment:** WAR file can be deployed to Tomcat, WildFly, or any Jakarta EE server

---

**Last Updated:** January 2026  
**Project Status:** Active Development
