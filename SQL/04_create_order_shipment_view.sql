-- Creates an order-shipment-level analytical view.
-- Each row represents one Order ID, Market,
-- Ship Mode and Order Priority combination.

CREATE OR REPLACE VIEW vw_order_shipment_analysis AS

SELECT
    CONCAT_WS(
        '|',
        Order_ID,
        Market,
        Ship_Mode,
        Order_Priority
    ) AS Order_Shipment_Key,

    Order_ID,
    Market,
    Ship_Mode,
    Order_Priority,

    MIN(Order_Date) AS Order_Date,
    MAX(Ship_Date) AS Ship_Date,

    MAX(Customer_ID) AS Customer_ID,
    MAX(Customer_Name) AS Customer_Name,
    MAX(Segment) AS Segment,
    MAX(Country) AS Country,
    MAX(Region) AS Region,

    COUNT(DISTINCT Row_ID) AS Line_Item_Count,
    COUNT(DISTINCT Product_ID) AS Distinct_Product_Count,

    SUM(Quantity) AS Total_Quantity,

    ROUND(SUM(Sales), 2) AS Total_Sales,
    ROUND(SUM(Profit), 2) AS Total_Profit,
    ROUND(SUM(Shipping_Cost), 2) AS Total_Shipping_Cost,

    ROUND(AVG(Discount) * 100, 2) AS Average_Discount_Percentage,

    ROUND(AVG(Shipping_Duration), 2) AS Average_Shipping_Duration,

    ROUND(SUM(Profit) / NULLIF(SUM(Sales), 0) * 100,2) AS Profit_Margin_Percentage,

    ROUND(SUM(Shipping_Cost) / NULLIF(SUM(Sales), 0) * 100, 2) AS Shipping_Cost_Percentage,

    ROUND(SUM(Shipping_Cost) / NULLIF(SUM(Quantity), 0),2) AS Shipping_Cost_Per_Unit,

    ROUND(SUM(Profit) / NULLIF(SUM(Shipping_Cost), 0),2 ) AS Profit_To_Shipping_Cost_Ratio

FROM orders

GROUP BY
    Order_ID,
    Market,
    Ship_Mode,
    Order_Priority;
