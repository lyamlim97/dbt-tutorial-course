WITH source AS (
        SELECT *

        FROM {{ source('thelook_ecommerce', 'orders') }}
)

SELECT
        -- IDs
        order_id,
        user_id,

        -- Other columns
        status,
        created_at,
        returned_at,
        shipped_at,
        delivered_at,
        num_of_item AS num_items_ordered

FROM source