# indian-toursim-

mysql> create database indian_tourism2;
Query OK, 1 row affected (0.01 sec)

mysql> use indian_tourism2
Database changed
mysql> CREATE TABLE tourist_destinations (
    ->     destination_id INT AUTO_INCREMENT PRIMARY KEY,   -- Primary Key
    ->     destination_name VARCHAR(100) NOT NULL,          -- Not Null constraint
    ->     state VARCHAR(100) NOT NULL,
    ->     description TEXT,
    ->     popularity INT CHECK (popularity BETWEEN 1 AND 10) -- Check constraint
    -> );
Query OK, 0 rows affected (0.03 sec)

mysql> CREATE TABLE tour_agencies (
    ->     agency_id INT AUTO_INCREMENT PRIMARY KEY,         -- Primary Key
    ->     agency_name VARCHAR(100) NOT NULL,                -- Not Null constraint
    ->     destination_id INT,                               -- Foreign Key reference
    ->     contact_number VARCHAR(15),                       -- We'll add the unique constraint later
    ->     established_year YEAR DEFAULT '2000',
    ->     CONSTRAINT fk_destination FOREIGN KEY (destination_id)
    ->     REFERENCES tourist_destinations(destination_id)
    -> );
Query OK, 0 rows affected (0.05 sec)

mysql> ALTER TABLE tour_agencies ADD CONSTRAINT unique_contact UNIQUE (contact_number);
Query OK, 0 rows affected (0.02 sec)
Records: 0  Duplicates: 0  Warnings: 0

mysql> INSERT INTO tourist_destinations (destination_name, state, description, popularity)
    -> VALUES
    -> ('Taj Mahal', 'Uttar Pradesh', 'Iconic 17th-century Mughal monument', 10),
    -> ('Jaipur', 'Rajasthan', 'Pink city with forts and palaces', 9),
    -> ('Kerala Backwaters', 'Kerala', 'Scenic lakes and houseboats', 8),
    -> ('Goa Beaches', 'Goa', 'Popular beach destination', 9),
    -> ('Leh Ladakh', 'Jammu & Kashmir', 'Mountain desert with high passes', 8);
Query OK, 5 rows affected (0.01 sec)
Records: 5  Duplicates: 0  Warnings: 0

mysql> INSERT INTO tour_agencies (agency_name, destination_id, contact_number, established_year)
    -> VALUES
    -> ('Wonder Tours', 1, '9876543210', 1998),
    -> ('Royal Travels', 2, '9123456780', 2005),
    -> ('Backwater Cruises', 3, '9012345678', 2010),
    -> ('Beach Retreats', 4, '9098765432', 2012),
    -> ('High Pass Adventures', 5, '9988776655', 2015);
Query OK, 5 rows affected (0.01 sec)
Records: 5  Duplicates: 0  Warnings: 0

mysql> -- This query wouldn't work as intended since `agency_id` is an auto-increment integer.
mysql> -- Updating auto-incremented IDs isn't a good practice. Instead, you can update another text field.
mysql> UPDATE tour_agencies
    -> SET agency_name = 'Elite Tours'
    -> WHERE agency_id = 1;
Query OK, 1 row affected (0.01 sec)
Rows matched: 1  Changed: 1  Warnings: 0

mysql> UPDATE tour_agencies
    -> SET agency_name = 'Exclusive Tours'
    -> WHERE agency_id = 2;
Query OK, 1 row affected (0.01 sec)
Rows matched: 1  Changed: 1  Warnings: 0

mysql> CREATE TABLE tour_operators (
    ->     operator_id INT AUTO_INCREMENT PRIMARY KEY,      -- Primary Key
    ->     operator_name VARCHAR(100) NOT NULL,             -- Not Null
    ->     destination_id INT NOT NULL,                     -- Foreign Key
    ->     UNIQUE (operator_name),                          -- Unique Constraint
    ->     CONSTRAINT fk_operator_destination FOREIGN KEY (destination_id)
    ->     REFERENCES tourist_destinations(destination_id)
    -> );
Query OK, 0 rows affected (0.04 sec)

mysql> DELETE FROM tour_operators
    -> WHERE operator_id IN (1, 2);
Query OK, 0 rows affected (0.00 sec)

mysql> ALTER TABLE tour_operators RENAME TO exclusive_tour_operators;
Query OK, 0 rows affected (0.02 sec)

mysql> -- Add a Primary Key (if not already defined)
mysql> ALTER TABLE tourist_destinations
    -> ADD CONSTRAINT PK_Destinations PRIMARY KEY (destination_id);
ERROR 1068 (42000): Multiple primary key defined
mysql>
mysql> -- Add a Foreign Key
mysql> ALTER TABLE tour_agencies
    -> ADD CONSTRAINT FK_Destination FOREIGN KEY (destination_id)
    -> REFERENCES tourist_destinations(destination_id);
ERROR 1826 (HY000): Duplicate foreign key constraint name 'FK_Destination'
mysql>
mysql> -- Change a Column from NOT NULL to NULL
mysql> ALTER TABLE tour_agencies MODIFY contact_number VARCHAR(15) NULL;
Query OK, 0 rows affected (0.01 sec)
Records: 0  Duplicates: 0  Warnings: 0

mysql>
mysql> -- Check Constraint
mysql> ALTER TABLE tourist_destinations
    -> ADD CONSTRAINT chk_popularity CHECK (popularity >= 1 AND popularity <= 10);
Query OK, 5 rows affected (0.05 sec)
Records: 5  Duplicates: 0  Warnings: 0

mysql>
mysql> -- Unique Constraint
mysql> ALTER TABLE tour_agencies
    -> ADD CONSTRAINT unique_contact UNIQUE (contact_number);
ERROR 1061 (42000): Duplicate key name 'unique_contact'
mysql>
mysql> -- AUTO_INCREMENT Example
mysql> ALTER TABLE tour_operators MODIFY operator_id INT AUTO_INCREMENT;
ERROR 1146 (42S02): Table 'indian_tourism2.tour_operators' doesn't exist
mysql>
mysql> -- Default Value Example
mysql> ALTER TABLE tour_agencies MODIFY established_year YEAR DEFAULT 2000;
Query OK, 0 rows affected (0.01 sec)
Records: 0  Duplicates: 0  Warnings: 0

mysql> CREATE TABLE tour_operators (
    ->     operator_id INT AUTO_INCREMENT PRIMARY KEY,      -- Primary Key
    ->     operator_name VARCHAR(100) NOT NULL,             -- Not Null
    ->     destination_id INT NOT NULL,                     -- Foreign Key
    ->     UNIQUE (operator_name),                          -- Unique Constraint
    ->     CONSTRAINT fk_operator_destination FOREIGN KEY (destination_id)
    ->     REFERENCES tourist_destinations(destination_id)
    -> );
ERROR 1826 (HY000): Duplicate foreign key constraint name 'fk_operator_destination'
mysql> SELECT CONSTRAINT_NAME, TABLE_NAME
    -> FROM information_schema.KEY_COLUMN_USAGE
    -> WHERE TABLE_NAME = 'tour_agencies';
+----------------------+---------------+
| CONSTRAINT_NAME      | TABLE_NAME    |
+----------------------+---------------+
| contact_number       | tour_agencies |
| PRIMARY              | tour_agencies |
| unique_contact       | tour_agencies |
| FK_Destination       | tour_agencies |
| tour_agencies_ibfk_1 | tour_agencies |
| PRIMARY              | tour_agencies |
| unique_contact       | tour_agencies |
| fk_destination       | tour_agencies |
+----------------------+---------------+
8 rows in set (0.00 sec)

mysql> ALTER TABLE tour_agencies
    -> DROP INDEX unique_contact;
Query OK, 0 rows affected (0.02 sec)
Records: 0  Duplicates: 0  Warnings: 0

mysql> ALTER TABLE tour_agencies
    -> ADD CONSTRAINT unique_contact UNIQUE (contact_number);
Query OK, 0 rows affected (0.04 sec)
Records: 0  Duplicates: 0  Warnings: 0

mysql> ALTER TABLE exclusive_tour_operators
    -> MODIFY operator_id INT AUTO_INCREMENT;
Query OK, 0 rows affected (0.02 sec)
Records: 0  Duplicates: 0  Warnings: 0

mysql> -- Check existing constraints
mysql> SELECT CONSTRAINT_NAME, TABLE_NAME
    -> FROM information_schema.KEY_COLUMN_USAGE
    -> WHERE TABLE_NAME = 'tour_agencies';
+----------------------+---------------+
| CONSTRAINT_NAME      | TABLE_NAME    |
+----------------------+---------------+
| contact_number       | tour_agencies |
| PRIMARY              | tour_agencies |
| unique_contact       | tour_agencies |
| FK_Destination       | tour_agencies |
| tour_agencies_ibfk_1 | tour_agencies |
| PRIMARY              | tour_agencies |
| unique_contact       | tour_agencies |
| fk_destination       | tour_agencies |
+----------------------+---------------+
8 rows in set (0.00 sec)

mysql>
mysql> -- Drop existing unique constraint if necessary
mysql> ALTER TABLE tour_agencies
    -> DROP INDEX unique_contact;
Query OK, 0 rows affected (0.02 sec)
Records: 0  Duplicates: 0  Warnings: 0

mysql>
mysql> -- Re-add the unique constraint
mysql> ALTER TABLE tour_agencies
    -> ADD CONSTRAINT unique_contact UNIQUE (contact_number);
Query OK, 0 rows affected (0.03 sec)
Records: 0  Duplicates: 0  Warnings: 0

mysql>
mysql> -- Modify operator_id in the renamed table
mysql> ALTER TABLE exclusive_tour_operators
    -> MODIFY operator_id INT AUTO_INCREMENT;
Query OK, 0 rows affected (0.01 sec)
Records: 0  Duplicates: 0  Warnings: 0

mysql> SELECT * FROM tourist_destinations WHERE state = 'Goa';
+----------------+------------------+-------+---------------------------+------------+
| destination_id | destination_name | state | description               | popularity |
+----------------+------------------+-------+---------------------------+------------+
|              4 | Goa Beaches      | Goa   | Popular beach destination |          9 |
+----------------+------------------+-------+---------------------------+------------+
1 row in set (0.00 sec)

mysql> SELECT state, COUNT(destination_id) AS total_destinations
    -> FROM tourist_destinations
    -> GROUP BY state;
+-----------------+--------------------+
| state           | total_destinations |
+-----------------+--------------------+
| Uttar Pradesh   |                  1 |
| Rajasthan       |                  1 |
| Kerala          |                  1 |
| Goa             |                  1 |
| Jammu & Kashmir |                  1 |
+-----------------+--------------------+
5 rows in set (0.00 sec)

mysql> SELECT state, COUNT(destination_id) AS total_destinations
    -> FROM tourist_destinations
    -> GROUP BY state
    -> HAVING total_destinations > 1;
Empty set (0.00 sec)

mysql> SELECT * FROM tourist_destinations ORDER BY popularity DESC;
+----------------+-------------------+-----------------+-------------------------------------+------------+
| destination_id | destination_name  | state           | description                         | popularity |
+----------------+-------------------+-----------------+-------------------------------------+------------+
|              1 | Taj Mahal         | Uttar Pradesh   | Iconic 17th-century Mughal monument |         10 |
|              2 | Jaipur            | Rajasthan       | Pink city with forts and palaces    |          9 |
|              4 | Goa Beaches       | Goa             | Popular beach destination           |          9 |
|              3 | Kerala Backwaters | Kerala          | Scenic lakes and houseboats         |          8 |
|              5 | Leh Ladakh        | Jammu & Kashmir | Mountain desert with high passes    |          8 |
+----------------+-------------------+-----------------+-------------------------------------+------------+
5 rows in set (0.00 sec)

mysql> SELECT DISTINCT state FROM tourist_destinations LIMIT 5;
+-----------------+
| state           |
+-----------------+
| Uttar Pradesh   |
| Rajasthan       |
| Kerala          |
| Goa             |
| Jammu & Kashmir |
+-----------------+
5 rows in set (0.00 sec)

mysql> SELECT MAX(popularity), MIN(popularity), AVG(popularity)
    -> FROM tourist_destinations;
+-----------------+-----------------+-----------------+
| MAX(popularity) | MIN(popularity) | AVG(popularity) |
+-----------------+-----------------+-----------------+
|              10 |               8 |          8.8000 |
+-----------------+-----------------+-----------------+
1 row in set (0.00 sec)

mysql> SELECT * FROM tour_agencies WHERE agency_name LIKE 'Royal%';
Empty set (0.00 sec)

mysql> -- LEFT JOIN
mysql> SELECT a.agency_name, d.destination_name
    -> FROM tour_agencies a
    -> LEFT JOIN tourist_destinations d
    -> ON a.destination_id = d.destination_id;
+----------------------+-------------------+
| agency_name          | destination_name  |
+----------------------+-------------------+
| Elite Tours          | Taj Mahal         |
| Exclusive Tours      | Jaipur            |
| Backwater Cruises    | Kerala Backwaters |
| Beach Retreats       | Goa Beaches       |
| High Pass Adventures | Leh Ladakh        |
+----------------------+-------------------+
5 rows in set (0.00 sec)

mysql>
mysql> -- RIGHT JOIN
mysql> SELECT a.agency_name, d.destination_name
    -> FROM tour_agencies a
    -> RIGHT JOIN tourist_destinations d
    -> ON a.destination_id = d.destination_id;
+----------------------+-------------------+
| agency_name          | destination_name  |
+----------------------+-------------------+
| Elite Tours          | Taj Mahal         |
| Exclusive Tours      | Jaipur            |
| Backwater Cruises    | Kerala Backwaters |
| Beach Retreats       | Goa Beaches       |
| High Pass Adventures | Leh Ladakh        |
+----------------------+-------------------+
5 rows in set (0.00 sec)

mysql>
mysql> -- INNER JOIN
mysql> SELECT a.agency_name, d.destination_name
    -> FROM tour_agencies a
    -> INNER JOIN tourist_destinations d
    -> ON a.destination_id = d.destination_id;
+----------------------+-------------------+
| agency_name          | destination_name  |
+----------------------+-------------------+
| Elite Tours          | Taj Mahal         |
| Exclusive Tours      | Jaipur            |
| Backwater Cruises    | Kerala Backwaters |
| Beach Retreats       | Goa Beaches       |
| High Pass Adventures | Leh Ladakh        |
+----------------------+-------------------+
5 rows in set (0.00 sec)

mysql> SELECT a.agency_name, d.destination_name
    -> FROM tour_agencies a
    -> LEFT JOIN tourist_destinations d
    -> ON a.destination_id = d.destination_id
    -> UNION
    -> SELECT a.agency_name, d.destination_name
    -> FROM tour_agencies a
    -> RIGHT JOIN tourist_destinations d
    -> ON a.destination_id = d.destination_id;
+----------------------+-------------------+
| agency_name          | destination_name  |
+----------------------+-------------------+
| Elite Tours          | Taj Mahal         |
| Exclusive Tours      | Jaipur            |
| Backwater Cruises    | Kerala Backwaters |
| Beach Retreats       | Goa Beaches       |
| High Pass Adventures | Leh Ladakh        |
+----------------------+-------------------+
5 rows in set (0.00 sec)

mysql> -- Start a transaction
mysql> START TRANSACTION;
Query OK, 0 rows affected (0.00 sec)

mysql>
mysql> -- Insert a record and commit
mysql> INSERT INTO tour_agencies (agency_name, destination_id, contact_number, established_year)
    -> VALUES ('Mountain Trekking', 5, '9990001234', 2020);
Query OK, 1 row affected (0.00 sec)

mysql> COMMIT;
Query OK, 0 rows affected (0.00 sec)

mysql>
mysql> -- Savepoint and Rollback Example
mysql> SAVEPOINT save_before_delete;
Query OK, 0 rows affected (0.00 sec)

mysql> DELETE FROM tour_agencies WHERE agency_id = 2;
Query OK, 1 row affected (0.00 sec)

mysql> ROLLBACK TO save_before_delete;
ERROR 1305 (42000): SAVEPOINT save_before_delete does not exist
mysql> -- 1. Start a transaction
mysql> START TRANSACTION;
Query OK, 0 rows affected (0.00 sec)

mysql>
mysql> -- 2. Create a savepoint
mysql> SAVEPOINT save_before_delete;
Query OK, 0 rows affected (0.00 sec)

mysql>
mysql> -- 3. Perform some changes (e.g., delete)
mysql> DELETE FROM tour_agencies WHERE agency_id = 2;
Query OK, 0 rows affected (0.00 sec)

mysql>
mysql> -- 4. Rollback to the savepoint if needed
mysql> ROLLBACK TO save_before_delete;
Query OK, 0 rows affected (0.00 sec)

mysql>
mysql> -- 5. If everything is good, you can commit the transaction
mysql> COMMIT;
Query OK, 0 rows affected (0.00 sec)

mysql> CREATE VIEW all_destinations_view AS
    -> SELECT * FROM tourist_destinations;
Query OK, 0 rows affected (0.01 sec)

mysql> CREATE VIEW popular_destinations AS
    -> SELECT destination_name, state FROM tourist_destinations WHERE popularity > 8;
Query OK, 0 rows affected (0.01 sec)

mysql> CREATE VIEW agency_with_popular_destinations AS
    -> SELECT a.agency_name, d.destination_name
    -> FROM tour_agencies a
    -> JOIN (SELECT destination_name, destination_id FROM tourist_destinations WHERE popularity > 8) d
    -> ON a.destination_id = d.destination_id;
Query OK, 0 rows affected (0.01 sec)

mysql> CREATE VIEW agency_destination_view AS
    -> SELECT a.agency_name, d.destination_name
    -> FROM tour_agencies a
    -> JOIN tourist_destinations d ON a.destination_id = d.destination_id;
Query OK, 0 rows affected (0.01 sec)

mysql> CREATE VIEW agency_destination_view AS
    -> SELECT a.agency_name, d.destination_name
    -> FROM tour_agencies a
    -> JOIN tourist_destinations d ON a.destination_id = d.destination_id;
ERROR 1050 (42S01): Table 'agency_destination_view' already exists
mysql> UPDATE agency_with_popular_destinations
    -> SET agency_name = 'Premier Tours'
    -> WHERE agency_name = 'Wonder Tours';
Query OK, 0 rows affected (0.00 sec)
Rows matched: 0  Changed: 0  Warnings: 0

mysql> -- Drop the view if it exists
mysql> DROP VIEW IF EXISTS popular_destinations;
Query OK, 0 rows affected (0.01 sec)

mysql>
mysql> -- Now create the view
mysql> CREATE VIEW popular_destinations AS
    -> SELECT destination_name, state FROM tourist_destinations WHERE popularity > 8;
Query OK, 0 rows affected (0.00 sec)

mysql> show tables;
+----------------------------------+
| Tables_in_indian_tourism2        |
+----------------------------------+
| agency_destination_view          |
| agency_with_popular_destinations |
| all_destinations_view            |
| exclusive_tour_operators         |
| popular_destinations             |
| tour_agencies                    |
| tourist_destinations             |
+----------------------------------+
7 rows in set (0.00 sec)

mysql>
