-- ACT 4: SELLER PERFORMANCE


-- Q1: Which sellers have fulfilled more than 100 orders?

SELECT oi.seller_id, COUNT(DISTINCT oi.order_id) AS n_orders
FROM `brazilian_ecommerce.order_items` oi
JOIN `brazilian_ecommerce.orders` o
ON o.order_id = oi.order_id
WHERE o.order_status = 'delivered'
GROUP BY oi.seller_id
HAVING n_orders > 100
ORDER BY 2 DESC;


-- Q2: Which sellers have an on-time delivery rate below 80%?

SELECT oi.seller_id,
  COUNT(*) AS total_orders,
  COUNTIF(o.order_delivered_customer_date <= o.order_estimated_delivery_date) AS on_time_orders,
  ROUND(
    COUNTIF(o.order_delivered_customer_date <= o.order_estimated_delivery_date) / COUNT(*) * 100,
    2
  ) AS on_time_rate_pct,
  sum(oi.price+oi.freight_value) as total
FROM `brazilian_ecommerce.order_items` oi
JOIN `brazilian_ecommerce.orders` o
ON o.order_id = oi.order_id
WHERE o.order_status = 'delivered'
GROUP BY oi.seller_id
HAVING on_time_rate_pct < 80
ORDER BY on_time_rate_pct ASC;


-- Q3: Which sellers generated revenue in the top quartile but have an average review score in the bottom quartile?

WITH seller_stats AS (
  SELECT oi.seller_id, 
    ROUND(SUM(oi.price+oi.freight_value),2) AS total_sales, 
    ROUND(AVG(orv.review_score),2) AS avg_review_score
  FROM `brazilian_ecommerce.order_items` oi
  JOIN `brazilian_ecommerce.order_reviews` orv
  ON oi.order_id = orv.order_id
  GROUP BY oi.seller_id
),

quartiled AS (
  SELECT *,
    NTILE(4) OVER (ORDER BY total_sales DESC) AS sales_quartile,
    NTILE(4) OVER (ORDER BY avg_review_score ASC) AS review_quartile
  FROM seller_stats
)

SELECT seller_id, total_sales, avg_review_score FROM quartiled
WHERE sales_quartile=1 AND review_quartile=1
ORDER BY 2 DESC;