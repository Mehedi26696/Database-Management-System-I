CREATE TABLE sales (
item_name varchar2(5) NOT NULL,
color varchar2(6) NOT NULL,
cloths_size varchar2(6) NOT NULL,
quantity NUMBER(5) NOT NULL
);


INSERT ALL
INTO sales VALUES ('skirt', 'dark', 'small', 2)
INTO sales VALUES ('skirt', 'dark', 'medium', 5)
INTO sales VALUES ('skirt', 'dark', 'large', 1)
INTO sales VALUES ('skirt', 'pastel', 'small', 11)
INTO sales VALUES ('skirt', 'pastel', 'medium', 9)
INTO sales VALUES ('skirt', 'pastel', 'large', 15)
INTO sales VALUES ('skirt', 'white', 'small', 2)
INTO sales VALUES ('skirt', 'white', 'medium', 5)
INTO sales VALUES ('skirt', 'white', 'large', 3)
INTO sales VALUES ('dress', 'dark', 'small', 2)
INTO sales VALUES ('dress', 'dark', 'medium', 6)
INTO sales VALUES ('dress', 'dark', 'large', 12)
INTO sales VALUES ('dress', 'pastel', 'small', 4)
INTO sales VALUES ('dress', 'pastel', 'medium', 3)
INTO sales VALUES ('dress', 'pastel', 'large', 3)
INTO sales VALUES ('dress', 'white', 'small', 2)
INTO sales VALUES ('dress', 'white', 'medium', 3)
INTO sales VALUES ('dress', 'white', 'large', 0)
INTO sales VALUES ('shirt', 'dark', 'small', 2)
INTO sales VALUES ('shirt', 'dark', 'medium', 6)
INTO sales VALUES ('shirt', 'dark', 'large', 6)
INTO sales VALUES ('shirt', 'pastel', 'small', 4)
INTO sales VALUES ('shirt', 'pastel', 'medium', 1)
INTO sales VALUES ('shirt', 'pastel', 'large', 2)
INTO sales VALUES ('shirt', 'white', 'small', 17)
INTO sales VALUES ('shirt', 'white', 'medium', 1)
INTO sales VALUES ('shirt', 'white', 'large', 10)
INTO sales VALUES ('pants', 'dark', 'small', 14)
INTO sales VALUES ('pants', 'dark', 'medium', 6)
INTO sales VALUES ('pants', 'dark', 'large', 0)
INTO sales VALUES ('pants', 'pastel', 'small', 1)
INTO sales VALUES ('pants', 'pastel', 'medium', 0)
INTO sales VALUES ('pants', 'pastel', 'large', 1)
INTO sales VALUES ('pants', 'white', 'small', 3)
INTO sales VALUES ('pants', 'white', 'medium', 0)
INTO sales VALUES ('pants', 'white', 'large', 2)
SELECT * FROM dual;



SELECT item_name, cloths_size, color, SUM(quantity) AS sales_quantity
FROM sales
GROUP BY item_name, cloths_size, color;

--- Roll Up

SELECT item_name, cloths_size, color, SUM(quantity) AS sales_quantity
FROM sales
GROUP BY rollup(item_name, cloths_size, color)
ORDER BY item_name, cloths_size, color;

SELECT color, item_name, cloths_size, SUM(quantity) AS sales_quantity
FROM sales
GROUP BY ROLLUP(color, item_name, cloths_size)
ORDER BY color, item_name, cloths_size;

SELECT item_name, cloths_size, color, SUM(quantity) AS sales_quantity
FROM sales
GROUP BY rollup(item_name), rollup(cloths_size, color)
ORDER BY item_name, cloths_size, color;

--- cube

SELECT item_name, cloths_size, color, SUM(quantity) AS sales_quantity
FROM sales
GROUP BY cube(item_name, cloths_size, color)
ORDER BY item_name, cloths_size, color;


SELECT decode(grouping(item_name),1,'all', item_name) as item_name,
decode(grouping(cloths_size),1,'all', cloths_size) as cloths_size,
decode(grouping(color),1,'all', color) as color,
SUM(quantity) AS sales_quantity
FROM sales
GROUP BY cube(item_name, cloths_size, color)
ORDER BY item_name, cloths_size, color;




select case when grouping(item_name) = 1 then 'all'
else item_name end as item_name,
case when grouping(color) = 1 then 'all'
else color end as color,
'all'as clothes_size, sum(quantity) as quantity
from sales
group by cube(item_name, color);


--- Grouping

SELECT item_name, cloths_size, color, SUM(quantity) AS sales_quantity,
GROUPING(item_name) AS item_name_flag,
GROUPING(cloths_size) AS cloths_size_flag,
GROUPING(color) AS color_flag

FROM sales
GROUP BY CUBE (item_name, cloths_size, color)
ORDER BY item_name, cloths_size, color;


SELECT item_name, cloths_size, color, SUM(quantity) AS sales_quantity,
GROUPING(item_name) AS f1g,
GROUPING(cloths_size) AS f2g,
GROUPING(color) AS f3g
FROM sales
GROUP BY CUBE (item_name, cloths_size, color)
having (GROUPING(color) = '1' and GROUPING(cloths_size) = '1') or (GROUPING(item_name) = '1' and
GROUPING(cloths_size) = '1')
ORDER BY item_name, cloths_size, color;


--- Pivot

SELECT item_name, cloths_size,
SUM(DECODE(color, 'dark', quantity, 0)) AS dark_sum_quantity,
SUM(DECODE(color, 'pastel', quantity, 0)) AS pastel_sum_quantity,
SUM(DECODE(color, 'white', quantity, 0)) AS white_sum_quantity
FROM sales
GROUP BY item_name, cloths_size
ORDER BY item_name, cloths_size;


SELECT item_name,
SUM(DECODE(color, 'dark', quantity, 0)) AS dark_sum_quantity,
SUM(DECODE(color, 'pastel', quantity, 0)) AS pastel_sum_quantity,
SUM(DECODE(color, 'white', quantity, 0)) AS white_sum_quantity
FROM sales
GROUP BY item_name
ORDER BY item_name;



SELECT cloths_size,
SUM(DECODE(color, 'dark', quantity, 0)) AS dark_sum_quantity,
SUM(DECODE(color, 'pastel', quantity, 0)) AS pastel_sum_quantity,
SUM(DECODE(color, 'white', quantity, 0)) AS white_sum_quantity
FROM sales
GROUP BY cloths_size
ORDER BY cloths_size;


SELECT item_name, color,
SUM(DECODE(cloths_size, 'small', quantity, 0)) AS small_sum_quantity,
SUM(DECODE(cloths_size, 'medium', quantity, 0)) AS medium_sum_quantity,
SUM(DECODE(cloths_size, 'large', quantity, 0)) AS large_sum_quantity
FROM sales
GROUP BY item_name, color
ORDER BY item_name, color;



select *
from sales
pivot (sum(quantity)
for color in ('dark','pastel','white'))
order by item_name;


select *
from sales
pivot (sum(quantity)
for cloths_size in ('small','medium','large'))
order by item_name;



select *
from sales
pivot (sum(quantity)
for color in ('dark','pastel','white'))
order by cloths_size;


SELECT item_name, cloths_size, color, SUM(quantity) AS sales_quantity
FROM sales
GROUP BY cube(item_name, cloths_size, color);