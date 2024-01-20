--- DB Movies

-- List the names of the actresses which are also produces
-- with neth worth more than 10 milion
SELECT name
FROM MovieStar
WHERE gender = 'F'
      AND name IN (SELECT name
                   FROM MovieExec
                   WHERE networth > 10000000);

-- List the names of the actors which are not producers
SELECT name
FROM MovieStar
WHERE name NOT IN (SELECT name
                   FROM MovieExec);

-- For each producer whose networth is greater than the
-- networth of Merv Griffin, list their name and their
-- productions
SELECT ME.name, M.title, M.year
FROM MovieExec as ME JOIN Movie as M
     ON ME.cert# = M.producer#
WHERE ME.networth > (SELECT networth
                     FROM MovieExec
                     WHERE name = 'Merv Griffin');

-- List the names of the longest movies per studio
SELECT name, year
FROM Movie as M1
WHERE length >= ALL(SELECT length
                    FROM Movie as M2
                    where M2.studioName = M1.studioName);

--- DB PC

-- List the laptops whose speed is lower than that of some PC
SELECT *
FROM Laptop as L
WHERE L.speed < ANY(SELECT P.speed
                    FROM PC as P);

-- List the makers of those PCs which have the lowest memory
-- and fastest processors
SELECT DISTINCT PRODUCT.maker
FROM PC JOIN PRODUCT
     ON PC.model = PRODUCT.model
        AND PRODUCT.type = 'PC'
WHERE PC.ram <= ALL(SELECT ram FROM PC)
      AND PC.speed >= ALL(SELECT speed FROM PC);


--- DB Ships

-- List the names of the ships with the biggest number of guns
-- considering only the ships with the same bore
SELECT S.name
FROM Ships as S JOIN Classes as C
     ON C.class = S.class
WHERE C.numguns >= ALL(SELECT numguns
                       FROM Classes as C2
                       WHERE C2.bore = C.bore);
