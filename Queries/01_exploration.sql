-- Table exploration
SELECT table_name, column_name 
FROM information_schema.columns 
WHERE table_schema = 'public'
ORDER BY table_name, ordinal_position

-- Order status exploration
SELECT order_status, COUNT(*) as total
FROM orders
GROUP BY order_status
ORDER BY total DESC;

-- First and last orders
SELECT 
MIN(order_purchase_timestamp) as first_order,
MAX(order_purchase_timestamp) as last_order
FROM orders;	
