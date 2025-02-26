CREATE OR REPLACE FUNCTION dosespot.sup_clinician_registration(_clinician_id text) RETURNS boolean
    LANGUAGE plpgsql SECURITY DEFINER
    AS $$

declare
  __emr constant text := 'emr_dosespot';

  __supervisor_task constant text := 'dosespot.sup_clinician_registration';
  __task constant text := 'verify_dosespot_clinician_registration';
  __offset constant interval := '30 minutes';
  _dosespot_clinician_id text;
  _domain text;

begin
  -- Skip supervision when the clinician is a test user:

  if dev.is_test_user(_clinician_id) then
    return false;
  end if;

  if exists(
    select *
    from dosespot.clinician_registrations
    where clinician_id = _clinician_id
  ) then
    return false;
  end if;

  if exists(
    select *
    from emr.clinicians
    where clinician_id = _clinician_id
      and NOT active
  ) then
    return false;
  end if;