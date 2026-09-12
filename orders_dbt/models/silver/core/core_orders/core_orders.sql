with dq_flags as (

    select
        *,

        case
            when amount_raw is null then 1
            when upper(trim(amount_raw)) = 'N/A' then 1
            when amount is not null then 1
            else 0
        end as dq_amount,

        case
            when customer_id is null then 0
            else 1
        end as dq_customer_id,

        case
            when order_date_raw is null then 0
            when order_date is not null then 1
            else 0
        end as dq_order_date,

        case
            when currency is null then 1
            when currency in ('EUR', 'USD', 'GBP') then 1
            else 0
        end as dq_currency

    from {{ ref('stg_orders') }}

),

validated as (

    select
        *,

        case
            when order_id is null then 0
            when dq_amount = 0 then 0
            when dq_customer_id = 0 then 0
            when dq_order_date = 0 then 0
            when dq_currency = 0 then 0
            else 1
        end as dq_overall

    from dq_flags

)

select *
from validated

qualify row_number() over (
    partition by batch_id, event_id
    order by
        last_updated desc,
        load_timestamp desc
) = 1
