# Olist Brazilian E-Commerce Analysis

A SQL-driven business analysis of Olist, a Brazilian e-commerce marketplace connecting small sellers with customers nationwide. This project examines platform growth, customer retention, delivery operations, seller performance, and customer satisfaction — and traces how these areas connect to one another.

## Why this project

I'm a Flutter developer and educator transitioning into analytics engineering. This project is my first deep-dive applying SQL to a real, messy, multi-table business dataset — going beyond isolated queries to build a connected analytical narrative the way an analytics team would for a stakeholder.

## The Dataset

Source: [Olist Brazilian E-Commerce Public Dataset on Kaggle](https://www.kaggle.com/datasets/olistbr/brazilian-ecommerce)

Olist is a Brazilian marketplace that connects small businesses to major retail channels. The dataset covers **100,000 orders** placed between 2016 and 2018, spanning customers, orders, order items, payments, reviews, products, and sellers across Brazil.

**Tables used:**

| Table | Purpose |
|---|---|
| `orders` | One row per order; status, timestamps, customer link |
| `order_items` | One row per item in an order; links to seller and product |
| `order_payments` | Payment method and installment data per order |
| `order_reviews` | Customer review score and text per order |
| `customers` | Customer location and unique person identifier |
| `sellers` | Seller location |
| `products` | Product category and dimensions |

Queried using **Google BigQuery (Standard SQL)**.

## Key Findings

> Replace the bracketed values below with your actual results once queries are run.

- The platform processed **99441** orders between **September, 2016** and **October, 2018**, with month-over-month revenue growth peaking at **108.68%** in **February, 2017** excluding extreme high outliers at the start of the business. Since then the business' percentage growth has been on a general decline.
- Only **3.12%** of customers placed more than one order — repeat purchase behaviour is **low** for a marketplace of this size.
- **12.93%** of platform revenue is concentrated in the top 10 sellers, indicating **high** seller concentration risk.
- **8.11%** of orders were delivered after the estimated delivery date.
- Customers in **Roraima** experienced average delivery times of **28.98 days**, the slowest in the country. 9 states have an average delivery days greater than 20 days..
- **316** sellers had an on-time delivery rate below 80%, despite collectively generating **$677825.99** in revenue.
- **113** sellers ranked in the top revenue quartile while also ranking in the bottom review-score quartile — these are the platform's highest financial-risk sellers.
- Orders that received a 1-star review were delivered **12.36 days** later than the platform average, on average.
- Customers who paid in installments had an average order value of **$198.68**, compared to **$121.04** for customers who paid in full.

## Analysis Structure

The analysis is organized into five acts, each answering a connected set of business questions.

### Act 1 — Business Overview
`queries/01_business_overview.sql`
- Orders placed per month
- Month-over-month revenue change
- Total revenue per seller

### Act 2 — Customer Behaviour
`queries/02_customer_behaviour.sql`
- Percentage of customers who made more than one purchase
- Revenue contribution by state
- Order value: installments vs. paid in full

### Act 3 — Operations
`queries/03_operations.sql`
- Percentage of orders delivered on time
- States with average delivery time over 20 days
- Product categories with the longest shipping times

### Act 4 — Seller Performance
`queries/04_seller_performance.sql`
- Sellers who fulfilled more than 100 orders
- Sellers with an on-time delivery rate below 80%
- High-revenue, low-rating sellers (the platform's risk segment)

### Act 5 — Customer Experience
`queries/05_customer_experience.sql`
- Average review score per product category
- Relationship between late delivery and review score
- Average delivery delay for 1-star reviews

## The Story This Data Tells

Olist's order volume and revenue grew steadily over the analysis window, but that growth is not evenly distributed — a small group of sellers and states account for a disproportionate share of revenue. As operational strain becomes visible in delivery times, particularly in certain states and categories, customer satisfaction takes a measurable hit. The data shows a direct, traceable line from **late delivery → lower review scores**, and isolates the specific sellers responsible for the platform's worst delivery performance — including a subset generating significant revenue while actively damaging customer trust.

## Tools Used

- **Google BigQuery** — SQL querying and aggregation
- **[Tableau Public / Power BI / Looker Studio]** — visualization *(fill in whichever you use)*
- **dbdiagram.io** — schema diagram

## Repository Structure

```
olist-ecommerce-analysis/
├── README.md
├── queries/
│   ├── 01_business_overview.sql
│   ├── 02_customer_behaviour.sql
│   ├── 03_operations.sql
│   ├── 04_seller_performance.sql
│   └── 05_customer_experience.sql
├── results/
│   ├── screenshots/
│   └── findings.md
└── assets/
    └── schema.png
```

## How to Run

1. Download the dataset from [Kaggle](https://www.kaggle.com/datasets/olistbr/brazilian-ecommerce)
2. Create a free project in [BigQuery Sandbox](https://console.cloud.google.com/bigquery)
3. Upload each CSV as a table inside a dataset named `brazilian_ecommerce`
4. Run the queries in the `queries/` folder in order — each file corresponds to one act of the analysis

## Author

**Elisha Aduojo** — Flutter developer and educator, transitioning into analytics engineering.
[LinkedIn](https://linkedin.com/in/elisha-enefu-522010285) · [GitHub](https://github.com/ExcelWhite)
