select
    epr.created_at::Date,
    count(epr.prescription_id)
from emr.prescriptions ep
inner join emr.prescription_errors epr
    on ep.prescription_id = epr.prescription_id
where epr.error ilike '%Unable to connect to the remote server%'
    and epr.created_at >= now() - interval '1 month'
    group by 1;

--=====================================
select
    ep.visit_id,
    dp.dosespot_prescription_id,
    pe.created_at as error_occured
from emr.prescriptions ep
inner join dosespot.prescriptions dp
    on ep.prescription_id = dp.prescription_id
inner join emr.prescription_errors pe
    on pe.prescription_id = ep.prescription_id
where ep.prescription_id in ('1411217','1411481','1411719','1411762','1412182','1412185','1412766','1413172');