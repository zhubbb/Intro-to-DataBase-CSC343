SET search_path TO uber, public;
DROP VIEW IF EXISTS Months cascade;
DROP VIEW IF EXISTS Answer cascade;


--get the month list from request and dropoff
create view Months(client_id, m) as
select Request.client_id, to_char(request.datetime, 'YYYY-MM') as m
from Request, Dropoff
where Request.request_id=Dropoff.request_id;

--select client_id and their email with number of month they had ride
create view Answer(client_id, email, months) as
select Client.client_id, Client.email, count(distinct Months.m) as months
from Client left outer join Months on Client.client_id=Months.client_id
group by Client.client_id
order by count(distinct Months.m) DESC;

select * from Answer;

--\i data.sql 
--\i uber.ddl 
