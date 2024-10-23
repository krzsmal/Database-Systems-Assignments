-- Task 1:
SELECT NAZWISKO, SUBSTR(ETAT, 0, 2) || ID_PRAC AS KOD FROM PRACOWNICY;

-- Task 2:
SELECT NAZWISKO, REPLACE(REPLACE(REPLACE(NAZWISKO, 'K', 'X'), 'L', 'X'), 'M', 'X') AS WOJNA_LITEROM FROM PRACOWNICY;

-- Task 3:
SELECT NAZWISKO FROM PRACOWNICY WHERE SUBSTR(NAZWISKO, 0, LENGTH(NAZWISKO)/2) LIKE '%L%';

-- Task 4:
SELECT NAZWISKO, ROUND(PLACA_POD*1.15, 0) AS PODWYZKA FROM PRACOWNICY;

-- Task 5:
SELECT NAZWISKO, PLACA_POD, PLACA_POD*0.2 AS INWESTYCJA, (PLACA_POD*0.2)*POWER(1+0.1, 10) AS KAPITAL, (PLACA_POD*0.2)*POWER(1+0.1, 10)-PLACA_POD*0.2 AS ZYSK FROM PRACOWNICY;

-- Task 6:
SELECT NAZWISKO, TO_CHAR(ZATRUDNIONY, 'yy/mm/dd') AS ZATRUDNI, FLOOR(((DATE '2000-01-01')-ZATRUDNIONY)/365.25) AS STAZ_W_2000 FROM PRACOWNICY;

-- Task 7:
ALTER SESSION SET NLS_LANGUAGE='POLISH';
SELECT NAZWISKO, (RPAD(UPPER(TO_CHAR(ZATRUDNIONY, 'month')), 11, 'X') || TO_CHAR(ZATRUDNIONY, ', dd yyyy')) AS DATA_ZATRUDNIENIA FROM PRACOWNICY WHERE ID_ZESP = 20;

-- Task 8:
ALTER SESSION SET NLS_LANGUAGE='POLISH';
SELECT UPPER(TO_CHAR(CURRENT_DATE, 'day')) AS DZIS FROM DUAL;

-- Task 9:
SELECT NAZWA, ADRES, 
    CASE SUBSTR(ADRES, 1, INSTR(ADRES, ' ', 1, 1)-1)
        WHEN 'PIOTROWO' THEN 'NOWE MIASTO'
        WHEN 'MIELZYNSKIEGO' THEN 'STARE MIASTO'
        WHEN 'STRZELECKA' THEN 'STARE MIASTO'
        WHEN 'WLODKOWICA' THEN 'GRUNWALD'
    END AS DZIELNICA FROM ZESPOLY;

-- Task 10:
SELECT NAZWISKO, PLACA_POD, CASE
    WHEN PLACA_POD>480 THEN 'Powyżej 480'
    WHEN PLACA_POD=480 THEN 'Dokładnie 480'
    ELSE 'Poniżej 480'
    END AS PRÓG FROM PRACOWNICY ORDER BY PLACA_POD DESC;

-- Task 11:
SELECT NAZWISKO, PLACA_POD, DECODE(SIGN(PLACA_POD-480),
    1, 'Powyżej 480',
    0, 'Dokładnie 480',
    'Poniżej 480') AS PRÓG FROM PRACOWNICY ORDER BY PLACA_POD DESC;