# Port 8080 Already in Use - FIXED

## Problem
Port 8080 is already being used by another process (PID: 23244), preventing Jetty from starting.

## Solution Applied
Changed Jetty port from **8080** to **8081** in `pom.xml`.

## New Port Configuration
- **Old Port**: 8080 (already in use)
- **New Port**: 8081 (available)

## How to Access Application Now

After starting the server, use these URLs:

1. **Database Test**: http://localhost:8081/db-test
2. **Home Page**: http://localhost:8081/
3. **Admin Login**: http://localhost:8081/login.jsp
4. **Health Check**: http://localhost:8081/health

## Alternative Solutions

### Option 1: Stop the Process Using Port 8080

If you want to use port 8080, stop the process first:

```powershell
# Find what's using port 8080
netstat -ano | findstr :8080

# Stop the process (replace PID with actual process ID)
taskkill /PID 23244 /F

# Then change port back to 8080 in pom.xml
```

### Option 2: Use Different Port (Already Applied)

Port changed to 8081 in `pom.xml`. Just restart the server.

### Option 3: Change Port Manually

Edit `pom.xml` and change the port number:
```xml
<httpConnector>
    <port>8082</port>  <!-- Use any available port -->
</httpConnector>
```

## Start the Server

```powershell
mvn jetty:run
```

The server will now start on port **8081**.

## Verify Port is Available

Check if port 8081 is available:
```powershell
netstat -ano | findstr :8081
```

If nothing is returned, the port is free to use.

---

**Status**: ✅ Port changed to 8081. Restart the server and use the new URLs above.
