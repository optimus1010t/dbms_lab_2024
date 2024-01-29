-- creating database
-- DROP TABLE IF EXISTS student, role, event, college, participant, volunteer, manage, event_volunteer, event_participant;
CREATE TABLE student (
    name varchar(255),
    roll varchar(50) PRIMARY KEY,
    dept varchar(100)
);
CREATE TABLE role (
    rid varchar(50) PRIMARY KEY,
    rname varchar(255) NOT NULL,
    description varchar(1024),
    student_roll varchar(50) NOT NULL,
    FOREIGN KEY (student_roll) REFERENCES student(roll)
);
CREATE TABLE event (
    eid varchar(50) PRIMARY KEY,
    date date NOT NULL,
    ename varchar(255) NOT NULL,
    type varchar(100)
);
CREATE TABLE college (
    name varchar(511) PRIMARY KEY,
    location varchar(1023) NOT NULL
);
CREATE TABLE participant (
    pid varchar(50) PRIMARY KEY,
    name varchar(255) NOT NULL,
    college_name varchar(511) NOT NULL,
    FOREIGN KEY (college_name) REFERENCES college(name)
);
CREATE TABLE volunteer (
	roll varchar(50) PRIMARY KEY
);
CREATE TABLE manage (
    student_roll varchar(50),
    eid varchar(50),
    PRIMARY KEY (student_roll, eid),
    FOREIGN KEY (student_roll) REFERENCES student(roll),
    FOREIGN KEY (eid) REFERENCES event(eid)
);
CREATE TABLE event_volunteer (
    volunteer_roll varchar(50),
    eid varchar(50),
    PRIMARY KEY (volunteer_roll, eid),
    FOREIGN KEY (volunteer_roll) REFERENCES volunteer(roll),
    FOREIGN KEY (eid) REFERENCES event(eid)
);
CREATE TABLE event_participant (
    pid varchar(50),
    eid varchar(50),
    PRIMARY KEY (pid, eid),
    FOREIGN KEY (pid) REFERENCES participant(pid),
    FOREIGN KEY (eid) REFERENCES event(eid)
);

-- inserting data

INSERT INTO college (name, location) VALUES ('IITB', 'Mumbai');
INSERT INTO college (name, location) VALUES ('MIT', 'Massachusetts');
INSERT INTO college (name, location) VALUES ('Stanford', 'California');
INSERT INTO college (name, location) VALUES ('Cambridge', 'Cambridge');
INSERT INTO college (name, location) VALUES ('Oxford', 'Oxford');

INSERT INTO student (name, roll, dept) VALUES ('Alice', '001', 'CSE');
INSERT INTO student (name, roll, dept) VALUES ('Bob', '002', 'ECE');
INSERT INTO student (name, roll, dept) VALUES ('Charlie', '003', 'MECH');
INSERT INTO student (name, roll, dept) VALUES ('David', '004', 'CSE');
INSERT INTO student (name, roll, dept) VALUES ('Eve', '005', 'CIVIL');

INSERT INTO role (rid, rname, description, student_roll) VALUES ('R01', 'Secretary', 'Handles administrative tasks', '001');
INSERT INTO role (rid, rname, description, student_roll) VALUES ('R02', 'Treasurer', 'Manages finances', '002');
INSERT INTO role (rid, rname, description, student_roll) VALUES ('R03', 'President', 'Leads the student body', '003');
INSERT INTO role (rid, rname, description, student_roll) VALUES ('R04', 'Vice President', 'Assists the President', '004');
INSERT INTO role (rid, rname, description, student_roll) VALUES ('R05', 'Member', 'Active member', '005');

INSERT INTO event (eid, date, ename, type) VALUES ('E01', '2024-02-15', 'Megaevent', 'Cultural');
INSERT INTO event (eid, date, ename, type) VALUES ('E02', '2024-03-20', 'Techfest', 'Technical');
INSERT INTO event (eid, date, ename, type) VALUES ('E03', '2024-04-25', 'Sports Day', 'Sports');
INSERT INTO event (eid, date, ename, type) VALUES ('E04', '2024-05-30', 'Music Concert', 'Cultural');
INSERT INTO event (eid, date, ename, type) VALUES ('E05', '2024-08-15', 'Independence Day', 'National');

INSERT INTO participant (pid, name, college_name) VALUES ('P01', 'Frank', 'IITB');
INSERT INTO participant (pid, name, college_name) VALUES ('P02', 'Grace', 'MIT');
INSERT INTO participant (pid, name, college_name) VALUES ('P03', 'Hannah', 'Stanford');
INSERT INTO participant (pid, name, college_name) VALUES ('P04', 'Ivan', 'Cambridge');
INSERT INTO participant (pid, name, college_name) VALUES ('P05', 'Julia', 'Oxford');

INSERT INTO volunteer (roll) VALUES ('001');
INSERT INTO volunteer (roll) VALUES ('002');
INSERT INTO volunteer (roll) VALUES ('003');
INSERT INTO volunteer (roll) VALUES ('004');
INSERT INTO volunteer (roll) VALUES ('005');

INSERT INTO manage (student_roll, eid) VALUES ('001', 'E01');
INSERT INTO manage (student_roll, eid) VALUES ('002', 'E02');
INSERT INTO manage (student_roll, eid) VALUES ('003', 'E03');
INSERT INTO manage (student_roll, eid) VALUES ('004', 'E04');
INSERT INTO manage (student_roll, eid) VALUES ('005', 'E05');

INSERT INTO event_volunteer (volunteer_roll, eid) VALUES ('001', 'E01');
INSERT INTO event_volunteer (volunteer_roll, eid) VALUES ('002', 'E02');
INSERT INTO event_volunteer (volunteer_roll, eid) VALUES ('003', 'E03');
INSERT INTO event_volunteer (volunteer_roll, eid) VALUES ('004', 'E04');
INSERT INTO event_volunteer (volunteer_roll, eid) VALUES ('005', 'E05');

INSERT INTO event_participant (pid, eid) VALUES ('P01', 'E01');
INSERT INTO event_participant (pid, eid) VALUES ('P02', 'E02');
INSERT INTO event_participant (pid, eid) VALUES ('P03', 'E03');
INSERT INTO event_participant (pid, eid) VALUES ('P04', 'E04');
INSERT INTO event_participant (pid, eid) VALUES ('P05', 'E05');

-- queries

SELECT S.Roll, S.Name 
FROM Student S
JOIN MANAGE M ON S.Roll = M.Student_Roll
JOIN Event E ON M.EID = E.EID
WHERE E.EName = 'Megaevent';

SELECT S.Roll, S.Name
FROM Student S
JOIN Role R ON S.Roll = R.Student_Roll
JOIN MANAGE M ON S.Roll = M.Student_Roll
JOIN Event E ON M.EID = E.EID
WHERE E.EName = 'Megaevent' AND R.Rname = 'Secretary';

SELECT P.name
FROM Participant P
JOIN College C ON P.college_name = C.name
JOIN Event_Participant EP ON P.pid = EP.pid
JOIN Event E ON EP.eid = E.eid
WHERE C.name = 'IITB' AND E.ename = 'Megaevent';

SELECT DISTINCT C.name
FROM College C
JOIN Participant P ON C.name = P.college_name
JOIN Event_Participant EP ON P.pid = EP.pid
JOIN Event E ON EP.eid = E.eid
WHERE E.ename = 'Megaevent';

SELECT DISTINCT E.ename
FROM Event E
JOIN Manage M ON E.eid = M.eid
JOIN Student S ON M.student_roll = S.roll
JOIN Role R ON S.roll = R.student_roll
WHERE R.rname = 'Secretary';

SELECT S.name
FROM Student S
JOIN Volunteer V ON S.roll = V.roll
JOIN Event_Volunteer EV ON V.roll = EV.volunteer_roll
JOIN Event E ON EV.eid = E.eid
WHERE S.dept = 'CSE' AND E.ename = 'Megaevent';

SELECT DISTINCT E.ename
FROM Event E
JOIN Event_Volunteer EV ON E.eid = EV.eid
JOIN Volunteer V ON EV.volunteer_roll = V.roll
JOIN Student S ON V.roll = S.roll
WHERE S.dept = 'CSE';

SELECT C.name
FROM College C
JOIN Participant P ON C.name = P.college_name
JOIN Event_Participant EP ON P.pid = EP.pid
JOIN Event E ON EP.eid = E.eid
WHERE E.ename = 'Megaevent'
GROUP BY C.name
ORDER BY COUNT(P.pid) DESC
LIMIT 1;

SELECT C.name
FROM College C
JOIN Participant P ON C.name = P.college_name
GROUP BY C.name
ORDER BY COUNT(P.pid) DESC
LIMIT 1;

SELECT S.dept, COUNT(DISTINCT V.roll) as volunteer_count
FROM student S
JOIN volunteer V ON S.roll = V.roll
JOIN event_volunteer EV ON V.roll = EV.volunteer_roll
JOIN event E ON EV.eid = E.eid
JOIN event_participant EP ON E.eid = EP.eid
JOIN participant P ON EP.pid = P.pid
WHERE P.college_name = 'IITB'
GROUP BY S.dept
ORDER BY COUNT(DISTINCT V.roll) DESC
LIMIT 1;
