USE ROLE SYSADMIN;
USE DATABASE SANDBOX;
USE WAREHOUSE COMPUTE_WH;
USE SCHEMA CONSUMPTION_SCH;

create or replace view consumption_sch.vw_yearly_revenue_kpis as
select
    d.year as year, -- fetch year from date_dim
    sum(fact.subtotal) as total_revenue,
    count(distinct fact.order_id) as total_orders,
    round(sum(fact.subtotal) / count(distinct fact.order_id), 2) as avg_revenue_per_order,
    round(sum(fact.subtotal) / count(fact.order_item_id), 2) as avg_revenue_per_item,
    max(fact.subtotal) as max_order_value
from
    consumption_sch.order_item_fact fact
join
    consumption_sch.date_dim d
on
    fact.order_date_dim_key = d.date_dim_hk -- join fact table with date_dim table
where DELIVERY_STATUS = 'Delivered'
group by
    d.year
order by
    d.year;