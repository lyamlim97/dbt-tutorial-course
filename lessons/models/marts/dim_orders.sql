with
    -- Aggregate measures
    order_item_measures as (
        select
            order_id,
            sum(item_sale_price) as total_sale_price,
            sum(product_cost) as total_product_cost,
            sum(item_profit) as total_profit,
            sum(item_discount) as total_discount
        from {{ ref("int_ecommerce__order_items_products") }}
        group by order_id
    )

select
    -- Data from our staging orders table
    od.order_id,
    od.created_at as order_created_at,
    od.shipped_at as order_shipped_at,
    od.delivered_at as order_delivered_at,
    od.returned_at as order_returned_at,
    od.status as order_status,
    od.num_items_ordered,

    -- Metrics on an order level
    om.total_sale_price,
    om.total_product_cost,
    om.total_profit,
    om.total_discount
from {{ ref("stg_ecommerce__orders") }} as od
left join order_item_measures as om on od.order_id = om.order_id
