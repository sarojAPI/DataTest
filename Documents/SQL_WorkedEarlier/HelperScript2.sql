--IMORTANT SCRIPT

select
    count(*),
    done
from q
where task = 'fulfill_flexe'
    and enqueued_at >= '2019-06-27'
group by done;

--EXTRA
 select
    count(order_type)
 from store.orders
 where user_id in (select user_id form store.orders)
    and order_type = 'rx_renewal';

--Another one
Select user_id
,order_id
, case
	when rx_renewal >= 1 then ‘this needs to be checked’
End as user_id_b
From store.orders limit 10;

--Check the order
select
    max(order_type)
from store.orders
where user_id = 'Zuept72k';


--2019/05/22 - Birth Control mismatch( below script)

select
    *
from queue
where q_name = 'emr'
    and enqueued_at >= '2019-05-19'
    and data->>'name' = 'sup.prescription_errors'
    and data#>>'{metadata, _prescription_id}' = '245440';

--Another for to check same time of errors in exec_db_fun:intg.handle_visit_closed

Select
    *
from q
where task = ‘exec_db_fun:intg.handle_visit_closed’
    and failed and enqueued_at >= now() -interval ’24 hour’
    and error ilike ‘EMR script missing in private.prescription%’

--Identify the ddl events (object ) change or function change in database (to see the history of the table or function)

select
    *
from dev.ddl_events
where ddl_event_details->0->>'object_identity' = 'store.address';

select
    *
from dev.ddl_events
where ddl_event_details->0->>'object_identity'
    ilike 'store.create_subscription%'
order by ddl_event_occurred_at;

--select * from dev.ddl_events where ddl_event_transacted_at >= now() - interval '24 hour’;

select ddl_event_transacted_at as modified_date, usename as modified_by, ddl_event_details->0->>'schema_name' as schema, substring(ddl_event_details->0->>'object_identity', 1, 31) as Function_name from dev.ddl_events where ddl_event_transacted_at >= now() - interval '24 hour' and usename != 'aptible';


select * from public.queue_task_duration where q_name = 'herms_fulfillment' and  created_at >= now() - interval '15 mins';

select date_trunc('minute',created_at) as count, count(1) from public.queue_task_duration where q_name = 'herms_fulfillment' and  created_at >= now() - interval '15 mins' group by 1;

--Pick up the date and time when the spike started to see the max and min task duration
select
    task,
    max(task_duration) from public.queue_task_duration
where q_name = 'charges'
    and created_at between '2022-10-13 20:00' and '2022-10-14 12:20'
group by 1 ;

--Pick up the time from alert started and ended
select
    task,
    max(task_duration)
from public.queue_task_duration
where q_name = 'charges'
    and created_at between '2022-10-14 09:06' and '2022-10-14 12:20'
    group by 1 ;

select
    task,
    min(task_duration)
from public.queue_task_duration
where q_name = 'charges' and created_at between '2022-10-14 09:06' and '2022-10-14 12:20'
    group by 1 ;