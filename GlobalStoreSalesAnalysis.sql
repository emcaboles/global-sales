
/*To check how many records are there per table */

SELECT 'categories', COUNT(*) FROM categories
UNION ALL
SELECT 'customers', COUNT(*) FROM customers
UNION ALL
SELECT 'employees', COUNT(*) FROM employees
UNION ALL
SELECT 'orders', COUNT(*) FROM orders
UNION ALL
SELECT 'ordersdetails', COUNT(*) FROM ordersdetails
UNION ALL
SELECT 'products', COUNT(*) FROM products
UNION ALL
SELECT 'shippers', COUNT(*) FROM shippers
UNION ALL
SELECT 'suppliers', COUNT(*) FROM suppliers;


/* Checking for the format of all tables */
SELECT * FROM categories
LIMIT 10;

SELECT * FROM customers
LIMIT 10;

SELECT * FROM employees 
LIMIT 10;

SELECT * FROM orders
LIMIT 10;

SELECT * FROM ordersdetails
LIMIT 10;

SELECT * FROM products
LIMIT 10;

SELECT * FROM shippers
LIMIT 10;

SELECT * FROM suppliers
LIMIT 10;

/* Find the top 5 countries with the highest total revenue from online orders. */
SELECT
	cus.Country as 'Country',
    ROUND(
		SUM(det.Quantity * pro.Price), 2) AS 'Revenue'
FROM
	orders ord
LEFT JOIN ordersdetails det ON ord.OrderID = det.OrderID
LEFT JOIN products pro ON det.ProductID = pro.ProductID
LEFT JOIN customers cus ON ord.CustomerID = cus.CustomerID
WHERE NOT det.Quantity IS NULL OR NOT pro.Price IS NULL
GROUP BY Country
ORDER BY Revenue DESC
LIMIT 5;

/* List the sales per region (North America, South America, Europe). */
WITH CustomerPerContinent AS (
	SELECT
		CustomerID,
		CASE
			WHEN Country IN ('USA', 'Canada', 'Mexico') THEN 'North America'
    		WHEN Country IN ('Brazil', 'Venezuela', 'Argentina') THEN 'South America'
    	ELSE 'Europe'
		END AS Continent
	FROM customers
	)

SELECT
	cpc.Continent,
	SUM(det.OrderID * ProductID) AS Sales
FROM ordersdetails det
LEFT JOIN orders ord ON det.OrderID = ord.OrderID
LEFT JOIN CustomerPerContinent cpc ON ord.CustomerID = cpc.CustomerID
GROUP BY Continent;

/* List the products that have been ordered in every month of the dataset. */
WITH Product_Orders AS (
	SELECT
		DATE_FORMAT(OrderDate, '%Y-%m') AS 'Order_Date',
		pro.ProductName AS 'Product_Name'
	FROM orders ord
	LEFT JOIN ordersdetails det ON ord.OrderID = det.OrderID
	LEFT JOIN products pro ON det.ProductID = pro.ProductID
	)

SELECT
	Product_Name,
    COUNT(Order_Date) AS 'Count'
FROM Product_Orders
GROUP BY Product_Name
HAVING(COUNT(Order_Date)) = (SELECT COUNT(DISTINCT(Order_Date)) FROM Product_Orders); /* Get all distinct year-month in the dataset */

/* List all products contained in bottles or jars or products that are sauces or syrup their supplier and their Location. */
SELECT
	ProductName,
    Unit,
    SuppliersName,
    CONCAT_WS(' ',Address,City,Country,PostalCode) AS 'Complete_Address',
    Country
FROM products pro
INNER JOIN suppliers sup ON pro.SuppliersID = sup.SupplierID
WHERE
	Unit REGEXP 'bottles|jars'
    OR ProductName REGEXP 'sauce|sås|Soße|saus|molho|salsa|kastike' /*sauces in languages of supplier countries*/
    OR ProductName REGEXP 'syrup|sirop|sirap|sirup|xarope|jarabe|sciroppo|siirapi' /*syrup in languages of supplier countries*/
ORDER BY Country ASC;

/* Identify the top 10 products with the highest profit margin. */
/*
Profit Margin = Sales - COGS / Sales 
			 = Price*Quantity - Cost*Quantity / Price*Quantity
			 = Quantity(Price-Cost)/Quantity*Price
			 = Price-Cost / Price
 */

SELECT
	ProductName,
    ROUND(
		100*(Price-Cost)/Cost, 2) AS ProfitMargin
FROM Products
ORDER BY ProfitMargin DESC
LIMIT 10;


/* Calculate the average order value for each product category. */
WITH Orders_Prices AS (
	SELECT
		det.OrderID as 'Order_ID',
    	pro.ProductName AS 'Product',
    	ROUND(
			det.Quantity * pro.Price, 2) AS 'Order_Price'
	FROM ordersdetails det
	LEFT JOIN PRODUCTS pro ON det.ProductID = pro.ProductID
)

SELECT
	Product,
    ROUND(
		SUM(Order_Price)/COUNT(Order_ID), 2) AS 'Avg_Order_Price'
FROM Orders_Prices
GROUP BY Product
ORDER BY Avg_Order_Price ASC;

/* Identify the customer ID's who have made purchases on consecutive days. */
WITH order_dates AS (
	SELECT
		CustomerID,
		OrderDate,
		DATEDIFF(
			OrderDate,
			LAG(OrderDate, 1, 0)
			OVER (PARTITION BY CustomerID ORDER BY OrderDate)) AS 'Diff_Order_Times'
	FROM orders
	ORDER BY ISNULL(Diff_Order_Times), Diff_Order_Times /*Order by NULLS LAST */
	)

SELECT
	CustomerID,
    Diff_Order_Times
FROM order_dates
WHERE Diff_Order_Times = 1;

/* Calculate the average number of days between a customer's first and second order. */

WITH order_dates AS (
	SELECT
		CustomerID,
		OrderDate,
		DATEDIFF(
			OrderDate,
			LAG(OrderDate, 1, 0)
			OVER (PARTITION BY CustomerID ORDER BY OrderDate)) AS 'Diff_Order_Times',
		ROW_NUMBER() OVER (PARTITION BY CustomerID ORDER BY OrderDate) AS 'Rank_Orders' /*what if there are two orders per day by the same customer */
	FROM orders
	)

SELECT
	ROUND(AVG(Diff_Order_Times), 2) AS 'Avg_Ord_Times'
FROM order_dates
WHERE Rank_Orders = 2;

/* Identify the customers who have made purchases in every product category */
SELECT
	ord.CustomerID as 'Customer_ID',
	CustomerName as 'Customer_Name',
    COUNT(DISTINCT(CategoryID)) AS 'Count_Cat'
FROM orders ord
INNER JOIN ordersdetails det ON ord.OrderID = det.OrderID
INNER JOIN products pro ON det.ProductID = pro.ProductID
INNER JOIN customers cus ON ord.CustomerID = cus.CustomerID
GROUP BY ord.CustomerID
HAVING COUNT(DISTINCT(CategoryID)) = (SELECT COUNT(*) FROM categories);


/* Find the average number of items per order for each customer. */
WITH items_per_customer AS (
	SELECT
		ord.OrderID AS 'Order_ID',
		cus.CustomerID,
        CustomerName,
		SUM(Quantity) AS 'No_Items'
	FROM orders ord
	INNER JOIN ordersdetails det ON ord.OrderID = det.OrderID
    INNER JOIN customers cus ON ord.CustomerID = cus.CustomerID
	GROUP BY CustomerID, ord.OrderID
	)

SELECT
	CustomerName,
    FLOOR(
		SUM(No_Items) / (COUNT(Order_ID))
		) AS 'Items'
FROM items_per_customer
GROUP BY CustomerName
ORDER BY Items ASC;

/* List the products that have been ordered by customers from at least 5 different countries. */
SELECT
	ProductName,
    COUNT(DISTINCT(Country)) AS 'Count_Country'
FROM orders ord
INNER JOIN ordersdetails det ON ord.OrderID = det.OrderID
INNER JOIN customers cus ON ord.CustomerID = cus.CustomerID
LEFT JOIN products pro ON det.ProductID = pro.ProductID
GROUP BY ProductName
HAVING COUNT(DISTINCT(Country)) >= 5
ORDER BY Count_Country ASC;

/* List the sales of each employee for the months of Aug and Sep 2023 from highest to lowest */
SELECT
    CONCAT_WS(' ',FirstName,LastName) AS 'Emp_Name',
    ROUND(
		SUM(Quantity * Price), 2) AS 'Sales'
FROM orders ord
INNER JOIN ordersdetails det ON ord.OrderID = det.OrderID
LEFT JOIN employees emp ON ord.EmployeeID = emp.EmployeeID
LEFT JOIN products pro ON det.ProductID = pro.ProductID
WHERE OrderDate >= '2023-08-01' AND OrderDate < '2023-10-01'
GROUP BY Emp_Name
ORDER BY Sales DESC;