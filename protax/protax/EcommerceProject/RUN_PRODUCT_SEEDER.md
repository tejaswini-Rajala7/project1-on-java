# How to Run Product Seeder

## Method 1: Run Java Class Directly

1. **Compile the project** (if not already compiled):
   ```bash
   # In your IDE (Eclipse/IntelliJ), just build the project
   # Or from command line:
   javac -cp "path/to/your/jar/files" src/util/ProductSeeder.java
   ```

2. **Run the ProductSeeder class**:
   - **In Eclipse**: Right-click on `ProductSeeder.java` → Run As → Java Application
   - **In IntelliJ**: Right-click on `ProductSeeder.java` → Run 'ProductSeeder.main()'
   - **From command line**:
     ```bash
     java -cp "bin:path/to/jdbc/driver.jar" util.ProductSeeder
     ```

## Method 2: Execute SQL Script Directly

1. **Connect to your PostgreSQL database**:
   ```bash
   psql -U your_username -d ecommerce
   ```

2. **Run the SQL script**:
   ```sql
   \i insert_products.sql
   ```
   
   Or copy and paste the contents of `insert_products.sql` into your database client.

## Method 3: Use Admin Panel (Manual)

1. Start your web application
2. Login as admin (admin@protax.com / admin123)
3. Go to Admin Dashboard → Manage Products
4. Click "Add New Product" for each product
5. Fill in the form with product details and upload images

## What Gets Inserted

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

## Notes

- Make sure your database connection is configured correctly in `DBConnection.java`
- Ensure categories exist in the database (Electronics, Clothing, Books, Home & Kitchen, Sports)
- Image paths are set to `assets/images/products/...` - make sure to add actual image files
- The seeder will skip products if their category is not found
- Duplicate products (same name) may cause errors depending on your database constraints

## Troubleshooting

**Error: Category not found**
- Make sure categories are inserted first (see `database_schema_postgresql.sql`)

**Error: Database connection failed**
- Check `DBConnection.java` configuration
- Ensure PostgreSQL is running
- Verify database credentials

**Products not showing images**
- Add actual image files to `WebContent/assets/images/products/...` directories
- Check image file names match exactly (case-sensitive)
