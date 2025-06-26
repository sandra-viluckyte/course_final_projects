USE hrcompany;

-- 1. Select all employees: Write a SQL query that will retrieve
-- all employee records from the Employees table.

SELECT *
FROM employees;

-- 2. Select certain columns: show all names and surnames from Employees table.

SELECT FirstName,
	LastName
FROM employees;

-- 3. Filter based on departments: get a list of employees who work in HR.

SELECT FirstName,
	LastName,
    DepartmentName
FROM employees
LEFT JOIN departments
	ON employees.DepartmentID = departments.DepartmentID
WHERE DepartmentName = "HR";

-- 4. Sort the employees: get a list of employees, sorted by
-- their hire date in ascending order.

SELECT *
FROM employees
ORDER BY HireDate ASC;

-- 5. Count the employees: find the total number of employees in the company.

SELECT COUNT(*)
FROM employees;

-- 6. Combine employees with departments: output a general list of employees,
-- indicating the department they work in next to each employee. (TIP: it would be best
-- to provide at least the employees' first and last names, and the department names
-- but you can output more information, it is not suitable to provide
-- only the employee ID)

SELECT EmployeeID,
	FirstName,
	LastName,
    DepartmentName
FROM employees
LEFT JOIN departments
	ON employees.DepartmentID = departments.DepartmentID;

-- 7. Calculate the average salary: find the average
-- salary in the company among all employees. (TIP: you should get one number
-- as the answer, which clearly shows the total average of all employees
-- salaries) (TIP2: note that each employee has several
-- salaries, if you can extract the latest
-- by date for each employee and calculate the average only from that, that would be great, but if you can't get
-- you should at least take the total average of the table)

SELECT ROUND(AVG(SalaryAmount), 2) AS average_salary
FROM employees
LEFT JOIN salaries
	ON employees.EmployeeID = salaries.EmployeeID
WHERE SalaryStartDate IN (SELECT MAX(SalaryStartDate)
FROM employees
LEFT JOIN salaries
	ON employees.EmployeeID = salaries.EmployeeID
GROUP BY employees.EmployeeID);
    
-- More simple version:
    
SELECT ROUND(AVG(SalaryAmount), 2) AS average_salary
FROM employees
LEFT JOIN salaries
	ON employees.EmployeeID = salaries.EmployeeID;
    

-- 8. Filter and count: find how many employees work in the IT department.

SELECT COUNT(*)
FROM employees
LEFT JOIN departments
	ON employees.DepartmentID = departments.DepartmentID
WHERE DepartmentName = "IT";

-- 9. Extract unique values: Get a list of unique job positions
-- from the jobpositions table. (TIP: jobpositions are job postings that
-- are not related to actual employees, but that doesn't mean there is no data in this
-- table, there is, you just don't need to join it to anything) (TIP2: You need
-- to get a list of titles only)

SELECT DISTINCT PositionTitle
FROM jobpositions;

-- 10. Select by date range: get employees who were hired between 2020-02-01 and 2020-11-01. (TIP: find the specified employees and
-- output all or selected information about them)

SELECT *
FROM employees
WHERE HireDate >= "2020-02-01" AND HireDate <= "2020-11-01";

-- 11. Employee Age: Get the age of each employee based on when
-- they were born. (TIP: output at least the employees' first and last names, for
-- checking it would be good to also include the year of birth and the calculated age column)

SELECT FirstName,
	LastName,
	DateOfBirth,
	ROUND(DATEDIFF(CURDATE(), DateOfBirth) / 365, 1) AS Age
FROM employees;

-- 12. Employee Email Address List: Get a list of all employee email
-- addresses in alphabetical order. (TIP: do not output anything that is not requested by the task,
-- i.e. only email addresses are needed and nothing else)

SELECT Email
FROM employees
ORDER BY Email ASC;

-- 13. Number of employees by department: find how many employees are working in each department. 
-- (TIP: output only department names and the number of employees working in each department)

SELECT DepartmentName, COUNT(*)
FROM employees
LEFT JOIN departments
	ON employees.DepartmentID = departments.DepartmentID
GROUP BY DepartmentName;

-- 14. Hardworking employee: select all employees who have 3 or
-- more skills. (TIP: you need to output not only the relationship between the data,
-- but also at least the names and surnames of the employees themselves, you can clearly provide
-- more information about such employees who have so many skills)

SELECT FirstName,
	LastName,
    COUNT(SkillName) AS skill_count
FROM employees
LEFT JOIN employeeskills
	ON employees.EmployeeID = employeeskills.EmployeeID
LEFT JOIN skills
	ON skills.SkillID = employeeskills.SkillID
GROUP BY FirstName, LastName
HAVING COUNT(SkillName) >= 3;


-- 15. Average cost of benefits: Calculate the average cost of benefits (benefits table) for employees.
--  (TIP: if the company has a benefits package, just find the average cost of each benefit, you don't need to connect with any employees or figure out the cost of employees who have opted for these benefits)

SELECT ROUND(AVG(Cost), 2) AS average_cost
FROM benefits;


-- 16. Youngest and oldest employees: find the youngest and oldest
-- employees in the company.

SELECT *,
	DATEDIFF(CURDATE(), DateOfBirth) / 365  AS Age
FROM employees
ORDER BY DateOfBirth DESC
LIMIT 1;

SELECT *,
	DATEDIFF(CURDATE(), DateOfBirth) / 365  AS Age
FROM employees
ORDER BY DateOfBirth ASC
LIMIT 1;


-- 17. Department with the most employees: find which department has the most employees.
--  (TIP: find which department has the most employees and output information about this department, such as its name, how many employees it has, etc.)

SELECT DepartmentName, COUNT(*)
FROM employees
LEFT JOIN departments
	ON employees.DepartmentID = departments.DepartmentID
GROUP BY DepartmentName
ORDER BY COUNT(*) DESC
LIMIT 1;

-- 18. Text search: find all employees with the word "excellent"
-- in their performance reviews (performancereviews table).

SELECT *
FROM employees
LEFT JOIN performancereviews
	ON employees.EmployeeID = performancereviews.EmployeeID
WHERE ReviewText LIKE "%excellent%";

-- 19. Employee Phone Numbers: Print all employee IDs with their
-- phone numbers. (TIP: only print the ID and their phone numbers here,
-- no other information is needed)

SELECT EmployeeID, 
	Phone
FROM employees;

-- 20. Employee hiring month: find which month had the most employees hired.
-- (TIP: you only need to output the month number or name that matched the given condition, 
-- and how many employees were hired that month, do not output the entire list and do not search for specific employees)

SELECT MONTHNAME(HireDate) AS hire_month,
    COUNT(MONTH(HireDate)) AS number_of_empployees
FROM employees
GROUP BY MONTHNAME(HireDate)
ORDER BY COUNT(MONTH(HireDate)) DESC
LIMIT 1;

-- 21. Employee skills: output all employees who have the skill
-- "Communication". (TIP: if you can, output the information of these employees,
-- such as first or last name, but if not, at least the ID of these employees)

SELECT *
FROM employees
LEFT JOIN employeeskills
	ON employees.EmployeeID = employeeskills.EmployeeID
LEFT JOIN skills
	ON employeeskills.skillID = skills.SkillID
WHERE SkillName LIKE "%communication%";

-- 22. Sub-queries: find which employee in the company earns the most
-- and display all their information.

SELECT *
FROM employees
LEFT JOIN salaries
	ON employees.EmployeeID = salaries.EmployeeID
WHERE SalaryAmount = (SELECT MAX(SalaryAmount) FROM salaries);


-- 23. Grouping and aggregation: Calculate the total costs of the company's benefits (benefits
-- table). (TIP: calculate the total amount the company spends on all
-- additional benefits, you should get one and the same total number, taking into account that some
-- employees have more benefits, others less)

SELECT SUM(expense)
FROM (SELECT Count(*),
	Cost,
    Cost * Count(*) AS expense
FROM employees
LEFT JOIN employeebenefits
	ON employees.EmployeeID = employeebenefits.EmployeeID
LEFT JOIN benefits
	ON employeebenefits.BenefitID = benefits.BenefitID
    GROUP BY Cost) AS full_expense;
    

-- 24. Show all available skills. (TIP: you only need to show the skill names,
-- no need to connect to employees)

SELECT SkillName
FROM skills;

-- 25. Leave Requests: Output a list of leave requests (leaverequests)
-- that are awaiting approval.

SELECT *
FROM leaverequests
WHERE LeaveType = "Vacation" AND Status = "Pending";

-- 26. Job Feedback: Output employees who have
-- received 5 points in their job feedback.

SELECT FirstName,
	LastName,
    DateOfBirth,
    ReviewText,
    Rating
FROM employees
LEFT JOIN performancereviews
	ON employees.EmployeeID = performancereviews.EmployeeID
WHERE Rating = 5;

-- 27. Benefits Enrollment: Retrieve all employees who are
-- enrolled in the "Health Insurance" benefits.

SELECT *
FROM employees
LEFT JOIN employeebenefits
	ON employees.EmployeeID = employeebenefits.EmployeeID
LEFT JOIN benefits
	ON employeebenefits.BenefitID = benefits.BenefitID
WHERE BenefitName = "Health Insurance";

-- 28. Salary increase: Show what the salaries of employees,
-- working in the "Finance" department, would look like if their salaries were increased by 10%.
    
    SELECT employees.EmployeeID,
	FirstName,
	LastName,
    SalaryAmount,
    SalaryStartDate,
    ROUND((SalaryAmount * 110) / 100, 0) AS increased_salary
FROM employees
LEFT JOIN departments
	ON employees.DepartmentID = departments.DepartmentID
LEFT JOIN salaries
	ON salaries.EmployeeID = employees.EmployeeID
WHERE DepartmentName = "Finance" AND SalaryStartDate IN (SELECT MAX(SalaryStartDate) FROM employees LEFT JOIN departments
	ON employees.DepartmentID = departments.DepartmentID
LEFT JOIN salaries
	ON salaries.EmployeeID = employees.EmployeeID
    WHERE DepartmentName = "Finance"
    GROUP BY employees.EmployeeID);

-- 29. Most Effective Employees: Find the 5 employees who have the highest
-- performance rating (performance table).

SELECT FirstName,
	LastName,
    DateOfBirth,
    AVG(Rating) AS average_rating
FROM employees
LEFT JOIN performancereviews
	ON employees.EmployeeID = performancereviews.EmployeeID
GROUP BY FirstName, LastName, DateOfBirth
ORDER BY AVG(Rating) DESC
LIMIT 5;

-- 30. Leave Request History: Get the complete leave request history
-- (leaverequests table) for the employee with id 1. (TIP: output all
-- information about such requests for this employee, no need for the employee himself).

SELECT *
FROM leaverequests
WHERE EmployeeID = 1 AND LeaveType = "Vacation";

-- 31. Salary Range Analysis: Determine the salary range (minimum
-- and maximum) for each job position. (TIP: do not confuse with jobspositions because
-- there is a job board and it is not related to employees) (TIP2: you need to output
-- the name of the department, what is the minimum salary in it, and what is the maximum salary)
-- (TIP3: it would be best if you took the latest dates, not just any dates).

SELECT DepartmentName, 
	MIN(SalaryAmount) AS min_salary, 
    MAX(SalaryAmount) AS max_salary
FROM employees
LEFT JOIN departments
	ON employees.DepartmentID = departments.DepartmentID
LEFT JOIN salaries
	ON salaries.EmployeeID = employees.EmployeeID
WHERE SalaryStartDate IN (SELECT MAX(SalaryStartDate)
FROM employees
LEFT JOIN departments
	ON employees.DepartmentID = departments.DepartmentID
LEFT JOIN salaries
	ON salaries.EmployeeID = employees.EmployeeID
    GROUP BY salaries.EmployeeID)
GROUP BY DepartmentName;


-- 32. Performance Review History: Get the full history of performance reviews
-- (performancereviews table) for employee with id 2. (TIP: output all
-- information for such reviews, no need for the employee's own information).

SELECT *
FROM performancereviews
WHERE EmployeeID = 2;

-- 33. Cost of benefits per employee: Calculate the total cost of benefits per employee (benefits table). 
-- (TIP: You should get one number as your final answer, this number is the total average of how much is spent on average 
-- on each employee in terms of benefits).

SELECT ROUND(AVG(Cost), 2) AS average_cost
FROM employees
LEFT JOIN employeebenefits
	ON employees.EmployeeID = employeebenefits.EmployeeID
LEFT JOIN benefits
	ON employeebenefits.BenefitID = benefits.BenefitID;
    

-- 34. Best skills by department: List the most common
-- skills in each department. (TIP: you need to display the department names, and next to them
-- what skill was used most often in it, and if that doesn't work, at least
-- display each section, its skill, and how many times it occurs in it, and sort them so that
-- they are at least visible by frequency)

SELECT DepartmentName, SkillName, COUNT(SkillName) AS skill_count
FROM employees
LEFT JOIN employeeskills
	ON employees.EmployeeID = employeeskills.EmployeeID
LEFT JOIN skills
	ON employeeskills.SkillID = skills.SkillID
LEFT JOIN departments
	ON employees.DepartmentID = departments.DepartmentID
GROUP BY DepartmentName, SkillName
ORDER BY COUNT(SkillName) DESC;

-- 35. Salary growth: Calculate the percentage increase in salary for each
-- employee compared to last year. (TIP: employee information should be visible,
-- e.g. first and last names, as well as the percentage increase in salary, or if there was no increase, write
-- 0 percent).


SELECT salaries.EmployeeID, FirstName, LastName, IF(MAX(SalaryAmount) = MIN(SalaryAmount), 0, (MAX(SalaryAmount) - MIN(SalaryAmount)) / MIN(SalaryAmount) * 100) AS salary_increase_percents
FROM employees
LEFT JOIN salaries
	ON employees.EmployeeID = salaries.EmployeeID
GROUP BY salaries.EmployeeID, FirstName, LastName;


-- 36. Employee retention: Find employees who have been with the company for more than
-- 5 years and have not received a salary increase during that time. (TIP: output
-- information for such employees, not just the id).

SELECT *
FROM employees
LEFT JOIN salaries
	ON employees.EmployeeID = salaries.EmployeeID
WHERE YEAR(CURDATE()) - YEAR(HireDate) > 5 AND salaries.EmployeeID IN (SELECT IF(MAX(SalaryAmount) - MIN(SalaryAmount) = 0, salaries.EmployeeID, 0)
FROM employees LEFT JOIN salaries 
ON employees.EmployeeID = salaries.EmployeeID
WHERE YEAR(CURDATE()) - YEAR(HireDate) > 5
GROUP BY salaries.EmployeeID);


-- 37. Employee Salary Analysis: Find each employee's compensation
-- (salary (salaries table) + benefits (benefits table))
-- and sort employees by total salary in descending order. (TIP: should
-- show both employee information and their salary and the total value of their benefits)

SELECT employees.EmployeeID, FirstName, LastName, SalaryAmount,
	SUM(Cost) AS total_benefits_amount
FROM employees
LEFT JOIN salaries
	ON employees.EmployeeID = salaries.EmployeeID
LEFT JOIN employeebenefits
	ON employeebenefits.EmployeeID = employees.EmployeeID
LEFT JOIN benefits
	ON employeebenefits.BenefitID = benefits.BenefitID
WHERE SalaryStartDate IN (SELECT MAX(SalaryStartDate) 
FROM employees
LEFT JOIN salaries
	ON employees.EmployeeID = salaries.EmployeeID
LEFT JOIN employeebenefits
	ON employeebenefits.EmployeeID = employees.EmployeeID
LEFT JOIN benefits
	ON employeebenefits.BenefitID = benefits.BenefitID
GROUP BY employees.EmployeeID)
GROUP BY employees.EmployeeID, FirstName, LastName, SalaryAmount
ORDER BY SalaryAmount DESC;

-- Jei reikėjo sudėti salaries ir benefits:
SELECT employees.EmployeeID, FirstName, LastName, SalaryAmount,
	SUM(Cost) AS total_benefits_amount,
    SUM(Cost) + SalaryAmount
FROM employees
LEFT JOIN salaries
	ON employees.EmployeeID = salaries.EmployeeID
LEFT JOIN employeebenefits
	ON employeebenefits.EmployeeID = employees.EmployeeID
LEFT JOIN benefits
	ON employeebenefits.BenefitID = benefits.BenefitID
WHERE SalaryStartDate IN (SELECT MAX(SalaryStartDate) 
FROM employees
LEFT JOIN salaries
	ON employees.EmployeeID = salaries.EmployeeID
LEFT JOIN employeebenefits
	ON employeebenefits.EmployeeID = employees.EmployeeID
LEFT JOIN benefits
	ON employeebenefits.BenefitID = benefits.BenefitID
GROUP BY employees.EmployeeID)
GROUP BY employees.EmployeeID, FirstName, LastName, SalaryAmount
ORDER BY SUM(Cost) + SalaryAmount  DESC;

-- 38. Employee Performance Review Trends: Output each employee's first and last name, 
-- indicating whether their performance review (performancereviews table) has improved or decreased. 
-- (TIP: Each employee should be visible, along with their information and whether their rating has improved or not).


SELECT
    FirstName,
    LastName,
    rate1,
    rate2,
    CASE
        WHEN rate1 > rate2 THEN "Better"
        WHEN rate1 < rate2 THEN "Worse"
        WHEN rate1 = rate2 THEN "The same"
        ELSE "N/A" 
    END AS rating_difference
FROM
    (SELECT
        EmployeeReviewDates.EmployeeID,
        EmployeeReviewDates.FirstName,
        EmployeeReviewDates.LastName,
        pr_latest.Rating AS rate1, -- Naujausias įvertinimas
        pr_earliest.Rating AS rate2 -- Senesnis įvertinimas
    FROM
         (SELECT
        employees.EmployeeID,
        employees.FirstName,
        employees.LastName,
        MAX(performancereviews.ReviewDate) AS LatestReviewDate, -- Naujausia vertinimo data
        MIN(performancereviews.ReviewDate) AS EarliestReviewDate -- Senesnė vertinimo data
    FROM
        employees
    LEFT JOIN
        performancereviews ON employees.EmployeeID = performancereviews.EmployeeID
    GROUP BY
        employees.EmployeeID, employees.FirstName, employees.LastName) AS EmployeeReviewDates
    LEFT JOIN
        performancereviews AS pr_latest
        ON EmployeeReviewDates.EmployeeID = pr_latest.EmployeeID AND EmployeeReviewDates.LatestReviewDate = pr_latest.ReviewDate
    LEFT JOIN
        performancereviews AS pr_earliest
        ON EmployeeReviewDates.EmployeeID = pr_earliest.EmployeeID AND EmployeeReviewDates.EarliestReviewDate = pr_earliest.ReviewDate) AS EmployeeRatings;
