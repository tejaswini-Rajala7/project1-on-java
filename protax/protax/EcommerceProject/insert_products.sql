-- Insert Products with Local Upload Images
-- Note: This script assumes categories already exist. If not, uncomment the category inserts below.

-- First, ensure categories exist (uncomment if needed)
-- INSERT INTO categories (name, description) VALUES
-- ('Electronics', 'Electronic devices and gadgets'),
-- ('Fashion', 'Apparel and fashion items'),
-- ('Home & Kitchen', 'Home and kitchen essentials'),
-- ('Books', 'Books and reading materials'),
-- ('Sports', 'Sports and fitness equipment')
-- ON CONFLICT DO NOTHING;

-- Insert products with proper category_id references
-- Electronics category (assuming category_id = 1)
INSERT INTO products (name, description, price, category_id, image_url, stock, brand, rating) VALUES
('Laptop', 'High-performance laptop with 16GB RAM', 59999.00, 
 (SELECT id FROM categories WHERE name = 'Electronics' LIMIT 1), 
 'uploads/laptop.jpg', 50, 'TechBrand', 4.7),

('Smartphone', 'Latest smartphone with 128GB storage', 29999.00, 
 (SELECT id FROM categories WHERE name = 'Electronics' LIMIT 1), 
 'uploads/smartphone.jpg', 100, 'TechBrand', 4.5)

ON CONFLICT DO NOTHING;

-- Fashion/Clothing category (using 'Clothing' as per schema)
INSERT INTO products (name, description, price, category_id, image_url, stock, brand, rating) VALUES
('T-Shirt', 'Cotton t-shirt, comfortable fit', 599.00, 
 (SELECT id FROM categories WHERE name = 'Clothing' LIMIT 1), 
 'uploads/tshirt.jpg', 200, 'FashionBrand', 4.2),

('Jeans', 'Denim jeans, classic fit', 1999.00, 
 (SELECT id FROM categories WHERE name = 'Clothing' LIMIT 1), 
 'uploads/jeans.jpg', 150, 'FashionBrand', 4.3)

ON CONFLICT DO NOTHING;

-- Books category
INSERT INTO products (name, description, price, category_id, image_url, stock, brand, rating) VALUES
('Java Programming Book', 'Complete guide to Java programming', 899.00, 
 (SELECT id FROM categories WHERE name = 'Books' LIMIT 1), 
 'uploads/java-book.jpg', 75, 'TechBooks', 4.6)

ON CONFLICT DO NOTHING;

-- Home & Kitchen category
INSERT INTO products (name, description, price, category_id, image_url, stock, brand, rating) VALUES
('Coffee Maker', 'Automatic coffee maker', 3499.00, 
 (SELECT id FROM categories WHERE name = 'Home & Kitchen' LIMIT 1), 
 'uploads/coffee-maker.jpg', 30, 'HomeBrand', 4.4)

ON CONFLICT DO NOTHING;

-- Sports category
INSERT INTO products (name, description, price, category_id, image_url, stock, brand, rating) VALUES
('Football', 'Professional football', 999.00, 
 (SELECT id FROM categories WHERE name = 'Sports' LIMIT 1), 
 'uploads/football.jpg', 100, 'SportsBrand', 4.5)

ON CONFLICT DO NOTHING;
