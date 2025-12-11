--1. Total population of all Countries?
Select count (dist. Country), sum (population) from Life_expectancy 
--2. How many Countries are still developing?
Select count (dist. country), status from Life_expectancy
Where status = Developing;
--3. How many Countries are developed?
Select count (dist. country), status from Life_expectancy
Where status = Developed;
--4. How many countries recorded hepatitis B?
Select count (dist. Country), hepatitis_b from Life_expectancy
--5. How many Countries recorded Measles?
Select count (dist. Country), measles from Life_expectancy
--6. Find the population of Hiv/aids recorded in each of the countries per year?
Select Count (dist. Country), hiv/aids, year from Life_expectancy


--7. What are the key patterns and variations in life expectancy across countries from 2000–2015?

SELECT Country, Year, Life_expectancy
FROM life_expectancy
WHERE Year BETWEEN 2000 AND 2015
ORDER BY Country, Year;

-- 8.	Which countries consistently maintain a high life expectancy, and which remain low?

SELECT Country,
       AVG(Life_expectancy) AS Average_LifeExpectancy
FROM life_expectancy
GROUP BY Country
ORDER BY Average_LifeExpectancy DESC;

-- 9.	How do adult mortality rates influence life expectancy?

SELECT Country, Year, Life_expectancy, Adult_mortality
FROM life_expectancy
ORDER BY Adult_mortality DESC;

-- 10.	How does the prevalence of HIV/AIDS impact life expectancy across countries?

SELECT 
    country,
    year,
    life_expectancy,
    `hiv/aids`
FROM life_expectancy
ORDER BY `hiv/aids` DESC;

--11. To what extent do immunization rates for Polio, Diphtheria, Hepatitis B predict life expectancy?

SELECT Country, Year, Life_expectancy, Polio, Diphtheria, Hepatitis_B
FROM life_expectancy;

-- 12.	What is the relationship between GDP per capita and life expectancy?

SELECT Country, Year, Life_expectancy, GDP
FROM life_expectancy
ORDER BY GDP DESC;

-- 13.	How does the income composition index relate to life expectancy?

SELECT Country, Year, Life_expectancy, Income_composition_of_resources
FROM life_expectancy;

-- 14.	How does schooling influence long-term health outcomes?

SELECT Country, Year, Life_expectancy, Schooling
FROM life_expectancy
ORDER BY Schooling DESC;

-- 15.	Do countries with higher health expenditure experience higher life expectancy?

SELECT Country, Year, Life_expectancy, Total_expenditure
FROM life_expectancy;

-- 16. Is the percentage of GDP spent on health a significant predictor of life expectancy?

SELECT Country, Year, Life_expectancy, Total_expenditure AS Health_Spending_GDP
FROM life_expectancy;

-- 17. Compare infant deaths and under-five deaths in determining national life expectancy:

SELECT Country, Year, Life_expectancy, Infant_deaths, Under_five_deaths
FROM life_expectancy
ORDER BY Infant_deaths DESC;

-- 18. How does child malnutrition (thinness indicators) correlate with life expectancy?
SELECT 
    country,
    year,
    life_expectancy,
    thinness__1_19_years,
    thinness_5_9_years
FROM life_expectancy;

-- 19. What are the differences in life expectancy between developed vs developing nations?
SELECT Status, AVG(Life_expectancy) AS Avg_LifeExp
FROM life_expectancy
GROUP BY Status;

-- 20.	Are developing countries showing significant progress during 2000–2015?
SELECT Country,
       MIN(Life_expectancy) AS Earliest,
       MAX(Life_expectancy) AS Latest,
       (MAX(Life_expectancy) - MIN(Life_expectancy)) AS Improvement
FROM life_expectancy
WHERE Status = 'Developing'
GROUP BY Country
ORDER BY Improvement DESC;

-- 21.	Which countries are improving rapidly in life expectancy?
SELECT Country,
       (MAX(Life_expectancy) - MIN(Life_expectancy)) AS Improvement
FROM life_expectancy
GROUP BY Country
ORDER BY Improvement DESC;

-- 22.	Which countries show warning signs (declining or stagnating life expectancy)?
SELECT Country,
       (MAX(Life_expectancy) - MIN(Life_expectancy)) AS Change
FROM life_expectancy
GROUP BY Country
HAVING Change <= 0
ORDER BY Change ASC;

-- 23.	Which nations have the highest burden of disease (HIV, measles) and how does it relate to life expectancy?
SELECT 
    country,
    year,
    life_expectancy,
    `hiv/aids`,
    measles
FROM life_expectancy
ORDER BY `hiv/aids` DESC, measles DESC;

-- 24.	Based on past trends, which countries are likely to experience continuous improvement?
SELECT Country,
       (MAX(Life_expectancy) - MIN(Life_expectancy)) AS Trend
FROM life_expectancy
GROUP BY Country
HAVING Trend > 0
ORDER BY Trend DESC;

-- 25.	Which countries could potentially fall behind if current patterns continue?
SELECT Country,
       (MAX(Life_expectancy) - MIN(Life_expectancy)) AS Trend
FROM life_expectancy
GROUP BY Country
HAVING Trend < 5  -- small improvement
ORDER BY Trend ASC;

-- 26.	What combination of factors (GDP, schooling, vaccinations, health expenditure) gives the strongest model for predicting life expectancy?
SELECT Country, Year, Life_expectancy,
       GDP,
       Schooling,
       Income_composition_of_resources,
       Polio, Diphtheria, Hepatitis_B,
       Total_expenditure
FROM life_expectancy
ORDER BY Life_expectancy DESC;


-- 27. Which diseases (measles, polio, hepatitis B, HIV/AIDS) appear to have the strongest impact on life expectancy?

WITH hiv_q AS (
  SELECT `hiv/aids`,
         NTILE(4) OVER (ORDER BY `hiv/aids`) AS hiv_quartile,
         country, year, life_expectancy
  FROM life_expectancy
),
measles_q AS (
  SELECT measles,
         NTILE(4) OVER (ORDER BY measles) AS measles_quartile,
         country, year, life_expectancy
  FROM life_expectancy
),
polio_q AS (
  SELECT polio,
         NTILE(4) OVER (ORDER BY polio) AS polio_quartile,
         country, year, life_expectancy
  FROM life_expectancy
),
hep_q AS (
  SELECT hepatitis_b,
         NTILE(4) OVER (ORDER BY hepatitis_b) AS hep_quartile,
         country, year, life_expectancy
  FROM life_expectancy
)
SELECT 'hiv' AS metric, hiv_quartile AS bucket, AVG(life_expectancy) AS avg_life_exp
FROM hiv_q GROUP BY hiv_quartile
UNION ALL
SELECT 'measles', measles_quartile, AVG(life_expectancy)
FROM measles_q GROUP BY measles_quartile
UNION ALL
SELECT 'polio', polio_quartile, AVG(life_expectancy)
FROM polio_q GROUP BY polio_quartile
UNION ALL
SELECT 'hepatitis_b', hep_quartile, AVG(life_expectancy)
FROM hep_q GROUP BY hep_quartile
ORDER BY metric, bucket;

--28. Are developing countries showing improvements in life expectancy compared to developed countries?
SELECT status,
       year,
       AVG(life_expectancy) AS avg_life_exp,
       COUNT(*) AS n_obs
FROM life_expectancy
GROUP BY status, year
ORDER BY status, year;

Select Country, Life_expectancy from life_expectancy
Order by Life_expectancy DESC
Limit 10
