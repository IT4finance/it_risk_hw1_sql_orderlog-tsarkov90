-- я предпочел задать две переменные
WITH constants(security_type, input_time) AS (
    VALUES('bond', -- preferred, -- common
           120000000)
)
SELECT *
FROM stock_orders, constants
WHERE order_time < input_time
ORDER BY order_time desc