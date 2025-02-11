use mydb;
--to find all students who have taken all courses in the CS department
SELECT * FROM Student WHERE not exists
(SELECT c.cno from course c
WHERE c.dept = 'CS' and c.cno not in 
                        (SELECT e.cno from enroll e WHERE e.sid = student.sid));

--or
SELECT * FROM Student WHERE exists
(SELECT c.cno from course c
WHERE c.dept = 'CS' and c.cno  in 
                        (SELECT e.cno from enroll e WHERE e.sid = student.sid));


--or
with ECtable as(SELECT e.Sid from Enroll e left JOIN Course c on e.Cno = c.Cno
WHERE c.Dept = 'CS')
SELECT s.* from Student s  join ECtable e on s.Sid = e.Sid;

--right join using left join to get courses which are not enrolled by any student
SELECT c.cno from course c left JOIN enroll e on c.cno=e.cno
WHERE e.cno IS NULL ;

--full outer join 
SELECT * from Enroll e full OUTER JOIN Course c on e.Cno = c.Cno

--to find all students who have not taken any course in the CS department
SELECT s.* from Student s where s.sid<>all(select e.sid from Enroll e JOIN Course c on e.cno=c.cno where c.dept='CS');

SELECT s.* from Student s where s.sid not in(select e.sid from Enroll e JOIN Course c on e.cno=c.cno where c.dept='CS');

SELECT s.* from Student s where not exists (select e.sid from Enroll e JOIN Course c on e.cno=c.cno where c.dept='CS' and e.sid=s.sid);

--NOT EXISTS (Query 3) is generally better because:
--It avoids issues with NULL values, which can complicate NOT IN queries.
--It often performs better in terms of query optimization and indexing.

--to find all students who have taken only Math course
SELECT s.* from Student s where s.sid in(select e.sid from Enroll e JOIN Course c on e.cno=c.cno where c.dept='Math') and s.sid not in(select e.sid from Enroll e JOIN Course c on e.cno=c.cno where c.dept<>'Math');

select e.sid from Enroll e JOIN Course c on e.cno=c.cno where c.dept='Math'
EXCEPT
select e.sid from Enroll e JOIN Course c on e.cno=c.cno where c.dept<>'Math';




