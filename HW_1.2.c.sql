WITH nt AS (SELECT MAX(bid_price) - MIN(bid_price) bid_chng, issuer 
            FROM bond_quotes 
            WHERE ytm_ind IS NOT NULL 
            AND to_date(date_trading, 'DD.MM.YYYY') BETWEEN to_date('10.11.2018','DD.MM.YYYY') AND to_date('10.11.2019','DD.MM.YYYY') -- чтобы понять изменения в bid_prict за год 
            AND ytm_ind > 0.08 
            GROUP BY issuer) 
SELECT nt.issuer, b.bid_price, b.date_trading, b.isin, b.ytm_ind 
FROM nt 
JOIN bond_quotes b 
ON nt.issuer = b.issuer 
WHERE (bid_price IS NOT NULL 
       AND ytm_ind IS NOT NULL 
       AND to_date(LEFT(date_trading,10), 'DD.MM.YYYY') + (days_to_maturity * interval '1 day') > to_date('01.12.2021', 'DD.MM.YYYY')
       AND to_date(date_trading, 'DD.MM.YYYY') BETWEEN to_date('10.11.2020','DD.MM.YYYY') AND to_date('20.11.2020','DD.MM.YYYY') 
       AND nt.bid_chng < 5) -- условие неволатильности
ORDER BY date_trading DESC

-- таблица дает данные торгов за последние десять дней самых неволатильных компаний
-- нужна, чтобы понять облигации каких компаний покупались в последние 10 дней
-- неволатильность определяется изменением bid_ask менее чем на 5 пунктов за год
-- показана доходность к погашению, чтобы учитывать ее при выборе выпуска
-- указаны isin 