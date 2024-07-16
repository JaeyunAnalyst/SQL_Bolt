-- SQL Lesson 1: SELECT queries 101

-- Find the title of each film
SELECT title
FROM movies;

--Find the director of each film
SELECT director
FROM movies;

--Find the title and director of each film
SELECT title, director
FROM movies;

--Find the title and year of each film
SELECT title, year
FROM movies;

--Find all the information about each film
SELECT *
FROM movies;

-- SQL Lesson 2: Queries with constraints (Pt. 1)

-- Find the movie with a row id of 6 
SELECT title
FROM movies
WHERE id = 6;

--Find the movies released in the years between 2000 and 2010
SELECT title, year
FROM movies
WHERE year BETWEEN 2000 AND 2010;

--Find the movies not released in the years between 2000 and 2010
SELECT title, year
FROM movies
WHERE year NOT BETWEEN 2000 AND 2010;

--Find the first 5 Pixar movies and their release year
SELECT title, year
FROM movies
WHERE id BETWEEN 1 AND 5;
--or
SELECT title, year
FROM movies
LIMIT 5;

-- SQL Lesson 3: Queries with constraints (Pt. 2)

-- Find all the Toy Story movies 
SELECT title
FROM movies
WHERE title LIKE '%Toy Story%';

--Find all the movies directed by John Lasseter
SELECT title
FROM movies
WHERE director = 'John Lasseter';

--Find all the movies (and director) not directed by John Lasseter
SELECT title, director
FROM movies
WHERE director != 'John Lasseter';

--Find all the WALL-* movies
SELECT title
FROM movies
WHERE title LIKE '%WALL-_';

-- SQL Lesson 4: Filtering and sorting Query results

-- List all directors of Pixar movies (alphabetically), without duplicates
SELECT DISTINCT director 
FROM movies
ORDER BY director;

--List the last four Pixar movies released (ordered from most recent to least)
SELECT title, year
FROM movies
ORDER BY year DESC
LIMIT 4;

--List the first five Pixar movies sorted alphabetically
SELECT title
FROM movies
ORDER BY title
LIMIT 5;

--List the next five Pixar movies sorted alphabetically
SELECT title
FROM movies
ORDER BY title
LIMIT 5 OFFSET 5;

-- SQL Review 5: Simple SELECT Queries

-- List all the Canadian cities and their populations
SELECT city, population
FROM north_american_cities
WHERE country = 'Canada';

--Order all the cities in the United States by their latitude from north to south
SELECT city, latitude
FROM north_american_cities
WHERE country = 'United States'
ORDER BY latitude DESC;

--List all the cities west of Chicago, ordered from west to east
SELECT city, longitude
FROM north_american_cities
WHERE longitude < -87.629798
ORDER BY longitude;

--List the two largest cities in Mexico (by population)
SELECT city, population
FROM north_american_cities
WHERE country = 'Mexico'
ORDER BY population DESC
LIMIT 2;

--List the third and fourth largest cities (by population) in the United States and their population
SELECT city, population
FROM north_american_cities
WHERE country = 'United States'
ORDER BY population DESC
LIMIT 2 OFFSET 2;

-- SQL Lesson 6: Multi-table queries with JOINs

-- Find the domestic and international sales for each movie
SELECT m.title, b.domestic_sales, b.international_sales
FROM movies AS m JOIN boxoffice AS b
ON m.id = b.movie_id;

--Show the sales numbers for each movie that did better internationally rather than domestically
SELECT m.title, b.domestic_sales, b.international_sales
FROM movies AS m JOIN boxoffice AS b
ON m.id = b.movie_id
WHERE b.international_sales > b.domestic_sales;

--List all the movies by their ratings in descending order
SELECT m.title, b.rating
FROM movies AS m JOIN boxoffice AS b
ON m.id = b.movie_id
ORDER BY b.rating DESC;

-- SQL Lesson 7: OUTER JOINs

-- Find the list of all buildings that have employees
SELECT DISTINCT b.building_name
FROM buildings AS b LEFT JOIN employees AS e
 ON b.building_name = e.building
WHERE e.name NOT NULL;

--Find the list of all buildings and their capacity
SELECT DISTINCT b.building_name, b.capacity
FROM buildings AS b LEFT JOIN employees AS e
 ON b.building_name = e.building

--List all buildings and the distinct employee roles in each building (including empty buildings)
-SELECT DISTINCT b.building_name, e.role
FROM buildings AS b LEFT JOIN employees AS e
 ON b.building_name = e.building

-- SQL Lesson 8: A short note on NULLs

-- Find the name and role of all employees who have not been assigned to a building
SELECT b.building_name, e.role, e.name
FROM employees AS e LEFT JOIN buildings AS b
 ON e.building = b.building_name
WHERE b.building_name IS NULL;

--Find the names of the buildings that hold no employees
SELECT b.building_name, e.role, e.name
FROM buildings AS b LEFT JOIN employees AS e
 ON b.building_name = e.building
WHERE e.role IS NULL;


-- SQL Lesson 9: Queries with expressions

-- List all movies and their combined sales in millions of dollars
SELECT m.title, (b.domestic_sales+b.international_sales)/1000000 AS combined_sales
FROM movies AS m LEFT JOIN boxoffice AS b
 ON m.id = b.movie_id;

--List all movies and their ratings in percent
SELECT m.title, b.rating*10 AS combined_sales
FROM movies AS m LEFT JOIN boxoffice AS b
 ON m.id = b.movie_id;

--List all movies that were released on even number years
SELECT m.title, m.year
FROM movies AS m LEFT JOIN boxoffice AS b
 ON m.id = b.movie_id
WHERE m.year % 2 = 0;

-- SQL Lesson 10: Queries with aggregates (Pt. 1)

-- Find the longest time that an employee has been at the studio
SELECT MAX(years_employed) 
FROM employees;

--For each role, find the average number of years employed by employees in that role
SELECT role, AVG(years_employed) 
FROM employees
GROUP BY role;

--Find the total number of employee years worked in each building
SELECT building, SUM(years_employed) AS Total_years_employee
FROM employees
GROUP BY building;

-- SQL Lesson 11: Queries with aggregates (Pt. 2)

-- Find the number of Artists in the studio (without a HAVING clause)
SELECT COUNT(role) 
FROM employees
WHERE role = 'Artist';

--Find the number of Employees of each role in the studio
SELECT role, COUNT(role)
FROM employees
GROUP BY role;

--Find the total number of years employed by all Engineers
SELECT role, SUM(years_employed)
FROM employees
GROUP BY role
HAVING role = 'Engineer';

-- SQL Lesson 12: Order of execution of a Query

-- Find the number of movies each director has directed
SELECT director, COUNT(title) 
FROM movies
GROUP BY director;

--Find the total domestic and international sales that can be attributed to each director
SELECT m.director, SUM(b.domestic_sales+b.international_sales) AS total_sales
FROM boxoffice AS b LEFT JOIN movies AS m
 ON b.movie_id = m.id
GROUP BY m.director;

--SQL Lesson 13: Inserting rows

--Add the studio's new production, Toy Story 4 to the list of movies (you can use any director)
INSERT INTO movies
(Title)
VALUES ('Toy Story 4');
--or
INSERT INTO movies
(id, title, director, year, length_minutes)
VALUES (4,'Toy Story 4', 'John Lasseter', 2024, 100);

--Toy Story 4 has been released to critical acclaim! It had a rating of 8.7, and made 340 million domestically and 270 million internationally. Add the record to the BoxOffice table.
INSERT INTO boxoffice
(movie_id, rating, domestic_sales, international_sales)
VALUES (4, 8.7, 340*1000000, 270*1000000);

-- SQL Lesson 14: Updating rows

--the director for A Bug's Life is incorrect, it was actually directed by John Lasseter
UPDATE movies
SET director = 'John Lasseter'
WHERE id = 2;

--The year that Toy Story 2 was released is incorrect, it was actually released in 1999
UPDATE movies
SET year = 1999
WHERE id = 3;

--Both the title and director for Toy Story 8 is incorrect! The title should be "Toy Story 3" and it was directed by Lee Unkrich
UPDATE movies
SET title = 'Toy Story 3', director = 'Lee Unkrich'
WHERE id = 11;

-- SQL Lesson 15: Deleting rows

-- This database is getting too big, lets remove all movies that were released before 2005.
DELETE FROM movies
WHERE year < 2005;

--Andrew Stanton has also left the studio, so please remove all movies directed by him.
DELETE FROM movies
WHERE director = 'Andrew Stanton';

-- SQL Lesson 16: Creating tables

-- Create a new table named Database with the following columns:
--Name A string (text) describing the name of the database
--Version A number (floating point) of the latest version of this database
--Download_count An integer count of the number of times this database was downloaded
--This table has no constraints.
CREATE TABLE IF NOT EXISTS database (
    name TEXT,
    version FLOAT,
    download_count INTEGER
);

-- SQL Lesson 17: Altering tables
-- Add a column named Aspect_ratio with a FLOAT data type to store the aspect-ratio each movie was released in. 
ALTER TABLE movies
ADD aspect_ratio FLOAT;

-- Add another column named Language with a TEXT data type to store the language that the movie was released in. Ensure that the default for this language is English.
ALTER TABLE movies
ADD language TEXT DEFAULT 'English';

-- SQL Lesson 18: Dropping tables

-- We've sadly reached the end of our lessons, lets clean up by removing the Movies table
DROP TABLE movies;
--And drop the BoxOffice table as well
DROP TABLE IF EXISTS boxoffice;
