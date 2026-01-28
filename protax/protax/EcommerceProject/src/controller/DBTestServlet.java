package controller;

import dao.DBConnection;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.io.PrintWriter;
import java.sql.Connection;
import java.sql.DatabaseMetaData;
import java.sql.ResultSet;

@WebServlet("/db-test")
public class DBTestServlet extends HttpServlet {
    
    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) 
            throws ServletException, IOException {
        resp.setContentType("text/html;charset=UTF-8");
        PrintWriter out = resp.getWriter();
        
        out.println("<!DOCTYPE html>");
        out.println("<html><head><title>Database Connection Test</title>");
        out.println("<style>body{font-family:Arial;margin:20px;} .success{color:green;} .error{color:red;} table{border-collapse:collapse;margin:20px 0;} th,td{border:1px solid #ddd;padding:8px;text-align:left;}</style>");
        out.println("</head><body>");
        out.println("<h1>Database Connection Test</h1>");
        
        Connection conn = null;
        try {
            out.println("<h2>Step 1: Attempting Connection...</h2>");
            conn = DBConnection.getConnection();
            
            if (conn == null) {
                out.println("<p class='error'>❌ Connection failed! Connection object is null.</p>");
                out.println("<h3>Troubleshooting Steps:</h3>");
                out.println("<ul>");
                out.println("<li>Check if PostgreSQL service is running</li>");
                out.println("<li>Verify database 'ecommerce' exists: <code>psql -U postgres -l</code></li>");
                out.println("<li>Create database if needed: <code>CREATE DATABASE ecommerce;</code></li>");
                out.println("<li>Check credentials in db.properties or DBConnection.java</li>");
                out.println("</ul>");
                return;
            }
            
            out.println("<p class='success'>✅ Connection successful!</p>");
            
            out.println("<h2>Step 2: Database Information</h2>");
            DatabaseMetaData meta = conn.getMetaData();
            out.println("<table>");
            out.println("<tr><th>Property</th><th>Value</th></tr>");
            out.println("<tr><td>Database Product</td><td>" + meta.getDatabaseProductName() + "</td></tr>");
            out.println("<tr><td>Database Version</td><td>" + meta.getDatabaseProductVersion() + "</td></tr>");
            out.println("<tr><td>Driver Name</td><td>" + meta.getDriverName() + "</td></tr>");
            out.println("<tr><td>Driver Version</td><td>" + meta.getDriverVersion() + "</td></tr>");
            out.println("<tr><td>URL</td><td>" + meta.getURL() + "</td></tr>");
            out.println("<tr><td>Username</td><td>" + meta.getUserName() + "</td></tr>");
            out.println("</table>");
            
            out.println("<h2>Step 3: Checking Tables</h2>");
            ResultSet tables = meta.getTables(null, null, "%", new String[]{"TABLE"});
            out.println("<table>");
            out.println("<tr><th>Table Name</th></tr>");
            boolean hasTables = false;
            while (tables.next()) {
                hasTables = true;
                String tableName = tables.getString("TABLE_NAME");
                out.println("<tr><td>" + tableName + "</td></tr>");
            }
            if (!hasTables) {
                out.println("<tr><td class='error'>No tables found! Run database_schema_postgresql.sql</td></tr>");
            }
            out.println("</table>");
            
            if (hasTables) {
                out.println("<p class='success'>✅ Database is properly set up!</p>");
            } else {
                out.println("<p class='error'>⚠️ Database exists but tables are missing.</p>");
                out.println("<p>Run: <code>psql -U postgres -d ecommerce -f database_schema_postgresql.sql</code></p>");
            }
            
        } catch (Exception e) {
            out.println("<p class='error'>❌ Error: " + e.getMessage() + "</p>");
            out.println("<pre>");
            e.printStackTrace(new PrintWriter(out));
            out.println("</pre>");
        } finally {
            if (conn != null) {
                try {
                    conn.close();
                    out.println("<p>Connection closed.</p>");
                } catch (Exception e) {
                    out.println("<p class='error'>Error closing connection: " + e.getMessage() + "</p>");
                }
            }
        }
        
        out.println("<hr>");
        out.println("<p><a href='index.jsp'>← Back to Home</a></p>");
        out.println("</body></html>");
    }
}
