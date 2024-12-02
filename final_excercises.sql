--2023/24

--podaj nazw� produktu dla kt�rego osi�gni�to minimalny ale niezerowy zwysk w 1996
select top 1 p.productname, sum(od.unitprice*od.quantity*(1-od.discount)) 
from Products p
inner join [Order Details] od on od.ProductID=p.ProductID
inner join orders o on o.OrderID=od.OrderID
where year(o.OrderDate)=1996
group by p.ProductID, p.Productname
having sum(od.unitprice*od.quantity*(1-od.discount))>0
order by sum(od.unitprice*od.quantity*(1-od.discount)) 

-- podaj tytu�y ksi��ek, kt�re zosta�y wypo�yczone przez wi�cej ni� jednego czytelnika, kt�ry 
-- posiada dzieci, podaj imie i nazwisko tych czytelnik�w
use library
select distinct firstname, lastname, title
from title t
inner join loanhist lh on lh.title_no=t.title_no
inner join member m on m.member_no=lh.member_no
where t.title_no in (select title_no from loanhist group by title_no having count(distinct member_no)>1)
and m.member_no in (select adult_member_no from juvenile)


--podaj wszystkie zam�wienia dla kt�rych op�ata za przesy�k� > �redniej w danym roku
use Northwind
select o.orderid
from orders o
where freight > (select avg(o2.freight) from orders o2 where year(o2.orderdate)=year(o.orderdate))




--2021/22

--Zad.1. Wy�wietl produkt, kt�ry przyni�s� najmniejszy, ale niezerowy, przych�d w 1996 roku
select top 1 p.productname, sum(od.unitprice*od.quantity*(1-od.discount)) 
from Products p
inner join [Order Details] od on od.ProductID=p.ProductID
inner join orders o on o.OrderID=od.OrderID
where year(o.OrderDate)=1996
group by p.ProductID, p.Productname
having sum(od.unitprice*od.quantity*(1-od.discount))>0
order by sum(od.unitprice*od.quantity*(1-od.discount)) 

--Zad.2. Wy�wietl wszystkich cz�onk�w biblioteki (imi� i nazwisko, adres) 
--rozr�niaj�c doros�ych i dzieci (dla doros�ych podaj liczb� dzieci),
--kt�rzy nigdy nie wypo�yczyli ksi��ki
use library
select m.firstname, m.lastname, a.street, 'adult', count(j.adult_member_no) as children
from member m
inner join adult a on a.member_no=m.member_no
left join juvenile j on j.adult_member_no=a.member_no
where m.member_no not in (select lh.member_no from loanhist lh)
and m.member_no not in (select l.member_no from loan l)
group by m.firstname, m.lastname, a.street
UNION
select m1.firstname, m1.lastname, a1.city, 'child', null
from member m1
inner join juvenile j1 on m1.member_no=j1.member_no
inner join adult a1 on j1.adult_member_no=a1.member_no
where m1.member_no not in (select l.member_no from loan l)
and m1.member_no not in (select lh.member_no from loanhist lh)
group by m1.firstname, m1.lastname, a1.city

--Zad.3. Wy�wietl podsumowanie zam�wie� (ca�kowita cena + fracht) obs�u�onych 
-- przez pracownik�w w lutym 1997 roku, uwzgl�dnij wszystkich, nawet je�li suma wynios�a 0.
use Northwind
select e.employeeid, e.FirstName, e.LastName, round(sum(od.quantity*od.unitprice*(1-od.discount)) + sum(o.freight),2) as value
from Employees e
left join orders o on o.EmployeeID=e.EmployeeID and year(o.orderdate) = 1997 and month(o.orderdate)=2
left join [order details] od on od.OrderID=o.OrderID
group by e.EmployeeID, e.FirstName, e.LastName



--2019/20
-- Wypisz wszystkich cz�onk�w biblioteki z adresami i info czy jest dzieckiem czy nie i 
-- ilo�� wypo�ycze� w poszczeg�lnych latach i miesi�cach. 
use library
select m.firstname, m.lastname, a.street, 'adult', year(out_date) as year, month(out_date) as month, count(*) as cnt
from member m 
inner join adult a on a.member_no=m.member_no
inner join loanhist lh on lh.member_no=m.member_no
group by m.firstname, m.lastname, a.street, year(out_date), month(out_date)
UNION
select m.firstname, m.lastname, a.street, 'child', year(out_date) as year, month(out_date) as month, count(*) as cnt
from member m 
inner join juvenile j on j.member_no=m.member_no
inner join adult a on a.member_no=j.adult_member_no
inner join loanhist lh on lh.member_no=m.member_no
group by m.firstname, m.lastname, a.street, year(out_date), month(out_date)
order by 1, 2, 5, 6

--Zam�wienia z Freight wi�kszym ni� AVG danego roku.
use Northwind
select o.orderid
from orders o
where freight>(select avg(freight) from orders o2 where year(o.orderdate)=year(o2.orderdate))

--Klienci, kt�rzy nie zam�wili nigdy nic z kategorii 'Seafood' w trzech wersjach. 
select c.customerid, c.companyname
from Customers c
left join orders o on o.CustomerID=c.CustomerID
left join [Order Details] od on od.OrderID=o.orderid
left join products p on p.ProductID=od.ProductID
left join Categories cat on cat.CategoryID=p.CategoryID and cat.CategoryName='Seafood'
group by c.customerid, c.CompanyName
having count(cat.CategoryID)=0

select c.customerid, c.companyname
from customers c
where not exists( 
	select * from orders o 
	where o.CustomerID=c.CustomerId and exists(
		select * from [Order Details] od
		where od.orderid=o.orderid and exists(
			select * from Products p 
			where p.ProductID=od.ProductID and exists(
				select * from Categories cat
				where cat.CategoryID=p.CategoryID and cat.CategoryName='Seafood'))))

select c.customerid, c.companyname
from customers c
where c.customerid not in(
	select customerid
	from Orders
	where orderid in(
		select orderid from [Order Details]
		where ProductID in(
			select ProductID from Products
			where CategoryID in (
				select CategoryID from Categories
				where CategoryName='Seafood'))))


--Dla ka�dego klienta najcz�ciej zamawian� kategori� w dw�ch wersjach. 
select c.customerid, c.companyname, (select top 1 cat.CategoryName 
									from Categories cat 
									right join products p on p.CategoryID=cat.categoryid
									right join [Order Details] od on od.ProductID=p.ProductID
									right join orders o on o.OrderID=od.orderid
									right join customers c1 on c1.CustomerID=o.CustomerID and c1.CustomerID=c.customerid
									group by cat.categoryid, cat.categoryname 
									order by count(od.productid) desc)
from Customers c
group by c.customerid, c.CompanyName
order by 1, 2, 3

select c.customerid, c.companyname, cat.categoryname
from customers c
inner join orders o on o.customerid=c.customerid
inner join [Order Details] od on od.orderid=o.orderid
inner join Products p on od.ProductID=p.ProductID
inner join Categories cat on cat.CategoryID=p.CategoryID
group by c.customerid, c.CompanyName, cat.CategoryName
having count(od.ProductID) =  (select max(t.cnt)
								from (select count(od1.productid) as cnt
										from orders o1 
										inner join [Order Details] od1 on od1.orderid=o1.orderid
										inner join Products p1 on p1.ProductID=od1.productid
										inner join Categories cat1 on cat1.CategoryID=p1.CategoryID
										where o1.customerid = c.customerid
										group by cat1.CategoryID) as t)
order by 1, 2, 3
								

--Podzia� na company, year month i suma freight
select s.shipperid, s.companyname, year(o.orderdate) as year, month(o.orderdate) as month, sum(o.freight) as freight_value
from shippers s
left join orders o on o.shipvia=s.shipperid
group by s.shipperid, s.companyname, year(o.orderdate), month(o.orderdate)

--Wypisa� wszystkich czytelnik�w, kt�rzy nigdy nie wypo�yczyli ksi��ki dane 
--adresowe i podzia� czy ta osoba jest dzieckiem (joiny, in, exists) 
use library
select m.member_no, m.firstname, m.lastname, a.street, 'adult'
from member m
inner join adult a on a.member_no=m.member_no
left join loanhist lh on lh.member_no=m.member_no
left join loan l on l.member_no=m.member_no
group by m.member_no, m.firstname, m.lastname, a.street
having count(lh.isbn)=0 and count(l.isbn)=0
UNION
select m.member_no, m.firstname, m.lastname, a.street, 'child'
from member m
inner join juvenile j on j.member_no=m.member_no
inner join adult a on a.member_no=j.adult_member_no
left join loanhist lh on lh.member_no=m.member_no
left join loan l on l.member_no=m.member_no
group by m.member_no, m.firstname, m.lastname, a.street
having count(lh.isbn)=0 and count(l.isbn)=0

-- Najcz�ciej wybierana kategoria w 1997 dla ka�dego klienta 
--by�o

-- Dla ka�dego czytelnika imi� nazwisko, suma ksi��ek wypo�yczony przez t� osob� i 
-- jej dzieci, kt�ry �yje w Arizona ma mie� wi�cej ni� 2 dzieci lub kto �yje w Kalifornii 
-- ma mie� wi�cej ni� 3 dzieci 
select m.member_no, m.firstname, m.lastname,count(distinct j.member_no), count(l.isbn)+count(lh.isbn)
											+(select count(l1.isbn) + count(lh1.isbn)
											from juvenile j1
											left join loan l1 on l1.member_no=j1.member_no
											left join loanhist lh1 on lh1.member_no=j1.member_no
											where j1.adult_member_no=m.member_no)
from member m 
inner join adult a on a.member_no=m.member_no
left join juvenile j on j.adult_member_no=a.member_no
left join loan l on l.member_no=m.member_no
left join loanhist lh on lh.member_no=m.member_no
where state='AZ'
group by m.member_no, m.firstname, m.lastname
having (count(distinct j.member_no)>2)
UNION
select m.member_no, m.firstname, m.lastname,count(distinct j.member_no), count(l.isbn)+count(lh.isbn)
											+(select count(l1.isbn) + count(lh1.isbn)
											from juvenile j1
											left join loan l1 on l1.member_no=j1.member_no
											left join loanhist lh1 on lh1.member_no=j1.member_no
											where j1.adult_member_no=m.member_no)
from member m 
inner join adult a on a.member_no=m.member_no
left join juvenile j on j.adult_member_no=a.member_no
left join loan l on l.member_no=m.member_no
left join loanhist lh on lh.member_no=m.member_no
where state='CA'
group by m.member_no, m.firstname, m.lastname
having (count(distinct j.member_no)>3)


--Jaki by� najpopularniejszy autor w�r�d dzieci w Arizonie w 2001 
select top 1 t.author
from title t
inner join loanhist lh on lh.title_no=t.title_no
inner join juvenile j on j.member_no=lh.member_no
inner join adult a on a.member_no=j.adult_member_no
where state='AZ' and year(out_date)=2001
group by t.author
order by count(t.author) desc

--Dla ka�dego dziecka wybierz jego imi� nazwisko, adres, imi� i nazwisko rodzica i 
--ilo�� ksi��ek, kt�re oboje przeczytali w 2001 
select j.member_no, m.firstname, m.lastname, a.city, m1.firstname, m1.lastname, count(distinct lh.isbn)+count(distinct lh1.isbn)
from juvenile j
inner join member m on m.member_no=j.member_no
inner join member m1 on j.adult_member_no=m1.member_no
inner join adult a on m1.member_no=a.member_no
left join loanhist lh on lh.member_no=j.member_no and year(lh.in_date)=2001
left join loanhist lh1 on lh1.member_no=m1.member_no and year(lh1.in_date)=2001
group by j.member_no, m.firstname, m.lastname, a.city, m1.firstname, m1.lastname
order by 1

--Kategorie kt�re w roku 1997 grudzie� by�y obs�u�one wy��cznie przez �United Package� 
use Northwind
select distinct cat.categoryname 
from categories cat
inner join products p on p.categoryid=cat.categoryid
inner join [Order Details] od on od.ProductID=p.ProductID
inner join orders o on o.orderid=od.orderid
inner join shippers s on s.ShipperID=o.shipvia
where s.CompanyName='United Package' and year(o.ShippedDate)=1997 and month(o.shippeddate)=12
except 
select distinct cat.categoryname 
from categories cat
inner join products p on p.categoryid=cat.categoryid
inner join [Order Details] od on od.ProductID=p.ProductID
inner join orders o on o.orderid=od.orderid
inner join shippers s on s.ShipperID=o.shipvia
where s.companyname<>'United Package' and year(o.ShippedDate)=1997 and month(o.shippeddate)=12


--Wybierz klient�w, kt�rzy kupili przedmioty wy��cznie z jednej kategorii w marcu 1997 
--i wypisz nazw� tej kategorii 
select distinct c.customerid, c.companyname, cat.CategoryName
from customers c
inner join orders o on o.CustomerID=c.CustomerID and year(o.orderdate)=1997 and month(o.orderdate)=3
inner join [Order Details] od on od.orderid=o.orderid
inner join products p on p.ProductID=od.ProductID
inner join Categories cat on cat.CategoryID=p.CategoryID
where c.CustomerID not in (select c1.customerid from customers c1
							inner join orders o1 on o1.CustomerID=c1.CustomerID and year(o1.orderdate)=1997 and month(o1.orderdate)=3
							inner join [Order Details] od1 on od1.OrderID=o1.orderid
							inner join Products p1 on p1.ProductID=od1.ProductID
							inner join Categories cat1 on cat1.CategoryID=p1.CategoryID
							where cat.CategoryID<>cat1.CategoryID)



--Wybierz dzieci wraz z adresem, kt�re nie wypo�yczy�y ksi��ek w lipcu 2001 autorstwa �Jane Austin�
use library
select distinct m.firstname, m.lastname, a.street
from member m
inner join juvenile j on j.member_no=m.member_no
inner join adult a on j.adult_member_no=a.member_no
left join loanhist lh on lh.member_no=m.member_no and year(lh.out_date)=2001 and month(lh.out_date)=7
left join title t on t.title_no=lh.title_no and t.author='Jane Austin'
group by m.firstname, m.lastname, a.street
having count(t.title_no)=0


--Wybierz kategori�, kt�ra w danym roku 1997 najwi�cej zarobi�a, podzia� na miesi�ce
use Northwind

with t as (
select cat.categoryid, cat.categoryname, month(o.orderdate) as month, sum(od.quantity*od.unitprice*(1-discount)) as category_value
from Categories cat
inner join Products p on p.categoryid=cat.categoryid
inner join [Order Details] od on od.ProductID=p.ProductID
inner join orders o on o.orderid=od.orderid 
where year(o.OrderDate)=1997
group by cat.categoryid,cat.CategoryName, month(o.orderdate))

select categoryname, month, category_value
from t t1
where category_value = (select max(category_value) from t t2 where t2.month=t1.month group by month)
order by 2

--Dane pracownika i najcz�stszy dostawca pracownik�w bez podw�adnych 

