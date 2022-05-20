DROP DATABASE IF EXISTS project_de;
create database project_de;
use project_de;

drop table if exists employees
CREATE EXTERNAL TABLE employees STORED AS AVRO 
LOCATION '/user/anabig114225/projectdata/employees' 
TBLPROPERTIES ('avro.schema.url'='/user/anabig114225/projectschema/employees.avsc');

drop table if exists titles
CREATE EXTERNAL TABLE titles STORED AS AVRO 
LOCATION '/user/anabig114225/projectdata/titles' 
TBLPROPERTIES ('avro.schema.url'='/user/anabig114225/projectschema/titles.avsc');

drop table if exists salaries
CREATE EXTERNAL TABLE salaries STORED AS AVRO 
LOCATION '/user/anabig114225/projectdata/salaries' 
TBLPROPERTIES ('avro.schema.url'='/user/anabig114225/projectschema/salaries.avsc');

drop table if exists departments
CREATE EXTERNAL TABLE departments STORED AS AVRO 
LOCATION '/user/anabig114225/projectdata/departments' 
TBLPROPERTIES ('avro.schema.url'='/user/anabig114225/projectschema/departments.avsc');

drop table if exists department_manager
CREATE EXTERNAL TABLE department_manager STORED AS AVRO 
LOCATION '/user/anabig114225/projectdata/department_manager' 
TBLPROPERTIES ('avro.schema.url'='/user/anabig114225/projectschema/department_manager.avsc');

drop table if exists department_employees
CREATE EXTERNAL TABLE department_employees STORED AS AVRO 
LOCATION '/user/anabig114225/projectdata/department_employees' 
TBLPROPERTIES ('avro.schema.url'='/user/anabig114225/projectschema/department_employees.avsc');

select e.emp_no, last_name, first_name, sex, salary from employees e
inner join salaries s on e.emp_no=s.emp_no;