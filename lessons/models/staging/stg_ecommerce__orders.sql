with source as (select * from {{ source("thelook_ecommerce", "orders") }})

select
    -- IDs
    order_id,
    user_id,

    -- Other columns
    status,
    created_at,
    returned_at,
    shipped_at,
    delivered_at,
    num_of_item as num_items_ordered

from source
