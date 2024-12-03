##  Sales Insight Data Analysis Project
##  Data Analysis Using SQL


##  Show all customer records
Select * from sales.customers;

##  Show total number of customer 
Select count(*) from sales.customers; 

##  Show all transactions
Select * from sales.transactions;

##  Show top 5 customers
select * from sales.transactions limit 5;

##  Show transactions for Chennai market (market code for chennai is Mark001)
Select * from sales.transactions where market_code = "Mark001";

## Show transactions where currency is in US dollars 
Select * from sales.transactions where currency = "USD";

##  Show transactions in 2020 join by date table
Select sales.transactions.*, sales.date.* from sales.transactions inner join sales.date on sales.transactions
.order_date = sales.date.date where sales.date.year = 2020;

##  Show total revenue in year 2020
Select sum(sales.transactions.sales_amount) from sales.transactions inner join sales.date on sales.transactions
.order_date = sales.date.date where sales.date.year = 2020;

##  Show total revenue in year 2020, January Month
Select sum(sales.transactions.sales_amount) from sales.transactions inner join sales.date on sales.transactions
.order_date = sales.date.date where sales.date.year = 2020 and month_name = "January";

##  Show total revenue in year 2020 in Chennai
 Select sum(sales.transactions.sales_amount) from sales.transactions inner join sales.date on sales.transactions
.order_date = sales.date.date where sales.date.year = 2020 and sales.transactions.market_code = "mark001";

## Distinct products in Chennai
select distinct product_code from sales.transactions where market_code = "mark001"