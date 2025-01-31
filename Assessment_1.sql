-- Task 1: Create a database named employee, 
	-- then import data_science_team.csv, 
	-- proj_table.csv and emp_record_table.csv 
	-- into the employee database from the given resources.

-- Database creation
create database if not exists employee;

-- Task 2: Create an ER diagram for the given employee database.
	-- See the following pdf (2_Create an ER diagram 1 for the given “employee” database).
    
-- Task 3: 
	-- Write a query to fetch EMP_ID, FIRST_NAME, LAST_NAME, GENDER, 
    -- and DEPARTMENT from the employee record table, and make a list of 
    -- employees and details of their department.

-- Select the database
use employee;

-- Fetch all employee
select * from employee.emp_record_table;

-- Fetch EMP_ID, FIRST_NAME, LAST_NAME, GENDER, and DEPARTMENT from the employee
select EMP_ID, FIRST_NAME, LAST_NAME, GENDER, DEPT from employee.emp_record_table;


-- Task 4: 
	-- Write a query to fetch EMP_ID, FIRST_NAME, LAST_NAME, GENDER, DEPARTMENT, and EMP_RATING if the EMP_RATING is: 
		-- less than two
		-- greater than four 
		-- between two and four

-- less than two
select EMP_ID, FIRST_NAME, LAST_NAME, GENDER, DEPT, EMP_RATING from employee.emp_record_table
where EMP_RATING < 2;

-- greater than four
select EMP_ID, FIRST_NAME, LAST_NAME, GENDER, DEPT, EMP_RATING from employee.emp_record_table
where EMP_RATING > 4;

-- between two and four
select EMP_ID, FIRST_NAME, LAST_NAME, GENDER, DEPT, EMP_RATING from employee.emp_record_table
where EMP_RATING >= 2 and EMP_RATING <= 4;
	-- Or --
select EMP_ID, FIRST_NAME, LAST_NAME, GENDER, DEPT, EMP_RATING from employee.emp_record_table
where EMP_RATING between 2 and 4;


-- Task 5:
	-- Write a query to concatenate the FIRST_NAME and 
    -- the LAST_NAME of employees in the Finance department 
    -- from the employee table and then give the resultant column alias as NAME.

select concat(FIRST_NAME, ".", LAST_NAME) as alias from employee.emp_record_table
where DEPT = "FINANCE";
	-- Or --
select concat(lower(FIRST_NAME), ".", lower(LAST_NAME)) as alias from employee.emp_record_table
where DEPT = "FINANCE";


-- Task 6:
	-- Write a query to list only those employees who have someone reporting to them. 
    -- Also, show the number of reporters (including the President).

-- Write a query to list only those employees who have someone reporting to them.
select distinct FIRST_NAME, LAST_NAME, ROLE from employee.emp_record_table
where ROLE = "MANAGER" or ROLE = "PRESIDENT";

-- Also, show the number of reporters (including the President).
select count(distinct FIRST_NAME, LAST_NAME, ROLE) from employee.emp_record_table
where ROLE = "MANAGER" or ROLE = "PRESIDENT";


-- Task 7:
	-- Write a query to list down all the employees from the healthcare and finance departments using union. 
    -- Take data from the employee record table.

select FIRST_NAME, LAST_NAME, DEPT from employee.emp_record_table
where DEPT = "HEALTHCARE"
UNION
select FIRST_NAME, LAST_NAME, DEPT from employee.emp_record_table
where DEPT = "FINANCE";


-- Task 8:
	-- Write a query to list down employee details such as EMP_ID, 
    -- FIRST_NAME, LAST_NAME, ROLE, DEPARTMENT, and EMP_RATING grouped by dept. 
    -- Also include the respective employee rating along with the max emp rating for the department.

select EMP_ID, FIRST_NAME, LAST_NAME, ROLE, DEPT, EMP_RATING, max(EMP_RATING) over(partition by DEPT) as MAX_DEPT_RATING 
from employee.emp_record_table;


-- Task 9:
	-- Write a query to calculate the minimum and the maximum salary of the employees in each role. 
    -- Take data from the employee record table.
    
select ROLE, min(SALARY) as MIN_SALARY, max(SALARY) as MAX_SALARY 
from employee.emp_record_table
group by ROLE;


-- Task 10:
	-- Write a query to assign ranks to each employee based on their experience. 
    -- Take data from the employee record table.

select FIRST_NAME, LAST_NAME, EXP,
case 
	 when EXP <= 2 then 'JUNIOR'
	 when EXP > 2 and EXP <= 5 then 'ASSOCIATE'
     when EXP > 5 and EXP <= 10 then 'SENIOR'
     when EXP > 10 and EXP <= 12 then 'LEAD'
     when EXP > 12 and EXP <= 16 then 'MANAGER'
     when EXP > 16 and EXP <= 20 then 'PRESIDENT'
     end as 'ASSIGNED_RANK'
from employee.emp_record_table
order by EXP;

-- select * from employee.emp_record_table;

-- Task 11:
	-- Write a query to create a view that displays employees in various countries whose salary is more than six thousand. 
    -- Take data from the employee record table.

create view EMPLOYEE_COUNTRY as
select EMP_ID, FIRST_NAME, LAST_NAME, COUNTRY, SALARY 
from employee.emp_record_table
where SALARY > 6000;

select * from EMPLOYEE_COUNTRY;


-- Task 12:
	-- Write a nested query to find employees with experience of more than ten years. 
    -- Take data from the employee record table.

select EMP_ID, FIRST_NAME, LAST_NAME, EXP from employee.emp_record_table
where EXP in (
		select EXP from employee.emp_record_table
		where EXP >= 10
		group by EXP
    );


-- Task 13:
	-- Write a query to create a stored procedure to retrieve the details of the employees whose experience is more than three years. 
    -- Take data from the employee record table.

USE `employee`;
DROP procedure IF EXISTS `GetExperiencedEmployee`;

DELIMITER $$
USE `employee`$$
CREATE PROCEDURE `GetExperiencedEmployee`()
BEGIN
	select EMP_ID, FIRST_NAME, LAST_NAME, EXP from employee.emp_record_table
	where EXP > 3
    group by EXP desc;
END;$$
DELIMITER ;

CALL GetExperiencedEmployee;


-- Task 14:
	-- Write a query using stored functions in the project table to check whether the job profile assigned 
    -- to each employee in the data science team matches the organization’s set standard.
		-- The standard being:
			-- For an employee with experience less than or equal to 2 years assign 'JUNIOR DATA SCIENTIST',
			-- For an employee with the experience of 2 to 5 years assign 'ASSOCIATE DATA SCIENTIST',
            -- For an employee with the experience of 5 to 10 years assign 'SENIOR DATA SCIENTIST',
            -- For an employee with the experience of 10 to 12 years assign 'LEAD DATA SCIENTIST',
			-- For an employee with the experience of 12 to 16 years assign 'MANAGER'.

select FIRST_NAME, LAST_NAME, EXP,
case 
	when EXP <= 2 then 'JUNIOR DATA SCIENTIST'
	when EXP > 2 and EXP <= 5 then 'ASSOCIATE DATA SCIENTIST'
	when EXP > 5 and EXP <= 10 then 'SENIOR DATA SCIENTIST'
	when EXP > 10 and EXP <= 12 then 'LEAD DATA SCIENTIST'
	when EXP > 12 and EXP <= 16 then 'MANAGER'
	end as 'JOB_PROFILE_ASSIGNED'
from employee.emp_record_table
where EXP != 20
order by EXP;


-- Task 15:
	-- Create an index to improve the cost and performance of the query to find the employee 
    -- whose FIRST_NAME is ‘Eric’ in the employee table after checking the execution plan.

create index idx_employee_first_name on employee.emp_record_table (FIRST_NAME);

select FIRST_NAME, LAST_NAME
from employee.emp_record_table
where FIRST_NAME = 'Eric';



-- Task 16:
	-- Write a query to calculate the bonus for all the employees, based on their ratings 
    -- and salaries (Use the formula: 5% of salary * employee rating).

select FIRST_NAME, LAST_NAME, EMP_RATING, SALARY, (EMP_RATING * SALARY * 0.05) as BONUS 
from employee.emp_record_table;


-- Task 17:
	-- Write a query to calculate the average salary distribution based on the continent and country. 
    -- Take data from the employee record table.

select CONTINENT, avg(SALARY) as AVG_SALARY from employee.emp_record_table
group by CONTINENT;

	-- Or --
    
select CONTINENT, sum(SALARY)/count(COUNTRY) as AVG_SALARY from employee.emp_record_table
group by CONTINENT;








