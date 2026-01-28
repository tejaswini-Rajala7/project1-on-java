package util;

import java.sql.*;
import dao.DBConnection;

/**
 * Utility class to update product image URLs in the database
 * This updates all products to use local uploads stored in WebContent/uploads
 */
public class ImageUrlUpdater {
    
    public static void main(String[] args) {
        System.out.println("Starting image URL update...");
        
        Connection con = null;
        PreparedStatement ps = null;
        
        try {
            con = DBConnection.getConnection();
            
            // Map of product names to their local image URLs (relative to context path)
            String[][] imageUpdates = {
                {"Laptop", "uploads/laptop.jpg"},
                {"Smartphone", "uploads/smartphone.jpg"},
                {"T-Shirt", "uploads/tshirt.jpg"},
                {"Jeans", "uploads/jeans.jpg"},
                {"Java Programming Book", "uploads/java-book.jpg"},
                {"Coffee Maker", "uploads/coffee-maker.jpg"},
                {"Football", "uploads/football.jpg"}
            };
            
            int updateCount = 0;
            
            // Update products by name
            for (String[] update : imageUpdates) {
                String productName = update[0];
                String imageUrl = update[1];
                
                ps = con.prepareStatement(
                    "UPDATE products SET image_url = ? WHERE name = ? AND (image_url NOT LIKE 'uploads/%' OR image_url IS NULL OR image_url = '')"
                );
                ps.setString(1, imageUrl);
                ps.setString(2, productName);
                
                int rowsUpdated = ps.executeUpdate();
                if (rowsUpdated > 0) {
                    System.out.println("✓ Updated: " + productName);
                    updateCount += rowsUpdated;
                }
                ps.close();
            }
            
            // Update any remaining products with local paths to a default placeholder
            ps = con.prepareStatement(
                "UPDATE products SET image_url = ? WHERE image_url NOT LIKE 'uploads/%' OR image_url IS NULL OR image_url = ''"
            );
            ps.setString(1, "uploads/smartphone.jpg");
            int remainingUpdated = ps.executeUpdate();
            if (remainingUpdated > 0) {
                System.out.println("✓ Updated " + remainingUpdated + " remaining products with default image");
                updateCount += remainingUpdated;
            }
            
            System.out.println("\n=== Update Complete ===");
            System.out.println("Total products updated: " + updateCount);
            
            // Verify updates
            ps = con.prepareStatement("SELECT id, name, image_url FROM products ORDER BY id");
            ResultSet rs = ps.executeQuery();
            System.out.println("\n=== Current Product Images ===");
            while (rs.next()) {
                System.out.println("ID: " + rs.getInt("id") + 
                                 " | Name: " + rs.getString("name") + 
                                 " | Image: " + rs.getString("image_url"));
            }
            rs.close();
            ps.close();
            
        } catch (Exception e) {
            System.err.println("Error during image URL update: " + e.getMessage());
            e.printStackTrace();
        } finally {
            try {
                if (ps != null) ps.close();
                if (con != null) con.close();
            } catch (SQLException e) {
                e.printStackTrace();
            }
        }
    }
}
