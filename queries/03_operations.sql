-- ACT 3: OPERATIONS

-- Q1: What percentage of orders were delivered on time?

SELECT 
  ROUND(
    COUNTIF(order_delivered_customer_date <= order_estimated_delivery_date)/
   COUNT(*)*100, 2
  )
FROM `brazilian_ecommerce.orders`
WHERE order_status = 'delivered'
  AND order_delivered_customer_date IS NOT NULL;


-- Q2: Which states have an average delivery time longer than 20 days?

SELECT 
  c.customer_state,
  ROUND(
    AVG(
      DATE_DIFF(o.order_delivered_customer_date, o.order_purchase_timestamp, day)
    ), 2
  ) as avg_delivery_days
FROM `brazilian_ecommerce.customers` c
JOIN `brazilian_ecommerce.orders` o
ON c.customer_id = o.customer_id
WHERE o.order_status = 'delivered'
  AND order_delivered_customer_date IS NOT NULL
GROUP BY c.customer_state
HAVING avg_delivery_days > 20
ORDER BY avg_delivery_days DESC;


-- Q3: Which product categories take the longest to ship from purchase to delivery?

SELECT COALESCE(p.product_category_name, 'uncategorised') AS product_category_name, 
  ROUND(
    AVG(
      TIMESTAMP_DIFF(o.order_delivered_customer_date, o.order_purchase_timestamp, day)
    ), 2
  ) avg_delivery_days
FROM `brazilian_ecommerce.order_items` oi
JOIN `brazilian_ecommerce.orders` o
ON oi.order_id = o.order_id
JOIN `brazilian_ecommerce.products` p
ON p.product_id = oi.product_id
GROUP BY p.product_category_name
ORDER BY avg_delivery_days DESC;



