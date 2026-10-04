{{
    config(
        materialized='table',
        tags=['customer_orders_export']
    )
}}

select
    o.order_id,
    o.customer_id,

    -- order attributes
    o.amount,
    o.currency,
    o.payment_method,
    o.status as order_status,
    o.order_date,

    -- customer attributes
    c.first_name,
    c.last_name,
    c.email,
    c.country,
    c.city,
    c.customer_type,
    c.registration_date,
    case
        when c.customer_id is null then false
        else true
    end as customer_matched,

    -- technical metadata
    o.last_updated as order_last_updated,
    c.last_updated as customer_last_updated

from {{ ref('gold_orders') }} o

left join {{ ref('gold_customers_scd1') }} c
    on o.customer_id = c.customer_id
