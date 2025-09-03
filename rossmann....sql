

----- rossmann project demand forecasting and optimization analysis ------


CREATE TABLE store (
    Store INT PRIMARY KEY,
    StoreType VARCHAR(10),
    Assortment VARCHAR(20),
    CompetitionDistance INT,
    CompetitionOpenSinceMonth INT,
    CompetitionOpenSinceYear INT,
    Promo2 INT,
    Promo2SinceWeek INT,
    Promo2SinceYear INT,
    PromoInterval VARCHAR(50)
);

DROP TABLE IF EXISTS train;

CREATE TABLE train (
    Store INT,
    DayOfWeek INT,
    Date DATE,
    Sales INT,
    Customers INT,
    Open INT,
    Promo INT,
    StateHoliday VARCHAR(5),
    SchoolHoliday INT
);


SELECT * FROM train;


SELECT * FROM store;





---- basic data validation ----

SELECT COUNT(*)FILTER (WHERE sales IS NULL) as missing_sales, 
       COUNT(*)FILTER (WHERE customers IS NULL) as missing_customers
	   FROM train;   ------- there is no null values in both columns in sales column and in customers column 




----- basic kpis -----
SELECT 
    SUM(sales) AS total_sales,
    AVG(sales) AS avg_sales,
    SUM(customers) AS total_customers,
    COUNT(DISTINCT store) AS total_stores
FROM train;





----- sales by time -----

SELECT EXTRACT(DOW FROM date) as day_of_week,
       AVG(sales) as avg_sales 
	   FROM train 
	   GROUP BY day_of_week
	   ORDER BY day_of_week;




----- promo vs non_promo sales (uplift impact)
 --- comparing average sales with and without promotion ----

 SELECT promo,
        AVG(sales) as avg_sales,
		COUNT(*) as records 
		FROM train 
		GROUP BY promo; 




---- calculating uplift % -----

SELECT 
(AVG(CASE WHEN promo = 1 THEN sales END) -
 AVG(CASE WHEN promo = 0 THEN sales END))
 / AVG(CASE WHEN promo = 0 THEN sales END)* 100 as promo_uplift_percentage
 FROM train;



---- promo impact by store ----
--- exploring which stores gain most from promotions ----

SELECT store,
     AVG(CASE WHEN promo = 1 THEN sales END) as avg_promo_sales,
	 AVG(CASE WHEN promo = 0 THEN sales END) as _nonpromo_sales,
	 (AVG(CASE WHEN promo = 1 THEN sales END) -
	 AVG(CASE WHEN promo = 0 THEN sales END)) as uplift
	 FROM train 
	 GROUP BY store 
	 ORDER BY uplift DESC;




---- promo impact by weekday ----
---- which weekdays respond best to promos ----

SELECT EXTRACT(DOW FROM date) as weekday,
AVG(CASE WHEN promo = 1 THEN sales END) as avg_promo_sales,
AVG(CASE WHEN promo = 0 THEN sales END) as avg_nonpromo_sales,
(AVG(CASE WHEN promo = 1 THEN sales END) - 
AVG(CASE WHEN promo = 0 THEN sales END)) as uplift 
FROM train 
GROUP BY weekday
ORDER BY weekday;




----- Promo Impact Uplift Impact Analysis -----


----- baseline sales vs promo sales -----
----- finding average sales with promo vs non-promo ----

SELECT 
promo,
AVG(sales) as avg_sales,
AVG(customers) as avg_customers
FROM train 
WHERE open = 1
GROUP BY promo;



----- store level promo impact -----
----- finding which stores gain the most from promotion -----


SELECT 
    store,
    AVG(CASE WHEN promo = 1 THEN sales END) AS avg_sales_promo,
    AVG(CASE WHEN promo = 0 THEN sales END) AS avg_sales_no_promo,
    ( (AVG(CASE WHEN promo = 1 THEN sales END) 
       - AVG(CASE WHEN promo = 0 THEN sales END)) 
       / AVG(CASE WHEN promo = 0 THEN sales END) * 100 ) AS promo_uplift_percentage
FROM train
WHERE open = 1
GROUP BY store
ORDER BY promo_uplift_percentage DESC
LIMIT 10;



----- promo impact by store type / assortment -----


SELECT 
    s.storetype,
    AVG(CASE WHEN t.promo = 1 THEN t.sales END) AS avg_sales_promo,
    AVG(CASE WHEN t.promo = 0 THEN t.sales END) AS avg_sales_no_promo,
    ( (AVG(CASE WHEN t.promo = 1 THEN t.sales END) 
       - AVG(CASE WHEN t.promo = 0 THEN t.sales END)) 
       / AVG(CASE WHEN t.promo = 0 THEN t.sales END) * 100 ) AS promo_uplift_percentage
FROM train t
JOIN store s ON t.store = s.store
WHERE t.open = 1
GROUP BY s.storetype
ORDER BY promo_uplift_percentage DESC;




---- time based promo analysis ----

---- checking promo impact by month -----


SELECT 
    EXTRACT(MONTH FROM date) AS month,
    AVG(CASE WHEN promo = 1 THEN sales END) AS avg_sales_promo,
    AVG(CASE WHEN promo = 0 THEN sales END) AS avg_sales_no_promo,
    ( (AVG(CASE WHEN promo = 1 THEN sales END) 
       - AVG(CASE WHEN promo = 0 THEN sales END)) 
       / AVG(CASE WHEN promo = 0 THEN sales END) * 100 ) AS promo_uplift_percentage
FROM train
WHERE open = 1
GROUP BY EXTRACT(MONTH FROM date)
ORDER BY month;



------ promo uplift -----

SELECT COUNT(*) FROM train;
SELECT COUNT(*) FROM store;

SELECT * FROM train LIMIT 5;
SELECT * FROM store LIMIT 5;


----- joining both tables with each others ----


CREATE OR REPLACE VIEW train_store AS
SELECT 
    t.store,
    t.dayofweek,
    t.date,
    t.sales,
    t.customers,
    t.open,
    t.promo,
    t.stateholiday,
    t.schoolholiday,
    s.storetype,
    s.assortment,
    s.competitiondistance,
    s.competitionopensinceyear,
    s.promo2,
    s.promo2sinceyear
FROM train t
JOIN store s ON t.store = s.store;



---- promo vs non-promo sales uplift check ----

SELECT 
promo,
ROUND(AVG(sales),2) as avg_sales,
ROUND(AVG(customers),2) avg_cusomers,
COUNT(*) as records
FROM train_store
GROUP BY promo
ORDER BY promo;



---- promo uplift by store type ----
SELECT 
storetype,
promo,
ROUND(AVG(sales),2) avg_sales
FROM train_store
GROUP BY storetype, promo
ORDER BY storetype, promo;


---- promo uplift by day of week ----

SELECT 
dayofweek,
promo,
ROUND(AVG(sales),2) as avg_sales 
FROM train_store
GROUP BY dayofweek, promo
ORDER BY dayofweek, promo;


---- monthly promo uplift -----
SELECT 
DATE_TRUNC('month', date) AS month,
promo,
ROUND(AVG(sales),2) AS avg_sales
FROM train_store
GROUP BY month, promo
ORDER BY month, promo;



---- uplift % calculation -----

SELECT 
promo,
ROUND(AVG(sales),2) AS avg_sales,
ROUND(100.0 * (AVG(sales) - MIN(AVG(sales)) OVER()) / MIN(AVG(sales)) OVER(),2) AS uplift_percent
FROM train_store
GROUP BY promo
ORDER BY promo;





WITH promo_vs_no AS (
SELECT s.storetype,
           t.promo,
           AVG(t.sales) AS avg_sales
FROM train t
JOIN store s ON t.store = s.store
WHERE t.open = 1
GROUP BY s.storetype, t.promo)
SELECT storetype,
MAX(CASE WHEN promo = 1 THEN avg_sales END) -
MAX(CASE WHEN promo = 0 THEN avg_sales END) AS sales_diff,
ROUND((MAX(CASE WHEN promo = 1 THEN avg_sales END) -
MAX(CASE WHEN promo = 0 THEN avg_sales END)) 
/ MAX(CASE WHEN promo = 0 THEN avg_sales END) * 100, 2) AS uplift_percent
FROM promo_vs_no
GROUP BY storetype;

----- basic data understandig ----- before going to power bi ----
SELECT COUNT(*) AS total_records, COUNT(DISTINCT store) AS unique_stores
FROM train;
--- looking for sales distribution -----
SELECT MIN(sales) AS min_sales, MAX(sales) AS max_sales, AVG(sales) AS avg_sales
FROM train;



----- promo vs non-promo sales -----
SELECT promo, AVG(sales) AS avg_sales, AVG(customers) AS avg_customers
FROM train
GROUP BY promo;


----- day of week impact (with & without promo)
SELECT dayofweek, promo, AVG(sales) AS avg_sales
FROM train
GROUP BY dayofweek, promo
ORDER BY dayofweek, promo;


----- state holiday and school holiday effect -----
SELECT stateholiday, promo, AVG(sales) AS avg_sales
FROM train
GROUP BY stateholiday, promo
ORDER BY stateholiday, promo;



SELECT schoolholiday, promo, AVG(sales) AS avg_sales
FROM train
GROUP BY schoolholiday, promo
ORDER BY schoolholiday, promo;



------- store level promo uplift -----
SELECT store,
AVG(CASE WHEN promo = 1 THEN sales END) AS avg_sales_promo,
AVG(CASE WHEN promo = 0 THEN sales END) AS avg_sales_nonpromo,
(AVG(CASE WHEN promo = 1 THEN sales END) - 
AVG(CASE WHEN promo = 0 THEN sales END)) AS promo_uplift
FROM train
GROUP BY store
ORDER BY promo_uplift DESC;



---- monthly-yearly trends -----
SELECT year, month, promo, AVG(sales) AS avg_sales
FROM train
GROUP BY year, month, promo
ORDER BY year, month, promo;



------ exporting tables -----

---- promo uplift ----
SELECT 
promo,
ROUND(AVG(sales),2) AS avg_sales,
ROUND(AVG(customers),2) AS avg_customers
FROM train
GROUP BY promo
ORDER BY promo;


---- store level promo impact ----

SELECT 
store,
ROUND(AVG(CASE WHEN promo = 1 THEN sales END),2) AS avg_sales_promo,
ROUND(AVG(CASE WHEN promo = 0 THEN sales END),2) AS avg_sales_nonpromo,
ROUND(
AVG(CASE WHEN promo = 1 THEN sales END) 
- AVG(CASE WHEN promo = 0 THEN sales END),2) AS promo_uplift
FROM train
GROUP BY store
ORDER BY promo_uplift DESC;


----- monthly trend analysis -----


SELECT 
DATE_TRUNC('month', date)::DATE AS month,
ROUND(AVG(sales),2) AS avg_sales,
ROUND(SUM(sales),2) AS total_sales,
ROUND(AVG(customers),2) AS avg_customers
FROM train
GROUP BY month
ORDER BY month;



---- holiday impact -----

SELECT 
stateholiday,
ROUND(AVG(sales),2) AS avg_sales,
ROUND(AVG(customers),2) AS avg_customers
FROM train
GROUP BY stateholiday
ORDER BY avg_sales DESC;


---- promo uplift analysis -----

---- sales uplift per store from promos ----
SELECT 
store,
ROUND(AVG(CASE WHEN promo = 1 THEN sales END),2) AS avg_sales_promo,
ROUND(AVG(CASE WHEN promo = 0 THEN sales END),2) AS avg_sales_nonpromo,
ROUND(
(AVG(CASE WHEN promo = 1 THEN sales END) - 
AVG(CASE WHEN promo = 0 THEN sales END)) * 100.0 /
AVG(CASE WHEN promo = 0 THEN sales END),2
) AS uplift_percent
FROM train
GROUP BY store
ORDER BY uplift_percent DESC;



----- overall promo uplift across all store -----


SELECT 
ROUND(AVG(CASE WHEN promo = 1 THEN sales END),2) AS avg_sales_promo,
ROUND(AVG(CASE WHEN promo = 0 THEN sales END),2) AS avg_sales_nonpromo,
ROUND((AVG(CASE WHEN promo = 1 THEN sales END) - 
         AVG(CASE WHEN promo = 0 THEN sales END)) * 100.0 /
         AVG(CASE WHEN promo = 0 THEN sales END),2) AS uplift_percent
FROM train;



---- promo impact by day of the week ----

SELECT 
dayofweek,
ROUND(AVG(CASE WHEN promo = 1 THEN sales END),2) AS avg_sales_promo,
ROUND(AVG(CASE WHEN promo = 0 THEN sales END),2) AS avg_sales_nonpromo,
ROUND((AVG(CASE WHEN promo = 1 THEN sales END) - 
         AVG(CASE WHEN promo = 0 THEN sales END)) * 100.0 /
         AVG(CASE WHEN promo = 0 THEN sales END),2) AS uplift_percent
FROM train
GROUP BY dayofweek
ORDER BY dayofweek;



----- comparing avg sales with promo vs non-promo ----

SELECT 
promo,
ROUND(AVG(sales),2) AS avg_sales,
ROUND(AVG(customers),2) AS avg_customers,
COUNT(*) AS total_days
FROM train
WHERE open = 1
GROUP BY promo
ORDER BY promo;


----- uplift % calculation -----

WITH sales_summary AS (
SELECT promo,
AVG(sales) AS avg_sales
FROM train
WHERE open = 1
GROUP BY promo)
SELECT 
    MAX(CASE WHEN promo = 1 THEN avg_sales END) /
    MAX(CASE WHEN promo = 0 THEN avg_sales END) - 1 AS promo_uplift_pct
FROM sales_summary;


----- promo uplift day of week ----

SELECT 
    dayofweek,
    ROUND(AVG(CASE WHEN promo = 1 THEN sales END),2) AS avg_sales_promo,
    ROUND(AVG(CASE WHEN promo = 0 THEN sales END),2) AS avg_sales_no_promo,
    ROUND(
        (AVG(CASE WHEN promo = 1 THEN sales END) - 
         AVG(CASE WHEN promo = 0 THEN sales END)) * 100.0 /
        NULLIF(AVG(CASE WHEN promo = 0 THEN sales END),0),2
    ) AS promo_uplift_pct
FROM train
WHERE open = 1
GROUP BY dayofweek
ORDER BY dayofweek;



----- promo impact over time -----

SELECT 
    DATE_TRUNC('month', date) AS month,
    ROUND(AVG(CASE WHEN promo = 1 THEN sales END),2) AS avg_sales_promo,
    ROUND(AVG(CASE WHEN promo = 0 THEN sales END),2) AS avg_sales_no_promo
FROM train
WHERE open = 1
GROUP BY month
ORDER BY month;


----- holiday vs promo impact -----
SELECT 
    stateholiday,
    ROUND(AVG(CASE WHEN promo = 1 THEN sales END),2) AS avg_sales_promo,
    ROUND(AVG(CASE WHEN promo = 0 THEN sales END),2) AS avg_sales_nonpromo,
    ROUND(
        (AVG(CASE WHEN promo = 1 THEN sales END) - AVG(CASE WHEN promo = 0 THEN sales END))
        / NULLIF(AVG(CASE WHEN promo = 0 THEN sales END),0) * 100,2
    ) AS promo_uplift_percent
FROM train
GROUP BY stateholiday
ORDER BY promo_uplift_percent DESC;
