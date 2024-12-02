--3.1 join æw koñcowe
use Northwind

--æwiczenie 1
--1.1
select od.OrderID, sum(quantity) as total_quantity, CompanyName
from [Order Details] as od
inner join orders o on od.OrderID=o.OrderID
left join Customers c on o.CustomerID=c.CustomerID
group by od.OrderID, CompanyName
order by 2 desc

--1.2
select od.orderid, sum(quantity) as total_quantity, CompanyName
from [Order Details] od
inner join orders o on o.OrderID=od.OrderID
left join customers c on c.CustomerID=o.CustomerID
group by od.orderid, companyname
having sum(quantity) > 250
order by 2 desc

--1.3
select od.orderid, companyname, round(sum(quantity*unitprice*(1-discount)),2) as 'total value'
from [Order Details] od
inner join orders o on o.OrderID=od.OrderID
left join customers c on c.CustomerID=o.CustomerID
group by od.orderid, companyname
order by 3

--1.4
select od.orderid, companyname, round(sum(quantity*unitprice*(1-discount)),2) as 'total_value'
from [Order Details] od
inner join orders o on o.OrderID=od.OrderID
left join customers c on c.CustomerID=o.CustomerID
group by od.orderid, companyname
having sum(quantity) > 250
order by 3

--1.5
select od.orderid, companyname, e.FirstName+' '+e.LastName as pracownik, round(sum(quantity*unitprice*(1-discount)),2) as 'total_value'
from [Order Details] od
inner join orders o on o.OrderID=od.OrderID
left join customers c on c.CustomerID=o.CustomerID
left join Employees e on o.EmployeeID=e.EmployeeID
group by od.orderid, companyname, e.FirstName+' '+e.LastName
having sum(quantity) > 250
order by 4

--æwiczenie 2

--2.1
select categoryname, sum(quantity) as sum
from categories c
left join products p on p.CategoryID=c.CategoryID
left join [Order Details] oo on oo.ProductID=p.ProductID
group by c.CategoryID, categoryname
order by 2 desc

--2.2
select categoryname, round(sum(quantity*od.unitprice*(1-discount)),2) as value
from categories c
left join products p on p.CategoryID=c.CategoryID
left join [Order Details] od on od.ProductID=p.ProductID
group by c.CategoryID, CategoryName
order by 2 desc

--2.3.1
select categoryname, round(sum(quantity*od.unitprice*(1-discount)),2) as value, sum(quantity) as total_quantity
from categories c
left join products p on p.CategoryID=c.CategoryID
left join [Order Details] od on od.ProductID=p.ProductID
group by c.categoryID, categoryname
order by 2 desc

--2.3.2
select categoryname, round(sum(quantity*od.unitprice*(1-discount)),2) as value, sum(quantity) as sum
from categories c
left join products p on p.CategoryID=c.CategoryID
left join [Order Details] od on od.ProductID=p.ProductID
group by c.categoryID, categoryname
order by 3 desc

--2.4
select od.OrderID, round(sum(quantity*od.unitprice*(1-discount))+o.Freight,2) as value
from [Order Details] od
inner join orders o on od.OrderID = o.OrderID
group by od.OrderID, o.Freight
order by 2 desc


--æwiczenie 3
--3.1
select s.CompanyName, count(o.orderid) as 'orders in 1997'
from shippers as s
left join Orders o on o.ShipVia=s.ShipperID
where year(o.shippeddate)=1997
group by s.ShipperID, s.CompanyName
order by 2 desc

--3.2
select top 1 s.CompanyName, count(o.orderid) as 'orders in 1997'
from shippers as s
inner join Orders o on o.ShipVia=s.ShipperID
where year(o.shippeddate)=1997
group by s.ShipperID, s.CompanyName
order by 2 desc

--3.3
select firstname, lastname, round(sum(od.quantity*od.unitprice*(1-discount)),2) as value
from employees e
left join orders o on o.EmployeeID=e.EmployeeID
left join [Order Details] od on o.OrderID = od.OrderID
group by e.EmployeeID, firstname, lastname
order by count(o.orderid) desc

--3.4
select top 1 firstname, lastname, count(o.orderid) as count
from employees e
inner join orders o on o.EmployeeID=e.EmployeeID
where year(o.ShippedDate)=1997
group by e.EmployeeID, firstname, lastname
order by count(o.orderid) desc

--3.5
select top 1 firstname, lastname, round(sum(od.quantity*od.unitprice*(1-discount)),2) as value
from employees e
inner join orders o on o.EmployeeID=e.EmployeeID
inner join [Order Details] od on o.OrderID = od.OrderID
where year(o.ShippedDate)=1997
group by e.EmployeeID, firstname, lastname
order by 3 desc


--æwiczenie 4

use Northwind

--4.1.1 ale to tylko pracownicy co maj¹ podw³adnych
select distinct e.firstname, e.lastname, round(sum(od.quantity*od.unitprice*(1-discount)),2) as sum
from employees e
inner join employees ee on ee.reportsto=e.EmployeeID
left join orders o on o.EmployeeID=e.EmployeeID
left join [Order Details] od on od.OrderID=o.OrderID
group by e.EmployeeID, e.firstname, e.lastname, ee.EmployeeID, ee.FirstName, ee.LastName

--4.1.2 ale to tylko pracownicy bez podw³adnych
select e.firstname, e.lastname, round(sum(od.quantity*od.unitprice*(1-discount)),2) as sum
from employees e
left join employees ee on ee.reportsto=e.EmployeeID
left join orders o on o.EmployeeID=e.EmployeeID
left join [Order Details] od on od.OrderID=o.OrderID
group by e.EmployeeID, e.firstname, e.lastname
having count(ee.employeeid)=0

--sprawdzenie
select firstname, lastname, round(sum(oo.quantity*oo.unitprice*(1-discount)),2) as value
from employees e
inner join orders o on o.EmployeeID=e.EmployeeID
inner join [Order Details] oo on o.OrderID = oo.OrderID
group by e.EmployeeID, firstname, lastname
order by count(o.orderid) desc

