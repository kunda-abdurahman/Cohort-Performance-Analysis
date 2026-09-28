-- 08_course_cohort_ranking
-- purpose :rank every course /cohort combination that has run in the program
-- by attendance rat ,alongside its complection rate to spot which specific
-- offering are underperforming and whether any course repeats near the -- bottom across multiple cohorts. 


WITH att As(
SELECT
		e.course_id,
		e.cohort_id,
		c.course_name,
	ROUND( 100.0 * SUM(a.status IN ('Present', 'Late')) 
	/ COUNT(*), 1 ) AS attendance_rate

FROM enrolments e 
JOIN courses c USING(course_id)
JOIN attendance a USING(enrolment_id)
WHERE a.status != 'Not Recorded'
GROUP BY e.course_id, e.cohort_id, course_name
),

Comp AS(
SELECT 
		course_id,
		cohort_id,
		c.course_name,
	ROUND( 100.0 * SUM(e.status = 'Completed') / COUNT(*), 1 ) AS completion_rate,

	COUNT(*) AS enrolled

FROM enrolments e
JOIN courses c USING(course_id)
GROUP BY course_id, cohort_id, course_name
)

SELECT 
		att.course_name,
		att.cohort_id,
        att.attendance_rate,
		comp.completion_rate,
		comp.enrolled
FROM att 
JOIN comp USING(course_id,cohort_id)
ORDER BY att.attendance_rate ASC;

-- RESUIT: Data Analysis appears twice in the weakest five (cohort 5 $ 4), suugesting a course level pattern ratherthan one bad cohort
-- completion rates for cohorts 4 and 5 read low across almost every row 
-- here because of the unknown-status data quality issues documented in 01_data_quality_checks not because those cohoryts geniunely performed worse 
