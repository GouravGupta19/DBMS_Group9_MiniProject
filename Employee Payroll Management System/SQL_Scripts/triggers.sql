CREATE TRIGGER after_employee_insert
AFTER INSERT ON Employees
FOR EACH ROW
BEGIN
  INSERT INTO Payroll (EmployeeID, BasicSalary, Deductions, Bonus)
  VALUES (NEW.EmployeeID, NEW.Salary, 0, 0);
END;

CREATE TRIGGER before_salary_update
BEFORE UPDATE ON Employees
FOR EACH ROW
BEGIN
  IF OLD.Salary != NEW.Salary THEN
    INSERT INTO SalaryLog (EmployeeID, OldSalary, NewSalary, ChangedAt)
    VALUES (OLD.EmployeeID, OLD.Salary, NEW.Salary, NOW());
  END IF;
END;

CREATE TRIGGER check_negative_deductions
BEFORE INSERT ON Payroll
FOR EACH ROW
BEGIN
  IF NEW.Deductions < 0 THEN
    SIGNAL SQLSTATE '45000'
    SET MESSAGE_TEXT = 'Deductions cannot be negative';
  END IF;
END;

CREATE TRIGGER update_salary_on_payroll_change
AFTER UPDATE ON Payroll
FOR EACH ROW
BEGIN
  UPDATE Employees
  SET Salary = NEW.BasicSalary - NEW.Deductions + NEW.Bonus
  WHERE EmployeeID = NEW.EmployeeID;
END;

CREATE TRIGGER default_attendance_status
BEFORE INSERT ON Attendance
FOR EACH ROW
BEGIN
  IF NEW.Status IS NULL THEN
    SET NEW.Status = 'Present';
  END IF;
END;
