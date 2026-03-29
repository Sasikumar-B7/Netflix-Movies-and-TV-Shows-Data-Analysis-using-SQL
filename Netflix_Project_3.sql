-- create database netflix
create database Netflix;

-- Create table netflix
DROP TABLE IF EXISTS NETFLIX;
CREATE TABLE NETFLIX (
	show_id	VARCHAR(10),
	type VARCHAR(20),
	title VARCHAR(104),
	director VARCHAR(208),
	cast VARCHAR(1000),
	country VARCHAR(150),
	date_added VARCHAR(50),
	release_year VARCHAR(20),
	rating VARCHAR(10),
    duration VARCHAR(15),
	listed_in VARCHAR(100),
	description VARCHAR(250)
);

DESCRIBE TABLE NETFLIX;
SELECT * FROM NETFLIX;


SET GLOBAL local_infile = 1;

LOAD DATA LOCAL INFILE 'C:/Users/sasik/Downloads/Git Hub SQL Projects/Project 3 Netflix/netflix_titles.csv'
INTO TABLE NETFLIX
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS;

select * from netflix;

Alter table netflix
modify release_year int;

-- 1. Count the number of Movies vs TV Shows

select 
type,
count(*)
from netflix
group by type;

-- 2. Find the most common rating for movies and TV shows

SELECT TYPE, RATING, TOTAL
FROM
(
select 
	TYPE,
    RATING,
    COUNT(*) AS TOTAL,
    RANK() OVER(PARTITION BY TYPE ORDER BY COUNT(*) DESC) AS RK
    FROM NETFLIX
    GROUP BY TYPE, RATING
) T
WHERE RK = 1;

-- 3. List all movies released in a specific year (e.g., 2020)
SELECT * 
FROM NETFLIX
WHERE TYPE = 'MOVIE' AND
RELEASE_YEAR = 2020;

-- 4. List all tv show released in a specific year (e.g., 2021)
SELECT * 
FROM NETFLIX 
WHERE TYPE = 'TV SHOW'
AND RELEASE_YEAR = 2021;

-- 5. Find the top 5 countries with the most content on Netflix

SELECT
  TRIM(jt.country) AS country,
  COUNT(*) AS total_count
FROM netflix
JOIN JSON_TABLE(
  CONCAT('["', REPLACE(country, ',', '","'), '"]'),
  "$[*]" COLUMNS (
    country VARCHAR(100) PATH "$"
  )
) AS jt
ON TRUE
WHERE jt.country <> ''
GROUP BY TRIM(jt.country)
ORDER BY total_count DESC
LIMIT 5;

-- 5. Identify the longest movie

SELECT *
FROM netflix
WHERE type = 'Movie'
ORDER BY CAST(SUBSTRING_INDEX(duration, ' ', 1) AS UNSIGNED) DESC;

-- 6. Find content added in the last 5 years

SELECT *
FROM netflix
ORDER BY RELEASE_YEAR DESC;

SELECT * 
FROM NETFLIX 
WHERE RELEASE_YEAR >= YEAR (DATE_SUB(CURRENT_DATE, INTERVAL 5 YEAR));

-- 7. Find all the movies/TV shows by director 'Rajiv Chilaka'!

SELECT *
FROM netflix
WHERE DIRECTOR LIKE '%Rajiv Chilaka%';

-- 8. List all TV shows with more than 5 seasons

SELECT 
type, 
director,
cast(substring_index (duration, ' ', 1) as unsigned) as duration_season
FROM NETFLIX 
WHERE 
TYPE = 'TV SHOW' 
AND 
CAST(SUBSTRING_INDEX (duration, ' ', 1) AS UNSIGNED) > 5
order by duration_season desc;

-- 9. Count the number of content items in each genre

SELECT 
    genre,
    COUNT(*) AS total_content
FROM netflix,
JSON_TABLE(
    CONCAT('["', REPLACE(listed_in, ',', '","'), '"]'),
    '$[*]' COLUMNS (genre VARCHAR(255) PATH '$')
) AS jt
GROUP BY genre;

-- 10. Find each year and the average numbers of content release by India on netflix. 
-- return top 5 year with highest avg content release !

SELECT
	RELEASE_YEAR,
	COUNT(*) AS TOTAL_SHOW
FROM NETFLIX
WHERE COUNTRY LIKE '%India%'
GROUP BY RELEASE_YEAR
ORDER BY TOTAL_SHOW desc
LIMIT 5;

-- 11. List all movies that are documentaries

SELECT *
FROM NETFLIX
WHERE LISTED_IN LIKE '%Documentaries%';

-- 12. Find all content without a director

SELECT *
FROM NETFLIX
WHERE DIRECTOR = '';

-- 13. Find how many movies actor 'Salman Khan' appeared in last 10 years!
SELECT *
FROM NETFLIX 
WHERE `cast` LIKE '%Salman%'
and
release_year >= extract(YEAR from CURRENT_DATE) - 10;

-- 14. Find the top 10 actors who have appeared in the highest number of movies produced in India.
SELECT 
TRIM(ACTOR) AS ACTOR,
COUNT(*) AS TOTAL_COUNT
FROM NETFLIX,
JSON_TABLE(
    CONCAT('["', REPLACE(`cast`, ',', '","'), '"]'),
    '$[*]' COLUMNS (actor VARCHAR(255) PATH '$')
) AS jt
WHERE COUNTRY LIKE '%India%'
AND ACTOR != ''
GROUP BY ACTOR
ORDER BY TOTAL_COUNT DESC
LIMIT 10;

/*
Question 15:
Categorize the content based on the presence of the keywords 'kill' and 'violence' in 
the description field. Label content containing these keywords as 'Bad' and all other 
content as 'Good'. Count how many items fall into each category.
*/

SELECT 
CATEGORY,
TYPE,
COUNT(*) AS TOTAL_COUNT
FROM (
SELECT *,
CASE
when
	DESCRIPTION LIKE '%kill%' OR '%violence%' then 'Bad'
    else 'Good'
    end as category
from netflix
) AS CATEGORIZED_CONTENT
GROUP BY CATEGORY, TYPE
ORDER BY TYPE DESC;


    


















