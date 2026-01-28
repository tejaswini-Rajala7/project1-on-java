import os
from typing import List, Dict, Any, Optional

import streamlit as st
import psycopg2
from psycopg2.extras import RealDictCursor
from psycopg2 import Error


# -----------------------------------------------------------------------------
# DB CONFIG
# -----------------------------------------------------------------------------

DB_HOST = os.getenv("ECOM_DB_HOST", "localhost")
DB_PORT = int(os.getenv("ECOM_DB_PORT", "5432"))  # PostgreSQL default port
DB_NAME = os.getenv("ECOM_DB_NAME", "ecommerce")
DB_USER = os.getenv("ECOM_DB_USER", "postgres")
DB_PASSWORD = os.getenv("ECOM_DB_PASSWORD", "postgres")  # CHANGE in production


def get_connection():
    try:
        conn = psycopg2.connect(
            host=DB_HOST,
            port=DB_PORT,
            database=DB_NAME,
            user=DB_USER,
            password=DB_PASSWORD,
        )
        return conn
    except Error as e:
        st.error(f"Database connection error: {e}")
        return None


# -----------------------------------------------------------------------------
# DB HELPERS
# -----------------------------------------------------------------------------

def fetch_one(query: str, params: tuple = ()) -> Optional[dict]:
    conn = get_connection()
    if not conn:
        return None
    try:
        cur = conn.cursor(cursor_factory=RealDictCursor)
        cur.execute(query, params)
        row = cur.fetchone()
        return dict(row) if row else None
    finally:
        cur.close()
        conn.close()


def fetch_all(query: str, params: tuple = ()) -> List[dict]:
    conn = get_connection()
    if not conn:
        return []
    try:
        cur = conn.cursor(cursor_factory=RealDictCursor)
        cur.execute(query, params)
        rows = cur.fetchall()
        return [dict(row) for row in rows]
    finally:
        cur.close()
        conn.close()


def execute(query: str, params: tuple = ()) -> int:
    """
    Execute INSERT/UPDATE/DELETE.
    Returns lastrowid if available, otherwise affected rows.
    """
    conn = get_connection()
    if not conn:
        return -1
    try:
        cur = conn.cursor()
        cur.execute(query, params)
        conn.commit()
        # For PostgreSQL, use RETURNING clause or fetch lastval()
        if "RETURNING" in query.upper():
            result = cur.fetchone()
            return result[0] if result else cur.rowcount
        else:
            return cur.rowcount
    finally:
        cur.close()
        conn.close()


# -----------------------------------------------------------------------------
# AUTH HELPERS
# -----------------------------------------------------------------------------

def register_user(name: str, email: str, password: str) -> bool:
    existing = fetch_one("SELECT id FROM users WHERE email=%s", (email,))
    if existing:
        st.warning("Email already registered.")
        return False
    q = "INSERT INTO users(name,email,password,role) VALUES(%s,%s,%s,'customer') RETURNING id"
    result = execute(q, (name, email, password))
    return result > 0


def validate_user(email: str, password: str) -> Optional[dict]:
    # NOTE: password is plain-text to match your existing Java project.
    q = "SELECT * FROM users WHERE email=%s AND password=%s"
    return fetch_one(q, (email, password))


# -----------------------------------------------------------------------------
# PRODUCT & CART HELPERS
# -----------------------------------------------------------------------------

def get_categories() -> List[dict]:
    return fetch_all("SELECT * FROM categories ORDER BY name")


def get_products(category_id: Optional[int] = None, search: str = "") -> List[dict]:
    base = (
        "SELECT p.*, c.name AS category_name "
        "FROM products p LEFT JOIN categories c ON p.category_id=c.id "
        "WHERE 1=1 "
    )
    params = []
    if category_id:
        base += "AND p.category_id = %s "
        params.append(category_id)
    if search:
        like = f"%{search}%"
        base += "AND (p.name LIKE %s OR p.description LIKE %s OR p.brand LIKE %s) "
        params.extend([like, like, like])
    base += "ORDER BY p.id DESC"
    return fetch_all(base, tuple(params))


def get_product(product_id: int) -> Optional[dict]:
    return fetch_one(
        "SELECT p.*, c.name AS category_name "
        "FROM products p LEFT JOIN categories c ON p.category_id=c.id "
        "WHERE p.id=%s",
        (product_id,),
    )


def get_user_addresses(user_id: int) -> List[dict]:
    return fetch_all(
        "SELECT * FROM addresses WHERE user_id=%s ORDER BY is_default DESC, id DESC",
        (user_id,),
    )


def add_address(user_id: int, data: dict) -> bool:
    if data.get("is_default"):
        # unset other defaults
        execute("UPDATE addresses SET is_default=false WHERE user_id=%s", (user_id,))
    q = (
        "INSERT INTO addresses(user_id, full_name, phone, address_line1, address_line2, "
        "city, state, pincode, is_default) VALUES(%s,%s,%s,%s,%s,%s,%s,%s,%s)"
    )
    execute(
        q,
        (
            user_id,
            data["full_name"],
            data["phone"],
            data["address_line1"],
            data.get("address_line2", ""),
            data["city"],
            data["state"],
            data["pincode"],
            bool(data.get("is_default", False)),
        ),
    )
    return True


def create_order(user_id: int, address_id: int, total_amount: float, payment_method: str) -> int:
    q = (
        "INSERT INTO orders(user_id, address_id, total_amount, status, payment_method, payment_status) "
        "VALUES(%s,%s,%s,'confirmed',%s,'paid') RETURNING id"
    )
    return execute(q, (user_id, address_id, total_amount, payment_method))


def add_order_item(order_id: int, product_id: int, quantity: int, price: float):
    q = "INSERT INTO order_items(order_id, product_id, quantity, price) VALUES(%s,%s,%s,%s)"
    execute(q, (order_id, product_id, quantity, price))


def get_orders_by_user(user_id: int) -> List[dict]:
    return fetch_all(
        "SELECT o.*, "
        "(a.address_line1 || ', ' || a.city || ', ' || a.state || ' - ' || a.pincode) AS address_details "
        "FROM orders o JOIN addresses a ON o.address_id=a.id "
        "WHERE o.user_id=%s ORDER BY o.order_date DESC",
        (user_id,),
    )


def get_order_items(order_id: int) -> List[dict]:
    return fetch_all(
        "SELECT oi.*, p.name AS product_name, p.image_url AS product_image "
        "FROM order_items oi JOIN products p ON oi.product_id=p.id "
        "WHERE oi.order_id=%s",
        (order_id,),
    )


# -----------------------------------------------------------------------------
# STREAMLIT STATE HELPERS
# -----------------------------------------------------------------------------

def init_session():
    if "user" not in st.session_state:
        st.session_state.user = None
    if "cart" not in st.session_state:
        st.session_state.cart = []  # list of {product_id, name, price, qty}


def add_to_cart(product: dict, qty: int = 1):
    cart: List[Dict[str, Any]] = st.session_state.cart
    for item in cart:
        if item["product_id"] == product["id"]:
            item["qty"] += qty
            break
    else:
        cart.append(
            {
                "product_id": product["id"],
                "name": product["name"],
                "price": float(product["price"]),
                "qty": qty,
            }
        )


def update_cart_qty(product_id: int, qty: int):
    cart: List[Dict[str, Any]] = st.session_state.cart
    for item in cart:
        if item["product_id"] == product_id:
            item["qty"] = max(1, qty)
            break


def remove_from_cart(product_id: int):
    cart: List[Dict[str, Any]] = st.session_state.cart
    st.session_state.cart = [c for c in cart if c["product_id"] != product_id]


def cart_total() -> float:
    return sum(item["price"] * item["qty"] for item in st.session_state.cart)


# -----------------------------------------------------------------------------
# UI SECTIONS
# -----------------------------------------------------------------------------

def ui_auth():
    st.subheader("Login / Register")
    tab_login, tab_register = st.tabs(["Login", "Register"])

    with tab_login:
        email = st.text_input("Email", key="login_email")
        password = st.text_input("Password", type="password", key="login_password")
        if st.button("Login", type="primary"):
            user = validate_user(email, password)
            if user:
                st.session_state.user = {
                    "id": user["id"],
                    "name": user["name"],
                    "email": user["email"],
                    "role": user.get("role", "customer"),
                }
                st.success(f"Welcome, {user['name']}!")
                st.rerun()
            else:
                st.error("Invalid email or password.")

    with tab_register:
        name = st.text_input("Full name", key="reg_name")
        email_r = st.text_input("Email", key="reg_email")
        pwd_r = st.text_input("Password", type="password", key="reg_pwd")
        if st.button("Create Account"):
            if not name or not email_r or not pwd_r:
                st.warning("All fields are required.")
            else:
                if register_user(name, email_r, pwd_r):
                    st.success("Registration successful. You can now log in.")


def ui_home():
    st.title("🛒 Protax Store (Streamlit UI)")
    st.write("A modern front-end for your e-commerce backend using Streamlit.")

    col1, col2 = st.columns(2)
    with col1:
        st.header("Browse Products")
        st.write("Explore our catalog of electronics, clothing, books and more.")
    with col2:
        st.header("Fast & Secure")
        st.write("Orders, cart, and user accounts powered by your MySQL backend.")


def ui_shop():
    st.title("🛍️ Shop")

    categories = get_categories()
    cat_names = ["All"] + [c["name"] for c in categories]
    cat_choice = st.selectbox("Category", cat_names)
    category_id = None
    if cat_choice != "All":
        for c in categories:
            if c["name"] == cat_choice:
                category_id = c["id"]
                break

    search = st.text_input("Search products")
    products = get_products(category_id, search)

    if not products:
        st.info("No products found.")
        return

    for p in products:
        cols = st.columns([2, 5, 2])
        with cols[0]:
            st.image(
                p.get("image_url") or "https://via.placeholder.com/200",
                width=120,
            )
        with cols[1]:
            st.subheader(p["name"])
            st.caption(p.get("category_name") or "")
            st.write(p.get("description") or "")
            stock = p.get("stock", 0)
            if stock > 0:
                st.success(f"In stock ({stock})")
            else:
                st.error("Out of stock")
        with cols[2]:
            st.markdown(f"**₹ {float(p['price']):.2f}**")
            if p.get("rating") is not None:
                st.write(f"⭐ {float(p['rating']):.1f}")
            if stock > 0:
                qty = st.number_input(
                    f"Qty_{p['id']}", min_value=1, max_value=min(10, stock), value=1, step=1
                )
                if st.button("Add to cart", key=f"add_{p['id']}"):
                    add_to_cart(p, qty)
                    st.success("Added to cart.")


def ui_cart():
    st.title("🧺 Cart")
    cart = st.session_state.cart
    if not cart:
        st.info("Your cart is empty.")
        return

    for item in cart:
        cols = st.columns([4, 2, 2])
        with cols[0]:
            st.write(item["name"])
        with cols[1]:
            new_qty = st.number_input(
                f"Qty_{item['product_id']}",
                min_value=1,
                max_value=50,
                value=item["qty"],
                step=1,
            )
            if new_qty != item["qty"]:
                update_cart_qty(item["product_id"], new_qty)
        with cols[2]:
            st.write(f"₹ {item['price'] * item['qty']:.2f}")
            if st.button("Remove", key=f"rm_{item['product_id']}"):
                remove_from_cart(item["product_id"])
                st.rerun()

    st.markdown("---")
    st.subheader(f"Total: ₹ {cart_total():.2f}")

    if st.session_state.user:
        if st.button("Proceed to checkout", type="primary"):
            st.session_state.page = "Checkout"
            st.rerun()
    else:
        st.warning("Please login to checkout.")


def ui_checkout():
    st.title("✅ Checkout")
    user = st.session_state.user
    if not user:
        st.warning("Please login to continue.")
        return

    cart = st.session_state.cart
    if not cart:
        st.info("Your cart is empty.")
        return

    addresses = get_user_addresses(user["id"])

    col_left, col_right = st.columns([3, 2])
    with col_left:
        st.subheader("Delivery Address")
        if not addresses:
            st.info("No address found. Add one below.")
        else:
            labels = [
                f"{a['full_name']} - {a['address_line1']}, {a['city']} ({a['pincode']})"
                for a in addresses
            ]
            idx = st.selectbox("Choose address", range(len(addresses)), format_func=lambda i: labels[i])
            selected_address = addresses[idx]
        with st.expander("Add / Edit Address"):
            with st.form("add_address_form"):
                full_name = st.text_input("Full name")
                phone = st.text_input("Phone")
                addr1 = st.text_input("Address line 1")
                addr2 = st.text_input("Address line 2")
                city = st.text_input("City")
                state = st.text_input("State")
                pincode = st.text_input("Pincode")
                is_default = st.checkbox("Set as default")
                submitted = st.form_submit_button("Save address")
                if submitted:
                    if not (full_name and phone and addr1 and city and state and pincode):
                        st.warning("All mandatory fields must be filled.")
                    else:
                        add_address(
                            user["id"],
                            {
                                "full_name": full_name,
                                "phone": phone,
                                "address_line1": addr1,
                                "address_line2": addr2,
                                "city": city,
                                "state": state,
                                "pincode": pincode,
                                "is_default": is_default,
                            },
                        )
                        st.success("Address saved.")
                        st.rerun()

    with col_right:
        st.subheader("Order Summary")
        total = cart_total()
        shipping = 50.0 if total > 0 else 0.0
        st.write(f"Subtotal: ₹ {total:.2f}")
        st.write(f"Shipping: ₹ {shipping:.2f}")
        st.markdown("---")
        st.write(f"**Total: ₹ {total + shipping:.2f}**")
        payment_method = st.selectbox(
            "Payment method", ["Cash on Delivery", "Credit Card", "UPI"]
        )
        can_place = bool(addresses)
        if not addresses:
            st.warning("Add an address before placing the order.")
        if st.button("Place order", type="primary", disabled=not can_place):
            addr_id = addresses[idx]["id"]
            order_id = create_order(user["id"], addr_id, total + shipping, payment_method)
            for item in cart:
                add_order_item(order_id, item["product_id"], item["qty"], item["price"])
            st.session_state.cart = []
            st.success(f"Order placed successfully! Order ID: #{order_id}")
            st.session_state.page = "Orders"
            st.rerun()


def ui_orders():
    st.title("📦 My Orders")
    user = st.session_state.user
    if not user:
        st.warning("Please login to view your orders.")
        return
    orders = get_orders_by_user(user["id"])
    if not orders:
        st.info("You have no orders yet.")
        return

    for o in orders:
        with st.expander(f"Order #{o['id']} - ₹ {o['total_amount']:.2f}"):
            st.write(f"Status: **{o['status']}**")
            st.write(f"Payment: **{o['payment_status']}** via {o['payment_method']}")
            st.write(f"Address: {o['address_details']}")
            items = get_order_items(o["id"])
            for it in items:
                cols = st.columns([4, 2, 2])
                with cols[0]:
                    st.write(it["product_name"])
                with cols[1]:
                    st.write(f"Qty: {it['quantity']}")
                with cols[2]:
                    st.write(f"₹ {it['price'] * it['quantity']:.2f}")


def ui_admin():
    user = st.session_state.user
    if not user or user.get("role") != "admin":
        st.warning("Admin access only.")
        return

    st.title("🛠️ Admin Panel")
    tab_prod, tab_orders = st.tabs(["Products", "Orders"])

    with tab_prod:
        st.subheader("Products")
        products = get_products()
        for p in products:
            cols = st.columns([4, 2, 2])
            with cols[0]:
                st.write(f"#{p['id']} - {p['name']}")
            with cols[1]:
                st.write(f"₹ {float(p['price']):.2f}")
            with cols[2]:
                st.write(f"Stock: {p.get('stock', 0)}")
        st.info("For full CRUD, continue using the Java admin JSP panel. This Streamlit admin is read-only.")

    with tab_orders:
        st.subheader("Recent Orders")
        orders = fetch_all(
            "SELECT o.*, u.name AS user_name "
            "FROM orders o JOIN users u ON o.user_id=u.id "
            "ORDER BY o.order_date DESC LIMIT 20"
        )
        for o in orders:
            st.write(
                f"Order #{o['id']} | {o['user_name']} | ₹ {o['total_amount']:.2f} | "
                f"Status: {o['status']} | Payment: {o['payment_status']}"
            )


# -----------------------------------------------------------------------------
# MAIN
# -----------------------------------------------------------------------------

def main():
    st.set_page_config(page_title="Protax Store", page_icon="🛒", layout="wide")
    init_session()

    # Sidebar navigation
    with st.sidebar:
        st.title("Protax Store")
        if st.session_state.user:
            st.write(f"Logged in as **{st.session_state.user['name']}**")
            if st.button("Logout"):
                st.session_state.user = None
                st.session_state.cart = []
                st.rerun()
        else:
            st.write("Not logged in")

        page = st.radio(
            "Navigate",
            ["Home", "Shop", "Cart", "Checkout", "Orders", "Admin"],
            key="nav",
        )
        st.session_state.page = page

    # Auth section for anonymous users on Home
    if not st.session_state.user and st.session_state.page in ["Home", "Cart", "Checkout", "Orders"]:
        ui_auth()
        st.markdown("---")

    # Page router
    page = st.session_state.page
    if page == "Home":
        ui_home()
    elif page == "Shop":
        ui_shop()
    elif page == "Cart":
        ui_cart()
    elif page == "Checkout":
        ui_checkout()
    elif page == "Orders":
        ui_orders()
    elif page == "Admin":
        ui_admin()


if __name__ == "__main__":
    main()

