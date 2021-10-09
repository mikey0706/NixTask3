--1

SELECT ProductName FROM dbo.Products WHERE UnitPrice = (SELECT MAX(UnitPrice) FROM dbo.Products); 

--2

SELECT ShipCity FROM dbo.Orders WHERE DATEDIFF(DAY, OrderDate, ShippedDate) > 10;                 

--3

SELECT DISTINCT ContactName FROM dbo.Customers
INNER JOIN Orders ON Customers.CustomerID = Orders.CustomerID                                     
WHERE RequiredDate < ShippedDate;

--4

SELECT TOP 1 COUNT(CustomerID) AS MaxCusomers from dbo.Orders                                     
GROUP BY EmployeeID ORDER BY MaxCusomers DESC;

--5

SELECT EmployeeID, COUNT(ShipCity) AS France97 FROM dbo.Orders
WHERE ShipCountry = 'France' 
AND YEAR(ShippedDate) = 1997 
AND EmployeeID =1
GROUP BY EmployeeID


--6

SELECT ShipCountry FROM dbo.Orders GROUP BY ShipCountry HAVING COUNT(OrderID)>2;

--7

SELECT ProductName FROM dbo.Products
INNER JOIN [Order Details] ON Products.ProductID = [Order Details].ProductID
GROUP BY ProductName HAVING SUM(Quantity)<1000;

--8

SELECT DISTINCT ContactName FROM dbo.Customers
INNER JOIN Orders ON Customers.CustomerID = Orders.CustomerID
WHERE Customers.City != Orders.ShipCity;

--9

DECLARE @ProductId int;

WITH OrdersData as (
SELECT OrderID FROM Orders
INNER JOIN Customers ON Orders.CustomerID = Customers.CustomerID
WHERE YEAR(ShippedDate) = 1997
AND FAX IS NOT NULL
)

SELECT @ProductId = ProductID FROM [Order Details]
INNER JOIN OrdersData ON [Order Details].OrderID = OrdersData.OrderID
WHERE ProductID = (
SELECT TOP 1  COUNT(ProductID) FROM [Order Details] GROUP BY ProductID ORDER BY ProductID DESC
);

SELECT CategoryName FROM dbo.Categories WHERE CategoryID = (
SELECT CategoryID FROM dbo.Products WHERE ProductID = @ProductId
);

--10

WITH EmpOrder as( 
SELECT Employees.EmployeeID, Orders.OrderID FROM Employees
INNER JOIN Orders ON Employees.EmployeeID = Orders.EmployeeID
WHERE YEAR(ShippedDate) = 1996
AND MONTH(ShippedDate) >= 09
AND MONTH(ShippedDate) <= 11
)

SELECT Employees.FirstName, Employees.LastName, SUM([Order Details].Quantity) AS TotalQuantity FROM Employees
INNER JOIN EmpOrder ON Employees.EmployeeID =EmpOrder.EmployeeID
INNER JOIN [Order Details] ON EmpOrder.OrderID = [Order Details].OrderID
GROUP BY Employees.FirstName, Employees.LastName




