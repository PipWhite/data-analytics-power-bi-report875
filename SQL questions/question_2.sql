SELECT 
    SUM(sale_price * product_quantity) AS revenue,
CASE
    WHEN order_date LIKE '2022-01%' THEN 'Jan'
    WHEN order_date LIKE '2022-02%' THEN 'Feb'
    WHEN order_date LIKE '2022-03%' THEN 'Mar'
    WHEN order_date LIKE '2022-04%' THEN 'Apr'
    WHEN order_date LIKE '2022-05%' THEN 'May'
    WHEN order_date LIKE '2022-06%' THEN 'Jun'
    WHEN order_date LIKE '2022-07%' THEN 'Jul'
    WHEN order_date LIKE '2022-08%' THEN 'Aug'
    WHEN order_date LIKE '2022-09%' THEN 'Sep'
    WHEN order_date LIKE '2022-10%' THEN 'Oct'
    WHEN order_date LIKE '2022-11%' THEN 'Nov'
    WHEN order_date LIKE '2022-12%' THEN 'Dec'
    ELSE 'unkown'
END AS month 
FROM 
    orders
Join 
    dim_product
ON
    orders.product_code = dim_product.product_code
WHERE
    orders.order_date LIKE '2022%'
GROUP BY
    month 
ORDER BY
    revenue desc;