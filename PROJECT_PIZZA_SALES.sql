-- DATA ANALYSIS PROJECT

   --(KPI'S)

 -- Total revenue
  select sum (total_price) as Total_Revenue
  from pizza_sales

  --Average order value

  select sum(total_price)/count (distinct order_id) as Avg_order_value
  from pizza_sales

  --total pizza sold

  select sum(quantity) as TOTAL_PIZZA_SOLD from pizza_sales

  --Average pizza's per order

  select cast(cast(sum(quantity) as decimal(10,2))/cast (count(distinct order_id) as decimal(10,2))  as decimal(10,2)) as avg_piiza_per_order
  from pizza_sales


 -- Daily trend for total orders

 select datename(dw, order_date)as 'days',count(distinct order_id) as total_orders
 from pizza_sales
 group by datename(dw, order_date)
 order by 2


 --hourly trend for total orders

 select datename(hh, order_time)as 'hours',count(distinct order_id) as total_orders
 from pizza_sales
 group by datename(hh, order_time)
 order by datename(hh, order_time)
 
 --Percentage of sales by pizaa category
 select pizza_category,sum (total_price)as Total_price,sum(total_price)*100  /(select sum(total_price)from pizza_sales where datename(mm,order_date) ='january' ) as pct_by_category
 from pizza_sales
 where datename(mm,order_date) ='january'
 group by pizza_category

 
  
 --Percentage of sales by pizaa size
select pizza_size,cast (sum(total_price)*100/(select sum (total_price) from pizza_sales) as decimal(10,2))as pct_by_size
from pizza_sales
where datename(qq,order_id) =1
group by pizza_size
order by pct_by_size desc

-- total pizzas sold by pizza category

select pizza_category, sum(quantity) AS sold_by_category
from pizza_sales 
group by pizza_category

--top 5 best seller pizas
 select top 5 pizza_name,  sum(quantity) as pizzas_sold
 from pizza_sales 
 group by pizza_name
 order by pizzas_sold desc

 --top 5 worst seller pizas
 select top 5 pizza_name,  sum(quantity) as pizzas_sold
 from pizza_sales 
 group by pizza_name
 order by pizzas_sold 