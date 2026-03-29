# Netflix-Movies-and-TV-Shows-Data-Analysis-using-SQL
![](https://github.com/Sasikumar-B7/Netflix-Movies-and-TV-Shows-Data-Analysis-using-SQL/blob/main/logo.png)

## Overview
This project involves a comprehensive analysis of Netflix's movies and TV shows data using SQL. The goal is to extract valuable insights and answer various business questions based on the dataset. The following README provides a detailed account of the project's objectives, business problems, solutions, findings, and conclusions.

## Objectives

- Analyze the distribution of content types (movies vs TV shows).
- Identify the most common ratings for movies and TV shows.
- List and analyze content based on release years, countries, and durations.
- Explore and categorize content based on specific criteria and keywords.

## Dataset

The data for this project is sourced from the Kaggle dataset:

- **Dataset Link:** [Movies Dataset](https://www.kaggle.com/datasets/shivamb/netflix-shows?resource=download)

## Schema

```sql
CREATE TABLE NETFLIX (
	show_id	VARCHAR (10),
	type VARCHAR(20),
	title VARCHAR(104),
	director VARCHAR(208),
	cast VARCHAR(1000),
	country VARCHAR(150),
	date_added VARCHAR(50),
	release_year VARCHAR (20),
	rating VARCHAR(10),
    duration VARCHAR (15),
	listed_in VARCHAR (100),
	description VARCHAR (250)
);```

## Business Problems and Solutions

### 1. Count the Number of Movies vs TV Shows

```sql
select 
type,
count(*)
from netflix
group by type;```

**Objective:** Determine the distribution of content types on Netflix.

### 2. Find the Most Common Rating for Movies and TV Shows

```sql
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
WHERE RK = 1;```

**Objective:** Identify the most frequently occurring rating for each type of content.

### 3. List All Movies Released in a Specific Year (e.g., 2020)

```sql
SELECT * 
FROM NETFLIX
WHERE TYPE = 'MOVIE' AND
RELEASE_YEAR = 2020;
```

**Objective:** Retrieve all movies released in a specific year.

## 4. Find the Top 5 Countries with the Most Content on Netflix**

```sql
SELECT * 
FROM NETFLIX 
WHERE TYPE = 'TV SHOW'
AND RELEASE_YEAR = 2021;```


**Objective:** Identify the top 5 countries with the highest number of content items.

## 5. Identify the Longest Movie

```sql
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
LIMIT 5;```

**Objective:** Find the movie with the longest duration.

## 6. Find Content Added in the Last 5 Years

```sql
SELECT * 
FROM NETFLIX 
WHERE RELEASE_YEAR >= YEAR (DATE_SUB(CURRENT_DATE, INTERVAL 5 YEAR)); ```

**Objective:** Retrieve content added to Netflix in the last 5 years.

**7. Find All Movies/TV Shows by Director 'Rajiv Chilaka'**

```sql
SELECT *
FROM netflix
WHERE DIRECTOR LIKE '%Rajiv Chilaka%'; ```

**Objective:** List all content directed by 'Rajiv Chilaka'.

**8. List All TV Shows with More Than 5 Seasons**

```sql
SELECT 
type, 
director,
cast(substring_index (duration, ' ', 1) as unsigned) as duration_season
FROM NETFLIX 
WHERE 
TYPE = 'TV SHOW' 
AND 
CAST(SUBSTRING_INDEX (duration, ' ', 1) AS UNSIGNED) > 5
order by duration_season desc; ```

**Objective:** Identify TV shows with more than 5 seasons.

**9. Count the Number of Content Items in Each Genre**

```sql
SELECT 
    genre,
    COUNT(*) AS total_content
FROM netflix,
JSON_TABLE(
    CONCAT('["', REPLACE(listed_in, ',', '","'), '"]'),
    '$[*]' COLUMNS (genre VARCHAR(255) PATH '$')
) AS jt
GROUP BY genre; ```

**Objective:** Count the number of content items in each genre.

**10.Find each year and the average numbers of content release in India on netflix. 
return top 5 year with highest avg content release!**

```sql
SELECT
	RELEASE_YEAR,
	COUNT(*) AS TOTAL_SHOW
FROM NETFLIX
WHERE COUNTRY LIKE '%India%'
GROUP BY RELEASE_YEAR
ORDER BY TOTAL_SHOW desc
LIMIT 5; ```

**Objective:** Calculate and rank years by the average number of content releases by India.

**11. List All Movies that are Documentaries**

```sql
SELECT *
FROM NETFLIX
WHERE LISTED_IN LIKE '%Documentaries%'; ```

**Objective: Retrieve all movies classified as documentaries.**

**12. Find All Content Without a Director**

```sql
SELECT * 
FROM netflix
WHERE director IS NULL; ```

**Objective: List content that does not have a director.**

**13. Find How Many Movies Actor 'Salman Khan' Appeared in the Last 10 Years**

```sql
SELECT *
FROM NETFLIX 
WHERE `cast` LIKE '%Salman%'
and
release_year >= extract(YEAR from CURRENT_DATE) - 10;```

**Objective:** Count the number of movies featuring 'Salman Khan' in the last 10 years.

**14. Find the Top 10 Actors Who Have Appeared in the Highest Number of Movies Produced in India**

```sql
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
LIMIT 10;```

**Objective:** Identify the top 10 actors with the most appearances in Indian-produced movies.

**15. Categorize Content Based on the Presence of 'Kill' and 'Violence' Keywords**

```sql
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
ORDER BY TYPE DESC; ```


## Findings and Conclusion

- **Content Distribution:** The dataset contains a diverse range of movies and TV shows with varying ratings and genres.
- **Common Ratings:** Insights into the most common ratings provide an understanding of the content's target audience.
- **Geographical Insights:** The top countries and the average content releases by India highlight regional content distribution.
- **Content Categorization:** Categorizing content based on specific keywords helps in understanding the nature of content available on Netflix.

This analysis provides a comprehensive view of Netflix's content and can help inform content strategy and decision-making.



## Author - Sasikumar , B

This project is part of my portfolio, showcasing the SQL skills essential for data analyst roles. If you have any questions, feedback, or would like to collaborate, feel free to get in touch!







