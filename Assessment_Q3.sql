-- Question 3: Identify customers with active plans and no transactions in the last 3 months
SELECT 
    c.id,
    CONCAT(c.first_name, ' ', c.last_name) AS name,
    s.plan_id,
    MAX(s.transaction_date) AS last_transaction_date,
    MAX(s.maturity_end_date) AS maturity_end_date
FROM 
    users_customuser c
JOIN 
    savings_savingsaccount s ON c.id = s.owner_id
GROUP BY 
    c.id, c.name, s.plan_id
HAVING 
    MAX(s.transaction_date) < CURDATE() - INTERVAL 3 MONTH
    AND MAX(s.maturity_end_date) > CURDATE();