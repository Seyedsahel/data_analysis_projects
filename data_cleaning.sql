-- SELECT * 
-- FROM layoffs_staging;
-- SELECT * 
-- FROM layoffs;

-- CREATE TABLE layoffs_staging
-- LIKE layoffs;

-- INSERT layoffs_staging
-- SELECT *
-- FROM layoffs;

WITH duplicate_cte AS (
SELECT * ,
ROW_NUMBER() OVER(
PARTITION BY company ,location, industry , total_laid_off , percentage_laid_off,`date`,stage,country,funds_raised_millions)
AS row_num 
FROM layoffs_staging)
SELECT * 
FROM duplicate_cte
WHERE row_num > 1;

SELECT * 
FROM layoffs_staging
WHERE company = 'casper';




CREATE TABLE `layoffs_staging2` (
  `company` text,
  `location` text,
  `industry` text,
  `total_laid_off` int DEFAULT NULL,
  `percentage_laid_off` text,
  `date` text,
  `stage` text,
  `country` text,
  `funds_raised_millions` int DEFAULT NULL,
  `row_num` int
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

SELECT * 
FROM layoffs_staging2;

INSERT INTO layoffs_staging2
SELECT * ,
ROW_NUMBER() OVER(
PARTITION BY company ,location, industry , total_laid_off , percentage_laid_off,`date`,stage,country,funds_raised_millions)
AS row_num 
FROM layoffs_staging;

DELETE  
FROM layoffs_staging2
WHERE row_num > 1;

SELECT *
FROM layoffs_staging2
WHERE row_num > 1;

SELECT company
FROM layoffs_staging2;

UPDATE layoffs_staging2
set company = trim(company);

SELECT distinct industry
FROM layoffs_staging2
order by 1;

SELECT *
FROM layoffs_staging2
WHERE industry LIKE "crypto%";

UPDATE layoffs_staging2
SET industry = 'Crypto'
WHERE industry LIKE "crypto%";

SELECT  country
FROM layoffs_staging2
order by 1;

select distinct country , trim(trailing "." from country)
from layoffs_staging2
order by 1;

update layoffs_staging2
set country = trim(trailing "." from country)
where country like 'United States%';

select `date`
from layoffs_staging2;

update layoffs_staging2
set `date` = str_to_date(`date`,'%m/%d/%Y');

alter table layoffs_staging2
modify column `date` date;

select *
from layoffs_staging2;

select *
from layoffs_staging2
where industry is null 
or industry = "";

select *
from layoffs_staging2 t1
join  layoffs_staging2 t2
	on t1.company = t2.company
where (t1.industry is null or t1.industry = "")
and t2.industry is not null;

 update layoffs_staging2
 set industry = null
 where industry = "";

update layoffs_staging2 t1
join layoffs_staging2 t2
	on t1.company = t2.company
set t1.industry = t2.industry
where t1.industry is null
and t2.industry is not null;

-- for total_laid_off , percentage_laid_off cant fill null values but they have a lot of null values 
-- and actiolly they are not matter in next project(date explority) so we gonna delete them

delete 
from layoffs_staging2 
where total_laid_off is null
and percentage_laid_off is null;

alter table layoffs_staging2
drop column row_num;



