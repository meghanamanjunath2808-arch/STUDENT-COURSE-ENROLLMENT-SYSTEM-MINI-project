CREATE DATABASE student_project;
use student_project;
CREATE TABLE students ( 
student_id INT AUTO_INCREMENT PRIMARY KEY, 
name VARCHAR(100), 
age INT, 
gender VARCHAR(10) 
);
CREATE TABLE courses ( 
course_id INT AUTO_INCREMENT PRIMARY KEY,
course_name VARCHAR(100), 
credits INT 
);
CREATE TABLE enrollment ( 
enroll_id INT AUTO_INCREMENT PRIMARY KEY,
student_id INT, 
course_id INT, 
enroll_date DATE, 
UNIQUE(student_id,course_id), FOREIGN KEY(student_id) REFERENCES students(student_id),
FOREIGN KEY(course_id) REFERENCES courses(course_id) 
);
CREATE TABLE exams ( 
exam_id INT AUTO_INCREMENT PRIMARY KEY, 
student_id INT, 
course_id INT, 
exam_date DATE, FOREIGN KEY(student_id) REFERENCES
students(student_id), FOREIGN KEY(course_id) REFERENCES
courses(course_id) 
);
CREATE TABLE results ( 
result_id INT AUTO_INCREMENT PRIMARY KEY, 
exam_id INT UNIQUE, 
marks INT, 
grade CHAR(2), 
FOREIGN KEY(exam_id) REFERENCES
exams(exam_id) 
);
INSERT INTO students(name, age, gender) 
VALUES ('Arjun', 20, 'Male'),
('Seema', 21, 'Female'), 
('Ravi', 22, 'Male'), 
('Divya', 20, 'Female');

INSERT INTO courses(course_name, credits) 
VALUES ('Database Systems', 4), 
('Python Programming', 3), 
('Statistics', 4), 
('Machine Learning', 5);

INSERT INTO enrollment(student_id, course_id, enroll_date) 
VALUES (1, 1, '2024-01-15'),
 (1, 2, '2024-01-16'), 
 (2, 1, '2024-01-15'), 
 (3, 3, '2024-01-20'), 
 (4, 4, '2024-01-22');

INSERT INTO exams(student_id, course_id, exam_date) 
VALUES (1, 1, '2024-02-20'), 
(1, 2, '2024-02-21'), 
(2, 1, '2024-02-20'), 
(4, 4, '2024-02-25');

INSERT INTO results(exam_id, marks, grade) 
VALUES (1, 85, 'A'), 
(2, 78, 'B'), 
(3, 92, 'A'),
(4, 65, 'C');
##TRIGGER
DELIMITER //

CREATE TRIGGER prevent_duplicate_exam
BEFORE INSERT ON exams
FOR EACH ROW
BEGIN
    IF EXISTS (
        SELECT 1 FROM exams
        WHERE student_id = NEW.student_id
        AND course_id = NEW.course_id
    ) THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Exam already created for this student & course';
    END IF;
END //

DELIMITER ;

#STORED PROCEDURE
DELIMITER //

CREATE PROCEDURE get_student_report(IN sid INT)
BEGIN
    SELECT s.name,
           c.course_name,
           r.marks,
           r.grade
    FROM students s
    JOIN exams e ON s.student_id = e.student_id
    JOIN results r ON e.exam_id = r.exam_id
    JOIN courses c ON e.course_id = c.course_id
    WHERE s.student_id = sid;
END //

DELIMITER ;
#Stored Function
DELIMITER //

CREATE FUNCTION calc_grade(score INT)
RETURNS CHAR(2)
DETERMINISTIC
BEGIN
    IF score >= 90 THEN
        RETURN 'A';
    ELSEIF score >= 75 THEN
        RETURN 'B';
    ELSEIF score >= 60 THEN
        RETURN 'C';
    ELSE
        RETURN 'F';
    END IF;
END //

DELIMITER ;
SELECT calc_grade(88);
#View
CREATE VIEW student_enrollment_view AS
SELECT s.name AS student,
       c.course_name AS course,
       e.enroll_date
FROM students s
JOIN enrollment e ON s.student_id = e.student_id
JOIN courses c ON e.course_id = c.course_id;
SELECT * FROM student_enrollment_view;