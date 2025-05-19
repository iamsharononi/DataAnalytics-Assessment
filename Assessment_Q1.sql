-- Question 1: Find high-value customers who have both savings and investment products
SELECT 
    c.id AS owner_id,
    CONCAT(c.first_name, ' ', c.last_name) AS name,

    -- Count of savings plans with deposits
    COUNT(DISTINCT CASE 
        WHEN p.is_regular_savings = 1 AND s.confirmed_amount > 0 THEN p.id 
    END) AS savings_count,

    -- Count of investment plans with deposits
    COUNT(DISTINCT CASE 
        WHEN p.is_a_fund = 1 AND s.confirmed_amount > 0 THEN p.id 
    END) AS investment_count,

    -- Total confirmed deposits (in Naira), handling possible NULLs
    ROUND(SUM(s.confirmed_amount) / 100, 2) AS total_deposits

FROM 
    users_customuser c
JOIN 
    plans_plan p ON p.owner_id = c.id
JOIN 
    savings_savingsaccount s ON s.plan_id = p.id
WHERE 
    p.is_regular_savings = 1 OR p.is_a_fund = 1
GROUP BY 
    c.id, name
HAVING 
    savings_count >= 1 AND investment_count >= 1
ORDER BY 
    total_deposits DESC;