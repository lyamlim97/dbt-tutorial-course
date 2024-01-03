{% macro get_brand_name() %}
    create or replace function {{ target.schema }}.get_brand_name(web_link string)
    returns string
    as (regexp_extract(web_link, r'.+/brand/(.+)'))
{% endmacro %}
