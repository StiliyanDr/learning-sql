--- DB Movies

-- List the movies produced by the producer of 'Star Wars',
-- include the producer's name
SELECT DISTINCT M1.title, ME.name
FROM Movie as M1, Movie as M2, MovieExec as ME
WHERE M1.producer# = M2.producerc#
      AND M2.title = 'Star Wars'
      AND M2.producer# = ME.cert#;

-- List the names of the producers of Harrison Ford's movies
SELECT DISTINCT ME.name
FROM MovieExec as ME, Movie as M, StarsIn as S
WHERE ME.cert# = M.producerc#
      AND M.title = S.movieTitle
      AND M.year = S.movieYear
      AND S.starName = 'Harrison Ford';

-- List the names of the actors with the studios which produced
-- their movies, oredered by studio names
SELECT DISTINCT M.studioName, S.starName
FROM Movie as M JOIN StarsIn as S
     ON M.title = S.movieTitle
        AND M.year = S.movieYear
ORDER BY M.studioName;

-- List the names of the actors which starred in a movie
-- of the producer with the biggest networth
SELECT DISTINCT S.starName
FROM MovieExec as ME, Movie as M, StarsIn as S
WHERE ME.cert# = M.producerc#
      AND M.title = S.movieTitle
      AND M.year = S.movieYear
      AND ME.networth >= ALL(SELECT networth
                             FROM MovieExec
                             WHERE networth IS NOT NULL);

-- List the actors which did not star in any movie
SELECT DISTINCT starName
FROM StarsIn LEFT JOIN Movie
     ON movieTitle = title
        AND movieYear = year
WHERE title IS NULL;

--- DB PC

-- List the products whose model is not for sale (is absent
-- from the relevant table)
(SELECT PR.model as model, PR.type, PR.maker
 FROM Product as PR LEFT JOIN Laptop as L
      ON PR.type = 'Laptop' AND PR.model = L.model
 WHERE L.model IS NULL)
UNION
(SELECT PR.model as model, PR.type, PR.maker
 FROM Product as PR LEFT JOIN PC
      ON PR.type = 'PC' AND PR.model = PC.model
 WHERE PC.model IS NULL)
UNION
(SELECT PR.model as model, PR.type, PR.maker
 FROM Product as PR LEFT JOIN Printer as P
      ON PR.type = 'Printer' AND PR.model = P.model
 WHERE P.model IS NULL)

-- List all the ships with their class information
-- but do not include classes with no ships
SELECT *
FROM Classes as C LEFT JOIN Ships as S
     ON C.class = S.class
WHERE S.name IS NOT NULL;

-- or

SELECT *
FROM Classes as C JOIN Ships as S
     ON C.class = S.class;

-- List all the ships with their class information
-- but only include classes without ships IF there
-- is a ship with that class name
SELECT *
FROM Classes as C LEFT JOIN Ships as S
     ON C.class = S.class
WHERE S.name IS NOT NULL
      OR EXISTS (SELECT *
                 FROM Ships
                 WHERE C.class = Ships.name);

-- For each country, list the ships which never fought
-- in a battle
SELECT DISTINCT C.country
FROM Classes as C JOIN Ships as S
     ON C.class = S.class
     LEFT JOIN Outcomes as O
     ON S.name = O.ship
WHERE O.battle IS NULL;
