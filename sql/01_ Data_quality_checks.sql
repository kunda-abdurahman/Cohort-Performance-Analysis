-- 01_data_quality_checks
-- purpose :check the underlying records before trusting any analysis built on it
USE arel;

-- Attendance data quality
-- Enrollments per status - unknown records
 SELECT status,
        COUNT(*) AS total_enrollments
 FROM enrolments
 GROUP BY status;
 -- 178/565 (31.5%) of enrolments have an unknown status. 
 
 -- Attendance by status - recorded
 SELECT status,
        COUNT(*) As total_attendance
FROM attendance
WHERE status = 'NOT Recorded'
GROUP BY status;
-- 187/58944 (3.2%) of attendance records have a status of 'NOT Recorded'

-- missing contact information for students
SELECT 
		SUM(email ='') AS missing_email,
        SUM(phone ='') AS missing_phone
FROM students;
-- 195/260 of students have a missing  contact information (emeils and phone)

-- Decison made from these results:
-- recorded rows with 'NOT RECORDED' should be excluded from attendance rate. 
-- 'UNKNOWN' enrolment status should be kept as its own column/category


