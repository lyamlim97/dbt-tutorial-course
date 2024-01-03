with
    -- Aggregate measures
    order_item_measures as (
        select
            order_id,
            sum(item_sale_price) as total_sale_price,
            sum(product_cost) as total_product_cost,
            sum(item_profit) as total_profit,
            sum(item_discount) as total_discount,
            {% for department in dbt_utils.get_column_values(
                table=ref("int_ecommerce__order_items_products"),
                column="product_department",
            ) %}
                sum(
                    if(product_department = '{{ department }}', item_sale_price, 0)
                ) as total_sold_{{ department.lower() }}swear{{ "," if not loop.last }}
            {%- endfor %}
        from {{ ref("int_ecommerce__order_items_products") }}
        group by order_id
    )

select
    -- Data from our staging orders table
    od.order_id,
    od.created_at as order_created_at,
    {{ is_weekend("od.created_at") }} as order_was_created_on_weekend,
    od.shipped_at as order_shipped_at,
    {{ is_weekend("od.order_shipped_at") }} as order_was_shipped_on_weekend,
    od.delivered_at as order_delivered_at,
    od.returned_at as order_returned_at,
    od.status as order_status,
    od.num_items_ordered,

    -- Metrics on an order level
    om.total_sale_price,
    om.total_product_cost,
    om.total_profit,
    om.total_discount,
    {% for department in departments %}
        total_sold_{{ department.lower() }}swear{{ "," if not loop.last }}
    {%- endfor %},
    timestamp_diff(
        od.created_at, user_data.first_order_created_at, day
    ) as days_since_first_order
from {{ ref("stg_ecommerce__orders") }} as od
left join order_item_measures as om on od.order_id = om.order_id
left join
    {{ ref("int_ecommerce__first_order_created") }} as user_data
    on user_data.user_id = od.user_id
