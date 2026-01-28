# Quick Fix: Product Images Not Displaying

## Problem
Product images are showing placeholders because the database has old local image paths (`assets/images/products/...`) instead of working URLs.

## Solution: Update Database Image URLs

### Option 1: Run SQL Script (Easiest)

1. **Open your PostgreSQL database client** (pgAdmin, DBeaver, or psql command line)

2. **Connect to your `ecommerce` database**

3. **Run the SQL script:**
   - Open the file: `update_product_images.sql`
   - Copy and paste the entire contents into your SQL client
   - Execute it

   OR run from command line:
   ```bash
   psql -U postgres -d ecommerce -f update_product_images.sql
   ```

### Option 2: Manual SQL Updates

Run these SQL commands one by one:

```sql
-- Update Smartphone
UPDATE products SET image_url = 'https://images.unsplash.com/photo-1511707171634-5f897ff02aa9?w=400&h=400&fit=crop' WHERE name = 'Smartphone';

-- Update Wireless Earbuds
UPDATE products SET image_url = 'https://images.unsplash.com/photo-1590658268037-6bf12165a8df?w=400&h=400&fit=crop' WHERE name = 'Wireless Earbuds';

-- Update Laptop
UPDATE products SET image_url = 'https://images.unsplash.com/photo-1496181133206-80ce9b88a853?w=400&h=400&fit=crop' WHERE name = 'Laptop';

-- Update Men T-Shirt
UPDATE products SET image_url = 'https://images.unsplash.com/photo-1521572163474-6864f9cf17ab?w=400&h=400&fit=crop' WHERE name = 'Men T-Shirt';

-- Update Running Shoes
UPDATE products SET image_url = 'https://images.unsplash.com/photo-1542291026-7eec264c27ff?w=400&h=400&fit=crop' WHERE name = 'Running Shoes';

-- Update Pressure Cooker
UPDATE products SET image_url = 'https://images.unsplash.com/photo-1556911220-bff31c812dba?w=400&h=400&fit=crop' WHERE name = 'Pressure Cooker';

-- Update Novel Book
UPDATE products SET image_url = 'https://images.unsplash.com/photo-1544947950-fa07a98d237f?w=400&h=400&fit=crop' WHERE name = 'Novel Book';

-- Update Cricket Bat
UPDATE products SET image_url = 'https://images.unsplash.com/photo-1612872087720-bb876e2e67d1?w=400&h=400&fit=crop' WHERE name = 'Cricket Bat';

-- Update any remaining products with local paths
UPDATE products SET image_url = 'https://images.unsplash.com/photo-1560472354-b33ff0c44a43?w=400&h=400&fit=crop' WHERE image_url LIKE 'assets/%' OR image_url IS NULL OR image_url = '';

-- Verify updates
SELECT id, name, image_url FROM products ORDER BY id;
```

## After Updating

1. **Restart your server** (if running):
   ```bash
   # Stop current server (Ctrl+C if running in terminal)
   mvn jetty:run -Djetty.port=8081
   ```

2. **Clear browser cache** and hard refresh:
   - **Chrome/Edge**: Press `Ctrl + Shift + R` or `Ctrl + F5`
   - **Firefox**: Press `Ctrl + Shift + R`

3. **Check the website**:
   - Home page: `http://localhost:8081/index.jsp`
   - Products page: `http://localhost:8081/ProductServlet`

## Verify Images Are Working

After updating, you should see:
- ✅ Product images displaying correctly on product cards
- ✅ Images visible on product detail pages
- ✅ Images showing in cart and wishlist

If images still don't show:
1. Check browser console (F12) for errors
2. Verify the `image_url` column in the database has the Unsplash URLs
3. Try opening one of the Unsplash URLs directly in your browser to confirm they're accessible
