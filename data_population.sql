INSERT INTO Users (username, email, password_hash, first_name, last_name, role)
VALUES 
('admin_user', 'admin@example.com', 'hashed_password', 'Admin', 'User', 'admin'),
('seller_john', 'john@example.com', 'hashed_password', 'John', 'Doe', 'seller'),
('buyer_mike', 'mike@example.com', 'hashed_password', 'Mike', 'Smith', 'buyer');

INSERT INTO Categories (name, description, parent_id)
VALUES 
('Electronics', 'Devices and gadgets', NULL),
('Clothing', 'Apparel and accessories', NULL),
('Home', 'Home and kitchen items', NULL);

INSERT INTO Products (name, description, price, stock_quantity, category_id, seller_id)
VALUES 
('Laptop', 'A high-performance laptop', 999.99, 10, 1, 2),
('T-shirt', 'Cotton t-shirt', 19.99, 50, 2, 2),
('Coffee Maker', 'Brew coffee at home', 49.99, 20, 3, 2);

INSERT INTO Addresses (user_id, street, city, state, zip_code, country)
VALUES 
(3, '123 Main St', 'New York', 'NY', '10001', 'USA'),
(2, '456 Market St', 'Los Angeles', 'CA', '90001', 'USA');

INSERT INTO Orders (user_id, total_amount, status, shipping_address_id)
VALUES 
(3, 1019.97, 'completed', 1),
(3, 39.99, 'pending', 1);

INSERT INTO OrderItems (order_id, product_id, quantity, price)
VALUES 
(1, 1, 1, 999.99),
(1, 3, 1, 49.99),
(2, 2, 2, 19.99);

INSERT INTO Reviews (product_id, user_id, rating, comment)
VALUES 
(1, 3, 5, 'Excellent laptop!'),
(2, 3, 4, 'Very comfortable t-shirt.');

INSERT INTO Payments (order_id, amount, payment_method, status)
VALUES 
(1, 1019.97, 'Credit Card', 'completed'),
(2, 39.99, 'PayPal', 'pending');

INSERT INTO ShoppingCart (user_id)
VALUES 
(3);

INSERT INTO CartItems (cart_id, product_id, quantity)
VALUES 
(1, 1, 1),
(1, 2, 3);
