-- Payment behavior by category: credit card share and average installments
SELECT 
    pct.product_category_name_english AS category,
    COUNT(*) AS total_payments,
    ROUND(100.0 * SUM(CASE WHEN op.payment_type = 'credit_card' THEN 1 ELSE 0 END) / COUNT(*), 1) AS pct_credit_card,
    ROUND(AVG(op.payment_installments), 1) AS avg_installments
FROM order_payments op
INNER JOIN orders_items oi 
    ON op.order_id = oi.order_id
INNER JOIN products p 
    ON oi.product_id = p.product_id
INNER JOIN product_category_translation pct 
    ON p.product_category_name = pct.product_category_name
GROUP BY pct.product_category_name_english
HAVING COUNT(*) >= 50
ORDER BY avg_installments DESC;