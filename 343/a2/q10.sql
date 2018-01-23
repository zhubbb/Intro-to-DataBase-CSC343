--2014 distance

SET search_path TO uber, public;
Drop view if exists distance2015 cascade;
Drop view if exists bill2015 cascade;
Drop view if exists distance2014 cascade;
Drop view if exists bill2014 cascade;
Drop view if exists months cascade;
Drop view if exists bill2015_null cascade;
Drop view if exists full_bill2015 cascade;
Drop view if exists distance2015_null cascade;
Drop view if exists full_distance2015 cascade;
Drop view if exists bill2014_null cascade;
Drop view if exists full_bill2014 cascade;
Drop view if exists distance2014_null cascade;
Drop view if exists full_distance2014 cascade;
-- Notice that the search path includes "public".  That is necessary
-- in order to make the <@> operator work.

create view distance2015 as
select dis.driver_id,to_char(r.datetime, 'MM') as m, 
sum(p1.location<@>p2.location)
from request as r,dropoff as d, Place as p1,Place as p2,dispatch 
as dis
where r.request_id = d.request_id
and dis.request_id=r.request_id
and extract(year from r.datetime)=2015
and r.source=p1.name
and r.destination=p2.name
group by dis.driver_id, m
;


create view bill2015 as
select dis.driver_id,to_char(r.datetime, 'MM') as m, 
sum(amount)
from request as r, dropoff as d, billed as b,dispatch as dis
where r.request_id = d.request_id
and dis.request_id=r.request_id
and extract(year from r.datetime)=2015
and r.request_id=b.request_id
group by dis.driver_id,m;




create view distance2014 as
select dis.driver_id,to_char(r.datetime, 'MM') as m, 
sum(p1.location<@>p2.location)
from request as r,dropoff as d,Place as p1,Place as p2, dispatch 
as dis
where r.request_id = d.request_id
and dis.request_id=r.request_id
and extract(year from r.datetime)=2014
and r.source=p1.name
and r.destination=p2.name
group by dis.driver_id, m
;

create view bill2014 as
select dis.driver_id,to_char(r.datetime, 'MM') as m, 
sum(amount)
from request as r, dropoff as d, billed as b,dispatch as dis
where r.request_id = d.request_id
and dis.request_id=r.request_id
and extract(year from r.datetime)=2014
and r.request_id=b.request_id
group by dis.driver_id,m;




CREATE VIEW Months as
SELECT to_char(DATE '2014-01-01' +
(interval '1' month * generate_series(0,11)), 'MM')  as m;





create view bill2015_null as 
select driver.driver_id, months.m ,0 as amount
from Months,driver
where not exists(
select bill2015.m
from bill2015
where driver.driver_id = bill2015.driver_id and 
months.m=bill2015.m
);



create view full_bill2015(driver_id,m,sum) as
select * from bill2015 
union
select * from bill2015_null;



create view distance2015_null as 
select driver.driver_id, months.m,0 as amount
from Months,driver
where not exists(
select distance2015.m
from distance2015
where driver.driver_id = distance2015.driver_id and 
months.m=distance2015.m
);



create view full_distance2015(driver_id,m,sum) as
select * from distance2015 
union
select * from distance2015_null;



create view bill2014_null as 
select driver.driver_id, months.m as m,0 as amount
from Months,driver
where not exists(
select bill2014.m
from bill2014
where driver.driver_id = bill2014.driver_id and 
months.m=bill2014.m
);



create view full_bill2014(driver_id,m,sum) as
select * from bill2014 
union
select * from bill2014_null;



create view distance2014_null as 
select driver.driver_id, months.m,0 as amount
from Months,driver
where not exists(
select distance2014.m
from distance2014
where driver.driver_id = distance2014.driver_id and 
months.m=distance2014.m
);



create view full_distance2014(driver_id,m,sum) as
select * from distance2014 
union
select * from distance2014_null;




create view answer as
select b1.driver_id, b1.m as month, 
d1.sum as mileage_2014,
b1.sum as billings_2014,
d2.sum as mileage_2015,
b2.sum as billings_2015,
(b2.sum-b1.sum) as billings_increase,
(d2.sum-d1.sum) as mileage_increase
from full_bill2014 b1,full_bill2015 b2,full_distance2014 d1,
full_distance2015 d2
where b1.driver_id= b2.driver_id
and b1.driver_id= d1.driver_id
and b1.driver_id= d2.driver_id
and b1.m=b2.m
and b1.m=d1.m
and b1.m=d2.m
order by b1.driver_id, month
;

select * from answer;
