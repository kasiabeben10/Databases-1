--3.0

--æwiczenie 1
--1
select ProductName, UnitPrice, CompanyName
from Products
inner join suppliers on Suppliers.SupplierID=PRODUCts.SupplierID
where products.UnitPrice between 20 and 30
order by UnitPrice

--2
select ProductName, UnitsInStock, CompanyName
from Products
inner join suppliers on Suppliers.SupplierID=PRODUCts.SupplierID
where CompanyName = 'Tokyo Traders'

--3
select customers.customerid, orderid, address
from customers left outer join orders 
on customers.CustomerID=Orders.CustomerID and year(orderdate) = 1997
where orderid is null

--4
select companyname, phone, productid, UnitsInStock
from suppliers inner join Products on Suppliers.SupplierID=Products.supplierID
where UnitsInStock=0

select distinct companyname, phone
from suppliers inner join Products on Suppliers.SupplierID=Products.supplierID
where UnitsInStock=0


--æwiczenie 2
--1
use library
select firstname, lastname, birth_date
from member inner join juvenile 
on member.member_no=juvenile.member_no

--2
select distinct title
from title inner join loan on title.title_no = loan.title_no


--3
select in_date, due_date, datediff(day, due_date, in_date) as ile_dni, fine_paid, fine_assessed
from title inner join loanhist on title.title_no=loanhist.title_no
where DATEDIFF(Day, due_date, in_date)>0  and title = 'Tao Teh King'

--4
select reservation.isbn, firstname, middleinitial, lastname
from member inner join reservation
on member.member_no = reservation.member_no
where lastname = 'Graff' and middleinitial='A'

--przyklad
use Northwind
select suppliers.companyname, shippers.companyname
from suppliers
cross join shippers
