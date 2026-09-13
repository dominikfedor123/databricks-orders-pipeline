{{
    config(
        tags=['customers_pipeline']
    )
}}

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
    batch_id,

    case
        when dq_customer_id = 0 then 'INVALID_CUSTOMER_ID'
        when dq_email = 0 then 'INVALID_EMAIL'
        when dq_country = 0 then 'INVALID_COUNTRY'
        when dq_customer_type = 0 then 'INVALID_CUSTOMER_TYPE'
        else 'DQ_FAILED'
    end as rejection_reason,

    current_timestamp() as rejected_at

from {{ ref('core_customers') }}

where dq_overall = 0
