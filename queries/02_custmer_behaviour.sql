-- ACT 2: CUSTOMER BEHAVIOUR


-- Q1: What percentage of customers made more than one purchase?

SELECT ROUND((COUNTIF(cnt_more_than_one>1)/COUNT(customer_unique_id))*100, 2) AS perc_return_customers
FROM (
  SELECT
    c.customer_unique_id,
    COUNT(o.order_purchase_timestamp) AS cnt_more_than_one
  FROM `brazilian_ecommerce.orders` o
  JOIN `brazilian_ecommerce.customers` c
  ON o.customer_id = c.customer_id
  GROUP BY c.customer_unique_id
);



-- Q2: Which states contribute the most revenue as a percentage of total platform revenue?

SELECT c.customer_state, ROUND(SUM(oi.price+oi.freight_value),2) as state_revenue,
  ROUND(
    SUM(oi.price+oi.freight_value)/
    SUM(SUM(oi.price+oi.freight_value)) OVER() * 100,
    2
  ) AS state_revenue_pct
FROM `brazilian_ecommerce.orders` o
JOIN `brazilian_ecommerce.order_items` oi
ON o.order_id = oi.order_id
JOIN `brazilian_ecommerce.customers` c
ON c.customer_id = o.customer_id
GROUP BY c.customer_state
ORDER BY state_revenue DESC;



-- Q3: Do customers who paid in installments have a higher or lower order value than those who paid in full?

SELECT 
  payment_type,
  ROUND(AVG(order_value), 2) AS avg_order_value,
  COUNT(*) AS num_orders
FROM (
  SELECT 
    order_id,
    SUM(payment_value) AS order_value,
    CASE 
      WHEN MAX(payment_installments) = 1 THEN 'paid in full'
      WHEN MAX(payment_installments) > 1 THEN 'installments'
    END AS payment_type
  FROM `brazilian_ecommerce.order_payments`
  GROUP BY order_id
) AS order_summary
WHERE payment_type IS NOT NULL
GROUP BY payment_type
ORDER BY avg_order_value DESC;



