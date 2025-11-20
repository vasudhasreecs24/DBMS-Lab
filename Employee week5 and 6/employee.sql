-- Create Database
CREATE DATABASE emp;
USE emp;

-----------------------------------------
-- 1. DEPARTMENT TABLE
-----------------------------------------
CREATE TABLE dept (
    deptno DECIMAL(2,0) PRIMARY KEY,
    dname VARCHAR(14),
    loc VARCHAR(13)
);

-----------------------------------------
-- 2. EMPLOYEE TABLE
-----------------------------------------
CREATE TABLE emp (
    empno DECIMAL(4,0) PRIMARY KEY,
    ename VARCHAR(10),
    mgr_no DECIMAL(4,0),
    hiredate DATE,
    sal DECIMAL(10,2),
    deptno DECIMAL(2,0),
    FOREIGN KEY (deptno) REFERENCES dept(deptno)
        ON DELETE CASCADE ON UPDATE CASCADE
);

-----------------------------------------
-- 3. INCENTIVES TABLE
-----------------------------------------
CREATE TABLE incentives (
    empno DECIMAL(4,0),
    incentive_date DATE,
    incentive_amount DECIMAL(10,2),
    PRIMARY KEY(empno, incentive_date),
    FOREIGN KEY(empno) REFERENCES emp(empno)
        ON DELETE CASCADE ON UPDATE CASCADE
);

-----------------------------------------
-- 4. PROJECT TABLE
-----------------------------------------
CREATE TABLE project (
    pno INT PRIMARY KEY,
    pname VARCHAR(30) NOT NULL,
    ploc VARCHAR(30)
);

-----------------------------------------
-- 5. ASSIGNED_TO TABLE
-----------------------------------------
CREATE TABLE assigned_to (
    empno DECIMAL(4,0),
    pno INT,
    job_role VARCHAR(30),
    PRIMARY KEY(empno, pno),
    FOREIGN KEY(empno) REFERENCES emp(empno)
        ON DELETE CASCADE ON UPDATE CASCADE,
    FOREIGN KEY(pno) REFERENCES project(pno)
        ON DELETE CASCADE ON UPDATE CASCADE
);

-------------------------------------------------------
-- INSERT VALUES INTO DEPT
-------------------------------------------------------
INSERT INTO dept VALUES 
(10,'ACCOUNTING','MUMBAI'),
(20,'RESEARCH','BENGALURU'),
(30,'SALES','DELHI'),
(40,'OPERATIONS','CHENNAI');

-------------------------------------------------------
-- INSERT VALUES INTO EMP
-------------------------------------------------------
INSERT INTO emp VALUES
(7369,'Adarsh',7902,'2012-12-17',80000.00,20),
(7499,'Shruthi',7698,'2013-02-20',16000.00,30),
(7521,'Anvitha',7698,'2015-02-22',12500.00,30),
(7566,'Tanvir',7839,'2008-04-02',29750.00,20),
(7654,'Ramesh',7698,'2014-09-28',12500.00,30),
(7698,'Kumar',7839,'2015-05-01',28500.00,30),
(7782,'CLARK',7839,'2017-06-09',24500.00,10),
(7788,'SCOTT',7566,'2010-12-09',30000.00,20),
(7839,'KING',NULL,'2009-11-17',500000.00,10),
(7844,'TURNER',7698,'2010-09-08',15000.00,30),
(7876,'ADAMS',7788,'2013-01-12',11000.00,20),
(7900,'JAMES',7698,'2017-12-03',9500.00,30),
(7902,'FORD',7566,'2010-12-03',30000.00,20);

-------------------------------------------------------
-- INSERT VALUES INTO INCENTIVES
-------------------------------------------------------
INSERT INTO incentives VALUES
(7499,'2019-02-01',5000.00),
(7521,'2019-03-01',2500.00),
(7566,'2022-02-01',5070.00),
(7654,'2020-02-01',2000.00),
(7654,'2022-04-01',879.00),
(7521,'2019-02-01',8000.00),
(7698,'2019-03-01',500.00),
(7698,'2020-03-01',9000.00),
(7698,'2022-04-01',4500.00);

-------------------------------------------------------
-- INSERT VALUES INTO PROJECT
-------------------------------------------------------
INSERT INTO project VALUES
(101,'AI Project','BENGALURU'),
(102,'IOT','HYDERABAD'),
(103,'BLOCKCHAIN','BENGALURU'),
(104,'DATA SCIENCE','MYSURU'),
(105,'AUTONOMUS SYSTEMS','PUNE');

-------------------------------------------------------
-- INSERT VALUES INTO ASSIGNED_TO
-------------------------------------------------------
INSERT INTO assigned_to VALUES
(7499,101,'Software Engineer'),
(7521,101,'Software Architect'),
(7566,101,'Project Manager'),
(7654,102,'Sales'),
(7521,102,'Software Engineer'),
(7499,102,'Software Engineer'),
(7654,103,'Cyber Security'),
(7698,104,'Software Engineer'),
(7900,105,'Software Engineer'),
(7839,104,'General Manager');
select *from  dept;
select *from emp;
select *from incentives;
select *from project;
select *from assigned;
-------------------------------------------------------
-- WEEK 5 QUERIES
-------------------------------------------------------

-- 1. Employees working in Bengaluru, Hyderabad, Mysuru projects
SELECT e.empno
FROM emp e 
JOIN assigned_to a ON e.empno = a.empno
JOIN project p ON a.pno = p.pno
WHERE p.ploc IN ('BENGALURU','HYDERABAD','MYSURU');

-- 2. Employee IDs with no incentives
SELECT empno
FROM emp
WHERE empno NOT IN (SELECT empno FROM incentives);

-- 3. Employees working at project location same as dept location
SELECT e.ename, e.empno, e.deptno, a.job_role, d.loc AS dept_loc, p.ploc AS project_loc
FROM emp e
JOIN dept d ON e.deptno = d.deptno
JOIN assigned_to a ON e.empno = a.empno
JOIN project p ON a.pno = p.pno
WHERE d.loc = p.ploc;

-------------------------------------------------------
-- WEEK 6 QUERIES
-------------------------------------------------------

-- 1. Managers with highest number of employees
SELECT m.ename, COUNT(*) AS emp_count
FROM emp e
JOIN emp m ON e.mgr_no = m.empno
GROUP BY m.ename
HAVING COUNT(*) = (
    SELECT MAX(mycount)
    FROM (SELECT COUNT(*) AS mycount FROM emp GROUP BY mgr_no) x
);

-- 2. Managers whose salary > average salary of their employees
SELECT *
FROM emp m
WHERE m.empno IN (SELECT mgr_no FROM emp)
AND m.sal > (
    SELECT AVG(e.sal) FROM emp e WHERE e.mgr_no = m.empno
);

-- 3. Top-level manager of each department
SELECT d.dname, e.ename AS top_manager
FROM dept d
JOIN emp e ON d.deptno = e.deptno
WHERE e.mgr_no IS NULL;

-- 4. Employee with 2nd highest incentive in Feb 2019
SELECT e.*
FROM emp e
JOIN incentives i ON e.empno = i.empno
WHERE MONTH(i.incentive_date)=2 AND YEAR(i.incentive_date)=2019
AND 2 = (
    SELECT COUNT(*) 
    FROM incentives j
    WHERE j.incentive_amount >= i.incentive_amount
);

-- 5. Employees working in same dept as their manager
SELECT *
FROM emp e
WHERE e.deptno = (
    SELECT deptno FROM emp m WHERE m.empno = e.mgr_no
);

-- 6. Employees whose net pay >= salary of any employee
SELECT DISTINCT e.ename, e.empno
FROM emp e
JOIN incentives i ON e.empno = i.empno
WHERE (e.sal + i.incentive_amount) >= ANY (SELECT sal FROM emp);
