SET SERVEROUTPUT ON

-- Task 1
DECLARE
    CURSOR cPracownicy IS
    SELECT NAZWISKO, ZATRUDNIONY FROM PRACOWNICY WHERE ETAT='ASYSTENT';
    vNazwisko PRACOWNICY.NAZWISKO%TYPE;
    vData PRACOWNICY.ZATRUDNIONY%TYPE;
BEGIN
    OPEN cPracownicy;
        LOOP
            FETCH cPracownicy INTO vNazwisko, vData;
            EXIT WHEN cPracownicy%NOTFOUND;
            DBMS_OUTPUT.PUT_LINE(vNazwisko || ' pracuje od ' || TO_CHAR(vData, 'DD-MM-YYYY'));
        END LOOP;
    CLOSE cPracownicy;
END;

-- Task 2
DECLARE
    CURSOR cPracownicy IS
    SELECT NAZWISKO FROM PRACOWNICY ORDER BY (placa_pod + COALESCE(placa_dod, 0)) DESC;
    vNazwisko PRACOWNICY.NAZWISKO%TYPE;
BEGIN
    OPEN cPracownicy;
        LOOP
            FETCH cPracownicy INTO vNazwisko;
            EXIT WHEN cPracownicy%ROWCOUNT = 4;
            DBMS_OUTPUT.PUT_LINE(cPracownicy%ROWCOUNT || ' : ' || vNazwisko);
        END LOOP;
    CLOSE cPracownicy;
END;

-- Task 3
SELECT NAZWISKO, PLACA_POD FROM PRACOWNICY WHERE TO_CHAR(ZATRUDNIONY, 'FMDAY') = 'MONDAY';

DECLARE
    CURSOR cPracownicy IS
    SELECT NAZWISKO, PLACA_POD FROM PRACOWNICY WHERE TO_CHAR(ZATRUDNIONY, 'FMDAY') = 'MONDAY'
    FOR UPDATE;
BEGIN
    FOR vPracownik IN cPracownicy LOOP
        UPDATE Pracownicy
        SET placa_pod = placa_pod * 1.2
        WHERE CURRENT OF cPracownicy;
    END LOOP;
END;

SELECT NAZWISKO, PLACA_POD FROM PRACOWNICY WHERE TO_CHAR(ZATRUDNIONY, 'FMDAY') = 'MONDAY';

-- Task 4
SELECT NAZWISKO, PLACA_DOD, ETAT, NAZWA FROM PRACOWNICY JOIN ZESPOLY USING(ID_ZESP);

DECLARE
    CURSOR cPracownicy IS
    SELECT NAZWISKO, PLACA_DOD, ETAT, NAZWA FROM PRACOWNICY JOIN ZESPOLY USING(ID_ZESP) 
    FOR UPDATE OF PLACA_DOD;
BEGIN
    FOR vPracownik IN cPracownicy LOOP
        IF vPracownik.NAZWA = 'ALGORYTMY' THEN
            UPDATE Pracownicy
            SET PLACA_DOD = COALESCE(PLACA_DOD, 0) + 100
            WHERE CURRENT OF cPracownicy;
        ELSIF vPracownik.NAZWA = 'ADMINISTRACJA' THEN
            UPDATE Pracownicy
            SET PLACA_DOD = COALESCE(PLACA_DOD, 0) + 150
            WHERE CURRENT OF cPracownicy;
        ELSIF vPracownik.ETAT = 'STAZYSTA' THEN
            DELETE FROM Pracownicy
            WHERE CURRENT OF cPracownicy;
        END IF;
    END LOOP;
END;

SELECT NAZWISKO, PLACA_DOD, ETAT, NAZWA FROM PRACOWNICY JOIN ZESPOLY USING(ID_ZESP); 

-- Task 5
CREATE OR REPLACE PROCEDURE PokazPracownikowEtatu (pEtat IN PRACOWNICY.ETAT%TYPE) IS
    CURSOR cPracownicy(pEtat PRACOWNICY.ETAT%TYPE) IS
        SELECT NAZWISKO FROM PRACOWNICY WHERE ETAT = pEtat;
BEGIN
    FOR vPracownik IN cPracownicy(pEtat) LOOP
        DBMS_OUTPUT.PUT_LINE(vPracownik.NAZWISKO);
    END LOOP;
END PokazPracownikowEtatu;

EXEC PokazPracownikowEtatu('PROFESOR');

-- Task 6
CREATE OR REPLACE PROCEDURE RaportKadrowy IS
    vLicznik NUMBER;
    vSrednia NUMBER;
    CURSOR cEtaty IS
        SELECT NAZWA FROM ETATY ORDER BY NAZWA;
    CURSOR cPracownicy(pEtat ETATY.NAZWA%TYPE) IS
        SELECT NAZWISKO, PLACA_POD, PLACA_DOD FROM PRACOWNICY WHERE ETAT = pEtat ORDER BY NAZWISKO;
BEGIN
    FOR vEtat IN cEtaty LOOP
        DBMS_OUTPUT.PUT_LINE('Etat: ' || vEtat.NAZWA);
        DBMS_OUTPUT.PUT_LINE('------------------------------');
        vLicznik := 0;
        vSrednia := 0;
        FOR vPracownik IN cPracownicy(vEtat.NAZWA) LOOP
            vLicznik := vLicznik + 1;
            DBMS_OUTPUT.PUT_LINE(vLicznik || '. ' || vPracownik.NAZWISKO || ', ' || (vPracownik.PLACA_POD + COALESCE(vPracownik.PLACA_DOD, 0)));
            vSrednia := vSrednia + (vPracownik.PLACA_POD + COALESCE(vPracownik.PLACA_DOD, 0));
        END LOOP;
        DBMS_OUTPUT.PUT_LINE('Liczba pracowników: ' || vLicznik);
        IF vSrednia != 0 THEN
            vSrednia := vSrednia/vLicznik;
            DBMS_OUTPUT.PUT_LINE('Średnia płaca na etacie: ' || vSrednia);
        ELSE
            DBMS_OUTPUT.PUT_LINE('Średnia płaca na etacie: brak');
        END IF;
        DBMS_OUTPUT.PUT_LINE(' ');
    END LOOP;
END RaportKadrowy;

EXEC RaportKadrowy;

-- Task 7
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
        IF SQL%ROWCOUNT != 0 THEN
			DBMS_OUTPUT.PUT_LINE('Dodano nowy zespół o id: ' || vId || ', nazwie: ' || pName || ' i adresie: ' || pAddress);
            DBMS_OUTPUT.PUT_LINE ('Dodane rekordy: '|| SQL%ROWCOUNT);
        ELSE
            DBMS_OUTPUT.PUT_LINE ('Nie dodano rekordów!');
        END IF;
    END Create_Team;

    PROCEDURE Delete_Team
        (pId ZESPOLY.ID_ZESP%TYPE) IS
    BEGIN
        DELETE FROM ZESPOLY WHERE ID_ZESP=pId;
        IF SQL%ROWCOUNT != 0 THEN
            DBMS_OUTPUT.PUT_LINE ('Usunięte rekordy: '|| SQL%ROWCOUNT);
        ELSE
            DBMS_OUTPUT.PUT_LINE ('Nie usunięto rekordów!');
        END IF;
    END Delete_Team;

    PROCEDURE Delete_Team
        (pName ZESPOLY.NAZWA%TYPE) IS
    BEGIN
        DELETE FROM ZESPOLY WHERE NAZWA=pName;
        IF SQL%ROWCOUNT != 0 THEN
            DBMS_OUTPUT.PUT_LINE ('Usunięte rekordy: '|| SQL%ROWCOUNT);
        ELSE
            DBMS_OUTPUT.PUT_LINE ('Nie usunięto rekordów!');
        END IF;
    END Delete_Team;

    PROCEDURE Update_Team
        (pId ZESPOLY.ID_ZESP%TYPE,
        pName ZESPOLY.NAZWA%TYPE,
        pAddress ZESPOLY.ADRES%TYPE) IS
    BEGIN
        UPDATE ZESPOLY
        SET NAZWA = pName, ADRES = pAddress
        WHERE ID_ZESP = pId;
        IF SQL%ROWCOUNT != 0 THEN
            DBMS_OUTPUT.PUT_LINE ('Zmienione rekordy: '|| SQL%ROWCOUNT);
        ELSE
            DBMS_OUTPUT.PUT_LINE ('Nie zmieniono rekordów!');
        END IF;
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

-- Task 8
CREATE OR REPLACE PACKAGE IntZespoly IS
    PROCEDURE Create_Team
        (pId ZESPOLY.ID_ZESP%TYPE, pName ZESPOLY.NAZWA%TYPE, pAddress ZESPOLY.ADRES%TYPE);

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
    PROCEDURE Team_Name_Exists(pName ZESPOLY.NAZWA%TYPE) IS
        vCount INTEGER;
    BEGIN
        SELECT COUNT(*) INTO vCount FROM ZESPOLY WHERE NAZWA = pName;
        IF vCount = 0 THEN
            RAISE_APPLICATION_ERROR(20001, 'Błąd -20001: Nie istnieje zespół o podanej nazwie!');
        END IF;
    END Team_Name_Exists;

    PROCEDURE Team_Id_Exists(pId ZESPOLY.ID_ZESP%TYPE) IS
        vCount INTEGER;
    BEGIN
        SELECT COUNT(*) INTO vCount FROM ZESPOLY WHERE ID_ZESP = pId;
        IF vCount = 0 THEN
            RAISE_APPLICATION_ERROR(20002, 'Błąd -20002: Nie istnieje zespół o podanym id!');
        END IF;
    END Team_Id_Exists;

    PROCEDURE Team_Id_Unique(pId ZESPOLY.ID_ZESP%TYPE) IS
        vCount INTEGER;
    BEGIN
        SELECT COUNT(*) INTO vCount FROM ZESPOLY WHERE ID_ZESP = pId;
        IF vCount > 0 THEN
            RAISE_APPLICATION_ERROR(20003, 'Błąd -20003: Podane id jest już zajęte!');
        END IF;
    END Team_Id_Unique;

    PROCEDURE Create_Team
        (pId ZESPOLY.ID_ZESP%TYPE, pName ZESPOLY.NAZWA%TYPE, pAddress ZESPOLY.ADRES%TYPE) IS
        vId ZESPOLY.ID_ZESP%TYPE;
    BEGIN
        IF pId IS NULL THEN
            SELECT NVL(MAX(ID_ZESP), 0) + 1 INTO vId FROM ZESPOLY;
        ELSE
            vId := pId;
            Team_Id_Unique(vId);
        END IF;
        INSERT INTO ZESPOLY(ID_ZESP, NAZWA, ADRES)
        VALUES(vId, pName, pAddress);
        IF SQL%ROWCOUNT != 0 THEN
			DBMS_OUTPUT.PUT_LINE('Dodano nowy zespół o id: ' || vId || ', nazwie: ' || pName || ' i adresie: ' || pAddress);
            DBMS_OUTPUT.PUT_LINE ('Dodane rekordy: '|| SQL%ROWCOUNT);
        ELSE
            DBMS_OUTPUT.PUT_LINE ('Nie dodano rekordów!');
        END IF;
    END Create_Team;

    PROCEDURE Delete_Team
        (pId ZESPOLY.ID_ZESP%TYPE) IS
    BEGIN
        Team_Id_Exists(pId);
        DELETE FROM ZESPOLY WHERE ID_ZESP=pId;
        IF SQL%ROWCOUNT != 0 THEN
            DBMS_OUTPUT.PUT_LINE ('Usunięte rekordy: '|| SQL%ROWCOUNT);
        ELSE
            DBMS_OUTPUT.PUT_LINE ('Nie usunięto rekordów!');
        END IF;
    END Delete_Team;

    PROCEDURE Delete_Team
        (pName ZESPOLY.NAZWA%TYPE) IS
    BEGIN
        Team_Name_Exists(pName);
        DELETE FROM ZESPOLY WHERE NAZWA=pName;
        IF SQL%ROWCOUNT != 0 THEN
            DBMS_OUTPUT.PUT_LINE ('Usunięte rekordy: '|| SQL%ROWCOUNT);
        ELSE
            DBMS_OUTPUT.PUT_LINE ('Nie usunięto rekordów!');
        END IF;
    END Delete_Team;

    PROCEDURE Update_Team
        (pId ZESPOLY.ID_ZESP%TYPE,
        pName ZESPOLY.NAZWA%TYPE,
        pAddress ZESPOLY.ADRES%TYPE) IS
    BEGIN
        Team_Id_Exists(pId);
        UPDATE ZESPOLY
        SET NAZWA = pName, ADRES = pAddress
        WHERE ID_ZESP = pId;
        IF SQL%ROWCOUNT != 0 THEN
            DBMS_OUTPUT.PUT_LINE ('Zmienione rekordy: '|| SQL%ROWCOUNT);
        ELSE
            DBMS_OUTPUT.PUT_LINE ('Nie zmieniono rekordów!');
        END IF;
    END Update_Team;

    FUNCTION Get_Id
        (pName IN ZESPOLY.NAZWA%TYPE)
        RETURN ZESPOLY.ID_ZESP%TYPE IS
        vId ZESPOLY.ID_ZESP%TYPE;
    BEGIN
        Team_Name_Exists(pName);
        SELECT ID_ZESP INTO vId FROM ZESPOLY WHERE NAZWA=pName;
        RETURN vId;
    END Get_Id;
    
    FUNCTION Get_Name
        (pId IN ZESPOLY.ID_ZESP%TYPE)
        RETURN ZESPOLY.NAZWA%TYPE IS
        vName ZESPOLY.NAZWA%TYPE;
    BEGIN
        Team_Id_Exists(pId);
        SELECT NAZWA INTO vName FROM ZESPOLY WHERE ID_ZESP=pId;
        RETURN vName;
    END Get_Name;

    FUNCTION Get_Address
        (pId IN ZESPOLY.ID_ZESP%TYPE)
        RETURN ZESPOLY.ADRES%TYPE IS
        vAddress ZESPOLY.ADRES%TYPE;
    BEGIN
        Team_Id_Exists(pId);
        SELECT ADRES INTO vAddress FROM ZESPOLY WHERE ID_ZESP=pId;
        RETURN vAddress;
    END Get_Address;
END IntZespoly;

EXEC IntZespoly.Create_Team(10, 'Nowy Zespol 1', 'OS. SOBIESKIEGO 26');

BEGIN
    DBMS_OUTPUT.PUT_LINE (IntZespoly.Get_Id('AAA'));
END;

BEGIN
    DBMS_OUTPUT.PUT_LINE (IntZespoly.Get_name(111));
END;
