/*
 * Compute the total revenue for each film.
 * The output should include a new column "rank" that shows the numerical rank
 *
 * HINT:
 * You should use the `rank` window function to complete this task.
 * Window functions are conceptually simple,
 * but have an unfortunately clunky syntax.
 * You can find examples of how to use the `rank` function at
 * <https://www.postgresqltutorial.com/postgresql-window-function/postgresql-rank-function/>.
 */
SELECT RANK() OVER (ORDER BY revenue DESC) AS rank, 
       title, 
       revenue,
       SUM(revenue) OVER (ORDER BY revenue DESC) AS "Total Revenue"
FROM (
    SELECT film.title, SUM(amount) AS revenue 
    FROM rental 
    JOIN payment USING (rental_id)
    JOIN inventory USING (inventory_id)
    JOIN film USING (film_id)
    GROUP BY film.title
) AS film_revenue;

