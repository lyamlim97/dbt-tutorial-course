with
    order_details as (
        select order_id, count(*) as num_of_items_in_order
        from {{ ref("stg_ecommerce__order_items") }}
        group by order_id
    )

select o.order_id, o.num_items_ordered, od.order_id, od.num_of_items_in_order
from {{ ref("stg_ecommerce__orders") }} as o
full outer join order_details as od on o.order_id = od.order_id
where
    o.order_id is null
    or od.order_id is null
    or o.num_items_ordered != od.num_of_items_in_order
