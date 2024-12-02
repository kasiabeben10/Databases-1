--cw 1
--1.1
-- 1.1
select distinct c.CompanyName, c.Phone
from customers c
inner join orders o on o.CustomerID=c.CustomerID
inner join Shippers s on s.ShipperID=o.ShipVia 
where year(o.shippeddate)=1997 and s.CompanyName='United Package'

--1.1 v2
select CompanyName, Phone
from Customers c
where exists
    (select *
     from orders o
     where o.CustomerID=c.CustomerID and year(o.ShippedDate)=1997 and o.ShipVia=
    (select shipperid
     from shippers
     where CompanyName='United Package'))

select CompanyName, Phone
from Customers c
where customerID in (select customerid from orders o
					where year(o.shippedDate) = 1997 
					and ShipVia in (select shipperid
									from shippers 
									where CompanyName='United Package'))
--1.2
select distinct c.CompanyName, c.Phone
from customers c
inner join orders o on o.CustomerID=c.CustomerID
inner join [Order Details] od on od.OrderID=o.OrderID
inner join Products p on p.ProductID=od.ProductID
inner join categories cat on cat.CategoryID=p.CategoryID
where categoryname='Confections'

-- 1.2 v2
select companyname, phone
from customers c
where exists
(select *
 from orders o
 where o.CustomerID=c.CustomerID and exists
	(select *
	 from [Order Details] od
	 where od.OrderID=o.OrderID and exists
		(select *
		 from products p
		 where p.ProductID=od.ProductID and exists
			(select *
			 from categories cat
			 where cat.CategoryID=p.CategoryID and categoryname='Confections'))))

--1.3
select distinct c.companyname, c.phone
from customers c
left join orders o on o.CustomerID=c.CustomerID
left join [Order Details] od on od.OrderID=o.OrderID
left join Products p on p.ProductID=od.ProductID
left join categories cat on cat.CategoryID=p.CategoryID and categoryname='Confections'
group by c.CustomerID, c.CompanyName, c.Phone
having count(cat.categoryid)=0

--1.3 podzapytania
select companyname, phone
from customers c
where not exists
(select *
 from orders o
 where o.CustomerID=c.CustomerID and exists
	(select *
	 from [Order Details] od
	 where od.OrderID=o.OrderID and exists
		(select *
		 from products p
		 where p.ProductID=od.ProductID and exists
			(select *
			 from categories cat
			 where cat.CategoryID=p.CategoryID and categoryname='Confections'))))
--æw 2
-- 2.1
select productid, max(quantity) as max_quantity
from [order details]
group by productid
order by productid
--2.1 v2
select distinct productid, quantity
from [order details] AS od1
where quantity = (select MAX(quantity)
					from [order details] AS od2
					where od1.productid = od2.productid)
order by 2

--2.1 v3
select distinct od.productid, (select max(quantity)
							from [Order Details] as od2
							where od.productid = od2.ProductID) as max_quantity
from [order details] od
order by 2


--2.2
select p.productid, p.productname
from products p
cross join products pp
group by p.productid, p.productname, p.UnitPrice
having p.unitprice<avg(pp.unitprice)

--2.2 v2
select productid, productname
from products p
where unitprice<(select avg(unitprice)
                 from products)

--2.3
select p.productid, p.productname
from products p
inner join products pp on pp.CategoryID=p.CategoryID
group by p.productid, p.productname, p.UnitPrice
having p.unitprice<avg(pp.unitprice)
--2.3 v2
select productid, productname
from products p
where unitprice<(select avg(unitprice)
                 from products
                 where CategoryID=p.CategoryID)

--æw 3
--3.1
select p.productid, p.productname, p.unitprice,
       avg(pp.unitprice) as 'avg', p.unitprice-avg(pp.unitprice) as diff
from products p
cross join products pp
group by p.productid, p.productname, p.UnitPrice
having p.unitprice<avg(pp.unitprice)
--3.1 v2
select productid, productname, unitprice,
(select avg(unitprice)
 from products) as 'avg',
abs(unitprice -(select avg(unitprice)
            from products)) as diff
from products p

--3.2
select  p.productid, p.productname, c.CategoryName,
        p.unitprice, avg(pp.unitprice) as 'avg',
        p.unitprice-avg(pp.unitprice) as diff
from products p
inner join products pp on pp.CategoryID=p.CategoryID
inner join categories c on c.CategoryID=p.CategoryID
group by p.productid, p.productname, p.UnitPrice, c.CategoryName
--3.2 v2
select  productid, productname,
        (select c.categoryname
        from Categories c
        where c.CategoryID=p.CategoryID) as 'categoryName',
        unitprice,
        (select avg(unitprice)
         from products
         where categoryid=p.CategoryID) as 'avg',
        unitprice -(select avg(unitprice)
                    from products
                    where categoryid=p.CategoryID) as diff
from products p

--æw 4
--4.1
select o.OrderID, round(sum(od.quantity*od.unitprice*(1-od.discount))+Freight,2) as value
from orders o
inner join [Order Details] od on o.OrderID = od.OrderID
where o.OrderID = 10250
group by o.OrderID, Freight
--4.1 v2
select OrderID,
       (select round(sum(quantity*unitprice*(1-discount)),2)
        from [Order Details] oo
        where o.OrderID = oo.OrderID
        )+ freight as sum
from orders o
where o.OrderID = 10250

--4.2
select od.orderid, round(sum(unitprice*quantity*(1-discount)) + freight , 2)
from [Order Details] od
inner join Orders o on od.OrderID = O.OrderID
group by od.orderid, freight
--4.2 v2
select oo.orderid, round(sum(unitprice*quantity*(1-discount)) +
    (select freight
     from orders o
     where o.OrderID=oo.OrderID),2)
from [Order Details] oo
group by orderid

--4.3
select address
from customers c
left join orders o on o.CustomerID=c.CustomerID and year(o.OrderDate)=1997
group by c.customerid, address
having count(o.customerID)=0
--4.3 v2
select address + ', ' + city as Adres, companyname
from customers c
where not exists(
    select *
    from orders o
    where o.CustomerID=c.CustomerID and year(o.orderdate)=1997
)
--4.4
select od.productid, count(distinct customerid)
from [Order Details] od
inner join Orders o on o.OrderID=od.OrderID
group by od.productid
having count(distinct customerid)>1
--4.4 v2
select p.productid
from products p
where   (select count(distinct customerid)
        from orders o
	    inner join [Order Details] oo on oo.ProductID=p.ProductID and o.OrderID=oo.OrderID
		group by productid)>1


--æwiczenie 5

-- 5.1
select e.firstname, e.lastname, sum(od.product_total_value) + sum(o.freight) as total_orders_value
from Employees e
left join orders o on e.EmployeeID=o.EmployeeID
left join (select od.orderid, sum(od.unitprice*od.quantity*(1-od.discount)) as product_total_value
			from [Order Details] od
			group by od.orderid) od on o.OrderID = od.orderid
group by e.FirstName, e.LastName
order by 3 desc

-- 5.1 v2
select e.firstname,
       e.lastname,
       round((select sum(o.freight)
              from orders o
              where o.employeeid = e.employeeid)
              +
             (select sum(od.unitprice * od.quantity * (1-od.discount))
              from [order details] as od
              where od.OrderID in (select o2.OrderID
                                   from orders as o2
                                   where o2.employeeid = e.employeeid)), 2) as total
from employees e
order by 3

--5.2
select top 1 e.firstname,
             e.lastname,
             round(SUM(od.unitprice * od.quantity * (1-od.discount)), 2) as total_value
from employees e
inner join orders o on e.employeeid = o.employeeid
inner join [order details] as od on od.OrderID = o.OrderID
where year(o.OrderDate) = 1997
group by e.firstname, e.lastname
order by total_value desc

--5.2 v2
select top 1 e.firstname,
             e.lastname,
             round((select sum(od.unitprice * od.quantity * (1-od.discount))
                    from [order details] as od
                    where od.OrderID in (select o2.OrderID
                                         from orders as o2
                                         where o2.employeeid = e.employeeid and year(o2.orderdate) = 1997)), 2) as total_value
from employees e
order by total_value desc


-- 5.3 (osoby z podw³adnymi)
select e.firstname,
       e.lastname,
       round((select sum(o.freight)
              from orders o
              where o.employeeid = e.employeeid)
              +
             (select sum(od.unitprice * od.quantity * (1-od.discount))
              from [order details] as od
              where od.OrderID in (select o2.OrderID
                                   from orders as o2
                                   where o2.employeeid = e.employeeid)), 2) as total
from employees e
where e.employeeid in (select e2.reportsTo
                       from employees as e2
                       where e2.reportsTo is not null)
-- 5.3 (osoby bez podw³adnych)
select e.firstname,
       e.lastname,
       round((select sum(o.freight)
              from orders o
              where o.employeeid = e.employeeid)
              +
             (select sum(od.unitprice * od.quantity * (1-od.discount))
              from [order details] as od
              where od.OrderID in (select o2.OrderID
                                   from orders as o2
                                   where o2.employeeid = e.employeeid)), 2) as total
from employees e
where e.employeeid not in (select e2.reportsTo
                       from employees as e2
                       where e2.reportsTo is not null)

--osoby z podw³adnymi
select e.firstname,
       e.lastname,
       round((select sum(o.freight)
              from orders o
              where o.employeeid = e.employeeid)
              +
             (select sum(od.unitprice * od.quantity * (1-od.discount))
              from [order details] as od
              where od.OrderID in (select o2.OrderID
                                   from orders as o2
                                   where o2.employeeid = e.employeeid)), 2) as total,
      (select max(o3.orderdate)
       from orders as o3
       where o3.employeeid = e.employeeid) as lastorderdate
from employees e
where e.employeeid in (select e2.reportsTo
                       from employees as e2
                       where e2.reportsTo is not null)

-- bez podw³adnych
select e.firstname,
       e.lastname,
       round((select sum(o.freight)
              from orders o
              where o.employeeid = e.employeeid)
              +
             (select sum(od.unitprice * od.quantity * (1-od.discount))
              from [order details] as od
              where od.OrderID in (select o2.OrderID
                                   from orders as o2
                                   where o2.employeeid = e.employeeid)), 2) as total,
      (select max(o3.orderdate)
       from orders as o3
       where o3.employeeid = e.employeeid) as lastorderdate
from employees e
where e.employeeid not in (select e2.reportsTo
                       from employees as e2
                       where e2.reportsTo is not null)
