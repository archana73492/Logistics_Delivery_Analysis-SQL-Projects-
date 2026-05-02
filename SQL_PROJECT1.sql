## CREATE TABLES##

CREATE TABLE Customers (
    customer_id INT PRIMARY KEY,
    name VARCHAR(50),
    city VARCHAR(50),
    signup_date DATE
);
CREATE TABLE Orders (
    order_id INT PRIMARY KEY,
    customer_id INT,
    order_date DATE,
    delivery_date DATE,
    status VARCHAR(20),
    order_value DECIMAL(10,2),
    FOREIGN KEY (customer_id) REFERENCES Customers(customer_id)
);
CREATE TABLE Delivery_Agents (
    agent_id INT PRIMARY KEY,
    name VARCHAR(50),
    city VARCHAR(50),
    rating DECIMAL(2,1)
);
CREATE TABLE Shipments (
    shipment_id INT PRIMARY KEY,
    order_id INT,
    agent_id INT,
    dispatch_date DATE,
    delivery_time INT,
    FOREIGN KEY (order_id) REFERENCES Orders(order_id),
    FOREIGN KEY (agent_id) REFERENCES Delivery_Agents(agent_id)
);

## INSERT DATA INTO TABLES ##

INSERT INTO Customers VALUES
(1, 'Ravi', 'Bangalore', '2023-01-10'),
(2, 'Anita', 'Mumbai', '2023-02-15'),
(3, 'John', 'Delhi', '2023-03-20'),
(4, 'Priya', 'Bangalore', '2023-04-05');

INSERT INTO Orders VALUES
(101, 1, '2023-05-01', '2023-05-04', 'Delivered', 5000),
(102, 2, '2023-05-02', '2023-05-08', 'Delayed', 7000),
(103, 3, '2023-05-03', '2023-05-05', 'Delivered', 3000),
(104, 4, '2023-05-04', NULL, 'Cancelled', 2000);

INSERT INTO Delivery_Agents VALUES
(1, 'Amit', 'Bangalore', 4.5),
(2, 'Suresh', 'Mumbai', 4.0),
(3, 'Rahul', 'Delhi', 3.8);

INSERT INTO Shipments VALUES
(1, 101, 1, '2023-05-01', 48),
(2, 102, 2, '2023-05-02', 120),
(3, 103, 3, '2023-05-03', 36);

##DELAYED ORDERS##

SELECT * FROM Orders
WHERE delivery_date > order_date + INTERVAL 3 DAY; 

##TOP DELIVERY AGENTS ##

SELECT agent_id, COUNT(*) AS total_deliveries
FROM Shipments
GROUP BY agent_id
ORDER BY total_deliveries DESC;

## AVERAGE DELIVERY TIME BY CITY  ##

SELECT c.city, AVG(s.delivery_time) AS avg_delivery_time
FROM Customers c
JOIN Orders o ON c.customer_id = o.customer_id
JOIN Shipments s ON o.order_id = s.order_id
GROUP BY c.city;

## MONTHLY REVENUE ##

SELECT DATE_FORMAT('month', order_date) AS month,
SUM(order_value) AS revenue
FROM Orders
GROUP BY month;

##  CANCELLATION RATE ##

SELECT 
(SUM(CASE WHEN status='Cancelled' THEN 1 ELSE 0 END)*100.0/COUNT(*)) AS cancel_rate
FROM Orders;

##  HIGH VALUE CUSTOMERS ##

SELECT customer_id, SUM(order_value) AS total_spent
FROM Orders
GROUP BY customer_id
HAVING SUM(order_value) > 5000;

## Window Function (Ranking Orders) ##


SELECT o.order_id, o.customer_id, o.order_value,
       (
         SELECT count(*)
         FROM Orders o2
         WHERE o2.customer_id = o.customer_id
           AND o2.order_value >= o.order_value
       ) AS order_rank
FROM Orders o
ORDER BY o.customer_id, order_rank;


