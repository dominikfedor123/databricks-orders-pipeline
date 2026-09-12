select
    order_id,
    customer_id,
    amount,
    currency,
    payment_method,
    status,
    order_date,
    last_updated

from {{ ref('gold_orders') }}

where status = 'COMPLETED'
