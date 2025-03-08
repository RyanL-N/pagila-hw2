/*
 * Compute the total revenue for each film.
 */
SELECT title, SUM(amount) AS revenue
FROM rental
JOIN payment USING (rental_id)
JOIN inventory USING (inventory_id)
JOIN film USING (film_id)
GROUP BY title;

