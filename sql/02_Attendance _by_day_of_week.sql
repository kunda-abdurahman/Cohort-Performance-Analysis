-- 02_attendance _by_day_of_week
-- purpose: find which day of the week has the lowest 
-- attendance,across all courses and cohorts
SELECT 
		DAYNAME(session_date) AS day_of_week,
		SUM(status IN ('present','late'))/ COUNT(*) AS attendance_rate
 FROM attendance
 WHERE status != 'NOT Recorded'
 GROUP BY DAYNAME(session_date) 
 ORDER BY attendance_rate ASC;
 -- the day the week with lowest attendance rate of 53.5% is friday
 
 -- Attendance rate by day of the ,by cohort
 WITH cohort_attendance As(
SELECT co.cohort_label,DAYNAME(a.session_date) AS day_of_week,
		SUM(a.status IN ('present','late'))/ COUNT(*) AS attendance_rate
FROM attendance a  
JOIN enrolments en 
ON a.enrolment_id = en.enrolment_id
JOIN cohorts co 
ON en.cohort_id = co.cohort_id
 WHERE a.status != 'NOT Recorded'
 GROUP BY DAYNAME(session_date),co.cohort_label
 )
SELECT cohort_label, day_of_week, attendance_rate,
	RANK() OVER(PARTITION BY cohort_label ORDER BY  attendance_rate )rank_
    FROM cohort_attendance;
    -- friday has the weakest attendance rate accross all cohorts. 
    
    
