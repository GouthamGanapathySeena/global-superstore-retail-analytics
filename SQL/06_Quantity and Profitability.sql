WITH order_shipments AS (
    SELECT
        `Order_ID`,
        `Market`,

        SUM(`Quantity`) AS total_quantity,
        SUM(`Sales`) AS order_sales,
        SUM(`Profit`) AS order_profit,
        AVG(`Discount`) AS average_discount,
        SUM(`Shipping_Cost`) AS order_shipping_cost,

        MAX(`Shipping_Duration`) AS shipping_duration

    FROM orders

    GROUP BY
        `Order_ID`,
        `Market`
),

quantity_bands AS (
    SELECT
        *,

        CASE
            WHEN total_quantity BETWEEN 1 AND 3
                THEN 'Small (1-3)'

            WHEN total_quantity BETWEEN 4 AND 6
                THEN 'Medium (4-6)'

            WHEN total_quantity BETWEEN 7 AND 10
                THEN 'Large (7-10)'

            ELSE 'Very Large (11+)'
        END AS quantity_band

    FROM order_shipments
)

SELECT
    quantity_band AS `Quantity Band`,

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

    ROUND(SUM(order_shipping_cost), 2)
        AS `Total Shipping Cost`,

    ROUND(AVG(order_shipping_cost), 2)
        AS `Average Shipping Cost per Shipment`,

    ROUND(
        SUM(order_shipping_cost) /
        NULLIF(SUM(order_sales), 0) * 100,
        2
    ) AS `Shipping Cost Percentage`,

    ROUND(AVG(shipping_duration), 2)
        AS `Average Shipping Duration`,

    ROUND(
        SUM(
            CASE
                WHEN order_profit < 0 THEN 1
                ELSE 0
            END
        ) / NULLIF(COUNT(*), 0) * 100,
        2
    ) AS `Loss-Making Shipment Rate`

FROM quantity_bands

GROUP BY quantity_band

ORDER BY FIELD(
    quantity_band,
    'Small (1-3)',
    'Medium (4-6)',
    'Large (7-10)',
    'Very Large (11+)'
);
