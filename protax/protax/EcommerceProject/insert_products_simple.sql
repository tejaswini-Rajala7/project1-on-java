-- Simple Product Insert Script (using direct category IDs)
-- Run this after checking your category IDs in the database
-- To check category IDs: SELECT id, name FROM categories;

-- Electronics (category_id = 1)
INSERT INTO products (name, description, price, category_id, image_url, stock, brand, rating) VALUES
('Laptop', 'High-performance laptop with 16GB RAM', 59999.00, 1, 'uploads/laptop.jpg', 50, 'TechBrand', 4.7),
('Smartphone', 'Latest smartphone with 128GB storage', 29999.00, 1, 'uploads/smartphone.jpg', 100, 'TechBrand', 4.5);

-- Clothing/Fashion (category_id = 2)
INSERT INTO products (name, description, price, category_id, image_url, stock, brand, rating) VALUES
('T-Shirt', 'Cotton t-shirt, comfortable fit', 599.00, 2, 'uploads/tshirt.jpg', 200, 'FashionBrand', 4.2),
('Jeans', 'Denim jeans, classic fit', 1999.00, 2, 'uploads/jeans.jpg', 150, 'FashionBrand', 4.3);

-- Books (category_id = 3)
INSERT INTO products (name, description, price, category_id, image_url, stock, brand, rating) VALUES
('Java Programming Book', 'Complete guide to Java programming', 899.00, 3, 'uploads/java-book.jpg', 75, 'TechBooks', 4.6);

-- Home & Kitchen (category_id = 4)
INSERT INTO products (name, description, price, category_id, image_url, stock, brand, rating) VALUES
('Coffee Maker', 'Automatic coffee maker', 3499.00, 4, 'uploads/coffee-maker.jpg', 30, 'HomeBrand', 4.4);

-- Sports (category_id = 5)
INSERT INTO products (name, description, price, category_id, image_url, stock, brand, rating) VALUES
('Football', 'Professional football', 999.00, 5, 'uploads/football.jpg', 100, 'SportsBrand', 4.5);
