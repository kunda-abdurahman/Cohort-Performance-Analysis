-- 06_dropout_timing
--
-- question:
-- is there a pattern in attendance before students dropout?
--
-- we compare attendance in the final 30 daysbefore a students 
-- last recorded attendance with their attendance earlier in the course

WITH last_attendance As(
		SELECT a.enrolment_id,
        MAX(a.session_date) AS last_attendance_date
FROM attendance a
JOIN enrolments en 
		ON en.enrolment_id = a.enrolment_id
WHERE en.status = 'Dropped'
GROUP BY enrolment_id
)
SELECT 
	CASE
        WHEN DATEDIFF(la.last_attendance_date, a.session_date)<= 30
        THEN 'Last 30 day'
        ELSE 'Earlier'
        END Period,
        ROUND(100 * SUM(a.status IN('Present','Late'))/ COUNT(*),1) AS attendance_rate,
        COUNT(*) AS sessions
FROM attendance a 
JOIN last_attendance la
	ON a.enrolment_id = la.enrolment_id
WHERE a.status <>'Not Recorded'
	AND a.session_date <= la.last_attendance_date
GROUP BY Period;

-- resuits:
-- Attendance drops sharply before students leave. 
-- Attendance is 53.8% earlier in the course but falls. 
-- 16.6% in the final 30 days before the last recorded attendance. 
-- this show that the declineing attendance is a clear pattern 
-- among the the students who eventually drop out. 

