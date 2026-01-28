# Fixed: HTTP 503 Service Unavailable Error

## ✅ What Was Fixed:

1. **Removed Tomcat Dependencies** - Removed `tomcat-embed-jasper` and `tomcat-embed-core` which were conflicting with Jetty
2. **Removed JSP Servlet Configuration** - Removed explicit JSP servlet config from web.xml (Jetty handles JSP automatically)
3. **Added Jetty JSP Support** - Added `apache-jsp` dependency to Jetty plugin for JSP processing
4. **Fixed web.xml Path** - Explicitly configured web.xml path in Jetty plugin

## 🔄 Server Status:

The server should now start successfully. Check the terminal logs for:
- `[INFO] Started ServerConnector@...{HTTP/1.1, (http/1.1)}{0.0.0.0:8081}`
- `[INFO] Started Server@...{STARTING}[11.0.20,sto=0]`
- Status should show `AVAILABLE` instead of `UNAVAILABLE`

## 🌐 Test the Application:

1. **Wait 10-15 seconds** for server to fully start
2. Visit: **http://localhost:8081/**
3. You should see the Protax Store homepage

## If Still Getting 503:

1. Check server logs in terminal for any errors
2. Verify database is running: `Get-Service postgresql*`
3. Test database connection: http://localhost:8081/db-test
4. Try accessing directly: http://localhost:8081/index.jsp

## Key Changes Made:

- **pom.xml**: Removed Tomcat dependencies, added Jetty JSP support
- **web.xml**: Removed explicit JSP servlet configuration
- **Jetty Plugin**: Added explicit web.xml path and JSP dependency

The application should now work properly! 🎉
