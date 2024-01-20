--- DB Movies

-- Show the address of studio MGM
SELECT address, name
FROM Studio
WHERE name = 'MGM';

-- List the names of all actors which stared in a movie
-- in 1980 whose name contains the word 'Love'
SELECT starName
FROM StarsIn
WHERE movieYear = 1980 and movieTitle like '%LOVE%';

-- List the names of all producers whose net worth is
-- more than 10 milion
SELECT name
FROM MovieExec
WHERE networth > 10000000;

-- List the names of all actors which are
-- male or live in Malibu
SELECT name
FROM MovieStar
WHERE gender = 'M' OR address LIKE '%Malibu%';

--- DB Ships

-- List the names of all ships launched before 1918
-- and name the resulting column shipName
SELECT name as shipName
FROM Ships
WHERE launched < 1918;

-- List the names of all ships whose name consists of
-- exactly two words
SELECT name
FROM Ships
WHERE name LIKE '% %' and name NOT LIKE '% % %';

--- DB PC

-- List all printer makers without duplicates
SELECT DISTINCT maker
FROM Product
WHERE type = 'Printer';

-- List all PCs' model, speed and HD where CD is
-- DVD 12x or 16x and price is lower than 2000
SELECT MODEL, SPEED, HD
FROM PC
WHERE (CD = '12' OR CD = '16') AND PRICE < 2000;