-- Task 1:
SELECT PRACOWNICY.NAZWISKO, PRACOWNICY.ETAT, PRACOWNICY.ID_ZESP, ZESPOLY.NAZWA
FROM PRACOWNICY INNER JOIN ZESPOLY ON ZESPOLY.ID_ZESP = PRACOWNICY.ID_ZESP
ORDER BY PRACOWNICY.NAZWISKO;

-- Task 2:
SELECT PRACOWNICY.NAZWISKO, PRACOWNICY.ETAT, PRACOWNICY.ID_ZESP, ZESPOLY.NAZWA
FROM PRACOWNICY INNER JOIN ZESPOLY ON ZESPOLY.ID_ZESP = PRACOWNICY.ID_ZESP
WHERE ZESPOLY.ADRES = 'PIOTROWO 3A'
ORDER BY PRACOWNICY.NAZWISKO;

-- Task 3:
SELECT P.NAZWISKO, P.ETAT, P.PLACA_POD, E.PLACA_MIN, E.PLACA_MAX
FROM PRACOWNICY P INNER JOIN ETATY E ON P.ETAT = E.NAZWA
ORDER BY E.NAZWA, P.NAZWISKO;

-- Task 4:
SELECT P.NAZWISKO, P.ETAT, P.PLACA_POD, E.PLACA_MIN, E.PLACA_MAX, case when P.PLACA_POD BETWEEN E.PLACA_MIN AND E.PLACA_MAX then 'OK' else 'NIE' end AS CZY_PENSJA_OK
FROM PRACOWNICY P INNER JOIN ETATY E ON P.ETAT = E.NAZWA
ORDER BY E.NAZWA, P.NAZWISKO;

-- Task 5:
SELECT P.NAZWISKO, P.ETAT, P.PLACA_POD, E.PLACA_MIN, E.PLACA_MAX, case when P.PLACA_POD BETWEEN E.PLACA_MIN AND E.PLACA_MAX then 'OK' else 'NIE' end AS CZY_PENSJA_OK
FROM PRACOWNICY P INNER JOIN ETATY E ON P.ETAT = E.NAZWA 
WHERE case when P.PLACA_POD BETWEEN E.PLACA_MIN AND E.PLACA_MAX then 'OK' else 'NIE' end != 'OK'
ORDER BY E.NAZWA, P.NAZWISKO;

-- Task 6:
SELECT P.NAZWISKO, P.PLACA_POD, P.ETAT, E.NAZWA AS KAT_PLAC, E.PLACA_MIN, E.PLACA_MAX
FROM PRACOWNICY P INNER JOIN ETATY E ON P.PLACA_POD BETWEEN E.PLACA_MIN AND E.PLACA_MAX
ORDER BY P.NAZWISKO, E.NAZWA;

-- Task 7:
SELECT P.NAZWISKO, P.PLACA_POD, P.ETAT, E.NAZWA AS KAT_PLAC, E.PLACA_MIN, E.PLACA_MAX
FROM PRACOWNICY P INNER JOIN ETATY E ON P.PLACA_POD BETWEEN E.PLACA_MIN AND E.PLACA_MAX
WHERE E.NAZWA = 'SEKRETARKA'
ORDER BY P.NAZWISKO, E.NAZWA;

-- Task 8:
SELECT P1.NAZWISKO AS PRACOWNIK, P1.ID_PRAC, P2.NAZWISKO AS SZEF, P1.ID_SZEFA
FROM PRACOWNICY P1 INNER JOIN PRACOWNICY P2 ON P1.ID_SZEFA = P2.ID_PRAC
ORDER BY P1.NAZWISKO;

-- Task 9:
SELECT P1.NAZWISKO AS PRACOWNIK, TO_CHAR(P1.ZATRUDNIONY, 'yyyy.mm.dd') AS PRAC_ZATRUDNIONY, P2.NAZWISKO AS SZEF, P1.ID_SZEFA, TO_CHAR(P2.ZATRUDNIONY, 'yyyy.mm.dd') AS SZEF_ZATRUDNIONY, EXTRACT(year FROM P1.ZATRUDNIONY)-EXTRACT(year FROM P2.ZATRUDNIONY) AS LATA
FROM PRACOWNICY P1 INNER JOIN PRACOWNICY P2 ON P1.ID_SZEFA = P2.ID_PRAC
WHERE EXTRACT(year FROM P1.ZATRUDNIONY)-EXTRACT(year FROM P2.ZATRUDNIONY) <= 10
ORDER BY P1.ZATRUDNIONY, P1.NAZWISKO;

-- Task 10:
SELECT Z.NAZWA, COUNT(Z.NAZWA) AS LICZBA, AVG(P.PLACA_POD) AS SREDNIA_PLACA                    
FROM ZESPOLY Z INNER JOIN PRACOWNICY P ON Z.ID_ZESP = P.ID_ZESP
GROUP BY Z.NAZWA
ORDER BY Z.NAZWA;

-- Task 11:
SELECT Z.NAZWA, CASE
    WHEN COUNT(Z.NAZWA) <= 2 THEN 'mały'
    WHEN COUNT(Z.NAZWA) BETWEEN 3 AND 6 THEN 'średni'
    ELSE 'duży' END
AS ETYKIETA            
FROM ZESPOLY Z INNER JOIN PRACOWNICY P ON Z.ID_ZESP = P.ID_ZESP
GROUP BY Z.NAZWA;