/*
 * Management wants to send coupons to customers who have previously rented one of the top-5 most profitable movies.
 * Your task is to list these customers.
 *
 * HINT:
 * In problem 16 of pagila-hw1, you ordered the films by most profitable.
 * Modify this query so that it returns only the film_id of the top 5 most profitable films.
 * This will be your subquery.
 * 
 * Next, join the film, inventory, rental, and customer tables.
 * Use a where clause to restrict results to the subquery.
 */
WITH top_films AS (
    -- Select the top 5 most profitable films
    SELECT film_id 
    FROM film 
    JOIN inventory USING (film_id)
    JOIN rental USING (inventory_id)
    JOIN payment USING (rental_id)
    GROUP BY film_id
    ORDER BY SUM(amount) DESC 
    LIMIT 5
)
SELECT DISTINCT customer.customer_id 
FROM customer
JOIN rental USING (customer_id)
JOIN inventory USING (inventory_id)
WHERE inventory.film_id IN (SELECT film_id FROM top_films)
ORDER BY customer.customer_id;

