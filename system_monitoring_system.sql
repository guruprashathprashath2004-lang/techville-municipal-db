-- =============================================TASK 04=============================================

-- =============================================
-- Sensor Monitoring System Database
-- Created by: Guru Prashath
-- Registration No: KD/HDCSE/CMU/79/05
-- =============================================

-- ================================================================================================
-- ============================================ TABLES ============================================
-- ================================================================================================

-- ======================== USER TABLE =======================

CREATE TABLE [User] (

    UserID       CHAR(4) CHECK (UserID LIKE '[U][0-9][0-9][0-9]'),
    FName        VARCHAR(20) NOT NULL,
    LName        VARCHAR(20) NOT NULL,
    Email        VARCHAR(40) NOT NULL UNIQUE,
    PasswordHash VARCHAR(20) NOT NULL,
    User_Type    VARCHAR(10) NOT NULL CHECK (User_Type IN ('Admin','Customer','Technician','Analyst')),

    CONSTRAINT User_PK PRIMARY KEY (UserID)
);

-- ==================== POSTAL_AREA TABLE ===================

CREATE TABLE Postal_Area (

    PostalCode VARCHAR(10),
    City       VARCHAR(20) NOT NULL,
    State      VARCHAR(20) NOT NULL,
    Street     VARCHAR(20) NULL,

    CONSTRAINT Postal_Area_PK PRIMARY KEY (PostalCode)
);

-- ===================== LOCATION TABLE =====================

CREATE TABLE Location (

    LocationID CHAR(4) CHECK ( LocationID Like '[L][0-9][0-9][0-9]' ),
    ZoneName   VARCHAR(15) NOT NULL,
    Latitude   DECIMAL(9,5) NULL,
    Longitude  DECIMAL(9,5) NULL,
    PostalCode VARCHAR(10) NOT NULL,

    CONSTRAINT Location_PK PRIMARY KEY (LocationID),
    CONSTRAINT Location_FK FOREIGN KEY (PostalCode) REFERENCES Postal_Area (PostalCode)
);

-- =================== SENSOR_MODEL TABLE =================== 

CREATE TABLE Sensor_Model (

    ModelName   VARCHAR(20) NOT NULL,
    Sensor_Type VARCHAR(30) NOT NULL,
    Version     VARCHAR(20) NULL,

    CONSTRAINT Sensor_Model_PK PRIMARY KEY (ModelName)
);

-- ========================= SENSOR =========================

CREATE TABLE Sensor (

    SensorID       CHAR(4) CHECK ( SensorID Like '[S][0-9][0-9][0-9]' ),
    DeploymentDate DATE NULL,
    ModelName      VARCHAR(20) NOT NULL,
    Status         VARCHAR(20) NOT NULL CHECK (Status IN ('Active','Inactive','Maintenance','Decommissioned')),
    LocationID     CHAR(4) NOT NULL,

    CONSTRAINT Sensor_PK PRIMARY KEY (SensorID),
    CONSTRAINT Sensor_FK1 FOREIGN KEY (ModelName) REFERENCES Sensor_Model (ModelName),
    CONSTRAINT Sensor_FK2 FOREIGN KEY (LocationID) REFERENCES Location (LocationID)
);

-- ====================== EVENT TABLE ======================

CREATE TABLE [Event] (

    EventID     CHAR(4) CHECK ( EventID Like '[E][0-9][0-9][0-9]' ),
    Event_Type  VARCHAR(30) NOT NULL,
    Description VARCHAR(400) NULL,
    Severity    VARCHAR(10) NOT NULL CHECK (Severity IN ('Low','Medium','High','Critical')),
    Start_Time  DATETIME NOT NULL,
    End_Time    DATETIME NULL,
    LocationID  CHAR(4) NOT NULL,
    SensorID    CHAR(4) NOT NULL,

    CONSTRAINT Event_PK PRIMARY KEY (EventID),
    CONSTRAINT Event_FK1 FOREIGN KEY (LocationID) REFERENCES Location (LocationID),
    CONSTRAINT Event_FK2 FOREIGN KEY (SensorID) REFERENCES Sensor (SensorID)
);

-- ====================== ACTION TABLE ======================

CREATE TABLE [Action] (

    ActionID    CHAR(4) CHECK ( ActionID Like '[A][0-9][0-9][0-9]' ),
    Description VARCHAR(400) NULL,
    Status      VARCHAR(15) NULL,
    Action_Type VARCHAR(30) NULL,
    TimeStamp   DATETIME NOT NULL,
    UserID      CHAR(4) NOT NULL,
    EventID     CHAR(4) NOT NULL, 

    CONSTRAINT Action_PK PRIMARY KEY (ActionID),
    CONSTRAINT Action_FK1 FOREIGN KEY (UserID) REFERENCES [User] (UserID),
    CONSTRAINT Action_FK2 FOREIGN KEY (EventID) REFERENCES [Event] (EventID)
);

-- ====================== REPORT TABLE ======================

CREATE TABLE Report (

    ReportID    CHAR(5) CHECK ( ReportID Like '[R][P][0-9][0-9][0-9]' ),
    Report_Type VARCHAR(30) NOT NULL,
    Title       VARCHAR(200) NOT NULL,
    GeneratedOn DATETIME NOT NULL,
    UserID      CHAR(4) NOT NULL,

    CONSTRAINT Report_PK PRIMARY KEY (ReportID),
    CONSTRAINT FK_Report_User FOREIGN KEY (UserID) REFERENCES [User] (UserID)
);

-- ================== SENSOR_READING TABLE ==================

CREATE TABLE Sensor_Reading (

    ReadingID CHAR(5) CHECK ( ReadingID Like '[R][D][0-9][0-9][0-9]' ),   
    Value     DECIMAL(9,5) NOT NULL,
    Unit      VARCHAR(10) NOT NULL,
    TimeStamp DATETIME NOT NULL,
    SensorID  CHAR(4) NOT NULL,

    CONSTRAINT Sensor_Reading_PK PRIMARY KEY (ReadingID),
    CONSTRAINT Sensor_Reading_FK FOREIGN KEY (SensorID) REFERENCES Sensor (SensorID)
);

-- =================== REPORT_DETAIL TABLE =================== 

CREATE TABLE Report_Detail (

    ReportID  CHAR(5) NOT NULL,
    ReadingID CHAR(5) NOT NULL,

    CONSTRAINT Report_Detail_PK PRIMARY KEY (ReportID, ReadingID),
    CONSTRAINT Report_Detail_FK1 FOREIGN KEY (ReportID) REFERENCES Report (ReportID),
    CONSTRAINT Report_Detail_FK2 FOREIGN KEY (ReadingID) REFERENCES Sensor_Reading (ReadingID)
);



-- ================================================================================================
-- ======================================== ADDING RECORDS ========================================
-- ================================================================================================

-- ====================== USER RECORDS ======================
INSERT INTO [User] (UserID, FName, LName, Email, PasswordHash, User_Type)
VALUES
   ('U001','Arun','Kumar','arun.k@example.com','hash_arun','Admin'),
   ('U002','Kaviya','Selvan','kaviya.s@example.com','hash_kaviya','Customer'),
   ('U003','Pravin','Raj','pravin.r@example.com','hash_pravin','Technician'),
   ('U004','Nithya','Kumar','nithya.k@example.com','hash_nithya','Analyst'),
   ('U005','Sarath','Siva','sarath.s@example.com','hash_sarath','Technician'),
   ('U006','Divya','Murugan','divya.m@example.com','hash_divya','Customer'),
   ('U007','Hari','Prasath','hari.p@example.com','hash_hari','Analyst'),
   ('U008','Meena','Lakshmi','meena.l@example.com','hash_meena','Customer'),
   ('U009','Karthik','Sundar','karthik.s@example.com','hash_karthik','Admin'),
   ('U010','Revathi','Ravi','revathi.r@example.com','hash_revathi','Technician'),
   ('U011','Vignesh','Mani','vignesh.m@example.com','hash_vignesh','Customer'),
   ('U012','Anitha','Suren','anitha.s@example.com','hash_anitha','Analyst'),
   ('U013','Gokul','Rajendran','gokul.r@example.com','hash_gokul','Technician'),
   ('U014','Priya','Devi','priya.d@example.com','hash_priya','Customer'),
   ('U015','Santhosh','Kannan','santhosh.k@example.com','hash_santhosh','Admin'),
   ('U016','Lavanya','Bala','lavanya.b@example.com','hash_lavanya','Customer'),
   ('U017','Ramesh','Selvakumar','ramesh.s@example.com','hash_ramesh','Technician'),
   ('U018','Kowsalya','Murali','kowsalya.m@example.com','hash_kowsalya','Analyst'),
   ('U019','Dinesh','Arul','dinesh.a@example.com','hash_dinesh','Technician'),
   ('U020','Janani','Subha','janani.s@example.com','hash_janani','Customer');

-- ====================== POSTAL_AREA RECORDS ======================
INSERT INTO Postal_Area (PostalCode, City, State, Street)
VALUES
   ('00100','Colombo','Western','Fort'),
   ('10200','Maharagama','Western','High Level Road'),
   ('10350','Dehiwala','Western','Galle Road'),
   ('10400','Negombo','Western','Main Street'),
   ('20000','Kandy','Central','Peradeniya Road'),
   ('20400','Katugastota','Central','Watapuluwa Road'),
   ('20500','Nuwara Eliya','Central','New Bazaar Street'),
   ('30000','Batticaloa','Eastern','Trincomalee Road'),
   ('31000','Trincomalee','Eastern','Dockyard Road'),
   ('32000','Ampara','Eastern','Kalmunai Road'),
   ('40000','Jaffna','Northern','Stanley Road'),
   ('41000','Vavuniya','Northern','Kandy Road'),
   ('42000','Kilinochchi','Northern','A9 Highway'),
   ('50000','Kurunegala','North Western','Negombo Road'),
   ('51000','Puttalam','North Western','Palavi Road'),
   ('60000','Matara','Southern','Hakmana Road'),
   ('61000','Galle','Southern','Wackwella Road'),
   ('70000','Ratnapura','Sabaragamuwa','Main Street'),
   ('71000','Kegalle','Sabaragamuwa','Avissawella Road'),
   ('80000','Badulla','Uva','Bandarawela Road');

-- ====================== LOCATION RECORDS ======================
INSERT INTO Location (LocationID, ZoneName, Latitude, Longitude, PostalCode)
VALUES
   ('L001','Fort',6.93300,79.85000,'00100'),
   ('L002','Maharagama',6.84280,79.92870,'10200'),
   ('L003','Dehiwala',6.84020,79.86500,'10350'),
   ('L004','Negombo',7.20830,79.83580,'10400'),
   ('L005','KandyTown',7.29060,80.63370,'20000'),
   ('L006','Katugastota',7.33330,80.61670,'20400'),
   ('L007','NuwaraEliya',6.97080,80.78290,'20500'),
   ('L008','Batticaloa',7.71700,81.70000,'30000'),
   ('L009','Trincomalee',8.56670,81.23330,'31000'),
   ('L010','Ampara',7.28330,81.66670,'32000'),
   ('L011','JaffnaTown',9.66850,80.00740,'40000'),
   ('L012','Vavuniya',8.75000,80.50000,'41000'),
   ('L013','Kilinochchi',9.40000,80.40000,'42000'),
   ('L014','Kurunegala',7.48330,80.36670,'50000'),
   ('L015','Puttalam',8.03330,79.83330,'51000'),
   ('L016','MataraTown',5.94850,80.54690,'60000'),
   ('L017','GalleTown',6.05350,80.22090,'61000'),
   ('L018','Ratnapura',6.68280,80.40370,'70000'),
   ('L019','Kegalle',7.25000,80.35000,'71000'),
   ('L020','BadullaTown',6.98330,81.06670,'80000');

-- ====================== SENSOR_MODEL RECORDS ======================
INSERT INTO Sensor_Model (ModelName, Sensor_Type, Version)
VALUES
   ('RainSenseX', 'Rainfall Sensor', 'v2.3'),
   ('AirCheck200', 'Air Quality Sensor', 'v1.8'),
   ('HydroWatch', 'Water Level Sensor', 'v3.0'),
   ('TempTrack', 'Temperature Sensor', 'v2.1'),
   ('HumidPro', 'Humidity Sensor', 'v1.5'),
   ('SoilSmart', 'Soil Moisture Sensor', 'v2.7'),
   ('FlowMeterX', 'Water Flow Sensor', 'v3.4'),
   ('WindMax', 'Wind Speed Sensor', 'v1.9'),
   ('DustScan', 'Particulate Matter Sensor', 'v2.0'),
   ('AquaPure', 'Water Quality Sensor', 'v1.6'),
   ('LightSense', 'Light Intensity Sensor', 'v1.2'),
   ('CO2Track', 'Carbon Dioxide Sensor', 'v2.5'),
   ('pHSense', 'Water pH Sensor', 'v3.1'),
   ('NoiseWatch', 'Sound Level Sensor', 'v2.8'),
   ('ThermoEdge', 'Temperature Sensor', 'v1.4'),
   ('AeroSmart', 'Air Pressure Sensor', 'v1.3'),
   ('FloodAlert', 'Flood Detection Sensor', 'v3.2'),
   ('SmokeGuard', 'Smoke Detection Sensor', 'v2.0'),
   ('UVCheck', 'UV Radiation Sensor', 'v1.9'),
   ('GasTrack', 'Gas Leakage Sensor', 'v2.6');

-- ====================== SENSOR RECORDS ======================
INSERT INTO Sensor (SensorID, DeploymentDate, ModelName, Status, LocationID)
VALUES
   ('S001','2025-08-15','RainSenseX','Active','L001'),
   ('S002','2025-08-16','AirCheck200','Active','L002'),
   ('S003','2025-08-17','HydroWatch','Maintenance','L003'),
   ('S004','2025-08-18','TempTrack','Active','L004'),
   ('S005','2025-08-19','HumidPro','Inactive','L005'),
   ('S006','2025-08-20','SoilSmart','Active','L006'),
   ('S007','2025-08-21','FlowMeterX','Decommissioned','L007'),
   ('S008','2025-08-22','WindMax','Active','L008'),
   ('S009','2025-08-23','DustScan','Maintenance','L009'),
   ('S010','2025-08-24','AquaPure','Active','L010'),
   ('S011','2025-08-25','LightSense','Inactive','L011'),
   ('S012','2025-08-26','CO2Track','Active','L012'),
   ('S013','2025-08-27','pHSense','Active','L013'),
   ('S014','2025-08-28','NoiseWatch','Maintenance','L014'),
   ('S015','2025-08-29','ThermoEdge','Active','L015'),
   ('S016','2025-08-30','AeroSmart','Decommissioned','L016'),
   ('S017','2025-08-31','FloodAlert','Active','L017'),
   ('S018','2025-09-01','SmokeGuard','Active','L018'),
   ('S019','2025-09-02','UVCheck','Inactive','L019'),
   ('S020','2025-09-03','GasTrack','Active','L020');

-- ====================== EVENT RECORDS ======================
INSERT INTO [Event] (EventID, Event_Type, Description, Severity, Start_Time, End_Time, LocationID, SensorID)
VALUES
   ('E001','Alert','High rainfall detected','High','2025-08-15 08:00:00','2025-08-15 10:00:00','L001','S001'),
   ('E002','Alert','Air quality poor due to smoke','Medium','2025-08-16 09:30:00','2025-08-16 12:00:00','L002','S002'),
   ('E003','Maintenance','Water level sensor calibration','Low','2025-08-17 14:00:00','2025-08-17 15:30:00','L003','S003'),
   ('E004','Alert','Temperature spike observed','High','2025-08-18 11:00:00','2025-08-18 12:00:00','L004','S004'),
   ('E005','Alert','Humidity below threshold','Medium','2025-08-19 07:00:00','2025-08-19 09:00:00','L005','S005'),
   ('E006','Alert','Soil moisture low','Medium','2025-08-20 10:15:00','2025-08-20 12:30:00','L006','S006'),
   ('E007','Decommission','Old water flow sensor removed','Low','2025-08-21 08:00:00','2025-08-21 08:30:00','L007','S007'),
   ('E008','Alert','High wind speed recorded','High','2025-08-22 13:00:00','2025-08-22 14:30:00','L008','S008'),
   ('E009','Maintenance','Dust sensor firmware update','Low','2025-08-23 09:00:00','2025-08-23 10:30:00','L009','S009'),
   ('E010','Alert','Water contamination detected','Critical','2025-08-24 07:30:00','2025-08-24 09:00:00','L010','S010'),
   ('E011','Alert','Low light intensity','Low','2025-08-25 18:00:00','2025-08-25 20:00:00','L011','S011'),
   ('E012','Alert','High CO2 concentration','High','2025-08-26 12:00:00','2025-08-26 14:00:00','L012','S012'),
   ('E013','Alert','Water pH abnormal','Medium','2025-08-27 08:30:00','2025-08-27 10:00:00','L013','S013'),
   ('E014','Maintenance','Noise sensor recalibration','Low','2025-08-28 09:00:00','2025-08-28 11:00:00','L014','S014'),
   ('E015','Alert','Temperature drop observed','Medium','2025-08-29 06:00:00','2025-08-29 08:00:00','L015','S015'),
   ('E016','Decommission','Old pressure sensor removed','Low','2025-08-30 10:00:00','2025-08-30 10:30:00','L016','S016'),
   ('E017','Alert','Flood detected in river','Critical','2025-08-31 07:00:00','2025-08-31 12:00:00','L017','S017'),
   ('E018','Alert','Smoke detected near factory','High','2025-09-01 14:00:00','2025-09-01 16:00:00','L018','S018'),
   ('E019','Alert','High UV radiation recorded','Medium','2025-09-02 11:00:00','2025-09-02 13:00:00','L019','S019'),
   ('E020','Alert','Gas leak detected','Critical','2025-09-03 09:00:00','2025-09-03 11:30:00','L020','S020');

-- ====================== ACTION RECORDS ======================
INSERT INTO [Action] (ActionID, Description, Status, Action_Type, TimeStamp, UserID, EventID)
VALUES
   ('A001','User login to system','Complete','Login','2025-08-15 07:50:00','U001','E001'),
   ('A002','Acknowledged high rainfall alert','Complete','Acknowledge','2025-08-15 08:05:00','U002','E001'),
   ('A003','Air quality report generated','Complete','ReportGeneration','2025-08-16 09:45:00','U003','E002'),
   ('A004','Calibrated water level sensor','Complete','Maintenance','2025-08-17 14:30:00','U004','E003'),
   ('A005','Temperature spike alert escalated','Complete','Escalation','2025-08-18 11:10:00','U005','E004'),
   ('A006','Adjusted humidity sensor settings','Complete','ConfigChange','2025-08-19 07:30:00','U006','E005'),
   ('A007','Soil moisture manual reading performed','Complete','ManualCheck','2025-08-20 10:45:00','U007','E006'),
   ('A008','Decommissioned old water flow sensor','Complete','Decommission','2025-08-21 08:15:00','U008','E007'),
   ('A009','High wind speed alert noted','Complete','Incident','2025-08-22 13:10:00','U009','E008'),
   ('A010','Dust sensor firmware updated','Complete','Maintenance','2025-08-23 09:30:00','U010','E009'),
   ('A011','Water contamination report created','Complete','ReportGeneration','2025-08-24 08:00:00','U011','E010'),
   ('A012','Low light intensity alert acknowledged','Complete','Acknowledge','2025-08-25 18:05:00','U012','E011'),
   ('A013','CO2 concentration alert escalated','Complete','Escalation','2025-08-26 12:15:00','U013','E012'),
   ('A014','Water pH manual check performed','Complete','ManualCheck','2025-08-27 09:00:00','U014','E013'),
   ('A015','Noise sensor recalibration completed','Complete','Maintenance','2025-08-28 11:00:00','U015','E014'),
   ('A016','Temperature drop alert acknowledged','Complete','Acknowledge','2025-08-29 06:30:00','U001','E015'),
   ('A017','Pressure sensor decommissioned','Complete','Decommission','2025-08-30 10:15:00','U002','E016'),
   ('A018','Flood alert escalated to authorities','Complete','Escalation','2025-08-31 07:30:00','U003','E017'),
   ('A019','Smoke near factory reported','Complete','Incident','2025-09-01 14:20:00','U004','E018'),
   ('A020','Gas leak mitigation performed','Complete','Incident','2025-09-03 09:30:00','U005','E020');

-- ====================== REPORT RECORDS ======================
INSERT INTO Report (ReportID, Report_Type, Title, GeneratedOn, UserID)
VALUES
   ('RP001','PDF','Monthly Rainfall Summary','2025-08-15 11:00:00','U001'),
   ('RP002','Excel','Air Quality Weekly Report','2025-08-16 13:00:00','U002'),
   ('RP003','PDF','Water Level Sensor Calibration Report','2025-08-17 16:00:00','U003'),
   ('RP004','PDF','Temperature Spike Analysis','2025-08-18 12:30:00','U004'),
   ('RP005','Excel','Humidity Sensor Status Report','2025-08-19 09:15:00','U005'),
   ('RP006','PDF','Soil Moisture Trends','2025-08-20 13:00:00','U006'),
   ('RP007','PDF','Decommissioned Sensors Log','2025-08-21 09:00:00','U007'),
   ('RP008','Excel','High Wind Speed Alerts','2025-08-22 15:00:00','U008'),
   ('RP009','PDF','Dust Sensor Firmware Update Summary','2025-08-23 11:00:00','U009'),
   ('RP010','PDF','Water Contamination Event Report','2025-08-24 10:00:00','U010'),
   ('RP011','Excel','Light Intensity Monitoring Report','2025-08-25 20:30:00','U011'),
   ('RP012','PDF','CO2 Concentration Alerts Summary','2025-08-26 14:30:00','U012'),
   ('RP013','PDF','Water pH Sensor Manual Check Report','2025-08-27 10:30:00','U013'),
   ('RP014','Excel','Noise Sensor Maintenance Log','2025-08-28 12:30:00','U014'),
   ('RP015','PDF','Temperature Drop Alerts','2025-08-29 08:30:00','U015'),
   ('RP016','PDF','Pressure Sensor Decommission Report','2025-08-30 10:30:00','U001'),
   ('RP017','Excel','Flood Event Escalation Report','2025-08-31 12:00:00','U002'),
   ('RP018','PDF','Smoke Detection Summary','2025-09-01 16:30:00','U003'),
   ('RP019','Excel','UV Radiation Monitoring Report','2025-09-02 13:30:00','U004'),
   ('RP020','PDF','Gas Leak Response Report','2025-09-03 12:00:00','U005');

-- ====================== SENSOR_READING RECORDS ======================
INSERT INTO Sensor_Reading (ReadingID, Value, Unit, TimeStamp, SensorID)
VALUES
   ('RD001',12.50,'mm','2025-08-15 08:10:00','S001'),
   ('RD002',80.25,'AQ','2025-08-16 09:40:00','S002'),
   ('RD003',3.50,'m','2025-08-17 14:10:00','S003'),
   ('RD004',35.70,'C','2025-08-18 11:10:00','S004'),
   ('RD005',40.25,'%','2025-08-19 07:10:00','S005'),
   ('RD006',15.50,'%','2025-08-20 10:20:00','S006'),
   ('RD007',25.00,'L/s','2025-08-21 08:10:00','S007'),
   ('RD008',60.50,'km/h','2025-08-22 13:10:00','S008'),
   ('RD009',45.20,'ug/m3','2025-08-23 09:10:00','S009'),
   ('RD010',6.80,'ppm','2025-08-24 07:40:00','S010'),
   ('RD011',120,'lux','2025-08-25 18:10:00','S011'),
   ('RD012',700,'ppm','2025-08-26 12:10:00','S012'),
   ('RD013',7.5,'pH','2025-08-27 08:40:00','S013'),
   ('RD014',55,'dB','2025-08-28 09:10:00','S014'),
   ('RD015',20.0,'C','2025-08-29 06:10:00','S015'),
   ('RD016',1015,'hPa','2025-08-30 10:10:00','S016'),
   ('RD017',5.2,'m','2025-08-31 07:10:00','S017'),
   ('RD018',250,'ppm','2025-09-01 14:10:00','S018'),
   ('RD019',9.5,'UV','2025-09-02 11:10:00','S019'),
   ('RD020',150,'ppm','2025-09-03 09:10:00','S020');

-- ====================== REPORT_DETAIL RECORDS ======================
INSERT INTO Report_Detail (ReportID, ReadingID)
VALUES
   ('RP001','RD001'),
   ('RP002','RD002'),
   ('RP003','RD003'),
   ('RP004','RD004'),
   ('RP005','RD005'),
   ('RP006','RD006'),
   ('RP007','RD007'),
   ('RP008','RD008'),
   ('RP009','RD009'),
   ('RP010','RD010'),
   ('RP011','RD011'),
   ('RP012','RD012'),
   ('RP013','RD013'),
   ('RP014','RD014'),
   ('RP015','RD015'),
   ('RP016','RD016'),
   ('RP017','RD017'),
   ('RP018','RD018'),
   ('RP019','RD019'),
   ('RP020','RD020');


---------------------------------------------------------------------------------------------------


-- ================================================================================================
-- ======================================== EXECUTE TABLES ========================================
-- ================================================================================================

SELECT * FROM [User]
SELECT * FROM Postal_Area
SELECT * FROM Location
SELECT * FROM Sensor_Model
SELECT * FROM Sensor
SELECT * FROM [Event]
SELECT * FROM [Action]
SELECT * FROM Report
SELECT * FROM Sensor_Reading
SELECT * FROM Report_Detail


-- =============================================TASK 05=============================================

-- 1 => List of details of all sensors.

SELECT 
    S.SensorID,
    SM.Sensor_Type,
    SM.ModelName,
    SM.Version,
    S.DeploymentDate,
    S.Status,
    L.ZoneName AS Location_Zone,
    PA.City,
    PA.State
FROM Sensor S INNER JOIN Sensor_Model SM ON S.ModelName = SM.ModelName
              INNER JOIN Location L ON S.LocationID = L.LocationID
              INNER JOIN Postal_Area PA ON L.PostalCode = PA.PostalCode
ORDER BY S.SensorID;


-- 2 => List of environmental data of a specific sensor.

SELECT 
    SR.ReadingID,
    SR.SensorID,
    S.ModelName,
    SM.Sensor_Type,
    SR.Value,
    SR.Unit,
    SR.TimeStamp,
    L.ZoneName AS Location_Zone,
    L.Latitude,
    L.Longitude
FROM Sensor_Reading SR INNER JOIN Sensor S ON SR.SensorID = S.SensorID
                       INNER JOIN Sensor_Model SM ON S.ModelName = SM.ModelName
                       INNER JOIN Location L ON S.LocationID = L.LocationID
WHERE SR.SensorID = 'S008';

-- 3 => List of events details at a specific location.
-- Complete event details including which sensor triggered it.

SELECT 
    E.EventID,
    E.Event_Type,
    E.Description,
    E.Severity,
    E.Start_Time,
    E.End_Time,
    S.SensorID,
    SM.ModelName,
    SM.Sensor_Type,
    L.ZoneName AS Location_Zone,
    L.Latitude,
    L.Longitude
FROM [Event] E INNER JOIN Sensor S ON E.SensorID = S.SensorID
               INNER JOIN Sensor_Model SM ON S.ModelName = SM.ModelName
               INNER JOIN Location L ON E.LocationID = L.LocationID
WHERE L.ZoneName = 'BadullaTown';----Detailed Answer 
                                  --(Event + Sensor + Model + Location)

-- 4 => List of average pollution level at each location.                               

SELECT 
    L.LocationID,
    L.ZoneName AS Location_Zone,
    AVG(SR.Value) AS [Average Pollution Level]
FROM Location L INNER JOIN Sensor S ON L.LocationID = S.LocationID
                INNER JOIN Sensor_Reading SR ON S.SensorID = SR.SensorID
GROUP BY L.LocationID, L.ZoneName;

-- 5 => List of all locations that have experienced more than 5 environmental events 
--      (pollution spikes or hazardous material leaks) in the last 30 days.

SELECT 
    L.LocationID,                        
    L.ZoneName AS Location_Zone,                           
    COUNT(E.EventID) AS [EventCount] 
FROM [Event] E INNER JOIN Location L ON E.LocationID = L.LocationID 
WHERE 
    (E.Event_Type LIKE '%pollution%' OR E.Event_Type LIKE '%hazardous%') 
    AND E.Start_Time >= DATEADD(DAY, -30, GETDATE())    
GROUP BY L.LocationID, L.ZoneName
HAVING COUNT(E.EventID) > 5                               
ORDER BY  COUNT(E.EventID) DESC;                              




-- ================================================================================================
-- ======================================== DROP TABLES ========================================
-- ================================================================================================

DROP TABLE Report_Detail
DROP TABLE Sensor_Reading
DROP TABLE Report
DROP TABLE [Action]
DROP TABLE [Event]
DROP TABLE Sensor
DROP TABLE Sensor_Model
DROP TABLE Location
DROP TABLE Postal_Area
DROP TABLE [User]


