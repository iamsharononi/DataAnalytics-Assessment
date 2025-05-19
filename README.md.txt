
SQL Assessment

 Overview

This project includes solutions to four key business questions aimed at analyzing customer behaviors and account activities using SQL.
The analysis utilizes three main tables:

 `users_customuser` (Customer Info)
 `plans_plan` (Savings & Investment Plan Info)
 `savings_savingsaccount` (Transaction Info)
 `withdrawals_withdrawal` (Withdrawal Info)

---

Solutions Approach

 1. High-Value Customers with Multiple Products

Objective:
Identify customers who have both a funded savings plan and an investment plan, then rank them by total deposits.

Approach:
 a). Used conditional `COUNT(DISTINCT …)` to separately count savings and investment plans with deposits.
 b). Filtered with `HAVING savings_count >= 1 AND investment_count >= 1`.
 c). Aggregated confirmed inflow amounts and converted from kobo to naira.
 d). Ordered by total deposits in descending order.

Key Considerations:
Used `CASE` statements inside aggregation to avoid double-counting and ensured financial accuracy by converting kobo to naira.

Insight(s):
Only a few customers hold both savings and investment plans with significant deposits.

Recommendation(s):
These multi-product users are strong candidates for VIP programs or premium offerings.
Focus on cross-selling to users who currently have only one product type.
-----------

 2. Transaction Frequency Analysis

Objective:
Categorize customers based on their average number of transactions per month.

Approach:
 a). Used a CTE to calculate:
  	i). `total_transactions`
  	ii). `active_months` (difference between first and last transaction month)
  	iii). `avg_txn_per_month`
 b). Created a frequency category using a `CASE` clause.
 c). Aggregated the customer count and average transactions for each frequency group.

Frequency Buckets:
 a). High Frequency: ≥ 10
 b). Medium Frequency: 3 - 9
 c). Low Frequency: ≤ 2

Key Considerations:
Used `TIMESTAMPDIFF(MONTH, MIN, MAX)` to determine customer activity duration and avoid division by zero.

Insight(s):
Most customers (72%) are low-frequency users, averaging fewer than 3 transactions per month.

Recommendation(s):
Introduce engagement nudges, gamification, and personalized incentives to boost activity especially among low- and medium-frequency users.

-----------

 3. Account Inactivity Alert

Objective:
Flag accounts with no transactions in the last 12 months but are still considered active.

Approach:
 a). Joined users and savings accounts.
 b). Grouped by customer and plan.
 c). Filtered plans where:
   	i). Last transaction occurred more than 3 months ago.
   	ii). Maturity end date is in the future (indicating an active plan).

Challenge & Resolution:
 a). The `plans_plan` table didn’t include `maturity_date`.
 b). Instead, used `savings_savingsaccount.maturity_end_date` to determine plan activity status.
 
Insight(s):
No customers were found who met the criteria (inactive for 3+ months but still had active plans).

Recommendation(s):
Reassess the filtering window or maturity conditions.
Alternatively, broaden criteria to catch at-risk users before they churn.

-----------

 4. Customer Lifetime Value (CLV) Estimation

Objective:
Estimate CLV using customer tenure and transaction behavior.

Formula:
CLV = (transactions / tenure) * 12 * avg profit per transaction

Where:
 Avg profit = 0.1% of transaction amount (in kobo)

Approach:
 a). Calculated tenure using `TIMESTAMPDIFF`.
 b). Handled division by zero using `NULLIF`.
 c). Converted kobo to naira and applied 0.1% multiplier.
 d). Used `IFNULL` to replace `NULL` CLVs with ₦0.00 for customers with no transactions.

Challenge & Resolution:
 Customers with no transactions caused `AVG(amount)` to return NULL, making CLV undefined.
 Applied `IFNULL()` to make default CLV to 0.00.

Insight(s):
CLV varies widely, with top customers showing long tenure and frequent transactions.
Some users have zero CLV due to no activity.

Recommendation(s):
Focus retention and rewards on high CLV users.
For zero-CLV customers, initiate onboarding or activation campaigns to generate value.



-----------

   Difficulties Encountered And Resolutions Made

1. Handling Customers with No Transactions (CLV Calculation)
Challenge:
While calculating CLV, some customers had no transaction records, resulting in a NULL value for average transaction amount.
This made the CLV formula undefined or misleading for such cases.

Resolution:
Used SQL’s IFNULL() function to replace NULL CLV values with ₦0.00, ensuring a more accurate and consistent output.
This also prevented display issues or misleading interpretations in the final report.


2. Zero Tenure Leading to Division Errors (CLV Calculation)
Challenge:
A few customers had a tenure of zero months, which caused a division-by-zero risk when calculating average transactions per month.

Resolution:
Applied NULLIF(tenure_months, 0) in the denominator to avoid division errors. 
This ensured the query handled new or incomplete customer records adequtely.


3. Missing Maturity Date in plans_plan Table (Inactivity Alert)
Challenge:
The original logic for identifying inactive accounts depended on a maturity_date field in the plans_plan table, which was not present in the dataset.

Resolution:
Adjusted the query to use maturity_end_date from the savings_savingsaccount table instead.
This allowed continued validation of account status without relying on unavailable fields.


4. Empty Result in Inactivity Alert Query
Challenge:
After implementing the inactivity alert logic, the query returned no results.

Resolution:
Conducted a data review and determined that all maturity dates were in the past, meaning no "currently active but inactive" accounts existed at the time. 

