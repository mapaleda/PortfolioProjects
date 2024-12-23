/* In this Project, we'll work with data provided by the United States Social Security Administration, 
which lists first names along with the number and sex of babies they were given to in each year.
The data spans 101 years, from 1920 to 2020.
The goal is to understand the trends in popularity of first names. Comparing between classic names and more recent names.
*/

-- 1. Classic American Names
-- Select first names and the total babies with that first_name
-- Group by first_name and filter for those names that appear in all 101 years
-- Order by the total number of babies with that first_name, descending

SELECT first_name,
       SUM(num)
FROM usa_baby_names
GROUP BY first_name
HAVING COUNT(year) = 101
ORDER BY SUM(num) DESC

--2. Timeless or Trendy?
-- Classify first names as 'Classic', 'Semi-classic', 'Semi-trendy', or 'Trendy'
-- Alias this column as popularity_type
-- Select first_name, the sum of babies who have ever had that name, and popularity_type
-- Order the results alphabetically by first_name
SELECT first_name,
       SUM(num),
       (CASE WHEN COUNT(num) > 80 THEN 'Classic'
             WHEN COUNT(num) > 50 THEN 'Semi-classic'
             WHEN COUNT(num) > 20 THEN 'Semi-trendy'
             WHEN COUNT(num) > 0 THEN 'Trendy'
             ELSE 'Not-classified' END) AS popularity_type
FROM usa_baby_names
GROUP BY first_name
ORDER BY first_name

--3. Top-ranked female names since 1920
-- RANK names by the sum of babies who have ever had that name (descending), aliasing as name_rank
-- Select name_rank, first_name, and the sum of babies who have ever had that name
-- Filter the data for results where sex equals 'F'
-- Limit to ten results
SELECT TOP 10 RANK() OVER(ORDER BY SUM(num) DESC) AS name_rank,
    first_name,
    SUM(num)
FROM usa_baby_names
WHERE sex = 'F'
GROUP BY first_name

--4. Picking a baby name
-- Select only the first_name column
-- Filter for results where sex is 'F', year is greater than 2015, and first_name ends in 'a'
-- Group by first_name and order by the total number of babies given that first_name
SELECT first_name
FROM usa_baby_names
WHERE sex = 'F'
    AND year > 2015
    AND first_name LIKE '%a'
GROUP BY first_name
ORDER BY SUM(num) DESC

--5. The Olivia expansion
-- Exploring how the name Olivia became so popular using a window function

-- Select year, first_name, num of Olivias in that year, and cumulative_olivias
-- Sum the cumulative babies who have been named Olivia up to that year; alias as cumulative_olivias
-- Filter so that only data for the name Olivia is returned.
-- Order by year from the earliest year to most recent

SELECT year,
       first_name,
       num,
       SUM(num) OVER (ORDER BY year) AS cumulative_olivias
FROM usa_baby_names
WHERE first_name = 'Olivia'
ORDER BY year

--6. Many males with same name
-- Select year and maximum number of babies given any one male name in that year, aliased as max_num
-- Filter the data to include only results where sex equals 'M'
SELECT year,
       max(num) AS max_num
FROM usa_baby_names
WHERE sex = 'M'
GROUP BY year

--7. Top male names over the years
-- Select year, first_name given to the largest number of male babies, and num of babies given that name
-- Join baby_names to the code in the last task as a subquery
-- Order results by year descending
SELECT b.year,
       b.first_name,
       b.num
FROM usa_baby_names AS b
INNER JOIN
    (SELECT year,
       max(num) AS max_num
     FROM usa_baby_names
     WHERE sex = 'M'
     GROUP BY year) AS m
ON m.year = b.year 
   AND m.max_num = b.num
ORDER BY year DESC

--8. Most years at number one
-- Select first_name and a count of years it was the top name in the last task; alias as count_top_name
-- Use the code from the previous task as a common table expression
-- Group by first_name and order by count_top_name descending
WITH top_male_names AS (
    SELECT TOP 101 b.year,
       b.first_name,
       b.num
    FROM usa_baby_names AS b
    INNER JOIN
        (SELECT year,
           max(num) AS max_num
         FROM usa_baby_names
         WHERE sex = 'M'
         GROUP BY year) AS m
    ON m.year = b.year 
       AND m.max_num = b.num
    ORDER BY year DESC
    )

SELECT first_name,
       COUNT(first_name) AS count_top_name
FROM top_male_names
GROUP BY first_name
ORDER BY count_top_name DESC