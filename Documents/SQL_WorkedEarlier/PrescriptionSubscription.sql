CREATE OR REPLACE FUNCTION store.update_subscription() RETURNS trigger
    LANGUAGE plpgsql STRICT SECURITY DEFINER
    AS $$
declare
  _user_id text := get_user();
  _address_metadata json;
  _unfulfilled_order_id text;
begin
  -- Check for row existence to verify user_id
  perform
    1
  from
    bo.subscriptions s
  where
    s.order_id = OLD.order_id
    and s.user_id = _user_id;

  if not found then
    return null;
  end if;

  if OLD.product_ids is distinct from NEW.product_ids then
    -- This view should only allow updating product_ids on bo.subscriptions
    perform bo.update_subscription(OLD.order_id,
                                   OLD.status,
                                   OLD.process_on_date,
                                   NEW.product_ids);
  end if;

  if OLD.address_id is distinct from NEW.address_id then
    select
      jsonb_build_object(
        'subscription_id', OLD.order_id,
        'product_type', store.subscription_type(NEW.product_ids),
        'address_id', id,
        'line1', line1,
        'line2', line2,
        'city', city,
        'state', state,
        'zip', zip,
        'country', coalesce(country, 'US')
      )
    into
      _address_metadata
    from
      store.address
    where
      id = NEW.address_id
      and user_id = _user_id;

    if not found then
      raise exception 'Address not found';
    end if;

    insert into bo.subscription_address (subscription_id, address_id)
    values (OLD.order_id, NEW.address_id);

    insert into audit.subscriptions (order_id, action, data, changed_by)
    values (OLD.order_id, 'update_address', _address_metadata, _user_id);

    -- If there is an unfulfilled order associated with this subscription,
    -- update its shipping address
    _unfulfilled_order_id := bo.find_last_unfulfilled_order_by_subscription_id(OLD.order_id);

    if not _unfulfilled_order_id is null then
      perform bo.maybe_update_order_address(_unfulfilled_order_id);
    end if;

    perform trigger_events('subscription_address_updated', _user_id, _address_metadata);
  end if;

  return NEW;
end
$$;


ALTER FUNCTION store.update_subscription() OWNER TO aptible;