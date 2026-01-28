package dao;

import java.sql.*;
import java.util.*;
import model.Cart;

public class CartDAO {

    // Add product to cart
    public static void addToCart(int userId, int productId) {
        Connection con = null;
        PreparedStatement check = null;
        PreparedStatement update = null;
        PreparedStatement insert = null;
        ResultSet rs = null;
        try {
            con = DBConnection.getConnection();

            // check if product already in cart
            check = con.prepareStatement(
                "SELECT * FROM cart WHERE user_id=? AND product_id=?"
            );
            check.setInt(1, userId);
            check.setInt(2, productId);
            rs = check.executeQuery();

            if (rs.next()) {
                // if exists, increase quantity
                update = con.prepareStatement(
                    "UPDATE cart SET quantity = quantity + 1 WHERE user_id=? AND product_id=?"
                );
                update.setInt(1, userId);
                update.setInt(2, productId);
                update.executeUpdate();
            } else {
                // else insert new row
                insert = con.prepareStatement(
                    "INSERT INTO cart(user_id, product_id, quantity) VALUES(?,?,1)"
                );
                insert.setInt(1, userId);
                insert.setInt(2, productId);
                insert.executeUpdate();
            }

        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            closeResources(rs, check, con);
            closeResources(null, update, null);
            closeResources(null, insert, null);
        }
    }

    // Get cart items with product details
    public static List<Cart> getCartByUser(int userId) {
        List<Cart> list = new ArrayList<>();
        Connection con = null;
        PreparedStatement ps = null;
        ResultSet rs = null;
        try {
            con = DBConnection.getConnection();
            ps = con.prepareStatement(
                "SELECT c.*, p.name as product_name, p.price, p.image_url " +
                "FROM cart c JOIN products p ON c.product_id = p.id WHERE c.user_id=?"
            );
            ps.setInt(1, userId);
            rs = ps.executeQuery();

            while (rs.next()) {
                Cart c = new Cart();
                c.setId(rs.getInt("id"));
                c.setUserId(rs.getInt("user_id"));
                c.setProductId(rs.getInt("product_id"));
                c.setQuantity(rs.getInt("quantity"));
                c.setProductName(rs.getString("product_name"));
                c.setProductPrice(rs.getDouble("price"));
                c.setProductImage(rs.getString("image_url"));
                list.add(c);
            }

        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            closeResources(rs, ps, con);
        }
        return list;
    }

    // Update cart quantity
    public static void updateCartQuantity(int cartId, int quantity) {
        Connection con = null;
        PreparedStatement ps = null;
        try {
            con = DBConnection.getConnection();
            ps = con.prepareStatement("UPDATE cart SET quantity=? WHERE id=?");
            ps.setInt(1, quantity);
            ps.setInt(2, cartId);
            ps.executeUpdate();
        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            closeResources(null, ps, con);
        }
    }

    // Remove one product from cart
    public static void removeFromCart(int cartId) {
        Connection con = null;
        PreparedStatement ps = null;
        try {
            con = DBConnection.getConnection();
            ps = con.prepareStatement("DELETE FROM cart WHERE id=?");
            ps.setInt(1, cartId);
            ps.executeUpdate();
        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            closeResources(null, ps, con);
        }
    }

    // Clear cart after order placed
    public static void clearCart(int userId) {
        Connection con = null;
        PreparedStatement ps = null;
        try {
            con = DBConnection.getConnection();
            ps = con.prepareStatement("DELETE FROM cart WHERE user_id=?");
            ps.setInt(1, userId);
            ps.executeUpdate();
        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            closeResources(null, ps, con);
        }
    }

    // Get cart total
    public static double getCartTotal(int userId) {
        Connection con = null;
        PreparedStatement ps = null;
        ResultSet rs = null;
        try {
            con = DBConnection.getConnection();
            ps = con.prepareStatement(
                "SELECT SUM(c.quantity * p.price) as total " +
                "FROM cart c JOIN products p ON c.product_id = p.id WHERE c.user_id=?"
            );
            ps.setInt(1, userId);
            rs = ps.executeQuery();
            if (rs.next()) {
                return rs.getDouble("total");
            }
        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            closeResources(rs, ps, con);
        }
        return 0.0;
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
