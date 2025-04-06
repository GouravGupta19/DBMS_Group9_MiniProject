DELIMITER //

CREATE PROCEDURE GetAllEmployees() 
BEGIN 
  SELECT Name, Department, Salary FROM Employees; 
END;
//

CREATE PROCEDURE SalaryBreakdown() 
BEGIN 
  SELECT E.Name, P.BasicSalary, P.Deductions, P.Bonus, (P.BasicSalary - P.Deductions + P.Bonus) AS NetSalary 
  FROM Payroll P JOIN Employees E ON E.EmployeeID = P.EmployeeID; 
END;
//

CREATE PROCEDURE HighestPaid() 
BEGIN 
  SELECT Name, Salary FROM Employees 
  WHERE Salary = (SELECT MAX(Salary) FROM Employees); 
END;
//

CREATE PROCEDURE PerfectAttendance() 
BEGIN 
  SELECT Name FROM Employees E 
  WHERE NOT EXISTS (SELECT 1 FROM Attendance A WHERE A.EmployeeID = E.EmployeeID AND A.Status = 'Absent'); 
END;
//

CREATE PROCEDURE UpdateSalary(IN id INT, IN inc INT) 
BEGIN 
  UPDATE Employees SET Salary = Salary + inc WHERE EmployeeID = id; 
END;
//

CREATE PROCEDURE MaxDeduction() 
BEGIN 
  SELECT E.Name, P.Deductions 
  FROM Payroll P JOIN Employees E ON E.EmployeeID = P.EmployeeID 
  WHERE P.Deductions = (SELECT MAX(Deductions) FROM Payroll); 
END;
//

CREATE PROCEDURE PayrollByMonth(IN m INT, IN y INT) 
BEGIN 
  SELECT DISTINCT P.* FROM Payroll P 
  JOIN Attendance A ON P.EmployeeID = A.EmployeeID 
  WHERE MONTH(A.Date) = m AND YEAR(A.Date) = y; 
END;
//

CREATE PROCEDURE OvertimeEmployees() 
BEGIN 
  SELECT DISTINCT E.Name 
  FROM Attendance A JOIN Employees E ON E.EmployeeID = A.EmployeeID 
  WHERE A.Status = 'Overtime'; 
END;
//

CREATE PROCEDURE DeleteOldPayrolls() 
BEGIN 
  DELETE FROM Payroll 
  WHERE EmployeeID IN (
    SELECT EmployeeID FROM Attendance 
    GROUP BY EmployeeID 
    HAVING MAX(Date) < DATE_SUB(CURDATE(), INTERVAL 1 YEAR)
  ); 
END;
//

CREATE PROCEDURE JoinByDate() 
BEGIN 
  SELECT E.EmployeeID, E.Name, MIN(A.Date) AS StartDate 
  FROM Employees E JOIN Attendance A ON E.EmployeeID = A.EmployeeID 
  GROUP BY E.EmployeeID ORDER BY StartDate; 
END;
//

DELIMITER ;
