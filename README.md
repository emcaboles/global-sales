# Global Online Store Sales Analysis
## Quick links
### <a href="https://app.powerbi.com/view?r=eyJrIjoiNGYyMDNkNTQtMjk3OC00YjE5LTk1NTYtMGYyODcyNzExMDk0IiwidCI6ImRmODY3OWNkLWE4MGUtNDVkOC05OWFjLWM4M2VkN2ZmOTVhMCJ9" target="_blank">Sales Dashboard</a>

## Table of Contents
**INSERT LINKS**
+ <a href="https://github.com/emcaboles/global-sales?tab=readme-ov-file#scenario">Scenario</a>
+ Data Extraction using SQL
+ Data Cleaning, Transformation, and Visualization using Power Query and Power BI
+ Data Analysis and Results
+ References
+ Extras

## Scenario
You are a data analyst at a global online store. The sales department needs your help in creating a report regarding the 2023 sales and the sales manager asked you to get the following data from you company's database using SQL.

1.  Find the top 5 countries with the highest total revenue from online orders.
2.  List the sales per region (North America, South America, Europe).
3.  List the products that have been ordered in every month of the dataset.
4.  List all products contained in bottles or jars or products that are sauces or syrup their supplier and their location.
5.  Identify the top 10 products with the highest profit margin.
6.  Calculate the average order value for each product category.
7.  Identify the customer ID's who have made purchases on consecutive days.
8.  Calculate the average number of days between a customer's first and second order.
9.  Identify the customers who have made purchases in every product category.
10.  Find the average number of items per order for each customer.
11.  List the products that have been ordered by customers from at least 5 different countries.
12.  List the sales of each employee for the months of Aug and Sep 2023 from highest to lowest.

In addition, they want you to create a Power BI report showing the sales from Jul 2023 to present with the following details:
* Sales Over Time
* Key Performance Indicators:
	* Monthly and Total Sales
	* Monthly and Total Profit
	* Monthly and Total Orders
* Sales per Product Category
* Sales per Customer
* Orders, Sales, Profit per Product
* Ranking of Agents per Sales
* Agent Weekly Metrics:
	* Orders per Agent
	* Customer per Agent
	* Sales per Agent
	* Product Units Sold Per Agent
    
Also, there should be a filter for YTD, MTD, Dates, and Continent/Region where customers are located.

However, there is one catch. The 2024 sales and their corresponding details have not yet been uploaded in the database but is manually recorded and saved in Excel files.

Since the data is manually recorded, the sales department also wants you to check if there are possible errors or outliers in the data.

## Data Extraction using SQL
The database has the following tables and relationships:
**INSERT ERD**

To have an idea about the tables, the number of records and the structure of each table were checked. 

```sql
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
```
**INSERT RESULTS USING  //DETAILS//**
<details>
  <summary>Results</summary>
  Insert Table
</details>

 ```sql
SELECT * FROM categories
LIMIT 10;
```
**INSERT RESULTS USING  //DETAILS//**
<details>
  <summary>Results</summary>
  Insert Table
</details>

```sql
SELECT * FROM customers
LIMIT 10;
```
<details>
  <summary>Results</summary>
  Insert Table
</details>

```sql
SELECT * FROM employees
LIMIT 10;
```
<details>
  <summary>Results</summary>
  Insert Table
</details>

```sql
SELECT * FROM orders
LIMIT 10;
```
<details>
  <summary>Results</summary>
  Insert Table
</details>

```sql
SELECT * FROM ordersdetails
LIMIT 10;
```
<details>
  <summary>Results</summary>
  Insert Table
</details>

```sql
SELECT * FROM products
LIMIT 10;
```
<details>
  <summary>Results</summary>
  Insert Table
</details>

```sql
SELECT * FROM shippers
LIMIT 10;
```
<details>
  <summary>Results</summary>
  Insert Table
</details>

```sql
SELECT * FROM suppliers
LIMIT 10;
```
<details>
  <summary>Results</summary>
  Insert Table
</details>

To save space, results for the next queries are truncated to show only the first 10 results, unless otherwise specified.

1.  Find the top 5 countries with the highest total revenue from online orders.
```sql
SELECT
	cus.Country as  'Country',
	ROUND(
		SUM(det.Quantity * pro.Price), 2) AS  'Revenue'
FROM
	orders ord
LEFT JOIN ordersdetails det ON ord.OrderID = det.OrderID
LEFT JOIN products pro ON det.ProductID = pro.ProductID
LEFT JOIN customers cus ON ord.CustomerID = cus.CustomerID
WHERE NOT det.Quantity IS NULL OR NOT pro.Price IS  NULL
GROUP BY Country
ORDER BY Revenue DESC
LIMIT 5; 
```
<details>
  <summary>Results</summary>
  Insert Table
</details>

2.  List the sales per region (North America, South America, Europe).
```sql
WITH CustomerPerContinent AS (
	SELECT
		CustomerID,
		CASE
			WHEN Country IN ('USA', 'Canada', 'Mexico') THEN 'North America'
			WHEN Country IN ('Brazil', 'Venezuela', 'Argentina') THEN 'South America'
			ELSE  'Europe'
		END AS Continent
	FROM customers
	)

SELECT
	cpc.Continent,
	SUM(det.OrderID * ProductID) AS Sales
From ordersdetails det
LEFT JOIN orders ord ON det.OrderID = ord.OrderID
LEFT JOIN CustomerPerContinent cpc ON ord.CustomerID = cpc.CustomerID
GROUP BY Continent;
```
<details>
  <summary>Results</summary>
  Insert Table
</details>

3.  List the products that have been ordered in every month of the dataset.
```sql
WITH Product_Orders AS (
	SELECT
		DATE_FORMAT(OrderDate, '%Y-%m') AS  'Order_Date',
		pro.ProductName AS  'Product_Name'
	FROM orders ord
	LEFT JOIN ordersdetails det ON ord.OrderID = det.OrderID
	LEFT JOIN products pro ON det.ProductID = pro.ProductID
)

SELECT
Product_Name,
COUNT(Order_Date) AS  'Count'
FROM Product_Orders
GROUP BY Product_Name
HAVING(COUNT(Order_Date)) = (SELECT  COUNT(DISTINCT(Order_Date)) FROM Product_Orders); /* Get all distinct year-month in the dataset */
```
<details>
  <summary>Results</summary>
  Insert Table
</details>

4.  List all products contained in bottles or jars or products that are sauces or syrup their supplier and their location.
```sql
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
	OR ProductName REGEXP 'sauce|sås|Soße|saus|molho|salsa|kastike'  /*sauces in languages of supplier countries*/
	OR ProductName REGEXP 'syrup|sirop|sirap|sirup|xarope|jarabe|sciroppo|siirapi'  /*syrup in languages of supplier countries*/
ORDER BY Country ASC;
```
<details>
  <summary>Results</summary>
  Insert Table
</details>

5.  Identify the top 10 products with the highest profit margin.
* Assuming that the total revenue is equivalent to sales and all costs are already accounted for in the *Cost* column of the *products* table:
&nbsp;&nbsp;&nbsp;&nbsp;Profit Margin = Sales - Cost of Goods Solds / Sales
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; = Price *x* Quantity  - Cost *x* Quantity / Price *x* Quantity
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; = Quantity *x* (Price-Cost)/ Quantity *x* Price
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; = Price-Cost / Price
```sql
SELECT
	ProductName,
	ROUND(
		100*(Price-Cost)/Cost, 2) AS ProfitMargin
FROM Products
ORDER BY ProfitMargin DESC
LIMIT  10;
```
<details>
  <summary>Results</summary>
  Insert Table
</details>

6.  Calculate the average order value for each product category.
```sql
WITH Orders_Prices AS (
	SELECT
		det.OrderID as  'Order_ID',
		pro.ProductName AS  'Product',
		ROUND(
			det.Quantity * pro.Price, 2) AS  'Order_Price'
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
```
<details>
  <summary>Results</summary>
  Insert Table
</details>

7.  Identify the customer ID's who have made purchases on consecutive days.
```sql
WITH order_dates AS (
	SELECT
		CustomerID,
		OrderDate,
		DATEDIFF(
			OrderDate,
			LAG(OrderDate, 1, 0)
			OVER (PARTITION  BY CustomerID ORDER BY OrderDate)) AS  'Diff_Order_Times'
	FROM orders
	ORDER BY ISNULL(Diff_Order_Times), Diff_Order_Times /*Order by NULLS LAST */
	)
	
SELECT
	CustomerID,
	Diff_Order_Times
FROM order_dates
WHERE Diff_Order_Times =  1;
```
<details>
  <summary>Results</summary>
  Insert Table
</details>

8.  Calculate the average number of days between a customer's first and second order.
```sql
WITH order_dates AS (
	SELECT
		CustomerID,
		OrderDate,
		DATEDIFF(
			OrderDate,
			LAG(OrderDate, 1, 0)
			OVER (PARTITION BY CustomerID ORDER BY OrderDate)) AS 'Diff_Order_Times',
		ROW_NUMBER() OVER (PARTITION BY CustomerID ORDER BY OrderDate) AS 'Rank_Orders' /*accounts if customer has two different orders on the same day */
	FROM orders
	)

SELECT
	FLOOR(AVG(Diff_Order_Times)) AS 'Avg_Ord_Times'
FROM order_dates
WHERE Rank_Orders = 2;
```
<details>
  <summary>Results</summary>
  Insert Table
</details>

9.  Identify the customers who have made purchases in every product category.
```sql
SELECT
	ord.CustomerID as  'Customer_ID',
	CustomerName as  'Customer_Name',
	COUNT(DISTINCT(CategoryID)) AS  'Count_Cat'
FROM orders ord
INNER JOIN ordersdetails det ON ord.OrderID = det.OrderID
INNER JOIN products pro ON det.ProductID = pro.ProductID
INNER JOIN customers cus ON ord.CustomerID = cus.CustomerID
GROUP BY ord.CustomerID
HAVING  COUNT(DISTINCT(CategoryID)) = (SELECT COUNT(*) FROM categories);
```
<details>
  <summary>Results</summary>
  Insert Table
</details>

10.  Find the average number of items per order for each customer.
```sql
WITH items_per_customer AS (
	SELECT
		ord.OrderID AS  'Order_ID',
		cus.CustomerID,
		CustomerName,
		SUM(Quantity) AS  'No_Items'
	FROM orders ord
	INNER JOIN ordersdetails det ON ord.OrderID = det.OrderID
	INNER JOIN customers cus ON ord.CustomerID = cus.CustomerID
	GROUP BY CustomerID, ord.OrderID
	)

SELECT
	CustomerName,
	FLOOR(
		SUM(No_Items) / (COUNT(Order_ID))
		) AS  'Items'
FROM items_per_customer
GROUP BY CustomerName
ORDER BY Items ASC;
```
<details>
  <summary>Results</summary>
  Insert Table
</details>

11.  List the products that have been ordered by customers from at least 5 different countries.
```sql
SELECT
	ProductName,
	COUNT(DISTINCT(Country)) AS  'Count_Country'
FROM orders ord
INNER JOIN ordersdetails det ON ord.OrderID = det.OrderID
INNER JOIN customers cus ON ord.CustomerID = cus.CustomerID
LEFT JOIN products pro ON det.ProductID = pro.ProductID
GROUP BY ProductName
HAVING COUNT(DISTINCT(Country)) >=  5
ORDER BY Count_Country ASC;
```
<details>
  <summary>Results</summary>
  Insert Table
</details>

12.  List the sales of each employee for the months of Aug and Sep 2023 from highest to lowest.
```sql
SELECT
	CONCAT_WS(' ',FirstName,LastName) AS  'Emp_Name',
	ROUND(
		SUM(Quantity * Price), 2) AS  'Sales'
FROM orders ord
INNER JOIN ordersdetails det ON ord.OrderID = det.OrderID
LEFT JOIN employees emp ON ord.EmployeeID = emp.EmployeeID
LEFT JOIN products pro ON det.ProductID = pro.ProductID
WHERE OrderDate >= '2023-08-01'AND OrderDate < '2023-10-01'
GROUP BY Emp_Name
ORDER BY Sales DESC;
```
<details>
  <summary>Results</summary>
  Insert Table
</details>

## Data Cleaning, Transformation, and Visualization using Power Query and Power BI

## Data Analysis and Results

## References

## Extras

