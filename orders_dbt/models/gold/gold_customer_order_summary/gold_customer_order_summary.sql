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
            when status = 'PENDING' then 1
            else 0
        end
    ) as pending_orders,

    sum(amount) as total_amount,

    avg(amount) as avg_order_amount,

    max(order_date) as last_order_date,

    max(last_updated) as last_order_timestamp

from {{ ref('gold_orders') }}

group by customer_id
