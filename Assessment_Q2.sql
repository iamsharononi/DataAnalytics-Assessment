-- Question 2: Calculate average transactions per month per customer and categorize them by frequency
WITH transaction_stats AS (
    SELECT
        c.id,
        c.name,
        COUNT(s.id) AS total_transactions,
        TIMESTAMPDIFF(MONTH, MIN(s.created_on), MAX(s.created_on)) + 1 AS active_months,
        ROUND(COUNT(s.id) / (TIMESTAMPDIFF(MONTH, MIN(s.created_on), MAX(s.created_on)) + 1), 2) AS avg_txn_per_month
    FROM 
        users_customuser c
    JOIN 
        savings_savingsaccount s
	ON
		c.id = s.owner_id
    GROUP BY 
        c.id, c.name
),
categorized AS (
    SELECT 
        *,
        CASE 
            WHEN avg_txn_per_month >= 10 THEN 'High Frequency'
            WHEN avg_txn_per_month BETWEEN 3 AND 9 THEN 'Medium Frequency'
            ELSE 'Low Frequency'
        END AS frequency_category
    FROM 
        transaction_stats
)
SELECT 
    frequency_category,
    COUNT(*) AS customer_count,
    ROUND(AVG(avg_txn_per_month), 1) AS avg_transactions_per_month
FROM 
    categorized
GROUP BY 
    frequency_category
ORDER BY 
    FIELD(frequency_category, 'High Frequency', 'Medium Frequency', 'Low Frequency');