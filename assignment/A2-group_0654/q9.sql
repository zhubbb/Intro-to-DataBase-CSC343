SET search_path TO uber, public;
DROP VIEW IF EXISTS clientanddriver cascade;

--put client id driver id together
create view clientanddriver(request_id, client_id, driver_id) as
select Request.request_id, Request.client_id, Dispatch.driver_id
from Request, Dropoff, Dispatch
where Request.request_id=Dropoff.request_id
and Dispatch.request_id=Request.request_id
;

--get client who has rate other driver before
create view clientrated(client_id, driver_id) as
select clientanddriver.client_id, clientanddriver.driver_id
from clientanddriver natural join DriverRating
;

--get client who has not rate other driver before
create view clientnotrated(client_id, driver_id) as
select clientanddriver.client_id, clientanddriver.driver_id
from clientanddriver natural full outer join DriverRating
where DriverRating.rating is null
;

--get all the unwanted client
create view notrated as
select client_id
from(
(select * from clientnotrated ) except (select * from clientrated)) as a1
;

--find the answer and join by client to get email
create view clienthaddride(client_id) as
select Request.client_id
from Client, Request, Dropoff
where Request.request_id=Dropoff.request_id
and Client.client_id=Request.client_id
;

create view answer(client_id, email) as
select Client.client_id, Client.email
from Client, (
(select * from clienthaddride ) except (select * from notrated)) as a1
where Client.client_id= a1.client_id
order by Client.email ASC
;

select * from answer;

--\i data.sql 
--\i uber.ddl 
