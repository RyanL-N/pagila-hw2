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
    SELECT film_id
    FROM film
    ORDER BY rental_rate * rental_duration DESC
    LIMIT 5
)
SELECT DISTINCT customer.customer_id, customer.first_name, customer.last_name
FROM customer
JOIN rental USING (customer_id)
JOIN inventory USING (inventory_id)
WHERE film_id IN (SELECT film_id FROM top_films);

