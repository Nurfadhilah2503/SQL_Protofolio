-- Show detail of IMDb Dataset

SELECT *
FROM imdb_movie_dataset;

-- Count All Film

SELECT COUNT(*)
FROM imdb_movie_dataset;


-- Data Cleaning

# Resolving Outliers / Null Values in the Year column

SELECT *
FROM imdb_movie_dataset
WHERE Year = 0;

UPDATE imdb_movie_dataset
SET Year = 2016
WHERE Title = 'Amateur Night' # I search the year of film manually on Google
LIMIT 1;

UPDATE imdb_movie_dataset
SET Year = 2015
WHERE Title = 'Wrecker'
LIMIT 1;

UPDATE imdb_movie_dataset
SET Year = 2014
WHERE Title = "Let's Be Cops"
LIMIT 1;

UPDATE imdb_movie_dataset
SET Year = 2010
WHERE Title = 'Srpski film'
LIMIT 1;

UPDATE imdb_movie_dataset
SET Year = 2006
WHERE Title = 'Idiocracy'
LIMIT 1;

# Resolving Outliers / Null Values in the Rating column

SELECT *
FROM imdb_movie_dataset
WHERE Rating > 9.9;

UPDATE imdb_movie_dataset
SET Rating = NULL
WHERE Rating > 9.9
LIMIT 12; # I use LIMIT If in Safe Update Mode

SELECT *
FROM imdb_movie_dataset
WHERE Rating = 0;

UPDATE imdb_movie_dataset
SET Rating = 6.7
WHERE Rating IS NULL OR Rating = 0
LIMIT 12; # I use LIMIT If in Safe Update Mode

# Resolving Outliers / Null Values in the Runtime (Minutes) column

SELECT *
FROM imdb_movie_dataset
WHERE `Runtime (Minutes)` < 60 or `Runtime (Minutes)` > 195;

UPDATE imdb_movie_dataset
SET `Runtime (Minutes)` = 123
WHERE `Runtime (Minutes)` > 195
LIMIT 8;

UPDATE imdb_movie_dataset
SET `Runtime (Minutes)` = 100
WHERE `Runtime (Minutes)` < 60
LIMIT 6;

# Resolving Outliers / Null Values in Revenue column

SELECT COUNT(`Revenue (Millions)`)
FROM imdb_movie_dataset
WHERE `Revenue (Millions)` = 0
ORDER BY `Revenue (Millions)` DESC;

UPDATE imdb_movie_dataset
SET `Revenue (Millions)` = 13.27
WHERE `Revenue (Millions)` = 0
LIMIT 126;

# Resolving Outliers / Null Values in Metascore column

SELECT Rank, Title, Metascore
FROM imdb_movie_dataset
WHERE Metascore = 0 or Metascore > 100
ORDER BY Metascore DESC;

UPDATE imdb_movie_dataset
SET Metascore = 72
WHERE Metascore > 100
LIMIT 6;

UPDATE imdb_movie_dataset
SET Metascore = 11
WHERE Metascore = 0
LIMIT 70;

# Resolving Outliers / Null Values in Votes column
 
SELECT COUNT(Votes)
FROM imdb_movie_dataset
WHERE Votes = 0;

UPDATE imdb_movie_dataset
SET Votes = 3630
WHERE Votes = 0
LIMIT 1;


-- Film Analysis by Rating
# Check Avarage of Rating Film

SELECT AVG(rating) AS avg_rating FROM imdb_movie_dataset;

# Search for the highest and lowest rated movies

SELECT Title, Rating 
FROM imdb_movie_dataset 
ORDER BY Rating DESC 
LIMIT 10;

SELECT Title, Rating 
FROM imdb_movie_dataset 
ORDER BY Rating ASC 
LIMIT 10;


-- Film Analysis by Genre
# Count the Film by Genre

SELECT TRIM(SUBSTRING_INDEX(SUBSTRING_INDEX(Genre, ',', numbers.n), ',', -1)) AS single_genre, 
       COUNT(*) AS jumlah
FROM imdb_movie_dataset
JOIN numbers ON CHAR_LENGTH(Genre) - CHAR_LENGTH(REPLACE(Genre, ',', '')) >= numbers.n - 1
WHERE Genre IS NOT NULL
	  AND TRIM(SUBSTRING_INDEX(SUBSTRING_INDEX(Genre, ',', numbers.n), ',', -1)) != ''
GROUP BY single_genre
ORDER BY jumlah DESC;

# Average rating per genre

SELECT Single_Genre AS Genre, 
       COUNT(*) AS Total_Films, 
       AVG(Rating) AS Average_Rating
FROM (
    SELECT Title, Rating,
           TRIM(SUBSTRING_INDEX(SUBSTRING_INDEX(Genre, ',', numbers.n), ',', -1)) AS Single_Genre
    FROM imdb_movie_dataset
    JOIN ( 
          SELECT 1 n UNION ALL SELECT 2 UNION ALL SELECT 3 
          UNION ALL SELECT 4 UNION ALL SELECT 5 UNION ALL SELECT 6
    ) numbers
    ON CHAR_LENGTH(Genre) - CHAR_LENGTH(REPLACE(Genre, ',', '')) >= numbers.n - 1
) AS Split_Genre
GROUP BY Single_Genre
ORDER BY Average_Rating DESC;

# Genres with the highest number of movies in 2016

WITH GenreExploded AS (
    SELECT 
        Title,
        YEAR, 
        TRIM(SUBSTRING_INDEX(SUBSTRING_INDEX(Genre, ',', numbers.n), ',', -1)) AS SingleGenre
    FROM 
        (SELECT 1 AS n UNION SELECT 2 UNION SELECT 3 UNION SELECT 4 UNION SELECT 5) numbers, -- Support up to 5 genres
        imdb_movie_dataset
    WHERE
        LENGTH(Genre) - LENGTH(REPLACE(Genre, ',', '')) + 1 >= numbers.n
        AND YEAR = 2016
)

# Count the Most Genres
SELECT 
    SingleGenre AS Genre, 
    COUNT(*) AS FilmCount
FROM 
    GenreExploded
GROUP BY 
    SingleGenre
ORDER BY 
    FilmCount DESC;


-- Film Analysis by Duration
 
# Longest Duration

SELECT title, `Runtime (Minutes)`
FROM imdb_movie_dataset
ORDER BY `Runtime (Minutes)` DESC
LIMIT 5; 

# Shortest Duration

SELECT title, `Runtime (Minutes)`
FROM imdb_movie_dataset
ORDER BY `Runtime (Minutes)` ASC
LIMIT 5;


-- Film Analysis by Director
# Movie distribution by director (Top 10 directors with the most movies)

SELECT Director, COUNT(*) AS movie_count
FROM imdb_movie_dataset
GROUP BY Director
ORDER BY movie_count DESC
LIMIT 10;

# Director with the highest average rating (minimum 5 movies)

SELECT director, AVG(rating) AS avg_rating, COUNT(*) AS movie_count
FROM imdb_movie_dataset
GROUP BY director
HAVING movie_count >= 5
ORDER BY avg_rating DESC
LIMIT 10;


-- Film Analysis by Year
# Count the film per Year

SELECT Year, COUNT(*) AS movie_count 
FROM imdb_movie_dataset 
GROUP BY Year 
ORDER BY Year;

# Years with the most movies

SELECT Year, COUNT(*) AS total_movies
FROM imdb_movie_dataset
GROUP BY Year
ORDER BY total_movies DESC
LIMIT 10;


-- Film Analysis by Revenue

SELECT Rank, Title, `Revenue (Millions)`
FROM imdb_movie_dataset
ORDER BY `Revenue (Millions)` DESC;

# Average Revenue by Genre

SELECT 
    Single_Genre AS Genre,
    AVG(`Revenue (Millions)`) AS Average_Revenue
FROM (
    SELECT 
        TRIM(SUBSTRING_INDEX(SUBSTRING_INDEX(Genre, ',', numbers.n), ',', -1)) AS Single_Genre,
        `Revenue (Millions)`
    FROM 
        imdb_movie_dataset
    JOIN 
        (SELECT 1 AS n UNION ALL SELECT 2 UNION ALL SELECT 3 UNION ALL SELECT 4 UNION ALL SELECT 5 UNION ALL SELECT 6) numbers
    ON 
        CHAR_LENGTH(Genre) - CHAR_LENGTH(REPLACE(Genre, ',', '')) >= numbers.n - 1
) Split_Genre
GROUP BY 
    Single_Genre
ORDER BY 
    Average_Revenue DESC;
    
# Top 10 Revenue Film

SELECT Rank, Title, `Revenue (Millions)`
FROM imdb_movie_dataset
ORDER BY `Revenue (Millions)` DESC
LIMIT 10;
    

-- Film Analysis by Metascore

SELECT Rank, Title, Metascore
FROM imdb_movie_dataset
ORDER BY Metascore DESC;

# Metascore Distribution

SELECT 
    FLOOR(Metascore / 10) * 10 AS Score_Range,
    COUNT(*) AS Total_Movies
FROM imdb_movie_dataset
GROUP BY Score_Range
ORDER BY Score_Range;

# Average Metascore by Genre

SELECT 
    Single_Genre AS Genre,
    AVG(Metascore) AS Average_Metascore
FROM (
    SELECT 
        TRIM(SUBSTRING_INDEX(SUBSTRING_INDEX(Genre, ',', numbers.n), ',', -1)) AS Single_Genre,
        Metascore
    FROM 
        imdb_movie_dataset
    JOIN 
        (SELECT 1 AS n UNION ALL SELECT 2 UNION ALL SELECT 3 UNION ALL SELECT 4 UNION ALL SELECT 5 UNION ALL SELECT 6) numbers
    ON 
        CHAR_LENGTH(Genre) - CHAR_LENGTH(REPLACE(Genre, ',', '')) >= numbers.n - 1
) Split_Genre
GROUP BY 
    Single_Genre
ORDER BY 
    Average_Metascore DESC;

# Top 10 Metascore Film

SELECT 
    Title,
    Metascore
FROM imdb_movie_dataset
ORDER BY Metascore DESC
LIMIT 10;

# Metascore Distribution by Year

SELECT 
    Year,
    AVG(Metascore) AS Average_Metascore,
    MIN(Metascore) AS Lowest_Metascore,
    MAX(Metascore) AS Highest_Metascore
FROM imdb_movie_dataset
GROUP BY Year
ORDER BY Year;

# Count of Films by Metascore Category

SELECT 
    CASE 
        WHEN Metascore >= 80 THEN 'Excellent'
        WHEN Metascore >= 60 THEN 'Good'
        WHEN Metascore >= 40 THEN 'Average'
        ELSE 'Poor'
    END AS Metascore_Category,
    COUNT(*) AS Total_Movies
FROM imdb_movie_dataset
GROUP BY Metascore_Category
ORDER BY Total_Movies DESC;


-- Film Analysis by Votes

#  Votes Distribution

SELECT 
    FLOOR(Votes / 100000) * 100000 AS Vote_Range,
    COUNT(*) AS Total_Movies
FROM imdb_movie_dataset
GROUP BY Vote_Range
ORDER BY Vote_Range;

# Average Votes by Genre

SELECT 
    Single_Genre AS Genre,
    AVG(Votes) AS Average_Votes
FROM (
    SELECT 
        TRIM(SUBSTRING_INDEX(SUBSTRING_INDEX(Genre, ',', numbers.n), ',', -1)) AS Single_Genre,
        Votes
    FROM 
        imdb_movie_dataset
    JOIN 
        (SELECT 1 AS n UNION ALL SELECT 2 UNION ALL SELECT 3 UNION ALL SELECT 4 UNION ALL SELECT 5 UNION ALL SELECT 6) numbers
    ON 
        CHAR_LENGTH(Genre) - CHAR_LENGTH(REPLACE(Genre, ',', '')) >= numbers.n - 1
) Split_Genre
GROUP BY 
    Single_Genre
ORDER BY 
    Average_Votes DESC;
    
# Top 10 Votes Film

SELECT
	Rank,
    Title,
    Votes
FROM imdb_movie_dataset
ORDER BY Votes DESC
LIMIT 10;

# Average Votes by Year

SELECT 
    Year,
    AVG(Votes) AS Average_Votes,
    MAX(Votes) AS Max_Votes,
    MIN(Votes) AS Min_Votes
FROM imdb_movie_dataset
GROUP BY Year
ORDER BY Year;

# Movie Classification Based on Number of Votes

SELECT 
    CASE 
        WHEN Votes >= 1000000 THEN 'Very Popular'
        WHEN Votes >= 500000 THEN 'Popular'
        WHEN Votes >= 100000 THEN 'Moderately Popular'
        ELSE 'Less Popular'
    END AS Popularity_Category,
    COUNT(*) AS Total_Movies
FROM imdb_movie_dataset
GROUP BY Popularity_Category
ORDER BY Total_Movies DESC;

# Votes Distribution by Genre

SELECT 
    Single_Genre AS Genre,
    FLOOR(Votes / 100000) * 100000 AS Vote_Range,
    COUNT(*) AS Total_Movies
FROM (
    SELECT 
        TRIM(SUBSTRING_INDEX(SUBSTRING_INDEX(Genre, ',', numbers.n), ',', -1)) AS Single_Genre,
        Votes
    FROM 
        imdb_movie_dataset
    JOIN 
        (SELECT 1 AS n UNION ALL SELECT 2 UNION ALL SELECT 3 UNION ALL SELECT 4 UNION ALL SELECT 5 UNION ALL SELECT 6) numbers
    ON 
        CHAR_LENGTH(Genre) - CHAR_LENGTH(REPLACE(Genre, ',', '')) >= numbers.n - 1
) Split_Genre
GROUP BY Single_Genre, Vote_Range
ORDER BY Single_Genre, Vote_Range;

    
-- Correlation and Combination

# Top 10 movies by genre and rating combination

SELECT title, genre, rating
FROM imdb_movie_dataset
ORDER BY rating DESC
LIMIT 10;

# Genre distribution by release year

SELECT
  Year,
  Single_Genre AS Genre,
  COUNT(*) AS Total_Movies
FROM (
  SELECT
    YEAR,
    TRIM(SUBSTRING_INDEX(SUBSTRING_INDEX(Genre, ',', numbers.n), ',', -1)) AS Single_Genre
  FROM imdb_movie_dataset
  JOIN (
    SELECT 1 n UNION ALL SELECT 2 UNION ALL SELECT 3
    UNION ALL SELECT 4 UNION ALL SELECT 5 UNION ALL SELECT 6
  ) numbers
  ON CHAR_LENGTH(Genre) - CHAR_LENGTH(REPLACE(Genre, ',', '')) = numbers.n - 1
) Split_Genre
GROUP BY Year, Single_Genre
ORDER BY Year ASC, Total_Movies DESC;

# Correlation between Duration and Rating

SELECT `Runtime (Minutes)`, AVG(rating) AS avg_rating
FROM imdb_movie_dataset
GROUP BY `Runtime (Minutes)`
ORDER BY `Runtime (Minutes)`;

# Correlation between Metascore and Rating

SELECT 
    ROUND(Metascore / 10) * 10 AS Score_Range,
    AVG(Rating) AS Average_Rating
FROM imdb_movie_dataset
GROUP BY Score_Range
ORDER BY Score_Range;

# Correlation between Metascore and Revenue

SELECT 
    ROUND(Metascore / 10) * 10 AS Score_Range,
    AVG(`Revenue (Millions)`) AS Average_Revenue
FROM imdb_movie_dataset
GROUP BY Score_Range
ORDER BY Score_Range;

# Correlation between Votes and Rating

SELECT 
    FLOOR(Votes / 100000) * 100000 AS Vote_Range,
    AVG(Rating) AS Average_Rating
FROM imdb_movie_dataset
GROUP BY Vote_Range
ORDER BY Vote_Range;

# Correlation between Votes and Revenue

SELECT 
    FLOOR(Votes / 100000) * 100000 AS Vote_Range,
    AVG(`Revenue (Millions)`) AS Average_Revenue
FROM imdb_movie_dataset
GROUP BY Vote_Range
ORDER BY Vote_Range;
