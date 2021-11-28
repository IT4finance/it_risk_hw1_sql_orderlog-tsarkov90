-- GROUP BY, HAVING, преобразования поля с типом DATE/TIME.
-- Средний объем сделки на компанию по часам
-- с ограничением, что суммарный объем сделок больше 1 000 000

SELECT
    (order_time / 10000000) as order_hour,
    security_code,
    sum(volume) / count(trade_no) as avg_volume
FROM stock_orders
WHERE action = 2 and buysell = 'B'
GROUP BY order_hour, security_code
HAVING sum(volume) > 1000000;
