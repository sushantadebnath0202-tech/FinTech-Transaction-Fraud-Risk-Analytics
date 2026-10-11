USE fintech_risk_analytics;
-- Expected row counts are documented in README.
SELECT 'customers' AS table_name,COUNT(*) AS records FROM customers
UNION ALL SELECT 'accounts',COUNT(*) FROM accounts
UNION ALL SELECT 'transactions',COUNT(*) FROM transactions
UNION ALL SELECT 'alerts',COUNT(*) FROM alerts;
SELECT COUNT(*) AS missing_customer_accounts FROM accounts a LEFT JOIN customers c ON a.customer_id=c.customer_id WHERE c.customer_id IS NULL;
SELECT COUNT(*) AS unmatched_transactions FROM transactions t LEFT JOIN accounts a ON t.account_id=a.account_id WHERE a.account_id IS NULL;
SELECT COUNT(*) AS nonpositive_amounts FROM transactions WHERE amount_usd<=0;
SELECT COUNT(*) AS invalid_fraud_labels FROM transactions WHERE confirmed_fraud NOT IN (0,1);
SELECT COUNT(*) AS alert_flag_mismatch FROM transactions t LEFT JOIN alerts a ON t.transaction_id=a.transaction_id
 WHERE (t.is_flagged=1 AND a.alert_id IS NULL) OR (t.is_flagged=0 AND a.alert_id IS NOT NULL);
SELECT COUNT(*) AS duplicate_transaction_ids FROM (SELECT transaction_id FROM transactions GROUP BY transaction_id HAVING COUNT(*)>1) d;
