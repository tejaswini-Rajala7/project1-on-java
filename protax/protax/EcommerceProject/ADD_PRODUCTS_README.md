# Adding Products to Database

## SQL Script Created
A SQL script `insert_products.sql` has been created with all the products you specified.

## Steps to Add Products:

### 1. Run the SQL Script
Execute the `insert_products.sql` file in your PostgreSQL database:

```sql
-- Connect to your database
\c ecommerce;

-- Run the script
\i insert_products.sql
```

Or copy and paste the contents of `insert_products.sql` into your database client.

### 2. Image Directory Structure Created
The following directories have been created for product images:
- `WebContent/assets/images/products/electronics/`
- `WebContent/assets/images/products/fashion/`
- `WebContent/assets/images/products/home-kitchen/`
- `WebContent/assets/images/products/books-stationery/`
- `WebContent/assets/images/products/toys-sports/`

### 3. Add Product Images
Place the actual product images in their respective folders:

**Electronics:**
- `smartphone.jpg`
- `wireless-earbuds.jpg`
- `laptop.jpg`

**Fashion:**
- `men-tshirt.jpg`
- `running-shoes.jpg`

**Home & Kitchen:**
- `pressure-cooker.jpg`

**Books:**
- `novel-book.jpg`

**Sports:**
- `cricket-bat.jpg`

### 4. Products Added
The following products will be inserted:

1. **Electronics:**
   - Smartphone - ₹14,999
   - Wireless Earbuds - ₹2,999
   - Laptop - ₹54,999

2. **Fashion (Clothing):**
   - Men T-Shirt - ₹599
   - Running Shoes - ₹2,499

3. **Home & Kitchen:**
   - Pressure Cooker - ₹1,799

4. **Books:**
   - Novel Book - ₹399

5. **Sports:**
   - Cricket Bat - ₹2,999

### Notes:
- The script uses `SELECT id FROM categories WHERE name = ...` to automatically find the correct category_id
- If categories don't exist, they need to be created first (see database_schema_postgresql.sql)
- The script includes `ON CONFLICT DO NOTHING` to prevent duplicate inserts
- All products have default stock, brand, and rating values set
- Image paths are relative: `assets/images/products/...`

### Alternative: Use Admin Panel
You can also add products through the admin panel at:
- Login as admin
- Go to Admin Dashboard
- Click "Manage Products"
- Click "Add New Product"
- Fill in the form and upload images
