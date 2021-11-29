-- WITH, JOIN.
-- Определение типа сделки (покупка или продажа)
with buys AS (
    SELECT
        security_code,
        order_no,
        order_time,
        price,
        trade_no,
        trade_price
    FROM public.stock_orders
    WHERE buysell = 'B'
        AND action = 2
),
sells AS (
    SELECT
        security_code,
        order_no,
        order_time,
        price,
        trade_no,
        trade_price
    FROM public.stock_orders
    WHERE buysell = 'S'
        AND action = 2
)
SELECT
    buys.security_code,
    buys.trade_no,
    buys.order_no buy_order_no,
    buys.price buy_price,
    sells.order_no sell_order_no,
    sells.price sell_price,
    buys.trade_price,

    CASE
        WHEN buys.order_no > sells.order_no THEN 'B'
        ELSE 'S'
    END trade_buysell

FROM buys JOIN sells ON
    buys.trade_no = sells.trade_no