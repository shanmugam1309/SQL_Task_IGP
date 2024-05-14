create database Sql_Task


-- Create Customers table
CREATE TABLE Customers (
    CustomerID INT PRIMARY KEY,
    CustomerName NVARCHAR(100),
    ContactName NVARCHAR(100),
    Country NVARCHAR(100)
)

-- Create Orders table
CREATE TABLE Orders (
    OrderID INT PRIMARY KEY,
    CustomerID INT,
    OrderDate DATETIME,
    FOREIGN KEY (CustomerID) REFERENCES Customers(CustomerID)
)

-- Create OrderDetails table
CREATE TABLE OrderDetails (
    OrderDetailID INT PRIMARY KEY,
    OrderID INT,
    ProductID INT,
    Quantity INT,
    UnitPrice DECIMAL(10, 2),
    FOREIGN KEY (OrderID) REFERENCES Orders(OrderID)
)


-- Declare variables
DECLARE @customerId INT
DECLARE @customerName NVARCHAR(100)
DECLARE @totalRevenue DECIMAL(18, 2)

-- Create a temporary table to store results
CREATE TABLE #CustomerRevenue (
    CustomerID INT,
    CustomerName NVARCHAR(100),
    TotalRevenue DECIMAL(18, 2)
)

-- Declare cursor
DECLARE customerCursor CURSOR FOR
SELECT c.CustomerID, c.CustomerName
FROM Customers c

-- Open cursor
OPEN customerCursor

-- Fetch data into variables
FETCH NEXT FROM customerCursor INTO @customerId, @customerName
WHILE @@FETCH_STATUS = 0
BEGIN
    -- Initialize total revenue
    SET @totalRevenue = 0
    
    -- Calculate total revenue for the current customer
    SELECT @totalRevenue = SUM(od.Quantity * od.UnitPrice)
    FROM Orders o
    INNER JOIN OrderDetails od ON o.OrderID = od.OrderID
    WHERE o.CustomerID = @customerId

    -- Insert the result into the temporary table
    INSERT INTO #CustomerRevenue (CustomerID, CustomerName, TotalRevenue)
    VALUES (@customerId, @customerName, @totalRevenue)

    -- Fetch next row
    FETCH NEXT FROM customerCursor INTO @customerId, @customerName
END

-- Close cursor
CLOSE customerCursor
DEALLOCATE customerCursor

-- Print the results
SELECT * FROM #CustomerRevenue

-- Drop the temporary table
--DROP TABLE #CustomerRevenue


-- Insert values into Customers table
INSERT INTO Customers (CustomerID, CustomerName, ContactName, Country)
VALUES 
    (1, 'Customer A', 'John Smith', 'USA'),
    (2, 'Customer B', 'Alice Johnson', 'Canada'),
    (3, 'Customer C', 'Emma Brown', 'UK'),
    (4, 'Customer D', 'Michael Lee', 'Australia')

-- Insert values into Orders table
INSERT INTO Orders (OrderID, CustomerID, OrderDate)
VALUES 
    (101, 1, '2024-05-01'),
    (102, 2, '2024-05-02'),
    (103, 1, '2024-05-03'),
    (104, 3, '2024-05-04'),
    (105, 4, '2024-05-05')

-- Insert values into OrderDetails table
INSERT INTO OrderDetails (OrderDetailID, OrderID, ProductID, Quantity, UnitPrice)
VALUES 
    (201, 101, 1, 2, 10.50),
    (202, 101, 2, 3, 15.25),
    (203, 102, 3, 1, 20.00),
    (204, 103, 1, 4, 10.50),
    (205, 104, 2, 2, 15.25),
    (206, 105, 3, 3, 20.00),
    (207, 105, 4, 1, 12.75)
