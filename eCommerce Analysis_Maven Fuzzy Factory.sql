/*
1.	Gsearch seems to be the biggest driver of our business. Could you pull monthly 
trends for gsearch sessions and orders so that we can showcase the growth there? 
*/ 
SELECT
	YEAR(website_sessions.created_at) AS year,
    MONTH(website_sessions.created_at) AS month,
    COUNT(DISTINCT website_sessions.website_session_id) AS sessions,
    COUNT(DISTINCT orders.order_id) AS orders,
    ROUND(COUNT(DISTINCT orders.order_id)/COUNT(DISTINCT website_sessions.website_session_id) * 100,2) AS session_to_orders_cvr
FROM website_sessions
	LEFT JOIN orders
		ON website_sessions.website_session_id = orders.website_session_id
WHERE website_sessions.created_at < '2012-11-27'
	AND website_sessions.utm_source= 'gsearch'
GROUP BY 1,2;


/*
2.	Next, it would be great to see a similar monthly trend for Gsearch, but this time splitting out nonbrand 
and brand campaigns separately. I am wondering if brand is picking up at all. If so, this is a good story to tell. 
*/ 
SELECT
	YEAR(website_sessions.created_at) AS year,
    MONTH(website_sessions.created_at) AS month,
    COUNT(DISTINCT CASE WHEN utm_campaign = 'brand' THEN website_sessions.website_session_id ELSE NULL END) AS brand_sessions,
    COUNT(DISTINCT CASE WHEN utm_campaign = 'brand' THEN orders.order_id ELSE NULL END) AS brand_orders,
    ROUND(COUNT(DISTINCT CASE WHEN utm_campaign = 'brand' THEN orders.order_id ELSE NULL END)/COUNT(DISTINCT CASE WHEN utm_campaign = 'brand' THEN website_sessions.website_session_id ELSE NULL END) * 100,2) AS brand_cvr,
    COUNT(DISTINCT CASE WHEN utm_campaign = 'nonbrand' THEN website_sessions.website_session_id ELSE NULL END) AS nonbrand_sessions,
    COUNT(DISTINCT CASE WHEN utm_campaign = 'nonbrand' THEN orders.order_id ELSE NULL END) AS nonbrand_orders,
    ROUND(COUNT(DISTINCT CASE WHEN utm_campaign = 'nonbrand' THEN orders.order_id ELSE NULL END)/COUNT(DISTINCT CASE WHEN utm_campaign = 'nonbrand' THEN website_sessions.website_session_id ELSE NULL END) * 100,2) AS nonbrand_cvr
FROM website_sessions
	LEFT JOIN orders
		ON website_sessions.website_session_id = orders.website_session_id
WHERE website_sessions.created_at < '2012-11-27'
	AND website_sessions.utm_source = 'gsearch'
GROUP BY 1,2;


/*
3.	While we’re on Gsearch, could you dive into nonbrand, and pull monthly sessions and orders split by device type? 
I want to flex our analytical muscles a little and show the board we really know our traffic sources. 
*/ 
SELECT
	YEAR(website_sessions.created_at) AS year,
    MONTH(website_sessions.created_at) AS month,
    COUNT(DISTINCT CASE WHEN device_type = 'desktop' THEN website_sessions.website_session_id ELSE NULL END) AS desktop_sessions,
    COUNT(DISTINCT CASE WHEN device_type = 'desktop' THEN orders.order_id ELSE NULL END) AS desktop_orders,
    ROUND(COUNT(DISTINCT CASE WHEN device_type = 'desktop' THEN orders.order_id ELSE NULL END)/COUNT(DISTINCT CASE WHEN device_type = 'desktop' THEN website_sessions.website_session_id ELSE NULL END) * 100,2) AS device__cvr,
    COUNT(DISTINCT CASE WHEN device_type = 'mobile' THEN website_sessions.website_session_id ELSE NULL END) AS mobile_sessions,
    COUNT(DISTINCT CASE WHEN device_type = 'mobile' THEN orders.order_id ELSE NULL END) AS mobile_orders,
    ROUND(COUNT(DISTINCT CASE WHEN device_type = 'mobile' THEN orders.order_id ELSE NULL END)/COUNT(DISTINCT CASE WHEN device_type = 'mobile' THEN website_sessions.website_session_id ELSE NULL END) * 100,2) AS mobile_cvr
FROM website_sessions
	LEFT JOIN orders
		ON website_sessions.website_session_id = orders.website_session_id
WHERE website_sessions.created_at < '2012-11-27'
	AND website_sessions.utm_source = 'gsearch'
    AND website_sessions.utm_campaign = 'nonbrand'
GROUP BY 1,2;



/*
4.	I’m worried that one of our more pessimistic board members may be concerned about the large % of traffic from Gsearch. 
Can you pull monthly trends for Gsearch, alongside monthly trends for each of our other channels?
*/ 
-- first, finding the various utm sources and referers to see the traffic we're getting
SELECT DISTINCT
	utm_source,
    utm_campaign,
    http_referer
FROM website_sessions
WHERE website_sessions.created_at < '2012-11-27';

-- we have four channels: 1.gsearch  2.bsearch  3.organic  4.direct
-- If utm_source and utm_campaign IS NULL and http_referer IS NOT NULL -> organic search
-- If utm_source and utm_campaign IS NULL and http_referer IS NULL -> direct

SELECT
	YEAR(website_sessions.created_at) AS year,
    MONTH(website_sessions.created_at) AS month,
    COUNT(DISTINCT CASE WHEN utm_source = 'gsearch' THEN website_sessions.website_session_id ELSE NULL END) AS gsearch_sessions,
    COUNT(DISTINCT CASE WHEN utm_source = 'gsearch' THEN orders.order_id ELSE NULL END) AS gsearch_orders,
    ROUND(COUNT(DISTINCT CASE WHEN utm_source = 'gsearch' THEN orders.order_id ELSE NULL END)/COUNT(DISTINCT CASE WHEN utm_source = 'gsearch' THEN website_sessions.website_session_id ELSE NULL END) * 100,2) AS gsearch_cvr,
    COUNT(DISTINCT CASE WHEN utm_source = 'bsearch' THEN website_sessions.website_session_id ELSE NULL END) AS bsearch_sessions,
    COUNT(DISTINCT CASE WHEN utm_source = 'bsearch' THEN orders.order_id ELSE NULL END) AS bsearch_orders,
    ROUND(COUNT(DISTINCT CASE WHEN utm_source = 'bsearch' THEN orders.order_id ELSE NULL END)/COUNT(DISTINCT CASE WHEN utm_source = 'bsearch' THEN website_sessions.website_session_id ELSE NULL END) * 100,2) AS bsearch_cvr,	
    COUNT(DISTINCT CASE WHEN utm_source IS NULL AND http_referer IS NULL THEN website_sessions.website_session_id ELSE NULL END) AS direct_sessions,
    COUNT(DISTINCT CASE WHEN utm_source IS NULL AND http_referer IS NULL THEN orders.order_id ELSE NULL END) AS direct_orders,
    ROUND(COUNT(DISTINCT CASE WHEN utm_source IS NULL AND http_referer IS NULL THEN orders.order_id ELSE NULL END)/COUNT(DISTINCT CASE WHEN utm_source IS NULL AND http_referer IS NULL THEN website_sessions.website_session_id ELSE NULL END) * 100,2) AS direct_cvr,
	COUNT(DISTINCT CASE WHEN utm_source IS NULL AND http_referer IS NOT NULL THEN website_sessions.website_session_id ELSE NULL END) AS orgainc_sessions,
    COUNT(DISTINCT CASE WHEN utm_source IS NULL AND http_referer IS NOT NULL THEN orders.order_id ELSE NULL END) AS orgainc_orders,
    ROUND(COUNT(DISTINCT CASE WHEN utm_source IS NULL AND http_referer IS NOT NULL THEN orders.order_id ELSE NULL END)/COUNT(DISTINCT CASE WHEN utm_source IS NULL AND http_referer IS NOT NULL THEN website_sessions.website_session_id ELSE NULL END) * 100,2) AS orgainc_cvr
FROM website_sessions
	LEFT JOIN orders
		ON website_sessions.website_session_id = orders.website_session_id
WHERE website_sessions.created_at < '2012-11-27'
GROUP BY 1,2;



/*
5.	I’d like to tell the story of our website performance improvements over the course of the first 8 months. 
Could you pull session to order conversion rates, by month? 

*/ 
SELECT
	YEAR(website_sessions.created_at) AS year,
    MONTH(website_sessions.created_at) AS month,
    COUNT(DISTINCT website_sessions.website_session_id) AS sessions,
    COUNT(DISTINCT orders.order_id) AS orders,
    ROUND(COUNT(DISTINCT orders.order_id)/COUNT(DISTINCT website_sessions.website_session_id) * 100,2) AS session_to_orders_cvr
FROM website_sessions
	LEFT JOIN orders
		ON website_sessions.website_session_id = orders.website_session_id
WHERE website_sessions.created_at < '2012-11-27'
GROUP BY 1,2;



/*
6.	For the gsearch lander test, please estimate the revenue that test earned us 
(Hint: Look at the increase in CVR from the test (Jun 19 – Jul 28), and use 
nonbrand sessions and revenue since then to calculate incremental value)
*/ 
-- STEP 0: Find out when the new page /lander launched
-- STEP 1: Find the first first_seen_landing_page_id for relevant sessions
-- STEP 2: Identify the landing page of these relevant sessions
-- STEP 3: Make a table to bring in the orders
-- STEP 4: Find the difference between conversion rates
-- STEP 5: Find out the last time when the traffic was sent to /home
-- STEP 6: Count the total sessions after the last time /home page to estimate the revenue
-- STEP 7: Calculate incremental value fro the difference between conversion rate and total sessions

-- STEP 0: find out when the new page /lander launched
SELECT
	MIN(created_at) AS first_created_at,
    MIN(website_pageview_id) AS first_test_pageview
FROM website_pageviews
WHERE pageview_url = '/lander-1';
#The first_test_pageview ID is 23504 and created at: 2012-06-19 00:35:54

-- STEP 1: find the first first_seen_landing_page_id for relevant sessions
CREATE TEMPORARY TABLE first_test_pageviews
SELECT
	website_sessions.website_session_id,
    MIN(website_pageviews.website_pageview_id) AS first_seen_landing_page_id
FROM website_sessions
	INNER JOIN website_pageviews
		ON website_sessions.website_session_id = website_pageviews.website_session_id
WHERE website_sessions.created_at < '2012-07-28' -- prescribed by the assignment
	AND website_pageviews.website_pageview_id >= 23504 -- first page_view
    AND utm_source = 'gsearch'
    AND utm_campaign = 'nonbrand'
GROUP BY 1;

-- STEP 2: identify the landing page of these relevant session, but restricting to home or lander-1 to analyze landing page A/B test
CREATE TEMPORARY TABLE nonbrand_test_sessions_with_landing_pages
SELECT
	first_test_pageviews.website_session_id,
    first_test_pageviews.first_seen_landing_page_id,
    website_pageviews.pageview_url AS landing_pages
FROM first_test_pageviews
	LEFT JOIN website_pageviews
		ON first_test_pageviews.website_session_id = website_pageviews.website_session_id
WHERE website_pageviews.pageview_url IN ('/home','/lander-1');

-- STEP 3: Make a table to bring in the orders
CREATE TEMPORARY TABLE nonbrand_test_sessions_with_orders
SELECT
	nonbrand_test_sessions_with_landing_pages.website_session_id,
    nonbrand_test_sessions_with_landing_pages.landing_pages,
    orders.order_id AS order_id
FROM nonbrand_test_sessions_with_landing_pages
	LEFT JOIN orders
		ON nonbrand_test_sessions_with_landing_pages.website_session_id = orders.website_session_id;

-- STEP 4: Find the difference between conversion rates
SELECT
	landing_pages,
    COUNT(DISTINCT website_session_id) AS sessions,
    COUNT(DISTINCT order_id) AS orders,
    ROUND(COUNT(DISTINCT order_id)/COUNT(DISTINCT website_session_id) * 100,2) AS conv_rate
FROM nonbrand_test_sessions_with_orders
GROUP BY 1;
# conversion rate is 3.18% for /home , while conversion rate is 4.06% for /lander-1

-- STEP 5: Find out the last tiem whenthe traffic was sent to /home
SELECT
    MAX(website_sessions.website_session_id) AS most_recent_gsearch_nonbrand_home_pageview
FROM website_sessions
	LEFT JOIN website_pageviews
		ON website_sessions.website_session_id = website_pageviews.website_session_id
WHERE 
    website_sessions.created_at < '2012-11-27'
    AND utm_source = 'gsearch'
    AND utm_campaign = 'nonbrand'
    AND website_pageviews.pageview_url = '/home';
 # max website_session_id = 17145

-- STEP 6: Count the total sessions after the last time /home page to estimate the revenue
SELECT
	COUNT(DISTINCT website_session_id) AS sessions_since_test
FROM website_sessions
WHERE     
	website_sessions.created_at < '2012-11-27'
    AND utm_source = 'gsearch'
    AND utm_campaign = 'nonbrand'
    AND website_session_id > 17145 -- last /home session
    ;
    
-- STEP 7: Calculate Average Revenue
# 22,972 total website sessions for /lander-1
# Conversion rate difference: 0.88%
# 22,972 * 0.88% incremental conversion = 202 -> incremental orders since July 29th (roughly 4 months)
# 202/4 = roughly 50 extra orders per month, not bad!



/*
7.	For the landing page test you analyzed previously, it would be great to show a full conversion funnel 
from each of the two pages to orders. You can use the same time period you analyzed last time (Jun 19 – Jul 28).
*/ 
-- STEP 0: Have an overview of the conversion funnel path
-- STEP 1: Identify each relevant pageview for relevant sessions as the specific funnel step
-- STEP 2: Create the session-level conversion funnel view
-- STEP 3: Aggregate the data to assess funnel performance

-- STEP 0: Have an overview of the conversion funnel path
SELECT DISTINCT
	pageview_url
FROM website_pageviews
	INNER JOIN website_sessions
		ON website_sessions.website_session_id = website_pageviews.website_session_id
WHERE website_pageviews.created_at > '2012-06-19'
	AND website_pageviews.created_at < '2012-07-28'
    AND utm_source = 'gsearch'
    AND utm_campaign = 'nonbrand';
#conversion funnel path: 
# /home ; /lander-1 
# -> /products 
# -> /the-original-mr-fuzzy 
# -> /cart 
# -> /shipping 
# -> /billing 
# -> /thank-you-for-your-order


-- STEP 1: Identify each relevant pageview for relevant sessions as the specific funnel step
SELECT 
	website_sessions.website_session_id,
    website_pageviews.pageview_url,
    CASE WHEN pageview_url = '/home' THEN 1 ELSE 0 END AS home_page,
    CASE WHEN pageview_url = '/lander-1' THEN 1 ELSE 0 END AS lander_1_page,
    CASE WHEN pageview_url = '/products' THEN 1 ELSE 0 END AS products_page,
    CASE WHEN pageview_url = '/the-original-mr-fuzzy' THEN 1 ELSE 0 END AS mrfuzzy_page,
    CASE WHEN pageview_url = '/cart' THEN 1 ELSE 0 END AS cart_page,
    CASE WHEN pageview_url = '/shipping' THEN 1 ELSE 0 END AS shipping_page,
    CASE WHEN pageview_url = '/billing' THEN 1 ELSE 0 END AS billing_page,
    CASE WHEN pageview_url = '/thank-you-for-your-order' THEN 1 ELSE 0 END AS thankyou_page
FROM website_sessions
	LEFT JOIN website_pageviews
		ON website_sessions.website_session_id = website_pageviews.website_session_id
WHERE website_pageviews.created_at > '2012-06-19'
	AND website_pageviews.created_at < '2012-07-28'
    AND utm_source = 'gsearch'
    AND utm_campaign = 'nonbrand'
ORDER BY 1;
    

 -- STEP 2: Create the session-level conversion funnel view   
CREATE TEMPORARY TABLE sessions_level_made_it_flagged
SELECT
	website_session_id,
    MAX(home_page) AS saw_homepage,
    MAX(lander_1_page) AS saw_lander_1_page,
    MAX(products_page) AS products_page_made_it,
    MAX(mrfuzzy_page) AS mrfuzzy_page_made_it,
    MAX(cart_page) AS cart_page__made_it,
    MAX(shipping_page) AS shipping_page_made_it,
    MAX(billing_page) AS billing_made_it,
    MAX(thankyou_page) AS thankyou_made_it
FROM (
SELECT 
	website_sessions.website_session_id,
    website_pageviews.pageview_url,
    CASE WHEN pageview_url = '/home' THEN 1 ELSE 0 END AS home_page,
    CASE WHEN pageview_url = '/lander-1' THEN 1 ELSE 0 END AS lander_1_page,
    CASE WHEN pageview_url = '/products' THEN 1 ELSE 0 END AS products_page,
    CASE WHEN pageview_url = '/the-original-mr-fuzzy' THEN 1 ELSE 0 END AS mrfuzzy_page,
    CASE WHEN pageview_url = '/cart' THEN 1 ELSE 0 END AS cart_page,
    CASE WHEN pageview_url = '/shipping' THEN 1 ELSE 0 END AS shipping_page,
    CASE WHEN pageview_url = '/billing' THEN 1 ELSE 0 END AS billing_page,
    CASE WHEN pageview_url = '/thank-you-for-your-order' THEN 1 ELSE 0 END AS thankyou_page
FROM website_sessions
	LEFT JOIN website_pageviews
		ON website_sessions.website_session_id = website_pageviews.website_session_id
WHERE website_pageviews.created_at > '2012-06-19'
	AND website_pageviews.created_at < '2012-07-28'
    AND utm_source = 'gsearch'
    AND utm_campaign = 'nonbrand'
) AS pageview_level
GROUP BY 1;

-- STEP 3: Aggregate the data to assess funnel performance
-- then this would produce the final output, part 1 - Session Funnel
SELECT
	CASE 
    WHEN saw_homepage = 1 THEN 'saw_homepage'
    WHEN saw_lander_1_page = 1 THEN 'saw_lander_1_page'
    ELSE 'others'
END AS segments,
    COUNT(DISTINCT website_session_id) AS sessions,
    COUNT(DISTINCT CASE WHEN products_page_made_it = 1 THEN website_session_id ELSE 0 END) AS to_products,
    COUNT(DISTINCT CASE WHEN mrfuzzy_page_made_it = 1 THEN website_session_id ELSE 0 END) AS to_mrfuzzy,
    COUNT(DISTINCT CASE WHEN cart_page__made_it = 1 THEN website_session_id ELSE 0 END) AS to_cart,
    COUNT(DISTINCT CASE WHEN shipping_page_made_it = 1 THEN website_session_id ELSE 0 END) AS to_shipping,
    COUNT(DISTINCT CASE WHEN billing_made_it = 1 THEN website_session_id ELSE 0 END) AS to_billing,
    COUNT(DISTINCT CASE WHEN thankyou_made_it = 1 THEN website_session_id ELSE 0 END) AS to_thankyou
 FROM sessions_level_made_it_flagged
GROUP BY 1;

-- then this as final output part 2 - Click Through Rate Funnels
SELECT
	CASE 
		WHEN saw_homepage = 1 THEN 'saw_homepage'
        WHEN saw_lander_1_page = 1 THEN 'saw_lander_1_page'
        ELSE 'others' 
	END AS segment, 
	ROUND(COUNT(DISTINCT CASE WHEN products_page_made_it = 1 THEN website_session_id ELSE NULL END)/COUNT(DISTINCT website_session_id) * 100,2) AS lander_ctr,
    ROUND(COUNT(DISTINCT CASE WHEN mrfuzzy_page_made_it = 1 THEN website_session_id ELSE NULL END)/COUNT(DISTINCT website_session_id) * 100,2) AS products_click_ctr,
    ROUND(COUNT(DISTINCT CASE WHEN cart_page__made_it = 1 THEN website_session_id ELSE NULL END)/COUNT(DISTINCT website_session_id) * 100,2) AS mrfuzzy_click_ctr,
    ROUND(COUNT(DISTINCT CASE WHEN shipping_page_made_it = 1 THEN website_session_id ELSE NULL END)/COUNT(DISTINCT website_session_id) * 100,2) AS cart_click_ctr,
    ROUND(COUNT(DISTINCT CASE WHEN billing_made_it = 1 THEN website_session_id ELSE NULL END)/COUNT(DISTINCT website_session_id) * 100,2) AS shipping_click_ctr,
    ROUND(COUNT(DISTINCT CASE WHEN thankyou_made_it = 1 THEN website_session_id ELSE NULL END)/COUNT(DISTINCT website_session_id) * 100,2) AS billing_click_ctr
FROM sessions_level_made_it_flagged
GROUP BY 1
;


/*
8.	I’d love for you to quantify the impact of our billing test, as well. Please analyze the lift generated 
from the test (Sep 10 – Nov 10), in terms of revenue per billing page session, and then pull the number 
of billing page sessions for the past month to understand monthly impact.
*/ 
-- STEP 0: Check the billing page version
-- STEP 1: Connect needed metrics altogether
-- STEP 2: Aggregate the data to assess billing-order performance
-- STEP 3: The Past month's billing page session

-- STEP 0: Check the billing page version
SELECT distinct
	pageview_url
FROM website_pageviews
WHERE pageview_url LIKE '%billing%'
	AND created_at > '2012-09-10' 
	AND created_at < '2012-11-10';

-- STEP 1: Connect needed metrics altogether
SELECT
	website_pageviews.website_session_id,
    website_pageviews.pageview_url AS billing_version_seen,
    orders.order_id,
    orders.price_usd
FROM website_pageviews
	LEFT JOIN orders   -- LEFT JOIN: session could have 0 orders.
		ON website_pageviews.website_session_id = orders.website_session_id
WHERE website_pageviews.created_at > '2012-09-10' 
	AND website_pageviews.created_at < '2012-11-10'
    AND website_pageviews.pageview_url IN ('/billing','/billing-2')
;

-- STEP 2: Aggregate the data to assess billing-level revenue performance
SELECT
	billing_version_seen,
    COUNT(DISTINCT website_session_id) AS sessions,
    ROUND(SUM(price_usd)/COUNT(DISTINCT website_session_id),2) AS revenue_per_billing_page_seen
FROM (
SELECT
	website_pageviews.website_session_id,
    website_pageviews.pageview_url AS billing_version_seen,
    orders.order_id,
    orders.price_usd
FROM website_pageviews
	LEFT JOIN orders   -- LEFT JOIN: session could have 0 orders.
		ON website_pageviews.website_session_id = orders.website_session_id
WHERE website_pageviews.created_at > '2012-09-10'
	AND website_pageviews.created_at < '2012-11-10'
    AND website_pageviews.pageview_url IN ('/billing','/billing-2')
) AS billing_pageviews_and_order_data
GROUP BY 1;
# $22.83 revenue per billing page seen for /billing
# $31.34 for /billing-2
# LIFT: $8.51 per billing page view
# so everytime a customer sees the billing page, you're now making $8.51 more than you were previously

-- STEP 3: The past month billing page session
SELECT
	COUNT(DISTINCT website_session_id) AS billing_sessions_past_month
FROM website_pageviews
WHERE website_pageviews.created_at BETWEEN '2012-10-27' AND '2012-11-27' -- past month
	AND pageview_url IN ('/billing', '/billing-2');
# 1,193 billing sessions past month
-- LIFT: $8.51 per billing session
-- VALUE OF BILLING TEST: 1,193 * $8.51 = $10,160 over the past month


/*
9. Let’s dive deeper into the impact of introducing new products. Please pull monthly sessions to 
the /products page, and show how the % of those sessions clicking through another page has changed 
over time, along with a view of how conversion from /products to placing an order has improved.
*/
-- first, identifying all the views of the /products page
CREATE TEMPORARY TABLE product_pageviews
SELECT
	website_session_id,
    website_pageview_id,
    created_at AS saw_product_page_at
FROM website_pageviews
WHERE pageview_url = '/products';


SELECT
	YEAR(saw_product_page_at) AS year,
    Month(saw_product_page_at) AS month,
    COUNT(DISTINCT product_pageviews.website_session_id) AS sessions_to_product_page,
    COUNT(DISTINCT website_pageviews.website_session_id) AS clicked_to_next_page,
    Round(COUNT(DISTINCT website_pageviews.website_session_id)/COUNT(DISTINCT product_pageviews.website_session_id)*100,2) AS clickthrough_rate,
    COUNT(DISTINCT orders.order_id) AS orders,
    ROUND(COUNT(DISTINCT orders.order_id)/COUNT(DISTINCT product_pageviews.website_session_id) *100,2) AS products_to_order_cvr
FROM product_pageviews
	LEFT JOIN website_pageviews
		ON product_pageviews.website_session_id = website_pageviews.website_session_id -- same session
        AND website_pageviews.website_pageview_id > product_pageviews.website_pageview_id -- they had another page AFTER
	LEFT JOIN orders
		on orders.website_session_id = product_pageviews.website_session_id
GROUP BY 1,2;
/*
10. We made our 4th product available as a primary product on December 05, 2014 (it was previously only a cross-sell item). 
Could you please pull sales data since then, and show how well each product cross-sells from one another?
*/
-- STEP 1: list out the primary products from the defined time period
CREATE TEMPORARY TABLE primary_products
SELECT
	order_id,
    primary_product_id,
    created_at AS order_at
FROM orders
WHERE created_at > '2014-12-05';

-- STEP 2: Get the cross-sells products
SELECT 
	primary_products.*,
    order_items.product_id AS cross_sell_product_id
FROM primary_products
	LEFT JOIN order_items
		ON order_items.order_id = primary_products.order_id
        AND order_items.is_primary_item = 0  -- only bringing in cross-sells
;

SELECT 
	primary_product_id, 
    COUNT(DISTINCT order_id) AS total_orders, 
    COUNT(DISTINCT CASE WHEN cross_sell_product_id = 1 THEN order_id ELSE NULL END) AS _xsold_p1,
    COUNT(DISTINCT CASE WHEN cross_sell_product_id = 2 THEN order_id ELSE NULL END) AS _xsold_p2,
    COUNT(DISTINCT CASE WHEN cross_sell_product_id = 3 THEN order_id ELSE NULL END) AS _xsold_p3,
    COUNT(DISTINCT CASE WHEN cross_sell_product_id = 4 THEN order_id ELSE NULL END) AS _xsold_p4,
    ROUNd(COUNT(DISTINCT CASE WHEN cross_sell_product_id = 1 THEN order_id ELSE NULL END)/COUNT(DISTINCT order_id) * 100,2) AS p1_xsell_cvr,
    ROUNd(COUNT(DISTINCT CASE WHEN cross_sell_product_id = 2 THEN order_id ELSE NULL END)/COUNT(DISTINCT order_id) * 100,2) AS p2_xsell_cvr,
    ROUNd(COUNT(DISTINCT CASE WHEN cross_sell_product_id = 3 THEN order_id ELSE NULL END)/COUNT(DISTINCT order_id) * 100,2)AS p3_xsell_cvr,
    ROUNd(COUNT(DISTINCT CASE WHEN cross_sell_product_id = 4 THEN order_id ELSE NULL END)/COUNT(DISTINCT order_id) * 100,2) AS p4_xsell_cvr
FROM
(
SELECT
	primary_products.*, 
    order_items.product_id AS cross_sell_product_id
FROM primary_products
	LEFT JOIN order_items 
		ON order_items.order_id = primary_products.order_id
        AND order_items.is_primary_item = 0 -- only bringing in cross-sells
) AS primary_w_cross_sell
GROUP BY 1;