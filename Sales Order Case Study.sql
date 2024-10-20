1. Identify the total no of products sold

SELECT sum(quantity) as total_no_of_products_sold FROM sales_order

2. Other than Completed, display the available delivery status's

select distinct status from sales_order
where status <> 'Completed'

or

select distinct status from sales_order
where lower(status) <> 'completed'

or

select distinct status from sales_order
where upper(status) <> 'COMPLETED'

or

select distinct status from sales_order
where status != 'Completed'

or

select distinct status from sales_order
where status not in ('Completed')


3.Display the order id, order_date and product_name for all the completed
orders.

SELECT s.order_id, s.order_date, p.name as product_name
FROM sales_order s
join products p on p.id = s.prod_id
where s.status = 'Completed'


4. Sort the above query to show the earliest orders at the top. Also display the
customer who purchased these orders.

SELECT c.name as customer_name, p.name as product_name, s.order_id, s.order_date 
FROM sales_order s
join customers c on c.id = s.customer_id
join products p on p.id = s.prod_id
where s.status = 'Completed'
order by s.order_date


5. Display the total no of orders corresponding to each delivery status

SELECT status, count(1) as total_no_of_orders
FROM sales_order
group by status
order by total_no_of_orders desc

6. For orders purchasing more than 1 item, how many are still not completed?

select count(1) as imcomplete_orders
from sales_order
where quantity > 1 and status <> 'Completed'

or

SELECT count(status) as no_incompleted_orders
FROM sales_order
where quantity > 1 and status <> 'Completed'

7. Find the total no of orders corresponding to each delivery status by ignoring
the case in delivery status. Status with highest no of orders should be at the
top.

SELECT status, count(1) as total_no_of_orders FROM sales_order
group by status
order by total_no_of_orders desc

8. Write a query to identify the total products purchased by each customer

select c.name as customer_name, sum(quantity) as total_products_purchased
from customers c
join sales_order s on s.customer_id = c.id
group by customer_name

9. Display the total sales and average sales done for each day.

select s.order_date, sum(s.quantity * p.price) as total_sales, avg(s.quantity * p.price) as avg_sales
from sales_order s
join products p on p.id = s.prod_id
group by s.order_date
order by s.order_date


10. Display the customer name, employee name and total sale amount of all
orders which are either on hold or pending.

select c.name as cust_name, e.name as emp_name, sum(s.quantity * p.price) as total_sales_amt
from sales_order s
join customers c on c.id = s.customer_id
join products p on p.id = s.prod_id
join employees e on e.id = s.emp_id
where status in ('On Hold','Pending')
group by cust_name, emp_name

11. Fetch all the orders which were neither completed/pending or were handled by
the employee Abrar. Display employee name and all details of order.

select e.name as emp_name,s.* 
from sales_order s
join employees e on e.id = s.emp_id
where e.name = 'Abrar Khan' or s.status not in ('Completed', 'Pending')

12. Fetch the orders which cost more than 2000 but did not include the macbook
pro. Print the total sale amount as well.

select s.*, p.name,(s.quantity * p.price) as tot_sales_amt 
from sales_order s
join products p on p.id = s.prod_id
where s.quantity * p.price > 2000 and p.name <> 'Macbook Pro'

13. Identify the customers who have not purchased any product yet.

select c.name 
from customers c
where c.id not in (select customer_id from sales_order)

14. Write a query to identify the total products purchased by each customer.
Return all customers irrespective of wether they have made a purchase or not.
Sort the result with highest no of orders at the top.

select c.name as cust_name, coalesce(sum(s.quantity),0) as tot_prods
from sales_order s
right join customers c on c.id = s.customer_id
group by cust_name
order by tot_prods desc

15. Corresponding to each employee, display the total sales they made of all the
completed orders. Display total sales as 0 if an employee made no sales yet.

select e.name as emp_name, coalesce(sum(s.quantity*p.price),0) as total_sales
from sales_order s
join products p on p.id = s.prod_id
right join employees e on e.id = s.emp_id and s.status = 'Completed'
group by emp_name
order by total_sales desc

16. Re-write the above query so as to display the total sales made by each
employee corresponding to each customer. If an employee has not served a
customer yet then display "-" under the customer.

select e.name as emp_name, coalesce(c.name,'-') as cust_name,
coalesce(sum(s.quantity*p.price),0) as total_sales
from sales_order s
join products p on p.id = s.prod_id
join customers c on c.id = s.customer_id
right join employees e on e.id = s.emp_id and s.status = 'Completed'
group by emp_name, cust_name
order by total_sales desc

17. Re-write above query so as to display only those records where the total sales
is above 1000

select e.name as emp_name, coalesce(c.name,'-') as cust_name,
coalesce(sum(s.quantity*p.price),0) as total_sales
from sales_order s
join products p on p.id = s.prod_id
join customers c on c.id = s.customer_id
right join employees e on e.id = s.emp_id and s.status = 'Completed'
group by emp_name, cust_name
having coalesce(sum(s.quantity*p.price),0) > 1000
order by total_sales desc

18. Identify employees who have served more than 2 customer.

select e.name as emp_name, count(distinct c.name) as no_of_cust_served
from employees e
join sales_order s on s.emp_id = e.id
join customers c on c.id = s.customer_id
group by emp_name
having count(distinct c.name) > 2

19. Identify the customers who have purchased more than 5 products

select c.name as cust_name, sum(s.quantity) as tot_no_prods
from customers c
join sales_order s on s.customer_id = c.id
group by cust_name
having sum(s.quantity) > 5


20. Identify customers whose average purchase cost exceeds the average sale of
all the orders.

select c.name as cust_name, avg(s.quantity*p.price) as avg_purchase
from sales_order s
join customers c on c.id = s.customer_id
join products p on p.id = s.prod_id
group by c.name
having avg(s.quantity*p.price) > (select avg(s.quantity*p.price) as avg_sales
from sales_order s
join products p on p.id = s.prod_id)