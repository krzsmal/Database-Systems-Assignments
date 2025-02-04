-- Task 1:
SELECT NAZWISKO, ETAT, ID_ZESP FROM PRACOWNICY
WHERE ID_ZESP = (SELECT ID_ZESP FROM PRACOWNICY WHERE UPPER(NAZWISKO)='BRZEZINSKI')
ORDER BY NAZWISKO;

-- Task 2:
SELECT P.NAZWISKO, P.ETAT, Z.NAZWA
FROM PRACOWNICY P INNER JOIN ZESPOLY Z ON P.ID_ZESP=Z.ID_ZESP
WHERE P.ID_ZESP = (SELECT ID_ZESP FROM PRACOWNICY WHERE UPPER(NAZWISKO)='BRZEZINSKI')
ORDER BY NAZWISKO;

-- Task 3:
SELECT NAZWISKO, ETAT, TO_CHAR(ZATRUDNIONY, 'YYYY/MM/DD') AS ZATRUDNIONY FROM PRACOWNICY
WHERE ZATRUDNIONY=(SELECT MIN(ZATRUDNIONY) FROM PRACOWNICY WHERE ETAT='PROFESOR') AND ETAT='PROFESOR';

-- Task 4:
SELECT NAZWISKO, TO_CHAR(ZATRUDNIONY, 'YYYY/MM/DD') AS ZATRUDNIONY, ID_ZESP FROM PRACOWNICY
WHERE (ZATRUDNIONY, ID_ZESP) IN (SELECT MAX(ZATRUDNIONY), ID_ZESP FROM PRACOWNICY GROUP BY ID_ZESP)
ORDER BY ZATRUDNIONY;

-- Task 5:
SELECT ID_ZESP, NAZWA, ADRES FROM ZESPOLY
WHERE ID_ZESP NOT IN (SELECT ID_ZESP FROM PRACOWNICY WHERE ID_ZESP IS NOT NULL);

-- Task 6:
SELECT NAZWISKO FROM PRACOWNICY
WHERE ETAT='PROFESOR' AND ID_PRAC NOT IN (SELECT ID_SZEFA FROM PRACOWNICY WHERE ETAT='STAZYSTA');

-- Task 7:
SELECT ID_ZESP, SUM(PLACA_POD) AS SUMA_PLAC FROM PRACOWNICY
HAVING SUM(PLACA_POD)>=ALL(SELECT SUM(PLACA_POD) AS SUMA_PLAC FROM PRACOWNICY GROUP BY ID_ZESP)
GROUP BY ID_ZESP;

-- Task 8:
SELECT Z.NAZWA, SUM(P.PLACA_POD) AS SUMA_PLAC FROM PRACOWNICY P
INNER JOIN ZESPOLY Z ON P.ID_ZESP=Z.ID_ZESP
HAVING SUM(P.PLACA_POD)>=ALL(SELECT SUM(PLACA_POD) AS SUMA_PLAC FROM PRACOWNICY GROUP BY ID_ZESP)
GROUP BY Z.NAZWA;

-- Task 9:
SELECT Z.NAZWA, COUNT(P.ID_ZESP) AS ILU_PRACOWNIKOW FROM PRACOWNICY P
INNER JOIN ZESPOLY Z ON P.ID_ZESP = Z.ID_ZESP
HAVING COUNT(P.ID_ZESP)>(SELECT COUNT(P.ID_ZESP) FROM PRACOWNICY P
INNER JOIN ZESPOLY Z ON P.ID_ZESP = Z.ID_ZESP
WHERE Z.NAZWA='ADMINISTRACJA')
GROUP BY Z.NAZWA;

-- Task 10:
SELECT ETAT FROM PRACOWNICY
HAVING COUNT(ETAT)=(SELECT MAX(COUNT(ETAT)) FROM PRACOWNICY
GROUP BY ETAT)
GROUP BY ETAT;

-- Task 11:
SELECT ETAT, LISTAGG((NAZWISKO), ',')
WITHIN GROUP (ORDER BY NAZWISKO) AS PRACOWNICY FROM PRACOWNICY
HAVING COUNT(ETAT)=(SELECT MAX(COUNT(ETAT)) FROM PRACOWNICY
GROUP BY ETAT)
GROUP BY ETAT;

-- Task 12:
SELECT P1.NAZWISKO AS PRACOWNIK, P2.NAZWISKO AS SZEF
FROM PRACOWNICY P1 INNER JOIN PRACOWNICY P2 ON P1.ID_SZEFA=P2.ID_PRAC
WHERE ABS(P2.PLACA_POD-P1.PLACA_POD)=(
SELECT MIN(ABS(P2.PLACA_POD-P1.PLACA_POD))
FROM PRACOWNICY P1 INNER JOIN PRACOWNICY P2 ON P1.ID_SZEFA=P2.ID_PRAC);