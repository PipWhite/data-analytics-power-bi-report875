SELECT 
    SUM(staff_numbers) AS number_of_staff_in_UK
FROM 
    dim_store
WHERE
    country_code = 'GB'