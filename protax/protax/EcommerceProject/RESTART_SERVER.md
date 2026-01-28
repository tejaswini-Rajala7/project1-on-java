# Server Restart Instructions

## ✅ Fixed Issues:
1. Created `web.xml` configuration file
2. Added JSP support dependencies
3. Configured welcome files (index.jsp)

## 🔄 To Restart the Server:

### Option 1: Stop and Restart (Recommended)
1. **Stop the current server**: Press `Ctrl+C` in the terminal where Jetty is running
2. **Restart**: Run this command:
   ```bash
   cd c:\Users\harsh\OneDrive\Desktop\protax\EcommerceProject
   mvn jetty:run
   ```

### Option 2: Kill Process and Restart
1. **Kill Java process**:
   ```powershell
   taskkill /F /IM java.exe
   ```
2. **Restart**:
   ```bash
   cd c:\Users\harsh\OneDrive\Desktop\protax\EcommerceProject
   mvn jetty:run
   ```

## 🌐 After Restart:
Visit: **http://localhost:8081/**

You should now see the **Protax Store** homepage with:
- Beautiful header with navigation
- Welcome message
- Product browsing cards
- Footer

## ✅ What Was Fixed:
- ✅ Created `WebContent/WEB-INF/web.xml` with proper configuration
- ✅ Added JSP servlet support (Apache Jasper)
- ✅ Configured welcome files so `index.jsp` loads automatically
- ✅ Disabled directory listing for security
- ✅ Added proper MIME types for CSS, images, etc.

The website should now display properly with all frontend elements!
