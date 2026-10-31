-- ============================================================
-- PROJECT: E-COMMERCE SALES FUNNEL & REVENUE ANALYSIS
-- DATABASE: Google BigQuery
-- TABLE: user_events
-- ANALYSIS PERIOD: Last 30 days from 2026-02-03
-- ============================================================


-- ============================================================
-- 1. DATA EXPLORATION
-- ============================================================

-- View all records
-- SELECT *
-- FROM `gen-lang-client-0530878963.1_.user_events`;

-- Identify all unique event types
-- SELECT DISTINCT event_type
-- FROM `1_.user_events`;

-- Check available event dates (latest to oldest)
-- SELECT DISTINCT event_date
-- FROM `gen-lang-client-0530878963.1_.user_events`
-- ORDER BY event_date DESC;


-- ============================================================
-- 2. SALES FUNNEL ANALYSIS
-- ============================================================
-- Objective:
-- Count unique users at each stage of the purchasing journey
-- and calculate conversion rates between consecutive stages.
--
-- Note:
-- The final column (overall_conversion_rate) measures the
-- payment -> purchase step, not view -> purchase.
-- ============================================================

WITH funnel_stage AS (
    SELECT
        COUNT(DISTINCT CASE
            WHEN event_type = 'page_view' THEN user_id
        END) AS stage_1_view,

        COUNT(DISTINCT CASE
            WHEN event_type = 'add_to_cart' THEN user_id
        END) AS stage_2_cart,

        COUNT(DISTINCT CASE
            WHEN event_type = 'checkout_start' THEN user_id
        END) AS stage_3_checkout,

        COUNT(DISTINCT CASE
            WHEN event_type = 'payment_info' THEN user_id
        END) AS stage_4_payment,

        COUNT(DISTINCT CASE
            WHEN event_type = 'purchase' THEN user_id
        END) AS stage_5_purchase

    FROM `gen-lang-client-0530878963.1_.user_events`

    WHERE event_date >= TIMESTAMP(
        DATE_SUB('2026-02-03', INTERVAL 30 DAY)
    )
)

-- Calculate conversion rates between funnel stages
SELECT
    stage_1_view,
    stage_2_cart,
    ROUND(100 * stage_2_cart / stage_1_view) AS view_to_cart_rate,

    stage_3_checkout,
    ROUND(100 * stage_3_checkout / stage_2_cart) AS cart_to_checkout_rate,

    stage_4_payment,
    ROUND(100 * stage_4_payment / stage_3_checkout) AS checkout_to_payment_rate,

    stage_5_purchase,
    ROUND(100 * stage_5_purchase / stage_4_payment) AS overall_conversion_rate

FROM funnel_stage;


-- ============================================================
-- 3. CONVERSION CHANNEL ANALYSIS
-- ============================================================
-- Objective:
-- Analyse funnel performance across different traffic sources
-- and compare their conversion rates.
-- ============================================================

-- View the source data
-- SELECT *
-- FROM `1_.user_events`;

WITH source_funnel AS (
    SELECT
        traffic_source,

        COUNT(DISTINCT CASE
            WHEN event_type = 'page_view' THEN user_id
        END) AS _view,

        COUNT(DISTINCT CASE
            WHEN event_type = 'add_to_cart' THEN user_id
        END) AS _cart,

        COUNT(DISTINCT CASE
            WHEN event_type = 'purchase' THEN user_id
        END) AS _purchase

    FROM `gen-lang-client-0530878963.1_.user_events`

    WHERE event_date >= TIMESTAMP(
        DATE_SUB('2026-02-03', INTERVAL 30 DAY)
    )

    GROUP BY traffic_source
)

-- Calculate conversion rates for each traffic source
SELECT
    traffic_source,
    _view,
    _cart,
    _purchase,

    ROUND(_cart * 100 / _view) AS cart_conversion_rate,

    ROUND(_purchase * 100 / _cart) AS purchase_conversion_rate,

    ROUND(_purchase * 100 / _view) AS overall_conversion_rate

FROM source_funnel

ORDER BY _purchase;


-- ============================================================
-- 4. TIME-TO-CONVERSION ANALYSIS
-- ============================================================
-- Objective:
-- Calculate the average time users take to progress through
-- different stages of the purchasing journey.
-- ============================================================

WITH user_journey AS (
    SELECT
        user_id,

        MIN(CASE
            WHEN event_type = 'page_view' THEN event_date
        END) AS view_time,

        MIN(CASE
            WHEN event_type = 'add_to_cart' THEN event_date
        END) AS cart_time,

        MIN(CASE
            WHEN event_type = 'purchase' THEN event_date
        END) AS purchase_time

    FROM `1_.user_events`

    WHERE event_date >= TIMESTAMP(
        DATE_SUB('2026-02-03', INTERVAL 30 DAY)
    )

    GROUP BY user_id

    -- Include only users who completed a purchase
    HAVING MIN(CASE
        WHEN event_type = 'purchase' THEN event_date
    END) IS NOT NULL
)

-- Calculate average time between journey stages
SELECT
    COUNT(*),

    ROUND(
        AVG(TIMESTAMP_DIFF(cart_time, view_time, MINUTE)),
        2
    ) AS avg_view_to_cart_time,

    ROUND(
        AVG(TIMESTAMP_DIFF(purchase_time, cart_time, MINUTE)),
        2
    ) AS avg_cart_to_purchase_time,

    ROUND(
        AVG(TIMESTAMP_DIFF(purchase_time, view_time, MINUTE)),
        2
    ) AS avg_total_journey_time

FROM user_journey;


-- ============================================================
-- 5. REVENUE FUNNEL ANALYSIS
-- ============================================================
-- Objective:
-- Calculate key revenue and business performance metrics,
-- including visitors, buyers, orders and revenue KPIs.
-- ============================================================

WITH funnel_revenue AS (
    SELECT
        COUNT(DISTINCT CASE
            WHEN event_type = 'page_view' THEN user_id
        END) AS total_visitors,

        COUNT(DISTINCT CASE
            WHEN event_type = 'purchase' THEN user_id
        END) AS total_buyers,

        ROUND(
            SUM(CASE
                WHEN event_type = 'purchase' THEN amount
            END),
            2
        ) AS total_revenue,

        COUNT(CASE
            WHEN event_type = 'purchase' THEN 1
        END) AS total_orders

    FROM `gen-lang-client-0530878963.1_.user_events`

    WHERE event_date >= TIMESTAMP(
        DATE_SUB('2026-02-03', INTERVAL 30 DAY)
    )
)

-- Calculate key business KPIs
SELECT
    total_visitors,
    total_buyers,
    total_revenue,
    total_orders,

    ROUND(total_revenue / total_orders, 2) AS avg_order_value,

    ROUND(total_revenue / total_buyers, 2) AS avg_revenue_per_buyer,

    ROUND(total_revenue / total_visitors, 2) AS avg_revenue_per_visitor

FROM funnel_revenue;
