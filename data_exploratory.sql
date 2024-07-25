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
# sum of total_laid_off of each company






