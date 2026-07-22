WITH order_shipments AS (
    SELECT
        `Order_ID`,
        `Market`,

        SUM(`Quantity`) AS total_quantity,
        SUM(`Sales`) AS order_sales,
        SUM(`Profit`) AS order_profit,
        AVG(`Discount`) AS average_discount

    FROM orders

    GROUP BY
        `Order_ID`,
        `Market`
),

discount_bands AS (
    SELECT
        *,

        CASE
            WHEN average_discount = 0
                THEN 'No Discount'

            WHEN average_discount <= 0.10
                THEN 'Low Discount (0-10%)'

            WHEN average_discount <= 0.20
                THEN 'Medium Discount (10-20%)'

            ELSE 'High Discount (Above 20%)'
        END AS discount_band

    FROM order_shipments
)

SELECT
    discount_band AS `Discount Band`,

    COUNT(*) AS `Order Shipments`,

    ROUND(AVG(total_quantity), 2)
        AS `Average Quantity`,

    ROUND(AVG(average_discount) * 100, 2)
        AS `Average Discount Percentage`,

    ROUND(SUM(order_sales), 2)
        AS `Total Sales`,

    ROUND(SUM(order_profit), 2)
        AS `Total Profit`,

    ROUND(
        SUM(order_profit) /
        NULLIF(SUM(order_sales), 0) * 100,
        2
    ) AS `Profit Margin Percentage`,

    ROUND(AVG(order_profit), 2)
        AS `Average Profit per Shipment`,

    ROUND(
        SUM(
            CASE
                WHEN order_profit < 0 THEN 1
                ELSE 0
            END
        ) / COUNT(*) * 100,
        2
    ) AS `Loss-Making Shipment Rate`

FROM discount_bands

GROUP BY discount_band

ORDER BY FIELD(
    discount_band,
    'No Discount',
    'Low Discount (0-10%)',
    'Medium Discount (10-20%)',
    'High Discount (Above 20%)'
);
