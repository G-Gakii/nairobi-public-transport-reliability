USE nairobi_transport;


-- view all records and columns in the route table
SELECT  *
FROM routes_worksheet;

-- view all records and columns in the trip table
SELECT *
FROM trips_worksheet;


-- view all records and columns in the vehicle table
SELECT *
FROM vehicles_worksheet;

-- calculate average delay for each route and rank from highest average delay to lowest

WITH trip_route_cte AS (
SELECT tw.route_id,rw.route_name , tw.delay_minutes ,rw.distance_km 
FROM trips_worksheet tw
LEFT JOIN routes_worksheet rw
ON tw.route_id  =rw.route_id
)
SELECT route_name,MAX(distance_km) as distance_km , ROUND(AVG(delay_minutes),2) avg_delay_minute
FROM trip_route_cte
GROUP by route_name 
ORDER BY avg_delay_minute DESC


 ;
 
 -- calculate average delay for each vehicle type and rank from highest to lowest delay
 SELECT vw.vehicle_type ,MAX(vw.capacity ) capacity,ROUND(AVG(tw.delay_minutes),2) avg_delay_time
 FROM trips_worksheet tw 
 LEFT JOIN vehicles_worksheet vw 
 ON tw.vehicle_id  = vw.vehicle_id
 WHERE vw.vehicle_type  IS NOT NULL
 GROUP BY vw.vehicle_type
 ORDER BY avg_delay_time DESC ;
 
 
 -- calculate average delay for each sacco and rank from highest to lowest delay
 SELECT vw.sacco_operator,SUM(vw.vehicle_id ) total_vehicles,ROUND(AVG(tw.delay_minutes),2) avg_delay_time
 FROM trips_worksheet tw 
 LEFT JOIN vehicles_worksheet vw 
 ON tw.vehicle_id  = vw.vehicle_id
 WHERE vw.sacco_operator  IS NOT NULL
 AND TRIM(vw.sacco_operator ) !=""
 GROUP BY vw.sacco_operator 
 ORDER BY avg_delay_time DESC ;
 
 
 -- calculate average delay for each route based on day  and rank from highest average delay to lowest

WITH trip_route_cte AS (
SELECT tw.route_id,rw.route_name ,tw.day_of_week , tw.delay_minutes ,rw.distance_km 
FROM trips_worksheet tw
LEFT JOIN routes_worksheet rw
ON tw.route_id  =rw.route_id
)
SELECT route_name,day_of_week , ROUND(AVG(delay_minutes),2) avg_delay_minute
FROM trip_route_cte
GROUP by route_name ,day_of_week
ORDER BY route_name ,avg_delay_minute DESC

 -- calculate average delay for each sacco based on day and rank from highest to lowest delay
 SELECT vw.sacco_operator,tw.day_of_week ,ROUND(AVG(tw.delay_minutes),2) avg_delay_time
 FROM trips_worksheet tw 
 LEFT JOIN vehicles_worksheet vw 
 ON tw.vehicle_id  = vw.vehicle_id
 WHERE vw.sacco_operator  IS NOT NULL
 AND TRIM(vw.sacco_operator ) !=""
 GROUP BY vw.sacco_operator ,tw.day_of_week 
 ORDER BY vw.sacco_operator,avg_delay_time DESC ;
 
 
 -- calculate average delay based on weather
 SELECT weather,ROUND(AVG(delay_minutes),2)
 FROM trips_worksheet 
 WHERE weather IS NOT NULL
 AND TRIM(weather) != ""
 GROUP BY weather ;
 
 -- calculate average delay and average rating of vehicle type
 SELECT vw.vehicle_type ,ROUND(AVG(tw.delay_minutes),2) avg_delay ,ROUND(AVG(tw.passenger_rating ),2) avg_rating
 FROM trips_worksheet tw
 LEFT JOIN vehicles_worksheet vw
 ON tw.vehicle_id  =vw.vehicle_id 
  WHERE vw.vehicle_type IS NOT NULL
 GROUP BY vw.vehicle_type 
 ORDER BY avg_rating DESC
 ;
 
 -- calculate average delay and average rating of sacco type
 SELECT vw.sacco_operator  ,ROUND(AVG(tw.delay_minutes),2) avg_delay ,ROUND(AVG(tw.passenger_rating ),2) avg_rating
 FROM trips_worksheet tw
 LEFT JOIN vehicles_worksheet vw
 ON tw.vehicle_id  =vw.vehicle_id 
  WHERE vw.sacco_operator  IS NOT NULL
  AND TRIM(vw.sacco_operator) !=""
 GROUP BY vw.sacco_operator 
 ORDER BY avg_rating DESC
 ;
 
 -- calculate average delay and average rating of route type
 SELECT rw.route_name  ,ROUND(AVG(tw.delay_minutes),2) avg_delay ,ROUND(AVG(tw.passenger_rating ),2) avg_rating
 FROM trips_worksheet tw
 LEFT JOIN routes_worksheet rw 
 ON tw.route_id =rw.route_id 
  WHERE rw.route_name   IS NOT NULL
  AND TRIM(rw.route_name) !=""
 GROUP BY rw.route_name
 ORDER BY avg_rating DESC
 ;

 
 
 