select
    sqs.subscription_id,
    sqs.sales_quote_id,
    sqca.created_at charge_attempt_created_at,
    sqca.error_message,
    sqca.result_payment_status
from ecom.sales_quote_subscriptions sqs
inner join bo.subscriptions s
    on sqs.subscription_id = s.order_id
inner join ecom.sales_quote_charge sqc
    on sqs.sales_quote_id = sqc.sales_quote_id
inner join ecom.sales_quote_charge_attempt sqca
    on sqc.sales_quote_charge_id = sqca.sales_quote_charge_id
where s.user_id = '7URRti0b7Wo'
and sqca.result_payment_status <> 'Succeeded';