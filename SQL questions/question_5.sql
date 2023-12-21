SELECT
    category,
    SUM((dim_product.sale_price - dim_product.cost_price) * product_quantity) AS profit
FROM
    dim_store
JOIN
    orders
ON
    orders.store_code = dim_store.store_code
JOIN
    dim_product
ON
    dim_product.product_code = orders.product_code
WHERE
    full_region = 'Wiltshire, UK'
AND
    orders.order_date LIKE '2021%'
GROUP BY
    category
ORDER BY
    category DESC

    