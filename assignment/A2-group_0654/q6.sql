
set search_path to uber;
Drop view if exists counter cascade;
Drop view if exists greatest cascade;
Drop view if exists second_greatest cascade;
Drop view if exists null_counter cascade;
Drop view if exists notnull_counter cascade;
--greatest per year
create view notnull_counter(client_id,count) as
select client.client_id,count(request.request_id),
extract(year from request.datetime) as y
from dropoff, request right join client
on request.client_id=client.client_id
where dropoff.request_id = request.request_id 
group by extract(year from request.datetime), client.client_id;


--select counter whose value is zero
create view null_counter as
select distinct client.client_id, 0 as count,
extract(year from request.datetime)
from client,request,dropoff
where request.request_id=dropoff.request_id
and not exists(
	select c.client_id   
	from notnull_counter as c 
	where c.client_id=client.client_id
	and c.y=extract(year from request.datetime)
);	

create view counter as 
select * from notnull_counter union
select * from null_counter;



--find client who spend most
create view greatest as 
select client_id , count, y
from counter c1
where count=(
	select max(count)
	from counter c2
	where c2.y=c1.y
);

--find client who spend second most
create view second_greatest as 
select c1.client_id,c1.count,c1.y
from counter c1
where c1.count=(
	select max(count)
	from (
	(select * from counter) except (select * from greatest)) 
	as c2
	where c2.y=c1.y
);

--find client who spend third most
create view third_greatest as 
select c1.client_id,c1.count,c1.y
from counter c1
where c1.count=(
	select max(count)
	from (
	(select * from counter) except (select * from greatest) 
	except (select * from second_greatest)
	) as c2
	where c2.y=c1.y
);




--find client who spend least
create view lowest as 
select client_id , count, y
from counter c1
where count=(
	select min(c2.count)
	from counter c2
	where c2.y=c1.y
);

--find client who spend second least
create view second_lowest as 
select c1.client_id,c1.count,c1.y
from counter c1
where c1.count=(
	select min(count)
	from (
	(select * from counter) except (select * from lowest)) 
	as c2
	where c2.y=c1.y
);

--find client who spend third least
create view third_lowest as 
select c1.client_id,c1.count,c1.y
from counter c1
where c1.count=(
	select max(c2.count)
	from (
	(select * from counter) except (select * from lowest) 
	except (select * from second_lowest)
	) as c2
	where c2.y=c1.y
);



create view answer as 
select distinct client_id, y as year, count as rides
from (select * from greatest 
union select * from second_greatest 
union select * from third_greatest
union select * from lowest 
union select * from second_lowest 
union select * from third_lowest) as list
order by rides desc, year asc,client_id asc;


select * from answer;
