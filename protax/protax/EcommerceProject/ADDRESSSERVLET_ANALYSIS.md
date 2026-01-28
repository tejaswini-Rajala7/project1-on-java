# 📍 AddressServlet.java - Usage & Impact Analysis

## ✅ **YES, This File is ACTIVELY USED in the Project**

### **File Details:**
- **Location**: `src/controller/AddressServlet.java`
- **URL Mapping**: `/address`
- **Purpose**: Manages user delivery addresses (CRUD operations)

---

## 🎯 **What This File Does:**

### **1. GET Request (`doGet` method)**
- **URL**: `GET /address`
- **Function**: Displays user's saved addresses
- **Action**: 
  - Checks if user is logged in
  - Retrieves all addresses for the logged-in user
  - Forwards to `addresses.jsp` to display them

### **2. POST Request (`doPost` method)**
- **URL**: `POST /address`
- **Functions**:
  - **Add Address** (`action=add`): Saves new delivery address
  - **Delete Address** (`action=delete`): Removes an address

---

## 🔗 **Where It's Used in the Project:**

### **1. Navigation Menu** (`WebContent/includes/header.jsp`)
```jsp
<li><a class="dropdown-item" href="<%=contextPath%>/address">
    <i class="fas fa-map-marker-alt"></i> Addresses
</a></li>
```
**Impact**: Users can access address management from any page via the user dropdown menu

---

### **2. Checkout Page** (`WebContent/checkout.jsp`)
**Multiple references:**

**a) When no addresses exist:**
```jsp
<% if (addresses == null || addresses.isEmpty()) { %>
    <div class="alert alert-warning">
        <p>No address found. Please add an address first.</p>
        <a href="address" class="btn btn-primary">Add Address</a>
    </div>
<% } %>
```

**b) Link to add new address:**
```jsp
<a href="address" class="btn btn-outline-primary">
    <i class="fas fa-plus"></i> Add New Address
</a>
```

**c) Displays addresses for selection:**
```jsp
<% for (Address addr : addresses) { %>
    <input type="radio" name="addressId" value="<%=addr.getId()%>">
    <!-- Address details displayed -->
<% } %>
```

**Impact**: 
- ✅ **CRITICAL** - Users cannot place orders without addresses
- ✅ Checkout page loads addresses via `CheckoutServlet` which calls `AddressDAO`
- ✅ Users can add new addresses directly from checkout

---

### **3. Address Management Page** (`WebContent/addresses.jsp`)
**Complete dependency:**

**a) Displays addresses:**
```jsp
List<Address> addresses = (List<Address>) request.getAttribute("addresses");
```

**b) Form to add address:**
```jsp
<form action="address" method="post">
    <input type="hidden" name="action" value="add">
    <!-- Address form fields -->
</form>
```

**c) Form to delete address:**
```jsp
<form action="address" method="post">
    <input type="hidden" name="action" value="delete">
    <input type="hidden" name="addressId" value="<%=addr.getId()%>">
</form>
```

**Impact**: This entire page depends on `AddressServlet` to function

---

### **4. Order Processing** (`src/controller/OrderServlet.java`)
**Indirect dependency:**
```java
// Get address
int addressId = Integer.parseInt(req.getParameter("addressId"));
Address address = AddressDAO.getAddressById(addressId);
if (address == null || address.getUserId() != userId) {
    res.sendRedirect("checkout.jsp?error=address");
    return;
}
// Uses addressId to create order
int orderId = OrderDAO.createOrder(userId, addressId, total, paymentMethod);
```

**Impact**: 
- ✅ Orders **REQUIRE** an address ID
- ✅ Users must have addresses (managed by AddressServlet) to place orders

---

## ⚠️ **Impact if This File is Removed:**

### **❌ Critical Issues:**

1. **Checkout Process Breaks**
   - Users cannot add new addresses from checkout page
   - "Add Address" button would return 404 error
   - Users stuck if they have no addresses

2. **Address Management Unavailable**
   - `/address` URL would return 404
   - Users cannot view their saved addresses
   - Users cannot delete old addresses
   - Navigation menu link would be broken

3. **Order Placement Blocked**
   - Users need addresses to place orders
   - Without ability to add addresses, checkout becomes impossible
   - Entire e-commerce flow breaks

4. **User Experience Degraded**
   - No way to manage delivery addresses
   - Users must manually enter address every time
   - No address history or saved addresses

---

## ✅ **Current Functionality Provided:**

| Feature | Status | Impact |
|---------|--------|--------|
| View saved addresses | ✅ Working | Users can see all their addresses |
| Add new address | ✅ Working | Users can save delivery addresses |
| Delete address | ✅ Working | Users can remove old addresses |
| Set default address | ✅ Working | Users can mark preferred address |
| Address selection in checkout | ✅ Working | Users can choose delivery address |
| Navigation menu link | ✅ Working | Easy access from any page |

---

## 🔄 **Data Flow:**

```
User clicks "Addresses" in menu
    ↓
GET /address
    ↓
AddressServlet.doGet()
    ↓
AddressDAO.getAddressesByUser(userId)
    ↓
Query: SELECT * FROM addresses WHERE user_id = ?
    ↓
Returns List<Address>
    ↓
Sets: req.setAttribute("addresses", list)
    ↓
Forwards to: addresses.jsp
    ↓
User sees address management page
```

---

## 📊 **Dependencies:**

### **AddressServlet Depends On:**
- ✅ `AddressDAO.java` - Database operations
- ✅ `Address.java` - Data model
- ✅ `addresses.jsp` - Frontend page

### **Other Files Depend On AddressServlet:**
- ✅ `header.jsp` - Navigation link
- ✅ `checkout.jsp` - Add address links
- ✅ `addresses.jsp` - Complete functionality
- ✅ `OrderServlet.java` - Indirect (needs addresses to exist)

---

## 🎯 **Conclusion:**

### **Status: ✅ ESSENTIAL FILE**

**Impact Level: 🔴 CRITICAL**

**Reason:**
1. **Required for checkout** - Users need addresses to place orders
2. **Core feature** - Address management is fundamental to e-commerce
3. **Multiple dependencies** - Used in navigation, checkout, and order processing
4. **User experience** - Without it, users cannot manage delivery addresses

### **Recommendation:**
**DO NOT REMOVE** - This file is essential for the e-commerce platform to function properly. Removing it would break:
- ❌ Address management
- ❌ Checkout process
- ❌ Order placement
- ❌ User navigation

---

## 🔧 **If You Need to Modify:**

The file is well-structured and follows the MVC pattern:
- ✅ Proper session validation
- ✅ Clean separation of concerns
- ✅ Error handling
- ✅ Redirects for success/error states

**Safe to modify for:**
- Adding new address fields
- Adding update/edit functionality
- Adding address validation
- Adding address search/filtering
