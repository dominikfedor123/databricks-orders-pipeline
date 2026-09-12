{{
    config(
        materialized='incremental',
        unique_key='order_id',
        incremental_strategy='merge'
    )
}}

with valid_orders as (

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

    from {{ ref('core_orders') }}

    where dq_overall = 1

    {% if is_incremental() %}

        and load_timestamp > (
            select coalesce(
                max(load_timestamp),
                timestamp('1900-01-01')
            )
            from {{ this }}
        )

    {% endif %}

),

latest_version as (

    select *

    from valid_orders

    qualify row_number() over (
        partition by order_id
        order by
            last_updated desc,
            event_id desc
    ) = 1

)

select *
from latest_version
