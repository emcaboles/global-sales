
# Global Online Store Sales Analysis
## Quick Links
[Power BI Dashboard](https://app.powerbi.com/view?r=eyJrIjoiMDlkYTMzZTgtMjFmZi00NGFkLWJjMGQtNzQ4ZmY0MjI0NmM4IiwidCI6ImRmODY3OWNkLWE4MGUtNDVkOC05OWFjLWM4M2VkN2ZmOTVhMCJ9) \
[SQL Queries](https://github.com/emcaboles/global-sales?tab=readme-ov-file#requested-data-queries)\
[Data Analysis](https://github.com/emcaboles/global-sales/tree/main?tab=readme-ov-file#data-analysis) 

## Table of Contents
+ [Scenario](https://github.com/emcaboles/global-sales?tab=readme-ov-file#scenario)
+ [Data Extraction (SQL)](https://github.com/emcaboles/global-sales?tab=readme-ov-file#data-extraction-sql)
+ [ETL and Visualization (Power Query, Power BI)](https://github.com/emcaboles/global-sales/tree/main?tab=readme-ov-file#etl-and-visualization-power-query-power-bi)
+ [Data Analysis](https://github.com/emcaboles/global-sales/tree/main?tab=readme-ov-file#data-analysis)
<!--+ Extras-->

## Scenario
[back to top](https://github.com/emcaboles/global-sales?tab=readme-ov-file#global-online-store-sales-analysis)


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

## Data Extraction (SQL)
[back to top](https://github.com/emcaboles/global-sales?tab=readme-ov-file#global-online-store-sales-analysis)

### Data Tables and the ERD
The database has the following tables and relationships:

![ERD_new_amazon](https://github.com/emcaboles/global-sales/assets/160221619/6e86c4b8-5858-4b5a-a40e-ba34c8babdbb)

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
<details>
  <summary>Results</summary>
	<img width="300" alt="Query_1_results" src="https://github.com/emcaboles/global-sales/assets/160221619/b179062c-6474-4266-984f-0e548b2ce296">
</details>


 ```sql
SELECT * FROM categories
LIMIT 10;
```
<details>
  <summary>Results</summary>
	<img width="500" alt="Query_2_categories" src="https://github.com/emcaboles/global-sales/assets/160221619/cf342b52-19b2-4a56-aeb1-bb73502a8a9d">
</details>

```sql
SELECT * FROM customers
LIMIT 10;
```
<details>
  <summary>Results</summary>
	<img width="1500" alt="Query_2_customers" src="https://github.com/emcaboles/global-sales/assets/160221619/136df5b7-c69d-4be6-a1eb-596945961771">
</details>

```sql
SELECT * FROM employees
LIMIT 10;
```
<details>
  <summary>Results</summary>
	<img width="800" alt="Query_2_employees" src="https://github.com/emcaboles/global-sales/assets/160221619/13d71b0e-2d39-403d-8452-4244cdbd271a">
</details>

```sql
SELECT * FROM orders
LIMIT 10;
```
<details>
  <summary>Results</summary>
  <img width="300" alt="Query_2_orders" src="https://github.com/emcaboles/global-sales/assets/160221619/0c549fcf-b09a-404b-9fd4-1b1b4fc2ccb3">

</details>

```sql
SELECT * FROM ordersdetails
LIMIT 10;
```
<details>
  <summary>Results</summary>
  <img width="300" alt="Query_2_ordersdetails" src="https://github.com/emcaboles/global-sales/assets/160221619/ef38ef2e-c14b-41af-96ac-e9ff01254c69">
</details>

```sql
SELECT * FROM products
LIMIT 10;
```
<details>
  <summary>Results</summary>
  <img width="700" alt="Query_2_products" src="https://github.com/emcaboles/global-sales/assets/160221619/383e2cee-9025-4680-84ad-c6d62b8af055">
</details>

```sql
SELECT * FROM shippers
LIMIT 10;
```
<details>
  <summary>Results</summary>
  <img width="400" alt="Query_2_shippers" src="https://github.com/emcaboles/global-sales/assets/160221619/ae480d46-79fc-44e1-880d-bad63f8c60e9">
</details>

```sql
SELECT * FROM suppliers
LIMIT 10;
```
<details>
  <summary>Results</summary>
  <img width="1034" alt="Query_2_suppliers" src="https://github.com/emcaboles/global-sales/assets/160221619/f7bf86fa-6a19-44b5-8944-83c75970158c">
</details>

### Requested Data Queries
[back to top](https://github.com/emcaboles/global-sales?tab=readme-ov-file#global-online-store-sales-analysis)

The following queries answer the Sales Department's request. Some results have been truncated to save space.

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
  <img width="250" alt="Query_3_results" src="https://github.com/emcaboles/global-sales/assets/160221619/75ccbfe9-b214-4cb2-849b-b4751ca1af33">
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
  <img width="400" alt="region_sales" src="https://github.com/emcaboles/global-sales/assets/160221619/d199daa9-4c1e-43f3-92f1-eeaa05afd397">
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
  <img width="300" alt="Query_5_results" src="https://github.com/emcaboles/global-sales/assets/160221619/ae6f5a7b-0038-47cc-a505-0b5782b6925e">
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
  <img width="1200" alt="Query_12_results" src="https://github.com/emcaboles/global-sales/assets/160221619/0e83d46d-9025-4e48-bb1e-af771d11de8b">
</details>

5.  Identify the top 10 products with the highest profit margin.
* Assuming that the total revenue is equivalent to sales and all costs are already accounted for in the *Cost* column of the *products* table:
Profit Margin = Sales - Cost of Goods Solds / Sales \
Profit Margin = Price *x* Quantity  - Cost *x* Quantity / Price *x* Quantity \
Profit Margin = Quantity *x* (Price-Cost)/ Quantity *x* Price \
Profit Margin = Price-Cost / Price
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
  <img width="400" alt="profit_margin" src="https://github.com/emcaboles/global-sales/assets/160221619/9ad8fc00-fe9b-4464-8a7e-09c6456a0ab2">

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
  <img width="450" alt="Query_4_results" src="https://github.com/emcaboles/global-sales/assets/160221619/abd57462-bba5-466f-9e4f-9720eb6d7647">
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
  <img width="400" alt="Query_6_results" src="https://github.com/emcaboles/global-sales/assets/160221619/97a7634a-47c8-4707-ae04-4de4666eefae">
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
  <img width="250" alt="Query_7_results" src="https://github.com/emcaboles/global-sales/assets/160221619/0494616f-55c7-4b19-bb72-c71a3f2db868">
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
  <img width="400" alt="Query_8_results" src="https://github.com/emcaboles/global-sales/assets/160221619/cb314275-c7a0-45cc-9f61-440706d4dcec">
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
  <img width="500" alt="Query_9_results" src="https://github.com/emcaboles/global-sales/assets/160221619/e1b682f3-6aab-4f17-9e41-e31e609843b0">
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
  <img width="350" alt="Query_10_results" src="https://github.com/emcaboles/global-sales/assets/160221619/91d107c4-ba17-4c34-9170-6ec029697513">
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
 <img width="400" alt="Query_11_results" src="https://github.com/emcaboles/global-sales/assets/160221619/e654ad33-3c01-4c63-9c47-4a4a6866897e">

</details>

## ETL and Visualization (Power Query, Power BI)
[back to top](https://github.com/emcaboles/global-sales?tab=readme-ov-file#global-online-store-sales-analysis)

### Extract, Transform, Load with Power Query
#### Extraction
To avoid enlarging the semantic model, only pertinent tables were loaded. SQL queries were also used to reduce the number of columns loaded in the model and to push most of the data transformation upstream.

The following queries used are as follows:

1. Customers Table
```sql
SELECT
	CustomerID,
	CustomerName,
	City,
	Country,
	CASE
		WHEN Country IN ('USA', 'Canada', 'Mexico') THEN 'North America'
		WHEN Country IN ('Brazil', 'Venezuela', 'Argentina') THEN 'South America'
		ELSE  'Europe'
	END AS Continent
FROM customers
```
2. Employees Table
```sql
SELECT
	EmployeeID,
	CONCAT_WS(' ', FirstName, LastName) AS 'FullName'
FROM employees
```
To track the dates, a rolling calendar was created using the following formula:
```PHP
List.Dates(
Source,
Number.From(DateTime.LocalNow()) - Number.From(Source),
#duration(1,0,0,0)
)
```
#### Transformation
For the 2024 sales data, the *orders* and *ordersdetails* excel files were loaded to Power Query and then appended with their database table counterparts.

![append_1](https://github.com/emcaboles/global-sales/assets/160221619/51038f93-9e59-484d-ba45-cf1b6d609c3f)

![append_2](https://github.com/emcaboles/global-sales/assets/160221619/dff07be6-3019-4f00-a0f3-f0f8d93f7420)

#### Loading
After transforming the data and making sure that all columns have proper data types, the tables were loaded to Power BI and connected in the Model View.

![model_1](https://github.com/emcaboles/global-sales/assets/160221619/c58df8d7-5925-4114-8e7d-46791b9ec6f8)

### Power BI Report
Since the Sales Department is interested in checking the YTD, QTD, MTD Sales, a DAX table was created to filter the rolling calendar table by YTD, QTD, and MTD.

```PHP
VAR TodayDate=TODAY()
VAR YearStart=
	CALCULATE(
		STARTOFYEAR(fOrders_app[OrderDate]),
		YEAR(fOrders_app[OrderDate]) = YEAR(TodayDate)
		)

VAR QuarterStart=
	CALCULATE(
		STARTOFQUARTER(fOrders_app[OrderDate]),
		YEAR(fOrders_app[OrderDate]) = YEAR(TodayDate),
		QUARTER(fOrders_app[OrderDate]) = QUARTER(TodayDate)
	)

VAR MonthStart=
	CALCULATE(
		STARTOFMONTH(fOrders_app[OrderDate]),
		YEAR(fOrders_app[OrderDate]) = YEAR(TodayDate),
		QUARTER(fOrders_app[OrderDate]) = QUARTER(TodayDate),
		MONTH(fOrders_app[OrderDate]) = MONTH(TodayDate)
	)

VAR Result=
	UNION(
		ADDCOLUMNS(
			CALENDAR(YearStart,TodayDate),
			"Selection", "YTD",
			"Order",1
			),
		ADDCOLUMNS(
			CALENDAR(QuarterStart,TodayDate),
			"Selection", "QTD",
			"Order",2
			),
		ADDCOLUMNS(
			CALENDAR(MonthStart,TodayDate),
			"Selection", "MTD",
			"Order",3
			)
	)

RETURN Result
```
After creating the period DAX table, it was connected to the rolling calendar table. Hence, the final model is illustrated below.

![model_2](https://github.com/emcaboles/global-sales/assets/160221619/d6bb92f9-aa67-4c6d-b8ff-d3b0509feff6)


Three pages were created for the Sales Department's dashboard. The first page was dedicated to provide an overview of the business. The second page displayed the Sales Agents' Metrics while the third page showed the possibile outliers in the data using Power BI's built-in Anomaly Detection feature.

![Sales_Page](https://github.com/emcaboles/global-sales/assets/160221619/dfee1a65-f80c-4643-9393-97008433b99f)

![Agent_Page](https://github.com/emcaboles/global-sales/assets/160221619/7643502b-eb4c-4626-9e4e-6debfe1a76c8)

![DA_Page](https://github.com/emcaboles/global-sales/assets/160221619/7e504896-fc40-4b19-8463-3269284b808c)

DAX measures were used to calculate for the metrics and KPI's requested by the sales department.

![image](https://github.com/emcaboles/global-sales/assets/160221619/6532c4cf-caa0-45d3-9f65-3d8162ef1985)


For the complete dashboard and DAX formulas used, please refer to the attached pbix and text files, respectively. Alternatively, the dashboard can be accessed via this [link](https://app.powerbi.com/view?r=eyJrIjoiMDlkYTMzZTgtMjFmZi00NGFkLWJjMGQtNzQ4ZmY0MjI0NmM4IiwidCI6ImRmODY3OWNkLWE4MGUtNDVkOC05OWFjLWM4M2VkN2ZmOTVhMCJ9).

## Data Analysis
[back to top](https://github.com/emcaboles/global-sales?tab=readme-ov-file#global-online-store-sales-analysis)

Power BI detected 12 possible outliers based on the daily expected sales value.

![image](https://github.com/emcaboles/global-sales/assets/160221619/eac9ff5e-05e9-4754-a82d-7a5b0268985e)

To allow users to check as to why certain points were considered outliers, product and customer tables were placed in the report so that users can drill down the contribution of each product and customer in terms of sales.

For example, selecting the first anomaly point which occurred on the 8th of October, it can be seen product *Thüringer Rostbratwurst* accounted for 43.89% of the daily sales and that units sold and sales for this product increased by 82% and 86%, respectively, compared to previous dates.

![bratwurts_1](https://github.com/emcaboles/global-sales/assets/160221619/14fdc498-45c8-4f2f-be9e-69779f56d777)

Furthermore, cross-filtering the customer table, it can be seen that customer *Save-a-lot Markets*, who has never bought *Thüringer Rostbratwurst* before, bought 31 units of the products, suggesting that there may be an increased demand for it. This is also supported by *Thüringer Rostbratwurst*'s  increasing daily sales trend, which is illustrated in the same page or via drill-through to the Sales Page.

![bratwurts_2](https://github.com/emcaboles/global-sales/assets/160221619/a81686c7-bf58-446f-9514-b3ff4bea4df5)

![bratwurts_3](https://github.com/emcaboles/global-sales/assets/160221619/a88a0c29-3faa-479e-b300-8dc48fa0faae)

![bratwurts_4](https://github.com/emcaboles/global-sales/assets/160221619/a1b7b8c5-bcfc-4db4-bbe7-2dc4c54f3fba)

However, it is worth noting that if there were no marketing campaigns made to push *Thüringer Rostbratwurst* to be sold to customers, there may be a need to check the sales invoices and records of customers who suddenly bought items they have never purchased before.

Finally, to aid the Sales Department in creating an overview of the daily sales, a dynamic *Sales and Product Analysis* section was added in the report page.

![bratwurts_5](https://github.com/emcaboles/global-sales/assets/160221619/b18d6f97-91b4-4b28-b082-e07f8877d3c4)
<!---

## References
[back to top](https://github.com/emcaboles/global-sales?tab=readme-ov-file#global-online-store-sales-analysis)

## Extras
[back to top](https://github.com/emcaboles/global-sales?tab=readme-ov-file#global-online-store-sales-analysis)
-->
