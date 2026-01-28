package dao;

import model.Coupon;
import org.junit.jupiter.api.Test;
import static org.junit.jupiter.api.Assertions.assertEquals;

public class CouponDAOTest {

    @Test
    void calculatesPercentDiscountCapped() {
        Coupon c = new Coupon();
        c.setDiscountPercent(10);
        c.setMaxDiscount(50);
        c.setMinPurchase(0);

        double discount = CouponDAO.calculateDiscount(c, 600);
        assertEquals(50, discount, 0.001); // capped at 50
    }

    @Test
    void calculatesAmountDiscountWithMinPurchase() {
        Coupon c = new Coupon();
        c.setDiscountAmount(100);
        c.setMinPurchase(500);

        double discountTooLow = CouponDAO.calculateDiscount(c, 400);
        double discountOk = CouponDAO.calculateDiscount(c, 600);

        assertEquals(0, discountTooLow, 0.001);
        assertEquals(100, discountOk, 0.001);
    }
}
