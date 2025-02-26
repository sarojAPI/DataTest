
--Error check in Queue & in ETL

select
	e.created_at::date as error_occurred_at
	-- , q_task(q.data) as task
	, q_visit_id(q.data) as visit_id
from queue_errors e
inner join queue q
	on q.id = e.queue_id
--where q_task(q.data) = 'add_payment_instrument'
where e.error ilike 'No user subscription found for medical service%'
	and e.created_at >= now() - interval '30 day'
	order by 2 ;
	-- group by 1;

--Trupil check

select
    *
from integration_activity
where name = 'truepill'
    and data#>>'{details,metadata}' = 'C2bKgn1r';


--Check how many containers under this worker
--aptible services --app forhims-prod-workers-herms-fulfillment

--Container Count: 1

--See how many orders are there to be processed
select task, count(1) from q where q_name = 'herms_fulfillment' and not done group by 1;

--See the max not done queue id
select max(id) from q where q_name = 'herms_fulfillment' and not done;

select max(id) from q where q_name = 'herms_fulfillment' and enqueued_at >= now() - interval '1 hour' and not done;

--See the not done task
select * from q where task = 'fulfill_herms_fulfillment' and  not done limit 1;

--See the not done queue under task
select * from q where q_name = 'herms_fulfillment' and  not done limit 1;

--See the done task
select * from q where task = 'fulfill_herms_fulfillment' and  done limit 1;


--See how many orders are there to be processed
select task, count(1) from q where q_name = 'herms_fulfillment' and not done group by 1;

--See the max not done queue id
select max(id) from q where q_name = 'herms_fulfillment' and not done;

