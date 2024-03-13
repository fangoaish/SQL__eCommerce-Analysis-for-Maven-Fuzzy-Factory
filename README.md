# eCommerce Analysis for Maven Fuzzy Factory

## Project Overview
This project focuses on the analysis and optimization of marketing channels, measurement and testing of website conversion performance, and utilization of data to comprehend the impact of new product launches are key responsibilities.

![ecommerce image](https://github.com/fangoaish/SQL__eCommerce-Analysis-for-Maven-Fuzzy-Factory/assets/51399519/491ac749-4f53-4941-ab04-ad8b0e696fdb)


## Business Goals
We'll use MySQL to understand how **_customers access and interact with the website_**, analyze **_landing page performance and conversion_**, and explore **_product-level sales_**.


## Data Sources
We will be working with six related tables, which contain eCommerce data about:
- Website Activity
- Products
- Orders and Refunds

![eCommerce Database Analyst for Maven Fuzzy Factory](https://github.com/fangoaish/SQL__eCommerce-Analysis-for-Maven-Fuzzy-Factory/assets/51399519/c6691412-e608-433f-835b-00807a7654f6)


## Data Preparation
No data preparation tasks were required as all the data provided had already been cleaned out prior.


## Business Objectives
These questions will be addressed accordingly in Exploratory Data Analysis
1. Showcase the growth of Gsearch as the primary driver of business by pulling monthly trends for search sessions and orders.
   
2. Evaluate the performance of nonbrand and brand campaigns separately to determine if brand campaigns are gaining traction.
   
3. Demonstrate a comprehensive understanding of traffic sources by analyzing nonbrand Gsearch sessions and orders split by device type.
   
4. Compare monthly trends of Gsearch traffic with other channels to understand their respective impacts on overall traffic.
   
5. Monitor and improve website performance by tracking session-to-order conversion rates monthly over the first 8 months.
    
6. Estimate the revenue generated from the search lander test by analyzing the increase in conversion rates and subsequent revenue.
    
7. Analyze the full conversion funnel from two landing page variants to orders to assess their respective impacts on conversions.
    
8. Quantify the impact of the billing test by analyzing revenue per billing page session and monthly billing page sessions.
    
9. Evaluate the impact of introducing new products by tracking monthly sessions to the /products page and changes in click-through rates, along with improvements in conversion rates from /products to placing orders.
    
10. Assess the cross-selling effectiveness of products since the 4th product was introduced as a primary product, by analyzing sales data to understand how well each product cross-sells from one another.

## Exploratory Data Analysis

### _1) Showcase the growth of Gsearch as the primary driver of business by pulling monthly trends for search sessions and orders._
   - Why do I want to know?
      - to understand where the customers are coming from and which channels are driving the highest quality traffic
   - So what?
      1. Analyzing search data and shifting budget towards the engines, campaigns, or keywords driving the strongest conversion rates
      2. Comparing user behavior patterns across traffic sources to inform creative and messaging strategy
      3. Identifying opportunities to eliminate wasted spend or scale high-converting traffic
   - Measured by?
      - website_session // order_id
         1. We use the utm parameters stored in the database to identify paid website sessions
         2. From our session data, we can link to our order data to understand how much revenue our paid campaigns are driving
       

<img width="524" alt="SQL P1Q1" src="https://github.com/fangoaish/SQL__eCommerce-Analysis-for-Maven-Fuzzy-Factory/assets/51399519/c8329a5b-81a0-44df-a504-35db08064f61">

![Conversion Rates of Sessions to Orders - Gsearch](https://github.com/fangoaish/SQL__eCommerce-Analysis-for-Maven-Fuzzy-Factory/assets/51399519/db04d55d-6428-45dc-a378-db5751d7aaab)


Overall, the data indicates a positive trend of increasing website traffic and orders over time, with a consistent conversion rate, suggesting that the website is effectively converting sessions into orders regardless of fluctuations in traffic volume. 

### _2) Evaluate the performance of nonbrand and brand campaigns separately to determine if brand campaigns are gaining traction._

<img width="797" alt="eCommerce Q2" src="https://github.com/fangoaish/SQL__eCommerce-Analysis-for-Maven-Fuzzy-Factory/assets/51399519/34f65380-0a94-47b2-ad55-df5b8f03f861">

![Conversion Rates Between Brand and Nonbrand Campaigns](https://github.com/fangoaish/SQL__eCommerce-Analysis-for-Maven-Fuzzy-Factory/assets/51399519/5610e6f0-6739-4507-a2bf-73b88ff055f9)



- #### **Brand Campaigns**:
There has been a noticeable increase in brand sessions and orders over the months, indicating a growing interest in brand-specific marketing efforts.
The brand campaign conversion rate fluctuates, peaking at 9.23% in April but stabilizing around 4-6% in subsequent months. This suggests that while there may be variations, the overall effectiveness of brand campaigns in converting sessions to orders remains relatively consistent.


- #### **Nonbrand Campaigns**:
Nonbrand sessions and orders also show an upward trend over the months, indicating increasing traffic and interest from users who are not specifically searching for the brand.
The nonbrand campaign conversion rate remains relatively stable around 3-4%, suggesting a consistent level of effectiveness in converting nonbrand sessions into orders.     



### _3) Demonstrate a comprehensive understanding of traffic sources by analyzing nonbrand Gsearch sessions and orders split by device type._
   - Why do I want to know?
      - Understanding nonbrand Gsearch sessions by device type is essential for optimizing user experience and targeting marketing efforts effectively.
   - So what?
      - Analyzing this data enables strategic decision-making, leading to improved user engagement and conversion rates through device-specific optimization and targeted marketing strategies.
   - Measured by?
        - website_session // device_type // order_id

<img width="754" alt="eCommerce Q3" src="https://github.com/fangoaish/SQL__eCommerce-Analysis-for-Maven-Fuzzy-Factory/assets/51399519/4ca43b81-2686-4061-a46b-b80125b1163c">

![Sessions by Device Types](https://github.com/fangoaish/SQL__eCommerce-Analysis-for-Maven-Fuzzy-Factory/assets/51399519/ff4882ea-9719-423c-9f1c-ac03760a6c77)

![Orders by Device Types](https://github.com/fangoaish/SQL__eCommerce-Analysis-for-Maven-Fuzzy-Factory/assets/51399519/9628b4bc-3051-42c7-9234-cff0a7d33bcd)

![Conversion Rates Between Desktop and Mobile](https://github.com/fangoaish/SQL__eCommerce-Analysis-for-Maven-Fuzzy-Factory/assets/51399519/0bca869d-e4f7-4aa8-ba6c-246207f393b7)


- **Desktop vs. Mobile Sessions**: There is a clear trend of increasing sessions on both desktop and mobile devices over the months, with desktop sessions consistently higher than mobile sessions.

- **Desktop vs. Mobile Orders**: Similarly, desktop orders outpace mobile orders, indicating that desktop users are more likely to make purchases compared to mobile users.

- **Conversion Rates**: While desktop conversion rates remain relatively stable at around 4-5%, mobile conversion rates fluctuate, with some months showing significantly lower rates.

- **Conclusion**: Desktop devices dominate both sessions and orders, suggesting that desktop users are the primary drivers of traffic and conversions. However, it's essential to address the lower conversion rates on mobile devices to capitalize fully on this traffic source. Strategies aimed at optimizing the mobile user experience and improving mobile conversion rates should be prioritized to ensure a comprehensive understanding and effective utilization of traffic sources across different devices


### _4) Compare monthly trends of Gsearch traffic with other channels to understand their respective impacts on overall traffic._
First, we'll check the different UTM sources and referrers to identify the incoming traffic.

<img width="339" alt="eCommerce Q4 -1" src="https://github.com/fangoaish/SQL__eCommerce-Analysis-for-Maven-Fuzzy-Factory/assets/51399519/883cc548-6d36-485c-a00a-a0f8964d936d">


we have four channels:
   1. gsearch
   2. bsearch
   3. organic
   4. direct


- If utm_source and utm_campaign IS NULL and http_referer IS NOT NULL -> _organic search_
- If utm_source and utm_campaign IS NULL and http_referer IS NULL -> _direct_

<img width="1266" alt="eCommerce Q4 -2" src="https://github.com/fangoaish/SQL__eCommerce-Analysis-for-Maven-Fuzzy-Factory/assets/51399519/8967abae-3590-4e50-9092-d20c6af90cf9">

![Average Conversion Rates By Channels](https://github.com/fangoaish/SQL__eCommerce-Analysis-for-Maven-Fuzzy-Factory/assets/51399519/198cd5b7-8143-42c3-b6a1-eb29e7f5deb1)

- **Gsearch Performance**: Gsearch consistently maintains a significant share of overall traffic throughout the months, with steady growth in sessions and orders. The conversion rate for Gsearch remains relatively stable, averaging 3.73%.

- **Other Channels**: While channels like branded search (Bsearch), direct, and organic traffic contribute to overall traffic. Among these, Bsearch stands out with the highest conversion rate at 4.82%, followed by direct at 4.98%, and organic traffic at 4.38%.

- **Conclusion**: Gsearch emerges as a consistent and impactful driver of overall traffic, with a relatively stable conversion rate. However, it's essential to note the varying performance of other channels, particularly Bsearch, which exhibits a higher conversion rate. Understanding these trends allows for strategic decisions in resource allocation and optimization efforts across different channels to maximize overall traffic and conversions.


### _5) Monitor and improve website performance by tracking session-to-order conversion rates monthly over the first 8 months._

<img width="510" alt="eCommerce Q5" src="https://github.com/fangoaish/SQL__eCommerce-Analysis-for-Maven-Fuzzy-Factory/assets/51399519/5d473d87-c48e-44e6-bf7d-a98ab0f5ee59">

![Conversion Rates of Sessions to Orders](https://github.com/fangoaish/SQL__eCommerce-Analysis-for-Maven-Fuzzy-Factory/assets/51399519/a434b3f2-3f07-4336-9689-da989d99914e)









## Challenges

## Limitations
- The reliability of the findings and the efficacy of the proposed recommendations depend on the quality of the datasets provided.
- Please be aware that our merged DataFrame contains aggregated sales data for each specific product.
- Additionally, the recency of all the data remains unknown due to the absence of a datetime parameter in the datasets.

## References
- [DataCamp](https://www.datacamp.com/)
- [Statista](https://www.statista.com/statistics/254489/total-revenue-of-the-global-sports-apparel-market/)
