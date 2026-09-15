-- Seller performance: total sales, items sold, and average rating
-- (sellers with at least 20 sales, to ensure a meaningful sample size)
SELECT 
    oi.seller_id,
    SUM(oi.price) AS total_sales,
    COUNT(*) AS items_sold,
    ROUND(AVG(orv.review_score), 2) AS avg_rating
FROM orders_items oi
INNER JOIN order_reviews orv 
    ON oi.order_id = orv.order_id
GROUP BY oi.seller_id
HAVING COUNT(*) >= 20
ORDER BY total_sales DESC
LIMIT 20; 