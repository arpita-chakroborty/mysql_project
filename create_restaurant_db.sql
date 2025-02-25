select * from menu_items;
select * from order_details;
-- write a query to find the number of items on the menu
select count(1) from menu_items;
-- What are the least and most expensive items on the menu?
SELECT item_name, price 
FROM menu_items
WHERE price = (SELECT MAX(price) FROM menu_items)

UNION ALL

SELECT item_name, price AS least_expensive
FROM menu_items
WHERE price = (SELECT MIN(price) FROM menu_items);

-- How many Italian dishes are on the menu? What are the least and most expensive Italian dishes on the menu?
(select count(1) as total_italian_menu
from menu_items
where category = "italian");

select (select item_name from menu_items where category="italian" and price=(select max(price)  from menu_items WHERE CATEGORY="ITALIAN")limit 1) as most_expensive_item,
(select max(price)FROM MENU_ITEMS
WHERE CATEGORY= "ITALIAN") MAX_PRICE,

(SELECT ITEM_NAME FROM MENU_ITEMS WHERE CATEGORY="ITALIAN" AND PRICE=(SELECT MIN(PRICE) FROM MENU_ITEMS
WHERE CATEGORY="ITALIAN") LIMIT 1 ) AS LEAST_EXPENSIVE_ITEM,
(SELECT MIN(PRICE) FROM MENU_ITEMS WHERE CATEGORY="ITALIAN") AS LOWST_PRICE;
-- How many dishes are in each category? What is the average dish price within each category?
SELECT CATEGORY, COUNT(1) AS NO_OF_DISHES,AVG(PRICE)  AS AVG_PRICE
FROM MENU_ITEMS
GROUP  BY CATEGORY;
-- View the order_details table. What is the date range of the table?
WITH CTE AS (
SELECT MIN(ORDER_DATE) AS START_DATE,MAX(ORDER_DATE) AS END_DATE FROM ORDER_DETAILS 
 SELECT DATEDIFF(START_DATE,END_DATE) FROM CTE
 -- How many orders were made within this date range? How many items were ordered within this date range?
 SELECT COUNT(DISTINCT ORDER_ID) AS TOTAL_NO_OF_ORDER, COUNT(ORDER_DETAILS_ID) AS TOTAL_ITEMS FROM ORDER_DETAILS;

 -- Which orders had the most number of items?
 SELECT ORDER_ID,COUNT(ITEM_ID)AS NO_OF_ORDER FROM ORDER_DETAILS
 GROUP BY 1
 ORDER BY NO_OF_ORDER DESC; 
--  How many orders had more than 12 items?
SELECT COUNT(*) FROM 
(SELECT ORDER_ID,COUNT(ITEM_ID) AS NO_OF_ITEMS FROM ORDER_DETAILS
GROUP BY ORDER_ID
HAVING NO_OF_ITEMS > 12) AS NUM_ORDERS;
-- Combine the menu_items and order_details tables into a single table
select * from order_details o
left join 
menu_items m
on o.item_id=m.menu_item_id;
-- What were the least and most ordered items? What categories were they in?
select m.item_name,m.category,count(o.order_details_id) as max_num_order
from menu_items m
left join order_details o
on m.menu_item_id=o.item_id
group by 1,2
order by max_num_order desc 
limit 1;

select m.item_name,m.category,count(distinct o.order_details_id) as min_num_order
from menu_items m
left join order_details o
on m.menu_item_id=o.item_id
group by 1,2
order by min_num_order 
limit 1;

-- What were the top 5 orders that spent the most money?
select order_id,sum(price) as most_spend_money
from menu_items m
left join order_details o
on m.menu_item_id=o.item_id
group by 1
order by sum(price) desc
limit 5;
-- View the details of the highest spend order. Which specific items were purchased?
select order_id,category,count(o.item_id) as num_items
from  menu_items m
left join order_details o
on m.menu_item_id=o.item_id
where order_id in (440,2075,1957,330,2675)
group by 1,2
;

