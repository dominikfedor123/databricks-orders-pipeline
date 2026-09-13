{{
    config(
        alias='customer_order_summary'
    )
}}

select
    customer_id,

    count(*) as total_orders,

    sum(
        case
            when status = 'COMPLETED' then 1
            else 0
        end
    ) as completed_orders,

    sum(
        case
            when status = 'CANCELLED' then 1
            else 0
        end
    ) as cancelled_orders,

    sum(amount) as total_amount,

    avg(amount) as avg_order_amount,

    max(last_updated) as last_order_timestamp

from {{ ref('gold_orders') }}

group by customer_id
