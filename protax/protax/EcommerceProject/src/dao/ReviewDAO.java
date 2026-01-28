package dao;

import model.Review;
import java.sql.*;
import java.util.*;

public class ReviewDAO {

    public static boolean addReview(int userId, int productId, int rating, String comment) {
        Connection con = null;
        PreparedStatement ps = null;
        try {
            con = DBConnection.getConnection();
            ps = con.prepareStatement(
                "INSERT INTO reviews(user_id, product_id, rating, comment) VALUES(?, ?, ?, ?) " +
                "ON CONFLICT (user_id, product_id) DO UPDATE SET rating=EXCLUDED.rating, comment=EXCLUDED.comment"
            );
            ps.setInt(1, userId);
            ps.setInt(2, productId);
            ps.setInt(3, rating);
            ps.setString(4, comment);
            ps.executeUpdate();

            // Update product rating
            updateProductRating(productId);
            return true;
        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            closeResources(null, ps, con);
        }
        return false;
    }

    public static List<Review> getReviewsByProduct(int productId) {
        List<Review> list = new ArrayList<>();
        Connection con = null;
        PreparedStatement ps = null;
        ResultSet rs = null;
        try {
            con = DBConnection.getConnection();
            ps = con.prepareStatement(
                "SELECT r.*, u.name as user_name FROM reviews r " +
                "JOIN users u ON r.user_id = u.id WHERE r.product_id=? ORDER BY r.created_at DESC"
            );
            ps.setInt(1, productId);
            rs = ps.executeQuery();

            while (rs.next()) {
                Review review = new Review();
                review.setId(rs.getInt("id"));
                review.setUserId(rs.getInt("user_id"));
                review.setProductId(rs.getInt("product_id"));
                review.setRating(rs.getInt("rating"));
                review.setComment(rs.getString("comment"));
                review.setCreatedAt(rs.getTimestamp("created_at"));
                review.setUserName(rs.getString("user_name"));
                list.add(review);
            }
        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            closeResources(rs, ps, con);
        }
        return list;
    }

    private static void updateProductRating(int productId) {
        Connection con = null;
        PreparedStatement ps = null;
        ResultSet rs = null;
        try {
            con = DBConnection.getConnection();
            ps = con.prepareStatement("SELECT AVG(rating) as avg_rating FROM reviews WHERE product_id=?");
            ps.setInt(1, productId);
            rs = ps.executeQuery();

            if (rs.next()) {
                double avgRating = rs.getDouble("avg_rating");
                PreparedStatement update = con.prepareStatement("UPDATE products SET rating=? WHERE id=?");
                update.setDouble(1, avgRating);
                update.setInt(2, productId);
                update.executeUpdate();
                update.close();
            }
        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            closeResources(rs, ps, con);
        }
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
