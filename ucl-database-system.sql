create database UEFA_A3
use UEFA_A3




CREATE TABLE Team(
	T_ID INT NOT NULL,
	TName VARCHAR(60),
	TCountry VARCHAR(40),
	HomeStdID INT,

	CONSTRAINT PK_Team PRIMARY KEY(T_ID),
	CONSTRAINT FK_Team FOREIGN KEY(HomeStdID) REFERENCES Stadium(S_ID),
);

CREATE TABLE Cities(
	City VARCHAR(40),
	Country VARCHAR(40),
	CONSTRAINT PK_City PRIMARY KEY(City),
);

CREATE TABLE Stadium(
	S_ID INT NOT NULL,
	S_Name VARCHAR(60),
	S_City VARCHAR(40),
	Capacity NUMERIC(7),

	CONSTRAINT PK_Stadium PRIMARY KEY(S_ID),
	CONSTRAINT FK_Stadium FOREIGN KEY(S_City) REFERENCES Cities(City),
);


CREATE TABLE Player(
	P_ID VARCHAR(10) NOT NULL,
	FName VARCHAR(30),
	LName VARCHAR(30),
	Nationality VARCHAR(30),
	D_O_B DATE,
	PlayerTID INT,
	JNum INT,
	Position VARCHAR(20),
	Height NUMERIC(5),
	Weight NUMERIC(5),
	Foot VARCHAR(1),

	CONSTRAINT PK_Player PRIMARY KEY(P_ID),
	CONSTRAINT FK_Player1 FOREIGN KEY(PlayerTID) REFERENCES Team(T_ID),
);

CREATE TABLE Manager(
	M_ID INT NOT NULL,
	FName VARCHAR(30),
	LName VARCHAR(30),
	Nationality VARCHAR(30),
	D_O_B DATE,
	M_TID INT,

	CONSTRAINT PK_Manager PRIMARY KEY(M_ID),
	CONSTRAINT FK_Manager FOREIGN KEY(M_TID) REFERENCES Team(T_ID),
);



CREATE TABLE Matches(
	MID VARCHAR(10) NOT NULL,
	MDatenTime DATETIME,
	HomeTID INT,
	AwayTID INT,
	MatchStdID INT,
	HTScore INT,
	ATScore INT,
	PenaltyShootout INT,
	Attendance NUMERIC(7),

	CONSTRAINT PK_Matches PRIMARY KEY(MID),
	CONSTRAINT FK_Matches1 FOREIGN KEY(HomeTID) REFERENCES Team(T_ID),
	CONSTRAINT FK_Matches2 FOREIGN KEY(AwayTID) REFERENCES Team(T_ID),
	CONSTRAINT FK_Matches3 FOREIGN KEY(MatchStdID) REFERENCES Stadium(S_ID),
	CONSTRAINT FK_Matches4 FOREIGN KEY(MDatenTime) REFERENCES Dates(DatenTime),
);

CREATE TABLE Goal(
	G_ID VARCHAR(10) NOT NULL,
	G_MID VARCHAR(10),
	G_PID VARCHAR(10),
	Duration INT,
	Assist VARCHAR(10),
	G_Desc VARCHAR(400),

	CONSTRAINT PK_Goals PRIMARY KEY(G_ID),
	CONSTRAINT FK_Goals1 FOREIGN KEY(G_MID) REFERENCES Matches(MID),
	CONSTRAINT FK_Goals2 FOREIGN KEY(G_PID) REFERENCES Player(P_ID),
);
CREATE TABLE Dates(
	DatenTime DATETIME NOT NULL,
	Season VARCHAR(10),

	CONSTRAINT PK_Datetime PRIMARY KEY(DatenTime),
);


/* --------------------DATA LOADING-------------------- */
GO
-- import the file
BULK INSERT dbo.Cities
FROM 'UEFA Champions League_Dataset - cities.csv '
WITH(FORMAT='CSV', FIRSTROW=2,  CODEPAGE='65001')
GO

GO
-- import the file
BULK INSERT dbo.Stadiums
FROM 'UEFA Champions League_Dataset - stadiums.csv'
WITH(FORMAT='CSV', FIRSTROW=2,  CODEPAGE='65001')
GO


GO
-- import the file
BULK INSERT dbo.Teams
FROM 'UEFA Champions League_Dataset - teams.csv'
WITH(FORMAT='CSV', FIRSTROW=2,  CODEPAGE='65001')
GO


GO
-- import the file
BULK INSERT dbo.Players
FROM 'UEFA Champions League_Dataset - players.csv'
WITH(FORMAT='CSV', FIRSTROW=2,  CODEPAGE='65001')
GO


GO
-- import the file
BULK INSERT dbo.Managers
FROM 'UEFA Champions League_Dataset - managers.csv'
WITH(FORMAT='CSV', FIRSTROW=2,  CODEPAGE='65001')
GO


GO
-- import the file
BULK INSERT dbo.Dates
FROM 'Formatted UEFA1 - datetime.csv'
WITH(FORMAT='CSV', FIRSTROW=2,  CODEPAGE='65001')
GO


GO
-- import the file
BULK INSERT dbo.Matches
FROM 'Formatted UEFA1 - matches.csv'
WITH(FORMAT='CSV', FIRSTROW=2,  CODEPAGE='65001')
GO


GO
-- import the file
BULK INSERT dbo.Goals
FROM 'UEFA Champions League_Dataset - goals.csv'
WITH(FORMAT='CSV', FIRSTROW=2, CODEPAGE='65001')
GO



--EASY
--Q1
Select Player.P_ID, Player.FName, Player.LName, Player.NATIONALITY, Player.D_O_B
from Player inner join Manager 
on Player.PlayerTID = Manager.M_TID
where Manager.M_ID�= 12

--Q2
SELECT Matches.MID, Stadium.S_Name as Stadium_Name, Stadium.S_City, HT.TName, AT.TName, Matches.ATTENDANCE, Matches.MDatenTime AS Date_Time
FROM Matches JOIN  Team HT on Matches.HomeTID = HT.T_ID JOIN  Team AT on Matches.AwayTID = AT.T_ID JOIN Stadium  ON Stadium.S_ID = Matches.MatchStdID
JOIN Cities C ON Stadium.S_City = C.City
WHERE C.Country�=�'Spain';

--Q3
SELECT DISTINCT Team.TName, Team.TCountry, Stadium.S_Name as STADIUM, COUNT(*) as WINs FROM Team 
JOIN Matches ON Matches.HomeTID = Team.T_ID
JOIN Stadium ON Stadium.S_ID = Matches.MatchStdID
WHERE Matches.HTScore > Matches.ATScore
AND Matches.MatchStdID = Team.HomeStdID
GROUP BY Team.TName, Team.TCountry, Stadium.S_Name
HAVING COUNT(*) > 3;

--Q4
SELECT DISTINCT Manager.M_ID, Manager.FName + ' ' + Manager.LName as Manager_Name, Team.TName, Manager.NATIONALITY
FROM Team
JOIN Manager ON Manager.M_TID = Team.T_ID
WHERE Manager.NATIONALITY <> Team.TCountry;

--Q5
SELECT DISTINCT HT.TName as Home_Team, AT.TName as Away_Team, Stadium.S_Name AS Stadium_Name, Dates.Season, Dates.DatenTime, Matches.ATTENDANCE, Stadium.CAPACITY
FROM Matches
JOIN  Team HT on Matches.HomeTID = HT.T_ID
JOIN  Team AT on Matches.AwayTID = AT.T_ID
JOIN Stadium ON Matches.MatchStdID = Stadium.S_ID
JOIN Dates ON Matches.MDatenTime = Dates.DatenTime
WHERE Stadium.CAPACITY > 60000;

--MEDIUM
--Q6
Select G_ID, Height, G_Desc ,P_ID from goal inner join Matches on Matches.MID = Goal.G_MID 
inner join Player on Player.P_ID = Goal.G_PID
where Assist is NULL and Player.Height > 180
group by MDatenTime, G_ID, Height, P_ID, G_Desc
Having Year(MDatenTime)�=�2020

--Q7
SELECT DISTINCT Team.T_ID, Team.TName AS TEAM,  COUNT(*) AS NUM_HOME_MATCHES, SUM(CASE WHEN M.HTScore > M.ATScore THEN 1 ELSE 0 END) AS NUM_HOME_WINS, 
SUM(CASE WHEN M.HTScore > M.ATScore THEN 1 ELSE 0 END) * 100 / COUNT(*) AS WIN_PERCENTAGE
FROM Matches M
JOIN Team ON M.HomeTID = Team.T_ID
JOIN Stadium ON M.MatchStdID = Stadium.S_ID
JOIN Cities ON Stadium.S_City = Cities.City
WHERE Team.TCountry = 'Russia' AND Team.HomeStdID = Stadium.S_ID
GROUP BY Team.T_ID, Team.TName
HAVING COUNT(*) > 0 AND SUM(CASE WHEN M.HTScore > M.ATScore THEN 1 ELSE 0 END) * 100�/�COUNT(*)�<�50

--Q8
SELECT DISTINCT Stadium.S_ID, Stadium.S_Name AS STADIUM, COUNT(*) AS NUM_MATCHES, SUM(CASE WHEN Matches.HTScore > Matches.ATScore THEN 1 ELSE 0 END) AS NUM_HOME_WINS, 
SUM(CASE WHEN Matches.HTScore > Matches.ATScore THEN 1 ELSE 0 END) * 100 / COUNT(*) AS WIN_PERCENTAGE
FROM Matches
JOIN Stadium ON Matches.MatchStdID = Stadium.S_ID
JOIN Team ON Matches.HomeTID = Team.T_ID
GROUP BY Stadium.S_ID, Stadium.S_Name
HAVING COUNT(*) > 6 
AND SUM(CASE WHEN Matches.HTScore > Matches.ATScore THEN 1 ELSE 0 END) * 100 / COUNT(*) < 50

--Q9
select top(1) Dates.Season,count(Goal.G_ID) as Goal_Count from Dates inner join Matches 
ON Matches.MDatenTime = Dates.DatenTime inner join Goal 
ON Goal.G_MID = Matches.MID 
where G_Desc ='left-footed shot'
group by Season
order by Goal_Count desc

--Q10
select top(1) Team.TCountry as Country, count(Goal.G_ID) as Goal_Count from Player inner join Goal 
ON Player.P_ID = Goal.G_PID
inner join Team ON Team.T_ID = Player.PlayerTID
group by Team.TCountry
having count(Goal.G_ID) > 1 
order by Goal_Count desc

--Hard
--Q11 
select Stadium.S_ID, Stadium.S_Name, COUNT(g1.G_ID) AS Goal_Count
FROM Goal g1
INNER JOIN Matches ON g1.G_MID = Matches.MID
INNER JOIN Stadium ON Matches.MatchStdID = Stadium.S_ID
WHERE g1.G_Desc = 'left-footed shot'
GROUP BY Stadium.S_ID, Stadium.S_Name
HAVING COUNT(g1.G_ID) > ( select count(g2.G_ID) from Goal g2 INNER JOIN Matches m ON g2.G_MID=m.MID
WHERE g2.G_Desc = 'right-footed shot' AND m.MatchStdID = Stadium.S_ID)

--Q12
Select Matches.MID, Matches.HomeTID, Matches.AwayTID, Stadium.S_City
from Matches inner join Stadium on Matches.MatchStdID = Stadium.S_ID, (Select Stadium.S_ID
from Cities inner join Stadium on Stadium.S_City = Cities.City,
( Select Top (1) Capacities, Cities.Country
from (Select SUM(Capacity) AS Capacities, Country
from Stadium inner join Cities on Stadium.S_City = Cities.City
group by Cities.Country) as Ans, Stadium inner join Cities on Cities.City = Stadium.S_City
where  Cities.Country = Ans.Country
order by Capacities desc) as Ans
where Cities.Country = Ans.Country) As StdNum
where Matches.MatchStdID�=�StdNum.S_ID;

--Q13
SELECT TOP 1 p1.P_ID, p1.FName + ' ' + p1.LName AS GOAL_SCORED_PLAYER, p2.P_ID, p2.FName + ' ' + p2.LName AS GOAL_ASSISTED_PLAYER, (SELECT COUNT(*)
FROM Goal g3
WHERE (g3.G_PID = p1.P_ID AND g3.Assist = p2.P_ID) OR (g3.G_PID = p2.P_ID AND g3.Assist = p1.P_ID)) AS Combined_Goals
FROM Goal g1
JOIN Player p1 ON g1.G_PID = p1.P_ID
JOIN Goal g2 ON g1.G_MID = g2.G_MID AND g1.Assist = g2.G_PID
JOIN Player p2 ON g2.G_PID = p2.P_ID AND p1.P_ID <> p2.P_ID
WHERE p1.FName + ' ' + p1.LName IS NOT NULL AND p2.FName + ' ' + p2.LName IS NOT NULL
GROUP BY p1.P_ID, p1.FName + ' ' + p1.LName, p2.P_ID, p2.FName + ' ' + p2.LName
ORDER BY Combined_Goals�DESC

--Q14
SELECT TOP 1 Team.T_ID, Team.TName, (SUM(CASE WHEN Goal.G_Desc = 'HEADER' THEN 1 ELSE 0 END) / COUNT(*)) * 100 AS HEADERS_PERCENT
FROM TEAM
JOIN PLAYER ON TEAM.T_ID = PLAYER.PlayerTID JOIN GOAL ON GOAL.G_PID = PLAYER.P_ID JOIN MATCHES ON MATCHES.MID = GOAL.G_MID
WHERE MATCHES.MDatenTime LIKE '%2020%'
GROUP BY TEAM.T_ID, TEAM.TNAME
ORDER BY HEADERS_PERCENT DESC

--Q15
select top(1) Manager.FName, Manager.LName, wins.Coun as Wins from Manager inner join ( select Team.T_ID as Team_ID ,count(Matches.MID) as Coun from Matches inner join Team 
ON (Matches.HomeTID = Team.T_ID AND Matches.HTScore>Matches.ATScore) OR(Matches.AwayTID=Team.T_ID AND Matches.HTScore<Matches.ATScore)
group by Team.T_ID) as wins
ON Manager.M_TID = wins.Team_ID
inner join  Matches ON (Matches.HomeTID = wins.Team_ID OR Matches.AwayTID = wins.Team_ID ) inner join Dates
ON Matches.MDatenTime = Dates.DatenTime
order by wins.Coun desc

--Bonus Mark
SELECT Team.T_ID, Team.TName, Dates.Season  
FROM Matches INNER JOIN Team ON 
(Matches.HomeTID = Team.T_ID AND Matches.HTScore>Matches.ATScore ) 
OR ( Matches.AwayTID = Team.T_ID AND Matches.HTScore < Matches.ATScore) 
inner join ( Select Dates.Season , Max(Dates.DatenTime ) as FMatch from Dates group by Dates.Season) AS FINALS
ON Finals.FMatch = Matches.MDatenTime
inner join Dates ON Dates.DatenTime=Matches.MDatenTime
order by Season



