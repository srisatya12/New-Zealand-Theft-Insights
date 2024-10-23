-- OBJECTIVE 1: IDENTIFY WHEN VEHICLES ARE STOLEN

-- 1. Find the number of vehicles stolen each year. SELECT * FROM stol

SELECT * FROM stolen_vehicles;

SELECT YEAR (date_stolen), COUNT(vehicle_id) AS num_vehicles
FROM stolen_vehicles 
GROUP BY YEAR(date_stolen);


-- 2. Find the number of vehicles stolen each month.

SELECT YEAR(date_stolen) AS year,MONTH(date_stolen) as month, COUNT(vehicle_id) AS num_vehicles
 FROM stolen_vehicles 
GROUP BY year, MONTH (date_stolen)
ORDER BY year,month;

-- 3. Find the number of vehicles stolen each day of the week.

SELECT DAYOFWEEK(date_stolen) AS dow, COUNT(vehicle_id) AS num_vehicles FROM stolen_vehicles GROUP BY DAYOFWEEK(date_stolen)

ORDER BY dow;

-- 4. Replace the numeric day of week values with the full name of eac

SELECT DAYOFWEEK(date_stolen) AS dow,

CASE WHEN DAYOFWEEK(date_stolen) = 1 THEN 'Sunday' WHEN DAYOFWEEK(date_stolen) = 2 THEN 'Monday' WHEN DAYOFWEEK(date_stolen) = 3 THEN 'Tuesday' WHEN DAYOFWEEK(date_stolen) = 4 THEN 'Wednesday' WHEN DAYOFWEEK(date_stolen) = 5 THEN 'Thursday' WHEN DAYOFWEEK(date_stolen) = 6 THEN 'Friday' ELSE 'Saturday' END AS day_of_week, COUNT(vehicle_id) AS num_vehicles

FROM stolen_vehicles

GROUP BY DAYOFWEEK(date_stolen), day_of_week ORDER BY dow;

-- 5. Data visualization: Create a bar chart



-- OBJECTIVE 2: IDENTIFY WHICH VEHICLES ARE STOLEN

-- 1. Find the vehicle types that are most often and least often stolen.

SELECT * FROM stolen_vehicles;

SELECT vehicle_type, COUNT(vehicle_id) AS num_vehicles 
FROM stolen_vehicles
GROUP BY vehicle_type
ORDER BY num_vehicles DESC
LIMIT 5;

-- 2. For each vehicle type, find the average age of the cars that are stolen.

SELECT vehicle_type, AVG(YEAR(date_stolen) - model_year) AS avg_age

FROM stolen_vehicles

GROUP BY vehicle_type

ORDER BY avg_age DESC;


-- 3. For each vhicle type, find the percent of vehicles stolen that are luxury verus standard 

SELECT * FROM stolen_vehicles;
SELECT * FROM make_details;

WITH lux_standard AS (SELECT vehicle_type, CASE WHEN make_type = 'Luxury' THEN 1 ELSE 0 END AS luxury, 1 AS all_cars
FROM stolen_vehicles sv LEFT JOIN make_details md 
ON sv.make_id = md.make_id)
SELECT vehicle_type, SUM(luxury) / COUNT(luxury) * 100 AS pct_lux
FROM lux_standard 
GROUP BY vehicle_type 
ORDER BY pct_lux DESC;

-- 4. Create a table where the rows represent the top 10 vehicle types, the columns represent the top 7 vehicle colors (plus 1 column for all other colors) and the value are the number of vehicles stolen.

SELECT * FROM stolen_vehicles;

'Silver', '1272'

'White', '934'

'Black', '589'

'Blue', '512'

'Red', '390'

'Grey', '378'

'Green', '224'
'Other'
SELECT color, COUNT (vehicle_id) AS num_vehicles FROM stolen_vehicles

GROUP BY color

ORDER BY num_vehicles DESC;

SELECT vehicle_type, COUNT(vehicle_id) AS num_vehicles,

SUM(CASE WHEN color = 'Silver' THEN 1 ELSE 0 END) AS silver,

SUM(CASE WHEN color = 'White' THEN 1 ELSE 0 END) AS white,

SUM(CASE WHEN color = 'Black' THEN 1 ELSE 0 END) AS black,

SUM(CASE WHEN color = 'Blue' THEN 1 ELSE 0 END) AS blue,

SUM(CASE WHEN color = 'Red' THEN 1 ELSE 0 END) AS red,

SUM(CASE WHEN color = 'Grey' THEN 1 ELSE 0 END) AS grey,

SUM(CASE WHEN color='Green' THEN 1 ELSE 0 END) AS green,

SUM(CASE WHEN Color IN ('Gold', 'Brown', 'Yellow', 'Orange', 'Purple', 'Cream', 'Pink') THEN 1 ELSE 0 END)	 AS other
FROM stolen_vehicles
GROUP BY vehicle_type
ORDER BY num_vehicles DESC
LIMIT 10;


-- OBJECTIVE 3: IDENTIFY WHERE VEHICLES ARE STOLEN

-- 1. Find the number of vehicles that were stolen in each region.

SELECT * FROM stolen_vehicles;

SELECT * FROM locations;

SELECT region, COUNT(vehicle_id) AS num_vehicles

FROM stolen_vehicles sv LEFT JOIN locations l 
ON sv.location_id = l. location_id 
GROUP BY region;

-- 2. Combine the previous output with the population and density statistics for each region

SELECT l.region, COUNT(sv.vehicle_id) AS num_vehicles, 
l.population, l.density 
FROM stolen_vehicles sv LEFT JOIN locations l
ON sv.location_id = l.location_id
GROUP BY l.region, l.population, l.density
ORDER BY num_vehicles DESC;

-- 3. Do the types of vehicles stolen in the three most dense regions differ from the three

SELECT l.region, COUNT(sv.vehicle_id) AS num_vehicles, 
l.population, l.density 
FROM stolen_vehicles sv LEFT JOIN locations l
ON sv.location_id = l.location_id
GROUP BY l.region, l.population, l.density
ORDER BY l.density DESC;


(SELECT 'High Density',sv.vehicle_type, COUNT(sv.vehicle_id) AS num_vehicles 
FROM stolen_vehicles sv LEFT JOIN locations l 
ON sv.location_id = l.location_id
WHERE l.region IN ('Auckland', 'Nelson', 'Wellington')
GROUP BY sv.vehicle_type
ORDER BY num_vehicles DESC)
UNION
(SELECT 'Low Density',sv.vehicle_type, COUNT(sv.vehicle_id) AS num_vehicles 
FROM stolen_vehicles sv LEFT JOIN locations l 
ON sv.location_id = l. location_id
WHERE l.region IN ('Otago', 'Gisborne', 'Southland')
GROUP BY sv.vehicle_type
ORDER BY num_vehicles DESC);

-- 4. Data visualization: Create a scatter plot

-- 5. Data visualization: Create a map
select l.region, l.country, l.population, l.density, COUNT(vehicle_id) AS theft_count

from stolen_vehicles as s

join locations as l

on s.location_id = l.location_id

group by l.region, l.country, l.population, l.density

order by l.density desc
