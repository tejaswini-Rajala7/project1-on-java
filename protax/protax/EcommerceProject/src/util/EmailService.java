package util;

import jakarta.mail.Message;
import jakarta.mail.MessagingException;
import jakarta.mail.PasswordAuthentication;
import jakarta.mail.Session;
import jakarta.mail.Transport;
import jakarta.mail.internet.InternetAddress;
import jakarta.mail.internet.MimeMessage;

import java.util.List;
import java.util.Properties;

import model.Order;
import model.OrderItem;
import model.User;

public class EmailService {
    // Configure via environment variables or edit defaults
    private static final String SMTP_HOST = System.getenv().getOrDefault("SMTP_HOST", "smtp.example.com");
    private static final String SMTP_PORT = System.getenv().getOrDefault("SMTP_PORT", "587");
    private static final String SMTP_USERNAME = System.getenv().getOrDefault("SMTP_USERNAME", "");
    private static final String SMTP_PASSWORD = System.getenv().getOrDefault("SMTP_PASSWORD", "");
    private static final String SMTP_FROM = System.getenv().getOrDefault("SMTP_FROM", "no-reply@protax-store.com");

    public static void sendOrderConfirmation(User user, Order order, List<OrderItem> items) {
        if (user == null || order == null || user.getEmail() == null || user.getEmail().isEmpty()) {
            return;
        }
        if (SMTP_USERNAME.isEmpty()) {
            System.out.println("[EmailService] SMTP not configured. Skipping email for order " + order.getId());
            return;
        }

        try {
            Session session = createSession();
            Message message = new MimeMessage(session);
            message.setFrom(new InternetAddress(SMTP_FROM));
            message.setRecipients(Message.RecipientType.TO, InternetAddress.parse(user.getEmail()));
            message.setSubject("Your Protax order #" + order.getId());
            message.setText(buildBody(user, order, items));
            Transport.send(message);
            System.out.println("[EmailService] Sent order confirmation for order " + order.getId());
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    private static Session createSession() {
        Properties props = new Properties();
        props.put("mail.smtp.auth", "true");
        props.put("mail.smtp.starttls.enable", "true");
        props.put("mail.smtp.host", SMTP_HOST);
        props.put("mail.smtp.port", SMTP_PORT);

        return Session.getInstance(props, new jakarta.mail.Authenticator() {
            @Override
            protected PasswordAuthentication getPasswordAuthentication() {
                return new PasswordAuthentication(SMTP_USERNAME, SMTP_PASSWORD);
            }
        });
    }

    private static String buildBody(User user, Order order, List<OrderItem> items) {
        StringBuilder sb = new StringBuilder();
        sb.append("Hi ").append(user.getName() != null ? user.getName() : "there").append(",\n\n");
        sb.append("Thanks for shopping at Protax Store. Your order has been received.\n\n");
        sb.append("Order ID: ").append(order.getId()).append("\n");
        sb.append("Status: ").append(order.getStatus()).append("\n");
        sb.append("Payment: ").append(order.getPaymentStatus()).append(" (").append(order.getPaymentMethod()).append(")\n");
        sb.append("Total: ₹").append(String.format("%.2f", order.getTotalAmount())).append("\n\n");
        sb.append("Items:\n");
        if (items != null) {
            for (OrderItem item : items) {
                sb.append("- ").append(item.getProductName())
                  .append(" x ").append(item.getQuantity())
                  .append(" @ ₹").append(String.format("%.2f", item.getPrice()))
                  .append("\n");
            }
        }
        sb.append("\nWe'll notify you when the order is shipped.\n");
        sb.append("\nIf you have questions, reply to this email.\n");
        sb.append("\nThanks,\nProtax Store");
        return sb.toString();
    }
}
