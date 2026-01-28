package dao;

import model.Order;
import model.OrderItem;
import java.sql.*;
import java.util.*;

public class OrderDAO {

    public static int createOrder(int userId, int addressId, double totalAmount, String paymentMethod) {
        Connection con = null;
        PreparedStatement ps = null;
        ResultSet rs = null;
        try {
            con = DBConnection.getConnection();
            ps = con.prepareStatement(
                "INSERT INTO orders(user_id, address_id, total_amount, payment_method, status, payment_status) " +
                "VALUES(?, ?, ?, ?, 'pending', 'pending')",
                Statement.RETURN_GENERATED_KEYS
            );
            ps.setInt(1, userId);
            ps.setInt(2, addressId);
            ps.setDouble(3, totalAmount);
            ps.setString(4, paymentMethod);
            ps.executeUpdate();

            rs = ps.getGeneratedKeys();
            if (rs.next()) {
                return rs.getInt(1);
            }
        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            closeResources(rs, ps, con);
        }
        return -1;
    }

    public static void addOrderItem(int orderId, int productId, int quantity, double price) {
        Connection con = null;
        PreparedStatement ps = null;
        try {
            con = DBConnection.getConnection();
            ps = con.prepareStatement(
                "INSERT INTO order_items(order_id, product_id, quantity, price) VALUES(?, ?, ?, ?)"
            );
            ps.setInt(1, orderId);
            ps.setInt(2, productId);
            ps.setInt(3, quantity);
            ps.setDouble(4, price);
            ps.executeUpdate();
        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            closeResources(null, ps, con);
        }
    }

    public static List<Order> getOrdersByUser(int userId) {
        List<Order> list = new ArrayList<>();
        Connection con = null;
        PreparedStatement ps = null;
        ResultSet rs = null;
        try {
            con = DBConnection.getConnection();
            ps = con.prepareStatement(
                "SELECT o.*, u.name as user_name, " +
                "(a.address_line1 || ', ' || a.city || ', ' || a.state || ' - ' || a.pincode) as address_details " +
                "FROM orders o " +
                "JOIN users u ON o.user_id = u.id " +
                "JOIN addresses a ON o.address_id = a.id " +
                "WHERE o.user_id=? ORDER BY o.order_date DESC"
            );
            ps.setInt(1, userId);
            rs = ps.executeQuery();

            while (rs.next()) {
                Order order = new Order();
                order.setId(rs.getInt("id"));
                order.setUserId(rs.getInt("user_id"));
                order.setAddressId(rs.getInt("address_id"));
                order.setTotalAmount(rs.getDouble("total_amount"));
                order.setStatus(rs.getString("status"));
                order.setPaymentMethod(rs.getString("payment_method"));
                order.setPaymentStatus(rs.getString("payment_status"));
                order.setOrderDate(rs.getTimestamp("order_date"));
                order.setUserName(rs.getString("user_name"));
                order.setAddressDetails(rs.getString("address_details"));
                list.add(order);
            }
        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            closeResources(rs, ps, con);
        }
        return list;
    }

    public static Order getOrderById(int orderId) {
        Connection con = null;
        PreparedStatement ps = null;
        ResultSet rs = null;
        try {
            con = DBConnection.getConnection();
            ps = con.prepareStatement(
                "SELECT o.*, u.name as user_name, " +
                "(a.address_line1 || ', ' || a.city || ', ' || a.state || ' - ' || a.pincode) as address_details " +
                "FROM orders o " +
                "JOIN users u ON o.user_id = u.id " +
                "JOIN addresses a ON o.address_id = a.id " +
                "WHERE o.id=?"
            );
            ps.setInt(1, orderId);
            rs = ps.executeQuery();

            if (rs.next()) {
                Order order = new Order();
                order.setId(rs.getInt("id"));
                order.setUserId(rs.getInt("user_id"));
                order.setAddressId(rs.getInt("address_id"));
                order.setTotalAmount(rs.getDouble("total_amount"));
                order.setStatus(rs.getString("status"));
                order.setPaymentMethod(rs.getString("payment_method"));
                order.setPaymentStatus(rs.getString("payment_status"));
                order.setOrderDate(rs.getTimestamp("order_date"));
                order.setUserName(rs.getString("user_name"));
                order.setAddressDetails(rs.getString("address_details"));
                return order;
            }
        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            closeResources(rs, ps, con);
        }
        return null;
    }

    public static List<OrderItem> getOrderItems(int orderId) {
        List<OrderItem> list = new ArrayList<>();
        Connection con = null;
        PreparedStatement ps = null;
        ResultSet rs = null;
        try {
            con = DBConnection.getConnection();
            ps = con.prepareStatement(
                "SELECT oi.*, p.name as product_name, p.image_url as product_image " +
                "FROM order_items oi JOIN products p ON oi.product_id = p.id WHERE oi.order_id=?"
            );
            ps.setInt(1, orderId);
            rs = ps.executeQuery();

            while (rs.next()) {
                OrderItem item = new OrderItem();
                item.setId(rs.getInt("id"));
                item.setOrderId(rs.getInt("order_id"));
                item.setProductId(rs.getInt("product_id"));
                item.setQuantity(rs.getInt("quantity"));
                item.setPrice(rs.getDouble("price"));
                item.setProductName(rs.getString("product_name"));
                item.setProductImage(rs.getString("product_image"));
                list.add(item);
            }
        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            closeResources(rs, ps, con);
        }
        return list;
    }

    public static List<Order> getAllOrders() {
        List<Order> list = new ArrayList<>();
        Connection con = null;
        PreparedStatement ps = null;
        ResultSet rs = null;
        try {
            con = DBConnection.getConnection();
            ps = con.prepareStatement(
                "SELECT o.*, u.name as user_name, " +
                "(a.address_line1 || ', ' || a.city || ', ' || a.state || ' - ' || a.pincode) as address_details " +
                "FROM orders o " +
                "JOIN users u ON o.user_id = u.id " +
                "JOIN addresses a ON o.address_id = a.id " +
                "ORDER BY o.order_date DESC"
            );
            rs = ps.executeQuery();

            while (rs.next()) {
                Order order = new Order();
                order.setId(rs.getInt("id"));
                order.setUserId(rs.getInt("user_id"));
                order.setAddressId(rs.getInt("address_id"));
                order.setTotalAmount(rs.getDouble("total_amount"));
                order.setStatus(rs.getString("status"));
                order.setPaymentMethod(rs.getString("payment_method"));
                order.setPaymentStatus(rs.getString("payment_status"));
                order.setOrderDate(rs.getTimestamp("order_date"));
                order.setUserName(rs.getString("user_name"));
                order.setAddressDetails(rs.getString("address_details"));
                list.add(order);
            }
        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            closeResources(rs, ps, con);
        }
        return list;
    }

    public static boolean updateOrderStatus(int orderId, String status) {
        Connection con = null;
        PreparedStatement ps = null;
        try {
            con = DBConnection.getConnection();
            ps = con.prepareStatement("UPDATE orders SET status=? WHERE id=?");
            ps.setString(1, status);
            ps.setInt(2, orderId);
            return ps.executeUpdate() > 0;
        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            closeResources(null, ps, con);
        }
        return false;
    }

    public static boolean updatePaymentStatus(int orderId, String paymentStatus) {
        Connection con = null;
        PreparedStatement ps = null;
        try {
            con = DBConnection.getConnection();
            ps = con.prepareStatement("UPDATE orders SET payment_status=? WHERE id=?");
            ps.setString(1, paymentStatus);
            ps.setInt(2, orderId);
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
