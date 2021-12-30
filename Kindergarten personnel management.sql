create database Project_TNguyen;
use Project_TNguyen;

create table Department(
	Dep_Id varchar(5) primary key,
    Dep_Name varchar(50)
    );
    
create table Jobs(
	Job_Id varchar(5) primary key,
    Dep_Id varchar(5),
    Job_Name varchar(50),
    foreign key (Dep_Id) references Department(Dep_Id)
    );
    
create table Employees(
	Emp_Id varchar(5) primary key,
    Job_Id varchar(5),
    Emp_Name varchar(50),
    DOB date,
    Address varchar(50),
    Gender enum('Male','Female'),
    Phone_Number varchar(10),
    foreign key (Job_Id) references Jobs(Job_Id)
    );
    
create table Salary(
	Job_Id varchar(5),
    Salary_Basic_Each_Hour float,
    foreign key (Job_Id) references Jobs(Job_Id)
    );
    
create table History_Working(
	Emp_Id varchar(5),
    Date_Working date,
    Start_Time time,
    End_Time time,
    primary key(Emp_Id,Date_Working),
    foreign key (Emp_Id) references Employees(Emp_Id)
    );
    
#--Nhập dữ liệu ở bảng department
INSERT INTO `department` (`Dep_Id`, `Dep_Name`) 
VALUES ('P01', 'Principal\'s office'),
('P02', 'Teachers'),
('P03', 'Finances office'), ('P04', 'Guards');    
    
#---Nhập dữ liệu ở bảng Jobs
INSERT INTO `jobs` (`Job_Id`, `Dep_Id`, `Job_Name`) VALUES 
('J01', 'P01', 'Principal'), ('J02', 'P02', 'Vice-Principal'), 
('J03', 'P02', 'Child care teacher from 24-36 months'),
('J04', 'P02', 'Child care teacher from 4-5 years old'),
('J05', 'P02', 'Child care teacher from 5-6 years old'),
('J06', 'P03', 'Treasurer'), ('J07', 'P03', 'Accountant'),
('J08', 'P04', 'Guard'), ('J09', 'P04', 'Labor');

#---Nhập dữ liệu ở bảng Employess
INSERT INTO `employees` (`Emp_Id`, `Job_Id`, `Emp_Name`, `DOB`, `Address`, `Gender`, `Phone_Number`) VALUES 
('NV01', 'J01', 'Nguyễn Thị Thùy Dương', '1980/05/05', 'Phước Mỹ, Sơn Trà, Đà Nẵng', 'Female', '0988125456'), 
('NV02', 'J02', 'Hoàng Anh Tú', '1982/04/02', 'Hải Hưng, Hải Lăng, Quảng Trị', 'Male', '0889124263'), 
('NV03', 'J03', 'Nguyễn Bảo Châu', '1992/07/08', 'Hòa Khánh Bắc, Liên Chiểu, Đà Nẵng', 'Female', '09495455654'),
('NV04', 'J04', 'Nguyễn Thị Diễm My', '1990/03/06', 'Thừa Thiên Huế', 'Female', '0899766244'), 
('NV05', 'J05', 'Nguyễn Thị Diễm Quỳnh', '1989/09/08', 'Thừa Thiên Huế', 'Female', '0369789456'), 
('NV06', 'J06', 'Hoàng Đức Sáng', '1987/10/11', 'Gio Hải, Gio Linh, Quảng Trị', 'Male', '0971168762'), 
('NV07', 'J07', 'Hoàng Anh', '1990/12/12', 'Hòa Minh, Hòa Vang, Đà Nẵng', 'Male', '0397125896'), 
('NV08', 'J08', 'Hoàng Văn Hòa', '1963/12/10', 'An Hải Đông', 'Male', '0945125452'),
('NV09', 'J09', 'Nguyễn Thị Nga', '1979/04/05', 'Cẩm Lệ, Đà Nẵng', 'Female', '0398124293');

#---Nhập dữ liệu ở bảng Salary
INSERT INTO `salary` (`Job_Id`, `Salary_Basic_Each_Hour`) VALUES 
('J01', '35000'),
('J02', '32000'), 
('J03', '30000'), 
('J04', '30000'), 
('J05', '30000'), 
('J06', '30000'), 
('J07', '30000'), 
('J08', '29000'), 
('J09', '29000');

#---Nhập dữ liệu ở bảng History_Working
INSERT INTO `history_working` (`Emp_Id`, `Date_Working`, `Start_Time`, `End_Time`) 
VALUES 
('NV01', '2021/10/10', '07:00', '16:30'), 
('NV02', '2021/10/11', '07:00', '16:00'),
('NV02', '2021/10/20', '07:00', '18:00'),
('NV03', '2021/09/10', '06:45', '17:00'), 
('NV04', '2021/09/26', '06:45', '17:00'),
('NV05', '2021/10/20', '06:45', '17:00'), 
('NV06', '2021/08/29', '08:00', '17:00'), 
('NV07', '2021/09/25', '08:00', '17:00'), 
('NV08', '2021/04/20', '06:00', '18:00'), 
('NV09', '2021/04/26', '06:00', '18:00');

#1. VIEW

-- View Tính giờ làm việc của nhân viên --
create view Time_Working
As
	select HW.Emp_Id,Emp.Emp_Name, HW.Date_Working, if( HOUR(HW.End_Time) - HOUR(HW.Start_Time) >= 8, 8, HOUR(HW.End_Time - HW.Start_Time)) as Hour_Working , 
    if( HOUR(HW.End_Time) - HOUR(HW.Start_Time) >= 8, HOUR(HW.End_Time - HW.Start_Time) - 8,0) as Hour_OverTime
	from History_Working as HW
    join Employees as Emp
    on Hw.Emp_Id = Emp.Emp_Id;

-- View tính tổng giờ làm việc mỗi tháng của nhân viên --

create view time_working_each_month
as
	SELECT
    `e`.`Emp_Id` AS `Emp_Id`,
    `e`.`Emp_Name` AS `Emp_Name`,
    SUM(
        `tw`.`Hour_Working` + `tw`.`Hour_OverTime`
    ) AS `Total_Time`,
    MONTH(`tw`.`Date_Working`) AS `MONTH`
FROM
    (
        `project_tnguyen`.`employees` `e`
    JOIN `project_tnguyen`.`time_working` `tw`
    ON
        (`tw`.`Emp_Id` = `e`.`Emp_Id`)
    )
GROUP BY
    MONTH(`tw`.`Date_Working`),
    `tw`.`Emp_Id`
ORDER BY
    SUM(
        `tw`.`Hour_Working` + `tw`.`Hour_OverTime`
    )
DESC;

#2. FUCTION

-- Fuction tính lương (bao gồm lương cơ bản và lương tăng ca) --
DELIMITER $$
CREATE DEFINER=`root`@`localhost` FUNCTION `Calculate_Salary`(`Hour_Working` INT, `Hour_OverTime` INT, `salary_each_month` FLOAT) RETURNS float
begin
	declare Final_Salary float default 0;
	if (Hour_Working  < 8) then
		set Final_Salary = Hour_Working * salary_each_month;
    else
		set Final_Salary = ((Hour_Working * salary_each_month) + ((Hour_OverTime) * salary_each_month * 1.5 ));
	end if;
    return Final_Salary;
end$$
DELIMITER ;

#3. PROCEDURES

-- Hiển thị id, tên và tổng lương của 1 nhân viên --

DELIMITER $$
CREATE DEFINER=`root`@`localhost` PROCEDURE `sum_salary_emp`(IN `Emp_Id` VARCHAR(5), IN `months` INT)
BEGIN
	SELECT e.Emp_Id, e.Emp_Name, Calculate_Salary(sum(tw.Hour_Working), sum(tw.Hour_OverTime), s.Salary_Basic_Each_Hour)
    FROM employees as e
    JOIN time_working as tw
   	ON TW.Emp_Id = e.Emp_Id
    JOIN jobs as j
    ON j.Job_Id = e.Job_Id
    JOIN salary as S
    ON S.Job_Id = j.Job_Id
    WHERE e.Emp_Id = Emp_Id and month(tw.Date_Working)= months
    GROUP by e.Emp_Id, month(tw.Date_Working);
END$$
DELIMITER ;

-- Hiển thị id và tên phòng ban có số lượng nhân viên làm việc nhiều nhất --

DELIMITER $$
CREATE DEFINER=`root`@`localhost` PROCEDURE `Show_Department_Has_The_Most_Emloyees`()
BEGIN
	SELECT dep.Dep_Id, dep.Dep_Name, count(dep.Dep_Id) as num_of_emp
    FROM  employees as emp 
    join jobs as j on emp.Job_Id = j.Job_Id
    join department as dep on dep.Dep_Id = j.Dep_Id
    group by dep.dep_id 
    having num_of_emp = (select max(a.quantity) from (select count(dep_id) as quantity from jobs group by dep_id) as a);
END$$
DELIMITER ;

-- Hiển thị id và tên phòng ban có số lượng nhân viên làm việc ít nhất --

DELIMITER $$
CREATE DEFINER=`root`@`localhost` PROCEDURE `Show_Department_Has_The_Least_Emloyees`()
BEGIN
	SELECT dep.Dep_Id, dep.Dep_Name, count(dep.Dep_Id) as num_of_emp
    FROM  employees as emp 
    join jobs as j on emp.Job_Id = j.Job_Id
    join department as dep on dep.Dep_Id = j.Dep_Id
    group by dep.dep_id 
    having num_of_emp = (select min(a.quantity) from (select count(dep_id) as quantity from jobs group by dep_id) as a);
END$$
DELIMITER ;

-- Hiển thị id, tên và công việc của nhân viên trong 1 phòng ban --

DELIMITER $$
CREATE DEFINER=`root`@`localhost` PROCEDURE `Show_Employees_Of_Department`(IN `Dep_Id` VARCHAR(5))
BEGIN
	SELECT e.Emp_Id, e.Emp_Name, j.Job_Name
    FROM employees as e
    JOIN jobs AS j
    ON j.Job_Id = e.Job_Id
    JOIN department as d
    ON d.Dep_Id = j.Dep_Id
    WHERE d.Dep_Id = Dep_Id;
END$$
DELIMITER ;

-- Hiển thị id, tên nhân viên của nhân viên theo công việc --

DELIMITER $$
CREATE DEFINER=`root`@`localhost` PROCEDURE `Show_Employees_Of_Job`(IN `Job_Id` VARCHAR(5))
BEGIN
	SELECT e.Emp_Id, e.Emp_Name
    FROM employees as e
    JOIN jobs as j
    ON j.Job_Id = e.Job_Id
    WHERE j.Job_Id = job_Id;
END$$
DELIMITER ;


-- Hiển thị id, tên và thời gian làm việc nhiều nhất của nhân viên theo tháng --
DELIMITER $$
CREATE DEFINER=`root`@`localhost` PROCEDURE `Show_Employees_Working_The_Most_Each_Month`(IN `Month` INT)
BEGIN
	SELECT e.Emp_Id, e.Emp_Name, max(twem.Total_Time) as Time_work_each_day_of_Month
    FROM employees as e
    JOIN time_working_each_month as twem
    ON twem.Emp_Id = e.Emp_Id
    WHERE twem.MONTH = Month;
END$$
DELIMITER ;


#4. TRIGGER

-- Kiểm tra ràng buộc của thời gian (thời gian của 1 ngày bắt đầu từ 00:00 đến 24:00) --

DELIMITER $$
CREATE TRIGGER `check_hour` BEFORE INSERT ON `history_working`
 FOR EACH ROW BEGIN
 if (new.Start_Time >24 or new.Start_Time< 0 and new.End_Time >24 or new.End_time < 00) THEN
     SIGNAL SQLSTATE '45000'
     set MESSAGE_TEXT='error';
end if;    
END;
DELIMITER ;