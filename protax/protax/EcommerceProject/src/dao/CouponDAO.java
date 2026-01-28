package dao;

import model.Coupon;

import java.sql.*;

public class CouponDAO {

    public static Coupon findActiveByCode(String code) {
        Connection con = null;
        PreparedStatement ps = null;
        ResultSet rs = null;
        try {
            con = DBConnection.getConnection();
            ps = con.prepareStatement(
                "SELECT * FROM coupons WHERE code = ? AND is_active = TRUE " +
                "AND (valid_from IS NULL OR valid_from <= CURRENT_DATE) " +
                "AND (valid_until IS NULL OR valid_until >= CURRENT_DATE)"
            );
            ps.setString(1, code);
            rs = ps.executeQuery();
            if (rs.next()) {
                Coupon c = new Coupon();
                c.setId(rs.getInt("id"));
                c.setCode(rs.getString("code"));
                c.setDiscountPercent(rs.getDouble("discount_percent"));
                c.setDiscountAmount(rs.getDouble("discount_amount"));
                c.setMinPurchase(rs.getDouble("min_purchase"));
                c.setMaxDiscount(rs.getDouble("max_discount"));
                c.setValidFrom(rs.getDate("valid_from"));
                c.setValidUntil(rs.getDate("valid_until"));
                c.setActive(rs.getBoolean("is_active"));
                return c;
            }
        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            closeResources(rs, ps, con);
        }
        return null;
    }

    public static double calculateDiscount(Coupon coupon, double total) {
        if (coupon == null) return 0;
        if (total < coupon.getMinPurchase()) return 0;

        double discount = 0;
        if (coupon.getDiscountPercent() > 0) {
            discount = total * (coupon.getDiscountPercent() / 100.0);
        }
        if (coupon.getDiscountAmount() > 0) {
            discount += coupon.getDiscountAmount();
        }
        if (coupon.getMaxDiscount() > 0 && discount > coupon.getMaxDiscount()) {
            discount = coupon.getMaxDiscount();
        }
        return discount;
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
