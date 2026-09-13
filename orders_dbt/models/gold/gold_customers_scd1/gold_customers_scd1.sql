{{
    config(
        materialized='incremental',
        unique_key='customer_id',
        incremental_strategy='merge',
        tags=['customers_pipeline']
    )
}}

with valid_customers as (

    select
        customer_id,
        first_name,
        last_name,
        email,
        country,
        city,
        customer_type,
        registration_date,
        last_updated,
        event_id,
        batch_id

    from {{ ref('core_customers') }}

    where dq_overall = 1

),

latest_customer as (

    select *

    from valid_customers

    qualify row_number() over (
        partition by customer_id
        order by last_updated desc, event_id desc
    ) = 1

)

select *
from latest_customer

{% if is_incremental() %}

where last_updated >= (
    select coalesce(max(last_updated), timestamp('1900-01-01'))
    from {{ this }}
)

{% endif %}
