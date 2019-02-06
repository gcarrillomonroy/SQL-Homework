USE sakila;

-- 1a. --
SELECT first_name, last_name FROM actor

-- 1b. --
SELECT CONCAT(CONCAT(first_name, ' ') ,last_name) AS actor_name
FROM actor;

-- 2a. --
SELECT actor_id, first_name, last_name FROM actor
WHERE first_name = "Joe"

-- 2b. --
SELECT actor_id, first_name, last_name FROM actor
WHERE last_name LIKE '%GEN%'

-- 2c. --
SELECT actor_id, first_name, last_name FROM actor
WHERE last_name LIKE '%LI%'
ORDER BY last_name, first_name

-- 2d. --
SELECT country_id, country
FROM country
WHERE country IN ('Afganistan', 'Bangladesh', 'China')

-- 3a. --
ALTER TABLE actor
ADD COLUMN description BLOB;

-- 3b. --
ALTER TABLE actor
DROP COLUMN description;

-- 4a. --
SELECT last_name FROM actor

SELECT COUNT(last_name)
FROM actor;

-- 4b. --
SELECT * FROM ( SELECT last_name, COUNT(last_name) AS 'Total'
FROM actor GROUP BY last_name ) AS T
WHERE Total > 2;

-- 4c. --
SELECT * FROM actor
WHERE first_name = 'GROUCHO' AND last_name = 'WILLIAMS';
UPDATE actor SET first_name = 'HARPO'
WHERE first_name = 'GROUCHO' AND last_name = 'WILLIAMS';
SELECT * FROM actor
WHERE first_name = 'HARPO' AND last_name = 'WILLIAMS';

-- 4d. --
SELECT IF (first_name = 'HARPO', 'GROUCHO',  first_name) AS 'first_name',
last_name FROM actor WHERE last_name = 'WILLIAMS';

-- 5a. --
SHOW CREATE TABLE address;

-- 6a. --
SELECT S.first_name, S.last_name, A.address FROM staff AS S
JOIN address AS A ON S.address_id = A.address_id;

-- 6b. --
SELECT SUM(P.amount) AS 'Total amount', S.first_name, S.last_name FROM payment AS P
JOIN staff AS S ON P.staff_id = S.staff_id GROUP BY P.staff_id;

-- 6c. --
SELECT COUNT(FA.actor_id), F.title FROM film AS F
INNER JOIN film_actor AS FA ON F.film_id = FA.film_id GROUP BY F.film_id;

-- 6d. --
SELECT COUNT(I.film_id) AS 'Number of copies', F.title FROM inventory AS I
JOIN film AS F ON F.film_id = I.film_id WHERE F.title LIKE 'Hunc%';

-- 6e. --
SELECT SUM(P.amount) AS 'Total Paid', C.first_name, C.last_name FROM payment AS P
JOIN customer AS C ON P.customer_id = C.customer_id GROUP BY C.customer_id ORDER BY C.last_name;

-- 7a --
SELECT title FROM film
WHERE language_id = ( SELECT language_id FROM language WHERE NAME = 'English' ) AND title LIKE 'K%' OR title LIKE 'Q%';

-- 7b --
SELECT first_name, last_name FROM actor 
WHERE actor_id IN (
	SELECT actor_id FROM film_actor WHERE film_id = (SELECT film_id FROM film WHERE title LIKE 'Alone%Trip%')
);

-- 7c. --
SELECT C.first_name, C.last_name, C.email, CO.country
FROM customer AS C
JOIN address AS A JOIN city AS CITY
JOIN country AS CO ON C.address_id = A.address_id AND A.city_id = CITY.city_id AND CITY.country_id = CO.country_id
WHERE CO.country = 'Canada';

-- 7d. --
SELECT F.title, C.name FROM film_category AS FC
JOIN category AS C JOIN film AS F ON C.category_id = FC.category_id AND FC.film_id = F.film_id
WHERE C.name = 'Family';

-- 7e. --
SELECT F.title, R.rental_date FROM rental AS R
JOIN inventory AS I JOIN film AS F ON R.inventory_id = I.inventory_id AND F.film_id = I.film_id ORDER BY R.rental_date DESC;

-- 7f. --
SELECT S.store_id, SUM(P.amount) FROM store AS S
JOIN staff JOIN payment AS P ON S.store_id = staff.store_id AND staff.staff_id = P.staff_id GROUP BY S.store_id;

-- 7g. --
SELECT S.store_id, city.city, C.country FROM store AS S
JOIN city JOIN country AS C JOIN address AS A ON S.address_id = A.address_id AND city.city_id = A.city_id AND city.country_id = C.country_id;

-- 7h. --
#select distinct(FC.category_id) , sum(P.amount) as 'Revenue', I.film_id, R.inventory_id, C.name from rental as R join payment as P join inventory as I join film_category as FC join category as C on R.rental_id = P.rental_id and I.inventory_id = R.inventory_id and FC.film_id = I.film_id and FC.category_id = C.category_id group by R.inventory_id order by Revenue desc limit 5;
SELECT FC.category_id , SUM(P.amount) AS 'Revenue', C.name FROM rental AS R
JOIN payment AS P JOIN inventory AS I JOIN film_category AS FC
JOIN category AS C ON R.rental_id = P.rental_id AND I.inventory_id = R.inventory_id AND FC.film_id = I.film_id AND FC.category_id = C.category_id GROUP BY C.name ORDER BY Revenue desc limit 5;

-- 8a. --
CREATE VIEW TopFiveGeneresByGrossRevenue AS (
SELECT FC.category_id , SUM(P.amount) AS 'Revenue', C.name FROM rental AS R
JOIN payment AS P
JOIN inventory AS I
JOIN film_category AS FC
JOIN category AS C ON R.rental_id = P.rental_id AND I.inventory_id = R.inventory_id AND FC.film_id = I.film_id AND FC.category_id = C.category_id GROUP BY C.name ORDER BY Revenue desc limit 5
);

-- 8b. --
SELECT * FROM TopFiveGeneresByGrossRevenue;

-- 8c. --
DROP VIEW TopFiveGeneresByGrossRevenue;