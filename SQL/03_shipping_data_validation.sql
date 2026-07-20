-- Checks whether the same Order ID and Market contain
-- multiple shipping modes or order-priority levels.

SELECT Order_ID,Market,
    COUNT(DISTINCT Ship_Mode) AS Ship_Modes,
    COUNT(DISTINCT Order_Priority) AS Priority_Levels
FROM orders
GROUP BY
    Order_ID,Market
HAVING
    COUNT(DISTINCT Ship_Mode) > 1
    OR COUNT(DISTINCT Order_Priority) > 1;
