SELECT
    TABLE_NAME
FROM
   information_schema.TABLES;

/* finding the table column names */
SELECT
    COLUMN_NAME
FROM
    information_schema.COLUMNS
WHERE
    table_schema = 'public'
AND
    TABLE_NAME = 'orders'

SELECT
    COLUMN_NAME
FROM
    information_schema.COLUMNS
WHERE
    table_schema = 'public'
AND
    TABLE_NAME = 'dim_customer'

SELECT
    COLUMN_NAME
FROM
    information_schema.COLUMNS
WHERE
    table_schema = 'public'
AND
    TABLE_NAME = 'dim_date'

SELECT
    COLUMN_NAME
FROM
    information_schema.COLUMNS
WHERE
    table_schema = 'public'
AND
    TABLE_NAME = 'dim_product'

SELECT
    COLUMN_NAME
FROM
    information_schema.COLUMNS
WHERE
    table_schema = 'public'
AND
    TABLE_NAME = 'dim_store'



