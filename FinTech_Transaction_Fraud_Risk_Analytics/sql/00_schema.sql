-- MySQL 8.0+ | Synthetic data, no genuine financial records
CREATE DATABASE IF NOT EXISTS fintech_risk_analytics;
USE fintech_risk_analytics;
CREATE TABLE IF NOT EXISTS customers (
 customer_id INT PRIMARY KEY, signup_date DATE NOT NULL, country VARCHAR(32) NOT NULL,
 segment VARCHAR(32) NOT NULL, kyc_status VARCHAR(16) NOT NULL
);
CREATE TABLE IF NOT EXISTS accounts (
 account_id INT PRIMARY KEY, customer_id INT NOT NULL UNIQUE,
 account_type VARCHAR(20), opened_date DATE,
 FOREIGN KEY (customer_id) REFERENCES customers(customer_id)
);
CREATE TABLE IF NOT EXISTS transactions (
 transaction_id INT PRIMARY KEY, account_id INT NOT NULL,
 transaction_date DATE NOT NULL, transaction_time TIME NOT NULL,
 channel VARCHAR(24),merchant_category VARCHAR(30),amount_usd DECIMAL(12,2) NOT NULL,
 is_cross_border TINYINT NOT NULL,is_new_device TINYINT NOT NULL,is_high_value TINYINT NOT NULL,
 is_odd_hour TINYINT NOT NULL,risk_score INT NOT NULL,is_flagged TINYINT NOT NULL,
 transaction_status VARCHAR(12) NOT NULL,confirmed_fraud TINYINT NOT NULL,
 FOREIGN KEY (account_id) REFERENCES accounts(account_id),
 INDEX idx_transaction_date (transaction_date), INDEX idx_flagged (is_flagged)
);
CREATE TABLE IF NOT EXISTS alerts (
 alert_id INT PRIMARY KEY, transaction_id INT UNIQUE NOT NULL,alert_date DATE NOT NULL,
 rule_name VARCHAR(60), review_outcome VARCHAR(24),review_minutes INT,
 FOREIGN KEY (transaction_id) REFERENCES transactions(transaction_id)
);
