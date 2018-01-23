-- Demonstration of how to use the <@> operator to compute the distance in miles
-- between two points on the globe.  Cool!

-- Use \i to import this file into psql.

-- Here we define a "schema" where we can put our little example and keep it
-- separate from other things in your database.
-- Notice that the search path includes "public".  That is necessary
-- in order to make the <@> operator work.

SET search_path TO uber, public;

-- Here we define a table and store locations in it.  (This is the same
-- table definition and data as used in the A2 starter code.)
-- Locations are specified as longitude and latitude (in that order), in degrees.
-- The psql documentation says that "Points are taken as (longitude, latitude) 
-- and not vice versa because longitude is closer to the intuitive idea of x-axis 
-- and latitude to y-axis.



-- And here's the big punchline:
-- We can use the <@> operator to compare pairs of locations and compute their 
-- distance in miles.  We will use this distance is "as the crow flies",
-- computed without regard to where the streets are, in Assignment 2.
-- Here, we compute that distance between every pair of locations.
select p1.name as start, p2.name as finish, p1.location <@> p2.location as distance
from place p1, place p2
where p1.name < p2.name;
