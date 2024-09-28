create database SALE_DB
use SALE_DB

--Q1
select Region,ProductID, sum(Sales) as Sum_Sale
From Orders 
Group by Region,ProductID
Order by Region asc, Sum_Sale desc
--Q2
select Product,Count(*) as Number_of_sale,
sum(Units) as Sum_Units,
sum(COGS) as Sum_COGS,
sum(Sales) as Sum_Sales,
sum(Sales)-sum(COGS) as Sum_Profit
from ORDERS left join PRODUCTS on ORDERS.ProductID=PRODUCTS.ProductID
group by Product
having Product is not null
select * from Products
--Q3
select top 3 *,[Suggested Price]-Price as PriceDifference
from PRODUCTS
order by PriceDifference DESC
--Q4
select *
From CUST0MSERS 
where Fname like 'M%'
--Q5
select PRODUCTS.ProductID,Product,[Description],Supplier,[Suggested Price],Price
From PRODUCTS left join ORDERS on ORDERS.ProductID=PRODUCTS.ProductID
Group by PRODUCTS.ProductID,Product,[Description],Supplier,[Suggested Price],Price

Except 

select PRODUCTS.ProductID,Product,[Description],Supplier,[Suggested Price],Price
From PRODUCTS left join ORDERS on ORDERS.ProductID=PRODUCTS.ProductID
where OrderDate between '2011-01-01' and '2011-01-31'

--Q6

select PRODUCTS.ProductID,Product,[Description],Supplier,[Suggested Price],Price
From PRODUCTS left join ORDERS on ORDERS.ProductID=PRODUCTS.ProductID
where OrderDate between '2011-01-01' and '2011-01-31'
Group by PRODUCTS.ProductID,Product,[Description],Supplier,[Suggested Price],Price

--Q7

select Product, SUM (Units) as Sum_Units_Q1_2011
From PRODUCTS left join ORDERS on ORDERS.ProductID=PRODUCTS.ProductID
where (OrderDate between '2011-01-01' and '2011-03-31')
Group by Product
Having SUM (Units) > 4000
Order by SUM (Units) desc

--Q8
select Product, 
SUM (COGS) as Sum_COGS_Month34_2011,
SUM (Sales) as Sum_Sales_Month34_2011
From PRODUCTS left join ORDERS on ORDERS.ProductID=PRODUCTS.ProductID
where (OrderDate between '2011-03-01' and '2011-04-30')
Group by Product
Order by SUM (Sales) desc
--Q9
select Supplier,
COUNT (*) as Count_Item_Supply
from PRODUCTS
group by Supplier 
Union
select CONVERT(char,count(distinct Supplier)),count(*) from PRODUCTS
order by COUNT (*) asc

--Q10
select Product, 
DATEPART(QUARTER,OrderDate) as By_Quarter,
Sum(Units) as Sum_Units_by_Quarter 
From PRODUCTS left join ORDERS on ORDERS.ProductID=PRODUCTS.ProductID
Group by Product,DATEPART(QUARTER,OrderDate)
Having DATEPART(QUARTER,OrderDate) is not null
Order by DATEPART(QUARTER,OrderDate) asc

    

