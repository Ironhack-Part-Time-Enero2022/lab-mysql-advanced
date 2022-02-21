USE publications;

SELECT calc_ganancia.au_id as autor, (sum(calc_ganancia.sales_ganancia) + calc_ganancia.advance) as ganancia ##Para tener una query englobada en otra: https://stackoverflow.com/questions/31979008/sql-two-select-statements-in-one-query y https://stackoverflow.com/questions/4441590/how-do-i-combine-multiple-sql-queries
FROM (
SELECT titleauthor.au_id, titleauthor.title_id, titles.advance, titles.price * sales.qty * (titles.royalty/100) * (titleauthor.royaltyper/100) as sales_ganancia
FROM titleauthor
INNER JOIN titles ON titleauthor.title_id = titles.title_id
INNER JOIN sales ON titleauthor.title_id = sales.title_id) as calc_ganancia
GROUP BY calc_ganancia.title_id, calc_ganancia.au_id
ORDER BY ganancia DESC
LIMIT 3;


CREATE TEMPORARY TABLE ejerc_2
SELECT titleauthor.au_id, titleauthor.title_id, titles.advance, (titles.price * sales.qty * (titles.royalty/100) * (titleauthor.royaltyper/100)) as sales_ganancia
FROM titleauthor
INNER JOIN titles ON titleauthor.title_id = titles.title_id
INNER JOIN sales ON titleauthor.title_id = sales.title_id

SELECT calc_ganancia.au_id as autor, (sum(calc_ganancia.sales_ganancia) + calc_ganancia.advance) as ganancia ##Me da error 1064 de sintaxis, sin embargo, tengo el mismo caso que el anterior. No lo comprendo.
FROM ejerc_2
GROUP BY calc_ganancia.title_id, calc_ganancia.au_id
ORDER BY ganancia DESC
LIMIT 3; 

CREATE TABLE most_profiting_authors ##La creo con el ejercicio 1 porque no entiendo el fallo en el segundo.
SELECT calc_ganancia.au_id as autor, (sum(calc_ganancia.sales_ganancia) + calc_ganancia.advance) as ganancia
FROM (
SELECT titleauthor.au_id, titleauthor.title_id, titles.advance, (titles.price * sales.qty * (titles.royalty/100) * (titleauthor.royaltyper/100)) as sales_ganancia
FROM titleauthor
INNER JOIN titles ON titleauthor.title_id = titles.title_id
INNER JOIN sales ON titleauthor.title_id = sales.title_id) as calc_ganancia
GROUP BY calc_ganancia.title_id, calc_ganancia.au_id
ORDER BY ganancia DESC
LIMIT 3;