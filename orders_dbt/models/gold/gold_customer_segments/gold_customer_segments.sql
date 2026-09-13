select
    customer_id,
    total_orders,
    total_amount,
    avg_order_amount,

    case
        when total_amount >= 1000 then 'HIGH'
        when total_amount >= 500 and total_amount < 1000 then 'MEDIUM'
        when total_amount < 500 then 'LOW'
    end as customer_segment

from {{ ref('gold_customer_summary') }}
