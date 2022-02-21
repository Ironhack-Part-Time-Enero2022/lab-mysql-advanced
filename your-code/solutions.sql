USE publications;

-- Query 1

SELECT t.title_id, ti.au_id, (t.price * s.qty * t.royalty / 100 * ti.royaltyper / 100) AS sales_royalty
FROM titles AS t
INNER JOIN titleauthor AS ti ON t.title_id = ti.title_id
INNER JOIN sales AS s ON t.title_id = s.title_id
ORDER BY sales_royalty DESC
LIMIT 3;

