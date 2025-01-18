-- PROJECT: CLEANING DATA IN SQL QUERIES 
  
  
-- https://www.kaggle.com/datasets/swaptr/layoffs-2022
  
  
SELECT *
FROM layoffs
;
  
  
----------------------------------------------------------------
  

-- Create a table to work on, raw data table will be as a backup
  
  
CREATE TABLE portfolio_project_layoffs.layoffs_working
LIKE layoffs
;
  

INSERT layoffs_working
SELECT * FROM portfolio_project_layoffs.layoffs
;
  
  
SELECT *
FROM layoffs_working
;
  
  
----------------------------------------------------------------------
  
  
-- Removing Duplicates
  
-- Checking data for duplicates
  
  
SELECT *
FROM layoffs_working
;
  
  
SELECT *,
ROW_NUMBER () OVER(
	PARTITION BY company, location, industry, total_laid_off, percentage_laid_off,`date`, stage, country, funds_raised) AS row_num
    FROM layoffs_working
;
    
    
WITH duplicate_cte AS
(SELECT *,
ROW_NUMBER () OVER(
	PARTITION BY company, location, industry, total_laid_off, percentage_laid_off,`date`, stage, country, funds_raised) AS row_num
    FROM layoffs_working)
SELECT * 
FROM duplicate_cte
WHERE row_num > 1
;


-- check the results


SELECT *
FROM layoffs_working
WHERE company = 'Beyond Meat'
;


-- this code show rows whith only 1 row duplicated so better do double checks before removing duplicates always


WITH duplicate_cte AS
(SELECT *,
ROW_NUMBER () OVER(
	PARTITION BY company, location, industry, total_laid_off, percentage_laid_off,`date`, stage, country, funds_raised) AS row_num
    FROM layoffs_working)
SELECT * 
FROM duplicate_cte
WHERE row_num > 1
;    
  
   
-- create new table to remove duplicates 


CREATE TABLE `layoffs_working1` (
  `company` text,
  `location` text,
  `industry` text,
  `total_laid_off` text,
  `percentage_laid_off` text,
  `date` text,
  `stage` text,
  `country` text,
  `funds_raised` double DEFAULT NULL,
  `row_num` INT
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci
;


SELECT *
FROM layoffs_working1
;


INSERT INTO layoffs_working1
SELECT *,
ROW_NUMBER () OVER(
	PARTITION BY company, location, industry, total_laid_off, percentage_laid_off,`date`, stage, country, funds_raised) AS row_num
FROM layoffs_working
;


SELECT *
FROM layoffs_working1
WHERE row_num > 1
;


DELETE 
FROM layoffs_working1
WHERE row_num > 1
;

-- double check if correctly done 


SELECT *
FROM layoffs_working1
WHERE row_num > 1
;


-- all duplicates removed 


-------------------------------------------------------------------------


-- Standardising data (finding issues and fixing them)


-- Firstly will remove empty sapce using TRIM function

SELECT *
FROM layoffs_working1
;


SELECT company, TRIM (company)
FROM layoffs_working1
;

UPDATE layoffs_working1
SET company = TRIM(company)
;

SELECT DISTINCT industry
FROM layoffs_working1
;

SELECT *
FROM layoffs_working1
WHERE industry = ''
;

SELECT *
FROM layoffs_working1
;

-- Research company to find out the industry, used company website https://www.crunchbase.com/organization/appsmith, identify as IT industry and will add this to layoffs_working1 table using UPDATE function

UPDATE layoffs_working1
SET industry = 'IT'
WHERE company LIKE 'Appsmith'
;

-- invastigate the locations names and standardise one with special characters, research company websites for correct locations


SELECT DISTINCT location
FROM layoffs_working1
ORDER BY location
;


SELECT DISTINCT *
FROM layoffs_working1
WHERE location LIKE '%sseldorf'
;

-- used company website for location confirmation https://springlane.de/

UPDATE layoffs_working1
SET location = 'Dusseldorf'
WHERE company LIKE 'Springlane'
;


SELECT DISTINCT *
FROM layoffs_working1
WHERE location LIKE '%rde'
;


-- used company website for location confirmation https://tibber.com/en/terms/privacy-policy


UPDATE layoffs_working1
SET location = 'Forde'
WHERE company LIKE 'Tibber'
;

-- used company website for confirmation https://www.crunchbase.com/organization/involves, and https://involves.com/


SELECT *
FROM layoffs_working1
WHERE location LIKE 'Florian%'
;


UPDATE layoffs_working1
SET location = 'Florianopolis'
Where company LIKE 'Involves'
;


SELECT *
FROM layoffs_working1
WHERE location LIKE 'Malm%'
;

-- used company website for confirmation https://careers.oatly.com/locations/malmo-hq


UPDATE layoffs_working1
SET location = 'Malmo'
Where company LIKE 'Oatly'
;


-- checks on country data 


SELECT DISTINCT country
FROM layoffs_working1
ORDER BY 1
;


-- convert date format from text to data type value


SELECT `date`
FROM layoffs_working1
;


ALTER TABLE layoffs_working1
MODIFY COLUMN `date` DATE
;


-- Look at NULL values and blanks


SELECT *
FROM layoffs_working1
;


-- the blank values in column total_laid_off, percentage_laid_off and funds_raised are not be changed, and there is no NULL values in this data


-- Remove any columns and rows which are not needed 


 SELECT *
 FROM layoffs_working1
 WHERE total_laid_off = ''
 AND percentage_laid_off = ''
 ;
 
 
 -- delete this rows as it can't be use in any calculations or analysis
 
 
DELETE FROM layoffs_working1
WHERE total_laid_off = ''
AND percentage_laid_off = ''
;


SELECT *
FROM layoffs_working1
;


ALTER TABLE layoffs_working1
DROP COLUMN row_num
;


SELECT *
FROM layoffs_working1
;


-- THIS IS THE END OF CLEANING PROJECT. DATA IS READY FOR EXPLORATION


-- THANK YOU!

