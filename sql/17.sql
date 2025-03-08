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

