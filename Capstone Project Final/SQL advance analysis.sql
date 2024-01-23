-- Pratik Sapkal


-- Total Sales per month

select year(orderDate) as order_year,
month(orderDate) as order_month,
sum(quantityOrdered * priceEach) as total_sales
from orders
join orderdetails using (orderNumber)
group by order_year,order_month
order by order_year, order_month;

-- Average Sales per month

select year(orderDate) as order_year,
month(orderDate) as order_month,
avg(quantityOrdered * priceEach) as avg_sales
from orders
join orderdetails using (orderNumber)
group by order_year,order_month
order by order_year, order_month;

-- Average Sales per product line

select distinct productLine,
avg(MSRP - buyPrice) as profit
from productlines
join products using (productLine)
group by productLine;

-- Top selling product

select productCode, productLine,
productName, 
sum(quantityOrdered * priceEach) as total_sales
from products
join orderdetails using(productCode)
group by productCode
order by total_sales desc;

-- Countries with highest spending

select country,
count(orderNumber) as No_of_orders,
avg(quantityOrdered * priceEach) as avg_spent
from orderdetails
join orders using(orderNumber)
join customers using(customerNumber)
group by country
order by avg_spent desc;

-- Top selling products with avg profit margin 
SELECT
    productline as Product_line,
    productName as Product_name,
    productCode as Product_code,
    count(orderNumber) as no_of_orders,
    ROUND(AVG(buyPrice), 2) AS Avg_BuyPrice,
    ROUND(AVG(MSRP), 2) AS Avg_MSRP,
    ROUND(AVG(MSRP - buyPrice), 2) AS Avg_ProfitMargin
FROM
    Products
join orderdetails using(productCode)
GROUP BY
    productCode
ORDER BY
    no_of_orders desc;
    
-- Countries and their top selling cities 
SELECT
    city,
    country,
    SUM(quantityOrdered * priceEach) AS TotalSales
FROM
    Customers
JOIN
    Orders ON Customers.customerNumber = Orders.customerNumber
JOIN
    OrderDetails ON Orders.orderNumber = OrderDetails.orderNumber
GROUP BY
    city, country
ORDER BY
    TotalSales DESC;

-- cities and their top selling product
Select 
city,
country,
max(productName) as top_product,
count(orderdetails.productCode) as no_of_orders,
SUM(quantityOrdered * priceEach) AS TotalSales
from customers
join 
	orders using(customerNumber)
join 
	orderdetails using(orderNumber)
join 
	products using(productCode)
group by
	city, country
order by totalSales;

-- Average processing time
SELECT
    AVG(DATEDIFF(shippedDate, orderDate)) AS AverageProcessingTime
FROM
    Orders;

-- customers with maximum order and their last order date.
SELECT
    customerNumber,
    COUNT(DISTINCT orderNumber) AS TotalOrders,
    MAX(orderDate) AS LastOrderDate
FROM
    Orders
GROUP BY
    customerNumber
ORDER BY
    TotalOrders DESC;

-- products that are frequently purchased together.

SELECT
    od1.productCode AS Product1,
    od2.productCode AS Product2,
    COUNT(*) AS Occurrences
FROM
    OrderDetails AS od1
JOIN
    OrderDetails AS od2 ON od1.orderNumber = od2.orderNumber
WHERE
    od1.productCode < od2.productCode
GROUP BY
    Product1, Product2
ORDER BY
    Occurrences DESC;


-- CustomerSalesSummary ;

CREATE VIEW CustomerSalesSummary AS
SELECT
    C.customerNumber,
    C.customerName,
    SUM(OD.quantityOrdered * OD.priceEach) AS TotalPurchases
FROM
    Customers AS C
JOIN
    Orders AS O ON C.customerNumber = O.customerNumber
JOIN
    OrderDetails AS OD ON O.orderNumber = OD.orderNumber
GROUP BY
    C.customerNumber, C.customerName;
    
select * from customersalessummary;

-- MonthlySales CTE

with MonthlySales as(
select month(orderDate) as ordermonth,
SUM(OD.quantityOrdered * OD.priceEach) AS TotalPurchases
from orders o
join orderdetails od using(orderNumber)
group by ordermonth)
select ordermonth, TotalPurchases 
from monthlysales
order by ordermonth;



