--What are the three longest trips on rainy days?--
WITH 
	city 
AS 
	(SELECT
		DATE(date)
	FROM
	 	weather
	 WHERE
	 	events = 'Rain'
	GROUP BY 1)
SELECT
	c.date,
	DATE(t.start_date),
	t.trip_id,
	t.start_station,
	t.end_station,
	t.duration
FROM
	trips t
JOIN
	city c	
ON
	 DATE(t.start_date) = DATE(c.date) 
ORDER BY duration DESC
LIMIT 3;

--Which station is full most often?--

SELECT
	stations.station_id,
	stations.name,
	COUNT(stations.name) as NO_OF_TIMES_FULL
FROM
	stations
JOIN
	status
ON
	stations.station_id = status.station_id
WHERE 
	status.docks_available = 0
GROUP BY stations.name,stations.station_id
ORDER BY NO_OF_TIMES_FULL DESC;

--Return a list of stations with a count of number of trips starting at that station but ordered by dock count.
SELECT
	t.start_station,
	COUNT(t.start_station) as trips_from_station,
	s.dockcount
FROM
	trips t
JOIN
	stations s
ON
	t.start_station = s.name
GROUP BY t.start_station, s.dockcount
ORDER BY s.dockcount DESC;

--(Challenge) What's the length of the longest trip for each day it rains anywhere?--
WITH 
	city 
AS 
	(SELECT
		DATE(date)
	FROM
	 	weather
	 WHERE
	 	events = 'Rain'
	GROUP BY 1),
	trip_city
AS
	(SELECT
		c.date,
		DATE(t.start_date) as t_date,
		t.trip_id,
		t.start_station,
		t.end_station,
		t.duration
	FROM
		trips t
	JOIN
		city c	
	ON
		 DATE(t.start_date) = DATE(c.date)
	ORDER BY duration DESC)
SELECT 
	t_date,
	max(duration)
FROM trip_city
GROUP BY 1;

