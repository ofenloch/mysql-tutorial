USE `tutorial`;

-- Beispiel aus dem Wiki-Artikel
-- https://de.wikipedia.org/wiki/Join_(SQL)
--
--
-- Wir erzeugen zwei Tabellen:
--
-- mysql> select * from tutorial.Mitarbeiter;
-- +------+---------+-------+
-- | MId  | Name    | AbtId |
-- +------+---------+-------+
-- | M1   | Müller  |    31 |
-- | M2   | Schmidt |    32 |
-- | M3   | Müller  |    32 |
-- | M4   | Meyer   |  NULL |
-- +------+---------+-------+
-- 4 rows in set (0.00 sec)

-- mysql> select * from tutorial.Abteilung;
-- +-------+-----------+
-- | AbtId | Name      |
-- +-------+-----------+
-- | 31    | Verkauf   |
-- | 32    | Technik   |
-- | 33    | Marketing |
-- +-------+-----------+
-- 3 rows in set (0.00 sec)

-- mysql> 
--
-- Die Beispiel-Tabellen haben folgende Besonderheiten:
-- * Die Mitarbeiterin oder der Mitarbeiter namens „Meyer“ ist keiner Abteilung 
--   zugeordnet. Der Wert NULL als AbtId bedeutet in SQL, dass dieser Wert unbekannt ist.
--
-- * Die Abteilung „Marketing“ hat keine zugeordneten Mitarbeiter.
--

-- Tabelle `Mitarbeiter` löschen
DROP TABLE IF EXISTS `Mitarbeiter`;
-- und neu anlegen
CREATE TABLE `Mitarbeiter` (
    `MId` varchar(10), 
    `Name` varchar(40),
    `AbtId` int REFERENCES Abteilung(AbtId),
    PRIMARY KEY(MId)
);
-- Daten in Tabelle `Mitarbeiter` einfügen
INSERT INTO `Mitarbeiter` VALUES 
    ('M1', 'Müller', 31),
    ('M2', 'Schmidt', 32),
    ('M3', 'Müller', 32),
    ('M4', 'Meyer',	NULL);

-- Tablle `Abteilung` löschen
DROP TABLE IF EXISTS `Abteilung`;
-- und neu anlegen
CREATE TABLE `Abteilung` (
    `AbtId` int, 
    `Name` varchar(40),
    PRIMARY KEY(AbtId)
);
-- Daten in Tabelle `Abteilung` einfügen
INSERT INTO `Abteilung` VALUES 
    (31, 'Verkauf'),
    (32, 'Technik'),
    (33, 'Marketing');


--
-- CROSS JOIN
--
-- Der CROSS JOIN zweier Tabellen bildet das kartesische Produkt der Datensätze der beiden Tabellen. 
-- Dabei wird jeder Datensatz der ersten Tabelle mit jedem anderen der zweiten Tabelle verknüpft. 
-- Wenn die beiden Tabellen gleichnamige Attribute haben, werden sie durch das Voranstellen des 
-- Tabellennamens ergänzt.
SELECT "CROSS JOIN: " AS INFO;
SELECT * FROM Mitarbeiter CROSS JOIN Abteilung;
-- mysql> SELECT *
--     -> FROM Mitarbeiter CROSS JOIN Abteilung;
-- +------+---------+-------+-------+-----------+
-- | MId  | Name    | AbtId | AbtId | Name      |
-- +------+---------+-------+-------+-----------+
-- | M1   | Müller  |    31 | 31    | Verkauf   |
-- | M1   | Müller  |    31 | 32    | Technik   |
-- | M1   | Müller  |    31 | 33    | Marketing |
-- | M2   | Schmidt |    32 | 31    | Verkauf   |
-- | M2   | Schmidt |    32 | 32    | Technik   |
-- | M2   | Schmidt |    32 | 33    | Marketing |
-- | M3   | Müller  |    32 | 31    | Verkauf   |
-- | M3   | Müller  |    32 | 32    | Technik   |
-- | M3   | Müller  |    32 | 33    | Marketing |
-- | M4   | Meyer   |  NULL | 31    | Verkauf   |
-- | M4   | Meyer   |  NULL | 32    | Technik   |
-- | M4   | Meyer   |  NULL | 33    | Marketing |
-- +------+---------+-------+-------+-----------+
-- 12 rows in set (0.00 sec)

-- mysql>
SELECT "Gleichwertige Abfrage 'SELECT * FROM Mitarbeiter, Abteilung;' " AS INFO;
SELECT * FROM Mitarbeiter, Abteilung;

--
-- LEFT OUTER JOIN
--
SELECT "LEFT OUTER JOIN: " AS INFO;
SELECT * FROM Mitarbeiter LEFT OUTER JOIN Abteilung USING (AbtId);

--
-- RIGHT OUTER JOIN
--
SELECT "RIGHT OUTER JOIN: " AS INFO;
SELECT * FROM Mitarbeiter RIGHT OUTER JOIN Abteilung USING (AbtId);

--
-- SELF JOIN
-- 
SELECT "SELF JOIN: " AS INFO;
SELECT MA.MId, MA.Name FROM Mitarbeiter MA CROSS JOIN Mitarbeiter MB WHERE MA.MId <> MB.MId AND MA.Name = MB.Name;
--
-- NATURAL JOIN
--
SELECT "NATURAL JOIN: " AS INFO;
SELECT * FROM Mitarbeiter NATURAL JOIN Abteilung;