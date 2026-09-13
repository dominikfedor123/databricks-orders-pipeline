{{
    config(
        materialized='table',
        tags=['customers_pipeline']
    )
}}

with customer_history as (

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

versioned as (

    select
        *,

        row_number() over (
            partition by customer_id
            order by last_updated, event_id
        ) as version_number,

        lead(last_updated) over (
            partition by customer_id
            order by last_updated, event_id
        ) as next_valid_from

    from customer_history

)

select
    sha2(
        concat(
            cast(customer_id as string),
            '|',
            cast(last_updated as string),
            '|',
            cast(event_id as string)
        ),
        256
    ) as customer_sk,

    customer_id,
    first_name,
    last_name,
    email,
    country,
    city,
    customer_type,
    registration_date,

    last_updated as valid_from,

    case
        when next_valid_from is null then null
        else next_valid_from
    end as valid_to,

    case
        when next_valid_from is null then true
        else false
    end as is_current,

    version_number,
    event_id,
    batch_id

from versioned
