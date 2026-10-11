USE fintech_risk_analytics;
-- 01 Executive scorecard: distinguish flagged transactions and confirmed fraud.
SELECT COUNT(*) AS transactions,
 ROUND(SUM(amount_usd),2) AS processed_amount_usd,
 ROUND(100*AVG(transaction_status='Approved'),2) AS approval_rate_pct,
 SUM(is_flagged) AS flagged_transactions,
 ROUND(100*AVG(is_flagged),2) AS alert_rate_pct,
 SUM(confirmed_fraud) AS confirmed_fraud_transactions,
 ROUND(SUM(CASE WHEN confirmed_fraud=1 AND transaction_status='Approved' THEN amount_usd ELSE 0 END),2) AS realized_fraud_loss_usd
FROM transactions;

-- 02 Monthly volume, acceptance, alerts and realized losses.
SELECT DATE_FORMAT(transaction_date,'%Y-%m') AS month,
 COUNT(*) AS transactions,ROUND(SUM(amount_usd),2) AS volume_usd,
 ROUND(100*AVG(transaction_status='Approved'),2) AS approval_pct,
 ROUND(100*AVG(is_flagged),2) AS flagged_pct,
 SUM(CASE WHEN confirmed_fraud=1 AND transaction_status='Approved' THEN amount_usd ELSE 0 END) AS fraud_loss_usd
FROM transactions GROUP BY DATE_FORMAT(transaction_date,'%Y-%m') ORDER BY month;

-- 03 By payment channel; order by realized fraud loss.
SELECT channel,COUNT(*) AS txns,ROUND(SUM(amount_usd),2) AS volume_usd,
 SUM(is_flagged) AS alerts, SUM(confirmed_fraud) AS fraud_cases,
 ROUND(SUM(CASE WHEN confirmed_fraud=1 AND transaction_status='Approved' THEN amount_usd ELSE 0 END),2) AS fraud_loss_usd
FROM transactions GROUP BY channel ORDER BY fraud_loss_usd DESC;

-- 04 Rules effectiveness and false-positive proxy.
SELECT COUNT(*) AS alerts,
 SUM(review_outcome='Confirmed Fraud') AS true_positive_alerts,
 SUM(review_outcome='Cleared') AS cleared_alerts,
 ROUND(100*SUM(review_outcome='Cleared')/NULLIF(COUNT(*),0),2) AS cleared_alert_pct,
 ROUND(AVG(review_minutes),1) AS avg_review_minutes
FROM alerts;

-- 05 Customer and merchant risk concentration using joins.
SELECT c.country,t.merchant_category,COUNT(*) AS txns,
 SUM(t.is_flagged) AS alerts,
 SUM(CASE WHEN t.confirmed_fraud=1 AND t.transaction_status='Approved' THEN t.amount_usd ELSE 0 END) AS fraud_loss_usd
FROM transactions t JOIN accounts a ON t.account_id=a.account_id
JOIN customers c ON a.customer_id=c.customer_id
GROUP BY c.country,t.merchant_category HAVING COUNT(*)>=10
ORDER BY fraud_loss_usd DESC, alerts DESC LIMIT 15;

-- 06 Month-on-month risk trajectory using CTE and LAG.
WITH monthly AS (
 SELECT DATE_FORMAT(transaction_date,'%Y-%m') AS month, COUNT(*) AS n, SUM(is_flagged) AS alerts
 FROM transactions GROUP BY DATE_FORMAT(transaction_date,'%Y-%m')
), trends AS (
 SELECT month,n,alerts,ROUND(100*alerts/n,2) AS alert_pct,
 LAG(ROUND(100*alerts/n,2)) OVER (ORDER BY month) AS previous_alert_pct
 FROM monthly)
SELECT *, ROUND(alert_pct-previous_alert_pct,2) AS change_pp FROM trends ORDER BY month;

-- 07 Top-risk accounts: rank by flagged transactions.
WITH acct AS (
 SELECT account_id,COUNT(*) AS txns,SUM(is_flagged) AS flags,
 SUM(CASE WHEN confirmed_fraud=1 AND transaction_status='Approved' THEN amount_usd ELSE 0 END) AS loss_usd
 FROM transactions GROUP BY account_id HAVING COUNT(*)>=3)
SELECT account_id,txns,flags,loss_usd,
 DENSE_RANK() OVER(ORDER BY flags DESC,loss_usd DESC) AS risk_rank
FROM acct ORDER BY flags DESC,loss_usd DESC LIMIT 20;

-- 08 Missed fraud: non-flagged true cases (a model limitation, not 'fraud prevention').
SELECT COUNT(*) AS missed_fraud_count,
 SUM(CASE WHEN transaction_status='Approved' THEN amount_usd ELSE 0 END) AS missed_approved_loss_usd
FROM transactions WHERE confirmed_fraud=1 AND is_flagged=0;
