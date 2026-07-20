-- Overall Business Performance KPIs
-- Calculates key indicators for the period 2011–2014,
-- including sales, profit, customers, orders, shipping and returns.
SELECT
  FORMAT(SUM(Sales),2) as 'Total Sales',
  FORMAT(SUM(Profit),2) AS 'Total Profit',
  CONCAT(ROUND(SUM(Profit) / SUM(Sales) * 100,2),'%') AS 'Profit Margin',
  FORMAT(COUNT(DISTINCT Order_ID),0) AS 'Total Orders',
  FORMAT(COUNT(DISTINCT Customer_ID),0) AS 'Total Customers',
  FORMAT(SUM(Quantity),0) AS 'Total Quantity Sold',
  ROUND(SUM(Sales) / COUNT(DISTINCT Order_ID),2) AS 'Average Order Value',
  CONCAT(ROUND(AVG(Discount)*100,2),'%') AS 'Average Discount',
  FORMAT(SUM(Shipping_Cost),2) AS 'Total Shipping Cost',
  CONCAT(ROUND(AVG(Shipping_Duration),0),' Days') AS 'Average Shipping Duration',
  (SELECT FORMAT(COUNT(DISTINCT Order_ID),0) FROM returns) AS 'Returned Orders',
  CONCAT(ROUND((SELECT COUNT(DISTINCT r.Order_ID)FROM returns r) * 100.0/ COUNT(DISTINCT Order_ID),2),'%') AS `Return Rate`
FROM
  orders;
