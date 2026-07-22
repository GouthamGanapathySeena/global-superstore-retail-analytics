WITH customer_performance AS (
    SELECT
        `Customer_ID` AS customer_id,
        SUM(`Sales`) AS total_sales,
        SUM(`Profit`) AS total_profit
    FROM orders
    GROUP BY `Customer_ID`
),ranked_customers AS (
    SELECT
        customer_id,
        total_sales,
        total_profit,
        ROW_NUMBER() OVER (
            ORDER BY total_profit DESC, customer_id
        ) AS profit_rank,
        COUNT(*) OVER () AS total_customers,
        SUM(total_sales) OVER () AS overall_sales,
        SUM(total_profit) OVER () AS overall_profit
    FROM customer_performance
),
customer_groups AS (
    SELECT
        customer_id,
        total_sales,
        total_profit,
        total_customers,
        overall_sales,
        overall_profit,
        CASE
            WHEN profit_rank <= CEIL(total_customers * 0.20)
                THEN 'Top 20% Customers'
            ELSE 'Remaining 80% Customers'
        END AS customer_group
    FROM ranked_customers
)SELECT
    customer_group AS `Customer Group`,
    COUNT(*) AS `Number of Customers`,
    ROUND(
        COUNT(*) * 100.0 /
        NULLIF(MAX(total_customers), 0),
        2
    ) AS `Percentage of Customers`,
    ROUND(SUM(total_sales), 2)
        AS `Total Sales`,
    ROUND(
        SUM(total_sales) * 100.0 /
        NULLIF(MAX(overall_sales), 0),
        2
    ) AS `Percentage of Total Sales`,
    ROUND(SUM(total_profit), 2)
        AS `Total Profit`,
    ROUND(
        SUM(total_profit) * 100.0 /
        NULLIF(MAX(overall_profit), 0),
        2
    ) AS `Percentage of Total Profit`,
    ROUND(
        SUM(total_profit) * 100.0 /
        NULLIF(SUM(total_sales), 0),
        2
    ) AS `Profit Margin Percentage`,
    ROUND(
        AVG(total_profit),
        2
    ) AS `Average Profit per Customer`
FROM customer_groups
GROUP BY customer_group
ORDER BY
    CASE
        WHEN customer_group = 'Top 20% Customers' THEN 1
        ELSE 2
    END;
