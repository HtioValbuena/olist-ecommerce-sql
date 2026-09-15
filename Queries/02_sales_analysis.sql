-- Total sales, items sold, average price, and average rating by product category
SELECT 
    pct.product_category_name_english AS category,
    SUM(oi.price) AS total_sales,
    COUNT(*) AS items_sold,
    ROUND(AVG(oi.price), 2) AS avg_item_price,
    ROUND(AVG(orv.review_score), 2) AS avg_rating
FROM order_items oi
INNER JOIN products p 
    ON oi.product_id = p.product_id
INNER JOIN product_category_translation pct 
    ON p.product_category_name = pct.product_category_name
INNER JOIN order_reviews orv
    ON oi.order_id = orv.order_id
GROUP BY pct.product_category_name_english
ORDER BY total_sales DESC;