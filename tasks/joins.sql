--- DB Movies

-- List the names of the male actors which starred in
-- 'Terms of Endearment'
SELECT name
FROM StarsIn JOIN MovieStar
     ON starName = name
WHERE gender = 'M' and movieTitle = 'Terms of Endearment';

-- List the names of the actors which starred in movies
-- produced by MGM in 1995
SELECT S.starName
FROM Movie as M, StarsIn as S
WHERE M.title = S.movieTitle
      AND M.year = S.movieYear
      AND M.studioName = 'MGM'
      AND M.year = 1995;

-- Show the name of the president of MGM
SELECT DISTINCT ME.name
FROM Studio as S, Movie as M, MovieExec as ME
WHERE S.name = M.studioName
      AND M.producerC# = ME.cert#
      AND S.name = "MGM";

-- List the names of the movies which are longer
-- than 'Gone with the wind'
SELECT title
FROM Movie
WHERE length > (SELECT length
                FROM Movie
                WHERE title = 'Gone With the Wind');

--- DB PC

-- List the model number and price of those products
-- whose maker is named 'B'
(SELECT P.model as model, L.price as price
FROM Product as P JOIN Laptop as L
    ON P.model = L.model AND p.type = 'Laptop'
WHERE P.maker = 'B')
UNION ALL
(SELECT P.model as model, PC.price as price
FROM Product as P JOIN PC
    ON P.model = PC.model AND p.type = 'PC'
WHERE P.maker = 'B')
UNION ALL
 (SELECT P.model as model, PR.price as price
  FROM Product as P JOIN Printer as PR
       ON P.model = PR.model AND p.type = 'Printer'
  WHERE P.maker = 'B');

-- List the HD sizes which are part of more than 2 computers
SELECT DISTINCT P1.HD
FROM PC as P1, PC as P2, PC as P3
WHERE P1.model <> P2.model
      AND P1.model <> P3.model
      AND P2.model <> P3.model
      AND P1.HD = P2.HD
      AND P2.HD = P3.HD;

-- List each pair of PC models with the same speed and RAM
-- Each pair should appear once, (i, j) but not (j, i)
SELECT *
FROM PC as P1, PC as P2
WHERE P1.model = P2.model
      AND P1.code < P2.code
      AND P1.ram = P2.ram
      AND P1.speed = P2.speed;


--- DB Ships

-- List the names, water displacement and the number of guns
-- of all the ships who fought in the battle of 'Guadalcanal'
SELECT S.name, C.displacement, C.numguns
FROM Classes as C, Ships as S, Outcomes as O
WHERE C.class = S.class
      AND S.name = O.ship
      AND O.battle = 'Guadalcanal';

-- List the names of the battles which had 3 ships from the
-- same country fight in them
SELECT DISTINCT O1.battle
FROM Outcomes as O1, Ships as S1, Classes as C1,
     Outcomes as O2, Ships as S2, Classes as C2,
     Outcomes as O3, Ships as S3, Classes as C3
WHERE S1.class = C1.class
      AND S2.class = C2.class
      AND S3.class = C3.class
      AND S1.name = O1.ship
      AND S2.name = O2.ship
      AND S3.name = O3.ship
      AND O1.battle = O2.battle
      AND O2.battle = O3.battle
      AND C1.country = C2.country
      AND C2.country = C3.country
      AND S1.name <> S2.name
      AND S1.name <> S3.name
      AND S2.name <> S3.name;

-- List the names of those ships which were damaged in one battle
-- but later fought in another battle
SELECT DISTINCT O1.ship
FROM Outcomes as O1, Outcomes as O2, Battles as B1, Battles as B2
WHERE O1.battle = B1.name
      AND O2.battle = B2.name
      AND O1.ship = O2.ship
      AND B1.date < B2.data
      AND O1.result = 'damaged';