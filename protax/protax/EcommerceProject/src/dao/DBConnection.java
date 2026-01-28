package dao;

import java.io.FileInputStream;
import java.io.InputStream;
import java.sql.Connection;
import java.sql.DriverManager;
import java.util.Properties;

public class DBConnection {
    private static final String DEFAULT_HOST = "localhost";
    private static final String DEFAULT_PORT = "5432";
    private static final String DEFAULT_DB = "ecommerce";
    private static final String DEFAULT_USER = "postgres";
    private static final String DEFAULT_PASSWORD = "postgres";
    
    private static String dbHost = DEFAULT_HOST;
    private static String dbPort = DEFAULT_PORT;
    private static String dbName = DEFAULT_DB;
    private static String dbUser = DEFAULT_USER;
    private static String dbPassword = DEFAULT_PASSWORD;
    
    static {
        loadConfiguration();
    }
    
    private static void loadConfiguration() {
        try {
            // Try to load from properties file
            Properties props = new Properties();
            InputStream is = DBConnection.class.getClassLoader().getResourceAsStream("db.properties");
            if (is == null) {
                // Try file system path
                try {
                    is = new FileInputStream("db.properties");
                } catch (Exception e) {
                    // Use defaults
                }
            }
            if (is != null) {
                props.load(is);
                dbHost = props.getProperty("db.host", DEFAULT_HOST);
                dbPort = props.getProperty("db.port", DEFAULT_PORT);
                dbName = props.getProperty("db.name", DEFAULT_DB);
                dbUser = props.getProperty("db.user", DEFAULT_USER);
                dbPassword = props.getProperty("db.password", DEFAULT_PASSWORD);
                is.close();
                System.out.println("[DBConnection] Loaded configuration from db.properties");
                System.out.println("[DBConnection] Database: " + dbName + ", User: " + dbUser);
            } else {
                System.out.println("[DBConnection] db.properties not found, using defaults");
            }
            
            // Override with environment variables if present
            dbHost = System.getenv().getOrDefault("DB_HOST", dbHost);
            dbPort = System.getenv().getOrDefault("DB_PORT", dbPort);
            dbName = System.getenv().getOrDefault("DB_NAME", dbName);
            dbUser = System.getenv().getOrDefault("DB_USER", dbUser);
            dbPassword = System.getenv().getOrDefault("DB_PASSWORD", dbPassword);
            
            System.out.println("[DBConnection] Final configuration - Host: " + dbHost + ", Port: " + dbPort + ", DB: " + dbName + ", User: " + dbUser);
        } catch (Exception e) {
            System.err.println("Warning: Could not load database configuration, using defaults: " + e.getMessage());
            e.printStackTrace();
        }
    }
    
    public static Connection getConnection() {
        Connection con = null;
        try {
            Class.forName("org.postgresql.Driver");
            String url = String.format("jdbc:postgresql://%s:%s/%s", dbHost, dbPort, dbName);
            System.out.println("[DBConnection] Attempting to connect to: " + url.replace(dbPassword, "***"));
            con = DriverManager.getConnection(url, dbUser, dbPassword);
            System.out.println("[DBConnection] Connection successful!");
        } catch (ClassNotFoundException e) {
            System.err.println("[DBConnection] ERROR: PostgreSQL driver not found. Make sure postgresql-42.7.4.jar is in classpath.");
            e.printStackTrace();
        } catch (Exception e) {
            System.err.println("[DBConnection] ERROR: Failed to connect to PostgreSQL database.");
            System.err.println("[DBConnection] Host: " + dbHost + ", Port: " + dbPort + ", Database: " + dbName);
            System.err.println("[DBConnection] User: " + dbUser);
            System.err.println("[DBConnection] Troubleshooting:");
            System.err.println("  1. Check if PostgreSQL is running: pg_ctl status or check Windows Services");
            System.err.println("  2. Verify database exists: psql -U postgres -l");
            System.err.println("  3. Create database if needed: CREATE DATABASE ecommerce;");
            System.err.println("  4. Check connection: psql -U postgres -d ecommerce");
            System.err.println("  5. Verify credentials in db.properties or environment variables");
            e.printStackTrace();
        }
        return con;
    }
    
    public static void testConnection() {
        Connection conn = getConnection();
        if (conn != null) {
            try {
                conn.close();
                System.out.println("[DBConnection] Test connection successful!");
            } catch (Exception e) {
                e.printStackTrace();
            }
        } else {
            System.err.println("[DBConnection] Test connection failed!");
        }
    }
}
