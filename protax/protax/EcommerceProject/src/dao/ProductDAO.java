package dao;

import model.Product;
import java.sql.*;
import java.util.*;

public class ProductDAO {

    public static List<Product> getAllProducts() {
        List<Product> list = new ArrayList<>();
        Connection con = null;
        PreparedStatement ps = null;
        ResultSet rs = null;
        try {
            con = DBConnection.getConnection();
            ps = con.prepareStatement(
                "SELECT p.*, c.name as category_name FROM products p " +
                "LEFT JOIN categories c ON p.category_id = c.id ORDER BY p.id DESC"
            );
            rs = ps.executeQuery();

            while (rs.next()) {
                Product p = new Product();
                p.setId(rs.getInt("id"));
                p.setName(rs.getString("name"));
                p.setDescription(rs.getString("description"));
                p.setPrice(rs.getDouble("price"));
                p.setCategoryId(rs.getInt("category_id"));
                p.setImageUrl(rs.getString("image_url"));
                p.setStock(rs.getInt("stock"));
                p.setBrand(rs.getString("brand"));
                p.setRating(rs.getDouble("rating"));
                p.setCategoryName(rs.getString("category_name"));
                list.add(p);
            }
        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            closeResources(rs, ps, con);
        }
        return list;
    }

    public static Product getProductById(int productId) {
        Connection con = null;
        PreparedStatement ps = null;
        ResultSet rs = null;
        try {
            con = DBConnection.getConnection();
            ps = con.prepareStatement(
                "SELECT p.*, c.name as category_name FROM products p " +
                "LEFT JOIN categories c ON p.category_id = c.id WHERE p.id=?"
            );
            ps.setInt(1, productId);
            rs = ps.executeQuery();

            if (rs.next()) {
                Product p = new Product();
                p.setId(rs.getInt("id"));
                p.setName(rs.getString("name"));
                p.setDescription(rs.getString("description"));
                p.setPrice(rs.getDouble("price"));
                p.setCategoryId(rs.getInt("category_id"));
                p.setImageUrl(rs.getString("image_url"));
                p.setStock(rs.getInt("stock"));
                p.setBrand(rs.getString("brand"));
                p.setRating(rs.getDouble("rating"));
                p.setCategoryName(rs.getString("category_name"));
                return p;
            }
        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            closeResources(rs, ps, con);
        }
        return null;
    }

    public static List<Product> getProductsByCategory(int categoryId) {
        List<Product> list = new ArrayList<>();
        Connection con = null;
        PreparedStatement ps = null;
        ResultSet rs = null;
        try {
            con = DBConnection.getConnection();
            ps = con.prepareStatement(
                "SELECT p.*, c.name as category_name FROM products p " +
                "LEFT JOIN categories c ON p.category_id = c.id WHERE p.category_id=?"
            );
            ps.setInt(1, categoryId);
            rs = ps.executeQuery();

            while (rs.next()) {
                Product p = new Product();
                p.setId(rs.getInt("id"));
                p.setName(rs.getString("name"));
                p.setDescription(rs.getString("description"));
                p.setPrice(rs.getDouble("price"));
                p.setCategoryId(rs.getInt("category_id"));
                p.setImageUrl(rs.getString("image_url"));
                p.setStock(rs.getInt("stock"));
                p.setBrand(rs.getString("brand"));
                p.setRating(rs.getDouble("rating"));
                p.setCategoryName(rs.getString("category_name"));
                list.add(p);
            }
        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            closeResources(rs, ps, con);
        }
        return list;
    }

    public static List<Product> searchProducts(String searchTerm) {
        List<Product> list = new ArrayList<>();
        Connection con = null;
        PreparedStatement ps = null;
        ResultSet rs = null;
        try {
            con = DBConnection.getConnection();
            ps = con.prepareStatement(
                "SELECT p.*, c.name as category_name FROM products p " +
                "LEFT JOIN categories c ON p.category_id = c.id " +
                "WHERE p.name LIKE ? OR p.description LIKE ? OR p.brand LIKE ?"
            );
            String searchPattern = "%" + searchTerm + "%";
            ps.setString(1, searchPattern);
            ps.setString(2, searchPattern);
            ps.setString(3, searchPattern);
            rs = ps.executeQuery();

            while (rs.next()) {
                Product p = new Product();
                p.setId(rs.getInt("id"));
                p.setName(rs.getString("name"));
                p.setDescription(rs.getString("description"));
                p.setPrice(rs.getDouble("price"));
                p.setCategoryId(rs.getInt("category_id"));
                p.setImageUrl(rs.getString("image_url"));
                p.setStock(rs.getInt("stock"));
                p.setBrand(rs.getString("brand"));
                p.setRating(rs.getDouble("rating"));
                p.setCategoryName(rs.getString("category_name"));
                list.add(p);
            }
        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            closeResources(rs, ps, con);
        }
        return list;
    }

    public static List<Product> searchProductsWithFilters(String searchTerm, Integer categoryId,
                                                          Double minPrice, Double maxPrice, Double minRating,
                                                          int offset, int limit) {
        List<Product> list = new ArrayList<>();
        Connection con = null;
        PreparedStatement ps = null;
        ResultSet rs = null;
        try {
            con = DBConnection.getConnection();
            StringBuilder sql = new StringBuilder(
                "SELECT p.*, c.name as category_name FROM products p " +
                "LEFT JOIN categories c ON p.category_id = c.id WHERE 1=1"
            );
            List<Object> params = new ArrayList<>();

            if (searchTerm != null && !searchTerm.trim().isEmpty()) {
                sql.append(" AND (p.name ILIKE ? OR p.description ILIKE ? OR p.brand ILIKE ?)");
                String pattern = "%" + searchTerm.trim() + "%";
                params.add(pattern);
                params.add(pattern);
                params.add(pattern);
            }
            if (categoryId != null) {
                sql.append(" AND p.category_id = ?");
                params.add(categoryId);
            }
            if (minPrice != null) {
                sql.append(" AND p.price >= ?");
                params.add(minPrice);
            }
            if (maxPrice != null) {
                sql.append(" AND p.price <= ?");
                params.add(maxPrice);
            }
            if (minRating != null) {
                sql.append(" AND p.rating >= ?");
                params.add(minRating);
            }

            sql.append(" ORDER BY p.id DESC LIMIT ? OFFSET ?");
            params.add(limit);
            params.add(offset);

            ps = con.prepareStatement(sql.toString());
            for (int i = 0; i < params.size(); i++) {
                ps.setObject(i + 1, params.get(i));
            }

            rs = ps.executeQuery();
            while (rs.next()) {
                Product p = new Product();
                p.setId(rs.getInt("id"));
                p.setName(rs.getString("name"));
                p.setDescription(rs.getString("description"));
                p.setPrice(rs.getDouble("price"));
                p.setCategoryId(rs.getInt("category_id"));
                p.setImageUrl(rs.getString("image_url"));
                p.setStock(rs.getInt("stock"));
                p.setBrand(rs.getString("brand"));
                p.setRating(rs.getDouble("rating"));
                p.setCategoryName(rs.getString("category_name"));
                list.add(p);
            }
        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            closeResources(rs, ps, con);
        }
        return list;
    }

    public static int countProductsWithFilters(String searchTerm, Integer categoryId,
                                               Double minPrice, Double maxPrice, Double minRating) {
        Connection con = null;
        PreparedStatement ps = null;
        ResultSet rs = null;
        try {
            con = DBConnection.getConnection();
            StringBuilder sql = new StringBuilder(
                "SELECT COUNT(*) FROM products p WHERE 1=1"
            );
            List<Object> params = new ArrayList<>();

            if (searchTerm != null && !searchTerm.trim().isEmpty()) {
                sql.append(" AND (p.name ILIKE ? OR p.description ILIKE ? OR p.brand ILIKE ?)");
                String pattern = "%" + searchTerm.trim() + "%";
                params.add(pattern);
                params.add(pattern);
                params.add(pattern);
            }
            if (categoryId != null) {
                sql.append(" AND p.category_id = ?");
                params.add(categoryId);
            }
            if (minPrice != null) {
                sql.append(" AND p.price >= ?");
                params.add(minPrice);
            }
            if (maxPrice != null) {
                sql.append(" AND p.price <= ?");
                params.add(maxPrice);
            }
            if (minRating != null) {
                sql.append(" AND p.rating >= ?");
                params.add(minRating);
            }

            ps = con.prepareStatement(sql.toString());
            for (int i = 0; i < params.size(); i++) {
                ps.setObject(i + 1, params.get(i));
            }

            rs = ps.executeQuery();
            if (rs.next()) {
                return rs.getInt(1);
            }
        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            closeResources(rs, ps, con);
        }
        return 0;
    }

    public static boolean addProduct(Product product) {
        Connection con = null;
        PreparedStatement ps = null;
        try {
            con = DBConnection.getConnection();
            ps = con.prepareStatement(
                "INSERT INTO products(name, description, price, category_id, image_url, stock, brand, rating) " +
                "VALUES(?, ?, ?, ?, ?, ?, ?, ?)"
            );
            ps.setString(1, product.getName());
            ps.setString(2, product.getDescription());
            ps.setDouble(3, product.getPrice());
            ps.setInt(4, product.getCategoryId());
            ps.setString(5, product.getImageUrl());
            ps.setInt(6, product.getStock());
            ps.setString(7, product.getBrand());
            ps.setDouble(8, product.getRating());
            return ps.executeUpdate() > 0;
        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            closeResources(null, ps, con);
        }
        return false;
    }

    public static boolean updateProduct(Product product) {
        Connection con = null;
        PreparedStatement ps = null;
        try {
            con = DBConnection.getConnection();
            ps = con.prepareStatement(
                "UPDATE products SET name=?, description=?, price=?, category_id=?, " +
                "image_url=?, stock=?, brand=? WHERE id=?"
            );
            ps.setString(1, product.getName());
            ps.setString(2, product.getDescription());
            ps.setDouble(3, product.getPrice());
            ps.setInt(4, product.getCategoryId());
            ps.setString(5, product.getImageUrl());
            ps.setInt(6, product.getStock());
            ps.setString(7, product.getBrand());
            ps.setInt(8, product.getId());
            return ps.executeUpdate() > 0;
        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            closeResources(null, ps, con);
        }
        return false;
    }

    public static boolean deleteProduct(int productId) {
        Connection con = null;
        PreparedStatement ps = null;
        try {
            con = DBConnection.getConnection();
            ps = con.prepareStatement("DELETE FROM products WHERE id=?");
            ps.setInt(1, productId);
            return ps.executeUpdate() > 0;
        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            closeResources(null, ps, con);
        }
        return false;
    }

    private static void closeResources(ResultSet rs, PreparedStatement ps, Connection con) {
        try {
            if (rs != null) rs.close();
            if (ps != null) ps.close();
            if (con != null) con.close();
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }
}
