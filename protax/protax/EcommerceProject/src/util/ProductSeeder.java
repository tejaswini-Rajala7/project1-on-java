package util;

import java.util.List;

import dao.CategoryDAO;
import dao.ProductDAO;
import model.Category;
import model.Product;

/**
 * Utility class to seed the database with initial products
 * Run this class's main method to insert products into the database
 */
public class ProductSeeder {
    
    public static void main(String[] args) {
        System.out.println("Starting product seeding...");
        
        try {
            // Get all categories to map names to IDs
            List<Category> categories = CategoryDAO.getAllCategories();
            System.out.println("Found " + categories.size() + " categories");
            
            // Create products array mapped to local uploaded images
            Product[] products = {
                // Electronics
                createProduct("Laptop", "High-performance laptop with 16GB RAM", 
                    59999.00, "Electronics", "uploads/laptop.jpg", 50, "TechBrand", 4.7),
                
                createProduct("Smartphone", "Latest smartphone with 128GB storage", 
                    29999.00, "Electronics", "uploads/smartphone.jpg", 100, "TechBrand", 4.5),
                
                // Fashion/Clothing
                createProduct("T-Shirt", "Cotton t-shirt, comfortable fit", 
                    599.00, "Clothing", "uploads/tshirt.jpg", 200, "FashionBrand", 4.2),
                
                createProduct("Jeans", "Denim jeans, classic fit", 
                    1999.00, "Clothing", "uploads/jeans.jpg", 150, "FashionBrand", 4.3),
                
                // Books
                createProduct("Java Programming Book", "Complete guide to Java programming", 
                    899.00, "Books", "uploads/java-book.jpg", 75, "TechBooks", 4.6),
                
                // Home & Kitchen
                createProduct("Coffee Maker", "Automatic coffee maker", 
                    3499.00, "Home & Kitchen", "uploads/coffee-maker.jpg", 30, "HomeBrand", 4.4),
                
                // Sports
                createProduct("Football", "Professional football", 
                    999.00, "Sports", "uploads/football.jpg", 100, "SportsBrand", 4.5)
            };
            
            // Insert products
            int successCount = 0;
            int failCount = 0;
            
            for (Product product : products) {
                if (product != null) {
                    if (ProductDAO.addProduct(product)) {
                        System.out.println("✓ Added: " + product.getName());
                        successCount++;
                    } else {
                        System.out.println("✗ Failed to add: " + product.getName());
                        failCount++;
                    }
                } else {
                    System.out.println("✗ Skipped product (category not found)");
                    failCount++;
                }
            }
            
            System.out.println("\n=== Seeding Complete ===");
            System.out.println("Successfully added: " + successCount + " products");
            System.out.println("Failed: " + failCount + " products");
            
        } catch (Exception e) {
            System.err.println("Error during seeding: " + e.getMessage());
            e.printStackTrace();
        }
    }
    
    private static Product createProduct(String name, String description, double price, 
                                        String categoryName, String imageUrl, int stock, 
                                        String brand, double rating) {
        try {
            // Find category by name
            List<Category> categories = CategoryDAO.getAllCategories();
            Integer categoryId = null;
            
            for (Category cat : categories) {
                if (cat.getName().equalsIgnoreCase(categoryName)) {
                    categoryId = cat.getId();
                    break;
                }
            }
            
            if (categoryId == null) {
                System.err.println("Category not found: " + categoryName);
                return null;
            }
            
            Product product = new Product();
            product.setName(name);
            product.setDescription(description);
            product.setPrice(price);
            product.setCategoryId(categoryId);
            product.setImageUrl(imageUrl);
            product.setStock(stock);
            product.setBrand(brand);
            product.setRating(rating);
            
            return product;
        } catch (Exception e) {
            System.err.println("Error creating product " + name + ": " + e.getMessage());
            return null;
        }
    }
}
