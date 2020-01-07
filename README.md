# MySQL Tutorial

This tutorial follows the instructions / tutorial on the MySQL web site. 
See <https://dev.mysql.com/doc/refman/8.0/en/tutorial.html> for the original.

## Creating the Database

Enter `CREATE DATABASE tutorial;` at the mysql prompt:

```bash
obama@teben:~/workspaces/mysql/tutorial$ mysql `cat ~/.mysql/obama@localhost` 
mysql: [Warning] Using a password on the command line interface can be insecure.
Welcome to the MySQL monitor.  Commands end with ; or \g.
Your MySQL connection id is 100
Server version: 5.7.28-0ubuntu0.19.04.2 (Ubuntu)

Copyright (c) 2000, 2019, Oracle and/or its affiliates. All rights reserved.

Oracle is a registered trademark of Oracle Corporation and/or its
affiliates. Other names may be trademarks of their respective
owners.

Type 'help;' or '\h' for help. Type '\c' to clear the current input statement.

mysql> CREATE DATABASE tutorial;
Query OK, 1 row affected (0.00 sec)

mysql> 
```

Select the new database by entering `USE tutorial;`. Get a list of tables in thies database with `SHOW tables;`. Since only the database was created and no tables were created yet, there are no tables:

```sql
mysql> USE tutorial;
Database changed
mysql> SHOW tables;
Empty set (0.00 sec)

mysql> 
```

## Creating a Table

Enter `CREATE TABLE pet (name VARCHAR(20), owner VARCHAR(20), 
species VARCHAR(20), sex CHAR(1), birth DATE, death DATE);at the mysql prompt to create the first table:

```sql
mysql> CREATE TABLE pet (name VARCHAR(20), owner VARCHAR(20),
    ->        species VARCHAR(20), sex CHAR(1), birth DATE, death DATE);
Query OK, 0 rows affected (0.02 sec)

mysql> 
```

This creates a **table** named 'pets' with five **columns** (or 
fields). The columns are 'name', 'owner', 'species', 'sex', 
'birth', and 'death'.

The **type** VARCHAR is a good choice for the name, owner, and 
species columns because the column values vary in length. The 
lengths in those column definitions need not all be the same, and 
need not be 20. You can normally pick any length from 1 to 65535, 
whatever seems most reasonable to you. If you make a poor choice 
and it turns out later that you need a longer field, MySQL provides 
an 'ALTER TABLE' statement.

Several types of values can be chosen to represent sex in animal 
records, such as 'm' and 'f', or perhaps 'male' and 'female'. It is 
simplest to use the single characters 'm' and 'f'.

The use of the DATE data type for the birth and death columns is a fairly obvious choice.

If we run the command `SHOW tables;` again, we see the new table named `pets`:

```sql
mysql> SHOW tables;
+--------------------+
| Tables_in_tutorial |
+--------------------+
| pet                |
+--------------------+
1 row in set (0.00 sec)

mysql>
```

With `DESCRIBE pet;` we get a description of the table:

```sql
mysql> DESCRIBE pet;
+---------+-------------+------+-----+---------+-------+
| Field   | Type        | Null | Key | Default | Extra |
+---------+-------------+------+-----+---------+-------+
| name    | varchar(20) | YES  |     | NULL    |       |
| owner   | varchar(20) | YES  |     | NULL    |       |
| species | varchar(20) | YES  |     | NULL    |       |
| sex     | char(1)     | YES  |     | NULL    |       |
| birth   | date        | YES  |     | NULL    |       |
| death   | date        | YES  |     | NULL    |       |
+---------+-------------+------+-----+---------+-------+
6 rows in set (0.00 sec)

mysql> 
```

## Loading Data into a Table

First, we create a simple text file with the data we want to insert into our table. 
The **columns** in that table must be separated by tabs stop. Otherwise mysql can't 
resolve the mapping of the date to the table's columns. See file [pet.txt](./pet.txt). 
Then we use the command `LOAD DATA LOCAL INFILE './pet.txt' INTO TABLE pet;` to load 
the data into the table:

```sql
mysql> LOAD DATA LOCAL INFILE './pet.txt' INTO TABLE pet;
Query OK, 8 rows affected, 7 warnings (0.00 sec)
Records: 8  Deleted: 0  Skipped: 0  Warnings: 7

mysql> 
```

As we can see, eight **records** (corresponding to eight affected **rows** were 
inserted into table 'pet'. And there were some **warnings**. We can check the 
warnings with `SHOW warnings;`:

```sql
mysql> SHOW warnings;
+---------+------+--------------------------------------------+
| Level   | Code | Message                                    |
+---------+------+--------------------------------------------+
| Warning | 1265 | Data truncated for column 'death' at row 1 |
| Warning | 1265 | Data truncated for column 'death' at row 2 |
| Warning | 1265 | Data truncated for column 'death' at row 3 |
| Warning | 1265 | Data truncated for column 'death' at row 4 |
| Warning | 1265 | Data truncated for column 'death' at row 6 |
| Warning | 1265 | Data truncated for column 'death' at row 7 |
| Warning | 1261 | Row 8 doesn't contain data for all columns |
+---------+------+--------------------------------------------+
7 rows in set (0.00 sec)

mysql> 
```

To 'manually' insert a **record** into the table, we 
use the command `INSERT INTO pet VALUES ('Puffball','Diane','hamster','f','1999-03-30',NULL);`:

```sql
mysql> INSERT INTO pet VALUES ('Puffball','Diane','hamster','f','1999-03-30',NULL);
Query OK, 1 row affected (0.01 sec)

mysql> 
```

Here we insert NULL directly to represent a missing value for the last column 'death'.

## Retrieving Information from a Table

### Selecting All Data

The most simple way to get data from a table (i.e. **execute a query**) ist `SELECT * FROM pet;`. This **statement** selects all columns from all records in the table:

```sql
mysql> SELECT * FROM pet;
+----------+--------+---------+------+------------+------------+
| name     | owner  | species | sex  | birth      | death      |
+----------+--------+---------+------+------------+------------+
| Fluffy   | Harold | cat     | f    | 1993-02-04 | 0000-00-00 |
| Claws    | Gwen   | cat     | m    | 1994-03-17 | 0000-00-00 |
| Buffy    | Harold | dog     | f    | 1989-05-13 | 0000-00-00 |
| Fang     | Benny  | dog     | m    | 1990-08-27 | 0000-00-00 |
| Bowser   | Diane  | dog     | m    | 1979-08-31 | 1995-07-29 |
| Chirpy   | Gwen   | bird    | f    | 1998-09-11 | 0000-00-00 |
| Whistler | Gwen   | bird    |      | 1997-12-09 | 0000-00-00 |
| Slim     | Benny  | snake   | m    | 1996-04-29 | NULL       |
| Puffball | Diane  | hamster | f    | 1999-03-30 | NULL       |
+----------+--------+---------+------+------------+------------+
9 rows in set (0.00 sec)

mysql> 
```

### Updating Data

We can see that Whistler, the bird, has no sex. To correct this 
mistake we could delete the table (using `DROP TABLE pet;`), edit the file 'pet.txt', re-create the table and load the corrected file again into the table:

```mysql
mysql> drop table pet;
Query OK, 0 rows affected (0.01 sec)

mysql> CREATE TABLE pet (name VARCHAR(20), owner VARCHAR(20),        species VARCHAR(20), sex CHAR(1), birth DATE, death DATE);
Query OK, 0 rows affected (0.02 sec)

mysql> LOAD DATA LOCAL INFILE './pet.txt' INTO TABLE pet;
Query OK, 8 rows affected, 7 warnings (0.01 sec)
Records: 8  Deleted: 0  Skipped: 0  Warnings: 7

mysql> SELECT * FROM pet;
+----------+--------+---------+------+------------+------------+
| name     | owner  | species | sex  | birth      | death      |
+----------+--------+---------+------+------------+------------+
| Fluffy   | Harold | cat     | f    | 1993-02-04 | 0000-00-00 |
| Claws    | Gwen   | cat     | m    | 1994-03-17 | 0000-00-00 |
| Buffy    | Harold | dog     | f    | 1989-05-13 | 0000-00-00 |
| Fang     | Benny  | dog     | m    | 1990-08-27 | 0000-00-00 |
| Bowser   | Diane  | dog     | m    | 1979-08-31 | 1995-07-29 |
| Chirpy   | Gwen   | bird    | f    | 1998-09-11 | 0000-00-00 |
| Whistler | Gwen   | bird    | m    | 1997-12-09 | 0000-00-00 |
| Slim     | Benny  | snake   | m    | 1996-04-29 | NULL       |
+----------+--------+---------+------+------------+------------+
8 rows in set (0.01 sec)

mysql> 
```
Of course we would have to insert Puffball's record again.

```sql
mysql> INSERT INTO pet VALUES ('Puffball','Diane','hamster','f','1999-03-30',NULL);
Query OK, 1 row affected (0.00 sec)

mysql> 
```

We could do this with all the missing or wrong data as well. But 
there is an easier way. We use 
`UPDATE pet SET birth = '1989-08-31' WHERE name = 'Bowser';` to correct Bowser's date of birth:

```sql
mysql> UPDATE pet SET birth = '1989-08-31' WHERE name = 'Bowser';
Query OK, 1 row affected (0.00 sec)
Rows matched: 1  Changed: 1  Warnings: 0

mysql> 
```

Now we fix the 0000-00-00 entries for the date of death with 
`UPDATE pet SET death = NULL WHERE death = 0000-00-00;`:

```sql
mysql> UPDATE pet SET death = NULL WHERE death = '0000-00-00';
ERROR 1292 (22007): Incorrect date value: '0000-00-00' for column 'death' at row 1
mysql> 
mysql> 
mysql> 
mysql> UPDATE pet SET death = NULL WHERE death = 0000-00-00;
Query OK, 6 rows affected (0.00 sec)
Rows matched: 6  Changed: 6  Warnings: 0

mysql> SELECT * FROM pet;
+----------+--------+---------+------+------------+------------+
| name     | owner  | species | sex  | birth      | death      |
+----------+--------+---------+------+------------+------------+
| Fluffy   | Harold | cat     | f    | 1993-02-04 | NULL       |
| Claws    | Gwen   | cat     | m    | 1994-03-17 | NULL       |
| Buffy    | Harold | dog     | f    | 1989-05-13 | NULL       |
| Fang     | Benny  | dog     | m    | 1990-08-27 | NULL       |
| Bowser   | Diane  | dog     | m    | 1989-08-31 | 1995-07-29 |
| Chirpy   | Gwen   | bird    | f    | 1998-09-11 | NULL       |
| Whistler | Gwen   | bird    | m    | 1997-12-09 | NULL       |
| Slim     | Benny  | snake   | m    | 1996-04-29 | NULL       |
| Puffball | Diane  | hamster | f    | 1999-03-30 | NULL       |
+----------+--------+---------+------+------------+------------+
9 rows in set (0.00 sec)

mysql> 
```

### Selecting Particular Rows

To get a list of all dogs, we use `SELECT * from pet WHERE species = 'dog';`

```sql
mysql> SELECT * from pet WHERE species = 'dog';
+--------+--------+---------+------+------------+------------+
| name   | owner  | species | sex  | birth      | death      |
+--------+--------+---------+------+------------+------------+
| Buffy  | Harold | dog     | f    | 1989-05-13 | NULL       |
| Fang   | Benny  | dog     | m    | 1990-08-27 | NULL       |
| Bowser | Diane  | dog     | m    | 1989-08-31 | 1995-07-29 |
+--------+--------+---------+------+------------+------------+
3 rows in set (0.00 sec)

mysql>
```

If we combine two (or more) WHERE clauses we can be more specific. To get a list of all male dogs, we use `SELECT * from pet WHERE species = 'dog' and sex = 'm';`:

```sql
mysql> SELECT * from pet WHERE species = 'dog' and sex = 'm';
+--------+-------+---------+------+------------+------------+
| name   | owner | species | sex  | birth      | death      |
+--------+-------+---------+------+------------+------------+
| Fang   | Benny | dog     | m    | 1990-08-27 | NULL       |
| Bowser | Diane | dog     | m    | 1989-08-31 | 1995-07-29 |
+--------+-------+---------+------+------------+------------+
2 rows in set (0.00 sec)

mysql> 
```

Of course there is an 'OR' as well:  With `SELECT * from pet WHERE owner = 'Diane' OR owner = 'Benny';` we get a list of Benny's and Diane's pets combined:

```sql
mysql> SELECT * from pet WHERE owner = 'Diane' OR owner = 'Benny';
+----------+-------+---------+------+------------+------------+
| name     | owner | species | sex  | birth      | death      |
+----------+-------+---------+------+------------+------------+
| Fang     | Benny | dog     | m    | 1990-08-27 | NULL       |
| Bowser   | Diane | dog     | m    | 1989-08-31 | 1995-07-29 |
| Slim     | Benny | snake   | m    | 1996-04-29 | NULL       |
| Puffball | Diane | hamster | f    | 1999-03-30 | NULL       |
+----------+-------+---------+------+------------+------------+
4 rows in set (0.00 sec)

mysql> 
```

We can combine 'AND' and 'OR' (although AND has higher 
**precedence** than OR). 
`SELECT * FROM pet WHERE (species = 'cat' AND sex = 'm') OR (species = 'dog' AND sex = 'f');` gets a list of male cats and female dogs:

```sql
mysql> SELECT * FROM pet WHERE (species = 'cat' AND sex = 'm') OR (species = 'dog' AND sex = 'f');
+-------+--------+---------+------+------------+-------+
| name  | owner  | species | sex  | birth      | death |
+-------+--------+---------+------+------------+-------+
| Claws | Gwen   | cat     | m    | 1994-03-17 | NULL  |
| Buffy | Harold | dog     | f    | 1989-05-13 | NULL  |
+-------+--------+---------+------+------------+-------+
2 rows in set (0.00 sec)

mysql>
```

The parenthesis around the two 'AND' clauses are not neccessary (sind 'AND' has the higher precedence) but they make things more obvious and readable. Without the parenthesis we get the same result:

```sql
mysql> SELECT * FROM pet WHERE species = 'cat' AND sex = 'm' OR species = 'dog' AND sex = 'f';
+-------+--------+---------+------+------------+-------+
| name  | owner  | species | sex  | birth      | death |
+-------+--------+---------+------+------------+-------+
| Claws | Gwen   | cat     | m    | 1994-03-17 | NULL  |
| Buffy | Harold | dog     | f    | 1989-05-13 | NULL  |
+-------+--------+---------+------+------------+-------+
2 rows in set (0.00 sec)

mysql> 
```

### Selecting Particular Columns

With the **query** `SELECT name, birth FROM pet;` we get only the list of birth dates and the pets' names. If we add 'ORDER BY name' the list issorted alphabetically by name

```sql
mysql> SELECT name, birth FROM pet ORDER BY name;
+----------+------------+
| name     | birth      |
+----------+------------+
| Bowser   | 1989-08-31 |
| Buffy    | 1989-05-13 |
| Chirpy   | 1998-09-11 |
| Claws    | 1994-03-17 |
| Fang     | 1990-08-27 |
| Fluffy   | 1993-02-04 |
| Puffball | 1999-03-30 |
| Slim     | 1996-04-29 |
| Whistler | 1997-12-09 |
+----------+------------+
9 rows in set (0.00 sec)

mysql> 
```

### Date Calculations

To determine how many years old each of your pets is, we use the query `SELECT name, birth, CURDATE(), TIMESTAMPDIFF(YEAR,birth,CURDATE()) AS age FROM pet  ORDER BY age;`:

```sql
mysql> SELECT name, birth, CURDATE(), TIMESTAMPDIFF(YEAR,birth,CURDATE()) AS age FROM pet ORDER BY age;
+----------+------------+------------+------+
| name     | birth      | CURDATE()  | age  |
+----------+------------+------------+------+
| Puffball | 1999-03-30 | 2020-01-06 |   20 |
| Chirpy   | 1998-09-11 | 2020-01-06 |   21 |
| Whistler | 1997-12-09 | 2020-01-06 |   22 |
| Slim     | 1996-04-29 | 2020-01-06 |   23 |
| Claws    | 1994-03-17 | 2020-01-06 |   25 |
| Fluffy   | 1993-02-04 | 2020-01-06 |   26 |
| Fang     | 1990-08-27 | 2020-01-06 |   29 |
| Buffy    | 1989-05-13 | 2020-01-06 |   30 |
| Bowser   | 1989-08-31 | 2020-01-06 |   30 |
+----------+------------+------------+------+
9 rows in set (0.00 sec)

mysql> 
```

Note: This shows clearly, that we should update the table. Either all our pets are dead or we got new ones.

We can add 15 years to each date of birth by executing the qury `UPDATE pet SET birth = birth + INTERVAL 15 YEAR;`. After that, our pets are a 15 years younger:

```sql
mysql> UPDATE pet SET birth = birth + INTERVAL 15 YEAR;
Query OK, 9 rows affected (0.00 sec)
Rows matched: 9  Changed: 9  Warnings: 0

mysql> SELECT name, birth, CURDATE(), TIMESTAMPDIFF(YEAR,birth,CURDATE()) AS age FROM pet ORDER BY age;
+----------+------------+------------+------+
| name     | birth      | CURDATE()  | age  |
+----------+------------+------------+------+
| Puffball | 2014-03-30 | 2020-01-06 |    5 |
| Chirpy   | 2013-09-11 | 2020-01-06 |    6 |
| Whistler | 2012-12-09 | 2020-01-06 |    7 |
| Slim     | 2011-04-29 | 2020-01-06 |    8 |
| Claws    | 2009-03-17 | 2020-01-06 |   10 |
| Fluffy   | 2008-02-04 | 2020-01-06 |   11 |
| Fang     | 2005-08-27 | 2020-01-06 |   14 |
| Buffy    | 2004-05-13 | 2020-01-06 |   15 |
| Bowser   | 2004-08-31 | 2020-01-06 |   15 |
+----------+------------+------------+------+
9 rows in set (0.00 sec)

mysql> 
```

Of course, we should update Bowser's date of death, too:
```sql
mysql> UPDATE pet SET death = death + INTERVAL 15 YEAR WHERE death IS NOT NULL;
Query OK, 1 row affected (0.00 sec)
Rows matched: 1  Changed: 1  Warnings: 0

mysql> SELECT * FROM pet;
+----------+--------+---------+------+------------+------------+
| name     | owner  | species | sex  | birth      | death      |
+----------+--------+---------+------+------------+------------+
| Fluffy   | Harold | cat     | f    | 2008-02-04 | NULL       |
| Claws    | Gwen   | cat     | m    | 2009-03-17 | NULL       |
| Buffy    | Harold | dog     | f    | 2004-05-13 | NULL       |
| Fang     | Benny  | dog     | m    | 2005-08-27 | NULL       |
| Bowser   | Diane  | dog     | m    | 2004-08-31 | 2010-07-29 |
| Chirpy   | Gwen   | bird    | f    | 2013-09-11 | NULL       |
| Whistler | Gwen   | bird    | m    | 2012-12-09 | NULL       |
| Slim     | Benny  | snake   | m    | 2011-04-29 | NULL       |
| Puffball | Diane  | hamster | f    | 2014-03-30 | NULL       |
+----------+--------+---------+------+------------+------------+
9 rows in set (0.00 sec)

mysql>
```

### Working with NULL Values

The NULL value can be surprising until you get used to it. 
Conceptually, NULL means "a missing unknown value" and it 
is treated somewhat differently from other values.

To test for NULL, use the `IS NULL` and `IS NOT NULL` operators, as shown here:

```sql
mysql> SELECT 1 IS NULL, 1 IS NOT NULL;
+-----------+---------------+
| 1 IS NULL | 1 IS NOT NULL |
+-----------+---------------+
|         0 |             1 |
+-----------+---------------+
1 row in set (0.00 sec)

mysql> 
```

A common error when working with NULL is to assume that it is not possible to insert a zero or an empty string into a column defined as NOT NULL, but this is not the case. These are in fact values, whereas NULL means “not having a value.” You can test this easily enough by using IS [NOT] NULL as shown:

```sql
mysql> SELECT 0 IS NULL, 0 IS NOT NULL, '' IS NULL, '' IS NOT NULL;
+-----------+---------------+------------+----------------+
| 0 IS NULL | 0 IS NOT NULL | '' IS NULL | '' IS NOT NULL |
+-----------+---------------+------------+----------------+
|         0 |             1 |          0 |              1 |
+-----------+---------------+------------+----------------+
1 row in set (0.00 sec)

mysql>
```

### Pattern Matching

MySQL provides **standard SQL pattern matching** as well as a form of pattern matching based on extended regular expressions similar to those used by Unix utilities such as vi, grep, and sed.

To get a list of pets whose name starts with a 'b' we use the 
query `SELECT * FROM pet WHERE name LIKE 'b%';`

```sql
mysql> SELECT * FROM pet WHERE name LIKE 'b%';
+--------+--------+---------+------+------------+------------+
| name   | owner  | species | sex  | birth      | death      |
+--------+--------+---------+------+------------+------------+
| Buffy  | Harold | dog     | f    | 2004-05-13 | NULL       |
| Bowser | Diane  | dog     | m    | 2004-08-31 | 2010-07-29 |
+--------+--------+---------+------+------------+------------+
2 rows in set (0.00 sec)

mysql> 
```

With `SELECT * FROM pet WHERE name LIKE '%fy';` we get all pets whos name ends with 'fy':

```sql
mysql> SELECT * FROM pet WHERE name LIKE '%fy';
+--------+--------+---------+------+------------+-------+
| name   | owner  | species | sex  | birth      | death |
+--------+--------+---------+------+------------+-------+
| Fluffy | Harold | cat     | f    | 2008-02-04 | NULL  |
| Buffy  | Harold | dog     | f    | 2004-05-13 | NULL  |
+--------+--------+---------+------+------------+-------+
2 rows in set (0.00 sec)

mysql>
```

To find names containing exactly five characters, use five 
instances of the '_' pattern character:

```sql
mysql> SELECT * FROM pet WHERE name LIKE '_____';
+-------+--------+---------+------+------------+-------+
| name  | owner  | species | sex  | birth      | death |
+-------+--------+---------+------+------------+-------+
| Claws | Gwen   | cat     | m    | 2009-03-17 | NULL  |
| Buffy | Harold | dog     | f    | 2004-05-13 | NULL  |
+-------+--------+---------+------+------------+-------+
2 rows in set (0.00 sec)

mysql>
```

The other type of pattern matching provided by MySQL uses extended **regular expressions**. When you 
test for a match for this type of pattern, use the 'REGEXP_LIKE()' function (or the REGEXP or 
RLIKE operators, which are synonyms for 'REGEXP_LIKE())'.

To find names containing a w, use this query:

￼```sql
mysql> SELECT * FROM pet WHERE REGEXP_LIKE(name, 'w');
ERROR 1305 (42000): FUNCTION tutorial.REGEXP_LIKE does not exist
mysql> 
```

As we can see, my version of MySQL does not support 'REGEXP_LIKE'. So let's try something different:

```sql
mysql> SELECT * FROM pet WHERE name REGEXP 'w';
+----------+-------+---------+------+------------+------------+
| name     | owner | species | sex  | birth      | death      |
+----------+-------+---------+------+------------+------------+
| Claws    | Gwen  | cat     | m    | 2014-03-17 | NULL       |
| Bowser   | Diane | dog     | m    | 2009-08-31 | 2015-07-29 |
| Whistler | Gwen  | bird    | m    | 2017-12-09 | NULL       |
+----------+-------+---------+------+------------+------------+
3 rows in set (0.00 sec)

mysql>
mysql> SELECT * FROM pet WHERE name REGEXP '^w';
+----------+-------+---------+------+------------+-------+
| name     | owner | species | sex  | birth      | death |
+----------+-------+---------+------+------------+-------+
| Whistler | Gwen  | bird    | m    | 2017-12-09 | NULL  |
+----------+-------+---------+------+------------+-------+
1 row in set (0.00 sec)

mysql>
```

