-- Netflix Project
CREATE TABLE netflix
(
	show_id	VARCHAR(10),
	type    VARCHAR(10),
	title	VARCHAR(250),
	director VARCHAR(550),
	casts	VARCHAR(1050),
	country	VARCHAR(550),
	date_added	VARCHAR(55),
	release_year	INT,
	rating	VARCHAR(15),
	duration	VARCHAR(100),
	listed_in	VARCHAR(250),
	description VARCHAR(550)
);

-- View the data
SELECT * FROM netflix;

-- 1. Count the number of Movies vs TV Shows

SELECT 
	type,
	COUNT(*) as total_content
FROM netflix
GROUP BY type

-- 2. Find the most common rating for movies and TV shows
SELECT DISTINCT ON (type) type, rating AS most_common_rating
FROM netflix
GROUP BY type, rating
ORDER BY type, COUNT(*) DESC;

-- 3. List all movies released in a specific year (e.g., 2020)
SELECT * FROM netflix WHERE release_year = 2020;
-- Count no.of movies of that particular year
SELECT COUNT(*) FROM netflix WHERE release_year = 2020;

-- 4. Find the Top 5 countries with the most content on Netflix
SELECT TRIM(UNNEST(STRING_TO_ARRAY(country, ','))) AS country,
       COUNT(*) AS total_content
FROM netflix
WHERE country IS NOT NULL
GROUP BY 1
ORDER BY total_content DESC
LIMIT 5;

-- 5. Identify the longest movie
SELECT * FROM netflix
WHERE type = 'Movie' AND
duration = (SELECT MAX(duration) FROM netflix)
ORDER BY duration DESC
LIMIT 1

-- 6. Find content added in the last 5 years
SELECT * FROM netflix
WHERE TO_DATE(date_added, 'Month DD, YYYY') >= CURRENT_DATE - INTERVAL '5 years';

-- 7. Find all Movies/TV Shows by director 'Rajiv Chilaka'
SELECT * FROM netflix
WHERE director ILIKE '%Rajiv Chilaka%';

-- 8. List all TV Shows with more than 5 seasons
SELECT * FROM netflix
WHERE type = 'TV Show'
  AND CAST(SPLIT_PART(duration, ' ', 1) AS INT) > 5;

-- 9. Count the number of content items in each genre
SELECT 
	TRIM(UNNEST(STRING_TO_ARRAY(listed_in, ','))) AS genre,
	COUNT(*) AS total_content
FROM netflix
GROUP BY genre
ORDER BY total_content DESC;

-- 10. Find each year and the average number of content releases by India
SELECT 
	release_year,
	COUNT(show_id) AS total_release,
	ROUND(COUNT(show_id) * 100.0 / SUM(COUNT(show_id)) OVER (), 2) AS percent_share
FROM netflix
WHERE country ILIKE '%India%'
GROUP BY release_year
ORDER BY percent_share DESC
LIMIT 5;

-- 11. List all movies that are documentaries
SELECT * FROM netflix
WHERE type = 'Movie' AND listed_in ILIKE '%Documentaries%';

-- 12. Find all content without a director
SELECT * FROM netflix
WHERE director IS NULL OR director = '';

-- 13. Find how many movies actor 'Salman Khan' appeared in during the last 10 years
SELECT COUNT(*) AS total_movies
FROM netflix
WHERE casts ILIKE '%Salman Khan%'
  AND release_year > EXTRACT(YEAR FROM CURRENT_DATE) - 10
  AND type = 'Movie';

-- 14. Find the top 10 actors who have appeared in the highest number of movies produced in India
SELECT 
	TRIM(UNNEST(STRING_TO_ARRAY(casts, ','))) AS actor,
	COUNT(*) AS total_movies
FROM netflix
WHERE country ILIKE '%India%'
GROUP BY actor
ORDER BY total_movies DESC
LIMIT 10;

-- 15. Categorize the content based on the presence of the keywords 'kill' and 'violence'
SELECT 
	CASE 
		WHEN description ILIKE '%kill%' OR description ILIKE '%violence%' THEN 'Bad'
		ELSE 'Good'
	END AS category,
	COUNT(*) AS content_count
FROM netflix
GROUP BY category
ORDER BY content_count DESC;