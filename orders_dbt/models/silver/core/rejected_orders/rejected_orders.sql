select
    order_id,
    customer_id,

    amount_raw,
    amount as amount_clean,

    status,

    order_date_raw,
    order_date as order_date_clean,

    cast(last_updated as string) as last_updated,
    cast(event_id as string) as event_id,

    batch_id,
    source_file,

    case
        when order_id is null
            then 'INVALID_ORDER_ID'

        when dq_amount = 0
            then 'INVALID_AMOUNT'

        when dq_customer_id = 0
            then 'INVALID_CUSTOMER_ID'

        when dq_order_date = 0
            then 'INVALID_ORDER_DATE'

        when dq_currency = 0
            then 'INVALID_CURRENCY'

        else 'DQ_FAILED'
    end as rejection_reason,

    current_timestamp() as rejected_at,

    currency_raw,
    currency as currency_clean

from {{ ref('core_orders') }}

where dq_overall = 0
