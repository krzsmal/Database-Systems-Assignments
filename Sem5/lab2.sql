SET SERVEROUTPUT ON

-- Task 1
CREATE OR REPLACE PROCEDURE NowyPracownik
    (pNazwisko IN VARCHAR,
    pNazwaZespolu IN VARCHAR,
    pNazwiskoSzefa IN VARCHAR,
    pPlacaPodstawowa IN NUMBER,
    pEtat IN VARCHAR DEFAULT 'STAZYSTA',
    pDataZatrudnienia IN DATE DEFAULT SYSDATE)
IS
    vIdPracownika PRACOWNICY.ID_PRAC%TYPE;
    vIdSzefa PRACOWNICY.ID_PRAC%TYPE;
    vIdZespolu ZESPOLY.ID_ZESP%TYPE;
BEGIN
	SELECT MAX(ID_PRAC)+1 INTO vIdPracownika FROM PRACOWNICY;
	SELECT ID_PRAC INTO vIdSzefa FROM PRACOWNICY WHERE NAZWISKO=pNazwiskoSzefa;
	SELECT ID_ZESP INTO vIdZespolu FROM ZESPOLY WHERE NAZWA=pNazwaZespolu;

	INSERT INTO Pracownicy (ID_PRAC, NAZWISKO, ETAT, ID_SZEFA, ZATRUDNIONY, PLACA_POD, ID_ZESP)
	VALUES (vIdPracownika, pNazwisko, pEtat, vIdSzefa, pDataZatrudnienia, pPlacaPodstawowa, vIdZespolu);
END NowyPracownik;

EXEC NowyPracownik('DYNDALSKI','ALGORYTMY','BLAZEWICZ',250);

SELECT * FROM Pracownicy WHERE nazwisko = 'DYNDALSKI';

-- Task 2
CREATE OR REPLACE FUNCTION PlacaNetto
    (pPlacaBrutto IN NATURAL,
    pPodatek IN NATURAL DEFAULT 20)
    RETURN NUMBER IS
    vPlacaNetto NUMBER(7,2);
BEGIN
    vPlacaNetto:=pPlacaBrutto*(1-(pPodatek/100));
    RETURN vPlacaNetto;
END PlacaNetto;


SELECT nazwisko, placa_pod AS BRUTTO,
PlacaNetto(placa_pod, 35) AS NETTO
FROM Pracownicy WHERE etat = 'PROFESOR' ORDER BY nazwisko;
 
 -- Task 3
CREATE OR REPLACE FUNCTION Silnia
    (pN IN NATURAL)
    RETURN NUMBER IS
    vWynik NUMBER := 1;
BEGIN
    IF pN != 0 THEN
        FOR vIndeks IN 1..pN LOOP
            vWynik := vWynik * vIndeks;
        END LOOP;
    END IF;
    RETURN vWynik;
END Silnia;

SELECT Silnia (10) FROM DUAL;

-- Task 4
CREATE OR REPLACE FUNCTION SilniaRek
    (pN IN NATURAL)
    RETURN NUMBER IS
    vWynik NUMBER := 1;
BEGIN
    IF pN != 0 THEN
        RETURN pN*SilniaRek(pN-1);
    ELSE
        RETURN vWynik;
    END IF;
END SilniaRek;

SELECT SilniaRek (10) FROM DUAL;

-- Task 5
CREATE OR REPLACE FUNCTION IleLat
    (pData IN DATE)
    RETURN NATURAL IS
    vLata NATURAL;
BEGIN
    vLata := FLOOR((SYSDATE - pData)/365);
    RETURN vLata;
END IleLat;

SELECT nazwisko, zatrudniony, IleLat(zatrudniony) AS staz
FROM Pracownicy WHERE placa_pod > 1000
ORDER BY nazwisko;

-- Task 6
CREATE OR REPLACE PACKAGE Konwersja IS
    FUNCTION Cels_To_Fahr
        (pStopnie IN NUMBER)
        RETURN NUMBER;
    
	FUNCTION Fahr_To_Cels
        (pStopnie IN NUMBER)
        RETURN NUMBER;
END Konwersja;

CREATE OR REPLACE PACKAGE BODY Konwersja IS
    FUNCTION Cels_To_Fahr
        (pStopnie IN NUMBER)
        RETURN NUMBER IS
        vWynik NUMBER(10,2);
    BEGIN
        vWynik := 9/5 * pStopnie + 32;
        RETURN vWynik;
    END Cels_To_Fahr;
    
	FUNCTION Fahr_To_Cels
        (pStopnie IN NUMBER)
        RETURN NUMBER IS
        vWynik NUMBER(10,2);
    BEGIN
        vWynik := 5/9 * (pStopnie - 32);
        RETURN vWynik;
    END Fahr_To_Cels;
END Konwersja;

SELECT Konwersja.Fahr_To_Cels(212) AS CELSJUSZ FROM Dual;

SELECT Konwersja.Cels_To_Fahr(0) AS FAHRENHEIT FROM Dual;

-- Task 7
CREATE OR REPLACE PACKAGE Zmienne IS
    vLicznik NUMBER := 0;
    
    PROCEDURE ZwiekszLicznik;
    
    PROCEDURE ZmniejszLicznik;
    
    FUNCTION PokazLicznik
        RETURN NUMBER;
END Zmienne;

CREATE OR REPLACE PACKAGE BODY Zmienne IS

    PROCEDURE ZwiekszLicznik
        IS
    BEGIN
        vLicznik := vLicznik + 1;
    END ZwiekszLicznik;


    PROCEDURE ZmniejszLicznik
        IS
    BEGIN
        vLicznik := vLicznik - 1;
    END ZmniejszLicznik;


    FUNCTION PokazLicznik
        RETURN NUMBER IS
    BEGIN
        RETURN vLicznik;
    END PokazLicznik;

    BEGIN
        vLicznik := 1;
        DBMS_OUTPUT.PUT_LINE('Zainicjalizowano');
END Zmienne;

BEGIN
    dbms_output.put_line(Zmienne.PokazLicznik);
END;

BEGIN
    Zmienne.ZwiekszLicznik;
    DBMS_OUTPUT.PUT_LINE(Zmienne.PokazLicznik);
    Zmienne.ZwiekszLicznik;
    DBMS_OUTPUT.PUT_LINE (Zmienne.PokazLicznik);
END;

BEGIN
    DBMS_OUTPUT.PUT_LINE (Zmienne.PokazLicznik);
    Zmienne.ZmniejszLicznik;
    DBMS_OUTPUT.PUT_LINE (Zmienne.PokazLicznik);
END;

-- Task 8
CREATE OR REPLACE PACKAGE IntZespoly IS
    PROCEDURE Create_Team
        (pName ZESPOLY.NAZWA%TYPE, pAddress ZESPOLY.ADRES%TYPE);

    PROCEDURE Delete_Team
        (pId ZESPOLY.ID_ZESP%TYPE);

    PROCEDURE Delete_Team
        (pName ZESPOLY.NAZWA%TYPE);
    
    PROCEDURE Update_Team
        (pId ZESPOLY.ID_ZESP%TYPE,
        pName ZESPOLY.NAZWA%TYPE,
        pAddress ZESPOLY.ADRES%TYPE);

    FUNCTION Get_Id
        (pName IN ZESPOLY.NAZWA%TYPE)
        RETURN ZESPOLY.ID_ZESP%TYPE;

    FUNCTION Get_Name
        (pId IN ZESPOLY.ID_ZESP%TYPE)
        RETURN ZESPOLY.NAZWA%TYPE;

    FUNCTION Get_Address
        (pId IN ZESPOLY.ID_ZESP%TYPE)
        RETURN ZESPOLY.ADRES%TYPE;
END IntZespoly;

CREATE OR REPLACE PACKAGE BODY IntZespoly IS
    PROCEDURE Create_Team
        (pName ZESPOLY.NAZWA%TYPE, pAddress ZESPOLY.ADRES%TYPE) IS
        vId ZESPOLY.ID_ZESP%TYPE;
    BEGIN
	    SELECT MAX(ID_ZESP)+1 INTO vId FROM ZESPOLY;
        INSERT INTO ZESPOLY(ID_ZESP, NAZWA, ADRES)
        VALUES(vId, pName, pAddress);
        DBMS_OUTPUT.PUT_LINE('Dodano nowy zespół o id: ' || vId || ', nazwie: ' || pName || ' i adresie: ' || pAddress);
    END Create_Team;

    PROCEDURE Delete_Team
        (pId ZESPOLY.ID_ZESP%TYPE) IS
    BEGIN
        DELETE FROM ZESPOLY WHERE ID_ZESP=pId;
    END Delete_Team;

    PROCEDURE Delete_Team
        (pName ZESPOLY.NAZWA%TYPE) IS
    BEGIN
        DELETE FROM ZESPOLY WHERE NAZWA=pName;
    END Delete_Team;

    PROCEDURE Update_Team
        (pId ZESPOLY.ID_ZESP%TYPE,
        pName ZESPOLY.NAZWA%TYPE,
        pAddress ZESPOLY.ADRES%TYPE) IS
    BEGIN
        UPDATE ZESPOLY
        SET NAZWA = pName, ADRES = pAddress
        WHERE ID_ZESP = pId;
    END Update_Team;

    FUNCTION Get_Id
        (pName IN ZESPOLY.NAZWA%TYPE)
        RETURN ZESPOLY.ID_ZESP%TYPE IS
        vId ZESPOLY.ID_ZESP%TYPE;
    BEGIN
        SELECT ID_ZESP INTO vId FROM ZESPOLY WHERE NAZWA=pName;
        RETURN vId;
    END Get_Id;
    
    FUNCTION Get_Name
        (pId IN ZESPOLY.ID_ZESP%TYPE)
        RETURN ZESPOLY.NAZWA%TYPE IS
        vName ZESPOLY.NAZWA%TYPE;
    BEGIN
        SELECT NAZWA INTO vName FROM ZESPOLY WHERE ID_ZESP=pId;
        RETURN vName;
    END Get_Name;

    FUNCTION Get_Address
        (pId IN ZESPOLY.ID_ZESP%TYPE)
        RETURN ZESPOLY.ADRES%TYPE IS
        vAddress ZESPOLY.ADRES%TYPE;
    BEGIN
        SELECT ADRES INTO vAddress FROM ZESPOLY WHERE ID_ZESP=pId;
        RETURN vAddress;
    END Get_Address;
END IntZespoly;

EXEC IntZespoly.Create_Team('Nowy Zespol 1', 'OS. SOBIESKIEGO 26');
EXEC IntZespoly.Create_Team('Nowy Zespol 2', 'OS. SOBIESKIEGO 26');
SELECT * FROM ZESPOLY;
EXEC IntZespoly.Update_Team(51, 'TEST_N', 'TEST_A');

BEGIN
    DBMS_OUTPUT.PUT_LINE (IntZespoly.Get_Id('TEST_N'));
    DBMS_OUTPUT.PUT_LINE (IntZespoly.Get_Name(51));
    DBMS_OUTPUT.PUT_LINE (IntZespoly.Get_Address(51));
END;

SELECT * FROM ZESPOLY;
EXEC IntZespoly.Delete_Team(51);
EXEC IntZespoly.Delete_Team('Nowy Zespol 2');

-- Task 9
SELECT object_name, status
FROM User_Objects
WHERE object_type = 'PROCEDURE'
ORDER BY object_name;

SELECT object_name, status
FROM User_Objects
WHERE object_type = 'FUNCTION'
ORDER BY object_name;

SELECT object_name, object_type, status
FROM User_Objects
WHERE object_type IN ('PACKAGE', 'PACKAGE BODY')
ORDER BY object_name;

SELECT text
FROM User_Source
WHERE name = 'NOWYPRACOWNIK'
AND type = 'PROCEDURE'
ORDER BY line;

SELECT text
FROM User_Source
WHERE name = 'ILELAT'
AND type = 'FUNCTION'
ORDER BY line;

SELECT text
FROM User_Source
WHERE name = 'INTZESPOLY'
AND type = 'PACKAGE'
ORDER BY line;

SELECT text
FROM User_Source
WHERE name = 'INTZESPOLY'
AND type = 'PACKAGE BODY'
ORDER BY line;

-- Task 10
DROP FUNCTION SILNIA;
DROP FUNCTION SILNIAREK;
DROP FUNCTION ILELAT;

-- Task 11
DROP PACKAGE KONWERSJA;