use library

----æw 1
select title, title_no
from title
------
select title, title_no
from title
where title_no=10
----
select title_no, author
from title
where author in ('Charles Dickens', 'Jane Austen')

----æw 2
select title_no, title
from title
where title like '%adventure%'
----
select distinct member_no, isnull(fine_paid,0) as fine_paid
from loanhist
where isnull(fine_paid,0)>0
order by fine_paid
----
select distinct city, state
from adult
----
select title
from title
order by 1

----æw 3
select member_no, isbn, fine_assessed, 2*fine_assessed as 'double fine'
from loanhist
where isnull(fine_assessed, 0) != 0
----
--select isbn, 2*isnull(fine_assessed,0) as 'double fine'
--from loanhist
--where isnull(fine_assessed,0)!=0

----æw 4
select firstname+middleinitial+lastname as email_name
from member
where lastname='Anderson'
----

select LOWER(firstname+middleinitial+SUBSTRING(lastname,1,2)) as email_name
from member
where lastname='Anderson'

----æw 5
select 'The title is: ' + title + ', title number ' + str(title_no) as 'title and title_no'
from title

select 'The title is: ' + title + ', title number ' + cast(title_no as varchar) as 'title and title_no'
from title

select 'The title is: ' + title + ', title number ' + convert(varchar, title_no) as 'title and title_no'
from title

--select 'The title is: ' + title + concat(', title number + title_no)) as 'title and title_no'
--from title


