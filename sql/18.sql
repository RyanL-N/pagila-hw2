/*
 * Compute the total revenue for each film.
 * The output should include another new column "revenue percent" that shows the percent of total revenue that comes from the current film and all previous films.
 * That is, the "revenue percent" column is 100*"total revenue"/sum(revenue)
 *
 * HINT:
 * The `to_char` function can be used to achieve the correct formatting of your percentage.
 * See: <https://www.postgresql.org/docs/current/functions-formatting.html#FUNCTIONS-FORMATTING-EXAMPLES-TABLE>
 */
WITH ranked_films AS (
    SELECT RANK() OVER (ORDER BY revenue DESC) AS rank,
           DENSE_RANK() OVER (ORDER BY revenue DESC) AS dense_rank,
           title,
           revenue
    FROM (
        SELECT film.title, 
               COALESCE(ROUND(SUM(payment.amount), 2), 0.00) AS revenue
        FROM film
        LEFT JOIN inventory USING (film_id)
        LEFT JOIN rental USING (inventory_id)
        LEFT JOIN payment USING (rental_id)
        GROUP BY film.title
    ) AS film_revenue
),
cumulative_total AS (
    SELECT rank,
           title,
           revenue,
           SUM(revenue) OVER (ORDER BY dense_rank ASC ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW) AS "total revenue",
           SUM(revenue) OVER () AS "grand_total"
    FROM ranked_films
),
final_output AS (
    SELECT rank,
           title,
           revenue,
           MAX("total revenue") OVER (PARTITION BY rank) AS "total revenue",
           ROUND(100.00 * MAX("total revenue") OVER (PARTITION BY rank) / "grand_total", 2) AS "percent revenue"
    FROM cumulative_total
)
SELECT rank,
       title,
       revenue,
       "total revenue",
       CASE 
           WHEN "total revenue" = (SELECT MAX("total revenue") FROM final_output) 
           THEN '100.00' 
           ELSE TO_CHAR("percent revenue", 'FM00.00')
       END AS "percent revenue"
FROM final_output
ORDER BY rank ASC, title ASC;

