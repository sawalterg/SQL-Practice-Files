SELECT
 department, sum(salary)
FROM
 staff
WHERE
 department LIKE 'B%yj'
GROUP BY
 department
 
 
 SELECT DISTINCT
 department
FROM 
 staff
 
 
 
 
 
SELECT DISTINCT
 UPPER(department)
FROM 
 staff
 
 
 
 
SELECT
 job_title || '-' || department title_dept # concatenates || and title_dept is new name of the column
FROM 
 staff
 

 
 
SELECT
 trim('  Software Engineer  '  )
 
SELECT
 length(trim(' Software Engineer   '))
 

 SELECT
 job_title (job_title like '%Assistant%') is_asst  # The % means any character before or after. the like in paranthesis is boolean
 
FROM 
 staff
 
 
 

SELECT
 SUBSTRING('abcdefg' FROM 1 FOR 3) test_string # Take the first three letters
 
 
 
 
SELECT
 SUBTSTRING(job_title FROM 10)  # Take all characters starting from 10
FROM
 staff
WHERE 
 job_title LIKE 'Assistant%'
 
 
 
 
 
 
SELECT
 OVERLAY(job_title PLACING 'Asst.' FROM 1 FOR 9) # Replacing the first 10 characters with Asst
FROM
 staff
WHERE 
 job_title LIKE 'Assistant%'
 
 
 
SELECT
 job_title
FROM 
 staff
WHERE
 job_title LIKE '%Assistant%'
 
 
 
SELECT
 job_title
FROM 
 staff
WHERE 
 job_title SIMILAR TO '%Assistant%(III|IV)' # Regular expressions for having these as yoru ends, note the OR pipe
 
 
SELECT
 job_title
FROM 
 staff
WHERE 
 job_title SIMILAR TO '%Assistant I_' # Any following characters for two letters
 
 
 
SELECT
 job_title
FROM 
 staff
WHERE 
 job_title SIMILAR TO '[EPS]%' # ANY JOB TITLE STARTS WITH E, P or S and then is followed by any character
 
 
 SELECT 
 department, avg(salary) # Whenever you are using an aggregate function, always be sure to use a GROUP BY statement
FROM
 staff
GROUP BY
 department

 
 
 
SELECT 
 department, avg(salary), trunc(avg(salary)), ceil(avg(salary)), round(avg(salary), 2)  # tunc rounds down, ceil returns the next largest in size, round just rounds up. Extra parameter for number of decimal places
FROM
 staff
GROUP BY
 department
 
 
 
 
### FILTERING AND JOINS and SUBQUERIES


SELECT
 s1.last_name,
 s1.salary,
 s1.department   
FROM
 staff s1  # Alias which tells the query which table to pull from
 
 
 
 
 # Subquery in SELECT clause
 
 SELECT
 s1.last_name,
 s1.salary,
 s1.department,
 (SELECT round(avg(salary)) FROM STAFF s2 WHERE s2.department = s1.department) # This adds another column which shows the average for each profession
FROM
 staff s1
 
 
# Subquery in the FROM clause
SELECT
 s1.department,
 round(avg(s1.salary))
FROM
 (SELECT
   department,
   salary
  FROM 
   staff
  WHERE
   salary > 100000) s1
GROUP BY
 s1.department
 
 
 # Taking the average salary from those who make over 100000 (executives). We use a subquery where we usually use a table name
 
 
 
 
 # SUBQUERY IN A WHERE CLAUSE
 SELECT
 s1.department, s1.last_name, s1.salary
FROM
 staff s1
WHERE
 s1.salary = (SELECT
		max(s2.salary)
		FROM staff s2)
		
		
# JOINING TABLES

SELECT
 s.last_name,
 s.department,
 cd.company_division
FROM 
 staff s
JOIN
 company_divisions cd
ON  # By default an inner join
 s.department = cd.department
 
 
 
 SELECT
 s.last_name,
 s.department,
 cd.company_division
FROM 
 staff s
 LEFT JOIN  # take all the lines in the staff table even if there isn't a corresponding row in the company divisions table
 company_divisions cd
ON
 s.department = cd.department

# Find out where the rows in the staff table have no corresponding divisions
 SELECT
 s.last_name,
 s.department,
 cd.company_division
FROM 
 staff s
LEFT JOIN
 company_divisions cd
ON
 s.department = cd.department
WHERE
 cd.company_division IS NULL
 

 
# CREATING A VIEW

 
 
CREATE VIEW staff_div_reg AS 
SELECT
 s.*, cd.company_division, cr.company_regions
FROM 
 staff s
LEFT  JOIN
 company_divisions cd
ON
 s.department = cd.department
LEFT JOIN
 company_regions cr
ON 
 s.region_id = cr.region_id
 
# Check new view works by counting the rows in the view 
 
SELECT
 count(*)
FROM 
 staff_div_reg
 
 
 
 
 # Ordering by and totaling with our view
SELECT
 company_division,
 company_regions,
 gender,
 count(*)
FROM
 staff_div_reg
GROUP BY
GROUPING SETS (company_division,company_regions, gender)
ORDER BY 
 company_regions, company_division, gender
 
 
 
 
 
 # Create new view (or replace if it already has a name)
 
 
 
 CREATE OR REPLACE VIEW staff_div_reg_country AS
 SELECT
  s.*, cd.company_division, cr.company_regions, cr.country
   FROM
    staff s
   LEFT JOIN
    company_divisions cd
   ON
    s.department = cd.department
   LEFT JOIN
    company_regions cr
   ON
    s.region_id = cr.region_id
	
	
	
SELECT
 company_regions, country, count(*)
FROM
 staff_div_reg_country
GROUP BY
 ROLLUP(country, company_regions)
ORDER BY
 country, company_regions
 
  # USE a roll up for 
  
  
  
## CUBE FUNCTION
SELECT
 company_division, company_regions, count(*)
FROM
 staff_div_reg_country
GROUP BY
 CUBE(company_division, company_regions)

 # All combos
 
 
 
 
 
 # WORKING WITH TOP RESULTS ONLY
 SELECT
 last_name, job_title, salary
FROM
 staff
ORDER BY
 salary DESC
FETCH FIRST 
 10 ROWS ONLY # FETCH FIRST SORTS THROUGH DATA BEFORE DECIDING COLUMNS TO RETURN. DIFERENT THAN LIMIT

 
 
SELECT
 company_division, count(*)
FROM
 staff_div_reg_country
GROUP BY
 company_division
ORDER BY
 count(*) DESC
FETCH FIRST 
 5 ROWS ONLY
 
 
 
 
 
 
# WINDOW FUCNTIONS - PARTITION BY


SELECT
 department,
 last_name,
 salary,
 avg(salary) OVER (PARTITION BY department) # This will make a fourth column that just shows average salary by department
FROM 
 staff
 
 
SELECT
 company_regions,
 last_name,
 salary,
 min(salary) OVER (PARTITION BY company_regions) # Gets minimum salary by region
FROM 
 staff_div_reg
 
 
 
SELECT 
 department,
 last_name,
 salary,
 first_value(salary) OVER (PARTITION BY department ORDER BY salary DESC) # GET THE HIGHEST SALARY
FROM
 staff
 
 
 
 
 
# RANK

SELECT
 department,
 last_name,
 salary,
 rank() OVER (PARTITION BY department ORDER BY salary DESC) # Where each salary falls in the department
FROM
 staff
 
 
# LAG

SELECT
 department,
 last_name,
 salary,
 lag(salary) OVER (PARTITION BY department ORDER BY salary DESC) # Returns the row before the currently processes row -- within each department RELATIVE TO CURRENT ROW
FROM
 staff
 
 
 
# LEAD OPPOSITE OF LAG
SELECT
 department,
 last_name,
 salary,
 lead(salary) OVER (PARTITION BY department ORDER BY salary DESC)
FROM
 staff
 
 
 
# ntile (ordered groups like quartiles)


SELECT
 department,
 last_name,
 salary,
 ntile(4) OVER (PARTITION BY department ORDER BY salary DESC) # will create bucket for quartiles for each salary by department
FROM
 staff