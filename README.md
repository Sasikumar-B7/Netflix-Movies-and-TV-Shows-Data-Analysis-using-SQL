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

- ## Schema

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


