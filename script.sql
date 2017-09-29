/*
Christopher Lam, lamcy1@uci.edu, 58939588
Thanh Do, thanhhd@uci.edu, 43671918
Bryan Oliande, boliande@uci.edu,13729240
*/


DROP DATABASE IF EXISTS `cs122a`;
CREATE DATABASE `cs122a`;
USE `cs122a`;

CREATE TABLE Building
(
BID		    int PRIMARY KEY,
Street		varchar(50) NOT NULL,
City		varchar(50) NOT NULL,
zipcode		int NOT NULL,
State		varchar(50) NOT NULL,
Name		varchar(50) NOT NULL
);

CREATE TABLE LocationObject
(
LOID		int PRIMARY KEY,
Name		varchar(50) NOT NULL,
LocationObjectType ENUM('Room', 'Corridor', 'OpenArea'),
BID int NOT NULL,
FOREIGN KEY(BID)
	REFERENCES Building(BID),
lowerLeftX 	int NOT NULL,
lowerLeftY  int NOT NULL,
upperRightX int NOT NULL,
upperRightY int NOT NULL,
floor		int NOT NULL
);

CREATE TABLE PartOf
(
BID int NOT NULL,
FOREIGN KEY(BID) 
	REFERENCES Building(BID),
LOID int NOT NULL,
FOREIGN KEY(LOID)
	REFERENCES LocationObject(LOID),
floor int NOT NULL
);

CREATE TABLE Room
(
LOID int NOT NULL,
FOREIGN KEY(LOID)
	REFERENCES LocationObject(LOID),
Name		varchar(50) NOT NULL,
lowerLeftX 	int NOT NULL,
lowerLeftY 	int NOT NULL,
upperRightX int NOT NULL,
upperRightY int NOT NULL,
capacity 	int NOT NULL,
number 		int NOT NULL
);

CREATE TABLE Corridor
(
LOID int NOT NULL,
FOREIGN KEY(LOID)
	REFERENCES LocationObject(LOID),
Name		varchar(50) NOT NULL,
lowerLeftX 	int NOT NULL,
lowerLeftY  int NOT NULL,
upperRightX int NOT NULL,
upperRightY int NOT NULL
);

CREATE TABLE OpenArea
(
LOID int NOT NULL,
FOREIGN KEY(LOID)
	REFERENCES LocationObject(LOID),
Name		varchar(50) NOT NULL,
lowerLeftX 	int NOT NULL,
lowerLeftY  int NOT NULL,
upperRightX int NOT NULL,
upperRightY int NOT NULL
);

CREATE TABLE Office
(
LOID int NOT NULL,
FOREIGN KEY(LOID)
	REFERENCES LocationObject(LOID)
);

CREATE TABLE MeetingRoom
(
LOID int NOT NULL,
FOREIGN KEY(LOID)
	REFERENCES LocationObject(LOID)
);

CREATE TABLE Person
(
PID int PRIMARY KEY,
LOID int NOT NULL,
FOREIGN KEY(LOID)
	REFERENCES LocationObject(LOID),
firstName varchar(50) NOT NULL,
lastName varchar(50) NOT NULL
);

CREATE TABLE AssignedTo
(
PID int NOT NULL,
FOREIGN KEY(PID)
	REFERENCES Person(PID),
LOID int NOT NULL,
FOREIGN KEY(LOID)
	REFERENCES LocationObject(LOID)
);

CREATE TABLE Event
(
EID int PRIMARY KEY,
LOID int NOT NULL,
FOREIGN KEY(LOID)
	REFERENCES LocationObject(LOID),
Confidence int NOT NULL,
Activity ENUM('Entering', 'Walking', 'Running', 'Bending', 'Standing')
);

CREATE TABLE TookPlace
(
LOID int NOT NULL,
FOREIGN KEY(LOID)
	REFERENCES LocationObject(LOID),
EID int NOT NULL,
FOREIGN KEY(EID)
	REFERENCES Event(EID)
);

CREATE TABLE Participated
(
EID int NOT NULL,
FOREIGN KEY(EID)
	REFERENCES Event(EID),
PID int NOT NULL,
FOREIGN KEY(PID)
	REFERENCES Person(PID)
);

CREATE TABLE Sensor
(
SID		int PRIMARY KEY,
name	varchar(50) NOT NULL,
SensorType ENUM('ImageSensor', 'TemperatureSensor', 'GPSSensor', 'LocationSensor')
);

CREATE TABLE SensorPlatform
(
SPID int PRIMARY KEY,
Name varchar(50) NOT NULL,
SensorPlatformType ENUM('MobilePlatform', 'FixedPlatform')
);

CREATE TABLE SensorHasSensorPlatform
(
SID int NOT NULL,
FOREIGN KEY(SID)
	REFERENCES Sensor(SID),
SPID int NOT NULL,
FOREIGN KEY(SPID)
	REFERENCES SensorPlatform(SPID)
);

CREATE TABLE OwnerOf
(
PID int NOT NULL,
FOREIGN KEY(PID)
	REFERENCES Person(PID),
SPID int NOT NULL,
FOREIGN KEY(SPID)
	REFERENCES SensorPlatform(SPID)
);

CREATE TABLE MobilePlatform
(
SPID int NOT NULL,
FOREIGN KEY(SPID)
	REFERENCES SensorPlatform(SPID),
Name varchar(50) NOT NULL
);

CREATE TABLE FixedPlatform
(
SPID int NOT NULL,
FOREIGN KEY(SPID)
	REFERENCES SensorPlatform(SPID),
Name varchar(50) NOT NULL
);

CREATE TABLE PositionedAt
(
SPID int NOT NULL,
FOREIGN KEY(SPID)
	REFERENCES SensorPlatform(SPID),
LOID int NOT NULL,
FOREIGN KEY(LOID)
	REFERENCES LocationObject(LOID)
);

CREATE TABLE LocationSensorHasMobilePlatform
(
SID int NOT NULL,
FOREIGN KEY(SID)
	REFERENCES Sensor(SID),
SPID int NOT NULL,
FOREIGN KEY(SPID)
	REFERENCES SensorPlatform(SPID)
);

CREATE TABLE Observation
(
OID int UNIQUE,
SID int NOT NULL,
FOREIGN KEY(SID)
	REFERENCES Sensor(SID),
ObservationType ENUM('RawImage', 'RawTemperature', 'RawGPS')
);

CREATE TABLE LocationSensor
(
SID int NOT NULL,
FOREIGN KEY(SID)
	REFERENCES Sensor(SID),
RealTime boolean NOT NULL
);

CREATE TABLE ImageSensor
(
Resolution ENUM('720x480', '1280x720', '2048x1080'),
Name varchar(50) NOT NULL,
SID int NOT NULL,
FOREIGN KEY(SID)
	REFERENCES Sensor(SID)     
);

CREATE TABLE TemperatureSensor
(
MetricSystem ENUM('Celsius', 'Kelvin'),
Name varchar(50) NOT NULL,
SID int NOT NULL,
FOREIGN KEY(SID)
	REFERENCES Sensor(SID)     
);

CREATE TABLE GPSSensor
(
Power decimal NOT NULL,
Name varchar(50) NOT NULL,
SID int NOT NULL,
FOREIGN KEY(SID)
	REFERENCES Sensor(SID)     
);

CREATE TABLE RawImage
(
Image VARBINARY(1000) NOT NULL,
Timestamp timestamp NOT NULL,
SID int NOT NULL,
FOREIGN KEY(SID)
	REFERENCES Sensor(SID)
);

CREATE TABLE RawTemperature
(
Temperature decimal NOT NULL,
Timestamp timestamp NOT NULL,
SID int NOT NULL,
FOREIGN KEY(SID)
	REFERENCES Sensor(SID)
);

CREATE TABLE RawGPS
(
Longitude decimal NOT NULL,
Latitude decimal NOT NULL,
Timestamp timestamp NOT NULL,
SID int NOT NULL,
FOREIGN KEY(SID)
	REFERENCES Sensor(SID)
);

CREATE TABLE DerivedFrom
(
OID int NOT NULL,
FOREIGN KEY(OID)
	REFERENCES Observation(OID),
SID int NOT NULL,
FOREIGN KEY(SID)
	REFERENCES Sensor(SID),
EID int NOT NULL,
FOREIGN KEY(EID)
	REFERENCES Event(EID)
);
