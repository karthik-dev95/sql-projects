-- SALES DATA ANALYTICS PROJECT (MySQL)

CREATE DATABASE IF NOT EXISTS sales_analytics;
USE sales_analytics;

CREATE TABLE Customers (
    CustomerID INT AUTO_INCREMENT PRIMARY KEY,
    CustomerName VARCHAR(100) NOT NULL,
    Email VARCHAR(100) UNIQUE,
    City VARCHAR(50),
    CreatedDate DATE
);

CREATE TABLE Products (
    ProductID INT AUTO_INCREMENT PRIMARY KEY,
    ProductName VARCHAR(100) NOT NULL,
    Category VARCHAR(50),
    Price DECIMAL(10,2) CHECK (Price > 0)
);

CREATE TABLE Orders (
    OrderID INT AUTO_INCREMENT PRIMARY KEY,
    CustomerID INT,
    OrderDate DATE,
    TotalAmount DECIMAL(10,2),
    FOREIGN KEY (CustomerID) REFERENCES Customers(CustomerID)
);

CREATE TABLE OrderDetails (
    OrderDetailID INT AUTO_INCREMENT PRIMARY KEY,
    OrderID INT,
    ProductID INT,
    Quantity INT CHECK (Quantity > 0),
    Amount DECIMAL(10,2),
    FOREIGN KEY (OrderID) REFERENCES Orders(OrderID),
    FOREIGN KEY (ProductID) REFERENCES Products(ProductID)
);

INSERT INTO Customers (CustomerName, Email, City, CreatedDate) VALUES
('Rahul Sharma', 'rahul@gmail.com', 'Bangalore', '2024-01-10'),
('Priya Verma', 'priya@gmail.com', 'Hyderabad', '2024-02-15'),
('Amit Kumar', 'amit@gmail.com', 'Chennai', '2024-03-05');

INSERT INTO Products (ProductName, Category, Price) VALUES
('Laptop', 'Electronics', 65000),
('Mobile Phone', 'Electronics', 30000),
('Headphones', 'Accessories', 3000);

INSERT INTO Orders (CustomerID, OrderDate, TotalAmount) VALUES
(1, '2024-03-20', 68000),
(2, '2024-03-21', 30000),
(3, '2024-04-05', 33000);

INSERT INTO OrderDetails (OrderID, ProductID, Quantity, Amount) VALUES
(1, 1, 1, 65000),
(1, 3, 1, 3000),
(2, 2, 1, 30000),
(3, 2, 1, 30000),
(3, 3, 1, 3000);

CREATE VIEW vw_product_sales AS
SELECT p.ProductName,
       SUM(od.Quantity) AS TotalQuantitySold,
       SUM(od.Amount) AS TotalSales
FROM Products p
JOIN OrderDetails od ON p.ProductID = od.ProductID
GROUP BY p.ProductName;

DELIMITER $$
CREATE PROCEDURE GetCustomerOrders(IN cust_id INT)
BEGIN
    SELECT OrderID, OrderDate, TotalAmount
    FROM Orders
    WHERE CustomerID = cust_id;
END$$
DELIMITER ;

CREATE INDEX idx_orders_customer ON Orders(CustomerID);
