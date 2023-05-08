
CREATE TABLE "departments" (
    "dept_no" VARCHAR(30)   NOT NULL,
    "dept_name" VARCHAR(30)   NOT NULL,
    CONSTRAINT "pk_departments" PRIMARY KEY (
        "dept_no"
     )
);

CREATE TABLE "dept_emp" (
    "emp_no" INT   NOT NULL,
    "dept_no" VARCHAR(30)   NOT NULL,
    CONSTRAINT "pk_dept_emp" PRIMARY KEY (
        "emp_no", "dept_no"
     )
);

CREATE TABLE "dept_manager" (
    "dept_no" VARCHAR(30)   NOT NULL,
    "emp_no" INT   NOT NULL,
    CONSTRAINT "pk_dept_manager" PRIMARY KEY (
        "emp_no"
     )
);

CREATE TABLE "employees" (
    "emp_no" INT   NOT NULL,
    "emp_title_id" VARCHAR(30)   NOT NULL,
    "birth_date" DATE   NOT NULL,
    "first_name" VARCHAR(30)   NOT NULL,
    "last_name" VARCHAR(30)   NOT NULL,
    "sex" VARCHAR(1)   NOT NULL,
    "hire_date" DATE   NOT NULL,
    CONSTRAINT "pk_employees" PRIMARY KEY (
        "emp_no"
     )
);

CREATE TABLE "salaries" (
    "emp_no" INT   NOT NULL,
    "salary" INT   NOT NULL,
    CONSTRAINT "pk_salaries" PRIMARY KEY (
        "emp_no"
     )
);

CREATE TABLE "titles" (
    "title_id" VARCHAR(30)   NOT NULL,
    "title" VARCHAR(30)   NOT NULL,
    CONSTRAINT "pk_titles" PRIMARY KEY (
        "title_id"
     )
);

ALTER TABLE "dept_emp" ADD CONSTRAINT "fk_dept_emp_emp_no" FOREIGN KEY("emp_no")
REFERENCES "employees" ("emp_no");

ALTER TABLE "dept_emp" ADD CONSTRAINT "fk_dept_emp_dept_no" FOREIGN KEY("dept_no")
REFERENCES "departments" ("dept_no");

ALTER TABLE "dept_manager" ADD CONSTRAINT "fk_dept_manager_dept_no" FOREIGN KEY("dept_no")
REFERENCES "departments" ("dept_no");

ALTER TABLE "dept_manager" ADD CONSTRAINT "fk_dept_manager_emp_no" FOREIGN KEY("emp_no")
REFERENCES "employees" ("emp_no");

ALTER TABLE "employees" ADD CONSTRAINT "fk_employees_emp_title_id" FOREIGN KEY("emp_title_id")
REFERENCES "titles" ("title_id");

ALTER TABLE "salaries" ADD CONSTRAINT "fk_salaries_emp_no" FOREIGN KEY("emp_no")
REFERENCES "employees" ("emp_no");


-- 1. List the employee number, last name, first name, sex, and salary of each employee.
CREATE VIEW employee_salary AS
SELECT e.emp_no,
e.last_name,
e.first_name,
e.sex,
s.salary
FROM employees AS e
JOIN salaries AS s
ON (e.emp_no = s.emp_no)

DROP VIEW employee_salary

SELECT * from employee_salary

-- 2. List the first name, last name, and hire date for the employees who were hired in 1986.
CREATE VIEW employees_1986 AS
SELECT e.first_name,
e.last_name,
e.hire_date
FROM employees AS e
WHERE hire_date >= '1/1/1986' AND hire_date < '1/1/1987'

SELECT * from employees_1986

-- 3. List the manager of each department along with their department number, department name, employee number, last name, and first name.
CREATE VIEW manager_info AS
SELECT dm.emp_no,
dm.dept_no,
d.dept_name,
e.last_name,
e.first_name
FROM dept_manager AS dm
JOIN departments AS d
ON (d.dept_no = dm.dept_no)
  JOIN employees AS e
  ON (e.emp_no = dm.emp_no)
  
SELECT * from manager_info

SELECT * from dept_manager

-- 4. List the department number for each employee along with that employee’s employee number, last name, first name, and department name.
CREATE VIEW department_employee AS
SELECT de.emp_no,
de.dept_no,
d.dept_name,
e.last_name,
e.first_name
FROM dept_emp AS de
JOIN departments AS d
ON (d.dept_no = de.dept_no)
  JOIN employees AS e
  ON (e.emp_no = de.emp_no)
  
SELECT * from department_employee

-- 5. List first name, last name, and sex of each employee whose first name is Hercules and whose last name begins with the letter B.
CREATE VIEW employee_herculesb AS
SELECT e.first_name,
e.last_name,
e.sex
FROM employees AS e
WHERE first_name = 'Hercules'AND last_name LIKE 'B%'

SELECT * from employee_herculesb

-- 6. List each employee in the Sales department, including their employee number, last name, and first name.
CREATE VIEW sales_employees AS
SELECT de.emp_no,
d.dept_name,
e.last_name,
e.first_name
FROM dept_emp AS de
JOIN departments AS d
ON (d.dept_no = de.dept_no)
  JOIN employees AS e
  ON (e.emp_no = de.emp_no)
WHERE dept_name = 'Sales'
  
SELECT * from sales_employees

-- 7. List each employee in the Sales and Development departments, including their employee number, last name, first name, and department name.
CREATE VIEW sales_dev_employees AS
SELECT de.emp_no,
d.dept_name,
e.last_name,
e.first_name
FROM dept_emp AS de
JOIN departments AS d
ON (d.dept_no = de.dept_no)
  JOIN employees AS e
  ON (e.emp_no = de.emp_no)
WHERE dept_name = 'Sales' OR dept_name = 'Development'

SELECT * from sales_dev_employees

-- 8. List the frequency counts, in descending order, of all the employee last names (that is, how many employees share each last name).
SELECT last_name, COUNT(last_name) AS "last name count"
FROM employees
GROUP BY last_name
ORDER BY "last name count" DESC;