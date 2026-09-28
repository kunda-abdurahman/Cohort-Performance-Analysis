-- 05_attendance _ comparison

-- question:
-- does the number of training days per week affect attendance 

-- cohorts 1 to 5 used a three-day week (MWF), while cohorts 6 used a five-day week (MTWTF). 

SELECT 
		co.schedule,
        ROUND( 100 * SUM(a.status IN('Present','Late'))/ COUNT(*),1) AS attendance_rate,
		COUNT(*) AS sessions
FROM attendance a
JOIN enrolments en 
	ON a.enrolment_id = en.enrolment_id
JOIN cohorts co 
	ON en.cohort_id = co.cohort_id	
	
WHERE a.status <>'Not Recorded'
GROUP BY co.schedule;

-- result:
-- attendance is almost the same under both schedules:
-- 58.0% for the five days of the week and 58.9% for the three day of the week.
-- the difference is less than one percentage point,suggesting 
-- that the  change in weekly schedule had little difference in 
-- attendsance based on the available data.   