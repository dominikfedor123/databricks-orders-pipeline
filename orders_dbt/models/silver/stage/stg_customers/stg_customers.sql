{{
    config(
        tags=['customers_pipeline']
    )
}}

select
    try_cast(customer_id as int) as customer_id,

    initcap(trim(first_name)) as first_name,
    initcap(trim(last_name)) as last_name,

    lower(trim(email)) as email,

    upper(trim(country)) as country,
    initcap(trim(city)) as city,

    upper(trim(customer_type)) as customer_type,

    try_cast(registration_date as date) as registration_date,
    try_cast(last_updated as timestamp) as last_updated,

    try_cast(event_id as int) as event_id,

    batch_id,
    load_timestamp

from {{ source('bronze', 'customers') }}
