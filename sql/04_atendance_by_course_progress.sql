-- 04_attendance_by_course_progress

-- question:
-- at what point in a course does attendance start to fall
--
-- courses have different lengths, so we divide each course 
-- into10 parts and compare attendance across those parts
--
-- 0 = beginning ,5 = middle, 9 = end

 WITH course_dates AS(
		SELECT en.course_id, en.cohort_id,
		MIN(a.session_date) AS first_date,
		MAX(a.session_date) AS last_date
 FROM enrolments en 
 JOIN attendance a 
		ON a.enrolment_id = en.enrolment_id
 GROUP BY en.course_id,en.cohort_id
 ),
 course_progress As(
 SELECT a.status,
		10 * DATEDIFF(a.session_date, cd.first_date)/
        DATEDIFF(cd.last_date, cd.first_date) AS decile
FROM attendance a
JOIN enrolments en
		ON a.enrolment_id = en.enrolment_id
JOIN course_dates cd
		ON en.course_id= cd.course_id AND en.cohort_id = cd.cohort_id
WHERE a.status <> 'Not Recorded'
)
SELECT 
		ROUND(decile) AS decile,
        ROUND( 100 * SUM(status IN('Present','Late'))/ COUNT(*),1) AS attendance_rate,
        COUNT(*) AS sessions
FROM course_progress
GROUP BY ROUND(decile) 
ORDER BY  decile;
 
 
 