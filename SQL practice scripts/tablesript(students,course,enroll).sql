use mydb;
-- Create the Student table
CREATE TABLE Student (
    Sid VARCHAR(2) PRIMARY KEY,
    Sname VARCHAR(50),
    Major VARCHAR(50),
    Byear INT
);

-- Insert values into the Student table
INSERT INTO Student (Sid, Sname, Major, Byear) VALUES
('s1', 'John', 'CS', 1990),
('s2', 'Ellen', 'Math', 1995),
('s3', 'Eric', 'CS', 1990),
('s4', 'Ann', 'Biology', 2001);

-- Create the Course table
CREATE TABLE Course (
    Cno VARCHAR(2) PRIMARY KEY,
    Cname VARCHAR(50),
    Dept VARCHAR(50)
);

-- Insert values into the Course table
INSERT INTO Course (Cno, Cname, Dept) VALUES
('c1', 'Dbs', 'CS'),
('c2', 'Calc1', 'Math'),
('c3', 'Calc2', 'Math'),
('c4', 'AI', 'Info');

-- Create the Enroll table
CREATE TABLE Enroll (
    Sid VARCHAR(2),
    Cno VARCHAR(2),
    Grade CHAR(1),
    PRIMARY KEY (Sid, Cno),
    FOREIGN KEY (Sid) REFERENCES Student(Sid),
    FOREIGN KEY (Cno) REFERENCES Course(Cno)
);

-- Insert values into the Enroll table
INSERT INTO Enroll (Sid, Cno, Grade) VALUES
('s1', 'c1', 'B'),
('s1', 'c2', 'A'),
('s2', 'c3', 'B'),
('s3', 'c1', 'A'),
('s3', 'c2', 'C');