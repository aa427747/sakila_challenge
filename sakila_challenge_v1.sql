-- COMPLETE 1a. Display the first and last names of all actors from the table actor.
Use sakila;
Select first_name, last_name, Actor_Name from actor;

-- 1b. Display the first and last name of each actor in a single column in upper case letters. Name the column Actor Name.
Use sakila;
ALTER TABLE `sakila`.`actor` 
ADD COLUMN `Actor Name` VARCHAR(90) NULL DEFAULT 'UPPERCASE' AFTER `last_update`;
Select Actor_Name from actor;
UPDATE actor 
Set Actor_Name = CONCAT(first_name, ',', last_name);

-- COMPLETE 2a. You need to find the ID number, first name, and last name of an actor, of whom you know only the first name, "Joe." What is one query would you use to obtain this information?
Use sakila;
Select actor_id, first_name, last_name from actor
-- Note > Both of the where statement provide the same single result of Joe Swank.
where first_name = 'Joe';
-- where first_name like '%Joe%';

-- COMPLETE 2b. Find all actors whose last name contain the letters GEN:
Use sakila;
Select actor_id, first_name, last_name from actor
where last_name like '%GEN%';

-- COMPLETE - 2c. Find all actors whose last names contain the letters LI. This time, order the rows by last name and first name, in that order:
Use sakila;
Select actor_id, first_name, last_name
from actor
where last_name like '%LI%'
order by last_name, first_name;

-- COMPLETE 2d. Using IN, display the country_id and country columns of the following countries: Afghanistan, Bangladesh, and China:
Use sakila;
Select country_id, country from country
where country in('Afghanistan','Bangladesh','China');

-- COMPLETE - 3a. You want to keep a description of each actor. You don't think you will be performing queries on a description, so create a column in the table actor named description and use the data type BLOB (Make sure to research the type BLOB, as the difference between it and VARCHAR are significant).
Use sakila;
ALTER TABLE `sakila`.`actor` 
ADD COLUMN `Description` BLOB NULL AFTER `Actor_Name`;

-- COMPLETE - 3b. Very quickly you realize that entering descriptions for each actor is too much effort. Delete the description column.
Use sakila;
ALTER TABLE `sakila`.`actor` 
DROP COLUMN `Description`;

-- COMPLETE - 4a. List the last names of actors, as well as how many actors have that last name.
Use sakila;
Select last_name, count(*) 
from actor
group by last_name;

-- COMPLETE - 4b. List last names of actors and the number of actors who have that last name, but only for names that are shared by at least two actors
Use sakila;
Select last_name as 'Actor Last Name', count(actor_id) as 'Actor_Count' 
from actor
-- where 'actor_count' > '1'
group by last_name
having Actor_Count > 1;

-- COMPLETE - 4c. The actor HARPO WILLIAMS was accidentally entered in the actor table as GROUCHO WILLIAMS. Write a query to fix the record.
Use sakila;
UPDATE actor
set first_name = 'HARPO'
where last_name = 'Williams' and first_name = 'Groucho';
UPDATE actor
set Actor_Name = 'HARPO,WILLIAMS'
where last_name = 'Williams' and first_name = 'Harpo';
Select
last_name, first_name, Actor_name  
from actor
where last_name = 'Williams' and first_name = 'Harpo';

-- COMPLETE - 4d. Perhaps we were too hasty in changing GROUCHO to HARPO. It turns out that GROUCHO was the correct name after all! In a single query, if the first name of the actor is currently HARPO, change it to GROUCHO.
Use sakila;
UPDATE actor
set first_name = 'GROUCHO', Actor_Name = 'GROUCHO,WILLIAMS'
where first_name = 'HARPO';
Select
last_name, first_name, Actor_name  
from actor
where last_name = 'Williams';

-- ??? - 5a. You cannot locate the schema of the address table. Which query would you use to re-create it?
Use sakila;
describe address;

-- COMPLETE - 6a. Use JOIN to display the first and last names, as well as the address, of each staff member. Use the tables staff and address:
Use sakila;
-- Select * from address;
-- Select * from staff;
Select first_name, last_name, address 
from staff
-- right join address ON staff.address_id = address.address_id;
inner join address ON staff.address_id = address.address_id;
-- left join address ON staff.address_id = address.address_id;

-- COMPLETE - 6b. Use JOIN to display the total amount rung up by each staff member in August of 2005. Use tables staff and payment.
Use sakila;
-- Select * from staff;
-- Select * from payment;
Select first_name, last_name, staff.staff_id, sum(amount)  
from staff
right join payment ON staff.staff_id = payment.staff_id
-- inner join payment ON staff.staff_id = payment.staff_id
-- left join payment ON staff.staff_id = payment.staff_id
group by staff.staff_id;

-- COMPLETE - 6c. List each film and the number of actors who are listed for that film. Use tables film_actor and film. Use inner join.
Use sakila;
-- Select * from film_actor;
-- Select * from film;
Select film.film_id, film.title, count(film_actor.film_id)  
from film
inner join film_actor ON film.film_id = film_actor.film_id
group by film.film_id;
-- Use sakila;
Select * from film_actor
where film_id = 1;

-- COMPLETE - 6d. How many copies of the film Hunchback Impossible exist in the inventory system?
-- -- Use sakila;
-- Select * from film;
-- Select * from inventory;
Select film.film_id, film.title, store_id, count(inventory.inventory_id)  
from film
inner join inventory ON film.film_id = inventory.film_id
where film.title like 'Hunchback%'
group by film.film_id;
-- Use sakila;
Select * from inventory
where film_id = 439;

-- COMPLETE - 6e. Using the tables payment and customer and the JOIN command, list the total paid by each customer. List the customers alphabetically by last name:
Use sakila;
-- Select * from payment;
-- Select * from customer;
Select 
-- -- customer.customer_id, 
first_name, last_name, sum(payment.amount) as Total_Amount_Paid 
from customer
inner join payment ON customer.customer_id = payment.customer_id
group by customer.customer_id
order by last_name;
-- -- Use sakila;
Select sum(amount) from payment
where customer_id = 505;

-- COMPLETE 7a. The music of Queen and Kris Kristofferson have seen an unlikely resurgence. As an unintended consequence, films starting with the letters K and Q have also soared in popularity. Use subqueries to display the titles of movies starting with the letters K and Q whose language is English.
Use sakila;
Select title from film f
where language_id in (
Select language_id from language l
where name = 'English')
and title like 'K%' or title like 'Q%';  
-- Using a Join, then would be as follows:
-- Select title, name 
-- from film
-- join language on film.language_id = language.language_id
-- where title like 'K%' or title like 'Q%'
-- order by title; 

-- COMPLETE - 7b. Use subqueries to display all actors who appear in the film Alone Trip.
Use sakila;
Select Actor_Name from actor
where actor_id in (
Select actor_id from film_actor 
where film_id in (
Select film_id from film
where title = 'Alone Trip'));
-- Using a Join, then would be as follows:
-- Select * from actor;
-- Select * from film_actor;
-- Select * from film;
-- where title like 'Alone%';
-- Select b.title, first_name, last_name
-- b.film_id, c.actor_id  
-- from film_actor a, 
-- 	 film b, 
-- 	 actor c
-- where b.film_id = a.film_id 
-- and a.actor_id = c.actor_id
-- and b.title like 'Alone%';

-- COMPLETE - 7c. You want to run an email marketing campaign in Canada, for which you will need the names and email addresses of all Canadian customers. Use joins to retrieve this information.
Use sakila;
Select first_name, last_name, email
from customer cu,
	 address ad,
     city ci,
     country cy
where cu.address_id = ad.address_id
  and ad.city_id = ci.city_id
  and ci.country_id = cy.country_id
  and country = 'Canada'
order by email;

-- COMPLETE - 7d. Sales have been lagging among young families, and you wish to target all family movies for a promotion. Identify all movies categorized as family films.
Use sakila;
-- Select * from category;
-- Select * from film_category;
-- Select * from film;
Select a.title, a.film_id, b.category_id, c.name
from film a, 
	 film_category b,
     category c
where a.film_id = b.film_id
  and b.category_id = c.category_id
  and c.name = 'Family';

-- COMPLETE - 7e. Display the most frequently rented movies in descending order.
Use sakila;
Select * from rental;
Select * from inventory;
Select * from film;
Select c.title, count(a.inventory_id) as 'Rental_Count'
from rental a,
	 inventory b,
     film c
where a.inventory_id = b.inventory_id
  and b.film_id = c.film_id
--    and a.inventory_id = '1'
group by c.title
order by count(a.inventory_id) desc; 
-- Started to try and do the above using the sub-query, but didn't finish it.
-- Select title, film_id from film; 
-- Select film_id, inventory_id, count(inventory_id) from inventory
-- group by inventory_id
-- having inventory_id = '1';
-- Select inventory_id, count(inventory_id) from rental
-- group by inventory_id;


-- COMPLETE - 7f. Write a query to display how much business, in dollars, each store brought in.
Use sakila;
Select store, concat('$', total_sales) from sales_by_store;
-- select date(created_at), concat('$', format(sum(price), 2))

-- COMPLETE - 7g. Write a query to display for each store its store ID, city, and country.
Use sakila;
Select s.store_id, c.city, y.country 
from store s,
	 address a,
     city c,
     country y
where s.address_id = a.address_id
  and a.city_id = c.city_id
  and c.country_id = y.country_id
GROUP BY s.store_id
ORDER BY y.country;

-- COMPLETE - 7h. List the top five genres in gross revenue in descending order. 
-- (Hint: you may need to use the following tables: category, film_category, inventory, payment, and rental.)
-- Multiple methods, view built for reference.
Use sakila;
-- Select * from category;
-- Select * from film_category;
-- Select * from inventory;
-- Select * from payment;
-- Select * from rental;
-- Select * from sales_by_film_category;
Select c.name AS category, SUM(p.amount) AS total_sales
from payment p,
	 rental r,
     inventory i,
     film f,
     film_category fc,
     category c
where p.rental_id = r.rental_id
  and r.inventory_id = i.inventory_id
  and i.film_id = f.film_id
  and f.film_id = fc.film_id
  and fc.category_id = c.category_id
group by name
order by total_sales DESC
limit 5;

-- SELECT 
--         `c`.`name` AS `category`, SUM(`p`.`amount`) AS `total_sales`
--     FROM
--         (((((`sakila`.`payment` `p`
--         JOIN `sakila`.`rental` `r` ON ((`p`.`rental_id` = `r`.`rental_id`)))
--         JOIN `sakila`.`inventory` `i` ON ((`r`.`inventory_id` = `i`.`inventory_id`)))
--         JOIN `sakila`.`film` `f` ON ((`i`.`film_id` = `f`.`film_id`)))
--         JOIN `sakila`.`film_category` `fc` ON ((`f`.`film_id` = `fc`.`film_id`)))
--         JOIN `sakila`.`category` `c` ON ((`fc`.`category_id` = `c`.`category_id`)))
--     GROUP BY `c`.`name`
--     ORDER BY `total_sales` DESC
    
-- COMPLETE - 8a. In your new role as an executive, you would like to have an easy way of viewing the Top five genres by gross revenue. Use the solution from the problem above to create a view. If you haven't solved 7h, you can substitute another query to create a view.
Use sakila; 
CREATE
    ALGORITHM = UNDEFINED 
    DEFINER = `root`@`localhost` 
    SQL SECURITY DEFINER
VIEW `sakila`.`top5_sales_by_film_category` AS
Select c.name AS category, SUM(p.amount) AS total_sales
from payment p,
	 rental r,
     inventory i,
     film f,
     film_category fc,
     category c
where p.rental_id = r.rental_id
  and r.inventory_id = i.inventory_id
  and i.film_id = f.film_id
  and f.film_id = fc.film_id
  and fc.category_id = c.category_id
group by name
order by total_sales DESC
limit 5;

-- COMPLETE - 8b. How would you display the view that you created in 8a?
Use sakila;
Select * from top5_sales_by_film_category;

-- COMPLETE - 8c. You find that you no longer need the view top_five_genres. Write a query to delete it.
Use sakila;
DROP VIEW `sakila`.`top5_sales_by_film_category`;