create database supplier;
use supplier;
create table SUPPLIERS(sid integer(5) primary key, sname varchar(20), city
varchar(20));
desc SUPPLIERS;

insert into suppliers values
(10001,'Acme Widget','Bangalore'),
(10002,'Johns','Kolkata'),
(10003,'Vimal','Mumbai'),
(10004,'Reliance','Delhi'),
(10005,'Mahindra','Mumbai');
create table PARTS
(pid integer(5) primary key,
 pname varchar(20),
 color varchar(10));
 desc PARTS;
 insert into PARTS values
 (20001,'Book','Red' ),
(20002,'Pen','Red' ),
(20003,'Pencil','Green' ),
(20004,'Mobile','Green' ),
(20005,'Charger','Black' );
CREATE TABLE CATALOG (
  sid int(5)  NOT NULL,
  pid int(5),
  cost FLOAT(6),
  PRIMARY KEY (sid, pid),
  FOREIGN KEY (sid) REFERENCES SUPPLIERS(sid),
  FOREIGN KEY (pid) REFERENCES PARTS(pid)
); 

 insert into CATALOG values
 (10001,20001,10),
 (10001,20002,10),
 (10001,20003,30),
 (10001,20004,10),
 (10001,20005,10),
 (10002,20001,10),
 (10002,20002,20),
 (10003,20003,30),
 (10004,20003,40);

 select * from SUPPLIERS;
 select *from PARTS;
 select *from CATALOG;
SELECT DISTINCT P.pname
FROM Parts P, Catalog C
WHERE P.pid = C.pid;
SELECT S.sname
FROM Suppliers S

WHERE
(( SELECT count(P.pid)
FROM Parts P ) =
( SELECT count(C.pid)
FROM Catalog C
WHERE C.sid = S.sid ));
SELECT S.sname
FROM Suppliers S
WHERE
(( SELECT count(P.pid)
FROM Parts P where color='Red' ) =
( SELECT count(C.pid)
FROM Catalog C, Parts P
WHERE C.sid = S.sid AND
C.pid = P.pid AND P.color = 'Red' ));
SELECT P.pname
FROM Parts P, Catalog C, Suppliers S
WHERE P.pid = C.pid AND C.sid = S.sid
AND S.sname = 'Acme Widget'
AND NOT EXISTS ( SELECT *

FROM Catalog C1, Suppliers S1
WHERE P.pid = C1.pid AND C1.sid = S1.sid AND
S1.sname <> 'Acme Widget');
SELECT DISTINCT C.sid FROM Catalog C
WHERE C.cost >( SELECT AVG (C1.cost)
FROM Catalog C1
WHERE C1.pid = C.pid );
SELECT P.pid, S.sname
FROM Parts P, Suppliers S, Catalog C
WHERE C.pid = P.pid
AND C.sid = S.sid
AND C.cost = (SELECT MAX(C1.cost)
FROM Catalog C1
WHERE C1.pid = P.pid);

