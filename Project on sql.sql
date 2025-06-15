--ONLINE BOOK STORE
DROP table if exists Books;
create table books(
book_id serial primary key,
title varchar(100),
author varchar(100),
genre varchar(50),
published_year int,
price numeric(10,2),
stock int
);
drop table if exists customers;
create table customers(
customer_id serial primary key,
name varchar(100),
email varchar(100),
phone varchar(15),
city varchar(50),
country varchar(150)
);
drop table if exists orders;
create table orders(
order_id serial primary key,
customer_id int references customers(customer_id),
book_id int references books(book_id),
order_date date,
quantity int,
total_amount numeric(10,2)
);
select *from books;
select *from customers;
select *from orders;

--import data into books table
copy books(book_id,title,author,genre,published_year,price,stock)
from 'D:\Sql\Books.csv'
csv header;

--import data into customers table
copy customers(customer_id,name,email,phone,city,country)
from 'D:\Sql\Customers.csv'
csv header;

--import data into orders table
copy orders(order_id,customer_id,book_id,order_date,quantity,total_amount)
from 'D:\Sql\Orders.csv'
csv header;


--1.retrive  all books in the "fiction " genre
select * from books
where genre='Fiction';

--2.find book published after the year 1950
select*from books
where published_year>1950;

--3.list all the customers from the canada
select *from customers
where country='Canada';

--4.show orders placed in nove 2023
select *from orders
where order_date between '2023-11-01' and '2023-11-30';

--5. retrive the total stock of books available
select sum(stock) as total_stock from books;
--6.find detail of most expensive book
select*from books 
order by price desc 
limit 1;

--7.show all customers who order more than 1 quantity of a book
select *from orders
where quantity>1;

--8.retrive all the orders where the total amount excceed $20
select *from orders
where total_amount>20;

--9 list all genre avaliable in the books table
select distinct genre from  books;

--10 find the book with lowest stock
select *from books
order by stock limit 1;

--11.calculate the total revenue generated from all orders
select sum(total_amount) as revenue from orders

--advanced questions
--1.retrive the total number of  books sold for each genre
select *from orders;
select b.genre,sum(o.quantity) as total_books_sold
from orders o
join books b on o.book_id = b.book_id
group by b.genre;

--2.find the avg price of books in the "fantasy" genre
select avg(price) as average_price
from books
where genre='Fantasy';

--3.list customers who have placed at list 2 orders
select  o.customer_id, c.name ,count(o.order_id) as order_count
from orders o
join customers c on o.customer_id = c.customer_id
group by o.customer_id, c.name
having count(order_id) >=2;

--4.find the most frequently ordered book
select o.book_id,b.title ,count(o.order_id) as order_count
from orders o
join books b on o.book_id=b.book_id
group by o.book_id,b.title
order by order_count desc limit 1;

--5.show the top 3 most expensive books of'Fantasy' genre
select *from books
where genre ='Fantasy'
order by price desc limit 3;

--6.retrive the total quantity of books sold by each auther
select b.author, sum(o.quantity) as total_books_sold
from orders o
join books b on o.book_id=b. book_id
group by b.author;

--7.list the cities where customers who spent $20 are located
select  distinct c.city,total_amount
from orders o
join customers c on o.customer_id=c.customer_id
where o.total_amount>30;

--8.find the customers who spent the most on orders

select c.customer_id,c.name,sum(o.total_amount) as total_spent
from orders o
join customers c on o.customer_id=c.customer_id
group by c.customer_id,c.name
order by total_spent desc limit 1;


--9. calculate the stock remaining after fulfilling all oredes
select b.book_id,b.title,b.stock,coalesce(sum(o.quantity),0) as order_quantity,
       b.stock- coalesce(sum(o.quantity),0) as remaining_quantity
from books b
left join  orders o on b.book_id=o.book_id
group by b.book_id  order by book_id;


































