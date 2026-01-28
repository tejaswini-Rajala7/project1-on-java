# Fix Product Images Not Displaying

## Problem
Product images are not displaying because the database contains old local image paths (`assets/images/products/...`) instead of working URLs.

## Solution

### Option 1: Run the Image URL Updater (Recommended)

1. **Compile and run the ImageUrlUpdater utility:**
   ```bash
   cd EcommerceProject
   mvn compile
   mvn exec:java -Dexec.mainClass="util.ImageUrlUpdater"
   ```

   This will update all product image URLs in the database to use working Unsplash URLs.

### Option 2: Run SQL Update Script

1. **Connect to your database** (PostgreSQL):
   ```bash
   psql -U your_username -d ecommerce
   ```

2. **Run the update script:**
   ```sql
   \i update_product_images.sql
   ```

   Or copy and paste the contents of `update_product_images.sql` into your database client.

### Option 3: Use ProductSeeder (if products don't exist)

If you need to add products fresh with correct image URLs:

```bash
cd EcommerceProject
mvn compile
mvn exec:java -Dexec.mainClass="util.ProductSeeder"
```

## What Gets Updated

The following products will have their image URLs updated:

- **Smartphone** → Unsplash smartphone image
- **Wireless Earbuds** → Unsplash earbuds image  
- **Laptop** → Unsplash laptop image
- **Men T-Shirt** → Unsplash t-shirt image
- **Running Shoes** → Unsplash shoes image
- **Pressure Cooker** → Unsplash cooker image
- **Novel Book** → Unsplash book image
- **Cricket Bat** → Unsplash cricket bat image

Any remaining products with local paths will get a default placeholder image.

## After Updating

1. **Restart your server** (if running):
   ```bash
   # Stop the current server (Ctrl+C)
   mvn jetty:run -Djetty.port=8081
   ```

2. **Clear your browser cache** and hard refresh:
   - Chrome/Edge: `Ctrl + Shift + R` or `Ctrl + F5`
   - Firefox: `Ctrl + Shift + R`

3. **Verify images are displaying** on:
   - Home page (`http://localhost:8081/index.jsp`)
   - Products page (`http://localhost:8081/ProductServlet`)
   - Product detail pages

## Troubleshooting

If images still don't display after updating:

1. **Check browser console** (F12) for any CORS or network errors
2. **Verify database updates** by checking the `image_url` column in the `products` table
3. **Check network tab** to see if image requests are being made and what the response is
4. **Verify Unsplash URLs** are accessible by opening them directly in a browser

## Notes

- The Unsplash URLs used are publicly accessible and don't require authentication
- Images are set to 400x400 pixels with `fit=crop` for optimal display
- The `image-handler.js` has been updated to better handle image loading and errors
