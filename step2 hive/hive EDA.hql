------------------------------------project_de table creation --------------------- 
create database project_de;
use project_de;

CREATE EXTERNAL TABLE employees STORED AS AVRO 
LOCATION '/user/anabig114225/projectdata/employees' 
TBLPROPERTIES ('avro.schema.url'='/user/anabig114225/projectschema/employees.avsc');

CREATE EXTERNAL TABLE titles STORED AS AVRO 
LOCATION '/user/anabig114225/projectdata/titles' 
TBLPROPERTIES ('avro.schema.url'='/user/anabig114225/projectschema/titles.avsc');

CREATE EXTERNAL TABLE salaries STORED AS AVRO 
LOCATION '/user/anabig114225/projectdata/salaries' 
TBLPROPERTIES ('avro.schema.url'='/user/anabig114225/projectschema/salaries.avsc');

CREATE EXTERNAL TABLE departments STORED AS AVRO 
LOCATION '/user/anabig114225/projectdata/departments' 
TBLPROPERTIES ('avro.schema.url'='/user/anabig114225/projectschema/departments.avsc');

CREATE EXTERNAL TABLE department_manager STORED AS AVRO 
LOCATION '/user/anabig114225/projectdata/department_manager' 
TBLPROPERTIES ('avro.schema.url'='/user/anabig114225/projectschema/department_manager.avsc');

CREATE EXTERNAL TABLE department_employees STORED AS AVRO 
LOCATION '/user/anabig114225/projectdata/department_employees' 
TBLPROPERTIES ('avro.schema.url'='/user/anabig114225/projectschema/department_employees.avsc');

---------------------------------------------------------
select * from titles limit 10;

#1.
select e.emp_no, last_name, first_name, sex, salary from employees e
inner join salaries s on e.emp_no=s.emp_no;

#2.
select first_name, last_name, hire_date from employees 
where cast(substring_index(hire_date,"/",-1) as int ) = 1986;

#3.
select d.dept_no, d.dept_name, dm.emp_no, last_name, first_name from departments d 
inner join department_manager dm on d.dept_no = dm.dept_no
inner join employees e on e.emp_no = dm.emp_no;

#4.
select e.emp_no, last_name, first_name, d.dept_name from employees e
inner join department_employees de on e.emp_no=de.emp_no
inner join departments d on de.dept_no=d.dept_no;


#5.
select first_name, last_name, sex from employees 
where first_name='Hercules' and last_name like 'B%';

#6.
create table department
as select dept_no, substr(dept_name, 2, length(dept_name)-2) as dept_name from departments;

select e.emp_no, last_name, first_name, d.dept_name from employees e
inner join department_employees de on e.emp_no=de.emp_no
inner join department d on de.dept_no=d.dept_no
where d.dept_name ='Sales';

#7.
select e.emp_no, last_name, first_name, d.dept_name from employees e
inner join department_employees de on e.emp_no=de.emp_no
inner join department d on de.dept_no=d.dept_no
where d.dept_name IN ('Sales', 'development');

#8.
select last_name, count(*) as count_of_employee_last_name from employees
group by last_name 
order by count_of_employee_last_name desc;

#9.
select
cast(hist.x as int) as bin_center,
cast(hist.y as bigint) as bin_height
from
(select
histogram_numeric(salary, 20) as A_hist
from
salaries) t
lateral view explode(A_hist) exploded_table as hist;

#10.
select t.title, avg(s.salary) as avg_salary from titles t 
inner join employees e on t.title_id = e.emp_titles_id 
inner join salaries s on e.emp_no = s.emp_no
group by t.title;

#11.
create table employee_final As
SELECT emp_no, emp_titles_id, 
    cast(concat(substring_index((substring_index(birth_date,'/',3)),'/',-1),'-',
            substring_index((substring_index(birth_date,'/',1)),'/',-1),'-',
            substring_index((substring_index(birth_date,'/',2)),'/',-1)) as DATE) as birth_date,
    first_name,
    last_name,
    sex,
    cast(concat(substring_index((substring_index(hire_date,'/',3)),'/',-1),'-',
            substring_index((substring_index(hire_date,'/',1)),'/',-1),'-',
            substring_index((substring_index(hire_date,'/',2)),'/',-1)) as DATE) as hire_date,
    no_of_projects,
    last_performance_rating,
    case when left_company=true then 1 else 0 end as left_company, last_date
from employees;

#12.a) 
    select left_company, count(*) from employees 
	group by left_company;

#12 b) 
    create table salary_dist    
    select
    case 
    when s.salary >= 40000 and s.salary < 50000   then '40-50k'
    when s.salary >= 50000 and s.salary < 60000 then '50 -60k' 
    when s.salary >= 60000 and s.salary < 70000 then '60 -70k'
    when s.salary >= 70000 and s.salary < 80000 then '70 -80k'
    when s.salary >= 80000 and s.salary < 90000 then '80 -90k'
    when s.salary >= 90000 and s.salary < 100000 then '90 -100k'
    when s.salary >= 100000 then '100k+'
    end as Salary_bins, e.emp_no 
    from employees e
    inner join salaries s on e.emp_no = s.emp_no;
    
    select Salary_bins , count(emp_no) freq from salary_dist 
    group by Salary_bins;
    
--#12.b) how many total employees per title in the company 

select t.title, count(e.emp_no) as total_employee_per_title from titles t
inner join employees e on t.title_id = e.emp_titles_id
group by t.title;

--#12.c) Total no employees per department in the company 

select d.dept_name, count(e.emp_no) as count_of_employee_per_department from employees e
inner join project_de.department_employees de on e.emp_no=de.emp_no
inner join project_de.department d on de.dept_no=d.dept_no
group by dept_name order by count_of_employee_per_department desc;

--#12.d) top 3 department where employees are leaving the company 

select d.dept_name, count(e.emp_no) as total_no_of_employees_left from project_de.employees e 
inner join project_de.department_employees de on e.emp_no=de.emp_no 
inner join project_de.department d on de.dept_no=d.dept_no 
where left_company = "true" group by dept_name order by total_no_of_employees_left desc;

#12 f) list of emp_name, title, dept_name, salary for each employee

select concat(first_name," ",last_name) as name, title, dept_name, salary from project_de.employees e
inner join project_de.salaries s on e.emp_no=s.emp_no 
inner join project_de.titles t on e.emp_titles_id=t.title_id 
inner join project_de.department_employees de on e.emp_no=de.emp_no 
inner join project_de.department d on de.dept_no=d.dept_no;