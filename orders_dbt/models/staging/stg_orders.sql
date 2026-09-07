select
    try_cast(order_id as int) as order_id,
    try_cast(customer_id as int) as customer_id,

    amount as amount_raw,

    case
        when amount is null then null
        when upper(trim(amount)) = 'N/A' then null
        when trim(amount) rlike '^-?[0-9]+(\\.[0-9]+)?([ ]+[A-Za-z]+)?$'
            then try_cast(
                regexp_extract(
                    trim(amount),
                    '^(-?[0-9]+(?:\\.[0-9]+)?)',
                    1
                ) as decimal(10,2)
            )
        else null
    end as amount,

    upper(trim(status)) as status,

    order_date as order_date_raw,

    coalesce(
        try_to_date(trim(order_date), 'yyyy-MM-dd'),
        try_to_date(trim(order_date), 'dd/MM/yyyy'),
        try_to_date(trim(order_date), 'dd-MM-yyyy'),
        try_to_date(trim(order_date), 'yyyy/MM/dd')
    ) as order_date,

    case
        when currency is null then null
        when trim(currency) = '' then null
        else upper(trim(currency))
    end as currency,

    case
        when payment_method is null then null
        when trim(payment_method) = '' then null
        else upper(trim(payment_method))
    end as payment_method,

    try_cast(last_updated as timestamp) as last_updated,
    try_cast(event_id as int) as event_id,

    batch_id,
    source_file,
    load_timestamp

from {{ source('bronze', 'orders') }}

