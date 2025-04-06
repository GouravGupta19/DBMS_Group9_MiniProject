-- 1
SELECT Name, Department,  Salary
FROM Employees;

-- 2
SELECT Employees.Name, Payroll.BasicSalary, Payroll.Deductions, Payroll.Bonus,  (Payroll.BasicSalary - Payroll.Deductions + Payroll.Bonus) AS NetSalary
FROM Payroll 
JOIN Employees  ON Employees.EmployeeID = Payroll.EmployeeID;

-- 3
SELECT Name, Salary
FROM Employees
WHERE Salary = (SELECT MAX(Salary) FROM Employees);

-- 4
SELECT Employees.Name
FROM Employees 
WHERE NOT EXISTS (
    SELECT 1 FROM Attendance 
    WHERE Attendance.EmployeeID = Employees.EmployeeID AND Attendance.Status = 'Absent'
);

-- 5
UPDATE Employees
SET Salary = Salary + 10000  -- Or any new value or increment logic
WHERE EmployeeID = 1;        -- Replace with appropriate ID or condition

-- 6
SELECT Employees.Name, Payroll.Deductions
FROM Payroll 
JOIN Employees  ON Employees.EmployeeID = Payroll.EmployeeID
WHERE Payroll.Deductions = (SELECT MAX(Deductions) FROM Payroll);

-- 7
SELECT DISTINCT P.*
FROM Payroll P
JOIN Attendance A ON P.EmployeeID = A.EmployeeID
WHERE MONTH(A.Date) = 3 AND YEAR(A.Date) = 2025;


-- 8
SELECT DISTINCT Employees.Name
FROM Attendance 
JOIN Employees  ON Employees.EmployeeID = Attendance.EmployeeID
WHERE Attendance.Status = 'Overtime';

-- 9
SET SQL_SAFE_UPDATES = 0;
DELETE FROM Payroll
WHERE EmployeeID IN (
    SELECT E.EmployeeID
    FROM Employees E
    LEFT JOIN Attendance A ON E.EmployeeID = A.EmployeeID
    GROUP BY E.EmployeeID
    HAVING MAX(A.Date) < DATE_SUB(CURDATE(), INTERVAL 1 YEAR)
       OR MAX(A.Date) IS NULL
);
SET SQL_SAFE_UPDATES = 1;
select * from Payroll;

-- 10
SELECT E.EmployeeID, E.Name, MIN(A.Date) AS StartDate
FROM Employees E
JOIN Attendance A ON E.EmployeeID = A.EmployeeID
GROUP BY E.EmployeeID, E.Name
ORDER BY StartDate ASC;

