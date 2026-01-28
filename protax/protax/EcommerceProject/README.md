# Protax Store - Full-Featured E-Commerce Platform

A comprehensive e-commerce website built with Java Servlets, JSP, MySQL, and Bootstrap. This project includes all the features you'd find in major e-commerce platforms like Amazon and Flipkart.

## Features

### Customer Features
- ✅ User Registration & Login
- ✅ Product Browsing with Categories
- ✅ Product Search
- ✅ Product Details with Reviews & Ratings
- ✅ Shopping Cart (Add, Update, Remove items)
- ✅ Address Management
- ✅ Checkout Process
- ✅ Order Placement
- ✅ Order History & Tracking
- ✅ Product Reviews & Ratings
- ✅ Responsive Design

### Admin Features
- ✅ Admin Dashboard
- ✅ Product Management (CRUD)
- ✅ Order Management
- ✅ Order Status Updates
- ✅ User Management

## Technology Stack

- **Backend**: Java Servlets (Jakarta EE)
- **Frontend**: JSP, Bootstrap 5, Font Awesome
- **Database**: MySQL
- **Build Tool**: Maven
- **Server**: Apache Tomcat (or any Jakarta EE compatible server)

## Database Setup

1. Create MySQL database:
```sql
mysql -u root -p
```

2. Run the SQL script:
```sql
source database_schema.sql
```

Or manually execute the SQL file located at `database_schema.sql`

3. Update database credentials in `src/dao/DBConnection.java` if needed:
```java
con = DriverManager.getConnection(
    "jdbc:mysql://localhost:3306/ecommerce",
    "root",
    "your_password"
);
```

## Project Structure

```
EcommerceProject/
├── src/
│   ├── controller/
│   │   ├── CartServlet.java
│   │   ├── LoginServlet.java
│   │   ├── OrderServlet.java
│   │   ├── ProductServlet.java
│   │   ├── ProductDetailServlet.java
│   │   ├── SearchServlet.java
│   │   ├── LogoutServlet.java
│   │   ├── AddressServlet.java
│   │   ├── CheckoutServlet.java
│   │   ├── ReviewServlet.java
│   │   └── admin/
│   │       ├── AdminProductServlet.java
│   │       └── AdminOrderServlet.java
│   ├── dao/
│   │   ├── DBConnection.java
│   │   ├── UserDAO.java
│   │   ├── ProductDAO.java
│   │   ├── CartDAO.java
│   │   ├── OrderDAO.java
│   │   ├── AddressDAO.java
│   │   ├── CategoryDAO.java
│   │   └── ReviewDAO.java
│   └── model/
│       ├── User.java
│       ├── Product.java
│       ├── Cart.java
│       ├── Order.java
│       ├── OrderItem.java
│       ├── Address.java
│       ├── Category.java
│       └── Review.java
├── WebContent/
│   ├── css/
│   │   └── style.css
│   ├── includes/
│   │   ├── header.jsp
│   │   └── footer.jsp
│   ├── admin/
│   │   ├── dashboard.jsp
│   │   ├── products.jsp
│   │   ├── product-form.jsp
│   │   ├── orders.jsp
│   │   └── order-details.jsp
│   ├── index.jsp
│   ├── login.jsp
│   ├── register.jsp
│   ├── products.jsp
│   ├── product-detail.jsp
│   ├── cart.jsp
│   ├── checkout.jsp
│   ├── order-history.jsp
│   ├── order-details.jsp
│   └── addresses.jsp
├── database_schema.sql
├── pom.xml
└── README.md
```

## Installation & Setup

### Prerequisites
- Java 11 or higher
- Maven 3.6+
- MySQL 8.0+
- Apache Tomcat 10+ (or any Jakarta EE compatible server)

### Steps

1. **Clone/Download the project**

2. **Set up the database**:
   - Create MySQL database
   - Run `database_schema.sql` script

3. **Configure database connection**:
   - Edit `src/dao/DBConnection.java` with your MySQL credentials

4. **Build the project**:
```bash
mvn clean install
```

5. **Deploy to Tomcat**:
   - Copy the generated WAR file from `target/EcommerceProject-1.0.war` to Tomcat's `webapps` directory
   - Or use your IDE to deploy directly

6. **Access the application**:
   - Customer portal: `http://localhost:8080/EcommerceProject-1.0/`
   - Admin login: `admin@protax.com` / `admin123`

## Default Admin Credentials

- **Email**: admin@protax.com
- **Password**: admin123

## Key Features Explained

### Shopping Cart
- Add products to cart
- Update quantities
- Remove items
- View cart total
- Persistent cart (stored in database)

### Order Management
- Place orders with address selection
- Multiple payment methods (COD, Credit Card, UPI)
- Order history for customers
- Order tracking with status updates
- Admin can update order status

### Product Management
- Browse products by category
- Search products
- View product details
- Product images
- Stock management
- Product ratings and reviews

### Admin Panel
- Dashboard with statistics
- Add/Edit/Delete products
- Manage orders
- Update order status
- View all orders

## API Endpoints

### Customer Endpoints
- `GET /` - Home page
- `GET /ProductServlet` - List all products
- `GET /product-detail?id={id}` - Product details
- `GET /search?q={query}` - Search products
- `GET /cart` - View cart
- `POST /cart` - Add/Update/Remove cart items
- `GET /checkout` - Checkout page
- `POST /order` - Place order
- `GET /order?action=history` - Order history
- `GET /address` - Manage addresses
- `POST /review` - Submit product review

### Admin Endpoints
- `GET /admin/dashboard.jsp` - Admin dashboard
- `GET /admin/products` - Manage products
- `GET /admin/orders` - Manage orders

## Database Schema

The database includes the following tables:
- `users` - User accounts
- `categories` - Product categories
- `products` - Product information
- `cart` - Shopping cart items
- `addresses` - User delivery addresses
- `orders` - Order information
- `order_items` - Order line items
- `reviews` - Product reviews
- `wishlist` - User wishlist (schema ready)
- `coupons` - Discount coupons (schema ready)

## Future Enhancements

- [ ] Password hashing (currently plain text)
- [ ] Email notifications
- [ ] Payment gateway integration
- [ ] Wishlist functionality
- [ ] Coupon/discount system
- [ ] Product recommendations
- [ ] Image upload functionality
- [ ] Advanced search filters
- [ ] Product comparison
- [ ] Customer support chat

## Security Notes

⚠️ **Important**: This is a development/demo project. For production use:
- Implement password hashing (BCrypt recommended)
- Add CSRF protection
- Implement proper input validation
- Use prepared statements (already implemented)
- Add rate limiting
- Implement session timeout
- Add HTTPS/SSL

## License

This project is for educational purposes.

## Support

For issues or questions, please check the code comments or database schema for guidance.

---

**Built with ❤️ using Java Servlets & JSP**
