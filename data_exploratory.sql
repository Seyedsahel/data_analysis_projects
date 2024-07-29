-- data exploratory

select * 
from layoffs_staging2;

select max(total_laid_off),max(percentage_laid_off)
from layoffs_staging2;


select * 
from layoffs_staging2
where percentage_laid_off = 1
order by total_laid_off desc;


select company , sum(total_laid_off)
from layoffs_staging2
group by company
order by 2 desc;
-- what are you doing with your employees amazon??!!
# sum of total_laid_off of each company

select min(`date`), max(`date`)
from layoffs_staging2;


select industry , sum(total_laid_off)
from layoffs_staging2
group by industry
order by 2 desc;
-- HR makes people get fired, then they have the lowest firing rate?!!

select country , sum(total_laid_off)
from layoffs_staging2
group by country
order by 2 desc;
-- United States don't be rush

select year(`date`) , sum(total_laid_off)
from layoffs_staging2
group by year(`date`)
order by 1 desc;


select company , avg(percentage_laid_off)
from layoffs_staging2
group by company
order by 2 desc;
-- it doesnt relly help full because we dont know how big the companies are

select substring(`date`,1,7) as `month` , sum(total_laid_off) as total_off
from layoffs_staging2
where substring(`date`,1,7) is not null
group by `month`
order by 1 desc;

with Rolling_Total as
(
select substring(`date`,1,7) as `month` , sum(total_laid_off) as total_off
from layoffs_staging2
where substring(`date`,1,7) is not null
group by `month`
order by 1 desc
)
select `month` , total_off , 
sum(total_off) over(order by `month`) as roling_total
from Rolling_Total;

with company_year (company , years , total_laid_off) as(
select company, year(`date`),sum(total_laid_off)
from layoffs_staging2
group by company, year(`date`)
) ,
 company_ranking_year as(
select *,
dense_rank() over(partition by years order by total_laid_off desc) as ranking
from company_year
where years is not null)
select * 
from company_ranking_year 
where ranking <= 5;



with industry_year (industry , years , total_laid_off) as(
select industry, year(`date`),sum(total_laid_off)
from layoffs_staging2
group by industry, year(`date`)
) ,
 industry_ranking_year as(
select *,
dense_rank() over(partition by years order by total_laid_off desc) as ranking
from industry_year
where years is not null)
select * 
from industry_ranking_year 
where ranking <= 5;


