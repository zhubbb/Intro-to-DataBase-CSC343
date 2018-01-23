set search_path to uber;

drop view if exists Answer cascade ;
drop view if exists driver_dropoff cascade ;
drop view if exists driver_pickup cascade ;
drop view if exists ride_duration cascade ;
drop view if exists breaktime cascade ;




create view driver_dropoff(driver_id,request_id,datetime) as 
select Dispatch.driver_id,Dispatch.request_id,Dropoff.datetime
from Dispatch,Dropoff
where Dispatch.request_id = Dropoff.request_id;


create view driver_pickup(driver_id,request_id,datetime) as
select Dispatch.driver_id,Dispatch.request_id,Pickup.datetime
from Dispatch,Pickup
where Dispatch.request_id = Pickup.request_id;

--break time --we can use datetime-datetime<24? no ,use date instead
create view breaktime_notnull(driver_id,request_id,breaktime) as 
select driver_dropoff.driver_id,driver_dropoff.request_id,
min(driver_pickup.datetime-driver_dropoff.datetime) as breaktime,
date(driver_dropoff.datetime)
from driver_dropoff,driver_pickup 
where driver_dropoff.driver_id=driver_pickup.driver_id 
and driver_pickup.request_id != driver_dropoff.request_id 
and date(driver_dropoff.datetime)=date(driver_pickup.datetime)
and driver_Pickup.datetime > driver_Dropoff.datetime
group by driver_dropoff.driver_id, 
date(driver_dropoff.datetime),driver_dropoff.request_id;



--breaktime --those without breaktime
create view breaktime_null(driver_id,request_id,breaktime) as 
select d1.driver_id,d1.request_id,
interval '0' as breaktime,
date(d1.datetime)
from driver_dropoff d1
where
d1.request_id = all(
select request_id 
from driver_dropoff d2
where date(d1.datetime)=date(d2.datetime)
);


create view breaktime as 
select * from breaktime_notnull union 
select * from breaktime_null;


--ride duration per day --use date function
create view ride_duration(driver_id,date,totaltime) as
select d.driver_id,date(d.datetime),
sum(d.datetime-p.datetime) as totaltime
from driver_pickup p,driver_dropoff d
where p.request_id=d.request_id 
and date(d.datetime)=date(p.datetime)
group by d.driver_id,date(d.datetime);


--with the  total time in that day
create view invalid_list as 
select distinct r.driver_id, 'invalid' as validation , r.date,
sum(r.totaltime) as totaltime, sum(b.breaktime) as breaktime
from ride_duration r , breaktime b 
where r.driver_id=b.driver_id and r.date = b.date
and r.totaltime>=interval '12 hours' 
and not exists 
(select breaktime.request_id
from breaktime
where Breaktime.request_id=b.request_id 
and Breaktime.breaktime > interval '15 minutes')
group by r.driver_id, r.date;
--select * from breaktime;
--select * from ride_duration;
--select * from invalid_list;


--three consecutive days 
create view Answer as 
select l1.driver_id as driver, l1.date as start , 
(l1.totaltime+l2.totaltime+l3.totaltime) as driving,
(l1.breaktime + l2.breaktime +l3.breaktime) as breaks
from invalid_list as l1,invalid_list as l2,invalid_list as l3
where l2.date-l1.date= 1
and l3.date-l2.date= 1
and l1.driver_id =l2.driver_id
and l2.driver_id=l3.driver_id;
order by driving desc, breaks asc
;

select * from Answer;
