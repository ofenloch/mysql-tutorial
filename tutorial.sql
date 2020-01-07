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
SELECT name, birth, CURDATE(), TIMESTAMPDIFF(YEAR,birth,CURDATE()) AS age FROM pet ORDER BY name;
SELECT name, birth, CURDATE(), TIMESTAMPDIFF(YEAR,birth,CURDATE()) AS age FROM pet ORDER BY age;


