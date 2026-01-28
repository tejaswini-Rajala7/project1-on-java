package dao;

import model.Address;
import java.sql.*;
import java.util.*;

public class AddressDAO {

    public static boolean addAddress(Address address) {
        Connection con = null;
        PreparedStatement ps = null;
        try {
            con = DBConnection.getConnection();
            
            // If this is default, unset other defaults
            if (address.isDefault()) {
                PreparedStatement updateDefault = con.prepareStatement(
                    "UPDATE addresses SET is_default = FALSE WHERE user_id = ?"
                );
                updateDefault.setInt(1, address.getUserId());
                updateDefault.executeUpdate();
                updateDefault.close();
            }

            ps = con.prepareStatement(
                "INSERT INTO addresses(user_id, full_name, phone, address_line1, address_line2, city, state, pincode, is_default) " +
                "VALUES(?, ?, ?, ?, ?, ?, ?, ?, ?)"
            );
            ps.setInt(1, address.getUserId());
            ps.setString(2, address.getFullName());
            ps.setString(3, address.getPhone());
            ps.setString(4, address.getAddressLine1());
            ps.setString(5, address.getAddressLine2());
            ps.setString(6, address.getCity());
            ps.setString(7, address.getState());
            ps.setString(8, address.getPincode());
            ps.setBoolean(9, address.isDefault());
            return ps.executeUpdate() > 0;
        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            closeResources(null, ps, con);
        }
        return false;
    }

    public static List<Address> getAddressesByUser(int userId) {
        List<Address> list = new ArrayList<>();
        Connection con = null;
        PreparedStatement ps = null;
        ResultSet rs = null;
        try {
            con = DBConnection.getConnection();
            ps = con.prepareStatement("SELECT * FROM addresses WHERE user_id=? ORDER BY is_default DESC");
            ps.setInt(1, userId);
            rs = ps.executeQuery();

            while (rs.next()) {
                Address address = new Address();
                address.setId(rs.getInt("id"));
                address.setUserId(rs.getInt("user_id"));
                address.setFullName(rs.getString("full_name"));
                address.setPhone(rs.getString("phone"));
                address.setAddressLine1(rs.getString("address_line1"));
                address.setAddressLine2(rs.getString("address_line2"));
                address.setCity(rs.getString("city"));
                address.setState(rs.getString("state"));
                address.setPincode(rs.getString("pincode"));
                address.setDefault(rs.getBoolean("is_default"));
                list.add(address);
            }
        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            closeResources(rs, ps, con);
        }
        return list;
    }

    public static Address getAddressById(int addressId) {
        Connection con = null;
        PreparedStatement ps = null;
        ResultSet rs = null;
        try {
            con = DBConnection.getConnection();
            ps = con.prepareStatement("SELECT * FROM addresses WHERE id=?");
            ps.setInt(1, addressId);
            rs = ps.executeQuery();

            if (rs.next()) {
                Address address = new Address();
                address.setId(rs.getInt("id"));
                address.setUserId(rs.getInt("user_id"));
                address.setFullName(rs.getString("full_name"));
                address.setPhone(rs.getString("phone"));
                address.setAddressLine1(rs.getString("address_line1"));
                address.setAddressLine2(rs.getString("address_line2"));
                address.setCity(rs.getString("city"));
                address.setState(rs.getString("state"));
                address.setPincode(rs.getString("pincode"));
                address.setDefault(rs.getBoolean("is_default"));
                return address;
            }
        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            closeResources(rs, ps, con);
        }
        return null;
    }

    public static Address getDefaultAddress(int userId) {
        Connection con = null;
        PreparedStatement ps = null;
        ResultSet rs = null;
        try {
            con = DBConnection.getConnection();
            ps = con.prepareStatement("SELECT * FROM addresses WHERE user_id=? AND is_default=TRUE");
            ps.setInt(1, userId);
            rs = ps.executeQuery();

            if (rs.next()) {
                Address address = new Address();
                address.setId(rs.getInt("id"));
                address.setUserId(rs.getInt("user_id"));
                address.setFullName(rs.getString("full_name"));
                address.setPhone(rs.getString("phone"));
                address.setAddressLine1(rs.getString("address_line1"));
                address.setAddressLine2(rs.getString("address_line2"));
                address.setCity(rs.getString("city"));
                address.setState(rs.getString("state"));
                address.setPincode(rs.getString("pincode"));
                address.setDefault(rs.getBoolean("is_default"));
                return address;
            }
        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            closeResources(rs, ps, con);
        }
        return null;
    }

    public static boolean deleteAddress(int addressId) {
        Connection con = null;
        PreparedStatement ps = null;
        try {
            con = DBConnection.getConnection();
            ps = con.prepareStatement("DELETE FROM addresses WHERE id=?");
            ps.setInt(1, addressId);
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
