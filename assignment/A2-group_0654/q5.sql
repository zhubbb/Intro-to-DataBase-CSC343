set search_path to uber;
Drop view if exists bill cascade;
Drop view if exists bill_null cascade;
Drop view if exists bill_notnull cascade;
Drop view if exists average cascade;


--with drive
create view bill_notnull as 
select request.client_id,
extract(year from request.datetime) as y,
extract(month from request.datetime) as m,
sum(Billed.amount) as amount
from dropoff,request,Billed
where dropoff.request_id=request.request_id
and request.request_id=Billed.request_id 
group by request.client_id,extract(year from request.datetime),
extract(month from request.datetime);

--select * from bill_notnull;

--without drive --or cast ('0' as integer)
create view bill_null as 
select distinct client.client_id,
extract(year from request.datetime) as y,
extract(month from request.datetime) as m,
0 as amount
from client,dropoff,request
where dropoff.request_id=request.request_id
and not exists(
select r.request_id
from request r join dropoff d on r.request_id =d.request_id
where extract(year from r.datetime) = 
extract(year from dropoff.datetime)
and extract(month from r.datetime) =
extract(month from dropoff.datetime)
and r.client_id=client.client_id);



create view bill as 
select * from bill_notnull union select * from bill_null;


--average amount
create view average as 
select sum(billed.amount)/count(distinct request.client_id)
 as avg,extract(year from request.datetime) as y,
extract(month from request.datetime) as m
from billed,request,dropoff
where dropoff.request_id=request.request_id
and billed.request_id=request.request_id 
group by extract(year from request.datetime),
extract(month from request.datetime)
having count(distinct request.client_id)!=0
;



--select * from average;
--select * from bill;

create view answer as 
(select bill.client_id, 
cast(bill.y as text)||(' ')||cast(bill.m as text) as month,
bill.amount as total,
'at or above' as comparison
from bill,average
where bill.amount>=avg
and average.y=bill.y 
and average.m=bill.m)
union 
(select bill.client_id, 
cast(bill.y as text)||(' ')||cast(bill.m as text) as month,
bill.amount as total,
'below' as comparison
from bill,average
where bill.amount<avg
and average.y=bill.y 
and average.m=bill.m)
order by month,total,client_id
;

select * from answer;
