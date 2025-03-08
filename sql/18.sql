/*
 * Compute the total revenue for each film.
 * The output should include another new column "revenue percent" that shows the percent of total revenue that comes from the current film and all previous films.
 * That is, the "revenue percent" column is 100*"total revenue"/sum(revenue)
 *
 * HINT:
 * The `to_char` function can be used to achieve the correct formatting of your percentage.
 * See: <https://www.postgresql.org/docs/current/functions-formatting.html#FUNCTIONS-FORMATTING-EXAMPLES-TABLE>
 */
WITH revenue_data AS (
    SELECT RANK() OVER (ORDER BY revenue DESC) AS rank, 
           title, 
           revenue,
           SUM(revenue) OVER (ORDER BY revenue DESC) AS "Total Revenue",
           SUM(revenue) OVER () AS grand_total
    FROM (
        SELECT film.title, SUM(amount) AS revenue 
        FROM rental 
        JOIN payment USING (rental_id)
        JOIN inventory USING (inventory_id)
        JOIN film USING (film_id)
        GROUP BY film.title
    ) AS film_revenue
)
SELECT rank, title, revenue, "Total Revenue",
       ROUND(100.0 * "Total Revenue" / grand_total, 2) AS "Percent Revenue"
FROM revenue_data;

