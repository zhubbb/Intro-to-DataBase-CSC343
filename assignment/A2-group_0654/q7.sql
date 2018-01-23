set search_path to uber;
Drop view if exists ratinglist cascade;
Drop view if exists answer cascade;



create view ratinglist(driver_id, rating) as 
select d.driver_id, r.rating
from DriverRating as r right join dispatch as d
on r.request_id=d.request_id;

--select * from ratinglist;

--rating at 5
create view r5 as 
select driver.driver_id, count(rating) as r5 
from ratinglist right join driver 
on driver.driver_id=ratinglist.driver_id
where rating=5
group by driver.driver_id;

--rating at 4
create view r4 as 
select driver.driver_id , count(rating) as r4
from ratinglist right join driver 
on driver.driver_id=ratinglist.driver_id
where rating=4
group by driver.driver_id;

--rating at 3
create view r3 as 
select driver.driver_id , count(rating) as r3
from ratinglist right join driver 
on driver.driver_id=ratinglist.driver_id
where rating=3
group by driver.driver_id;
--rating at 2
create view r2 as 
select driver.driver_id, count(rating) as r2
from ratinglist right join driver 
on driver.driver_id=ratinglist.driver_id
where rating=2
group by driver.driver_id;
--rating at 1
create view r1 as 
select driver.driver_id , count(rating) as r1
from ratinglist join driver 
on driver.driver_id=ratinglist.driver_id
where rating=1
group by driver.driver_id;


create view answer as
select driver.driver_id,r5,r4,r3,r2,r1
from r5 natural full outer join 
r4 natural full outer join 
r3 natural full outer join 
r2 natural full outer join 
r1 natural full outer join driver
order by r5 desc, r4 desc, r3 desc, r2 desc, r1 desc, driver.driver_id asc;



select * from answer;
