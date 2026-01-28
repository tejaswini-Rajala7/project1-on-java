package util;

public class PaymentService {

    public static class PaymentResult {
        private final boolean success;
        private final String status; // paid / pending / failed
        private final String message;

        public PaymentResult(boolean success, String status, String message) {
            this.success = success;
            this.status = status;
            this.message = message;
        }

        public boolean isSuccess() {
            return success;
        }

        public String getStatus() {
            return status;
        }

        public String getMessage() {
            return message;
        }
    }

    /**
     * Stubbed payment processor.
     * COD stays pending, Stripe/Razorpay test modes are auto-approved,
     * and credit/UPI are accepted in demo mode.
     */
    public static PaymentResult process(String method, double amount) {
        if (method == null) {
            return new PaymentResult(true, "pending", "Cash on delivery");
        }
        String normalized = method.toLowerCase();
        if (normalized.contains("cash")) {
            return new PaymentResult(true, "pending", "Cash on delivery");
        }
        if (normalized.contains("stripe")) {
            return new PaymentResult(true, "paid", "Stripe test payment approved");
        }
        if (normalized.contains("razorpay")) {
            return new PaymentResult(true, "paid", "Razorpay test payment approved");
        }
        if (normalized.contains("credit") || normalized.contains("card") || normalized.contains("upi")) {
            return new PaymentResult(true, "paid", "Payment captured");
        }
        return new PaymentResult(false, "failed", "Unsupported payment method");
    }
}
