--  Создать таблицу
DROP TABLE IF EXISTS public.stock_orders;

CREATE TABLE public.stock_orders
(
    no bigint NOT NULL, -- в таблице 15 123 693 строк
    security_code varchar(20),
    buysell char(1),
    order_time int, -- 10:00:00.000
    order_no bigint NOT NULL,
    action smallint, -- 0/1/2
    price numeric(15, 6), -- 6 знаков после запятой точно, перед запятой было 6, но я сделал больше
    volume bigint,
    trade_no bigint,
    trade_price numeric(15, 6)
)
WITH (
    OIDS=FALSE
)
TABLESPACE pg_default;

ALTER TABLE public.stock_orders
        OWNER to postgres;

-- На всякий случай изменить формат даты для Маков
ALTER DATABASE postgres SET datestyle TO "ISO, DMY";         

-- Загрузить данные
\copy public.stock_orders FROM 'C:/Users/Public/OrderLog20151123.csv' DELIMITER ',' CSV HEADER;