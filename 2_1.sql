use Northwind
--æw 1
--1.1
select orderid, sum(convert(money,(1-discount)*UnitPrice*Quantity)) as order_value
from [Order Details]
group by OrderID
order by 2 desc

--1.2
select top 10 orderid, sum(convert(money,(1-discount)*UnitPrice*Quantity)) as order_value
from [Order Details]
group by OrderID
order by 2 desc

--æw 2
--2.1
select productid, sum(quantity) as total_quantity
from [Order Details]
where ProductID<3
group by ProductID

--2.2
select productid, sum(quantity) as total_quantity
from [Order Details]
group by ProductID

--2.3
select orderid, sum(convert(money,(1-discount)*quantity*unitprice)) as total_value
from [Order Details]
group by orderid
having sum(Quantity)>250
order by 2 desc

--æw 3
--3.1
select EmployeeID, count(orderid) as num_of_orders
from orders
group by EmployeeID

--3.2
select shipvia, sum(freight) as total_freight
from orders
group by shipvia

--3.3
select shipvia, sum(freight) as total_freight
from orders
where year(ShippedDate) between 1996 and 1997 
group by shipvia


--æw 4
--4.1
select employeeid, year(orderdate) as year, month(orderdate) as month, count(orderid) as number_of_orders
from orders
group by employeeid,year(orderdate), month(orderdate)
order by 1, 2, 3

--4.2
select categoryid, min(unitprice) as min, max(unitprice) as max
from Products
group by CategoryID


