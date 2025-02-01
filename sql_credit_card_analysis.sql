
---1 write a query to print top 5 cities with highest spends and their percentage contribution of total credit card spends

with cte as(
select city, sum(amount) as total_spent
from credit_card_transactions
group by city
),
total_expenditure as (
select sum(CAST(amount AS BIGINT)) as total_amount
from credit_card_transactions
)
select top 5 cte.*, round(total_spent*1.0/total_amount * 100,2) as percentage_contribution
from
cte 
cross join total_expenditure
order by total_spent desc
  

--2- write a query to print highest spend month and amount spent in that month for each card type

  
select * from credit_card_transactions
with cte as (
select card_type, month(transaction_date) as transaction_month, year(transaction_date) as transaction_year, sum(amount) as total_amount
from credit_card_transactions

group by month(transaction_date), year(transaction_date), card_type
),
ranking as (
select *, row_number() over(partition by card_type order by total_amount desc) as rn
from cte
)
select * from ranking
where rn = 1


--3- write a query to find percentage contribution of spends by females for each expense type

  
select exp_type,
sum(case when gender='F' then amount else 0 end)*100.0/sum(amount) as percentage_female_contribution
from credit_card_transactions
group by exp_type
order by percentage_female_contribution desc;


--4- during weekends which city has highest total spend to total no of transcations ratio 


select top 1 city , sum(amount)*1.0/count(1) as ratio
from credit_card_transactions
where datepart(weekday,transaction_date) in (1,7)
group by city
order by ratio desc;
