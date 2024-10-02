select * from coffee_shop_sales;

-- CONVERT DATE (transaction_date) COLUMN TO PROPER DATE FORMAT
UPDATE coffee_shop_sales
SET transaction_date = STR_TO_DATE(transaction_date, '%d-%m-%Y');

-- ALTER DATE (transaction_date) COLUMN TO DATE DATA TYPE
ALTER TABLE coffee_shop_sales
MODIFY COLUMN transaction_date DATE;

-- CONVERT TIME (transaction_time)  COLUMN TO PROPER DATE FORMAT
UPDATE coffee_shop_sales
SET transaction_time = STR_TO_DATE(transaction_time, '%H:%i:%s');


-- ALTER TIME (transaction_time) COLUMN TO DATE DATA TYPE
ALTER TABLE coffee_shop_sales
MODIFY COLUMN transaction_time TIME;

-- DATA TYPES OF DIFFERENT COLUMNS
DESCRIBE coffee_shop_sales;

-- CHANGE COLUMN NAME `ï»¿transaction_id` to transaction_id
ALTER TABLE coffee_shop_sales
CHANGE COLUMN `ï»¿transaction_id` transaction_id INT;

select * from coffee_shop_sales;
-- TOTAL SALES
select concat((round(sum(unit_price * transaction_qty)))/1000, "k") as total_sales
from coffee_shop_sales
where 
month (transaction_date) = 3; -- March month

-- selected month / CM (current month) May=5 -- PM (Privious Month) April=4 
-- TOTAL SALES KPI - MOM DIFFERENCE AND MOM GROWTH
select
	Month(transaction_Date) as month, -- Number of Month
    round(sum(unit_price * transaction_qty)) as totla_sales, -- total sales column 
	(sum(unit_price * transaction_qty) - lag(sum(unit_price * transaction_qty), 1) -- month sales difference
    over(order by month(transaction_date))) / lag(sum(unit_price * transaction_qty), 1) -- division by previous month sales
    over(order by month(transaction_date)) * 100 as mom_increase_percentage -- percentage
from
	coffee_shop_sales
where
	month(transaction_date) in (4, 5) -- for months of April and May
group by
	month(transaction_date)
Order by
	month(transaction_date);
    
select * from coffee_shop_sales;
select count(transaction_id) as total_orders
from coffee_shop_sales
where
month(transaction_date) = 5; -- may month

select * from coffee_shop_sales;
-- TOTAL ORDERS KPI - MOM DIFFERENCE AND MOM GROWTH
select
	Month(transaction_date) AS Month,
    round(count(transaction_date)) as Total_orders,
	(COUNT(transaction_id) - LAG(COUNT(transaction_id), 1) 
OVER (ORDER BY MONTH(transaction_date))) / LAG(COUNT(transaction_id), 1) 
OVER (ORDER BY MONTH(transaction_date)) * 100 AS mom_increase_percentage
FROM
	coffee_shop_sales
Where
	Month(transaction_date) IN(4,5) -- for Apirl and May
Group by 
	Month(transaction_date)
order by
	Month(transaction_date);
   
select * from coffee_shop_sales;
-- TOTAL QUANTITY SOLD
select sum(transaction_qty) AS Total_qty_Sold
from coffee_shop_sales
where
month(transaction_date) = 5; -- May Month

-- TOTAL QUANTITY SOLD KPI - MOM DIFFERENCE AND MOM GROWTH
select 
	month(transaction_date) as Month,
    round(sum(transaction_qty)) as total_qty_sold,
    (sum(transaction_qty) - lag(sum(transaction_qty),1)
    over(order by month(transaction_date))) / lag(sum(transaction_qty),1)
    over(order by month(transaction_date))*100 as mon_increase_percentage
    from
		coffee_shop_sales
	where
		month(transaction_date) in (4,5) -- for April and may
	group by	
		Month(transaction_date)
	order by
		month(transaction_date);

select * from coffee_shop_sales;
-- CALENDAR TABLE – DAILY SALES, QUANTITY and TOTAL ORDERS
select 
	concat(round(sum(unit_price * transaction_qty)/ 1000, 1), 'k') as Total_sales,
    concat(round(sum(transaction_qty)/ 1000, 1), 'k') as Total_qty_sold,
    concat(round(count(transaction_id)/ 1000, 1), 'k') as Total_orders
from coffee_shop_sales
where
	transaction_date = '2023-03-27';

select * from coffee_shop_sales;
-- SALES BY WEEKDAY / WEEKEND
-- weekends sat/sum
-- weekdays mon to fri
-- Sun = 1
-- Mon = 2
-- .
-- .
-- Sat = 7

select 
	case	
		when dayofweek(transaction_date) in (1,7) then 'Weekends'
        else 'Weekdays'
        end as Date_type,
        concat(round(sum(unit_price * transaction_qty)/1000, 1), 'k') as Total_sales
	from coffee_shop_sales
    where month(transaction_date) = 5 -- may month
    group by
		case when dayofweek(transaction_date) in (1,7) then 'Weekends'
        else 'Weekdays'
        end;
        
select * from coffee_shop_sales;
-- SALES BY STORE LOCATION
	select
		store_location,
		concat(round(sum(unit_price * transaction_qty)/1000, 2), 'k') as Total_sales
		from coffee_shop_sales
        where month(transaction_date) = 5 -- may
        group by store_location
        order by sum(unit_price * transaction_qty) desc;
        
select * from coffee_shop_sales;
--  Display sales analysis with average line

select avg(unit_price * transaction_qty) as Avg_sales
from coffee_shop_sales
where month (transaction_date) = 5; -- may

--  another way we can short it 

select 
	concat(round(avg(Total_sales)/1000, 1), 'k') as Avg_sales
from	
	(
    select sum(unit_price * transaction_qty) as Total_sales
    from coffee_shop_sales
    where month (transaction_date) = 5 -- May month
    group by transaction_date
    ) as internal_query;
    
-- daily sales for the particual month
select 	
	day(transaction_date) as Day_of_month,
    sum(unit_price * transaction_qty) as Total_sales
    from coffee_shop_sales
    Where Month(transaction_date) = 5 -- May Month
    group by day(transaction_date)
    order by day(transaction_date);
    
-- COMPARING DAILY SALES WITH AVERAGE SALES – IF GREATER THAN “ABOVE AVERAGE” and LESSER THAN “BELOW AVERAGE”
Select
	Day_of_month,
    case
		When Total_sales > Avg_sales then 'Above Average'
        when Total_sales < Avg_sales then 'Below Average'
        else 'Average'
        End as sales_status,
        Total_sales
	from(
	    SELECT 
        DAY(transaction_date) AS day_of_month,
        SUM(unit_price * transaction_qty) AS total_sales,
        AVG(SUM(unit_price * transaction_qty)) OVER () AS avg_sales
    FROM 
        coffee_shop_sales
    WHERE 
        MONTH(transaction_date) = 5  -- Filter for May
    GROUP BY 
        DAY(transaction_date)
) AS sales_data
ORDER BY 
    day_of_month;

select * from coffee_shop_sales;
-- sales analysis by product category
select 
	product_type,
    sum(unit_price * transaction_qty) As Total_sales
    from coffee_shop_sales
    where month(transaction_date) = 5 and product_category = 'coffee'
    group by product_type
    order by sum(unit_price * transaction_qty) desc
	limit 10;
    
-- sales analysis by days and hours
 select
	sum(unit_price * transaction_qty) as Total_sales,
    sum(transaction_qty) as total_qty_sold,
    Count(*) as Total_orders
    from coffee_shop_sales
    where month(transaction_date) = 5 -- may month
    and dayofweek(transaction_date) = 1 -- Sunday day
    and hour(transaction_time) = 14; -- hour no 14
    
select
	hour(transaction_time),
    sum(unit_price * transaction_qty) as Total_sales
    from coffee_shop_sales
    where month(transaction_date) = 5 -- may month
    group by hour(transaction_time)
    order by hour(transaction_time);
    
-- weekdays sales 
select 
	case
		when dayofweek(transaction_date) = 2 then 'Monday'
        when dayofweek(transaction_date) = 3 then 'Tuesday'
        when dayofweek(transaction_date) = 4 then 'Wednesday'
        when dayofweek(transaction_date) = 5 then 'Thursday'
        when dayofweek(transaction_date) = 6 then 'Friday'
        when dayofweek(transaction_date) = 7 then 'Saturday'
        else 'Sunday'
	end as Day_of_Week,
    round(sum(unit_price * transaction_qty)) as Total_sales
    from 
	   coffee_shop_sales
	where
		month(transaction_date) = 5 -- filter for may (month number 5)
        group by 
			case
		when dayofweek(transaction_date) = 2 then 'Monday'
        when dayofweek(transaction_date) = 3 then 'Tuesday'
        when dayofweek(transaction_date) = 4 then 'Wednesday'
        when dayofweek(transaction_date) = 5 then 'Thursday'
        when dayofweek(transaction_date) = 6 then 'Friday'
        when dayofweek(transaction_date) = 7 then 'Saturday'
        else 'Sunday'
	end
    
    

    

    
    
    
    
