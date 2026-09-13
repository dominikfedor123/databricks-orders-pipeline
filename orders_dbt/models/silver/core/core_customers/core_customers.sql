{{
    config(
        tags=['customers_pipeline']
    )
}}

with dq_flags as (

    select
        *,

        case
            when customer_id is null then 0
            else 1
        end as dq_customer_id,

        case
            when email is null then 0
            when email not like '%@%' then 0
            else 1
        end as dq_email,

        case
            when country is null then 0
            when country in ('SK', 'CZ', 'DE', 'AT', 'US', 'GB') then 1
            else 0
        end as dq_country,

        case
            when customer_type is null then 0
            when customer_type in ('STANDARD', 'PREMIUM', 'VIP', 'RETAIL', 'BUSINESS') then 1
            else 0
        end as dq_customer_type

    from {{ ref('stg_customers') }}

),

validated as (

    select
        *,

        case
            when dq_customer_id = 0 then 0
            when dq_email = 0 then 0
            when dq_country = 0 then 0
            when dq_customer_type = 0 then 0
            else 1
        end as dq_overall

    from dq_flags

)

select *
from validated

qualify row_number() over (
    partition by batch_id, event_id
    order by last_updated desc
) = 1
