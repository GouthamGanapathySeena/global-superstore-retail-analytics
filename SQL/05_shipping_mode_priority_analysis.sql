-- Compares shipping modes and order-priority levels
-- based on profitability, shipping expenditure
-- and shipping-cost efficiency.

SELECT
    Ship_Mode,
    Order_Priority,

    COUNT(*) AS Distinct_Orders,

    ROUND(SUM(Total_Sales), 2) AS Total_Sales,

    ROUND(SUM(Total_Profit), 2) AS Total_Profit,

    ROUND(SUM(Total_Profit) / NULLIF(SUM(Total_Sales), 0) * 100, 2) AS Profit_Margin_Percentage,

    ROUND(AVG(Total_Profit), 2) AS Average_Profit_Per_Order,

    ROUND(SUM(Total_Shipping_Cost), 2) AS Total_Shipping_Expenditure,

    ROUND(AVG(Total_Shipping_Cost), 2) AS Average_Shipping_Cost_Per_Order,

    ROUND(SUM(Total_Shipping_Cost) / NULLIF(SUM(Total_Sales), 0) * 100,2) AS Shipping_Cost_Percentage_Of_Sales,

    ROUND(SUM(Total_Shipping_Cost) / NULLIF(SUM(Total_Quantity), 0),2 ) AS Shipping_Cost_Per_Unit,

    ROUND(SUM(Total_Profit) / NULLIF(SUM(Total_Shipping_Cost), 0),2) AS Profit_To_Shipping_Cost_Ratio,

    ROUND(AVG(Average_Shipping_Duration), 2) AS Average_Shipping_Duration

FROM vw_order_shipment_analysis

GROUP BY
    Ship_Mode,
    Order_Priority

ORDER BY
    Ship_Mode,
    Order_Priority;
