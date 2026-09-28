-- 03_ attendance_by_month

-- question :
-- does attendance decline as the courses progress
SELECT 
	DATE_FORMAT(session_date,'%Y-%m') AS month,
    ROUND(100* SUM(status IN('Present','Late')
    )/ COUNT(*), 1
    ) AS attendance_rate,
    COUNT(*) AS total_sessions
FROM attendance
WHERE status <> 'Not Recorded'
GROUP BY DATE_FORMAT(session_date,'%Y-%m');

