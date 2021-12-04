-- Осмысленный запрос DISTINCT WHERE ORDER BY 

SELECT issuer, COUNT(DISTINCT(isin)) isin_count, AVG(ABS(g_spread_interpolated)) avg_g_spread,avg(coupon) avg_coup, currency 
FROM bond_quotes 
WHERE state_bank = 'False' 
AND to_date(LEFT(date_trading,10), 'DD.MM.YYYY') + (days_to_maturity * interval '1 day') > to_date('01.12.2021', 'DD.MM.YYYY') -- условие непогашенности облигаций 
GROUP BY issuer, currency, state_bank ORDER BY avg_g 

-- все негосударственные банки с наименьшим g_spread (то есть наименьшей рискованностью)
-- также есть поле доходность к погашению, количество выпусков облигаций и валюта, в которой они выпущены
-- данная таблица может пригодиться для того, чтобы найти частные компании с наименьшим риском и наибольшей доходностьюdemo

-- недостатки: там, где isin_count больше одного, надо отдельно рассматривать компанию, чтобы понять, какой выпуск выгоднееdemo