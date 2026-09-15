# Olist E-commerce SQL Analysis

SQL analysis of the Olist Brazilian e-commerce public dataset using PostgreSQL. Portfolio project focused on data exploration, cleaning, and answering business questions through SQL.

## Dataset

[Brazilian E-Commerce Public Dataset by Olist](https://www.kaggle.com/datasets/olistbr/brazilian-ecommerce) — 9 related tables: customers, orders, order_items, order_payments, order_reviews, products, sellers, geolocation, product_category_translation.

## Tools

- PostgreSQL + pgAdmin4 (database and query execution)
- VS Code (documentation and version control)
- Git / GitHub (repository)

## Project structure

```
olist-ecommerce-sql/
├── Queries/
│   ├── 01_exploration.sql
│   ├── 02_sales_analysis.sql
│   ├── 03_logistics_analysis.sql
│   ├── 04_seller_performance.sql
│   └── 05_payment_analysis.sql
├── Screenshots/
└── README.md
```

## Business questions

1. Which product categories have the highest sales and best customer ratings?
2. Which Brazilian states have the most orders and the longest delivery times?
3. Which sellers perform best in terms of sales and customer satisfaction?
4. How do payment methods vary across product categories?

---

## Block 1: Initial exploration (`01_exploration.sql`)

### 1. Data import verification

All 9 tables were imported into PostgreSQL. Row counts match the expected dataset totals exactly, confirming a complete import.

![Table verification](Screenshots/01_verificacion_tablas.png)

| Table | Rows |
|---|---|
| customers | 99,441 |
| geolocation | 1,000,163 |
| orders | 99,441 |
| order_items | 112,650 |
| order_payments | 103,886 |
| order_reviews | 99,224 |
| products | 32,951 |
| sellers | 3,095 |
| product_category_translation | 71 |

### 2. Orders by status

![Orders by status](Screenshots/02_ordenes_por_status.png)

| Status | Count |
|---|---|
| delivered | 96,478 |
| shipped | 1,107 |
| canceled | 625 |
| unavailable | 609 |
| invoiced | 314 |
| processing | 301 |
| created | 5 |
| approved | 2 |

97% of orders are in `delivered` status. The rest did not complete their full lifecycle at the time the dataset was extracted. **Design decision:** delivery-time and customer-satisfaction analyses will be filtered to `order_status = 'delivered'`, since only these orders have a recorded delivery date.

### 3. Date range

![Date range](Screenshots/03_rango_fechas.png)

Orders span from **2016-09-04** to **2018-10-17** (2 years and 1 month). 2016 and 2018 are partial years (4 and ~10 months respectively); only 2017 is a full calendar year. Any year-over-year sales comparison needs to account for this to avoid comparing periods of different sizes.

---

## Block 2: Business Questions

### Question 1: Which product categories have the highest sales and best customer ratings? (`02_sales_analysis.sql`)

![Sales by category](Screenshots/04_sales_by_category.png)

| Category | Total Sales | Items Sold | Avg. Item Price | Avg. Rating |
|---|---|---|---|---|
| health_beauty | $1,252,404.85 | 9,645 | $129.85 | 4.14 |
| watches_gifts | $1,197,565.48 | 5,950 | $201.27 | 4.02 |
| bed_bath_table | $1,040,140.31 | 11,137 | $93.40 | 3.90 |
| sports_leisure | $986,848.92 | 8,640 | $114.22 | 4.11 |
| computers_accessories | $914,579.39 | 7,849 | $116.52 | 3.93 |

*(full results for all 71 categories in the query output)*

**Key findings:**

- `health_beauty` leads in total revenue, but `watches_gifts` earns almost as much with 40% fewer items sold, its average item price ($201.27) is roughly double that of `bed_bath_table` ($93.40), showing revenue can come from either high volume or high price per item.
- `computers` stands out as a high-value niche category: highest average item price ($1,070.99) but only 200 items sold.
- `security_and_services` has both minimal volume (2 items) and the lowest average rating (2.50)  this pattern suggests a potential problem area, though the cause would need further business context to confirm.

**Known limitation:** `review_score` is recorded at the order level, not the item level. When an order contains multiple items of the same category, its review score is counted once per item in the average, this can slightly overweight categories with multi-item orders.

### Question 2: Which Brazilian states have the most orders and the longest delivery times? (`03_logistics_analysis.sql`)

![Orders and delivery time by state](Screenshots/05_orders_by_state.png)

| State | Total Orders | Avg. Delivery (days) |
|---|---|---|
| SP | 40,501 | 8.8 |
| RJ | 12,350 | 15.3 |
| MG | 11,354 | 12.0 |
| RS | 5,345 | 15.3 |
| PR | 4,923 | 12.0 |
| SC | 3,546 | 15.0 |
| BA | 3,256 | 19.3 |
| DF | 2,080 | 13.0 |
| ES | 1,995 | 15.8 |
| GO | 1,957 | 15.6 |
| PE | 1,593 | 18.4 |
| CE | 1,279 | 21.3 |
| PA | 946 | 23.8 |
| MT | 886 | 18.1 |
| MA | 717 | 21.6 |
| MS | 701 | 15.6 |
| PB | 517 | 20.4 |
| PI | 476 | 19.5 |
| RN | 474 | 19.3 |
| AL | 397 | 24.5 |
| SE | 335 | 21.5 |
| TO | 274 | 17.7 |
| RO | 243 | 19.4 |
| AM | 145 | 26.4 |
| AC | 80 | 21.0 |
| AP | 67 | 27.2 |
| RR | 41 | 29.4 |

**Key findings:**

- `SP` (São Paulo) dominates in volume (40,501 orders - more than 3x the next state) and also has the fastest average delivery (8.8 days). This pattern suggests Olist's sellers/distribution infrastructure is likely concentrated in or near São Paulo, though this dataset doesn't include warehouse location data to confirm it directly.
- `RJ`, the second-highest volume state, still takes almost double the delivery time of `SP` (15.3 vs. 8.8 days) despite relative geographic proximity, reinforcing that distance from the fulfillment hub, not demand alone, drives delivery speed.
- The slowest-delivery states (`RR`: 29.4 days, `AP`: 27.2, `AM`: 26.4) are all in Brazil's North region, and also have the lowest order volumes, consistent with lower population density and greater logistical distance from major distribution centers.