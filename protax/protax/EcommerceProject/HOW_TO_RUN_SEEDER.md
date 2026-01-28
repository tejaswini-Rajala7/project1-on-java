# How to Run Product Seeder - EASY METHOD

## ✅ Method 1: Use Web Interface (RECOMMENDED - Easiest!)

1. **Start your web application** (Tomcat/Server)

2. **Login as Admin**:
   - Go to: `http://localhost:8080/EcommerceProject/login.jsp`
   - Username: `admin@protax.com`
   - Password: `admin123`

3. **Go to Admin Dashboard**:
   - After login, click on "Admin" in the menu
   - Or go directly to: `http://localhost:8080/EcommerceProject/admin/dashboard.jsp`

4. **Click "🌱 Seed Products" button**:
   - You'll see a green button "🌱 Seed Products" in the Products card
   - Click it to run the seeder

5. **View Results**:
   - The page will show which products were added successfully
   - You can then go to "Manage Products" to see all products

**That's it!** No command line, no classpath issues - just click a button!

---

## Method 2: Direct URL Access

If you're already logged in as admin, you can directly access:
```
http://localhost:8080/EcommerceProject/admin/seed-products
```

---

## Method 3: Run SQL Script (Alternative)

If the web method doesn't work, you can run the SQL script directly:

1. **Open PostgreSQL**:
   ```bash
   psql -U postgres -d ecommerce
   ```

2. **Run the script**:
   ```sql
   \i insert_products.sql
   ```
   
   Or copy/paste the contents of `insert_products.sql` into your database client.

---

## What Gets Added

The seeder will insert 8 products:

**Electronics:**
- Smartphone - ₹14,999
- Wireless Earbuds - ₹2,999  
- Laptop - ₹54,999

**Fashion (Clothing):**
- Men T-Shirt - ₹599
- Running Shoes - ₹2,499

**Home & Kitchen:**
- Pressure Cooker - ₹1,799

**Books:**
- Novel Book - ₹399

**Sports:**
- Cricket Bat - ₹2,999

---

## Troubleshooting

**"Access Denied" or redirects to login:**
- Make sure you're logged in as admin
- Check that your session hasn't expired

**"Category not found" errors:**
- Make sure categories are inserted first
- Run the `database_schema_postgresql.sql` script if you haven't

**Products not showing:**
- Check the database directly: `SELECT * FROM products;`
- Verify the products were actually inserted

**Images not showing:**
- Add actual image files to `WebContent/assets/images/products/...` directories
- Image paths are already set in the database

---

## Next Steps After Seeding

1. **Add Product Images**:
   - Place image files in the respective folders:
     - `WebContent/assets/images/products/electronics/`
     - `WebContent/assets/images/products/fashion/`
     - `WebContent/assets/images/products/home-kitchen/`
     - `WebContent/assets/images/products/books-stationery/`
     - `WebContent/assets/images/products/toys-sports/`

2. **Verify Products**:
   - Go to Products page: `http://localhost:8080/EcommerceProject/ProductServlet`
   - Or Admin → Manage Products

3. **Edit if Needed**:
   - Use the admin panel to edit product details, prices, or images
