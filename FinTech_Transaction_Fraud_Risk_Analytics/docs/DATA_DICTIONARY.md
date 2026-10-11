# Data dictionary

All records synthetic. Monetary fields use USD.

## customers
Grain: one customer

| Column | Interpretation |
| --- | --- |
| `customer_id` | Customer id (synthetic identifier; use for joins) |
| `signup_date` | Signup date |
| `country` | Country |
| `segment` | Segment |
| `kyc_status` | Kyc status |

## accounts
Grain: one account

| Column | Interpretation |
| --- | --- |
| `account_id` | Account id (synthetic identifier; use for joins) |
| `customer_id` | Customer id (synthetic identifier; use for joins) |
| `account_type` | Account type |
| `opened_date` | Opened date |

## transactions
Grain: one payment attempt

| Column | Interpretation |
| --- | --- |
| `transaction_id` | Transaction id (synthetic identifier; use for joins) |
| `account_id` | Account id (synthetic identifier; use for joins) |
| `transaction_date` | Transaction date |
| `transaction_time` | Transaction time |
| `channel` | Channel |
| `merchant_category` | Merchant category |
| `amount_usd` | Amount usd |
| `is_cross_border` | Is cross border (0=no; 1=yes) |
| `is_new_device` | Is new device (0=no; 1=yes) |
| `is_high_value` | Is high value (0=no; 1=yes) |
| `is_odd_hour` | Is odd hour (0=no; 1=yes) |
| `risk_score` | Risk score |
| `is_flagged` | Is flagged (0=no; 1=yes) |
| `transaction_status` | Transaction status |
| `confirmed_fraud` | Confirmed fraud (simulated ground truth, not a regulatory conclusion) |

## alerts
Grain: one flagged review alert

| Column | Interpretation |
| --- | --- |
| `alert_id` | Alert id (synthetic identifier; use for joins) |
| `transaction_id` | Transaction id (synthetic identifier; use for joins) |
| `alert_date` | Alert date |
| `rule_name` | Rule name |
| `review_outcome` | Review outcome |
| `review_minutes` | Review minutes |
