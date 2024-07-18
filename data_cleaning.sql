SELECT * 
FROM layoffs_staging;
SELECT * 
FROM layoffs;

-- CREATE TABLE layoffs_staging
-- LIKE layoffs;

-- INSERT layoffs_staging
-- SELECT *
-- FROM layoffs;

WITH duplicate_cte AS (
SELECT * ,
ROW_NUMBER() OVER(
PARTITION BY company , industry , total_laid_off , percentage_laid_off,`date`)
AS row_num 
FROM layoffs_staging)
SELECT * 
FROM duplicate_cte
WHERE row_num > 1;




