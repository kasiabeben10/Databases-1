--3.0 ci¹g dalszy
use Northwind

--æwiczenia strona 20
--1
select ProductName, UnitPrice, CategoryName, CompanyName, Address
from Products 
inner join Categories on Products.CategoryID=Categories.CategoryID
left outer join Suppliers on Products.SupplierID=Suppliers.SupplierID
where UnitPrice between 20 and 30 and CategoryName='Meat/Poultry'

--2
select ProductName, UnitPrice, CategoryName, CompanyName
from Products 
inner join Categories on Products.CategoryID=Categories.CategoryID
left outer join Suppliers on Products.SupplierID=Suppliers.SupplierID
where CategoryName='Confections'

--3
select distinct Customers.CompanyName,Customers.Phone
from Customers 
inner join Orders on Customers.CustomerID=Orders.CustomerID
inner join Shippers on Orders.ShipVia=Shippers.ShipperID
where year(ShippedDate)=1997 and Shippers.CompanyName='United Package'

--4
select distinct CompanyName, Phone
from Customers 
inner join Orders on Customers.CustomerID=Orders.CustomerID
inner join [Order Details] on [Order Details].OrderID=Orders.OrderID
inner join Products on [Order Details].ProductID=Products.ProductID
inner join Categories on Categories.CategoryID=Products.CategoryID
where CategoryName='Confections'

--æwiczenia strona 21
use library
--1
select firstname, lastname, birth_date, street +' '+ city+' '+ state as Address
from member
inner join juvenile on juvenile.member_no=member.member_no
inner join adult on juvenile.adult_member_no=adult.member_no

--2
select m.firstname, m.lastname, birth_date, street +' '+ city+' '+ state as Address, am.firstname as imie_rodzica, am.lastname as nazwisko_rodzica
from member as m
inner join juvenile on m.member_no=juvenile.member_no
inner join adult on adult.member_no=juvenile.adult_member_no
inner join member as am on am.member_no=adult.member_no


--æwiczenia strona 26
use northwind

--1
select e.firstname+' '+e.lastname as Pracownik, ee.firstname+' '+ee.lastname as Podwladny
from employees as e
inner join employees as ee on ee.reportsto=e.EmployeeID
group by e.firstname+' '+e.lastname, ee.firstname+' '+ee.lastname with rollup
having e.firstname+' '+e.lastname is not null and ee.firstname+' '+ee.lastname is not null

-- v2
select a. employeeid, a.FirstName + a. LastName as Szef ,
       b. EmployeeID, b. FirstName + b. LastName as Podw³adny
from Employees as a
join Employees as b
on b. ReportsTo = a. EmployeeID

--2
select e.firstname+' '+e.lastname as Pracownik
from employees as e
left join employees as ee on ee.reportsto=e.EmployeeID
group by e.firstname+' '+e.lastname
having count(ee.employeeid)=0


use library
--3
select a.member_no, a.street+' '+a.city+ ' '+a.state as Address
from adult as a
inner join juvenile j on j.adult_member_no=a.member_no
where j.birth_date < '1996/01/01'

--4
select a.member_no, a.street+' '+a.city+ ' '+a.state as Address
from adult as a
inner join juvenile j on j.adult_member_no=a.member_no and j.birth_date < '1996/01/01'
left join loan l on l.member_no=a.member_no
group by a.member_no, a.street+' '+a.city+ ' '+a.state
having count(l.isbn)=0


--æwiczenia strona 28
use library

--1
select firstname+' '+lastname as name,  a.street+' '+a.city+ ' '+a.state+' ' +a.zip as adress
from member as m
inner join adult as a on a.member_no=m.member_no

--2
select l.isbn, l.copy_no, on_loan, title, translation, cover
from loan as l
inner join copy as c on c.isbn=l.isbn
inner join title as t on l.title_no = t.title_no
inner join item as i on i.isbn = c.isbn
where l.isbn = 1 or l.isbn=500 or l.isbn=1000
group by l.isbn, l.copy_no, on_loan, title, translation, cover
order by l.isbn


--3
select m.member_no, firstname, lastname, r.isbn, r.log_date
from member m
left join reservation r on r.member_no=m.member_no
where m.member_no=250 or m.member_no=342 or m.member_no=1675
group by m.member_no, firstname, lastname, r.isbn, r.log_date

--4
use library
select m.member_no, m.firstname+m.lastname as ImieINazwisko, count(j.adult_member_no) as LiczbaDzieci
from member m
inner join adult a on a.member_no=m.member_no and a.state='AZ'
left join juvenile j on j.adult_member_no=a.member_no
group by m.member_no, m.firstname+m.lastname
having count(j.adult_member_no)>2

--5
select m.member_no, m.firstname+' '+m.lastname as name, count(j.adult_member_no) as liczbaDzieci
from member m
inner join adult a on a.member_no=m.member_no and a.state='AZ'
left join juvenile j on j.adult_member_no=a.member_no
group by m.member_no, m.firstname+' '+m.lastname, a.state
having count(j.adult_member_no)>2
UNION
select m.member_no, m.firstname+' '+m.lastname as name, count(j.adult_member_no) as liczbaDzieci
from member m
inner join adult a on a.member_no=m.member_no and a.state='CA'
left join juvenile j on j.adult_member_no=a.member_no
group by m.member_no, m.firstname+' '+m.lastname, a.state
having count(j.adult_member_no)>3

-- bez union
SELECT member_no, name, SUM(count_child) as liczbaDzieci, state
FROM
(
    SELECT
        m.member_no,
        m.firstname+' '+m.lastname as name,
        count(j.adult_member_no) as count_child,
        a.state as state
    FROM member m
    INNER JOIN adult a ON a.member_no=m.member_no
    LEFT JOIN juvenile j ON j.adult_member_no=a.member_no
    WHERE a.state IN ('AZ', 'CA')
    GROUP BY m.member_no, m.firstname+' '+m.lastname, a.state
    HAVING
        (a.state = 'AZ' AND count(j.adult_member_no)>2) OR
        (a.state = 'CA' AND count(j.adult_member_no)>3)
) as t
GROUP BY member_no, name, state
ORDER BY 4, 1

