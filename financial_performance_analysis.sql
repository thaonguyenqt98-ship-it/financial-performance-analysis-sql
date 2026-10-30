/*========================================================
 Section 1 - Market Overview
========================================================*/
/* Q1. How many companies are included in the dataset? */
SELECT COUNT(*) AS total_companies
FROM companies_financials;

/* Q2. How many sectors are represented? */
SELECT COUNT(DISTINCT sector) AS total_sectors
FROM companies_financials;

/* Q3. How many industries are represented? */
SELECT COUNT(DISTINCT industry) AS total_industries
FROM companies_financials;

/* Q4. Which stock exchanges have the largest number of listed companies? */
SELECT exchange, COUNT(*) AS total_companies
FROM companies_financials
GROUP BY exchange
ORDER BY total_companies DESC;

/* Q5. Which sectors contain the highest number of companies? */
SELECT sector, COUNT(*) AS total_companies
FROM companies_financials
WHERE sector IS NOT NULL
GROUP BY sector
ORDER BY total_companies DESC;

/* Q6. Which industries contain the highest number of companies? */
SELECT industry, COUNT(*) AS total_companies
FROM companies_financials
WHERE industry IS NOT NULL
GROUP BY industry
ORDER BY total_companies DESC;

/*========================================================
💰 Section 2 – Revenue Analysis 
========================================================*/
/* Q7. Which companies generate the highest revenue? */
SELECT ticker, company_name, sector, revenue_m
FROM companies_financials
WHERE revenue_m IS NOT NULL
ORDER BY revenue_m DESC;

/* Q8. Which sectors generate the highest total revenue? */
SELECT sector, SUM(revenue_m) AS total_revenue
FROM companies_financials
WHERE revenue_m IS NOT NULL
GROUP BY sector
ORDER BY total_revenue DESC;

/* Q9. Which sectors have the highest average revenue per company? */
SELECT sector, AVG(revenue_m) AS avg_revenue
FROM companies_financials
WHERE revenue_m IS NOT NULL
GROUP BY sector
ORDER BY avg_revenue DESC;

/* Q10. Which industries generate the highest average revenue? */
SELECT industry, AVG(revenue_m) AS avg_revenue
FROM companies_financials
WHERE revenue_m IS NOT NULL
GROUP BY industry
ORDER BY avg_revenue DESC;

/* Q11. Which companies generate above-average revenue but report negative net income? */
SELECT ticker, company_name, sector, revenue_m, net_income_m
FROM companies_financials
WHERE revenue_m >(SELECT AVG(revenue_m)FROM companies_financials)
AND net_income_m <0
ORDER BY revenue_m DESC;

/* Q12. Which companies have the highest revenue growth? */
SELECT ticker, company_name, sector, revenue_growth_1y_pct
FROM companies_financials
WHERE revenue_growth_1y_pct IS NOT NULL
ORDER BY revenue_growth_1y_pct DESC;

/* Q13. Which sectors have the highest average revenue growth? */
SELECT sector, AVG(revenue_growth_1y_pct) AS avg_revenue_growth
FROM companies_financials
WHERE revenue_growth_1y_pct IS NOT NULL
GROUP BY sector
ORDER BY avg_revenue_growth DESC;

/*========================================================
💰 Section 3 – Profitability Analysis
========================================================*/
/* Q14. Which companies generate the highest net income? */
SELECT ticker, company_name, sector, net_income_m
FROM companies_financials
WHERE net_income_m IS NOT NULL
ORDER BY net_income_m DESC;

/* Q15. Which sectors have the highest average net margin? */
SELECT sector, AVG(net_margin_pct) AS avg_net_margin
FROM companies_financials
WHERE net_margin_pct IS NOT NULL
GROUP BY sector
ORDER BY avg_net_margin DESC;

/* Q16. Which industries have the highest average Return on Equity (ROE)?*/
SELECT industry, AVG(roe_pct) AS avg_roe
FROM companies_financials
WHERE roe_pct IS NOT NULL
GROUP BY industry
ORDER BY avg_roe DESC;

/*Q17. Which industries have the highest average Return on Assets (ROA)?*/
SELECT industry, AVG(roa_pct) AS avg_roa
FROM companies_financials
WHERE roa_pct IS NOT NULL
GROUP BY industry
ORDER BY avg_roa DESC;

/*Q18. Which companies combine above-average revenue with above-average profit margins?*/
SELECT ticker, company_name, sector, revenue_m, net_margin_pct
FROM companies_financials
WHERE revenue_m > (
    SELECT AVG(revenue_m)
    FROM companies_financials)
AND net_margin_pct > (
    SELECT AVG(net_margin_pct)
    FROM companies_financials)
ORDER BY revenue_m DESC, net_margin_pct DESC;

/*Q19. Which companies generate positive free cash flow while reporting negative net income?*/
SELECT ticker, company_name, sector, free_cash_flow_m, net_income_m
FROM companies_financials
WHERE free_cash_flow_m > 0 AND net_income_m < 0
ORDER BY free_cash_flow_m DESC;

/*Q20. What percentage of companies are profitable?*/
SELECT ROUND(100 * SUM(CASE WHEN profitable = 'Y' THEN 1 ELSE 0 END) / COUNT(*), 2) AS profitable_percentage
FROM companies_financials;

/*========================================================
💰 Section 4 – Financial Health
========================================================*/
/* Q21. Which companies carry the highest total debt? */
SELECT ticker, company_name, sector, total_debt_m
FROM companies_financials
WHERE total_debt_m IS NOT NULL
ORDER BY total_debt_m DESC;

/* Q22. Which sectors have the highest average Debt-to-Equity ratio? */
SELECT sector, AVG(debt_equity_ratio) AS avg_debt_to_equity
FROM companies_financials
WHERE debt_equity_ratio IS NOT NULL
GROUP BY sector
ORDER BY avg_debt_to_equity DESC;

/* Q23. Which companies maintain the strongest liquidity based on the Current Ratio? */
SELECT ticker, company_name, sector, current_ratio
FROM companies_financials
WHERE current_ratio IS NOT NULL
ORDER BY current_ratio DESC;

/* Q24. Which companies hold the largest net cash reserves? */
SELECT ticker, company_name, sector, net_cash_m
FROM companies_financials
WHERE net_cash_m IS NOT NULL
ORDER BY net_cash_m DESC;

/* Q25. Which companies show strong profitability but weak liquidity? */
SELECT ticker, company_name, sector, net_margin_pct, current_ratio
FROM companies_financials
WHERE net_margin_pct>(SELECT AVG(net_margin_pct) FROM companies_financials) AND current_ratio<(SELECT AVG(current_ratio) FROM companies_financials)
ORDER BY net_margin_pct DESC;

/*========================================================
💰 Section 5 – Growth Analysis
========================================================*/
/* Q26. Which companies achieve above-average revenue growth while remaining profitable? */
SELECT ticker, company_name, sector, revenue_growth_1y_pct, profitable
FROM companies_financials
WHERE revenue_growth_1y_pct>(SELECT AVG(revenue_growth_1y_pct) FROM companies_financials) AND profitable='Y'
ORDER BY revenue_growth_1y_pct DESC;

/* Q27. Which sectors achieve above-average revenue growth and above-average net margins? */
SELECT sector, AVG(revenue_growth_1y_pct) AS avg_revenue_growth, AVG(net_margin_pct) AS avg_net_margin
FROM companies_financials
WHERE revenue_growth_1y_pct IS NOT NULL AND net_margin_pct IS NOT NULL
GROUP BY sector
HAVING AVG(revenue_growth_1y_pct) > (
    SELECT AVG(revenue_growth_1y_pct)
    FROM companies_financials
    WHERE revenue_growth_1y_pct IS NOT NULL)
AND AVG(net_margin_pct) > (
    SELECT AVG(net_margin_pct)
    FROM companies_financials
    WHERE net_margin_pct IS NOT NULL)
ORDER BY avg_revenue_growth DESC;

/* Q28. Which companies combine high revenue growth with positive free cash flow? */
SELECT ticker, company_name, sector, revenue_growth_1y_pct, free_cash_flow_m
FROM companies_financials
WHERE revenue_growth_1y_pct > (
    SELECT AVG(revenue_growth_1y_pct)
    FROM companies_financials
    WHERE revenue_growth_1y_pct IS NOT NULL)
AND free_cash_flow_m > 0
ORDER BY revenue_growth_1y_pct DESC;

/*========================================================
💰 Section 6 – Financial Benchmarking
========================================================*/
/* Q29. Which companies outperform their sector averages in net profit margin? */
WITH sector_avg AS (
    SELECT
        sector,
        AVG(net_margin_pct) AS avg_sector_net_margin
    FROM companies_financials
    WHERE net_margin_pct IS NOT NULL
    GROUP BY sector
)

SELECT
    c.ticker,
    c.company_name,
    c.sector,
    c.net_margin_pct,
    s.avg_sector_net_margin
FROM companies_financials c
JOIN sector_avg s
    ON c.sector = s.sector
WHERE c.net_margin_pct > s.avg_sector_net_margin
ORDER BY c.net_margin_pct DESC;

/* Q30. Which sectors outperform the overall market in net profit margin? */
SELECT sector, AVG(net_margin_pct) AS avg_net_margin
FROM companies_financials
WHERE net_margin_pct IS NOT NULL
GROUP BY sector
HAVING AVG(net_margin_pct) >
(
    SELECT AVG(net_margin_pct)
    FROM companies_financials
    WHERE net_margin_pct IS NOT NULL
)
ORDER BY avg_net_margin DESC;

/*========================================================
💰 Section 7 – Advanced Business Insights
========================================================*/
/* Q31. Which sectors achieve above-average Return on Assets while maintaining below-average financial leverage? */
SELECT sector, AVG(roa_pct) AS avg_roa, AVG(debt_equity_ratio) AS avg_debt_equity
FROM companies_financials
WHERE roa_pct IS NOT NULL
  AND debt_equity_ratio IS NOT NULL
GROUP BY sector
HAVING AVG(roa_pct) >(
    SELECT AVG(roa_pct)
    FROM companies_financials
    WHERE roa_pct IS NOT NULL)
AND AVG(debt_equity_ratio) <(
    SELECT AVG(debt_equity_ratio)
    FROM companies_financials
    WHERE debt_equity_ratio IS NOT NULL)
ORDER BY avg_roa DESC;

/* Q32. Do larger companies, measured by total assets, consistently achieve higher profitability? */
SELECT
    CASE
        WHEN total_assets_m >
            (
                SELECT AVG(total_assets_m)
                FROM companies_financials
                WHERE total_assets_m IS NOT NULL
            )
        THEN 'Larger Companies'
        ELSE 'Smaller Companies'
    END AS company_size,

    AVG(net_margin_pct) AS avg_net_margin,
    COUNT(*) AS total_companies
FROM companies_financials
WHERE total_assets_m IS NOT NULL
  AND net_margin_pct IS NOT NULL
GROUP BY company_size;

/* Q33. Which sectors exhibit the greatest variation in profitability? */
SELECT sector, STDDEV(net_margin_pct) AS margin_variability
FROM companies_financials
WHERE net_margin_pct IS NOT NULL
GROUP BY sector
ORDER BY margin_variability DESC;

/* Q34. Which companies rank among the top 3 companies with the highest net profit margins within each sector? */
WITH ranked_companies AS
(
SELECT
    ticker,
    company_name,
    sector,
    net_margin_pct,
    DENSE_RANK() OVER
    (
        PARTITION BY sector
        ORDER BY net_margin_pct DESC
    ) AS sector_rank
FROM companies_financials
WHERE net_margin_pct IS NOT NULL
)

SELECT *
FROM ranked_companies
WHERE sector_rank<=3
ORDER BY sector,sector_rank;

/*=========================================================
SQL Techniques Demonstrated
===========================================================

✓ Filtering (WHERE)

✓ Aggregation (SUM, AVG, COUNT)

✓ GROUP BY

✓ HAVING

✓ CASE WHEN

✓ CTE (WITH)

✓ JOIN

✓ Subqueries

✓ Window Functions (DENSE_RANK)

✓ Statistical Functions (STDDEV)

✓ Business Benchmarking

✓ Financial KPI Analysis */