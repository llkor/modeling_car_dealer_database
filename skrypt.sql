DROP TABLE Wyposazenie;
DROP TABLE Profil;
DROP TABLE mod_typ;
DROP TABLE dod_wyposazenie;
DROP TABLE Sprzedaż;
DROP TABLE Samochod;
DROP TABLE Typ_silnika;
DROP TABLE Klient;
DROP TABLE Dealer ;
DROP TABLE Ciezarowy;
DROP TABLE Osobowy;
DROP TABLE Model ;
DROP TABLE Marka;


CREATE TABLE Marka 
    (
     nazwa VARCHAR (50) NOT NULL CONSTRAINT pk_marka_nazwa PRIMARY KEY, 
     rok_załozenia INTEGER,
	 CONSTRAINT ck_marka_rok CHECK (LEN(rok_załozenia)=4)
    );

CREATE TABLE Model 
    (
     identyfikator VARCHAR (100) NOT NULL CONSTRAINT pk_model_id PRIMARY KEY, 
     nazwa VARCHAR (100) NOT NULL , 
     rok_wprowadzania INTEGER , 
     typ VARCHAR (30) NOT NULL , 
	 nastepnik VARCHAR(100) REFERENCES Model(identyfikator),
     marka_nazwa VARCHAR (50) NOT NULL REFERENCES Marka(nazwa), 
	 CONSTRAINT ck_model_typ CHECK (typ IN( 'osobowy','ciężarowy')),
	 CONSTRAINT ck_model_rok CHECK (LEN(rok_wprowadzania)= 4)
    );
CREATE TABLE Osobowy
	(
	model_id VARCHAR(100) NOT NULL FOREIGN KEY REFERENCES Model(identyfikator),
	liczba_pasazerow INT NOT NULL,
	pojemność_bagażnika INT NOT NULL
	);
CREATE TABLE Ciezarowy
    (
	model_id VARCHAR(100) NOT NULL FOREIGN KEY REFERENCES Model(identyfikator),
	ładowność INT NOT NULL
	);
CREATE TABLE Dealer 
    (
     nazwa VARCHAR (30) NOT NULL CONSTRAINT pk_dealer_nazwa PRIMARY KEY, 
     adres VARCHAR (60) NOT NULL 
    );
CREATE TABLE Klient 
    (
     id INTEGER NOT NULL CONSTRAINT pk_klient_id PRIMARY KEY, 
     imię VARCHAR (30) NOT NULL , 
     nazwisko VARCHAR (30) NOT NULL , 
     numer_telefonu INTEGER NOT NULL ,
	 CONSTRAINT ck_klient_imie CHECK (imię LIKE '[A-Z]%'),
	 CONSTRAINT ck_klient_nazwisko CHECK (nazwisko LIKE '[A-Z]%'),
	 CONSTRAINT ck_klient_numer CHECK (LEN(numer_telefonu) = 9)
	 );
CREATE TABLE Typ_silnika 
    (
     identyfikator VARCHAR (30) NOT NULL CONSTRAINT pk_silnik_id PRIMARY KEY, 
     rodzaj_paliwa VARCHAR (30) NOT NULL , 
     opis_parametrów VARCHAR (30) 
    );
CREATE TABLE Samochod 
    (
     VIN VARCHAR(17) NOT NULL CONSTRAINT pk_samochod_vin CHECK (LEN(VIN)=17) PRIMARY KEY, 
     przebieg INTEGER NOT NULL , 
     rok_produkcji INTEGER NOT NULL CONSTRAINT ck_samochod_rok CHECK (LEN(rok_produkcji)=4), 
     kraj_pochodzenia VARCHAR (30) NOT NULL , 
     skrzynia_biegów VARCHAR (50) NOT NULL , 
     model VARCHAR (100) NOT NULL REFERENCES Model(identyfikator),
     typ_silnika VARCHAR (30) NOT NULL REFERENCES Typ_Silnika(identyfikator), 
     dealer VARCHAR (30) NOT NULL REFERENCES Dealer(nazwa),
	 
	
    );
CREATE TABLE Sprzedaż 
    (
	 data_s DATETIME NOT NULL ,
     cena MONEY NOT NULL , 
     Dealer_nazwa VARCHAR (30) NOT NULL REFERENCES Dealer(nazwa), 
     Klient_id INTEGER NOT NULL REFERENCES Klient(id), 
     Samochod_VIN VARCHAR(17) NOT NULL REFERENCES Samochod(VIN),
	 PRIMARY KEY(data_s,Dealer_nazwa, Klient_id, Samochod_VIN)
    );
CREATE TABLE dod_wyposazenie 
    (
     nazwa VARCHAR (30) NOT NULL CONSTRAINT pk_wyposazenie_nazwa PRIMARY KEY 
    );
CREATE TABLE mod_typ
    (
	silnik_id VARCHAR (30) REFERENCES Typ_silnika(identyfikator),
	model_id VARCHAR (100) REFERENCES Model(identyfikator),
	PRIMARY KEY(silnik_id, model_id)
	);
CREATE TABLE Profil
    (
	model_id VARCHAR (100) REFERENCES Model(identyfikator) ,
	dealer_nazwa VARCHAR (30) NOT NULL REFERENCES Dealer(nazwa),
	PRIMARY KEY(model_id, dealer_nazwa)
	);
CREATE TABLE Wyposazenie
    (
	Samochod_VIN VARCHAR(17) NOT NULL REFERENCES Samochod(VIN),
	nazwa VARCHAR (30) NOT NULL REFERENCES dod_wyposazenie(nazwa),
	PRIMARY KEY(Samochod_VIN, nazwa)
	);

	GO

INSERT INTO Marka VALUES
('Mercedes',1926),
('BMW',1916),
('Citroen', 1919);
INSERT INTO Model VALUES
('C-CLASS W204', 'W204', 2007, 'osobowy', 'C-CLASS W205', 'Mercedes'),
('C-CLASS W205', 'W205', 2014, 'osobowy', NULL, 'Mercedes'),
('Jumper L3Hz HDI', 'Jumper', 2013, 'ciężarowy', NULL, 'Citroen'),
('ActiveHybrid7(F04)', 'ActiveHybrid', 2008, 'osobowy',NULL, 'BMW');
INSERT INTO Osobowy VALUES
('C-CLASS W204', 5, 450),
('C-CLASS W205', 5, 435),
('ActiveHybrid7(F04)', 5, 278);
INSERT INTO Ciezarowy VALUES
('Jumper L3Hz HDI', 3.5);
INSERT INTO Typ_silnika VALUES
('N55', 'hybryd', 'turbo'),
('4HU', 'diesel', '2.2'),
('M274DE16AL', 'benzyn', '6l/100km');
INSERT INTO Dealer VALUES
('Autopark PREMIUM', 'Obornicka 4,Suchy Las'),
('AUTOKOMIS Twoje Używane', 'Obornicka 341,Poznań');

INSERT INTO Samochod VALUES
('WDDGJ5HB7CF796462',156000 ,2012 ,'Niemcy', 'automatyczna stopniowa', 'C-CLASS W204', 'M274DE16AL', 'Autopark PREMIUM'),
('WDDGF8AB7DF899668',70000 ,2014 ,'Niemcy', 'automatyczna stopniowa', 'C-CLASS W205', 'M274DE16AL', 'Autopark PREMIUM'),
('VF7UA5FXH9J276031',360000 ,2013 ,'Włochy', 'manualna', 'Jumper L3Hz HDI', '4HU', 'AUTOKOMIS Twoje Używane'),
('WBAUT9C50AA191254',200000 ,2010 ,'Niemcy', 'automatyczna stopniowa', 'ActiveHybrid7(F04)', 'N55', 'Autopark PREMIUM');
 
 INSERT INTO Klient VALUES
 ('1', 'Piotr', 'Makowski', 515805285),
 ('2', 'Maria', 'Lubomirska', 752963502);
 INSERT INTO Sprzedaż VALUES
 (14-09-2019, 14500, 'AUTOKOMIS Twoje Używane', '1', 'VF7UA5FXH9J276031'),
 (25-07-2020, 20000, 'Autopark PREMIUM', '2', 'WDDGF8AB7DF899668');
 INSERT INTO dod_wyposazenie VALUES
 ('Elektryczne szyby'),
 ('Podgrzewane lusterka'),
 ('Czujniki parkowania'),
 ('Klimatyzacja');
 INSERT INTO mod_typ VALUES
 ('N55','ActiveHybrid7(F04)'),
 ('4HU','Jumper L3Hz HDI'),
 ('M274DE16AL', 'C-CLASS W205'),
 ('M274DE16AL','C-CLASS W204');
 INSERT INTO Profil VALUES
 ('C-CLASS W205', 'Autopark PREMIUM'),
 ('ActiveHybrid7(F04)','Autopark PREMIUM'),
 ('C-CLASS W204', 'Autopark PREMIUM'),
 ('Jumper L3Hz HDI', 'AUTOKOMIS Twoje Używane');
 INSERT INTO Wyposazenie VALUES
 ('WDDGJ5HB7CF796462','Elektryczne szyby'),
 ('WDDGJ5HB7CF796462', 'Czujniki parkowania'),
 ('WDDGJ5HB7CF796462','Klimatyzacja'),
 ('WDDGF8AB7DF899668','Czujniki parkowania'),
 ('VF7UA5FXH9J276031', 'Elektryczne szyby'),
 ('WBAUT9C50AA191254','Klimatyzacja');

 SELECT * FROM Samochod;
 SELECT * FROM Marka;
 SELECT * FROM Model;
 SELECT * FROM Osobowy;
 SELECT * FROM Ciezarowy;
 SELECT * FROM Samochod;
 SELECT * FROM Typ_silnika;
 SELECT * FROM Typ_silnika;
 SELECT * FROM dod_wyposazenie;
 SELECT * FROM Dealer;
 SELECT * FROM Klient;
 SELECT * FROM Sprzedaż;
 SELECT * FROM Wyposazenie;