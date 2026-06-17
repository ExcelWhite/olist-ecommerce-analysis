-- ACT 1: BUSINESS OVERVIEW


-- Q1: How many orders were placed per month?

SELECT 
  FORMAT_DATE('%Y-%m', DATE(order_purchase_timestamp)) AS month,
  COUNT(order_id) AS n_orders 
FROM `brazilian_ecommerce.orders`
GROUP BY month
ORDER BY month;


-- Q2: Month-over-month revenue change

WITH monthly_revenue AS (
  SELECT 
    FORMAT_DATE('%Y-%m', DATE(o.order_purchase_timestamp)) AS month,
    ROUND(SUM(oi.price + oi.freight_value), 2) AS revenue
  FROM `brazilian_ecommerce.order_items` oi
  JOIN `brazilian_ecommerce.orders` o ON o.order_id = oi.order_id
  GROUP BY month
)

SELECT 
  month,
  revenue,
  ROUND(
    (revenue - LAG(revenue) OVER (ORDER BY month)) 
    / LAG(revenue) OVER (ORDER BY month) * 100,
    2
  ) AS perc_growth
FROM monthly_revenue
WHERE month BETWEEN '2017-01' AND '2018-09'
ORDER BY month;


-- Q3: Total revenue per seller

SELECT oi.seller_id, ROUND(SUM(oi.price+oi.freight_value), 2) AS revenue
FROM `brazilian_ecommerce.order_items` oi
JOIN `brazilian_ecommerce.orders` o
ON o.order_id = oi.order_id
WHERE o.order_status = 'delivered'
GROUP BY seller_id
ORDER BY revenue DESC;


