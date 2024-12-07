use project_gym_member;

SELECT * FROM gym_membership;

desc gym_membership;

SHOW CREATE TABLE gym_membership;


# CHANGE DATA TYPE OF avg_time_check_in

ALTER TABLE gym_membership
		MODIFY avg_time_check_in TIME AFTER fav_group_lesson;
        
        
# CHANGE DATA TYPE OF avg_time_check_out
        
ALTER TABLE gym_membership
		MODIFY avg_time_check_out TIME AFTER avg_time_check_in;
        

# User Distribution Based on Abonement Type        

SELECT abonoment_type, COUNT(*) AS jumlah_pengguna
FROM gym_membership
GROUP BY abonoment_type;


#  Gender Distribution of Users

SELECT gender, COUNT(*) AS jumlah_pengguna
FROM gym_membership
GROUP BY gender;


# Average age of users by subscription type

SELECT abonoment_type, AVG(Age) AS rata2_usia
FROM gym_membership
GROUP BY abonoment_type;


# Average User Time in Gym per Visit

SELECT AVG(avg_time_in_gym) AS rata_waktu_di_gym
FROM gym_membership;

# Frequent Sauna 

SELECT DISTINCT uses_sauna
FROM gym_membership;

SELECT COUNT(*) AS total_baris,
       COUNT(uses_sauna) AS total_tidak_null,
       SUM(CASE WHEN uses_sauna = 'TRUE' THEN 1 ELSE 0 END) AS pengguna_sauna
FROM gym_membership;


# Favorite Drink Distribution

SELECT TRIM(SUBSTRING_INDEX(SUBSTRING_INDEX(fav_drink, ',', numbers.n), ',', -1)) AS single_drink, 
       COUNT(*) AS jumlah
FROM gym_membership
JOIN numbers ON CHAR_LENGTH(fav_drink) - CHAR_LENGTH(REPLACE(fav_drink, ',', '')) >= numbers.n - 1
WHERE fav_drink IS NOT NULL
	  AND TRIM(SUBSTRING_INDEX(SUBSTRING_INDEX(fav_drink, ',', numbers.n), ',', -1)) != ''
GROUP BY single_drink
ORDER BY jumlah DESC;


# Average visits per week by subscription type

SELECT abonoment_type, AVG(visit_per_week) AS rata_kunjungan
FROM gym_membership
GROUP BY abonoment_type;

SELECT abonoment_type, SUM(visit_per_week)
FROM gym_membership
GROUP BY abonoment_type;


# Most Common Check-in and Check-out Times

SELECT avg_time_check_in, COUNT(*) AS jumlah_check_in
FROM gym_membership
GROUP BY avg_time_check_in
ORDER BY jumlah_check_in DESC
LIMIT 5;

SELECT avg_time_check_out, COUNT(*) AS jumlah_check_out
FROM gym_membership
GROUP BY avg_time_check_out
ORDER BY jumlah_check_out DESC
LIMIT 5;


# Number of Users Participating in Group Exercise by Type of Payment

SELECT DISTINCT attend_group_lesson
FROM gym_membership;

DESC gym_membership;

SELECT COUNT(*) AS total_baris,
       COUNT(attend_group_lesson) AS total_tidak_null,
       SUM(CASE WHEN attend_group_lesson = 'TRUE' THEN 1 ELSE 0 END) AS group_lesson
FROM gym_membership;

# Favorite Exersice

SELECT TRIM(SUBSTRING_INDEX(SUBSTRING_INDEX(fav_group_lesson, ',', numbers.n), ',', -1)) AS single_fav_group, 
       COUNT(*) AS jumlah
FROM gym_membership
JOIN numbers ON CHAR_LENGTH(fav_group_lesson) - CHAR_LENGTH(REPLACE(fav_group_lesson, ',', '')) >= numbers.n - 1
WHERE fav_group_lesson IS NOT NULL
	  AND TRIM(SUBSTRING_INDEX(SUBSTRING_INDEX(fav_group_lesson, ',', numbers.n), ',', -1)) != ''
GROUP BY single_fav_group
ORDER BY jumlah DESC;
