Select 
    SUM(dim_product.sale_price * product_quantity) AS revenue,
    store_type
From
    dim_store
Join 
    orders
ON
    orders.store_code = dim_store.store_code
JOIN
    dim_product
ON
    orders.product_code = dim_product.product_code
WHERE
    dim_store.country_code = 'DE'
AND
    orders.order_date LIKE '2022%'
GROUP BY
    store_type
ORDER BY
    store_type DESC