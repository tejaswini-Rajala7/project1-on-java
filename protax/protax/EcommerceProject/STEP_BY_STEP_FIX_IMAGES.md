# Step-by-Step Guide: Fix Product Images Not Displaying

## Overview
This guide will help you update product image URLs in your database so images display correctly on your website.

---

## Step 1: Stop Your Server (If Running)

1. **If your server is currently running:**
   - Go to the terminal/command prompt where the server is running
   - Press `Ctrl + C` to stop it
   - Wait for it to fully stop

---

## Step 2: Update Database Image URLs

You have **3 options** - choose the one that's easiest for you:

### **Option A: Using pgAdmin (Easiest - Recommended)**

1. **Open pgAdmin** (PostgreSQL administration tool)
   - If you don't have it, download from: https://www.pgadmin.org/

2. **Connect to your database:**
   - In pgAdmin, expand "Servers" → Your server → "Databases" → "ecommerce"
   - Right-click on "ecommerce" → Select "Query Tool"

3. **Open the SQL file:**
   - In pgAdmin, go to: File → Open File
   - Navigate to: `C:\Users\harsh\OneDrive\Desktop\protax\EcommerceProject\update_product_images.sql`
   - Click "Open"

4. **Execute the script:**
   - Click the "Execute" button (or press F5)
   - You should see messages like "UPDATE 1" for each product

5. **Verify the update:**
   - Scroll to the bottom of the script
   - You'll see a `SELECT` statement that shows all products and their image URLs
   - Make sure all `image_url` values start with `https://images.unsplash.com/`

### **Option B: Using Command Line (psql)**

1. **Open Command Prompt or PowerShell**

2. **Navigate to the project folder:**
   ```bash
   cd "C:\Users\harsh\OneDrive\Desktop\protax\EcommerceProject"
   ```

3. **Run the SQL script:**
   ```bash
   psql -U postgres -d ecommerce -f update_product_images.sql
   ```
   
   - Enter your PostgreSQL password when prompted
   - You should see UPDATE messages for each product

4. **Verify (optional):**
   ```bash
   psql -U postgres -d ecommerce -c "SELECT id, name, image_url FROM products ORDER BY id;"
   ```

### **Option C: Manual SQL Updates**

1. **Open your database client** (pgAdmin, DBeaver, or any SQL client)

2. **Connect to the `ecommerce` database**

3. **Copy and paste this SQL** (one block at a time or all at once):

```sql
-- Update Smartphone
UPDATE products 
SET image_url = 'https://images.unsplash.com/photo-1511707171634-5f897ff02aa9?w=400&h=400&fit=crop'
WHERE name = 'Smartphone' AND (image_url LIKE 'assets/%' OR image_url IS NULL);

-- Update Wireless Earbuds
UPDATE products 
SET image_url = 'https://images.unsplash.com/photo-1590658268037-6bf12165a8df?w=400&h=400&fit=crop'
WHERE name = 'Wireless Earbuds' AND (image_url LIKE 'assets/%' OR image_url IS NULL);

-- Update Laptop
UPDATE products 
SET image_url = 'https://images.unsplash.com/photo-1496181133206-80ce9b88a853?w=400&h=400&fit=crop'
WHERE name = 'Laptop' AND (image_url LIKE 'assets/%' OR image_url IS NULL);

-- Update Men T-Shirt
UPDATE products 
SET image_url = 'https://images.unsplash.com/photo-1521572163474-6864f9cf17ab?w=400&h=400&fit=crop'
WHERE name = 'Men T-Shirt' AND (image_url LIKE 'assets/%' OR image_url IS NULL);

-- Update Running Shoes
UPDATE products 
SET image_url = 'https://images.unsplash.com/photo-1542291026-7eec264c27ff?w=400&h=400&fit=crop'
WHERE name = 'Running Shoes' AND (image_url LIKE 'assets/%' OR image_url IS NULL);

-- Update Pressure Cooker
UPDATE products 
SET image_url = 'https://images.unsplash.com/photo-1556911220-bff31c812dba?w=400&h=400&fit=crop'
WHERE name = 'Pressure Cooker' AND (image_url LIKE 'assets/%' OR image_url IS NULL);

-- Update Novel Book
UPDATE products 
SET image_url = 'https://images.unsplash.com/photo-1544947950-fa07a98d237f?w=400&h=400&fit=crop'
WHERE name = 'Novel Book' AND (image_url LIKE 'assets/%' OR image_url IS NULL);

-- Update Cricket Bat
UPDATE products 
SET image_url = 'https://images.unsplash.com/photo-1612872087720-bb876e2e67d1?w=400&h=400&fit=crop'
WHERE name = 'Cricket Bat' AND (image_url LIKE 'assets/%' OR image_url IS NULL);

-- Update any remaining products with local paths
UPDATE products 
SET image_url = 'https://images.unsplash.com/photo-1560472354-b33ff0c44a43?w=400&h=400&fit=crop'
WHERE image_url LIKE 'assets/%' OR (image_url IS NULL OR image_url = '');

-- Verify updates
SELECT id, name, image_url FROM products ORDER BY id;
```

4. **Execute the SQL** and verify the results

---

## Step 3: Start Your Server

1. **Open a new terminal/command prompt**

2. **Navigate to your project folder:**
   ```bash
   cd "C:\Users\harsh\OneDrive\Desktop\protax\EcommerceProject"
   ```

3. **Start the server:**
   ```bash
   mvn jetty:run -Djetty.port=8081
   ```

4. **Wait for the server to start:**
   - You should see: `Started ServerConnector@...{HTTP/1.1, (http/1.1)}{0.0.0.0:8081}`
   - The server is ready when you see: `Started Jetty Server`

---

## Step 4: Clear Browser Cache

**IMPORTANT:** You must clear your browser cache to see the changes!

### **Chrome / Edge / Brave:**
1. Press `Ctrl + Shift + Delete`
2. Select "Cached images and files"
3. Time range: "All time"
4. Click "Clear data"
5. **OR** Simply press `Ctrl + Shift + R` (hard refresh) on the page

### **Firefox:**
1. Press `Ctrl + Shift + Delete`
2. Select "Cache"
3. Time range: "Everything"
4. Click "Clear Now"
5. **OR** Press `Ctrl + Shift + R` (hard refresh)

### **Alternative: Hard Refresh**
- **Windows:** `Ctrl + Shift + R` or `Ctrl + F5`
- **Mac:** `Cmd + Shift + R`

---

## Step 5: Test Your Website

1. **Open your browser** and go to:
   ```
   http://localhost:8081/index.jsp
   ```

2. **Check the home page:**
   - Look at the "Best Sellers" section
   - Product images should now be visible (not placeholders)
   - Each product card should show an actual product image

3. **Check the products page:**
   - Go to: `http://localhost:8081/ProductServlet`
   - All product images should display correctly

4. **Check product detail page:**
   - Click on any product
   - The product image should be visible on the detail page

5. **Check cart and wishlist:**
   - Add products to cart/wishlist
   - Images should display there too

---

## Step 6: Verify Database Updates (Optional)

If you want to double-check that the database was updated correctly:

1. **Open your database client** (pgAdmin, etc.)

2. **Run this query:**
   ```sql
   SELECT id, name, image_url FROM products ORDER BY id;
   ```

3. **Verify:**
   - All `image_url` values should start with `https://images.unsplash.com/`
   - No `image_url` should contain `assets/images/products/`
   - Each product should have a unique Unsplash URL

---

## Troubleshooting

### **Images Still Not Showing?**

1. **Check browser console:**
   - Press `F12` to open Developer Tools
   - Go to "Console" tab
   - Look for any red error messages
   - Go to "Network" tab → Refresh page → Check if image requests are failing

2. **Verify database updates:**
   - Run: `SELECT id, name, image_url FROM products;`
   - Make sure URLs are updated

3. **Check server logs:**
   - Look at the terminal where the server is running
   - Check for any error messages

4. **Try opening an image URL directly:**
   - Copy one of the Unsplash URLs from the database
   - Paste it in your browser address bar
   - If it doesn't load, there might be a network/firewall issue

5. **Restart server:**
   - Stop the server (`Ctrl + C`)
   - Start it again (`mvn jetty:run -Djetty.port=8081`)

### **Database Connection Issues?**

- Make sure PostgreSQL is running
- Check your database credentials in `src/main/resources/db.properties`
- Verify the database name is `ecommerce`

### **Maven Command Not Working?**

- Make sure Maven is installed: `mvn --version`
- Make sure you're in the correct directory: `EcommerceProject` folder
- Try: `mvn clean compile jetty:run -Djetty.port=8081`

---

## Summary Checklist

- [ ] Stopped the server (if it was running)
- [ ] Updated database image URLs using SQL script
- [ ] Verified database updates (checked image_url column)
- [ ] Started the server (`mvn jetty:run -Djetty.port=8081`)
- [ ] Cleared browser cache (`Ctrl + Shift + R`)
- [ ] Tested home page - images displaying
- [ ] Tested products page - images displaying
- [ ] Tested product detail page - images displaying

---

## Quick Reference Commands

```bash
# Navigate to project
cd "C:\Users\harsh\OneDrive\Desktop\protax\EcommerceProject"

# Start server
mvn jetty:run -Djetty.port=8081

# Stop server
Ctrl + C

# Run SQL script (if psql is in PATH)
psql -U postgres -d ecommerce -f update_product_images.sql

# Check database
psql -U postgres -d ecommerce -c "SELECT id, name, image_url FROM products;"
```

---

## Need Help?

If images still don't display after following these steps:
1. Check the browser console (F12) for errors
2. Verify the database has the correct URLs
3. Make sure you cleared the browser cache
4. Try opening the website in an incognito/private window

Good luck! 🚀
