use publications;

-- CHALLENGE 1
with a as (select 
	ta.au_id 															as author_id
    , ta.title_id 														as title_id
    , t.advance 
	, t.price * s.qty * t.royalty / 100 * ta.royaltyper / 100 			as sales_royalty
from `publications`.`titleauthor` ta
inner join `publications`.`titles` t 
	on ta.title_id = t.title_id
inner join `publications`.`sales` s
	on t.title_id = s.title_id
)

select 
	author_id
    , sum(sales_royalty) 	as sales_royalty
    , sum(advance) 		as advance
from a 
group by 1;
	
-- CHALLENGE 2

create temporary table a
select 
	ta.au_id 															as author_id
    , ta.title_id 														as title_id
    , t.advance 
	, t.price * s.qty * t.royalty / 100 * ta.royaltyper / 100 			as sales_royalty
from `publications`.`titleauthor` ta
inner join `publications`.`titles` t 
	on ta.title_id = t.title_id
inner join `publications`.`sales` s
	on t.title_id = s.title_id;
    
 select 
	author_id
    , sum(sales_royalty) 	as sales_royalty
    , sum(advance) 		as advance
from a 
group by 1;   

-- CHALLENGE 3

create table `publications`.`most_profiting_authors`
with aux as (select 
	ta.au_id 															as author_id
    , ta.title_id 														as title_id
    , t.advance 
	, t.price * s.qty * t.royalty / 100 * ta.royaltyper / 100 			as sales_royalty
from `publications`.`titleauthor` ta
inner join `publications`.`titles` t 
	on ta.title_id = t.title_id
inner join `publications`.`sales` s
	on t.title_id = s.title_id
)

select 
	author_id
    , sum(sales_royalty) +  sum(advance)	as profits
from aux 
group by 1;