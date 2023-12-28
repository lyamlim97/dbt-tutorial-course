{% test primary_key(model, column_name) %}
    with
        validation as (
            select {{ column_name }} as primary_key, count({{ column_name }} ) as occurrences
            from {{ model }}
            group by {{ column_name }}
        )

    select *
    from validation
    where primary_key is null or occurrences > 1
{% endtest %}
