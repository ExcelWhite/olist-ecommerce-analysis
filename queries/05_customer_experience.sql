-- What is the average review score per product category?

SELECT 
  p.product_category_name, 
  ROUND(AVG(orv.review_score), 2) AS avg_rs
FROM `brazilian_ecommerce.order_items` oi
JOIN `brazilian_ecommerce.order_reviews` orv
ON oi.order_id = orv.order_id
JOIN `brazilian_ecommerce.products` p
ON oi.product_id = p.product_id
WHERE p.product_category_name IS NOT NULL
GROUP BY p.product_category_name
ORDER BY 2 DESC;


-- Is there a relationship between late delivery and low review scores?

WITH delivery_performance AS (
  SELECT 
    o.order_id,
    orv.review_score,
    CASE 
      WHEN DATE_DIFF(o.order_delivered_customer_date, o.order_estimated_delivery_date, DAY) > 0 THEN 'Late'
      ELSE 'On-Time / Early'
    END AS delivery_status
  FROM `brazilian_ecommerce.orders` o
  JOIN `brazilian_ecommerce.order_reviews` orv
    ON o.order_id = orv.order_id
  WHERE o.order_status = 'delivered' 
    AND o.order_delivered_customer_date IS NOT NULL
)

SELECT
  delivery_status,
  COUNT(order_id) AS total_orders,
  ROUND(COUNT(order_id) / SUM(COUNT(order_id)) OVER () * 100, 2) AS pct_of_orders,
  ROUND(AVG(review_score), 2) AS average_review_score
FROM delivery_performance
GROUP BY delivery_status;


-- Q3: Among orders with a review score of 1, what was the average delay in days beyond the estimated delivery date?

SELECT 
  ROUND(
    AVG(DATE_DIFF(o.order_delivered_customer_date, o.order_estimated_delivery_date, day)), 
    2
  ) AS avg_delays
FROM `brazilian_ecommerce.orders` o
JOIN `brazilian_ecommerce.order_reviews` orv
ON o.order_id = orv.order_id
WHERE o.order_status = 'delivered'
  AND o.order_delivered_customer_date IS NOT NULL
  AND DATE_DIFF(o.order_delivered_customer_date, o.order_estimated_delivery_date, day) > 0
AND orv.review_score = 1
