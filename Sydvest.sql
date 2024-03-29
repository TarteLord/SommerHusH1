USE [master]
GO

if exists(select * from sys.databases where name = 'SydvestDB')
begin
	drop database SydvestDB
	print 'Drop database'
end
go

CREATE DATABASE SydvestDB
 CONTAINMENT = NONE
 ON  PRIMARY 
( NAME = N'SydvestDB', FILENAME = N'C:\Program Files\Microsoft SQL Server\MSSQL14.MSSQLSERVER\MSSQL\DATA\SydvestDB.mdf' , SIZE = 8192KB , MAXSIZE = UNLIMITED, FILEGROWTH = 65536KB )
 LOG ON 
( NAME = N'SydvestDB_log', FILENAME = N'C:\Program Files\Microsoft SQL Server\MSSQL14.MSSQLSERVER\MSSQL\DATA\SydvestDB_log.ldf' , SIZE = 8192KB , MAXSIZE = 2048GB , FILEGROWTH = 65536KB )
GO

USE SydvestDB;

CREATE TABLE PostNrby
(
	postNr smallint primary key check (postNr > 999 AND postNr < 10000),
	ByNavn nvarchar(50) not null

)
GO

CREATE TABLE konsulenter
(
	konsulenterID int identity(1,1) primary key,
	Fornavn nvarchar(50) not null,
	Efternavn nvarchar(100) not null,
	Adresse nvarchar(255) not null,
	Telefon int not null,
	PostNr smallint not null foreign key references PostNrby (postNr),
	Omr�de smallint foreign key references PostNrby (postNr),
)
GO



CREATE TABLE Ejer
(
	EjerID int Identity(1,1) primary key,
	Fornavn nvarchar(50) not null,
	Efternavn nvarchar(100) not null,
	Adresse nvarchar(255) not null,
	PostNr smallint not null foreign key references PostNrby (postNr),
	Telefon int not null
)
GO



CREATE TABLE SommerHuse
(
	SommerHusID int identity(1,1) primary key,
	PostNr smallint not null foreign key references PostNrby (postNr),
	Adresse nvarchar(255) not null,
	Senge smallint not null,
	Stoerrelse smallint not null,
	Klassificering nvarchar(10), --M� gerne v�re null, hvis den ikke er blevet kvalificeret
	StandardUgePris smallint not null,
	Opsynsmand nvarchar(255) not null,
	Godkendt nvarchar(50) not null,
	EjerID int not null foreign key references Ejer (EjerID)
)
GO



CREATE TABLE Reservationer
(
	ReservationID int identity(1,1) primary key,
	SommerhusID int not null foreign key references SommerHuse (SommerHusID),
	Dage smallint not null,
	StartDato Date not null,
	S�son nvarchar(100),
	KundeTelefon int,
	Kundenavn nvarchar(255) not null,
)
GO
SET DATEFORMAT dmy;



INSERT INTO PostnrBy VALUES (4000, 'Roskilde'), 
							(2750, 'Ballerup'),
							(5000, 'Odense'  ),
							(2730, 'Herlev'  ),
							(7300, 'Jelling' ),
							(8600, 'Silkeborg'),
							(2000, 'Frederiksberg'),
							(2400, 'K�benhavn NV')
GO 


INSERT INTO Ejer VALUES ('Gunnar', 'Bo', 'Fuglebakken 88', 2730, 91929394), 
						('Lars', 'Hjortsh�j', 'Strandv�nget 22', 2750, 20304050),
						('Kim', 'Hansen', 'Sortepervej 54', 2750, 30405060)			
GO


INSERT INTO SommerHuse VALUES (2730, 'Solsortevej 24', 4, 70, 'Hustle', 4000, 'Jens karlsen', 'Godkendt',1), 
						(2750, 'Rentemestervej 77', 10, 250, 'Luksus', 10000, 'Peter Jensen', 'Godkendt',3),
						(8600, 'Silkeborgvej 63', 6, 110, 'Budget', 2600, 'Hans Bo', 'Ikke Godkendt',3)			
GO


INSERT INTO Reservationer VALUES (2, 5, '27-07-2019', 'Super', 23124376, 'bente Larsen'),
								 (3, 10, '13-07-2019', 'Super', 58736871, 'Klaus bentsen'),
								 (1, 5, '22-06-2019', 'H�j', 53807266,'Emil Dalange'),
								 (3, 5, '02-02-2019', 'Lav', 76832658,'Daniel hansen')
GO

INSERT INTO konsulenter Values ('S�ren','Pedersen','Sm�ralle 189', 85473921, 2730, 7300),
							   ('Rasmus','Jensen','Nattergalevej 64', 73254323, 2000, 2400),
							   ('Hanne','Larsen','Guldbergsgade 12', 29253446, 2400, 2000),
							   ('Hans', 'Andersen', 'Ligusterv�nget 42', 01020304, 2730, 2750), 
							   ('Bent', 'Olesen', 'Solvej 27', 50607080, 5000, 4000),
							   ('Lise', 'Pedersen', 'Nattergalevej 13', 10203040, 7300, 8600)
GO

-------------------------------------SELECT STATEMENTS----------------------------------------------------------------

--Alle ejerne kun navn og id
SELECT Ejer.EjerID, Ejer.Fornavn, Ejer.Efternavn FROM Ejer

--Speciel ejer efter ID, alle info fra Ejer tabel
SELECT * FROM Ejer WHERE EjerID = 1; 

--Speciel ejer efter ID, alle info fra Ejer tabel + Somerhuse de ejer //kan man bruge right join?
SELECT Ejer.EjerID, Ejer.Fornavn, Ejer.Efternavn, Ejer.Adresse, Ejer.PostNr, Ejer.Telefon, SommerHuse.Adresse, SommerHuse.PostNr
FROM Ejer
INNER JOIN SommerHuse ON Ejer.EjerID = SommerHuse.EjerID WHERE SommerHuse.EjerID = 3;

--SELECT Ejer.EjerID, Ejer.Fornavn, Ejer.Efternavn, Ejer.Adresse, Ejer
SELECT Ejer.EjerID, Ejer.Fornavn, Ejer.Efternavn, Ejer.Adresse, Ejer.PostNr, Ejer.Telefon FROM EJER WHERE EJER.EjerID = 2;

--Alle sommerhuse (Adresse, postnummer, id).
SELECT SommerHuse.SommerHusID,SommerHuse.Adresse, SommerHuse.PostNr FROM SommerHuse

--Et sommerhus (Alle info fra tabel + Ejernavn fra Ejer tabel
SELECT SommerHuse.SommerHusID, SommerHuse.PostNr, SommerHuse.Adresse, SommerHuse.Senge, SommerHuse.Stoerrelse, SommerHuse.Klassificering, SommerHuse.StandardUgePris, SommerHuse.Opsynsmand, SommerHuse.Godkendt, Ejer.Fornavn, Ejer.Efternavn
FROM SommerHuse
INNER JOIN Ejer ON SommerHuse.EjerID = Ejer.EjerID WHERE Ejer.EjerID = 3;

--Alle reservationer, dato + antal dage. logik for ugenumre evt i C# (Uge nummer, adresse, postnummer, kunde) OPRET KUNDE table evt.
SELECT * FROM Reservationer

--Alle udlejningskonsulenter (Fornavn, efternavn)
SELECT konsulenter.Fornavn, konsulenter.Efternavn FROM konsulenter

--Se reservationer p� p�g�ldende hus 
SELECT * FROM Reservationer WHERE ReservationID = 2;


---------------------------------UPDATES-------------------------------------------------

--Ejer rette i alt undtagen ID
UPDATE konsulenter 
SET Fornavn = '', Efternavn = '', Adresse = '', 
WHERE MedarbejderID = 2;
--Sommerhus rette i alt undtagen SommerHusID

--Reservationer
 
