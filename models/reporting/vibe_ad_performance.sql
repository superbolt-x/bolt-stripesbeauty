{{ config (
    alias = target.database + '_vibe_ad_performance'
)}}

{%- set date_granularity_list = ['day','week','month','quarter','year'] -%}


WITH vibe_data AS (
        {% for granularity in date_granularity_list %}
        SELECT 
            '{{granularity}}' as date_granularity,
            date_trunc('{{granularity}}',impression_date) end as date,
			      campaign_id,	
            creative_id,	
            campaign_name,	
            creative_name,
            sum(spend) as spend,
            sum(impressions) as impressions,
            sum(completed_views) as completed_views,
            sum(number_of_page_views) as page_views,
            sum(number_of_sessions) as sessions,
            sum(installs) as installs,
            sum(number_of_leads) as leads,
            sum(number_of_signups) as signups,
            sum(installs) as installs,
            sum(number_of_purchases) as purchases
            sum(amount_of_purchases) as revenue
        FROM {{ source('gsheet_raw','vibe_ads_insights') }}
        GROUP BY 1,2,3,4,5,6
        {% if not loop.last %}UNION ALL{% endif %}
        {% endfor %}
    )

SELECT * FROM vibe_data
