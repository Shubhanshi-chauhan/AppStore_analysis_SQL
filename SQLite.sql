Create table Applestore_description_combined AS

SELECT * from appleStore_description1

UNION ALL

SELECT * from appleStore_description2

Union ALL

SELECT * from appleStore_description3

Union ALL

SELECT * from appleStore_description4

**EDA**

--check tha number of unique apps in tables
Select count(DISTINCT id) AS UniqueIDs
From AppleStore

Select count(DISTINCT id) AS UniqueIDs
from Applestore_description_combined


--check for missing values--AppleStore
select count(*) AS Missingvalues
from AppleStore
where track_name IS NULL Or user_rating is null OR prime_genre is null

--check for missing values Applestore_description_combined table
select count(*) AS Missingvalues
from Applestore_description_combined
where app_desc IS NULL

--find out number of apps per genre

SELECT prime_genre,count(*) as NumApps
From AppleStore
Group BY prime_genre
Order by NumApps DESC


--Get an overview of the Apps ratings
Select min(user_rating) As MinRating,
		max(user_rating) As Maxrating,
        avg(user_rating) AS AvgRating
From AppleStore 

 --Determine whether paid apps have higher rating than free App
 
Select CASE
			when price > 0 then 'Paid'
            Else 'Free'
            End AS App_Type,
            Avg(user_rating) As avg_rating
from AppleStore
Group by App_Type

--check if apps with supportes languages have higher rating

Select CASE
			when  lang_num <10 THEN '<10 languages'
            When lang_num BETWEEN 10 AND 30 THEN '10-30 languages'
            Else '>30 languages'
            End As language_bucket,
            avg(user_rating) As avg_rating
From AppleStore
Group by language_bucket
Order by avg_rating desc

--check genres with low ratings

Select prime_genre, avg(user_rating) As avg_rating
from AppleStore
Group by prime_genre
order by avg_rating asc
limit 10

--check if there is corelation between the length of the app description and the user rating

Select CASE
	when length(B.app_desc) <500 THEN 'short'
        When length(B.app_desc) BETWEEN 500 and 1000 THEN 'Medium'
        Else 'Long'
        End As description_length_bucket,
        avg(A.user_rating) AS average_rating

FROM
	AppleStore as A
JOIN
	Applestore_description_combined As B
ON
	a.id= b.id
group by description_length_bucket
Order by average_rating DESC

--Interesting insight-apps having long description has higher rating

--check the top-rated apps for each genre

Select 
	prime_genre,
       track_name,
       user_rating
From (
  Select
  	prime_genre,
    track_name,
    user_rating,
  	Rank() Over(PARTITION BY prime_genre ORDER by user_rating DESC,rating_count_tot DESC) as rank
  	FROM
  	AppleStore
  ) AS A 
  WHERE
  A.rank = 1
  
  --Summary:
  --Paid apps have better rating 
  --Apps supporting between 10 and 30 languages have better ratings 
  --Finance and book apps have low ratings (more need to create app for market penetration)
  --Apps with a longer description have bettter ratings 
  --A new app should aim for an average rating above 3.5 
  --Games and entertainment have high comptetion (high demand)
  
	







