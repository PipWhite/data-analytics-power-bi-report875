
CREATE VIEW view_2 AS
SELECT
    store_type,
    SUM(product_quantity) AS total_sales,
    COUNT(order_date_uuid) AS count_of_orders,
    (product_quantity / SUM(product_quantity)) * 100 AS percentage_of_total_sales
FROM
    dim_store
JOIN
    orders
ON
    dim_store.store_code = orders.store_code
GROUP BY
    store_type,
    product_quantity;


SELECT 
    store_type,
    SUM(total_sales) AS total_sales,
    SUM(count_of_orders) AS count_of_orders
FROM
    view_2
GROUP BY
    store_type;


