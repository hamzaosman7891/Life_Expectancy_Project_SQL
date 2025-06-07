### World Life Expectancy Project (Data Cleaning)


SELECT *
FROM world_life_expectancy
;

-- Identify Duplicates

SELECT Country, Year, CONCAT(Country, Year), COUNT(CONCAT(Country, Year))
FROM world_life_expectancy
GROUP BY Country, Year, CONCAT(Country, Year)
HAVING COUNT(CONCAT(Country, Year)) > 1
;

-- Identify Row_Id for Duplicates

SELECT *
FROM (
SELECT Row_ID,
CONCAT(Country, Year),
ROW_NUMBER() OVER( PARTITION BY CONCAT(Country, Year) ORDER BY CONCAT(Country, Year)) as Row_Num
FROM world_life_expectancy
) AS Row_Table
WHERE Row_Num > 1
;

-- Delete Duplicates 

DELETE FROM world_life_expectancy
WHERE 
	Row_ID IN (
	SELECT Row_ID
FROM (
	SELECT Row_ID,
	CONCAT(Country, Year),
	ROW_NUMBER() OVER( PARTITION BY CONCAT(Country, Year) ORDER BY CONCAT(Country, Year)) as Row_Num
	FROM world_life_expectancy
	) AS Row_Table
WHERE Row_Num > 1
)
;

-- Standardising the Status Column 
-- Identify blanks in Status

SELECT *
FROM world_life_expectancy
WHERE Status = ''
;


SELECT DISTINCT(Status)
FROM world_life_expectancy
WHERE Status <> ''
;

-- Returns a list of all Developing countries

SELECT DISTINCT(Country)
FROM world_life_expectancy
WHERE Status = 'Developing'
;

UPDATE world_life_expectancy
SET Status = 'Developing'
WHERE Country IN (SELECT DISTINCT(Country)
					FROM world_life_expectancy
					WHERE Status = 'Developing');
                    
-- Standardising blank values with Developing countries

UPDATE world_life_expectancy t1
JOIN world_life_expectancy t2
	ON t1.Country = t2.Country
SET t1.Status = 'Developing'
WHERE t1.Status = ''
AND t2.Status <> ''
AND T2.Status = 'Developing'
;

SELECT *
FROM world_life_expectancy
WHERE Country = 'United States of America'
;

-- Standardising blank values with Developed countries

UPDATE world_life_expectancy t1
JOIN world_life_expectancy t2
	ON t1.Country = t2.Country
SET t1.Status = 'Developed'
WHERE t1.Status = ''
AND t2.Status <> ''
AND T2.Status = 'Developed'
;

-- Standarising life expectancy columns
-- Finding the blank values

SELECT *
FROM world_life_expectancy
WHERE Status is NULL
;

SELECT *
FROM  world_life_expectancy
WHERE `Life expectancy` = ''
;

SELECT Country, Year, `Life expectancy`
FROM  world_life_expectancy
#WHERE `Life expectancy` = ''
;

-- Self joining to determine the expected average of blank values

SELECT t1.Country, t1.Year, t1.`Life expectancy`, 
t2.Country, t2.Year, t2.`Life expectancy`,
t3.Country, t3.Year, t3.`Life expectancy`,
ROUND((t2.`Life expectancy` + t3.`Life expectancy`)/ 2,1)
FROM  world_life_expectancy t1
JOIN world_life_expectancy t2
	ON t1.Country = t2.Country
    AND t1.Year = t2.Year - 1 
JOIN world_life_expectancy t3
	ON t1.Country = t3.Country
    AND t1.Year = t3.Year + 1
WHERE t1.`Life expectancy` = ''
;

-- Update the blank values with the average life expectancy value

UPDATE world_life_expectancy t1
JOIN world_life_expectancy t2
	ON t1.Country = t2.Country
    AND t1.Year = t2.Year - 1 
JOIN world_life_expectancy t3
	ON t1.Country = t3.Country
    AND t1.Year = t3.Year + 1
SET t1.`Life expectancy` = ROUND((t2.`Life expectancy` + t3.`Life expectancy`)/ 2,1)
WHERE t1.`Life expectancy` = ''
;

SELECT *
FROM world_life_expectancy
;
