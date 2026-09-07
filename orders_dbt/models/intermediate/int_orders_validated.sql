select
    *,

    case
        when order_id is null then 0

        when customer_id is null then 0

        when amount is null
             and amount_raw is not null then 0

        when currency is not null
             and currency not in ('EUR', 'USD', 'GBP') then 0

        else 1
    end as dq_overall

from {{ ref('stg_orders') }}
