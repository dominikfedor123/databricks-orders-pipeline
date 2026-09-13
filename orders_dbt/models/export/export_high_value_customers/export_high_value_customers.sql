select customer_id,
        total_orders,
        total_amount,
        avg_order_amount,
        customer_segment

from {{ ref('gold_customer_segments') }}

where customer_segment = 'HIGH'
