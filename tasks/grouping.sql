--- DB PC

-- List the average screen size of laptops per maker
SELECT P.maker, DECIMAL(AVG(L.screen), 9, 2) as AvgScreen
FROM Product as P JOIN Laptop as L
     ON P.model = L.model AND P.type = 'Laptop'
GROUP BY P.maker;

-- List the average price of laptops whose speed is more than 1000
--
-- NOTE: averaging without grouping, result is scalar
--
SELECT DECIMAL(AVG(price), 9, 2) as AvgPrice
FROM Laptop
WHERE speed > 1000;

-- Show the average price of computers made by 'A'
SELECT DECIMAL(AVG(PC.price), 9, 2) as AvgPrice
FROM Product as P JOIN PC
     ON P.type = 'PC' AND P.model = PC.model
WHERE P.maker = 'A';

-- List the average price of computers and laptops made by 'B'
SELECT DECIMAL(AVG(S.price), 9, 2) as AvgPrice
FROM 
((SELECT PC.price as price
  FROM Product as P JOIN PC
       ON P.model = PC.model and P.type = 'PC'
  WHERE P.maker = 'B')
UNION ALL
 (SELECT L.price as price
  FROM Product as P JOIN Laptop as L
       ON P.model = L.model and P.type = 'Laptop'
  WHERE P.maker = 'B')) as S;

-- List the average price of computers depending on their speed
SELECT speed, DECIMAL(AVG(price), 9, 2) as AvgPrice
FROM PC
GROUP BY speed;

-- List the makers with at least 3 different PC models
SELECT maker, COUNT(DISTINCT model) as NumModels
FROM Product
GROUP BY maker, type
HAVING type = 'PC' AND COUNT(DISTINCT model) >= 3;

-- List the PC makers and their highest PC price
SELECT P.maker, MAX(PC.price) as MaxPrice
FROM Product as P JOIN PC
     ON P.type = 'PC' and P.model = PC.model
GROUP BY P.maker;

-- List the PC makers with highest PC price
SELECT DISTINCT P.maker
FROM Product as P JOIN PC
     ON P.type = 'PC' and P.model = PC.model
GROUP BY P.maker
HAVING MAX(PC.price) >= ALL(SELECT PC1.price
                            FROM Product as P1 JOIN PC as PC1
                                 ON P1.type = 'PC' and P1.model = PC1.model
                            WHERE P1.maker = P.maker);

-- List the average price of computers per speed, with the
-- speed being more than 800
SELECT speed, DECIMAL(AVG(price), 9, 2) as AvgPrice
FROM PC
WHERE speed > 800
GROUP BY speed;

-- List the average disk size of computers whose makers
-- also make printers
SELECT P.maker, DECIMAL(AVG(PC.hd)) as AvgHD
FROM PC JOIN Product as P
     ON PC.model = P.model AND P.type = 'PC'
GROUP BY P.maker
HAVING P.maker IN (SELECT DISTINCT maker
                   FROM Product
                   WHERE type = 'Printer');

--- DB Ships

--- List the number of ship classes
SELECT COUNT(class) as ClassCount
FROM Classes;

-- List the first and last year a ship was launched, for each class
SELECT C.class,
       MIN(S.launched) as FirstShipYear,
       MAX(S.launched) as LastShipYear
FROM Classes as C JOIN Ships as S
     ON C.class = S.class
GROUP BY C.class;

-- List the number of ships sunk in a battle, for each class
SELECT S.class, COUNT(O.result) as SunkCount
FROM Ships as S JOIN Outcomes as O
     ON S.name = O.ship
WHERE O.result = 'sunk'
GROUP BY S.class;

-- List the number of ships sunk in a battle, for each class
-- with at least two ships
SELECT S.class, COUNT(O.result) as SunkCount
FROM Ships as S JOIN Outcomes as O
     ON S.name = O.ship
WHERE O.result = 'sunk'
GROUP BY S.class
HAVING S.class IN (SELECT class
                   FROM Ships
                   GROUP BY class
                   HAVING COUNT(name) >= 2);
