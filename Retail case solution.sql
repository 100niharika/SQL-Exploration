-------------- Data Preparetion and Understanding-----------------
--1. No of rows
select count(*)
from Transactions as T
Inner Join prod_cat_info as P
on T.prod_cat_code=P.prod_cat_code
Inner join Customer as C
on C.customer_Id=T.cust_id

--2. No of transactions with return
select count(transaction_id) as [No of Transactions]
from Transactions
where total_amt<0

--4. Time range into date, month, and year diff columns
select tran_date, Day(tran_date) as [Date], month(tran_date) as [Month], year(tran_date) as [Year]
from Transactions

--5. Product category that sub category DIy belongs
select prod_cat, prod_subcat
from prod_cat_info
where prod_subcat='DIY'

----------------Data Analysis-------------------

--1. Channel most frequently used for transaction
select top 1 Store_type, count(store_type) as Frequency
from Transactions
group by Store_type
order by Frequency Desc

--2. Count of Male and Female Customers
select Gender, count(gender) as [Count]
from Customer
where gender is not null
group by Gender

--3. City with Max number of customers
select Top 1 city_code, count(customer_id) as Max_Customer
from Customer
group by city_code
order by Max_Customer Desc

--4. Subcategories under book category
select prod_subcat, count(prod_subcat) as [Count]
from prod_cat_info
where prod_cat='Books'
group by prod_subcat

--5. Max quantity of product ordered
select max(qty) as maximum_quantity
from Transactions

--6. Net total revenue for category: Electronics and Books
select prod_cat, round(sum(total_amt),2) as Revenue
from Transactions as T
Inner Join prod_cat_info as P
on T.prod_cat_code=P.prod_cat_code
where prod_cat in ('Electronics', 'Books')
group by prod_cat

--7. customers have >10 transactions, excluding returns
select count(cust_id) as [No of customer with >10 Tnx]
from Transactions
where total_amt>0

--8. combined revenue from electronics, clothing from flagship store
select store_type, prod_cat, round(sum(total_amt),2) as Revenue
from Transactions as T
Inner Join prod_cat_info as P
on T.prod_cat_code=P.prod_cat_code
where Store_type = 'Flagship store'
and
prod_cat in ('Electronics','Clothing')
group by Store_type, prod_cat

--9. revenue from male customer in electronics category
select prod_cat, round(Sum(Total_amt),1) as Total_Revenue
from Transactions as T
Inner Join prod_cat_info as P
on T.prod_cat_code=P.prod_cat_code
Inner join Customer as C
on C.customer_Id=T.cust_id
where Gender = 'M'
and
prod_cat = 'Electronics'
group by prod_cat

--10. % of sales and returns by sub category display top 5 in terms of sales
select top 5 prod_subcat, round(sum(total_amt)/(select sum(total_amt) from Transactions)*100,2) as [%Revenue]
from Transactions as T
Inner Join prod_cat_info as P
on T.prod_cat_code=P.prod_cat_code
group by prod_subcat

--11. agr between 25-35, find net total revnue gemnerate in last 30 days 

Select *
from
(
select Tran_date, DATEDIFF(year,DOB,getdate()) as age, sum(total_amt) as Revenue
from Customer as C
Inner Join Transactions as T
on C.customer_Id=T.cust_id
group by DATEDIFF(year,DOB,getdate()), tran_date
) as X
where age between 25 and 35
and
tran_date > (select DATEADD(day, -30, max(tran_date)) from Transactions)
order by Revenue Desc

/*select max(tran_date) as Max
from Transactions
*/

--12. product category with max returns in last 3 months
select prod_cat, tran_date, sum(total_amt) as Revenue
from prod_cat_info as P
Inner join Transactions as T
on P.prod_cat_code=T.prod_cat_code
where total_amt<0
and
tran_date > (select DATEADD(month, -3, max(tran_date)) from Transactions)
group by prod_cat, tran_date
order by Revenue ASC

--13. store type that sells max products - by sales and qnt
select top 1 Store_type, round(sum(qty),2) as Quantity, Round(sum(total_amt),2) as Sales
from prod_cat_info as P
Inner join Transactions as T
on P.prod_cat_code=T.prod_cat_code
group by Store_type
order by Sales Desc, Quantity Desc

--14. categories for which average revenue is above overall average
Select Prod_cat, Avg_Revenue
from
(select prod_cat, sum(total_amt) as Revenue,avg(total_amt) as Avg_Revenue
from prod_cat_info as P
Inner join Transactions as T
on P.prod_cat_code=T.prod_cat_code
group by prod_cat
) as X
where Avg_Revenue>(select avg(total_amt) from Transactions)

--15. average and total revenue by each subcategory of category, top 5 amoung qnt sold
select top 5 prod_subcat,Avg(total_amt) as Average,sum(total_amt) as Revenue, sum(qty) as Sold_Qnt
from prod_cat_info as P
Inner join Transactions as T
on P.prod_cat_code=T.prod_cat_code
group by prod_subcat
order by Sold_Qnt DESC




