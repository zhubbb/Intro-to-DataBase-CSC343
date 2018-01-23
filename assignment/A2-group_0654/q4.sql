SET search_path TO uber, public;
DROP VIEW IF EXISTS tenday cascade;
--DROP VIEW IF EXISTS firstday cascade;

--get the first driver with at least ten day
create view tenday(driver_id) as
select Dispatch.driver_id
from Driver, Dispatch
where Driver.driver_id=Dispatch.driver_id
group by Dispatch.driver_id
having count(Dispatch.request_id)>=10
;

--find their first ride date
create view firstday(datetime, driver_id) as
select Request.datetime, d1.driver_id
from Request, Dispatch d1, Dropoff, tenday
where Request.request_id=d1.request_id 
and tenday.driver_id=d1.driver_id
and Request.request_id=Dropoff.request_id and 
Request.datetime <= 
all(select Request.datetime from Request, Dispatch 
where d1.driver_id=Dispatch.driver_id 
and Request.request_id=Dispatch.request_id )
;

--get the consecutive first 5day
create view firstfive(request_id, driver_id) as
select distinct Request.request_id, Dispatch.driver_id
from Request, Dispatch, firstday
where Dispatch.driver_id=firstday.driver_id and 
Request.request_id =Dispatch.request_id and Request.request_id 
in(select Request.request_id from Request, firstday 
where date(Request.datetime)= date(firstday.datetime) 
or date(Request.datetime)= date(firstday.datetime)+ INTERVAL '1 day' 
or date(Request.datetime)= date(firstday.datetime)+ INTERVAL '2 day' 
or date(Request.datetime)= date(firstday.datetime)+ INTERVAL '3 day' 
or date(Request.datetime)= 
date(firstday.datetime)+ INTERVAL '4 day')
;

--get the early average
create view earlyaverage(average, driver_id) as
select avg(DriverRating.rating), driver_id
from DriverRating natural join firstfive
group by driver_id
;


--get all the day after first five day
create view latefive(request_id, driver_id) as
select Request.request_id, d2.driver_id
from Request, Dispatch d2, firstday
where Request.request_id=d2.request_id 
and d2.driver_id=firstday.driver_id 
and date(Request.datetime) > date(firstday.datetime)+ INTERVAL '4 day' 
;



--get the late average
create view lateaverage(average, driver_id) as
select avg(DriverRating.rating), driver_id
from DriverRating natural join latefive
--order by driver_id
group by driver_id
;


--group by all the trained and untrained 
create view traineddriver(type, number, early, late) as
select cast('trained' as text) as type, 
count(driver.driver_id), 
avg(earlyaverage.average), avg(lateaverage.average)
from earlyaverage, lateaverage, driver
where earlyaverage.driver_id=driver.driver_id 
and lateaverage.driver_id=driver.driver_id and driver.trained=true
group by driver.driver_id
;

create view untraineddriver(type, number, early, late) as
select cast('untrained' as text) as type, 
count(driver.driver_id), 
avg(earlyaverage.average), avg(lateaverage.average)
from earlyaverage, lateaverage, driver
where earlyaverage.driver_id=driver.driver_id 
and lateaverage.driver_id=driver.driver_id and driver.trained=false
group by driver.driver_id
;

create view trained(type, number, early, late) as
select type, count(traineddriver.number), 
avg(traineddriver.early), avg(traineddriver.late)
from traineddriver
group by type
;

create view untrained(type, number, early, late) as
select type, count(untraineddriver.number), 
avg(untraineddriver.early), avg(untraineddriver.late)
from untraineddriver
group by type
;

--union and get the answer
create view answer as
select *
from(
(select * from trained )union (select * from untrained)) as a1
order by type asc
;

select * from answer;

