{{ config(
    materialized='table'
) }}

select
    customer_id,
    upper(payment_method) as payment_method,
    count(order_id) as order_cnt,
    sum(amount) as total_amount,
    avg(amount) as avg_amount,
    max(order_date) as last_order,

    round(
        100.0 * sum(amount)
        / nullif(sum(sum(amount)) over (partition by customer_id), 0),
        2
    ) as payment_method_share

from {{ ref('gold_orders') }}

where upper(payment_method) in ('PAYPAL', 'CARD')

group by
    customer_id,
    upper(payment_method)
