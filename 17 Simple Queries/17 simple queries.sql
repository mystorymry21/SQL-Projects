/*******************/
/* 17 SQL Queries */
/*******************/

/* 1. Create Database name sql_projects_github.*/
CREATE SCHEMA `sql_projects_github`;

/* 
2. Create tables:
Years with attributes (id, country, _2022, _2020, _2015, _2010, _2000)
Growth with attributes (id, growth_rates)
Population with attributes (world_population_percentage, continent)
*/
CREATE TABLE years(
		id INT PRIMARY KEY auto_increment,
        country TEXT,
        _2022 INT,
        _2020 INT,
        _2015 INT,
        _2010 INT, 
        _2000 INT 
);

CREATE TABLE growth(
		id INT PRIMARY KEY auto_increment,
        growth_rate DOUBLE NOT NULL
);

CREATE TABLE population(
		id INT PRIMARY KEY auto_increment,
        world_population_percentage double,
        continent TEXT
);

/* 
3. Add rows into Years table
(1, 'China', 1425887, 1424930, 1393715, 1348191, 1264099),
(2, 'India', 1417173, 1396387, 1322867, 1240614, 1059634),
(3, 'United States', 338290, 335942, 324608, 311183, 282399),
(4, 'Indonesia', 275501, 271858, 259092, 244016, 214072)
(5, 'Pakistan', 235825, 227197, 210969, 194454, 154370);
*/
INSERT INTO years (country, _2022, _2020, _2015, _2010, _2000)
VALUES
('China', 1425887, 1424930, 1393715, 1348191, 1264099),
('India', 1417173, 1396387, 1322867, 1240614, 1059634),
('United States', 338290, 335942, 324608, 311183, 282399),
('Indonesia', 275501, 271858, 259092, 244016, 214072),
('Pakistan', 235825, 227197, 210969, 194454, 154370);

/*
4. Add rows into Growth table
(1, 1.00),
(2, 1.01),
(3, 1.00),
(4, 1.01),
(5, 1.02);
*/
INSERT INTO growth (growth_rate)
VALUES
(1.00),
(1.01),
(1.00),
(1.01),
(1.02);

/* 
5. Add rows into Population table
(1, 17.88, 'Asia'),
(2, 17.77, 'Asia'),
(3, 4.24, 'Asia'),
(4, 3.45, 'Asia'),
(5, 2.96, 'Asia');
*/
INSERT INTO population (world_population_percentage, continent)
VALUES
(17.88, 'Asia'),
(17.77, 'Asia'),
(4.24, 'Asia'),
(3.45, 'Asia'),
(2.96, 'Asia');

/*
6. Query all rows from Population table
*/
SELECT * FROM population;

/*
7. Change the name of population with world_population_percentage = 4.24 to 'North America'
*/
UPDATE population
SET continent = 'North America'
WHERE world_population_percentage = 4.24;

/*
8. Query Id, country, and 2022 of years table
*/
SELECT id, country, _2022
FROM years;

/*
9. Query world population percentage of Population
*/
SELECT world_population_percentage
FROM population;

/*
10. Query all Asia continent 
*/
SELECT continent FROM population;

/*
11. Add new rows into Years table
(6, 'South Africa', 59894, 58802, 55877, 51785, 46813),
(7, 'Italy', 59037, 59501, 60233, 59822, 56966),
(8, 'Myanmar', 54179, 53423, 51484, 49391, 45538),
(9, 'Kenya', 54027, 51986, 46851, 41518, 30852),
(10, 'Colombia', 51874,	50931, 47120, 44816, 39215),
(11, 'South Korea',	51816, 51845, 50994, 48813, 46789);

*/
INSERT INTO years (country, _2022, _2020, _2015, _2010, _2000)
VALUES
('South Africa', 59894, 58802, 55877, 51785, 46813),
('Italy', 59037, 59501, 60233, 59822, 56966),
('Myanmar', 54179, 53423, 51484, 49391, 45538),
('Kenya', 54027, 51986, 46851, 41518, 30852),
('Colombia', 51874,	50931, 47120, 44816, 39215),
('South Korea',	51816, 51845, 50994, 48813, 46789);

/*
12. Add new rows into Growth table
*/
INSERT INTO growth (growth_rate)
VALUES
(1.01),
(1.00),
(1.01),
(1.02),
(1.01),
(1.00);
SELECT * FROM growth;

/*
13. Add new rows into Population table
*/
INSERT INTO population (world_population_percentage, continent)
VALUES
(0.75, 'Africa'),
(0.74, 'Europe'),
(0.68, 'Asia'),
(0.68, 'Africa'),
(0.65, 'South America'),
(0.65, 'Asia');
SELECT * FROM population;

/*
14. Sum all years of population in Years table
*/
SELECT id, country, _2022, _2020, _2015, _2010, _2000,
		SUM(_2022 + _2020 + _2015 + _2010 + _2000) AS Total
FROM years
GROUP BY country
ORDER BY Total DESC;

/* 
15. Query name of all countries with world population using Join
*/
SELECT y.country, g.growth_rate, p.continent
FROM years y
JOIN growth g ON g.id = y.id
JOIN population p ON p.id = y.id;

/*
16. Query name of all countries with world population using Join, 
and Filter growth rate = 1 and continent = Asia
*/
SELECT y.country, g.growth_rate, p.continent
FROM years y
JOIN growth g ON g.id = y.id
JOIN population p ON p.id = y.id
WHERE g.growth_rate > 1 AND p.continent = 'Asia';

/* 17. Delete table Years, Growth, Populations. */
DROP TABLE years;
DROP TABLE Growth;
DROP TABLE population;
