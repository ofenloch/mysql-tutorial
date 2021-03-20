/**
    This script (re-)creates the database tutorial and 
    the two tables (pet and event) in this database.

    It is mostly for convenience to start with a clean slate.
    
**/

--
-- re-create the database
--
DROP DATABASE IF EXISTS `tutorial`;
CREATE DATABASE `tutorial`;
USE `tutorial`;

--
-- Table structure for table `pet`
--

DROP TABLE IF EXISTS `pet`;
CREATE TABLE `pet` (
  `name` varchar(20) DEFAULT NULL,
  `owner` varchar(20) DEFAULT NULL,
  `species` varchar(20) DEFAULT NULL,
  `sex` char(1) DEFAULT NULL,
  `birth` date DEFAULT NULL,
  `death` date DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Dumping data for table `pet`
--

LOCK TABLES `pet` WRITE;
INSERT INTO `pet` VALUES 
  ('Fluffy','Harold','cat','f','1993-02-04',NULL),
  ('Claws','Gwen','cat','m','1994-03-17',NULL),
  ('Buffy','Harold','dog','f','1989-05-13',NULL),
  ('Fang','Benny','dog','m','1990-08-27',NULL),
  ('Bowser','Diane','dog','m','1979-08-31','1995-07-29'),
  ('Chirpy','Gwen','bird','f','1998-09-11',NULL),
  ('Whistler','Gwen','bird','','1997-12-09',NULL),
  ('Slim','Benny','snake','m','1996-04-29',NULL),
  ('Puffball','Diane','hamster','f','1999-03-30',NULL);
UNLOCK TABLES;

--
-- Table structure for table `event`
--

DROP TABLE IF EXISTS `event`;
CREATE TABLE `event` (
  `name` varchar(20) DEFAULT NULL,
  `date` date DEFAULT NULL,
  `type` varchar(15) DEFAULT NULL,
  `remark` varchar(255) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Dumping data for table `event`
--

LOCK TABLES `event` WRITE;
INSERT INTO `event` VALUES 
  ('Fluffy','1995-05-15','litter','4 kittens, 3 female, 1 male'),
  ('Buffy','1993-06-23','litter','5 puppies, 2 female, 3 male'),
  ('Buffy','1994-06-19','litter','3 puppies, 3 female'),
  ('Chirpy','1999-03-21','vet','needed beak straightened'),
  ('Slim','1997-08-03','vet','broken rib'),
  ('Bowser','1991-10-12','kennel',''),
  ('Fang','1991-10-12','kennel',''),
  ('Fang','1992-08-27','birthday','Gave him a new chew toy'),
  ('Claws','1991-08-27','birthday','Gave him a new flea collar'),
  ('Whistler','1998-12-09','birthday','First birthday');
UNLOCK TABLES;

--
-- Beam the pets and the events to the present
--
UPDATE pet SET birth = birth + INTERVAL 20 YEAR WHERE birth IS NOT NULL;
UPDATE pet SET death = death + INTERVAL 20 YEAR WHERE death IS NOT NULL;
UPDATE event SET date = date + INTERVAL 20 YEAR WHERE date IS NOT NULL;

--
-- Show the tables
--
SELECT "Table 'pet':" as INFO;
SELECT * from pet;
SELECT "Table 'event':" as INFO;
SELECT * from event;
SELECT "Ages of my pets:" as INFO;
SELECT name, birth, CURDATE(), TIMESTAMPDIFF(YEAR,birth,CURDATE()) AS age FROM pet ORDER BY age;