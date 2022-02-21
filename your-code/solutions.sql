USE publications;

-- Challenge 1:

-- Calculate the royalty of each sale for each author.

CREATE TEMPORARY TABLE royalties_author
SELECT t.title_id, ta.au_id, (t.price * s.qty * t.royalty / 100 * ta.royaltyper / 100) AS sales_royalty
FROM titles AS t
INNER JOIN titleauthor AS ta ON t.title_id = ta.title_id
INNER JOIN sales AS s ON t.title_id = s.title_id;

SELECT * FROM royalties_author;

-- Using the output from Step 1 as a temp table, aggregate the total royalties for each title for each author.

CREATE TEMPORARY TABLE royalties_author_grouped
SELECT title_id, au_id, sum(sales_royalty) AS sales_royalty_sum
FROM royalties_author
GROUP BY title_id, au_id;

SELECT * FROM royalties_author_grouped;

-- Using the output from Step 2 as a temp table, calculate the total profits of each author by aggregating the advances and total royalties of each title.

CREATE TEMPORARY TABLE top3_profitables
SELECT rag.au_id, (rag.sales_royalty_sum + t.advance) AS total_profit
FROM royalties_author_grouped AS rag
LEFT JOIN titles AS t ON rag.title_id = t.title_id
ORDER BY total_profit DESC
LIMIT 3;

SELECT * FROM top3_profitables;

-- Challenge 2:

-- Calculate the royalty of each sale for each author. USING DERIVED TABLES

SELECT t.title_id, ta.au_id, (t.price * s.qty * t.royalty / 100 * ta.royaltyper / 100) AS sales_royalty
FROM titles AS t
INNER JOIN titleauthor AS ta ON t.title_id = ta.title_id
INNER JOIN sales AS s ON t.title_id = s.title_id;

-- Using the output from Step 1 as a temp table, aggregate the total royalties for each title for each author. USING DERIVED TABLES

SELECT title_id, au_id, sum(sales_royalty) AS sales_royalty_sum
FROM (SELECT t.title_id, ta.au_id, (t.price * s.qty * t.royalty / 100 * ta.royaltyper / 100) AS sales_royalty
		FROM titles AS t
		INNER JOIN titleauthor AS ta ON t.title_id = ta.title_id
		INNER JOIN sales AS s ON t.title_id = s.title_id) AS td1
GROUP BY title_id, au_id;

-- Using the output from Step 2 as a temp table, calculate the total profits of each author by aggregating the advances and total royalties of each title. USING DERIVED TABLES

SELECT td2.au_id, (td2.sales_royalty_sum + t.advance) AS total_profit
FROM (SELECT title_id, au_id, sum(sales_royalty) AS sales_royalty_sum
		FROM (SELECT t.title_id, ta.au_id, (t.price * s.qty * t.royalty / 100 * ta.royaltyper / 100) AS sales_royalty
				FROM titles AS t
				INNER JOIN titleauthor AS ta ON t.title_id = ta.title_id
				INNER JOIN sales AS s ON t.title_id = s.title_id) AS td1
		GROUP BY title_id, au_id) AS td2
LEFT JOIN titles AS t ON td2.title_id = t.title_id
ORDER BY total_profit DESC
LIMIT 3;

-- Challenge 3:

-- Utilizo el metodo de derived tables ya que mi tabla temporal está limitada a 3 autores

-- QUERY CREACION DERIVED
CREATE TABLE most_profiting_authors AS
SELECT * FROM (SELECT td2.au_id, (td2.sales_royalty_sum + t.advance) AS total_profit
				FROM (SELECT title_id, au_id, sum(sales_royalty) AS sales_royalty_sum
						FROM (SELECT t.title_id, ta.au_id, (t.price * s.qty * t.royalty / 100 * ta.royaltyper / 100) AS sales_royalty
								FROM titles AS t
								INNER JOIN titleauthor AS ta ON t.title_id = ta.title_id
								INNER JOIN sales AS s ON t.title_id = s.title_id) AS td1
						GROUP BY title_id, au_id) AS td2
				LEFT JOIN titles AS t ON td2.title_id = t.title_id
				ORDER BY total_profit DESC) AS mpa;

-- QUERY VISUALIZACION DERIVED
SELECT * FROM most_profiting_authors
ORDER BY total_profit DESC;

-- Utilizo el metodo de temp tables a pesar de que mi tabla temporal está limitada a 3 autores

-- QUERY CREACION TEMP
CREATE TABLE most_profiting_authors_temp AS
SELECT * FROM top3_profitables;

-- QUERY VISUALIZACION TEMP
SELECT * FROM most_profiting_authors_temp
ORDER BY total_profit DESC;
