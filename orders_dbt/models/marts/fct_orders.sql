select
    order_id,
    customer_id,
    amount,
    currency,
    payment_method,
    status,
    order_date,
    last_updated,
    event_id,
    batch_id,
    source_file,
    load_timestamp

from {{ ref('int_orders_validated') }}

where dq_overall = 1

qualify row_number() over (
    partition by order_id
    order by
        last_updated desc,
        event_id desc
) = 1
