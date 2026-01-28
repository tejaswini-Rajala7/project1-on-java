# Easiest Way to Fix Product Images

## Quick Solution (Choose One)

---

## Method 1: Command Line (If PostgreSQL is Installed) ⚡ FASTEST

**Steps:**

1. **Open Command Prompt or PowerShell**

2. **Type these commands one by one:**

```bash
cd "C:\Users\harsh\OneDrive\Desktop\protax\EcommerceProject"
```

```bash
psql -U postgres -d ecommerce -f update_product_images.sql
```

3. **Enter your PostgreSQL password** when prompted

4. **Done!** You should see messages like:
   ```
   UPDATE 1
   UPDATE 1
   ...
   ```

5. **Restart your server and clear browser cache** (see Step 3 below)

---

## Method 2: Download DBeaver (Visual Tool) 🎯 EASIEST

**If Method 1 doesn't work, use this:**

### Step 1: Download DBeaver
1. Go to: https://dbeaver.io/download/
2. Click "Windows Installer" (Community Edition - FREE)
3. Download and install (just click Next, Next, Install)

### Step 2: Connect to Database
1. Open DBeaver
2. Click the "New Database Connection" button (plug icon at top)
3. Select "PostgreSQL" → Next
4. Fill in:
   ```
   Host: localhost
   Port: 5432
   Database: ecommerce
   Username: postgres
   Password: [enter your PostgreSQL password]
   ```
5. Click "Test Connection"
6. If it says "Connected" → Click "Finish"

### Step 3: Run SQL Script
1. In DBeaver, find your database on the left: "Databases" → "ecommerce"
2. Right-click on "ecommerce" → "SQL Editor" → "New SQL Script"
3. Go to: File → Open File
4. Navigate to: `C:\Users\harsh\OneDrive\Desktop\protax\EcommerceProject\update_product_images.sql`
5. Click "Open"
6. Click the "Execute SQL Script" button (or press `Ctrl + Enter`)
7. You should see UPDATE messages

### Step 4: Done!
- Close DBeaver
- Restart your server and clear browser cache (see Step 3 below)

---

## Method 3: Copy-Paste SQL (Works with Any Tool)

**If you have ANY database tool (even online), use this:**

1. **Open your database tool** (DBeaver, pgAdmin, online tool, etc.)

2. **Connect to your database:**
   - Database: `ecommerce`
   - Host: `localhost`
   - Port: `5432`
   - Username: `postgres`
   - Password: [your password]

3. **Open a SQL query window**

4. **Copy and paste this entire SQL:**

```sql
UPDATE products 
SET image_url = 'https://images.unsplash.com/photo-1511707171634-5f897ff02aa9?w=400&h=400&fit=crop'
WHERE name = 'Smartphone' AND (image_url LIKE 'assets/%' OR image_url IS NULL);

UPDATE products 
SET image_url = 'https://images.unsplash.com/photo-1590658268037-6bf12165a8df?w=400&h=400&fit=crop'
WHERE name = 'Wireless Earbuds' AND (image_url LIKE 'assets/%' OR image_url IS NULL);

UPDATE products 
SET image_url = 'https://images.unsplash.com/photo-1496181133206-80ce9b88a853?w=400&h=400&fit=crop'
WHERE name = 'Laptop' AND (image_url LIKE 'assets/%' OR image_url IS NULL);

UPDATE products 
SET image_url = 'https://images.unsplash.com/photo-1521572163474-6864f9cf17ab?w=400&h=400&fit=crop'
WHERE name = 'Men T-Shirt' AND (image_url LIKE 'assets/%' OR image_url IS NULL);

UPDATE products 
SET image_url = 'https://images.unsplash.com/photo-1542291026-7eec264c27ff?w=400&h=400&fit=crop'
WHERE name = 'Running Shoes' AND (image_url LIKE 'assets/%' OR image_url IS NULL);

UPDATE products 
SET image_url = 'https://images.unsplash.com/photo-1556911220-bff31c812dba?w=400&h=400&fit=crop'
WHERE name = 'Pressure Cooker' AND (image_url LIKE 'assets/%' OR image_url IS NULL);

UPDATE products 
SET image_url = 'https://images.unsplash.com/photo-1544947950-fa07a98d237f?w=400&h=400&fit=crop'
WHERE name = 'Novel Book' AND (image_url LIKE 'assets/%' OR image_url IS NULL);

UPDATE products 
SET image_url = 'https://images.unsplash.com/photo-1612872087720-bb876e2e67d1?w=400&h=400&fit=crop'
WHERE name = 'Cricket Bat' AND (image_url LIKE 'assets/%' OR image_url IS NULL);

UPDATE products 
SET image_url = 'https://images.unsplash.com/photo-1560472354-b33ff0c44a43?w=400&h=400&fit=crop'
WHERE image_url LIKE 'assets/%' OR (image_url IS NULL OR image_url = '');
```

5. **Execute/Run the SQL**

6. **Done!**

---

## Step 3: After Updating Database

### 1. Start Your Server

Open a new terminal/command prompt:

```bash
cd "C:\Users\harsh\OneDrive\Desktop\protax\EcommerceProject"
mvn jetty:run -Djetty.port=8081
```

Wait for: "Started Jetty Server"

### 2. Clear Browser Cache

**IMPORTANT!** You must clear cache or images won't show!

- Press `Ctrl + Shift + R` (hard refresh)
- OR `Ctrl + Shift + Delete` → Clear cached images

### 3. Test Website

Open: `http://localhost:8081/index.jsp`

**You should now see product images!** 🎉

---

## Which Method Should I Use?

| Method | When to Use |
|--------|-------------|
| **Method 1 (Command Line)** | ✅ If you have PostgreSQL installed and know your password |
| **Method 2 (DBeaver)** | ✅ If you prefer visual tools or Method 1 doesn't work |
| **Method 3 (Copy-Paste)** | ✅ If you already have any database tool |

**Recommendation:** Try Method 1 first. If it doesn't work, use Method 2 (DBeaver).

---

## Troubleshooting

### "psql: command not found"
→ Use Method 2 (DBeaver) instead

### "Password authentication failed"
→ Check your PostgreSQL password. It's the password you set when installing PostgreSQL.

### "Database does not exist"
→ Make sure your database is named `ecommerce`. Check in your database tool.

### "Connection refused"
→ Make sure PostgreSQL is running:
  - Windows: Check Services → PostgreSQL should be running
  - Or restart PostgreSQL service

---

## Summary

1. **Update database** (choose Method 1, 2, or 3 above)
2. **Start server** (`mvn jetty:run -Djetty.port=8081`)
3. **Clear browser cache** (`Ctrl + Shift + R`)
4. **Test website** (`http://localhost:8081/index.jsp`)

**That's it!** 🚀
