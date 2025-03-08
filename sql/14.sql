/*
 * Create a report that shows the total revenue per month and year.
 *
 * HINT:
 * This query is very similar to the previous problem,
 * but requires an additional JOIN.
 */
SELECT DATE_PART('year', rental_date) AS "Year", 
       DATE_PART('month', rental_date) AS "Month", 
       SUM(amount) AS "Total Revenue"
FROM rental 
JOIN payment USING (rental_id)
GROUP BY ROLLUP ("Year", "Month")
ORDER BY "Year", "Month";

