USE publications;
--
-- CHALLENGE 1
--
-- Step 1
CREATE TEMPORARY TABLE royalties_sales
SELECT ta.title_id, ta.au_id,
(titles.price * sales.qty * (titles.royalty / 100) * (ta.royaltyper / 100)) AS sales_royalty
FROM titleauthor AS ta
LEFT JOIN titles
ON ta.title_id = titles.title_id
INNER JOIN sales
ON titles.title_id = sales.title_id;

-- Step 2
CREATE TEMPORARY TABLE royalties_author
SELECT title_id, au_id, (SELECT SUM(sales_royalty) GROUP BY title_id) AS sum_royalties
FROM royalties_sales
GROUP BY title_id, au_id
ORDER BY au_id;

-- Step 3
CREATE TEMPORARY TABLE total_profit
SELECT title_id, sum(advance) AS total_profit
FROM(
SELECT title_id, advance
FROM titles
UNION ALL
SELECT title_id, sum_royalties
FROM royalties_author) AS advance
GROUP BY title_id;

SELECT au_id, total_profit
FROM royalties_author
INNER JOIN total_profit
ON total_profit.title_id = royalties_author.title_id
ORDER BY total_profit DESC
LIMIT 3;
--
-- CHALLENGE 2
--
SELECT au_id, total_profit
FROM titleauthor
INNER JOIN(
SELECT title_id, sum(advance) AS total_profit
FROM
(SELECT title_id, advance
FROM titles
UNION ALL
SELECT title_id, sum_royalties
FROM
(SELECT title_id, au_id, (SELECT SUM(sales_royalty) GROUP BY title_id) AS sum_royalties -- royalties_author
	FROM
    (SELECT title_id, au_id, sales_royalty
	FROM -- royalties_sales
		(SELECT ta.title_id, ta.au_id,
		(titles.price * sales.qty * (titles.royalty / 100) * (ta.royaltyper / 100)) AS sales_royalty
		FROM titleauthor AS ta
		LEFT JOIN titles
		ON ta.title_id = titles.title_id
		INNER JOIN sales
		ON titles.title_id = sales.title_id) AS royalties_sales) AS royalties_author -- royalties_sales
	GROUP BY title_id, au_id
	ORDER BY au_id) AS P) AS advance GROUP BY title_id) AS X -- royalties_author
ON titleauthor.title_id = X.title_id
ORDER BY total_profit DESC
LIMIT 3;
-- 
-- CHALLENGE 3
--
CREATE TABLE most_profiting_authors
SELECT au_id, total_profit
FROM titleauthor
INNER JOIN(
SELECT title_id, sum(advance) AS total_profit
FROM
(SELECT title_id, advance
FROM titles
UNION ALL
SELECT title_id, sum_royalties
FROM
(SELECT title_id, au_id, (SELECT SUM(sales_royalty) GROUP BY title_id) AS sum_royalties -- royalties_author
	FROM
    (SELECT title_id, au_id, sales_royalty
	FROM -- royalties_sales
		(SELECT ta.title_id, ta.au_id,
		(titles.price * sales.qty * (titles.royalty / 100) * (ta.royaltyper / 100)) AS sales_royalty
		FROM titleauthor AS ta
		LEFT JOIN titles
		ON ta.title_id = titles.title_id
		INNER JOIN sales
		ON titles.title_id = sales.title_id) AS royalties_sales) AS royalties_author -- royalties_sales
	GROUP BY title_id, au_id
	ORDER BY au_id) AS P) AS advance GROUP BY title_id) AS X -- royalties_author
ON titleauthor.title_id = X.title_id
ORDER BY total_profit DESC;

select * from most_profiting_authors ORDER BY total_profit DESC;