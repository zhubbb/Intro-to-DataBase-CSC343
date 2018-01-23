SET search_path TO uber, public;
DROP VIEW IF EXISTS reciprocals cascade;

## ANNOTATION 1: A comment of what this view does would be helpful. ##
create view reciprocals(request_id, client_id, 
DriverRating, ClientRating) as
select Request.request_id, Request.client_id, 
DriverRating.rating, ClientRating.rating
from Client, Request, DriverRating, ClientRating
where Request.request_id=DriverRating.request_id
and Client.client_id=Request.client_id
and ClientRating.request_id=Request.request_id
## END ANNOTATION 1 ##
;

create view answer(client_id, reciprocals, difference) as
select reciprocals.client_id, count(reciprocals.request_id), 
avg(reciprocals.DriverRating-reciprocals.ClientRating)
from reciprocals
group by reciprocals.client_id
order by avg(reciprocals.DriverRating-reciprocals.ClientRating)
;

select * from answer;

--\i data.sql 
--\i uber.ddl 
