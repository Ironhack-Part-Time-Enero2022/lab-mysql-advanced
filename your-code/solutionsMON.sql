USE publications;

-- CHALLENGE 1 

--  Step 1

Select titleauthor.title_id AS TITLEID
, titleauthor.au_id AS AUTHORID
, (titles.price * sales.qty * (titles.royalty / 100) * (titleauthor.royaltyper / 100)) AS SALESROYALTY
from titleauthor
left join titles ON titleauthor.title_id = titles.title_id
inner join sales ON titles.title_id = sales.title_id;

-- Step2 

select title_id, au_id, SALESROYALTY
From 
(Select titleauthor.title_id AS TITLEID
, titleauthor.au_id AS AUTHORID
, (titles.price * sales.qty * (titles.royalty / 100) * (titleauthor.royaltyper / 100)) AS SALESROYALTY
from titleauthor
left join titles ON titleauthor.title_id = titles.title_id
inner join sales ON titles.title_id = sales.title_id) AS ROYALTY
group by title_id, au_id;
Error Code: 1054. Unknown column 'title_id' in 'field list'
Error Code: 1054. Unknown column 'titleauthor.title_id' in 'field list'

