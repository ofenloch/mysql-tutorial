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
--
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
-- In allen Formen des inneren Verbundes der Beispiel-Tabellen kommt der Mitarbeiter mit der MId „M4“ nicht vor, weil 
-- ihm ja keine Abteilung zugeordnet ist. Und auch die Abteilung „Marketing“ kommt nicht vor, weil sie keine Mitarbeiter hat.
-- 
-- Die Formen des Outer Joins (deutsch: äußerer Verbund) beziehen Datensätze in den Verbund ein, zu denen es keine 
-- Entsprechungen der Werte in den beiden Tabellen gibt. Der äußere Verbund muss also immer eingesetzt werden, wenn unbekannte 
-- oder fehlende Information im Spiel ist.
--
-- Sollen im Beispiel der Mitarbeiter und Abteilungen alle Mitarbeiter mit ihren Abteilungen ausgegeben werden, auch diejenigen, 
-- die keiner Abteilung zugeordnet sind, dann ist ein äußerer Verbund erforderlich.
--


--
-- LEFT OUTER JOIN
--

-- Das Ergebnis von T1 LEFT OUTER JOIN T2 der Tabellen T1 und T2 enthält alle Datensätze der Tabelle T1 links des Schlüsselworts 
-- JOIN, selbst wenn es keinen korrespondierenden Datensatz der rechten Tabelle T2 gibt. Die fehlenden Werte aus T2 werden 
-- durch NULL aufgefüllt.

SELECT "LEFT OUTER JOIN: " AS INFO;
SELECT * FROM Mitarbeiter LEFT OUTER JOIN Abteilung USING (AbtId);
-- Das Ergebnis enthält nun auch den Mitarbeiter mit der MId „M4“ und die Attribute aus der verknüpften Tabelle Abteilung sind NULL.
-- mysql> SELECT * FROM Mitarbeiter LEFT OUTER JOIN Abteilung USING (AbtId);
-- +-------+-----+---------+---------+
-- | AbtId | MId | Name    | Name    |
-- +-------+-----+---------+---------+
-- |    31 | M1  | Müller  | Verkauf |
-- |    32 | M2  | Schmidt | Technik |
-- |    32 | M3  | Müller  | Technik |
-- |  NULL | M4  | Meyer   | NULL    |
-- +-------+-----+---------+---------+
-- 4 rows in set (0.00 sec)

-- mysql>


--
-- RIGHT OUTER JOIN
--

-- Ein RIGHT OUTER JOIN bildet den inneren Verbund der beiden Tabellen und ergänzt ihn um je einen Datensatz für Datensätze in der 
-- rechten Tabelle, zu denen es keine Korrespondenz in der linken Tabelle gibt.

SELECT "RIGHT OUTER JOIN: " AS INFO;
SELECT * FROM Mitarbeiter RIGHT OUTER JOIN Abteilung USING (AbtId);
-- Das Ergebnis enthält nun einen Datensatz für die Abteilung „Marketing“, der kein Angestellter zugeordnet ist, weshalb 
-- die Attribute MId und Name NULL sind.
-- mysql> SELECT * FROM Mitarbeiter RIGHT OUTER JOIN Abteilung USING (AbtId);
-- +-------+-----------+------+---------+
-- | AbtId | Name      | MId  | Name    |
-- +-------+-----------+------+---------+
-- |    31 | Verkauf   | M1   | Müller  |
-- |    32 | Technik   | M2   | Schmidt |
-- |    32 | Technik   | M3   | Müller  |
-- |    33 | Marketing | NULL | NULL    |
-- +-------+-----------+------+---------+
-- 4 rows in set (0.00 sec)

-- mysql>

-- Ein weiteres Beispiel, bei dem der äußere Verbund benötigt wird: Es sollen alle Abteilungen mit der Anzahl ihrer Mitarbeiter 
-- ausgegeben werden. Da beim inneren Verbund zur Abteilung mit der AbtId 33 gar kein Datensatz ausgegeben werden würde, muss 
-- die Anweisung mit dem äußeren Verbund formuliert werden:
SELECT Abt.Name, count(MId) as Mitarbeiterzahl FROM Mitarbeiter RIGHT OUTER JOIN Abteilung AS Abt USING (AbtId) GROUP BY AbtId, Abt.Name;
-- mysql> SELECT Abt.Name, count(MId) as Mitarbeiterzahl 
--     -> FROM Mitarbeiter RIGHT OUTER JOIN Abteilung AS Abt USING (AbtId)
--     -> GROUP BY AbtId, Abt.Name;
-- +-----------+-----------------+
-- | Name      | Mitarbeiterzahl |
-- +-----------+-----------------+
-- | Verkauf   |               1 |
-- | Technik   |               2 |
-- | Marketing |               0 |
-- +-----------+-----------------+
-- 3 rows in set (0.00 sec)

-- mysql>

--
-- SELF JOIN
-- 

-- Ein Self Join ist ein Join einer Tabelle mit sich selbst. Das bedeutet, dass Datensätze der Tabelle mit anderen Datensätzen 
-- derselben Tabelle verglichen werden müssen. Damit man in SQL Werte der Datensätze derselben Tabelle vergleichen kann, muss 
-- man in der Anweisung explizite Bezeichnungen für zwei Tupelvariablen vergeben, die beide die Datensätze der Tabelle durchlaufen können.

-- Als Beispiel soll überprüft werden, ob in der Tabelle Mitarbeiter zwei Mitarbeiter mit gleichem Namen aber verschiedener 
-- MId vorkommen. Im folgenden Self Join werden die Tupelvariablen MA und MB für die Tabelle „Mitarbeiter“ definiert, um den 
-- Vergleich durchführen zu können.

SELECT "SELF JOIN: " AS INFO;
SELECT MA.MId, MA.Name FROM Mitarbeiter MA CROSS JOIN Mitarbeiter MB WHERE MA.MId <> MB.MId AND MA.Name = MB.Name;

-- mysql> SELECT MA.MId, MA.Name
--     -> FROM Mitarbeiter MA CROSS JOIN Mitarbeiter MB
--     -> WHERE MA.MId <> MB.MId AND MA.Name = MB.Name;
-- +-----+---------+
-- | MId | Name    |
-- +-----+---------+
-- | M3  | Müller  |
-- | M1  | Müller  |
-- +-----+---------+
-- 2 rows in set (0.00 sec)

-- mysql>


--
-- NATURAL JOIN
--

SELECT "NATURAL JOIN: " AS INFO;
SELECT * FROM Mitarbeiter NATURAL JOIN Abteilung;

-- mysql> SELECT * FROM Mitarbeiter NATURAL JOIN Abteilung;
-- Empty set (0.00 sec)

-- mysql> 