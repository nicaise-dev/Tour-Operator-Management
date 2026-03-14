C-- TOUR MANAGEMENT DATABASE

-- 1. Person
CREATE TABLE Person (
    PersonID      INT PRIMARY KEY,
    Sex           CHAR(1),
    Age           TINYINT,
    Date_of_birth DATE,
    Statue        VARCHAR(100),
    Name          VARCHAR(255) NOT NULL,
    ContactID     INT,
    AddressID     INT,
    Column_info   VARCHAR(255)
);

-- 2. Address
CREATE TABLE Address (
    AddressID    INT PRIMARY KEY,
    Country      VARCHAR(100),
    State        VARCHAR(100),
    City         VARCHAR(100),
    Street       VARCHAR(255),
    Street_Num   SMALLINT,
    POBox_num    INT,
    Mail_address VARCHAR(255),
    PersonID     INT,
    ContactID    INT,
    FOREIGN KEY (PersonID) REFERENCES Person(PersonID)
);

-- 3. Contract
CREATE TABLE Contract (
    ContractID        INT PRIMARY KEY,
    Type              VARCHAR(100),
    Date_of_debut     DATE,
    Valid_date        DATE,
    Pricing_system    VARCHAR(100),
    Constraints       TEXT,
    Financial_penalty DECIMAL(12,2),
    PlaceID           INT
);

-- 4. Place
CREATE TABLE Place (
    PlaceID       INT PRIMARY KEY,
    ContractID    INT,
    Address       VARCHAR(255),
    Provider_name VARCHAR(255),
    FOREIGN KEY (ContractID) REFERENCES Contract(ContractID)
);

-- 5. Accomodation  (weak entity — depends on Contract)
CREATE TABLE Accomodation (
    ContractID  INT,
    Type        VARCHAR(100),
    PRIMARY KEY (ContractID),
    FOREIGN KEY (ContractID) REFERENCES Contract(ContractID)
        ON DELETE CASCADE
);

-- 6. Itinerary
CREATE TABLE Itinerary (
    ItineraryID        INT PRIMARY KEY,
    ContractID         INT,
    Breakfast_place    VARCHAR(255),
    Lunch_place        VARCHAR(255),
    Dinner_place       VARCHAR(255),
    Accomodation_place VARCHAR(255),
    Description        TEXT,
    FOREIGN KEY (ContractID) REFERENCES Contract(ContractID)
);

-- 7. Tour
CREATE TABLE Tour (
    TourID      INT PRIMARY KEY,
    ItineraryID INT,
    Dates       DATE,
    GuideID     INT,
    Status      VARCHAR(50),
    Designation VARCHAR(255),
    FOREIGN KEY (ItineraryID) REFERENCES Itinerary(ItineraryID)
);

-- 8. Guide
CREATE TABLE Guide (
    Guide_ContractID INT PRIMARY KEY,
    PersonID         INT,
    TourID           INT,
    Payment          DECIMAL(12,2),
    FOREIGN KEY (PersonID)  REFERENCES Person(PersonID),
    FOREIGN KEY (TourID)    REFERENCES Tour(TourID)
);

-- 9. Customer  (associative/junction table)
CREATE TABLE Customer (
    PersonID  INT,
    TourID    INT,
    AddressID INT,
    PRIMARY KEY (PersonID, TourID),
    FOREIGN KEY (PersonID)  REFERENCES Person(PersonID),
    FOREIGN KEY (TourID)    REFERENCES Tour(TourID),
    FOREIGN KEY (AddressID) REFERENCES Address(AddressID)
);

-- 10. Mail  (weak entity — depends on Person)
CREATE TABLE Mail (
    PersonID      INT,
    AddressID     INT,
    Email_Address VARCHAR(255) NOT NULL,
    PRIMARY KEY (PersonID, Email_Address),
    FOREIGN KEY (PersonID)  REFERENCES Person(PersonID)
        ON DELETE CASCADE,
    FOREIGN KEY (AddressID) REFERENCES Address(AddressID)
);

-- 11. Phone  (weak entity — depends on Person)
CREATE TABLE Phone (
    PersonID  INT,
    AddressID INT,
    Phone_num VARCHAR(20),
    PRIMARY KEY (PersonID, Phone_num),
    FOREIGN KEY (PersonID)  REFERENCES Person(PersonID)
        ON DELETE CASCADE,
    FOREIGN KEY (AddressID) REFERENCES Address(AddressID)
);

-- Deferred FK constraints (circular references)

ALTER TABLE Person
    ADD CONSTRAINT fk_person_address
    FOREIGN KEY (AddressID) REFERENCES Address(AddressID);

ALTER TABLE Contract
    ADD CONSTRAINT fk_contract_place
    FOREIGN KEY (PlaceID) REFERENCES Place(PlaceID);

ALTER TABLE Tour
    ADD CONSTRAINT fk_tour_guide
    FOREIGN KEY (GuideID) REFERENCES Guide(Guide_ContractID);