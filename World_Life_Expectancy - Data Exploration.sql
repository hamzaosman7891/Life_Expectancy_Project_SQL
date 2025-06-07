# World Life Expectancy Project (Exploratory Data Analysis)


SELECT *
FROM world_life_expectancy
;

-- Idenyify countries based on Min & Max Life expectancy over the last 15 years.
-- Which countries have the highest increase in life expectancy?

SELECT Country, 
MIN(`Life expectancy`), 
MAX(`Life expectancy`),
ROUND(MAX(`Life expectancy`) - MIN(`Life expectancy`),1) AS Life_Increase_15_Years
FROM world_life_expectancy
GROUP BY Country
HAVING MIN(`Life expectancy`) <> 0
AND  MAX(`Life expectancy`) <> 0
ORDER BY Life_Increase_15_Years DESC
;

-- Identify average life expectancy for each year

SELECT Year, ROUND(AVG(`Life expectancy`),2)
FROM world_life_expectancy
WHERE `Life expectancy` <> 0
AND `Life expectancy` <> 0
GROUP BY Year
ORDER BY Year
;

SELECT *
FROM world_life_expectancy
;

-- This query shows the correlation between Life Expectancy and GDP

SELECT Country, ROUND(AVG(`Life expectancy`),1) AS Life_Exp, ROUND(AVG(GDP),1) AS GDP
FROM world_life_expectancy
GROUP BY Country
HAVING Life_Exp > 0
AND GDP > 0
ORDER BY GDP DESC
;


-- Identify High Correlation between GDP and Life Expectancy (assume GDP > 1500 is considered HIGH)
SELECT 
SUM(CASE WHEN GDP >= 1500 THEN 1 ELSE 0 END) High_GDP_COUNT,
AVG(CASE WHEN GDP >= 1500 THEN `Life expectancy` ELSE NULL END) High_GDP_Life_Exp,
SUM(CASE WHEN GDP <= 1500 THEN 1 ELSE 0 END) Low_GDP_COUNT,
AVG(CASE WHEN GDP <= 1500 THEN `Life expectancy` ELSE NULL END) Low_GDP_Life_Exp
FROM world_life_expectancy
;

-- Is there a correlation between life expectancy and the status of a country?

SELECT Status, Round(AVG(`Life expectancy`),1)
FROM world_life_expectancy
GROUP BY Status
;

SELECT Status, COUNT(DISTINCT Country), Round(AVG(`Life expectancy`),1)
FROM world_life_expectancy
GROUP BY Status
;

-- Is there a correlation between life expectancy and BMI?

SELECT Country, ROUND(AVG(`Life expectancy`),1) AS Life_Exp, ROUND(AVG(BMI),1) AS BMI
FROM world_life_expectancy
GROUP BY Country
HAVING Life_Exp > 0
AND BMI > 0
ORDER BY BMI ASC
;

-- Identifies the Rolling Total of Adult Mortality over the years

SELECT Country, Year, `Life expectancy`, `Adult Mortality`,
SUM(`Adult Mortality`) OVER(PARTITION BY Country ORDER BY Year) AS Rolling_Total
FROM world_life_expectancy
WHERE Country LIKE '%United%'
;