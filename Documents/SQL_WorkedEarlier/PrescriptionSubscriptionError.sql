CREATE FUNCTION sup.prescription_errors(_prescription_id bigint, _attempt integer) RETURNS bigint
    LANGUAGE plpgsql SECURITY DEFINER
    AS $$
declare
  __max_attempts constant int := 5;
  __emr constant text := 'emr_dosespot';
  __presume_ok_attempt constant int := 3;
  _next_attempt_offset interval := '60 sec';
  _q_id bigint;
  _visit_id text;


begin

  -- Skip supervision when the clinician was a test user:
  if exists(
    select *
    from emr.prescriptions
    where prescription_id = _prescription_id
    and dev.is_test_user(clinician_id)) then

    raise info 'Adding prescription for test clinician now...';
    perform intg.add_prescription(_prescription_id);
    return null;

  end if;

  if _attempt > __max_attempts then
    return null;
  end if;

  if exists(
    select *
    from emr.prescription_errors
    where prescription_id = _prescription_id) then
    return null;
  end if;

  if _attempt = __presume_ok_attempt then
    raise info 'Adding prescription now...';
    perform intg.add_prescription(_prescription_id);
  end if;

  -- Create a prescription error check task

  insert into queue (schedule_at, q_name, data)
  select
    now(),
    __emr,
    json_build_object(
      'task', 'get_dosespot_prescription_error',
      'prescription_id', rx.prescription_id,
      'clinician_id', rx.clinician_id,
      'user_id', rx.user_id,
      'visit_id', rx.visit_id,
      'dosespot_clinician_id', dc.dosespot_clinician_id,
      'dosespot_patient_id', p.dosespot_patient_id,
      'dosespot_prescription_id', drx.dosespot_prescription_id
      )
  from
    emr.prescriptions rx
    join dosespot.prescriptions drx using (prescription_id)
    join dosespot.clinicians dc using (clinician_id)
    join dosespot.patients p using (user_id)
  where
    rx.prescription_id = _prescription_id
  returning
    data->>'visit_id' into _visit_id;

  assert _visit_id is not null, 'Could not enqueue prescription worker: not found.';

  insert into queue (schedule_at, q_name, data)
  values (
    now() + _next_attempt_offset,
    __emr,
    json_build_object(
      'task', 'exec_db_fun',
      'name', 'sup.prescription_errors',
      'visit_id', _visit_id,
      'pass_as_json', false,
      'metadata', json_build_object(
        '_prescription_id', _prescription_id,
        '_attempt', _attempt + 1
    )
  ))
  returning id into _q_id;

  return _q_id;

end;
$$;