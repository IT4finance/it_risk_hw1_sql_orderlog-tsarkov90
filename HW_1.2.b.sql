-- Осмысленный запрос GROUP BY, HAVING, DATE

SELECT issuer, COUNT(DISTINCT(isin)) distinct_isin_count, AVG(coupon) avg_coup, AVG(ytm_ind) ytm_avg, AVG(days_to_maturity)/365 avg_years_to_m 
FROM bond_quotes 
WHERE to_date(LEFT(date_trading,10), 'DD.MM.YYYY') + (days_to_maturity * interval '1 day') > to_date('01.12.2021', 'DD.MM.YYYY') -- условие непогашенности облигаций
GROUP BY issuer 
HAVING AVG(coupon) > 0.07 
ORDER BY AVG(coupon) DESC

-- Показывает банки с самой высокой купонной доходностью, количество их ISIN, средняя купонная доходность по ним и средний ytm.
-- Может понадобиться, чтобы найти компании для дальнейшего, более подробного анализа ее выпусков облигаций. 
-- Также облигации непогашены 