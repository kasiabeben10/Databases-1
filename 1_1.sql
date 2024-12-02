use Northwind
--select CompanyName, Address from Customers
--select LastName, HomePhone from Employees
--select ProductName, UnitPrice from Products
--select CategoryName, Description from Categories
--select CompanyName, HomePage from Suppliers


select CompanyName, Address 
from Customers
where City='London'

select CompanyName, Address
from Customers
where Country='France' or Country='Spain'

select ProductName, UnitPrice
from Products
where UnitPrice>=20 and UnitPrice<=30

select ProductName, UnitPrice
from Products
where CategoryID=6

select ProductName, UnitsinStock
from Products
where SupplierID=4

select ProductName 
from Products
where UnitsInStock=0

SELECT companyname
FROM customers
WHERE companyname LIKE '%Restaurant%'
-----------
select * from Products 
where QuantityPerUnit LIKE '%bottle%'
-----------

select FirstName, LastName, Title
from Employees
where LastName like '[B-L]%'
------------

select FirstName, LastName, Title 
from Employees
where LastName like '[BL]%'
-----------

select CategoryName, Description
from Categories
where Description like '%,%'
-------------

select CompanyName, ContactName, Address
from Customers
where CompanyName like '%Store%'
-----------

select *
from Products
where UnitPrice<10 OR UnitPrice>20

select *
from Products
where UnitPrice not between 10 and 20
-----------

select ProductName, UnitPrice
from Products
where UnitPrice>=20 AND UnitPrice<=30
-----

select CompanyName, Country
from Customers
where Country = 'Japan' or Country = 'Italy'

select CompanyName, Country
from Customers
where Country IN ('Japan', 'Italy')
-----
select OrderID, OrderDate, CustomerID
from Orders
where (ShippedDate is null or ShippedDate>GETDATE()) and ShipCountry='Argentina'
----
select CompanyName, Country
from Customers
order by Country, CompanyName

select CompanyName, Country
from Customers
order by 2,1
------
select Categories.CategoryName, Products.ProductName, Products.UnitPrice
from Products
inner join Categories on Products.CategoryID=Categories.CategoryID
order by 1,3 desc
------
select CompanyName, Country
from Customers
where Country in ('Japan', 'Italy')
order by 2, 1
-------
select OrderID, ProductID, UnitPrice*Quantity*(1-Discount) as Value
from [Order Details]
where OrderID=10250
-------
select isnull(Phone,'-') + ', ' + isnull(Fax,'-') as 'Kontakt'
from Suppliers

select concat(Phone, ', ', Fax) as "Kontakt"
from Suppliers