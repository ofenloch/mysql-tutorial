-- This is the database used in this tutorial

-- Delete the database if it exists

DROP DATABASE IF EXISTS  `tutorial`;

CREATE DATABASE `tutorial`;

USE `tutorial`;


-- Delete the table if it exists
DROP TABLE IF EXISTS `pet`;

-- Create the table
CREATE TABLE `pet` (
  `name` varchar(20),
  `owner` varchar(20),
  `species` varchar(20),
  `sex` char(1),
  `birth` date,
  `death` date
);


SELECT "Loading data from './pet.txt' ... " as INFO;

-- Read the text file
LOAD DATA LOCAL INFILE './pet.txt' INTO TABLE `pet`;

SHOW warnings;

SELECT * FROM pet;

-- Add an entry for Puffball
INSERT INTO pet VALUES ('Puffball','Diane','hamster','f','1999-03-30',NULL);

-- Correct Bowser's date of birth 
UPDATE pet SET birth = '1989-08-31' WHERE name = 'Bowser';
-- Enter sex for 
UPDATE pet SET sex = 'm' WHERE name = 'Whistler';

SELECT * FROM tutorial.pet;

-- Beam the pets to the present
UPDATE pet SET birth = birth + INTERVAL 20 YEAR;
UPDATE pet SET death = death + INTERVAL 20 YEAR WHERE death IS NOT NULL;

SELECT * FROM `tutorial`.`pet`;

-- List the pets' age
SELECT name, birth, CURDATE(), TIMESTAMPDIFF(YEAR,birth,CURDATE()) AS age_in_years FROM tutorial.pet ORDER BY name;
SELECT name, birth, CURDATE(), TIMESTAMPDIFF(YEAR,birth,CURDATE()) AS age_in_years FROM tutorial.pet ORDER BY age_in_years;

-- To find names containing exactly five characters, use five 
-- instances of the '_' pattern character:
SELECT * FROM pet WHERE name LIKE '_____';


--
-- find out the ages at which each pet had its litters with JOIN
-- 
SELECT pet.name, TIMESTAMPDIFF(YEAR,birth,date) AS age, remark FROM pet INNER JOIN event ON pet.name = event.name WHERE event.type = 'litter';

--
-- find out the ages at which each pet had its litters without JOIN
-- 
SELECT pet.name, TIMESTAMPDIFF(YEAR,birth,date) AS age, remark FROM pet, event WHERE pet.name=event.name AND event.type = 'litter';