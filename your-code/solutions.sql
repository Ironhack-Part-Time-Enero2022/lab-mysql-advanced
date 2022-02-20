use publications;


-- CHALLENGE 1 

--  Step1 

select tau.title_id, tau.au_id, (t.price * s.qty * (t.royalty / 100) * (tau.royaltyper / 100)) as sales_royalty
from titleauthor as tau
left join titles as t on tau.title_id = t.title_id
inner join sales as s on t.title_id = s.title_id;

-- Step2 

select title_id, au_id, sales_royalty
From
	(select tau.title_id, tau.au_id, (t.price * s.qty * (t.royalty / 100) * (tau.royaltyper / 100)) as sales_royalty
	from titleauthor as tau
	left join titles as t on tau.title_id = t.title_id
	inner join sales as s on t.title_id = s.title_id) as royalty_sales
group by title_id, au_id;

-- Step3, a unirlo

select au_id, profit_
from titleauthor
inner join(
select title_id, sum(advance) as profit_
from 
(select title_id, advance
from titles
union all
select title_id, suma_roy
from
(select title_id, au_id, (select sum(sales_royalty) group by title_id) as suma_roy 
	from
	(select title_id, au_id, sales_royalty
	From
		(select tau.title_id, tau.au_id, (t.price * s.qty * (t.royalty / 100) * (tau.royaltyper / 100)) as sales_royalty
		from titleauthor as tau
		left join titles as t on tau.title_id = t.title_id
		inner join sales as s on t.title_id = s.title_id) as royal_sls) as royal_au
	group by title_id, au_id
    order by au_id) as P) as advance group by title_id) as Y
on titleauthor.title_id = Y.title_id
order by profit_ desc
limit 3;

-- CHALLENGE 2, A VER la he cagado por que no me di cuenta que el 2 era el 1 pero de otra manera ! esta vez con tablas temporales

-- tabla 1 - sales_royalty - para calcular las royalties para todas las ventas, acá tenemos repetidos. 
create temporary table royal_sls
select tau.title_id, tau.au_id, (t.price * s.qty * (t.royalty / 100) * (tau.royaltyper / 100)) as sales_royalty
from titleauthor as tau
left join titles as t on tau.title_id = t.title_id
inner join sales as s on t.title_id = s.title_id;

-- tabla 2 - royal_au - para simplemente espaciar la royalties por autor

create temporary table royal_au
select title_id, au_id, (select sum(sales_royalty) group by title_id) as suma_roy
from royal_sls
group by title_id,au_id
order by au_id;

-- tabla 3 - profit_ 

create temporary table profit_
select title_id, sum(advance) as profit_
from(
select title_id, advance
from titles
union all -- esto no entendi bien, pero googleado. 
select title_id, suma_roy
from royal_au) as advance
group by title_id;

-- resultado final

select au_id, profit_
from royal_au as ra
inner join profit_ as pr on ra.title_id = pr.title_id
order by profit_ desc
limit 3;

-- CHALLENGE 3 - crear tabla permanente, he usado la subquery por que quiero que se me guarde la tabla. no se por que pensé que con temporales no se me iba a guardar, pero avisame. 

create table most_profiting_authors
select au_id, profit_
from titleauthor
inner join(
select title_id, sum(advance) as profit_
from 
(select title_id, advance
from titles
union all
select title_id, suma_roy
from
(select title_id, au_id, (select sum(sales_royalty) group by title_id) as suma_roy 
	from
	(select title_id, au_id, sales_royalty
	From
		(select tau.title_id, tau.au_id, (t.price * s.qty * (t.royalty / 100) * (tau.royaltyper / 100)) as sales_royalty
		from titleauthor as tau
		left join titles as t on tau.title_id = t.title_id
		inner join sales as s on t.title_id = s.title_id) as royal_sls) as royal_au
	group by title_id, au_id
    order by au_id) as P) as advance group by title_id) as Y
on titleauthor.title_id = Y.title_id
order by profit_ desc;

select * from most_profiting_authors order by profit_ desc;

