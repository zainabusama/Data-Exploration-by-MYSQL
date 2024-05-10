SELECT * 
FROM world_layoffs.layoffs_staging2;
SELECT max(total_laid_off) as max_total_laid_off
FROM layoffs_staging2;
-- Looking at Percentage to see how big these layoffs were
SELECT MAX( percentage_laid_off),MIN(percentage_laid_off)
FROM  layoffs_staging2
WHERE percentage_laid_off IS NOT NULL;


-- Which companies had 1 which is basically 100 percent of they company laid off

SELECT company 
FROM layoffs_staging2
WHERE percentage_laid_off =1;
-- these are mostly startups it looks like who all went out of business during this time
-- convert percentage to %
update  layoffs_staging2
set percentage_laid_off=percentage_laid_off*100;
-- if we order by funcs_raised_millions we can see how big some of these companies were
SELECT company ,percentage_laid_off,funds_raised_millions
FROM layoffs_staging2
WHERE percentage_laid_off =100
ORDER BY funds_raised_millions desc;




-- BritishVolt looks like an EV company, Quibi! I recognize that company - wow raised like 2 billion dollars and went under - ouch
-- Companies with the biggest single Layoff
SELECT total_laid_off,company
FROM layoffs_staging2
order by 2 desc
limit 5;

SELECT location, SUM(total_laid_off)
FROM world_layoffs.layoffs_staging2
GROUP BY location
ORDER BY 2 DESC
LIMIT 10;


SELECT company, SUM(total_laid_off)
FROM world_layoffs.layoffs_staging2
GROUP BY company
ORDER BY 2 DESC
LIMIT 10;




SELECT country, SUM(total_laid_off)
FROM world_layoffs.layoffs_staging2
GROUP BY country
ORDER BY 2 DESC;



SELECT YEAR(date), SUM(total_laid_off),country
FROM world_layoffs.layoffs_staging2
GROUP BY YEAR(date),country
ORDER BY 1 ASC;




SELECT industry, SUM(total_laid_off)
FROM world_layoffs.layoffs_staging2
GROUP BY industry
ORDER BY 2 DESC;

SELECT stage ,SUM(total_laid_off)
FROM layoffs_staging2
GROUP BY stage
order by 2 DESC;
SELECT company, YEAR(date) AS years, SUM(total_laid_off) AS total_laid_off
  FROM layoffs_staging2
  GROUP BY company, YEAR(date);
  
  
  
  
  
  
  
  
WITH Company_Year AS (
 SELECT company, YEAR(date) AS years, SUM(total_laid_off) AS total_laid_off
  FROM layoffs_staging2
  GROUP BY company, YEAR(date)
  )
  ,Company_Year_Rank AS(
SELECT company, years, total_laid_off, DENSE_RANK() OVER (PARTITION BY years ORDER BY total_laid_off DESC) AS ranking
FROM Company_Year)
SELECT company, years, total_laid_off, ranking
FROM Company_Year_Rank
WHERE ranking <= 3
AND years IS NOT NULL
ORDER BY years ASC, total_laid_off DESC;

SELECT substring(date,1,7) as dates, sum(total_laid_off) AS total_laid_off
FROM layoffs_staging2
GROUP BY dates
order by dates  desc;
WITH DATE_CTE AS 
(
SELECT SUBSTRING(date,1,7) as dates, SUM(total_laid_off) AS total_laid_off
FROM layoffs_staging2
GROUP BY dates
ORDER BY dates ASC
)
SELECT dates, total_laid_off,SUM(total_laid_off) OVER (ORDER BY dates ASC) as rolling_total_layoffs
FROM DATE_CTE
ORDER BY dates ASC;











