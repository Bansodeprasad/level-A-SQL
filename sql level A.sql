 1. List of all customers.
SELECT * FROM Sales.Customer;

-- 2. List of all customers where company name ending in N
SELECT * FROM Sales.Customer
WHERE CompanyName LIKE '%N';

-- 3. List of all customers who live in Berlin or London
SELECT * FROM Sales.Customer
WHERE City IN ('Berlin', 'London');

-- 4. List of all customers who live in UK or USA
SELECT * FROM Sales.Customer
WHERE Country IN ('UK', 'USA');

-- 5. List of all products sorted by product name
SELECT * FROM Production.Product
ORDER BY Name;

-- 6. List of all products where product name starts with an A
SELECT * FROM Production.Product
WHERE Name LIKE 'A%';

-- 7. List of customers who ever placed an order
SELECT DISTINCT c.*
FROM Sales.Customer c
JOIN Sales.SalesOrderHeader soh ON c.CustomerID = soh.CustomerID;

-- 8. List of Customers who live in London and have bought chai
SELECT DISTINCT c.*
FROM Sales.Customer c
JOIN Sales.SalesOrderHeader soh ON c.CustomerID = soh.CustomerID
JOIN Sales.SalesOrderDetail sod ON soh.SalesOrderID = sod.SalesOrderID
JOIN Production.Product p ON sod.ProductID = p.ProductID
WHERE c.City = 'London' AND p.Name = 'Chai';

-- 9. List of customers who never place an order
SELECT c.*
FROM Sales.Customer c
LEFT JOIN Sales.SalesOrderHeader soh ON c.CustomerID = soh.CustomerID
WHERE soh.CustomerID IS NULL;

-- 10. List of customers who ordered Tofu
SELECT DISTINCT c.*
FROM Sales.Customer c
JOIN Sales.SalesOrderHeader soh ON c.CustomerID = soh.CustomerID
JOIN Sales.SalesOrderDetail sod ON soh.SalesOrderID = sod.SalesOrderID
JOIN Production.Product p ON sod.ProductID = p.ProductID
WHERE p.Name = 'Tofu';

-- 11. Details of first order of the system
SELECT TOP 1 *
FROM Sales.SalesOrderHeader
ORDER BY OrderDate;

-- 12. Find the details of most expensive order date
SELECT TOP 1 *
FROM Sales.SalesOrderHeader
ORDER BY TotalDue DESC;

-- 13. For each order get the OrderID and Average quantity of items in that order
SELECT SalesOrderID, AVG(OrderQty) AS AvgQuantity
FROM Sales.SalesOrderDetail
GROUP BY SalesOrderID;

-- 14. For each order get the orderID, minimum quantity and maximum quantity for that order
SELECT SalesOrderID, MIN(OrderQty) AS MinQuantity, MAX(OrderQty) AS MaxQuantity
FROM Sales.SalesOrderDetail
GROUP BY SalesOrderID;

-- 15. Get a list of all managers and total number of employees who report to them.
SELECT m.ManagerID, COUNT(e.EmployeeID) AS TotalEmployees
FROM HumanResources.Employee e
JOIN HumanResources.Employee m ON e.ManagerID = m.EmployeeID
GROUP BY m.ManagerID;

-- 16. Get the OrderID and the total quantity for each order that has a total quantity of greater than 300
SELECT SalesOrderID, SUM(OrderQty) AS TotalQuantity
FROM Sales.SalesOrderDetail
GROUP BY SalesOrderID
HAVING SUM(OrderQty) > 300;

-- 17. List of all orders placed on or after 1996/12/31
SELECT *
FROM Sales.SalesOrderHeader
WHERE OrderDate >= '1996-12-31';

-- 18. List of all orders shipped to Canada
SELECT *
FROM Sales.SalesOrderHeader
WHERE ShipCountry = 'Canada';

-- 19. List of all orders with order total > 200
SELECT *
FROM Sales.SalesOrderHeader
WHERE TotalDue > 200;

-- 20. List of countries and sales made in each country
SELECT ShipCountry, SUM(TotalDue) AS TotalSales
FROM Sales.SalesOrderHeader
GROUP BY ShipCountry;

-- 21. List of Customer ContactName and number of orders they placed
SELECT c.ContactName, COUNT(soh.SalesOrderID) AS NumberOfOrders
FROM Sales.Customer c
JOIN Sales.SalesOrderHeader soh ON c.CustomerID = soh.CustomerID
GROUP BY c.ContactName;

[11:14 PM, 6/7/2024] bansodeprasad: 22. List of customer contact names who have placed more than 3 orders
SELECT c.ContactName
FROM Sales.Customer c
JOIN Sales.SalesOrderHeader soh ON c.CustomerID = soh.CustomerID
GROUP BY c.ContactName
HAVING COUNT(soh.SalesOrderID) > 3;

-- 23. List of discontinued products which were ordered between 1/1/1997 and 1/1/1998
SELECT DISTINCT p.ProductID, p.Name
FROM Production.Product p
JOIN Sales.SalesOrderDetail sod ON p.ProductID = sod.ProductID
JOIN Sales.SalesOrderHeader soh ON sod.SalesOrderID = soh.SalesOrderID
WHERE p.DiscontinuedDate IS NOT NULL
AND soh.OrderDate BETWEEN '1997-01-01' AND '1998-01-01';

-- 24. List of employee first name, last name, supervisor first name, last name
SELECT e.FirstName, e.LastName, s.FirstName AS SupervisorFirstName, s.LastName AS SupervisorLastName
FROM HumanResources.Employee e
JOIN HumanResources.Employee s ON e.ManagerID = s.EmployeeID;

-- 25. List of Employees id and total sale conducted by employee
SELECT e.EmployeeID, SUM(soh.TotalDue) AS TotalSales
FROM HumanResources.Employee e
JOIN Sales.SalesOrderHeader soh ON e.EmployeeID = soh.SalesPersonID
GROUP BY e.EmployeeID;

-- 26. List of employees whose FirstName contains character 'a'
SELECT *
FROM HumanResources.Employee
WHERE FirstName LIKE '%a%';

-- 27. List of managers who have more than four people reporting to them.
SELECT m.EmployeeID, COUNT(e.EmployeeID) AS TotalEmployees
FROM HumanResources.Employee e
JOIN HumanResources.Employee m ON e.ManagerID = m.EmployeeID
GROUP BY m.EmployeeID
HAVING COUNT(e.EmployeeID) > 4;

-- 28. List of Orders and ProductNames
SELECT soh.SalesOrderID, p.Name
FROM Sales.SalesOrderHeader soh
JOIN Sales.SalesOrderDetail sod ON soh.SalesOrderID = sod.SalesOrderID
JOIN Production.Product p ON sod.ProductID = p.ProductID;

-- 29. List of orders placed by the best customer
SELECT soh.*
FROM Sales.SalesOrderHeader soh
WHERE soh.CustomerID = (
    SELECT TOP 1 c.CustomerID
    FROM Sales.Customer c
    JOIN Sales.SalesOrderHeader soh ON c.CustomerID = soh.CustomerID
    GROUP BY c.CustomerID
    ORDER BY SUM(soh.TotalDue) DESC
);

-- 30. List of orders placed by customers who do not have a Fax number
SELECT soh.*
FROM Sales.SalesOrderHeader soh
JOIN Sales.Customer c ON soh.CustomerID = c.CustomerID
WHERE c.Fax IS NULL;

-- 31. List of Postal codes where the product Tofu was shipped
SELECT DISTINCT soh.ShipPostalCode
FROM Sales.SalesOrderHeader soh
JOIN Sales.SalesOrderDetail sod ON soh.SalesOrderID = sod.SalesOrderID
JOIN Production.Product p ON sod.ProductID = p.ProductID
WHERE p.Name = 'Tofu';

-- 32. List of product Names that were shipped to France
SELECT DISTINCT p.Name
FROM Production.Product p
JOIN Sales.SalesOrderDetail sod ON p.ProductID = sod.ProductID
JOIN Sales.SalesOrderHeader soh ON sod.SalesOrderID = soh.SalesOrderID
WHERE soh.ShipCountry = 'France';

-- 33. List of ProductNames and Categories for the supplier 'Specialty Biscuits, Ltd.'
SELECT p.Name, pc.Name AS Category
FROM Production.Product p
JOIN Production.ProductCategory pc ON p.ProductCategoryID = pc.ProductCategoryID
JOIN Production.ProductVendor pv ON p.ProductID = pv.ProductID
JOIN Purchasing.Vendor v ON pv.VendorID = v.VendorID
WHERE v.Name = 'Specialty Biscuits, Ltd.';

-- 34. List of products that were never ordered
SELECT p.*
FROM Production.Product p
LEFT JOIN Sales.SalesOrderDetail sod ON p.ProductID = sod.ProductID
WHERE sod.ProductID IS NULL;

-- 35. List of products where units in stock is less than 10 and units on order are 0.
SELECT *
FROM Production.Product
WHERE UnitsInStock < 10 AND UnitsOnOrder = 0;

-- 36. List of top 10 countries by sales
SELECT TOP 10 ShipCountry, SUM(TotalDue) AS TotalSales
FROM Sales.SalesOrderHeader
GROUP BY ShipCountry
ORDER BY TotalSales DESC;

-- 37. Number of orders each employee has taken for customers with CustomerIDs between A and AO
SELECT soh.SalesPersonID, COUNT(soh.SalesOrderID) AS NumberOfOrders
FROM Sales.SalesOrderHeader soh
JOIN Sales.Customer c ON soh.CustomerID = c.CustomerID
WHERE c.CustomerID BETWEEN 'A' AND 'AO'
GROUP BY soh.SalesPersonID;

-- 38. Orderdate of most expensive order
SELECT TOP 1 OrderDate
FROM Sales.SalesOrderHeader
ORDER BY TotalDue DESC;

-- 39. Product name and total revenue from that product
SELECT p.Name, SUM(sod.LineTotal) AS TotalRevenue
FROM Production.Product p
JOIN Sales.SalesOrderDetail sod
[11:15 PM, 6/7/2024] bansodeprasad: Sure! Here are the SQL queries for the remaining tasks (40, 41, 42):


-- 40. Supplierid and number of products offered
SELECT pv.VendorID AS SupplierID, COUNT(p.ProductID) AS NumberOfProducts
FROM Production.Product p
JOIN Production.ProductVendor pv ON p.ProductID = pv.ProductID
GROUP BY pv.VendorID;

-- 41. Top ten customers based on their business
SELECT TOP 10 c.CustomerID, SUM(soh.TotalDue) AS TotalBusiness
FROM Sales.Customer c
JOIN Sales.SalesOrderHeader soh ON c.CustomerID = soh.CustomerID
GROUP BY c.CustomerID
ORDER BY TotalBusiness DESC;

-- 42. What is the total revenue of the company
SELECT SUM(TotalDue) AS TotalRevenue
FROM Sales.SalesOrderHeader;