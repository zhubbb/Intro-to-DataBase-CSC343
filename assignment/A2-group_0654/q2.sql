SET search_path TO uber, public;
DROP VIEW IF EXISTS before2014 cascade;
DROP VIEW IF EXISTS Answer cascade;

--Find clients who had rides before 2014 costing at 
--least $500 in total, have had between 1 and 10 rides in 2014,
--and have had fewer rides in 2015 than in 2014

create view before2014(client_id, billed) as
select Request.client_id, sum(Billed.amount)
from Request, Billed
where Request.request_id=Billed.request_id 
and extract(year from Request.datetime)<2014
group by Request.client_id
having sum(Billed.amount)>=500
;


--find client who had ride between 1 and 10 
create view between10(client_id, count) as
select Request.client_id, count(Request.datetime)
from Request, before2014, Dropoff
where Request.request_id=Dropoff.request_id
and Request.client_id=before2014.client_id 
and extract(year from Request.datetime)=2014
group by Request.client_id
having count(Request.datetime)<=10 and count(Request.datetime)>=1
;

--Find clients who had rides in 2015
create view ride2015(client_id, count2) as
select Request.client_id, count(Request.datetime)
from Request, between10, Dropoff
where Request.request_id=Dropoff.request_id
and Request.client_id=between10.client_id 
and extract(year from Request.datetime)=2015
group by Request.client_id
;

--When reporting their name, create a string that combines the 
--customer's first name and surname name, with a single blank between. 
-- Do not add any punctuation, but if
--either attribute contains punctuation, leave it as is.  
--For this query, if an email address is NULL, report it as unknown
create view Answer(client_id) as
select Client.client_id, 
(Client.firstname||(' ')||Client.surname) as name, 
Client.email, before2014.billed, 
(between10.count-ride2015.count2)as decline
from Client natural join before2014 
natural join ride2015 natural join between10
--where Client.client_id=before2014.client_id and 
--Client.client_id=ride2015.client_id and  Client.client_id=between10.client_id
where ride2015.count2<between10.count
order by before2014.billed DESC
;

select * from Answer;
