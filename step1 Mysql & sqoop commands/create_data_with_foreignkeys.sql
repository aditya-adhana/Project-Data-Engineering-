CREATE TABLE employees(
emp_no int not null,
emp_titles_id varchar(10) not null,
birth_date varchar(20) not null,
first_name varchar(30) not null,
last_name varchar(30) not null,
sex char(2) not null,
hire_date varchar(20) not null,
no_of_projects smallint not null,
Last_performance_rating varchar(4) not null,
left_company boolean not null,
last_date varchar(20),
PRIMARY KEY(emp_no),
CONSTRAINT FK_title_id FOREIGN KEY (emp_titles_id) REFERENCES titles(title_id));

CREATE TABLE titles(
title_id varchar(10) not null,
title varchar(30) not null,
PRIMARY KEY(title_id),
 );

CREATE TABLE salaries(
emp_no int not null,
salary int not null,
CONSTRAINT FK_emp_no FOREIGN KEY (emp_no) REFERENCES employees(emp_no) );

CREATE TABLE departments(
dept_no varchar(10) not null,
dept_name varchar(30) not null, 
PRIMARY KEY(dept_no) );

CREATE TABLE department_manager(
dept_no varchar(10) not null,
emp_no int not null,
CONSTRAINT FK_dept_no FOREIGN KEY (dept_no) REFERENCES departments(dept_no),
CONSTRAINT FK_emp_no1 FOREIGN KEY (emp_no) REFERENCES employees(emp_no) );

CREATE TABLE department_employees(
emp_no int not null,
dept_no varchar(10) not null,
CONSTRAINT FK_dept_no2 FOREIGN KEY (emp_no) REFERENCES employees(emp_no),
CONSTRAINT FK_emp_no2 FOREIGN KEY (dept_no) REFERENCES departments(dept_no) ); 