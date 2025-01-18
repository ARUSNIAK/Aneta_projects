-- Portfolio Project Exploratory Data Analysis using cleanned Layoff Data


SELECT *
FROM layoffs_working1
;


-- start


SELECT MAX(total_laid_off), MAX(percentage_laid_off)
FROM layoffs_working1
;


SELECT *
FROM layoffs_working1
WHERE percentage_laid_off = 1
;


SELECT *
FROM layoffs_working1
WHERE percentage_laid_off = 1
ORDER BY total_laid_off DESC
;


SELECT *
FROM layoffs_working1
WHERE percentage_laid_off = 1
ORDER BY funds_raised DESC
;

SELECT company, SUM(total_laid_off)
FROM layoffs_working1
GROUP BY company
ORDER BY 2 DESC
;


SELECT MIN(`date`), MAX(`date`)
FROM layoffs_working1
;


SELECT industry, SUM(total_laid_off)
FROM layoffs_working1
GROUP BY industry
ORDER BY 2 DESC
;


SELECT *
FROM layoffs_working1
;


SELECT country, SUM(total_laid_off)
FROM layoffs_working1
GROUP BY country
ORDER BY 2 DESC
;

-- lets look at the data by `date` - this one looks at individaul date

SELECT `date`, SUM(total_laid_off)
FROM layoffs_working1
GROUP BY `date`
ORDER BY 1 DESC
;

-- use year function 


SELECT YEAR(`date`), SUM(total_laid_off)
FROM layoffs_working1
GROUP BY YEAR(`date`)
ORDER BY 1 DESC
;


SELECT YEAR(`date`), SUM(total_laid_off)
FROM layoffs_working1
GROUP BY YEAR(`date`)
ORDER BY 2 DESC
;


SELECT stage, SUM(total_laid_off)
FROM layoffs_working1
GROUP BY stage
ORDER BY 2 DESC
;


-- rolling total_laid_off - start in very early until very end 


SELECT * 
FROM layoffs_working1
;


SELECT SUBSTRING(`date`,6,2) AS `Month`, SUM(total_laid_off)
FROM layoffs_working1
GROUP BY `Month`
ORDER BY 1
;


SELECT SUBSTRING(`date`,1,7) AS `Month`, SUM(total_laid_off)
FROM layoffs_working1
GROUP BY `Month`
ORDER BY 1 ASC
;


WITH Rolling_Total AS
(
SELECT SUBSTRING(`date`,1,7) AS `Month`, SUM(total_laid_off) AS total_off
FROM layoffs_working1
GROUP BY `Month`
ORDER BY 1 ASC
)
SELECT `Month`, total_off,
 SUM(total_off) OVER(ORDER BY `Month`) AS Rolling_Total
FROM Rolling_Total
;


SELECT company, SUM(total_laid_off)
FROM layoffs_working1
GROUP BY company
ORDER BY 2 DESC
;

-- look at the companies yearly laid off, grouped by companies and years


SELECT company, YEAR(`date`), SUM(total_laid_off)
FROM layoffs_working1
GROUP BY company, YEAR(`date`)
ORDER BY company ASC
;


-- rank which years company laid off the most employees


SELECT company, YEAR(`date`), SUM(total_laid_off)
FROM layoffs_working1
GROUP BY company, YEAR(`date`)
ORDER BY 3 DESC
;


WITH Company_Year (company, years, total_laid_off) AS
(
SELECT company, YEAR(`date`), SUM(total_laid_off)
FROM layoffs_working1
GROUP BY company, YEAR(`date`)
)
SELECT *, DENSE_RANK () OVER(PARTITION BY years ORDER BY total_laid_off DESC) AS Ranking
FROM Company_Year
ORDER BY Ranking ASC
;

-- rank top companies which laid_off people

WITH Company_Year (company, years, total_laid_off) AS
(
SELECT company, YEAR(`date`), SUM(total_laid_off)
FROM layoffs_working1
GROUP BY company, YEAR(`date`)
), Company_Year_Rank AS
(SELECT *, DENSE_RANK () OVER(PARTITION BY years ORDER BY total_laid_off DESC) AS Ranking
FROM Company_Year
)
SELECT *
FROM Company_Year_Rank
WHERE Ranking <=5
;


WITH Industry_Year (industry, years, total_laid_off) AS
(
SELECT industry, YEAR(`date`), SUM(total_laid_off)
FROM layoffs_working1
GROUP BY industry, YEAR(`date`)
), Industry_Year_Rank AS
(SELECT *, DENSE_RANK () OVER(PARTITION BY years ORDER BY total_laid_off DESC) AS Ranking
FROM Industry_Year
)
SELECT *
FROM Industry_Year_Rank
WHERE Ranking <=5
;


-- THE END 


