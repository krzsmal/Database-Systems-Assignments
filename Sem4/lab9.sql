-- Task 1:
CREATE TABLE PROJEKTY (
    ID_PROJEKTU NUMBER(4) GENERATED ALWAYS AS IDENTITY,
    OPIS_PROJEKTU VARCHAR2(20),
    DATA_ROZPOCZECIA DATE DEFAULT CURRENT_DATE,
    DATA_ZAKONCZENIA DATE,
    FUNDUSZ NUMBER(7, 2)
);

-- Task 2:
INSERT INTO PROJEKTY VALUES(
    DEFAULT,
    'Indeksy bitmapowe',
    TO_DATE('1999/04/02', 'yyyy/mm/dd'),
    TO_DATE('2001/08/31', 'yyyy/mm/dd'),
    25000
);

INSERT INTO PROJEKTY VALUES(
    DEFAULT,
    'Sieci kręgosłupowe',
    DEFAULT,
    NULL,
    19000
);

-- Task 3:
SELECT ID_PROJEKTU, OPIS_PROJEKTU FROM PROJEKTY;

-- Task 4:
INSERT INTO PROJEKTY VALUES(
    10,
    'Indeksy drzewiaste',
    TO_DATE('2013/12/24', 'yyyy/mm/dd'),
    TO_DATE('2014/01/01', 'yyyy/mm/dd'),
    1200
);

-- Task 5:
INSERT INTO PROJEKTY VALUES(
    DEFAULT,
    'Indeksy drzewiaste',
    TO_DATE('2013/12/24', 'yyyy/mm/dd'),
    TO_DATE('2014/01/01', 'yyyy/mm/dd'),
    1200
);

-- Task 6:
UPDATE PROJEKTY P SET
P.ID_PROJEKTU=10 WHERE OPIS_PROJEKTU='Indeksy drzewiaste';

-- Task 7:
CREATE TABLE PROJEKTY_KOPIA AS SELECT * FROM PROJEKTY;

SELECT * FROM PROJEKTY_KOPIA;

-- Task 8:
INSERT INTO PROJEKTY_KOPIA VALUES(
    10,
    'Sieci lokalne',
    SYSDATE,
    SYSDATE+INTERVAL '1' YEAR,
    24500
);

-- Task 9:
DELETE FROM PROJEKTY WHERE OPIS_PROJEKTU='Indeksy drzewiaste';

-- Task 10:
SELECT TABLE_NAME FROM USER_TABLES;