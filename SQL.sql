#_______________________________________________________________________________________________________________________________________________________________________#
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~SQL Homework - Sakila DB ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~#
#_______________________________________________________________________________________________________________________________________________________________________#

# Tell SQL to use the Sakila database
USE sakila;


# 1a. Display the first and last names of all actors from the table actor
-- Grab the first and last_name columns from the table named actor in the Sakila database
SELECT first_name, last_name 
FROM actor;


# 1b. Display the first and last name of each actor in a single column in upper case letters. Name the column Actor Name.
-- Grab the first_name and last_name columns, set the case setting to ALL CAPS and combine the columns. 
-- Then, display the value in a new column called actor_name.
SELECT UPPER(CONCAT(first_name, ' ', last_name)) AS 'actor_name' 
FROM actor;


# 2a. You need to find the ID number, first name, and last name of an actor, of whom you know only the first name, "Joe." 
# What is one query would you use to obtain this information?
-- Grab the actor_id, first & last_name columns, and use WHERE to find first name Joe
SELECT actor_id, first_name, last_name 
FROM actor 
WHERE first_name = 'Joe';


# 2b. Find all actors whose last name contain the letters GEN:
-- Keep the query from 2a, but now grab all values from last_name using % to return values containing GEN
SELECT actor_id, first_name, last_name 
FROM actor
WHERE last_name LIKE '%GEN%';


# 2c. Find all actors whose last names contain the letters LI. This time, order the rows by last name and first name, in that order:
-- Next, grab last names containing LI and use ORDER BY to list the rows in descending order
SELECT actor_id, first_name, last_name 
FROM actor
WHERE last_name LIKE '%LI%'
ORDER BY last_name, first_name;


# 2d. Using IN, display the country_id and country columns of the following countries: Afghanistan, Bangladesh, and China
-- Next, grab the country_id and country columns from the country table using WHERE to show country names Afghanistan, Bangladesh, or China.
SELECT country_id, country 
FROM country
WHERE country IN ('Afghanistan', 'Bangladesh', 'China');


# 3a. You want to keep a description of each actor. You don't think you will be performing queries on a description, 
# so create a column in the table actor named description and use the data type BLOB
#  (Make sure to research the type BLOB, as the difference between it and VARCHAR are significant).
-- Before altering the actor table, check it out to find a good spot for the description column
SELECT * 
FROM actor;

-- Ok, now add in the description column with BLOB as the datatype, and put it after the last_name column
ALTER TABLE actor
ADD desc_name BLOB AFTER last_name;


# 3b. Very quickly you realize that entering descriptions for each actor is too much effort. Delete the description column, then preview to check it
ALTER TABLE actor
DROP COLUMN desc_name;

SELECT * 
FROM actor;


# 4a. List the last names of actors, as well as how many actors have that last name 
-- First grab the last_name column, then the COUNT of the last_name column from the actor table and use GROUP BY to list the values
SELECT last_name, COUNT(last_name)
FROM actor 
GROUP BY last_name;


# 4b. List last names of actors and the number of actors who have that last name, but only for names that are shared by at least two actors
-- Keep the code from 4a, and add a line using HAVING to show the values meeting the name criteria
SELECT last_name, COUNT(last_name)
FROM actor 
GROUP BY last_name
HAVING COUNT(last_name) >= 2;


# 4c. The actor HARPO WILLIAMS was accidentally entered in the actor table as GROUCHO WILLIAMS. Write a query to fix the record.
-- First, use UPDATE to update within the actor table. Then, use SET to change the first_name to HARPO. Also, check it out after. 
UPDATE actor
SET first_name = "HARPO"
WHERE first_name = "GROUCHO" and last_name = 'WILLIAMS';

SELECT * 
FROM actor
WHERE first_name = "GROUCHO" and last_name = 'WILLIAMS';


# 4d. Perhaps we were too hasty in changing GROUCHO to HARPO. It turns out that GROUCHO was the correct name after all! 
# In a single query, if the first name of the actor is currently HARPO, change it to GROUCHO.
-- Keep the query from 4c, and indicate the change using actor_id (there are multiple Harpos in this table). Also, check it out after.
UPDATE actor
SET first_name = "GROUCHO"
WHERE actor_id = 172;

SELECT *
FROM actor
WHERE actor_id = 172;


# 5a. You cannot locate the schema of the address table. Which query would you use to re-create it?
-- Use DESCRIBE to show the address table in an actual table format; the alternative is showing all values in one row...which...bleh
DESCRIBE address;


# 6a. Use JOIN to display the first and last names, as well as the address, of each staff member. Use the tables staff and address.
-- Preview the tables to determine where to join
SELECT *
FROM address;
SELECT *
FROM staff;

-- Grab the first and last name columns from the staff table and the address column from the address table. 
-- Then, join the staff and address tables using inner join on address_id.
SELECT sf.first_name, sf.last_name, ad.address 
FROM staff sf
JOIN address ad
ON sf.address_id = ad.address_id;


# 6b. Use JOIN to display the total amount rung up by each staff member in August of 2005. Use tables staff and payment.
-- Preview time
SELECT *
FROM payment;
SELECT *
FROM staff;

-- Grab the first and last name columns from the staff table and the sum of the amount column from the payment table. 
-- Then, join the staff and payment tables using inner join staff_id.
-- Then, use GROUP BY staff_id to show the amount values by staff member.
SELECT sf.first_name, sf.last_name, sum(pt.amount)
FROM staff sf
JOIN payment pt
ON sf.staff_id = pt.staff_id
GROUP BY sf.staff_id;


# 6c. List each film and the number of actors who are listed for that film. Use tables film_actor and film. Use inner join.
-- Preview time
SELECT *
FROM film;
SELECT *
FROM film_actor;

-- Grab the title and count of the actor_id columns from the film_actor table. Then join to the film table on film_id. 
-- Then, use GROUP BY to show # of actors by film.
SELECT title, COUNT(actor_id) 
FROM film_actor fa
JOIN film fm
ON fm.film_id = fa.film_id
GROUP BY title;


# 6d. How many copies of the film Hunchback Impossible exist in the inventory system?
-- Preview time (just inventory, we already saw film)
SELECT *
FROM inventory;

-- Grab the title column from the film table and the count of the film id from the inventory table. 
-- Then, join on film_id and use GROUP BY to show inventory count by title. 
SELECT fm.title, COUNT(inv.film_id)
FROM film fm
JOIN inventory inv
ON fm.film_id = inv.film_id
GROUP BY fm.film_id
HAVING fm.title = "Hunchback Impossible";	


# 6e. Using the tables payment and customer and the JOIN command, list the total paid by each customer. List the customers alphabetically by last name.
-- Preview Time
SELECT *
FROM payment; 
SELECT *
FROM customer;

-- Grab the first and last name columns from the customer table, and the sum of the amount column from the payment table, in a new column called total_paid. 
-- Join on customer_id and use GROUP BY to show the values from the instruction.
SELECT cr.first_name, cr.last_name, sum(pt.amount) AS total_paid 
FROM payment pt
JOIN customer cr
ON pt.customer_id = cr.customer_id
GROUP BY cr.first_name, cr.last_name
ORDER BY cr.last_name, cr.first_name;


# 7a. The music of Queen and Kris Kristofferson have seen an unlikely resurgence. 
# As an unintended consequence, films starting with the letters K and Q have also soared in popularity. 
-- Use subqueries to display the titles of movies starting with the letters K and Q whose language is English.
-- Grab the title column from the film table and sort to show the values from the instruction.
SELECT title
FROM film
WHERE (title LIKE 'K%' OR title LIKE 'Q%')
	AND language_id = 
		(SELECT language_id 
         FROM language
		 WHERE name = 'English');
 
 
# 7b. Use subqueries to display all actors who appear in the film Alone Trip.
-- Grab the first_name and last_name columns from the actor table and use IN to show where the actor_id has the same values as the actor_id in the film_actor table
-- Then, match those actors using their film_id in the film actor table with their film_id in the film table, to show the actors who were in 'Alone Trip'
SELECT first_name, last_name
FROM actor
WHERE actor_id IN
	(SELECT actor_id
     FROM film_actor
     WHERE film_id IN
		(SELECT film_id
         FROM film
         WHERE title = 'Alone Trip'
         ));


# 7c. You want to run an email marketing campaign in Canada, for which you will need the names and email addresses of all Canadian customers. 
# Use joins to retrieve this information.
-- Preview Time
SELECT *
FROM customer;
SELECT *
FROM address;
SELECT *
FROM city;
SELECT *
FROM country;

-- The values needed are in columns from the customer, address, city, and country tables. 
-- Join the customer (columns: fname, lname & email) and address tables on address_id. 
-- Then, join those with the city table on city_id. 
-- Then, join those with the country table on country_id, and show values matching 'Canada' as the country name. 
SELECT cr.first_name, cr.last_name, cr.email 
FROM customer cr
JOIN address ad
ON (cr.address_id = ad.address_id)
JOIN city cty
ON (cty.city_id = ad.city_id)
JOIN country cry
ON (cry.country_id = cty.country_id)
WHERE cry.country= 'Canada';


# 7d. Sales have been lagging among young families, and you wish to target all family movies for a promotion. 
# Identify all movies categorized as family films.
-- Preview Time
SELECT *
FROM film;
SELECT *
FROM film_category;
SELECT *
FROM category;

-- The values needed are in columns from the film, film_category, and category tables, and we want to show all family films. 
-- Grab the title and description columns from the film table where the film_id matches the film_id in the film_category table.
-- With those selected, grab the columns from the category table where the category_id matches our group the film_category table, and the name is Family. 
SELECT title, description 
FROM film 
WHERE film_id IN
	(SELECT film_id 
    FROM film_category
	WHERE category_id IN
		(SELECT category_id 
        FROM category
		WHERE name = "Family")
	);


# 7e. Display the most frequently rented movies in descending order.
-- Preview Time
SELECT * 
FROM rental;
SELECT *
FROM inventory;
SELECT *
FROM film;

-- The values needed are in columns from the rental, inventory, and film tables.
-- Grab the title from the film table and show it with a new column named as '# of Times Rented'.
-- This is going to hold the count of values from the rental_id column in the rental table. 
-- Next, join those with the inventory table on inventory_id. 
-- Then join with the film table on film_id and use GROUP BY to show the titles and counts in descending order.
SELECT fm.title, COUNT(rental_id) AS '# of Times Rented'
FROM rental rt
JOIN inventory inv
ON (rt.inventory_id = inv.inventory_id)
JOIN film fm
ON (inv.film_id = fm.film_id)
GROUP BY fm.title
ORDER BY `# of Times Rented` DESC;


# 7f. Write a query to display how much business, in dollars, each store brought in.
-- Preview Time
SELECT * 
FROM payment;
SELECT *
FROM rental;
SELECT *
FROM store;

-- The values needed are in columns from the rental, inventory, and film tables.
-- Grab the store_id from the store table and show it with a new column named as 'Business in Dollars'. 
-- This is going to hold the sum of values from the amount column in the payment table. 
-- Next, join those with the rental table on rental_id, then join those with the inventory table on inventory_id. 
-- Then join those with the store table on store_id.
-- Then, use GROUP BY to show the amount of 'Business in Dollars' by store_id.
SELECT sr.store_id, SUM(amount) AS 'Business in Dollars'
FROM payment pt
JOIN rental rt
ON (pt.rental_id = rt.rental_id)
JOIN inventory inv
ON (inv.inventory_id = rt.inventory_id)
JOIN store sr
ON (sr.store_id = inv.store_id)
GROUP BY sr.store_id; 


# 7g. Write a query to display for each store its store ID, city, and country.
-- Preview Time
SELECT * 
FROM store;
SELECT *
FROM address;
SELECT *
FROM city;
SELECT *
FROM country;

-- The values needed are in columns from the store, address, city, and country tables.
-- Grab the store_id from the store table, city from the city table, and country from the country table. 
-- Next, join the address and store ables on address_id. 
-- Then, join those values to the city table on city_id. Then, join those to the country table on country_id. 
SELECT sr.store_id, cty.city, cry.country 
FROM store sr
JOIN address ad
ON (sr.address_id = ad.address_id)
JOIN city cty
ON (cty.city_id = ad.city_id)
JOIN country cry
ON (cry.country_id = cty.country_id);


# 7h. List the top five genres in gross revenue in descending order. 
# (Hint: you may need to use the following tables: category, film_category, inventory, payment, and rental.)
-- Preview Time
SELECT * 
FROM category;
SELECT *
FROM film_category;
SELECT *
FROM inventory;
SELECT *
FROM payment;
SELECT *
FROM rental;

-- The description already outlined the tables needed (yippy!)
-- Grab the name column from the category table and name it as 'Genre'. 
-- Show it with a new column named as 'GrossRev' - this is going to hold the sum of values from the amount column in the payment table. 
-- Next, join the category table to the film_category table on category_id, then join those values to the inventory table on film_id. 
-- Then, join those values to the rental table on inventory_id, then join those values to the payment table on rental_id. 
-- Finally, use GROUP BY and LIMIT to show the top five genres in gross revenue in descending order.
SELECT cat.name AS 'Genre', SUM(pt.amount) AS 'GrossRev' 
FROM category cat
JOIN film_category fat
ON (cat.category_id=fat.category_id)
JOIN inventory inv
ON (fat.film_id=inv.film_id)
JOIN rental rt
ON (inv.inventory_id=rt.inventory_id)
JOIN payment pt
ON (rt.rental_id=pt.rental_id)
GROUP BY cat.name 
ORDER BY GrossRev 
LIMIT 5;


# 8a. In your new role as an executive, you would like to have an easy way of viewing the Top five genres by gross revenue. 
# Use the solution from the problem above to create a view. If you haven't solved 7h, you can substitute another query to create a view.
CREATE VIEW genre_rev AS
SELECT cat.name AS 'Genre', SUM(pt.amount) AS 'GrossRev' 
FROM category cat
JOIN film_category fat
ON (cat.category_id=fat.category_id)
JOIN inventory inv
ON (fat.film_id=inv.film_id)
JOIN rental rt
ON (inv.inventory_id=rt.inventory_id)
JOIN payment pt
ON (rt.rental_id=pt.rental_id)
GROUP BY cat.name 
ORDER BY GrossRev 
LIMIT 5;


# 8b. How would you display the view that you created in 8a?
-- Just like Preview Time:
SELECT *
FROM genre_rev;


# 8c. You find that you no longer need the view top_five_genres. Write a query to delete it.
-- Thank you, NeXExit the view using DROP
DROP VIEW genre_rev;

#_______________________________________________________________________________________________________________________________________________________________________#
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ FIN ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~#
#_______________________________________________________________________________________________________________________________________________________________________#





