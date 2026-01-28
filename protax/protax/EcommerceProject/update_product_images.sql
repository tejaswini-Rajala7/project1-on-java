-- Update Product Images to Local Uploads
-- Maps each product to the photo stored in WebContent/uploads

-- Electronics
UPDATE products
SET image_url = 'uploads/laptop.jpg'
WHERE name = 'Laptop'
  AND (image_url NOT LIKE 'uploads/%' OR image_url IS NULL OR image_url = '');

UPDATE products
SET image_url = 'uploads/smartphone.jpg'
WHERE name = 'Smartphone'
  AND (image_url NOT LIKE 'uploads/%' OR image_url IS NULL OR image_url = '');

-- Clothing/Fashion
UPDATE products
SET image_url = 'uploads/tshirt.jpg'
WHERE name = 'T-Shirt'
  AND (image_url NOT LIKE 'uploads/%' OR image_url IS NULL OR image_url = '');

UPDATE products
SET image_url = 'uploads/jeans.jpg'
WHERE name = 'Jeans'
  AND (image_url NOT LIKE 'uploads/%' OR image_url IS NULL OR image_url = '');

-- Books
UPDATE products
SET image_url = 'uploads/java-book.jpg'
WHERE name = 'Java Programming Book'
  AND (image_url NOT LIKE 'uploads/%' OR image_url IS NULL OR image_url = '');

-- Home & Kitchen
UPDATE products
SET image_url = 'uploads/coffee-maker.jpg'
WHERE name = 'Coffee Maker'
  AND (image_url NOT LIKE 'uploads/%' OR image_url IS NULL OR image_url = '');

-- Sports
UPDATE products
SET image_url = 'uploads/football.jpg'
WHERE name = 'Football'
  AND (image_url NOT LIKE 'uploads/%' OR image_url IS NULL OR image_url = '');

-- Update any remaining products without uploads/ paths to a known local image
UPDATE products
SET image_url = 'uploads/smartphone.jpg'
WHERE image_url NOT LIKE 'uploads/%' OR image_url IS NULL OR image_url = '';

-- Verify updates
SELECT id, name, image_url FROM products ORDER BY id;
