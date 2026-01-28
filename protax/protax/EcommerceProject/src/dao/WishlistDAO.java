package dao;

import model.Product;
import model.Wishlist;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class WishlistDAO {

    public static boolean addToWishlist(int userId, int productId) {
        Connection con = null;
        PreparedStatement ps = null;
        try {
            con = DBConnection.getConnection();
            ps = con.prepareStatement(
                "INSERT INTO wishlist(user_id, product_id) VALUES (?, ?) " +
                "ON CONFLICT (user_id, product_id) DO NOTHING"
            );
            ps.setInt(1, userId);
            ps.setInt(2, productId);
            ps.executeUpdate();
            return true;
        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            closeResources(null, ps, con);
        }
        return false;
    }

    public static boolean removeFromWishlist(int userId, int productId) {
        Connection con = null;
        PreparedStatement ps = null;
        try {
            con = DBConnection.getConnection();
            ps = con.prepareStatement("DELETE FROM wishlist WHERE user_id=? AND product_id=?");
            ps.setInt(1, userId);
            ps.setInt(2, productId);
            return ps.executeUpdate() > 0;
        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            closeResources(null, ps, con);
        }
        return false;
    }

    public static List<Wishlist> getWishlist(int userId) {
        List<Wishlist> items = new ArrayList<>();
        Connection con = null;
        PreparedStatement ps = null;
        ResultSet rs = null;
        try {
            con = DBConnection.getConnection();
            ps = con.prepareStatement(
                "SELECT w.id as wishlist_id, w.created_at, w.user_id, w.product_id, " +
                "p.id as product_id, p.name, p.description, p.price, p.category_id, " +
                "p.image_url, p.stock, p.brand, p.rating, c.name as category_name " +
                "FROM wishlist w " +
                "JOIN products p ON w.product_id = p.id " +
                "LEFT JOIN categories c ON p.category_id = c.id " +
                "WHERE w.user_id=? ORDER BY w.created_at DESC"
            );
            ps.setInt(1, userId);
            rs = ps.executeQuery();
            while (rs.next()) {
                Wishlist w = new Wishlist();
                w.setId(rs.getInt("wishlist_id"));
                w.setUserId(rs.getInt("user_id"));
                w.setProductId(rs.getInt("product_id"));
                w.setCreatedAt(rs.getTimestamp("created_at"));

                Product p = new Product();
                p.setId(rs.getInt("product_id"));
                p.setName(rs.getString("name"));
                p.setDescription(rs.getString("description"));
                p.setPrice(rs.getDouble("price"));
                p.setCategoryId(rs.getInt("category_id"));
                p.setImageUrl(rs.getString("image_url"));
                p.setStock(rs.getInt("stock"));
                p.setBrand(rs.getString("brand"));
                p.setRating(rs.getDouble("rating"));
                p.setCategoryName(rs.getString("category_name"));
                w.setProduct(p);

                items.add(w);
            }
        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            closeResources(rs, ps, con);
        }
        return items;
    }

    public static boolean isInWishlist(int userId, int productId) {
        Connection con = null;
        PreparedStatement ps = null;
        ResultSet rs = null;
        try {
            con = DBConnection.getConnection();
            ps = con.prepareStatement(
                "SELECT 1 FROM wishlist WHERE user_id=? AND product_id=?"
            );
            ps.setInt(1, userId);
            ps.setInt(2, productId);
            rs = ps.executeQuery();
            return rs.next();
        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            closeResources(rs, ps, con);
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
