SET SERVEROUTPUT ON

-- Task 1
DECLARE
 vTekst VARCHAR(100) := 'Witaj, świecie!';
 vLiczba NUMBER(7,3) := 1000.456;
BEGIN
    DBMS_OUTPUT.PUT_LINE('Zmienna vTekst: ' || vTekst);
    DBMS_OUTPUT.PUT_LINE('Zmienna vLiczba: ' || vLiczba);
END;

-- Task 2
DECLARE
 vTekst VARCHAR(100) := 'Witaj, świecie!';
 vLiczba NUMBER(19,3) := 1000.456;
BEGIN
    vTekst := CONCAT(vTekst, ' Witaj, nowy dniu!');
    vLiczba := vLiczba + POWER(10, 15);
    DBMS_OUTPUT.PUT_LINE('Zmienna vTekst: ' || vTekst);
    DBMS_OUTPUT.PUT_LINE('Zmienna vLiczba: ' || vLiczba);
END;

-- Task 3
DECLARE
 vLiczba1 NUMBER(19,3) := 5;
 vLiczba2 NUMBER(19,3) := 3;
BEGIN
    DBMS_OUTPUT.PUT_LINE('Wynik dodawania ' || vLiczba1 || ' i ' || vLiczba2 || ': ' || (vLiczba1+vLiczba2));
END;

-- Task 4
DECLARE
 vPromien NUMBER(19,3) := 5;
 cPI CONSTANT NUMBER(3,2) := 3.14;
BEGIN
    DBMS_OUTPUT.PUT_LINE('Obwód koła o promieniu równym ' || vPromien || ': ' || (2*cPI*vPromien));
    DBMS_OUTPUT.PUT_LINE('Pole koła o promieniu równym ' || vPromien || ': ' || (cPI*POWER(vPromien, 2)));
END;

-- Task 5
DECLARE
 vNazwisko Pracownicy.nazwisko%TYPE;
 vEtat Pracownicy.etat%TYPE;
BEGIN
    SELECT *
    INTO vNazwisko, vEtat
    FROM (SELECT nazwisko, etat FROM Pracownicy ORDER BY placa_pod + COALESCE(placa_dod, 0) DESC)
    WHERE ROWNUM = 1;

    DBMS_OUTPUT.PUT_LINE('Najlepiej zarabia pracownik ' || vNazwisko);
    DBMS_OUTPUT.PUT_LINE('Pracuje on jako ' || vEtat);
END;

-- Task 6
DECLARE
TYPE tDane IS RECORD (
 nazwisko Pracownicy.nazwisko%TYPE,
 etat Pracownicy.etat%TYPE);
 vPracownik tDane;
BEGIN
    SELECT *
    INTO vPracownik.nazwisko, vPracownik.etat
    FROM (SELECT nazwisko, etat FROM Pracownicy ORDER BY placa_pod + COALESCE(placa_dod, 0) DESC)
    WHERE ROWNUM = 1;

    DBMS_OUTPUT.PUT_LINE('Najlepiej zarabia pracownik ' || vPracownik.nazwisko);
    DBMS_OUTPUT.PUT_LINE('Pracuje on jako ' || vPracownik.etat);
END;

-- Task 7
DECLARE
    SUBTYPE tPieniadze IS NUMBER(7,2);
    vZarobki tPieniadze;
BEGIN
    SELECT placa_pod + COALESCE(placa_dod, 0)
    INTO vZarobki
    FROM pracownicy
    WHERE nazwisko = 'SLOWINSKI';
    DBMS_OUTPUT.PUT_LINE('Pracownik SLOWINSKI zarabia rocznie ' || 12*vZarobki);
END;

-- Task 8
DECLARE
    vSekunda VARCHAR(2) := '00';
BEGIN
    WHILE vSekunda != '25' LOOP
        SELECT TO_CHAR(SYSDATE, 'SS')
        INTO vSekunda
        FROM DUAL;
    END LOOP;

    DBMS_OUTPUT.PUT_LINE('Nadeszła 25 sekunda!');
END;

-- Task 9
DECLARE
    vN NATURAL := 10;
    vWynik NATURAL := 1;
BEGIN
    IF vN != 0 THEN
        FOR vIndeks IN 1..vN LOOP
            vWynik := vWynik * vIndeks;
        END LOOP;
    END IF;

    DBMS_OUTPUT.PUT_LINE('Silnia dla n=' || vN || ': ' || vWynik);
END;

-- Task 10
DECLARE
    vDzien VARCHAR(100);
BEGIN
    FOR vRok IN 2000..2100 LOOP
        FOR vMiesiac IN 1..12 LOOP
            SELECT TO_CHAR(TO_DATE('13-' || vMiesiac || '-' || vRok, 'DD-MM-YYYY'), 'FMDAY') 
            INTO vDzien
            FROM dual;
            IF vDzien = 'FRIDAY' THEN
                DBMS_OUTPUT.PUT_LINE(TO_CHAR(TO_DATE('13-' || vMiesiac || '-' || vRok, 'DD-MM-YYYY'), 'DD-MM-YYYY'));
            END IF;
        END LOOP;
    END LOOP;
END;