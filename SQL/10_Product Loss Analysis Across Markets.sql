WITH product_market_performance AS (
    SELECT
        `Product_ID`,
        MAX(`Product_Name`) AS product_name,
        `Market`,
        COUNT(*) AS transaction_lines,
        ROUND(SUM(`Sales`), 2) AS market_sales,
        ROUND(SUM(`Profit`), 2) AS market_profit,
        ROUND(AVG(`Discount`) * 100, 2) AS average_discount_percentage
    FROM orders
    GROUP BY
        `Product_ID`,
        `Market`
),
product_summary AS (
    SELECT
        `Product_ID`,
        MAX(product_name) AS product_name,
        SUM(transaction_lines) AS total_transaction_lines,
        COUNT(*) AS markets_sold,
        SUM(
            CASE
                WHEN market_profit < 0 THEN 1
                ELSE 0
            END
        ) AS loss_making_markets,
        ROUND(SUM(market_sales), 2) AS total_sales,
        ROUND(SUM(market_profit), 2) AS total_profit,
        ROUND(
            SUM(market_profit) /
            NULLIF(SUM(market_sales), 0) * 100,
            2
        ) AS profit_margin_percentage,
        ROUND(
            SUM(
                average_discount_percentage * transaction_lines
            ) /
            NULLIF(SUM(transaction_lines), 0),
            2
        ) AS average_discount_percentage
    FROM product_market_performance
    GROUP BY `Product_ID`
)
SELECT
    `Product_ID` AS `Product ID`,
    product_name AS `Product Name`,
    total_transaction_lines AS `Transaction Lines`,
    markets_sold AS `Markets Sold`,
    loss_making_markets AS `Loss-Making Markets`,
    total_sales AS `Total Sales`,
    total_profit AS `Total Profit`,
    profit_margin_percentage AS `Profit Margin Percentage`,
    average_discount_percentage AS `Average Discount Percentage`
FROM product_summary
WHERE
    total_profit < 0
    AND loss_making_markets >= 2
    AND total_transaction_lines >= 5
ORDER BY total_profit ASC;
