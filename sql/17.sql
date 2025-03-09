/*
 * Compute the total revenue for each film.
 * The output should include another new column "total revenue" that shows the sum of all the revenue of all previous films.
 *
 * HINT:
 * My solution starts with the solution to problem 16 as a subquery.
 * Then I combine the SUM function with the OVER keyword to create a window function that computes the total.
 * You might find the following stackoverflow answer useful for figuring out the syntax:
 * <https://stackoverflow.com/a/5700744>.
 */
WITH ranked_films AS (
    SELECT RANK() OVER (ORDER BY revenue DESC) AS rank,
           DENSE_RANK() OVER (ORDER BY revenue DESC) AS dense_rank,
           title,
           revenue
    FROM (
        SELECT film.title,
               COALESCE(SUM(payment.amount), 0.00) AS revenue
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
           SUM(revenue) OVER (ORDER BY dense_rank ASC ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW) AS "total revenue"
    FROM ranked_films
)
SELECT rank,
       title,
       revenue,
       MAX("total revenue") OVER (PARTITION BY rank) AS "total revenue"
FROM cumulative_total
ORDER BY rank ASC, title ASC;

