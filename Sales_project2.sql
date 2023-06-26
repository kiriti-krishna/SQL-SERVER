--Inspecting data

select * from sales

-- checking unique values
select distinct status from sales
select distinct productline from sales
select distinct country from sales
select distinct territory from sales
select distinct dealsize from sales

--Analysis by productline
select productline,sum (sales) as revenue from sales
group by productline
order by 2 desc

select year_id,sum (sales) as revenue from sales
group by year_id
order by 2 desc

select dealsize,sum (sales) as revenue from sales	
group by dealsize
order by 2 desc

-- which month  has the highest sales in each year
select month_id ,sum (sales) revenue, count(ordernumber) freq from sales
where year_id = 2003 --change year 
group by month_id
order by 2 desc

 --november seem to be the month, lets see which product makes the high sales

 select month_id, productline, sum (sales) revune from sales
 where year_id = 2003 and month_id = 11
 group by month_id, productline order by 3 desc

 --RFM analysis
 --lets see who is the beset customer


 drop table if exists #Trfm
; with rfm as     -- CTE1 
 (
  select customername,
  sum(sales) momentary,
  avg(sales) avg_momentary,
  count(ordernumber) freq,
  max(orderdate) last_orderd_date,
  (select max(orderdate) from sales) as max_order_date,
  DATEDIFF(dd,max(orderdate),(select max(orderdate) from sales)) as recency
  from sales
  group by customername
  ),
  
   rfm_calc as     --CTE2
  (
  select *,
  ntile(4)over (order by recency) as rfm_recency, 
  ntile(4)over (order by freq) as rfm_freq,
  ntile(4)over (order by avg_momentary ) as rfm_momentary
  from rfm
  )
  select *,rfm_recency+rfm_freq+rfm_momentary as rfm_cell,
  cast(rfm_recency as varchar)+ cast(rfm_freq as varchar)+ cast(rfm_momentary as varchar) as frm_string
  into #Trfm    -- creates a temp table
  from rfm_calc




--FINAL RESULT OF CUSTOMERS
  select customername,rfm_recency,rfm_freq,rfm_momentary,rfm_cell ,
  case 
	    when rfm_cell >9 then 'best customer'
		when rfm_cell< 5 then 'lost customer'
		when rfm_cell  between 3 and 9 then 'moderate customer'
  end as frm_segment
  from #Trfm



  -- what products are most often sold

  select distinct( ordernumber),Stuff(
 (select ','+ productcode from sales p
 where ordernumber in
 (
    select ordernumber 
      from (
           select ordernumber,count(*) as n from sales
           where status ='shipped'
           group by ordernumber
	  ) m
     where n =2	
)
and p.ORDERNUMBER =s.ORDERNUMBER
for xml path ('')),1,1,'') as productcodes
from sales s
order by 2 desc