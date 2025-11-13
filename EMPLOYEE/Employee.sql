create database employee;
use employee;
create table DEPT (
    DEPT_NO INT ,
    DEPT_NAME VARCHAR(100),
    DEPT_LOC VARCHAR(100),
    primary key (DEPT_NO));
create table EMPLOYEE (
    EMP_NO INT,
    EMP_NAME VARCHAR(100),
    MGR_NO INT,
    HIRE_DATE DATE,
    SALARY DECIMAL(10,2),
    DEPT_NO INT,
    primary key (EMP_NO),
    foreign key (DEPT_NO) references DEPT(DEPT_NO));
create table PROJECT (
    P_NO INT ,
    P_LOC VARCHAR(100),
    P_NAME VARCHAR(100),
    primary key(P_NO));
create table ASSIGNED_TO (
    EMP_NO INT,
    P_NO INT,
    JOB_ROLE VARCHAR(100),
    primary key (EMP_NO, P_NO),
    foreign key (EMP_NO) references  EMPLOYEE(EMP_NO),
    foreign key (P_NO) references PROJECT(P_NO));
create table INCENTIVES (
    EMP_NO INT,
    INCENTIVE_DATE DATE,
    INCENTIVE_AMOUNT DECIMAL(10,2),
    foreign key (EMP_NO) references EMPLOYEE(EMP_NO));
insert into DEPT values (1, 'Development', 'Bengaluru'),
(2, 'Testing', 'Hyderabad'),
                (3, 'Sales', 'Mysuru'),
                (4, 'HR', 'Chennai'),
(5, 'Support', 'Mumbai'),
(6, 'Admin', 'Pune');
insert into EMPLOYEE values (101, 'Anil', NULL, '2022-01-01', 60000, 1),
(102, 'Priya', 101, '2022-02-01', 50000, 2),
(103, 'Rahul', 102, '2021-07-12', 65000, 1),
(104, 'Neha', 101, '2023-04-10', 48000, 3),
(105, 'Vijay', NULL, '2022-05-16', 59000,2),
(106, 'Sneha', 101, '2022-12-05', 51000, 4);
insert into PROJECT values (201, 'Bengaluru', 'Alpha'),
(202, 'Hyderabad', 'Beta'),
(203, 'Chennai', 'Gamma'),
(204, 'Mysuru', 'Delta'),
(205, 'Mumbai', 'Sigma'),
(206, 'Pune', 'Zeta');
insert into ASSIGNED_TO values (101, 201, 'Developer'),
(102, 202, 'Tester'),
(103, 204, 'Lead'),
(104, 202, 'Support'),
(105, 201, 'Analyst'),
(106, 203, 'Manager');
insert into INCENTIVES values (101, '2023-01-10', 5000),
(102, '2023-02-15', 4000),
(104, '2023-03-20', 3500),
(105, '2023-04-05', 4500),
(106, '2023-06-25', 3000);
SELECT EMP_NO
FROM EMPLOYEE
WHERE EMP_NO NOT IN (SELECT EMP_NO FROM INCENTIVES);
select distinct A.EMP_NO from ASSIGNED_TO A
 join PROJECT P ON A.P_NO=P.P_NO
 where P.P_LOC IN ("Bengaluru", "Hyderabad", "Mysuru");
SELECT E.EMP_NAME, E.EMP_NO, D.DEPT_NO, A.JOB_ROLE, D.DEPT_LOC AS DEPT_LOCATION, P.P_LOC AS PROJECT_LOCATION
FROM EMPLOYEE E
JOIN DEPT D ON E.DEPT_NO = D.DEPT_NO
JOIN ASSIGNED_TO A ON E.EMP_NO = A.EMP_NO
JOIN PROJECT P ON A.P_NO = P.P_NO
WHERE D.DEPT_LOC = P.P_LOC;
/*SELECT E2.EMP_NAME AS Manager_Name
FROM EMPLOYEE E2
WHERE E2.EMP_NO = (
    SELECT MGR_NO
    FROM EMPLOYEE
    WHERE MGR_NO IS NOT NULL
    GROUP BY MGR_NO
    ORDER BY COUNT(*) DESC
    LIMIT 1
);*/
SELECT E2.EMP_NO AS MGR_NO, E2.EMP_NAME AS Manager_Name, counts.emp_count AS Num_Employees
FROM EMPLOYEE E2
JOIN (
    SELECT MGR_NO, COUNT(*) AS emp_count
    FROM EMPLOYEE
    WHERE MGR_NO IS NOT NULL
    GROUP BY MGR_NO
    HAVING COUNT(*) = (
        SELECT MAX(emp_count)
        FROM (
            SELECT COUNT(*) AS emp_count
            FROM EMPLOYEE
            WHERE MGR_NO IS NOT NULL
            GROUP BY MGR_NO
        ) AS inner_counts
    )
) AS counts ON E2.EMP_NO = counts.MGR_NO;
select E.EMP_NO,E.EMP_NAME AS Manager_name, E.SALARY AS Manager_salary
from EMPLOYEE E
where E.EMP_NO in (select MGR_NO from EMPLOYEE
where MGR_NO IS NOT NULL
group by MGR_NO
HAVING E.SALARY > avg(SALARY)
);
/*select e2.EMP_NAME as second_level_manager, d.DEPT_NAME as department_name
from EMPLOYEE e1
join EMPLOYEE e2 on e1.EMP_NO = e2.MGR_NO
join dept d on e2.DEPT_NO = d.DEPT_NO
where e1.MGR_NO is null;*/
SELECT E.EMP_NAME AS Second_Top_Level_Manager, D.DEPT_NAME
FROM EMPLOYEE E
JOIN DEPT D ON E.DEPT_NO = D.DEPT_NO
WHERE E.MGR_NO IN (
    SELECT EMP_NO
    FROM EMPLOYEE
    WHERE MGR_NO IS NULL
)
ORDER BY D.DEPT_NAME;
/*SELECT E.*
FROM EMPLOYEE E
JOIN INCENTIVES I ON E.EMP_NO = I.EMP_NO
WHERE I.INCENTIVE_DATE >= '2023-01-01'
  AND I.INCENTIVE_DATE <= '2023-12-31'
  AND I.INCENTIVE_AMOUNT = (
        SELECT DISTINCT INCENTIVE_AMOUNT
        FROM INCENTIVES
        WHERE INCENTIVE_DATE >= '2023-01-01'
          AND INCENTIVE_DATE <= '2023-12-31'
        ORDER BY INCENTIVE_AMOUNT DESC
        LIMIT 1 OFFSET 1
);*/
select e.EMP_NAME, i.INCENTIVE_AMOUNT from EMPLOYEE e
join INCENTIVES i on e.EMP_NO = i.EMP_NO
where i.INCENTIVE_DATE like '2023%'  
and i.INCENTIVE_AMOUNT = (
select INCENTIVE_AMOUNT
from INCENTIVES
where INCENTIVE_DATE like '2023%'
order by INCENTIVE_AMOUNT desc
limit 1 offset 1
);
/*SELECT E.*
FROM EMPLOYEE E
JOIN EMPLOYEE M
  ON E.MGR_NO = M.EMP_NO
WHERE E.DEPT_NO = M.DEPT_NO;*/
select e.EMP_NAME as Employee_name, e.DEPT_NO as Employee_dept,
m.EMP_NAME as Manager_name, m.DEPT_NO as Manager_dept from EMPLOYEE e
 join EMPLOYEE m on e.MGR_NO = m.EMP_NO
 where e.DEPT_NO = m.DEPT_NO;
