
# Investigate Rotten tomatoes data using SQL

- เป็นข้อมูลคะแนนของนักวิจารณ์และคนดูรวมถึงประเภทหนังและรายได้จาก rotten tomatoes ตั้งแต่ปี 1971 ถึงปี 2020 ทั้งหมด 997 เรื่อง
- ข้อมูลจาก [Kaggle link](https://www.kaggle.com/datasets/thedevastator/rotten-tomatoes-top-movies-ratings-and-technical)
- Data preparation process in this [github link](https://github.com/Thanyanon/datascience_project/blob/main/essential_python/rotten_tomatoes.ipynb)

## Finding
  
  1. [หนังที่ทำรายได้สูงสุด 10 อันดับแรก](##-1.-หนังที่ทำรายได้สูงสุด-10-อันดับแรก)
  2. [หนังที่ได้คะแนนนักวิจารณ์และคนดูสูงสุด 5 อันดับแรก](##-2.-หนังที่ได้คะแนนนักวิจารณ์และคนดูสูงสุด-5-อันดับแรก)
  3. รายได้เฉลี่ยของหนังที่นักวิจารณ์ชอบมากกว่า vs คนดูชอบมากกว่า
  4. ผู้กำกับที่ทำเงินได้มากที่สุด 5 อันดับแรก
  5. จำนวนหนังแบ่งตามประเภท
  6. ประเภทหนังที่ได้คะแนนนักวิจารณ์สูงสุด 5 อันดับแรก
  7. ประเภทหนังที่ได้คะแนนคนดูสูงสุด 5 อันดับแรก
  8. ประเภทหนังที่ทำเงินได้สูงที่สุด 5 อันดับแรก
  9. จำนวนหนังทีรับได้คะแนนนักวิจารณ์สูงสุดในแต่ละปี
  10. สร้าง virtual table เพื่อเก็บข้อมูลเฉพาะหนังที่ได้คะแนนนักวิจารณ์สูงสุดในแต่ละปี
  11. [ประเภทของหนังที่ได้คะแนนนักวิจารณ์สูงสุดในแต่ละปี](##-11.-หนังที่ได้คะแนนนักวิจารณ์สูงสุดในแต่ละปีเป็นหนังประเภท?)

---

## 1. หนังที่ทำรายได้สูงสุด 10 อันดับแรก

``` SQL
-- Top 10 movies with highest gross

SELECT
  title,
  year,
  genre,
  critic_score,
  people_score,
  gross_usa
FROM `studied-triode-356514.rotten_tomatoes.rotten_tomatoes_movies`
ORDER BY gross_usa DESC
LIMIT 10
```
![top10_movies_gross](https://github.com/Thanyanon/datascience_project/blob/main/sql/rotten_tomatoes/top10_movies_gross.png)


## 2. หนังที่ได้คะแนนนักวิจารณ์และคนดูสูงสุด 5 อันดับแรก

```SQL
-- Top 5 movies with highest critic_score and people_score

SELECT
  title,
  year,
  genre,
  critic_score,
  people_score,
  gross_usa
FROM `studied-triode-356514.rotten_tomatoes.rotten_tomatoes_movies`
ORDER BY critic_score DESC, people_score DESC
LIMIT 5
```
![top5_score](https://github.com/Thanyanon/datascience_project/blob/main/sql/rotten_tomatoes/top5_score.png)
  
  
## 3. รายได้เฉลี่ยของหนังที่นักวิจารณ์ชอบมากกว่า vs คนดูชอบมากกว่า

- หนังที่คะแนนนักวิจารณ์สูงกว่าคะแนนคนดูมีประมาณ 600 เรื่อง ซึ่งมากกว่าหนังที่คะแนนคนดูมากกว่าคะแนนนักวิจารณ์ที่ 90 เรื่องอยู่เกือบ 6 เท่า 
- แต่หนังที่คนดูให้คะแนนมากกว่านักวิจารณ์ทำรายได้เฉลี่ยอยู่ที่ประมาณ 70,000,000 เหรียญ ซึ่งมากกว่าหนังที่นักวิจารณ์ให้คะแนนมากกว่าที่ 50,000,000 เหรียญอยู่ 40%

**จำนวนหนังที่นักวิจารณ์ชอบมากกว่าคนดู**

```SQL
-- Number and average gross of movies which people score > critic_score

SELECT
  COUNT(title) AS num_movies,
  ROUND(AVG(gross_usa)) AS avg_gross
FROM `studied-triode-356514.rotten_tomatoes.rotten_tomatoes_movies`
WHERE people_score - critic_score > 0 AND gross_usa IS NOT NULL
```
![avg_gross_cmp](https://github.com/Thanyanon/datascience_project/blob/main/sql/rotten_tomatoes/avg_gross_cmp.png)

**จำนวนหนังที่คนดูชอบมากกว่านักวิจารณ์**

```SQL
-- Number and average gross of movies which critic_score > people score

SELECT
  COUNT(title) AS num_movies,
  ROUND(AVG(gross_usa)) AS avg_gross
FROM `studied-triode-356514.rotten_tomatoes.rotten_tomatoes_movies`
WHERE critic_score - people_score > 0 AND gross_usa IS NOT NULL
```
![avg_gross_pmc](https://github.com/Thanyanon/datascience_project/blob/main/sql/rotten_tomatoes/avg_gross_pmc.png)


## 4. ผู้กำกับที่ทำเงินได้มากที่สุด 5 อันดับแรก

```SQL
-- Find performance of each producer

SELECT
  DISTINCT(director) AS unique_director,
  COUNT(title) AS num_movies,
  ROUND(AVG(critic_score), 2) AS avg_critic_score,
  ROUND(AVG(people_score), 2) AS avg_people_score,
  ROUND(SUM(gross_usa)) AS total_gross,
  ROUND(AVG(gross_usa)) AS avg_gross,
  ROUND(MAX(gross_usa)) AS max_gross
FROM `studied-triode-356514.rotten_tomatoes.rotten_tomatoes_movies`
GROUP BY unique_director
ORDER BY total_gross DESC
LIMIT 5;
```
![top5_producer](https://github.com/Thanyanon/datascience_project/blob/main/sql/rotten_tomatoes/top5_producer.png)


## 5. ประเภทหนังที่มีจำนวนหนังเยอะที่สุด 10 อันดับแรกคือ

- หนังหนึ่งเรื่องสามารถมีประเภทของหนังหรือ genre ได้มากกว่า 1 ประเภท
- ใช้ SPLIT เพื่อแยกประเภทของหนังจากคอลัมน์ genre ออกมาด้วย delimiter ' ,' เพื่อให้ได้ column ใหม่ที่เป็น array
- ใช้ UNNEST เพื่อทำให้ data ของเรากลายเป็น long format เพื่อให้ aggregate ค่าได้ตามที่ต้องการ 

```SQL
-- See number of movies, average critic score, people score and gross in each movies genre
  -- Split genre which is a multiple value string with comma seperated to array using SPLIT
  -- Using UNNEST to seperated the genre array to get a long format of data

WITH sub AS (
  SELECT
    title,
    critic_score,
    people_score,
    gross_usa,
    SPLIT(genre, ", ") AS dis_genre
  FROM `studied-triode-356514.rotten_tomatoes.rotten_tomatoes_movies`
)

SELECT
  DISTINCT(genre) as unique_genre,
  COUNT(title) as num_movies,
  ROUND(AVG(critic_score), 2) as avg_critic_score,
  ROUND(AVG(people_score), 2) as avg_people_score,
  ROUND(AVG(gross_usa)) as avg_gross
FROM sub,
UNNEST(dis_genre) as genre
GROUP BY genre
ORDER BY num_movies DESC
```

> มีประเภทหนังทั้งหมด 23 ประเภท ซึ่งหนังหนึ่งเรื่องสามารถมีประเภทของหนังได้มากกว่าหนึ่งประเภท

![top10_genre_nummovie](https://github.com/Thanyanon/datascience_project/blob/main/sql/rotten_tomatoes/top10_genre_nummovie.png)


## 6. ประเภทหนังที่ได้คะแนนนักวิจารณ์สูงสุด 5 อันดับ

ประเภทหนังที่ได้คะแนนนักวิจารณ์สูงสุด 5 อันดับคือ gay and lesbian, crime, other, documentary และ animation ตามลำดับ

![top5_genre_criticscore](https://github.com/Thanyanon/datascience_project/blob/main/sql/rotten_tomatoes/top5_genre_criticscore.png)


## 7. ประเภทหนังที่ได้คะแนนคนดูสูงสุด 5 อันดับ

ประเภทหนังที่ได้คะแนนคนดูสูงสุด 5 อันดับคือ other, war, anime, crime และ musical

![top5_genre_peoplescore](https://github.com/Thanyanon/datascience_project/blob/main/sql/rotten_tomatoes/top5_genre_peoplescore.png)


## 8. ประเภทหนังที่ทำเงินได้สูงที่สุด 5 อันดับ

ประเภทหนังที่ทำเงินได้สูงที่สุด 5 อันดับคือ action, adventure, sci fi, fantasy และ kids and family

![top5_gross_genre](https://github.com/Thanyanon/datascience_project/blob/main/sql/rotten_tomatoes/top5_gross_genre.png)


## 9. จำนวนหนังทีได้คะแนนนักวิจารณ์สูงสุดในแต่ละปี

```SQL
-- Select max critic score from each year and number of movies which having max critic score
  -- Use CTE to create a max critic score in each year
  -- Filter fact table with max critic score of each year by using join
  -- Count number of top movies in each year

WITH max_scores AS (
  SELECT
    year,
    MAX(critic_score) AS max_critic_score,
  FROM `studied-triode-356514.rotten_tomatoes.rotten_tomatoes_movies` as movies
  GROUP BY year
)

SELECT
  movies.year AS year,
  COUNT(*) AS num_top_movies
FROM `studied-triode-356514.rotten_tomatoes.rotten_tomatoes_movies` as movies
JOIN max_scores
ON movies.year = max_scores.year
AND movies.critic_score = max_scores.max_critic_score
GROUP BY year
ORDER BY year DESC
```
![](https://github.com/Thanyanon/datascience_project/blob/main/sql/rotten_tomatoes/number_topmovies_eachyear.png)


## 10. สร้าง virtual table ที่เก็บข้อมูลเฉพาะหนังที่ได้คะแนนนักวิจารณ์สูงสุดในแต่ละปี

สร้าง virtual table ด้วย VIEW เพื่อเก็บข้อมูลของหนังที่ได้คะแนนนักวิจารณ์สูงสุดของแต่ละปี โดยในแต่ละปีอาจจะมีหนังที่ได้คะแนนสูงสุดเท่ากันหลายเรื่อง

```SQL
-- Create virtual table named top_movies contain data of movies which have highest score in each year

CREATE VIEW `studied-triode-356514.rotten_tomatoes.top_movies` 
AS
  WITH max_scores AS (
    SELECT 
      year AS year_max,
      MAX(critic_score) AS max_critic_score
    FROM `studied-triode-356514.rotten_tomatoes.rotten_tomatoes_movies` AS movies
    GROUP BY year_max
  )
SELECT
  *
FROM `studied-triode-356514.rotten_tomatoes.rotten_tomatoes_movies` AS movies
JOIN max_scores
ON movies.year = max_scores.year_max
AND movies.critic_score = max_scores.max_critic_score
```

## 11. หนังที่ได้คะแนนนักวิจารณ์สูงสุดในแต่ละปีเป็นหนังประเภท?

หนังที่ได้คะแนนนักวิจารณ์สูงสุดในแต่ละปีเป็นหนัง drama เป็นส่วนมาก โดยมีหนังถึง 60 เรื่องที่เป็นหนังประเภท drama

```SQL
WITH sub AS (
  SELECT
    title,
    year,
    critic_score,
    people_score,
    gross_usa,
    SPLIT(genre, ', ') as ar_genre
  FROM `studied-triode-356514.rotten_tomatoes.top_movies`
)

SELECT
  genre,
  COUNT(title) AS num_movies
FROM sub,
UNNEST(ar_genre) AS genre
GROUP BY genre
ORDER BY num_movies DESC
```
![topmovies_genre_count](https://github.com/Thanyanon/datascience_project/blob/main/sql/rotten_tomatoes/topmovies_genre_count.png)
