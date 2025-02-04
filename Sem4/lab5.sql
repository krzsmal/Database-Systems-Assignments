-- Task 1:
SELECT P.NAZWISKO, P.ID_ZESP, Z.NAZWA
FROM PRACOWNICY P LEFT OUTER JOIN ZESPOLY Z ON P.ID_ZESP = Z.ID_ZESP
ORDER BY P.NAZWISKO;

-- Task 2:
SELECT Z.NAZWA, Z.ID_ZESP, NVL(P.NAZWISKO, 'brak pracowników') as PRACOWNIK
FROM ZESPOLY Z LEFT OUTER JOIN PRACOWNICY P ON Z.ID_ZESP = P.ID_ZESP
ORDER BY Z.NAZWA, P.NAZWISKO;

-- Task 3:
SELECT NVL(Z.NAZWA, 'brak zespołu') AS ZESPOL, NVL(P.NAZWISKO, 'brak pracowników') as PRACOWNIK
FROM ZESPOLY Z FULL OUTER JOIN PRACOWNICY P ON Z.ID_ZESP = P.ID_ZESP
ORDER BY Z.NAZWA, P.NAZWISKO;

-- Task 4:
SELECT Z.NAZWA as ZESPOL, COUNT(P.NAZWISKO) AS LICZBA, SUM(P.PLACA_POD) AS SUMA_PLAC
FROM ZESPOLY Z LEFT OUTER JOIN PRACOWNICY P ON Z.ID_ZESP = P.ID_ZESP
GROUP BY Z.NAZWA;

-- Task 5:
SELECT Z.NAZWA as NAZWA
FROM ZESPOLY Z LEFT OUTER JOIN PRACOWNICY P ON Z.ID_ZESP = P.ID_ZESP
GROUP BY Z.NAZWA
HAVING COUNT(P.NAZWISKO) = 0
ORDER BY Z.NAZWA;

-- Task 6:
SELECT P1.NAZWISKO AS PRACOWNIK, P1.ID_PRAC, P2.NAZWISKO AS SZEF, P1.ID_SZEFA
FROM PRACOWNICY P1 LEFT OUTER JOIN PRACOWNICY P2 ON P1.ID_SZEFA = P2.ID_PRAC
ORDER BY P1.NAZWISKO;

-- Task 7:
SELECT P2.NAZWISKO AS PRACOWNIK, COUNT(P1.NAZWISKO) AS LICZBA_PODWADNYCH
FROM PRACOWNICY P1 RIGHT OUTER JOIN PRACOWNICY P2 ON P1.ID_SZEFA = P2.ID_PRAC
GROUP BY P2.NAZWISKO
ORDER BY P2.NAZWISKO;

-- Task 8:
SELECT P1.NAZWISKO, P1.ETAT, P1.PLACA_POD, Z.NAZWA, P2.NAZWISKO AS SZEF
FROM PRACOWNICY P1 LEFT OUTER JOIN PRACOWNICY P2 ON P1.ID_SZEFA = P2.ID_PRAC
LEFT OUTER JOIN ZESPOLY Z ON P1.ID_ZESP = Z.ID_ZESP
ORDER BY P1.NAZWISKO;

-- Task 9:
SELECT P.NAZWISKO, Z.NAZWA
FROM PRACOWNICY P CROSS JOIN ZESPOLY Z
ORDER BY P.NAZWISKO, Z.NAZWA;

-- Task 10:
SELECT COUNT(*)
FROM PRACOWNICY P
CROSS JOIN ZESPOLY
CROSS JOIN ETATY;


-- Task 11:
SELECT DISTINCT ETAT
FROM PRACOWNICY
WHERE EXTRACT(YEAR FROM ZATRUDNIONY) = 1992
INTERSECT
SELECT DISTINCT ETAT
FROM PRACOWNICY
WHERE EXTRACT(YEAR FROM ZATRUDNIONY) = 1993;

-- Task 12:
SELECT Z.ID_ZESP
FROM ZESPOLY Z
MINUS
SELECT Z.ID_ZESP FROM ZESPOLY Z RIGHT OUTER JOIN PRACOWNICY P ON Z.ID_ZESP = P.ID_ZESP;

-- Task 13:
SELECT Z.ID_ZESP, Z.NAZWA
FROM ZESPOLY Z
MINUS
SELECT Z.ID_ZESP, Z.NAZWA FROM ZESPOLY Z RIGHT OUTER JOIN PRACOWNICY P ON Z.ID_ZESP = P.ID_ZESP;

-- Task 14:
SELECT NAZWISKO, PLACA_POD, 'Poniżej 480 złotych' AS PROG
FROM PRACOWNICY WHERE PLACA_POD < 480
UNION
SELECT NAZWISKO, PLACA_POD, 'Dokładnie 480 złotych' AS PROG FROM PRACOWNICY WHERE PLACA_POD = 480
UNION
SELECT NAZWISKO, PLACA_POD, 'Powyżej 480 złotych' AS PROG FROM PRACOWNICY WHERE PLACA_POD > 480
ORDER BY PLACA_POD;