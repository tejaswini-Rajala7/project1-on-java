# 🚀 Project is Running!

## Server Information

- **Server**: Jetty (Embedded)
- **Port**: 8081
- **Context Path**: `/` (root)
- **URL**: http://localhost:8081

## Access Points

### Customer Portal
- **Home**: http://localhost:8081/
- **Products**: http://localhost:8081/ProductServlet
- **Login**: http://localhost:8081/login.jsp
- **Register**: http://localhost:8081/register.jsp

### Admin Portal
- **Admin Login**: http://localhost:8081/login.jsp
- **Admin Dashboard**: http://localhost:8081/admin/dashboard.jsp
- **Admin Products**: http://localhost:8081/admin/products
- **Admin Orders**: http://localhost:8081/admin/orders

### Test & Health
- **Database Test**: http://localhost:8081/db-test
- **Health Check**: http://localhost:8081/health

## Default Credentials

### Admin Account
- **Email**: admin@protax.com
- **Password**: admin123

## Quick Start Guide

1. **Test Database Connection**
   - Visit: http://localhost:8081/db-test
   - Should show "✅ Connection successful!" and list of tables

2. **Login as Admin**
   - Go to: http://localhost:8081/login.jsp
   - Use: admin@protax.com / admin123
   - Access admin dashboard to add products

3. **Register New Customer**
   - Go to: http://localhost:8081/register.jsp
   - Create account and start shopping

4. **Browse Products**
   - Visit: http://localhost:8081/ProductServlet
   - Use search filters, add to cart, wishlist items

## Features Available

✅ User Registration & Login
✅ Product Browsing with Categories
✅ Advanced Search & Filters (price, rating, category)
✅ Pagination
✅ Product Details with Reviews
✅ Shopping Cart
✅ Wishlist
✅ Coupon System
✅ Address Management
✅ Checkout Process
✅ Order Placement
✅ Order History
✅ Payment Integration (COD, Card, UPI, Stripe, Razorpay)
✅ Email Notifications (if SMTP configured)
✅ Admin Dashboard
✅ Product Management (CRUD)
✅ Order Management
✅ Image Upload for Products

## Stopping the Server

Press `Ctrl+C` in the terminal where Jetty is running, or:
```bash
# Find and kill the Java process
taskkill /F /IM java.exe
```

## Troubleshooting

### Database Connection Issues
- Check PostgreSQL is running: `Get-Service postgresql*`
- Verify database exists: `psql -U postgres -l`
- Test connection: http://localhost:8081/db-test

### Port Already in Use
- Change port in `pom.xml` (jetty-maven-plugin configuration)
- Or stop other services using port 8081

### Application Not Loading
- Check console logs for errors
- Verify WAR file was built: `target/EcommerceProject-1.0.war`
- Check database connection logs

## Next Steps

1. ✅ Database configured
2. ✅ Application built
3. ✅ Server running
4. 🔄 Test all features
5. 🔄 Add products via admin panel
6. 🔄 Test shopping flow

## Enjoy Your E-Commerce Platform! 🎉
