CREATE TABLE Users (
    user_id SERIAL PRIMARY KEY,
    username VARCHAR(50) UNIQUE NOT NULL,
    email VARCHAR(100) UNIQUE NOT NULL,
    password_hash VARCHAR(255) NOT NULL,
    first_name VARCHAR(50),
    last_name VARCHAR(50),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    role VARCHAR(20) CHECK (role IN ('admin', 'seller', 'buyer'))
);

CREATE TABLE Categories (
    category_id SERIAL PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    description TEXT,
    parent_id INT REFERENCES Categories(category_id)
);

CREATE TABLE Products (
    product_id SERIAL PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    description TEXT,
    price DECIMAL(10, 2) NOT NULL,
    stock_quantity INT NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    category_id INT REFERENCES Categories(category_id),
    seller_id INT REFERENCES Users(user_id)
);

CREATE TABLE Addresses (
    address_id SERIAL PRIMARY KEY,
    user_id INT REFERENCES Users(user_id),
    street VARCHAR(255),
    city VARCHAR(100),
    state VARCHAR(100),
    zip_code VARCHAR(20),
    country VARCHAR(100)
);

CREATE TABLE Orders (
    order_id SERIAL PRIMARY KEY,
    user_id INT REFERENCES Users(user_id),
    order_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    total_amount DECIMAL(10, 2) NOT NULL,
    status VARCHAR(20) CHECK (status IN ('pending', 'completed', 'canceled')),
    shipping_address_id INT REFERENCES Addresses(address_id)
);

CREATE TABLE OrderItems (
    order_item_id SERIAL PRIMARY KEY,
    order_id INT REFERENCES Orders(order_id),
    product_id INT REFERENCES Products(product_id),
    quantity INT NOT NULL,
    price DECIMAL(10, 2) NOT NULL
);

CREATE TABLE Reviews (
    review_id SERIAL PRIMARY KEY,
    product_id INT REFERENCES Products(product_id),
    user_id INT REFERENCES Users(user_id),
    rating INT CHECK (rating BETWEEN 1 AND 5),
    comment TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);


CREATE TABLE Payments (
    payment_id SERIAL PRIMARY KEY,
    order_id INT REFERENCES Orders(order_id),
    payment_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    amount DECIMAL(10, 2) NOT NULL,
    payment_method VARCHAR(50),
    status VARCHAR(20) CHECK (status IN ('pending', 'completed', 'failed'))
);

CREATE TABLE ShoppingCart (
    cart_id SERIAL PRIMARY KEY,
    user_id INT REFERENCES Users(user_id),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE CartItems (
    cart_item_id SERIAL PRIMARY KEY,
    cart_id INT REFERENCES ShoppingCart(cart_id),
    product_id INT REFERENCES Products(product_id),
    quantity INT NOT NULL
);

-- Indexes
CREATE INDEX idx_users_username ON Users(username);
CREATE INDEX idx_users_email ON Users(email);
CREATE INDEX idx_categories_name ON Categories(name);
CREATE INDEX idx_products_name ON Products(name);
CREATE INDEX idx_products_category ON Products(category_id);
CREATE INDEX idx_products_seller ON Products(seller_id);
CREATE INDEX idx_orders_user ON Orders(user_id);
CREATE INDEX idx_orders_status ON Orders(status);
CREATE INDEX idx_order_items_order ON OrderItems(order_id);
CREATE INDEX idx_order_items_product ON OrderItems(product_id);
CREATE INDEX idx_reviews_product ON Reviews(product_id);
CREATE INDEX idx_reviews_user ON Reviews(user_id);
CREATE INDEX idx_addresses_user ON Addresses(user_id);
CREATE INDEX idx_payments_order ON Payments(order_id);
CREATE INDEX idx_payments_status ON Payments(status);d
CREATE INDEX idx_shopping_cart_user ON ShoppingCart(user_id);
CREATE INDEX idx_cart_items_cart ON CartItems(cart_id);
CREATE INDEX idx_cart_items_product ON CartItems(product_id);


CREATE ROLE admin LOGIN PASSWORD 'admin_password' SUPERUSER;

GRANT ALL PRIVILEGES ON DATABASE ecom_db TO admin;

CREATE ROLE employee NOLOGIN;

GRANT ALL PRIVILEGES ON DATABASE ecom_db TO employee;
GRANT SELECT, INSERT, UPDATE, DELETE ON Users TO employee;
GRANT SELECT, INSERT, UPDATE, DELETE ON Products TO employee;
GRANT SELECT, INSERT, UPDATE, DELETE ON Orders TO employee;
GRANT SELECT, INSERT, UPDATE, DELETE ON OrderItems TO employee;
GRANT SELECT, INSERT, UPDATE, DELETE ON Reviews TO employee;
GRANT SELECT, INSERT, UPDATE, DELETE ON Addresses TO employee;
GRANT SELECT, INSERT, UPDATE, DELETE ON Payments TO employee;

CREATE ROLE customer NOLOGIN;
-- General access for all customers
GRANT SELECT ON Products TO customer;  -- View products
GRANT SELECT ON Reviews TO customer;  -- View reviews


CREATE ROLE buyer NOLOGIN;
-- Permissions for buyers
GRANT SELECT ON Products TO buyer;  -- View products
GRANT SELECT ON Reviews TO buyer;  -- View reviews
GRANT SELECT, INSERT ON Orders TO buyer;  -- Place orders
GRANT SELECT ON OrderItems TO buyer;  -- View their order details
-- Row level security on Orders
ALTER TABLE Orders ENABLE ROW LEVEL SECURITY;
CREATE POLICY buyer_order_policy ON Orders
FOR SELECT TO buyer USING (user_id = current_setting('my.current_user_id')::int);
ALTER TABLE Orders FORCE ROW LEVEL SECURITY;
-- Row level security on OrderItems
ALTER TABLE OrderItems ENABLE ROW LEVEL SECURITY;
CREATE POLICY buyer_order_items_policy ON OrderItems
FOR SELECT TO buyer USING (order_id IN (SELECT order_id FROM Orders WHERE user_id = current_setting('my.current_user_id')::int));
ALTER TABLE OrderItems FORCE ROW LEVEL SECURITY;

CREATE ROLE seller NOLOGIN;
-- Permissions for sellers
GRANT SELECT, INSERT ON Products TO seller;  -- View products
GRANT SELECT ON Reviews TO seller;  -- View reviews
GRANT SELECT, INSERT, UPDATE ON Orders TO seller;  -- View their orders
GRANT SELECT, INSERT, UPDATE, DELETE ON Products TO seller;  -- Manage their products
GRANT SELECT, INSERT, UPDATE ON OrderItems TO seller;  -- Manage their order items
GRANT SELECT ON Addresses TO seller;  -- View addresses

-- Create Seller Login Roles
CREATE ROLE seller_john LOGIN PASSWORD 'seller_password1' IN ROLE seller;
CREATE ROLE seller_jane LOGIN PASSWORD 'seller_password2' IN ROLE seller;
CREATE ROLE seller_alice LOGIN PASSWORD 'seller_password3' IN ROLE seller;
CREATE ROLE seller_bob LOGIN PASSWORD 'seller_password4' IN ROLE seller;
CREATE ROLE seller_charlie LOGIN PASSWORD 'seller_password5' IN ROLE seller;

-- Create Buyer Login Roles
CREATE ROLE buyer_mike LOGIN PASSWORD 'buyer_password1' IN ROLE buyer;
CREATE ROLE buyer_susan LOGIN PASSWORD 'buyer_password2' IN ROLE buyer;
CREATE ROLE buyer_tom LOGIN PASSWORD 'buyer_password3' IN ROLE buyer;
CREATE ROLE buyer_emily LOGIN PASSWORD 'buyer_password4' IN ROLE buyer;
CREATE ROLE buyer_nina LOGIN PASSWORD 'buyer_password5' IN ROLE buyer;

-- Create Employee Login Roles and assign them to the NOLOGIN role
CREATE ROLE employee_jack LOGIN PASSWORD 'employee_password1' IN ROLE employee;
CREATE ROLE employee_mary LOGIN PASSWORD 'employee_password2' IN ROLE employee;
CREATE ROLE employee_lisa LOGIN PASSWORD 'employee_password3' IN ROLE employee;
