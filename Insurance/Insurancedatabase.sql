create database InsuranceDatabase;
use InsuranceDatabase;
create table person
(driver_id varchar(100) primary key ,
name varchar(100),
address varchar(100));
insert into person(driver_id,name,address) values
('A01','Richard','Srinivas nagar'),
('A02','Pradeep','Rajaji nagar'),
('A03','Smith','Ashok nagar'),
('A04','Venu','N R Colony'),
('A05','Jhon','Hanumanth nagar');
create table car
(reg_num varchar(50) primary key,
model varchar(100),
year int);
insert into car (reg_num,model,year) values
('KA052250','Indica',1990),
('KA031181','Lancer',1957),
('KA095477','Tayota',1998),
('KA053408','Honda',2008),
('KA041702','Audi',2005);
create table accident
(report_num int primary key,
accident_date varchar(100),
location varchar(100));
insert into accident (report_num,accident_date,location) values
(11,'01-JAN-03','Mysore Road'),
(12,'02-FEB-04','South end Circle'),
(13,'21-JAN-03','Bull temple Road'),
(14,'17-FEB-08','Mysore Road'),
(15,'04-MAR-05','Kanakpura Road');
create table owns
(driver_id varchar(100),
reg_num varchar(100),
foreign key(driver_id) references person(driver_id),
foreign key(reg_num) references car(reg_num));
insert into owns (driver_id,reg_num) values
('A01','KA052250'),
('A02','KA053408'),
('A03','KA031181'),
('A04','KA095477'),
('A05','KA041702');
create table participated
(driver_id varchar(100),
reg_num varchar(100),
report_num int,
damage_amount int,
foreign key(driver_id) references person(driver_id),
foreign key(reg_num) references car(reg_num),
foreign key (report_num)references accident(report_num));
insert into participated (driver_id,reg_num,report_num,damage_amount)
values
('A01','KA052250',11,10000),
('A02','KA053408',12,50000),
('A03','KA095477',13,25000),
('A04','KA031181',14,300),
('A05','KA041702',15,5000);
select accident_date,location
from accident;
update participated
set damage_amount=25000 
where reg_num='KA053408' and report_num=12;
select * from participated;
select count(distinct driver_id) CNT 
from participated a, accident b 
where a.report_num=b.report_num and b.accident_date like '%08';

insert into accident values (16,'2008-03-08','Domulur');
select *from accident;
select driver_id
from participated
where damage_amount>=25000;
select * from participated order by damage_amount desc;
select avg(damage_amount)
from participated;
SET SQL_SAFE_UPDATES = 0;
DELETE FROM participated
WHERE damage_amount < (
    SELECT avg_damage
    FROM (
        SELECT AVG(damage_amount) AS avg_damage
        FROM participated
    ) AS temp
);
select name 
from person as a, participated as b
where a.driver_id=b.driver_id and damage_amount>(select avg_damage
												from (select avg(damage_amount) as avg_damage
                                                from participated) as temp);

select max(damage_amount)
from participated;

