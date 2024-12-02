use Northwind
---cwiczenie----
--1.1
select count(*)
from Products
where UnitPrice not between 10 and 20
--1.2
select max(UnitPrice)
from Products
where UnitPrice<20
--1.3
select max(UnitPrice) as 'max', min(UnitPrice) as 'min', avg(UnitPrice) as 'avg'
from Products
where QuantityPerUnit like '%bottle%'
--1.4
select * from Products
where UnitPrice>(select avg(UnitPrice) from Products)
--1.5
select Round(sum(UnitPrice*Quantity*(1-Discount)),2)
from [Order Details]
where OrderID = 10250

select * from orderhist

---przyk³ad---
select productid, sum(quantity) as total_quantity
from [order details]
group by productid

---æwiczenia---

--2.1
select productid, max(UnitPrice) as max_price
from [order details]
group by productID

--2.2
select productid, max(UnitPrice) as max_price
from [order details]
group by productID
order by 2

--2.3
select orderid, max(unitprice) as max_price, min(unitprice) as min_price
from [Order Details]
group by OrderID

--2.4
select ShipVia, count(*) as cnt
from Orders
group by ShipVia

--2.5
select TOP 1 ShipVia, count(*) as cnt
from Orders
where YEAR(ShippedDate)=1997
group by ShipVia
order by 2 desc

--przyklad
select productid, sum(quantity) as total_quantity
from [Order Details]
group by ProductID
having sum(quantity)>1200

--cwiczenia
--3.1
select orderid, count(productid) as number
from [Order Details]
group by OrderID
having count(ProductID)>5

--3.2
select customerid, count(orderId) as number
from orders
where YEAR(ShippedDate)=1998
group by customerid
having count(OrderID)>8
order by sum(freight) desc

--rollup
select productid, orderid, SUM(quantity) AS total_quantity 
from orderhist
group by productid, orderid
with rollup
order by productid, orderid

--
SELECT orderid, productid, SUM(quantity) AS total_quantity 
FROM [order details]
WHERE orderid < 10250
GROUP BY orderid, productid ORDER BY orderid, productid

SELECT orderid, productid, SUM(quantity) AS total_quantity FROM [order details]
WHERE orderid < 10250
GROUP BY orderid, productid
WITH ROLLUP
ORDER BY orderid, productid

--cube
SELECT productid, orderid, SUM(quantity) AS total_quantity 
FROM orderhist
GROUP BY productid, orderid
with cube
order by productid, orderid




