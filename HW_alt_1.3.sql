WITH t1 AS(SELECT isin, issuer, date_trading, bid_price bid_last 
           FROM (SELECT isin, issuer, date_trading, bid_price, trade_regime,days_to_maturity, 
                 row_number() over(partition by isin order by to_date(left(date_trading,10), 'DD.MM.YYYY') desc) as rn 
                 from bond_quotes where bid_price is not null) as T 
           where rn = 1 
           AND (to_date(left(date_trading,10), 'DD.MM.YYYY') <= to_date('20.11.2020', 'DD.MM.YYYY')) 
           AND to_date(LEFT(date_trading,10), 'DD.MM.YYYY') + (days_to_maturity * interval '1 day') > to_date('01.12.2021', 'DD.MM.YYYY')), 
      t2 AS (SELECT T2.number_of_trades, T2.isin, T2.issuer, T2.date_trading, T2.ask_price ask_previous, T2.bid_price 
             FROM (SELECT number_of_trades, isin, issuer, date_trading, bid_price,ask_price, trade_regime,days_to_maturity, row_number() over(partition by bid_price order by to_date(left(date_trading,10), 'DD.MM.YYYY') desc) as rn1 
                   from bond_quotes where bid_price is not null) as T2 
             JOIN t1 ON t1.issuer = T2.issuer 
             where rn1 = 2 AND (to_date(left(t2.date_trading,10), 'DD.MM.YYYY') <= to_date('20.11.2020', 'DD.MM.YYYY')) 
             AND (to_date(left(t1.date_trading,10), 'DD.MM.YYYY') + (1 * interval '1 day') = to_date(left(t2.date_trading,10), 'DD.MM.YYYY') 
                  OR to_date(left(t1.date_trading,10), 'DD.MM.YYYY') + (2 * interval '1 day') = to_date(left(t2.date_trading,10), 'DD.MM.YYYY') 
                  OR to_date(left(t1.date_trading,10), 'DD.MM.YYYY') + (3 * interval '1 day') = to_date(left(t2.date_trading,10), 'DD.MM.YYYY') 
                  OR to_date(left(t1.date_trading,10), 'DD.MM.YYYY') + (4 * interval '1 day') = to_date(left(t2.date_trading,10), 'DD.MM.YYYY') 
                  OR to_date(left(t1.date_trading,10), 'DD.MM.YYYY') + (5 * interval '1 day') = to_date(left(t2.date_trading,10), 'DD.MM.YYYY')) 
             AND t2.number_of_trades IS NOT NULL -- условие проводимых сделок
             AND to_date(LEFT(t2.date_trading,10), 'DD.MM.YYYY') + (days_to_maturity * interval '1 day') > to_date('01.12.2021', 'DD.MM.YYYY')) \
SELECT t1.isin, t1.bid_last, t2.ask_previous, (t1.bid_last - t2.bid_price)/t1.bid_last avg_change 
FROM t1 
JOIN t2 ON t1.isin = t2.isin AND t1.issuer = t2.issuer 
JOIN bond_quotes b ON t1.isin = b.isin AND t1.issuer = b.issuer 
WHERE b.trade_regime LIKE '%' --можно заменить на равно конкретному значению

-- а. создаю таблицу из для bid_last с помощью row_number, где беру нужную первую строку по отсортированной дате (самую недавнюю)
-- б. создаю таблицу для ask_previous с помощью row_number, где беру вторую строку (по условию ближайшая предшествующей котировке)
-- условие не позднее 5 дней с помощью where и or (повторения можно выбросить через not)
-- прирост посчитан как разница между первым и последним значением

