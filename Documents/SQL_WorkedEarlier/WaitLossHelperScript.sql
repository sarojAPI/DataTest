select
    o.created_at,
    o.id as order_id,
    o.order_type,
    o.status,
    o.user_id,
    v.id as visit_id,
    oi.product_id,
    p_sub.prescriptions,
    s.amount as charged_amount
from store.orders o
left join store.visits v
    on o.id = v.order_id
inner join store.order_items oi
    on o.id = oi.order_id
inner join (select
                p.id,
                p.prescriptions
            from store.products p
            where p.prescriptions = '{WEIGHT_MANAGEMENT}'
            ) as p_sub
                on oi.product_id = p_sub.id
inner join bo.stripe_orders s
    on oi.order_id = s.order_id
where o.created_at >= now() -interval '30 day' order by 1;