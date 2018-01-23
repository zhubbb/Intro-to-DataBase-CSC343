SET search_path TO uber, public;
Drop view if exists Months cascade

create view Months(client_id, m) as
select Request.client_id, 
cast(extract(month from Request.datetime) as text)||(',')
||cast(extract(year from Request.datetime) as text) as m
from Request, Dropoff
where Request.request_id=Dropoff.request_id;



select Client.client_id, Client.email, 
count(distinct Months.m) as months
from Client left outer join Months 
on Client.client_id=Months.client_id
group by Client.client_id
order by count(distinct Months.m) DESC;

--\i data.sql 
--\i uber.ddl 
