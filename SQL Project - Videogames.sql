-- In this project, we'll explore the top 400 best-sellingvideogames created between 1977 and 2020. 
--We'll compare a dataset on game sales with critic and user reviews to determine whether or not videogames have improved as the gaming market has grown.

-- 1. Top selling video games of all time.

-- Select all information for the top ten best-selling games
-- Order the results from best-selling game down to tenth best-selling
USE VideogamesProject

SELECT TOP 10 *
FROM game_sales
ORDER BY Total_Shipped DESC;

-- 2. Missing review scores

-- Join games_sales and reviews
-- Select a count of the number of games where both critic_score and user_score are null
SELECT COUNT(*)
FROM game_sales AS gs
LEFT JOIN game_reviews AS r
ON gs.Name = r.Name
WHERE critic_score IS NULL AND user_score IS NULL;

-- 3. Years that video game critics loved

-- Select release year and average critic score for each year, rounded and aliased
-- Join the game_sales and reviews tables
-- Group by release year
-- Order the data from highest to lowest avg_critic_score and limit to 10 results
SELECT TOP 10 gs.year, AVG(r.critic_score) AS avg_critic_score
FROM game_sales AS gs
INNER JOIN game_reviews AS r
ON gs.name = r.name
GROUP BY gs.year
ORDER BY avg_critic_score DESC;

-- 4. Was 1982 really that great?

-- Paste your query from the previous task; update it to add a count of games released in each year called num_games
-- Update the query so that it only returns years that have more than four reviewed games
SELECT TOP 10 gs.year, AVG(r.critic_score) AS avg_critic_score, COUNT(gs.name) AS num_games
FROM game_sales AS gs
INNER JOIN game_reviews AS r
ON gs.name = r.name
GROUP BY gs.year
HAVING COUNT(gs.name) > 4
ORDER BY avg_critic_score DESC;

-- 5. Years that dropped off the critics' favorites list
-- Select the year and avg_critic_score for those years that dropped off the list of critic favorites 
-- Order the results from highest to lowest avg_critic_score
SELECT year, avg_critic_score
FROM top_critic_scores
EXCEPT
SELECT year, avg_critic_score
FROM top_critic_scores_more_than_four_games
ORDER BY avg_critic_score DESC;

-- 6. Years video game players loved
-- Select year, an average of user_score, and a count of games released in a given year, aliased and rounded
-- Include only years with more than four reviewed games; group data by year
-- Order data by avg_user_score, and limit to ten results
SELECT TOP 10 gs.year, AVG(r.user_score) AS avg_user_score, COUNT(gs.name) AS num_games
FROM game_sales AS gs
INNER JOIN game_reviews AS r
ON gs.name = r.name
GROUP BY gs.year
HAVING COUNT(gs.name) > 4
ORDER BY avg_user_score DESC;

-- 7. Years that both players and critics loved
-- Select the year results that appear on both tables
SELECT year
FROM top_critic_scores_more_than_four_games
INTERSECT
SELECT year
FROM top_user_scores_more_than_four_games;

-- 8. Sales in best video games years
-- Select year and sum of games_sold, aliased as total_games_sold; order results by total_games_sold descending
-- Filter game_sales based on whether each year is in the list returned in the previous task
SELECT year, SUM(total_shipped) AS total_games_sold
FROM game_sales
WHERE year IN (
    SELECT year
    FROM top_critic_scores_more_than_four_games
    INTERSECT
    SELECT year
    FROM top_user_scores_more_than_four_games)
GROUP BY year
ORDER BY total_games_sold DESC;