CREATE DATABASE telecom_churn;
USE telecom_churn;

CREATE TABLE customers (
customerID VARCHAR(50),
gender VARCHAR(10),
SeniorCitizen INT,
Partner VARCHAR(10),
Dependents VARCHAR(10),
tenure INT,
PhoneService VARCHAR(10),
MultipleLines VARCHAR(50),
InternetService VARCHAR(50),
OnlineSecurity VARCHAR(50),
OnlineBackup VARCHAR(50),
DeviceProtection VARCHAR(50),
TechSupport VARCHAR(50),
StreamingTV VARCHAR(50),
StreamingMovies VARCHAR(50),
Contract VARCHAR(50),
PaperlessBilling VARCHAR(10),
PaymentMethod VARCHAR(100),
MonthlyCharges DECIMAL(10,2),
TotalCharges DECIMAL(10,2),
Churn VARCHAR(10)
);

#1. Total Customers
SELECT COUNT(*) AS Total_Customers
FROM customers;

#2. Total Churned Customers
SELECT COUNT(*) AS Churned_Customers
FROM customers
WHERE Churn='Yes';

#3. Churn Rate
SELECT
ROUND(
COUNT(CASE WHEN Churn='Yes' THEN 1 END)
*100.0/
COUNT(*),
2
) AS Churn_Rate
FROM customers;

#4. Churn by Gender
SELECT
gender,
COUNT(*) AS Churned_Customers
FROM customers
WHERE Churn='Yes'
GROUP BY gender;

#5. Churn by Contract Type
SELECT
Contract,
COUNT(*) AS Churned_Customers
FROM customers
WHERE Churn='Yes'
GROUP BY Contract
ORDER BY Churned_Customers DESC;

#6. Churn by Internet Service
SELECT
InternetService,
COUNT(*) AS Churned_Customers
FROM customers
WHERE Churn='Yes'
GROUP BY InternetService;

#7. Churn by Payment Method
SELECT
PaymentMethod,
COUNT(*) AS Churned_Customers
FROM customers
WHERE Churn='Yes'
GROUP BY PaymentMethod
ORDER BY Churned_Customers DESC;

#8. Revenue Lost Due to Churn
SELECT
SUM(MonthlyCharges) AS Revenue_At_Risk
FROM customers
WHERE Churn='Yes';

#9. Average Monthly Charges of Churned Customers
SELECT
ROUND(AVG(MonthlyCharges),2)
AS Avg_Monthly_Charges
FROM customers
WHERE Churn='Yes';

#10. Average Tenure of Churned Customers
SELECT
ROUND(AVG(tenure),2)
AS Avg_Tenure
FROM customers
WHERE Churn='Yes';

#11. Churn Rate by Contract
SELECT
Contract,
ROUND(
COUNT(CASE WHEN Churn='Yes' THEN 1 END)
*100.0/
COUNT(*),
2
) AS Churn_Rate
FROM customers
GROUP BY Contract;

#12. Churn Rate by Internet Service
SELECT
InternetService,
ROUND(
COUNT(CASE WHEN Churn='Yes' THEN 1 END)
*100.0/
COUNT(*),
2
) AS Churn_Rate
FROM customers
GROUP BY InternetService;

#13. Top 5 High-Risk Customer Segments
SELECT
Contract,
InternetService,
COUNT(*) AS Churned_Customers
FROM customers
WHERE Churn='Yes'
GROUP BY Contract,InternetService
ORDER BY Churned_Customers DESC
LIMIT 5;

#14. Customers with Highest Monthly Charges
SELECT
customerID,
MonthlyCharges
FROM customers
ORDER BY MonthlyCharges DESC
LIMIT 10;

#15. Customers with Long Tenure Who Churned
SELECT
customerID,
tenure,
Contract
FROM customers
WHERE Churn='Yes'
ORDER BY tenure DESC
LIMIT 20;

#16. Rank Customers by Monthly Charges
SELECT
customerID,
MonthlyCharges,
DENSE_RANK() OVER(
ORDER BY MonthlyCharges DESC
) AS Rank_No
FROM customers;

#17. Top 5 Customers by Charges in Each Contract
WITH cte AS
(
SELECT
customerID,
Contract,
MonthlyCharges,
DENSE_RANK() OVER(
PARTITION BY Contract
ORDER BY MonthlyCharges DESC
) AS rn
FROM customers
)
SELECT *
FROM cte
WHERE rn<=5;

#18. Compare Churn Revenue to Total Revenue
SELECT
SUM(CASE WHEN Churn ='Yes'
THEN MonthlyCharges ELSE 0 END)
AS Churn_Revenue,
SUM(MonthlyCharges)
AS Total_Revenue
FROM customers;

#19. Create Tenure Groups
SELECT
CASE
WHEN tenure <=12 THEN '0-12 Months'
WHEN tenure <=24 THEN '13-24 Months'
WHEN tenure <=48 THEN '25-48 Months'
WHEN tenure <=60 THEN '49-60 Months'
ELSE '60+ Months'
END AS Tenure_Group,
COUNT(*) AS Customers
FROM customers
GROUP BY Tenure_Group;

#20. Churn Rate by Tenure Group
SELECT
CASE
WHEN tenure <=12 THEN '0-12 Months'
WHEN tenure <=24 THEN '13-24 Months'
WHEN tenure <=48 THEN '25-48 Months'
WHEN tenure <=60 THEN '49-60 Months'
ELSE '60+ Months'
END AS Tenure_Group,
ROUND(
COUNT(CASE WHEN Churn='Yes' THEN 1 END)
*100.0/
COUNT(*),
2
) AS Churn_Rate
FROM customers
GROUP BY Tenure_Group
ORDER BY Churn_Rate DESC;














