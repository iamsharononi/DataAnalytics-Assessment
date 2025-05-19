-- Question 4: Customer Lifetime Value
SELECT 
    c.id AS customer_id,
    CONCAT(c.first_name, ' ', c.last_name) AS name,
    
    -- Tenure in months: months between today and signup
    TIMESTAMPDIFF(MONTH, c.date_joined, CURDATE()) AS tenure_months,
    
    -- Total number of transactions
    COUNT(s.id) AS total_transactions,
    
    -- CLV formula: (transactions / tenure) * 12 * avg profit per transaction
    ROUND(
        (COUNT(s.id) / NULLIF(TIMESTAMPDIFF(MONTH, c.date_joined, CURDATE()), 0)) 
        * 12 * (0.001 * AVG(s.amount)) / 100, 2
    ) AS estimated_clv

FROM 
    users_customuser c
LEFT JOIN 
    savings_savingsaccount s
ON
	c.id = s.owner_id
GROUP BY 
    c.id, c.name
ORDER BY 
    estimated_clv DESC;