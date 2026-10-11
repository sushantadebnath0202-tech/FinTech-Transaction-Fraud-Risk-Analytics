# KPI dictionary — transaction risk

| KPI | Definition | Numerator / Denominator | Unit / notes |
| --- | --- | --- | --- |
| Submitted transactions | All rows of `transactions` | COUNT(*) | Attempts, not approvals |
| Transaction volume | Sum `amount_usd` for all submitted attempts | SUM(amount_usd) | USD, submitted volume includes declines |
| Approval rate | Approved attempts / submitted attempts | Approved / total | % |
| Alert rate | Rule-flagged attempts / submitted attempts | `SUM(is_flagged)` / total | % |
| Confirmed fraud cases | Simulated `confirmed_fraud=1` | COUNT conditional | Not equivalent to alerts |
| Realized fraud loss proxy | Approved transactions where fraud was confirmed, value sum | SUM(CASE ...) | USD, excludes declined losses |
| Cleared alert share | Reviewed alerts with outcome `Cleared` / all created alerts | cleared / all alerts | Operational proxy, not definitive precision |
| Missed fraud | Confirmed fraud transactions with `is_flagged=0` | COUNT conditional | Known only because labels were simulated |
| Channel rank | Dense rank over approved fraud loss by channel | RANKX/DENSE_RANK | Risk priority context |

**Alert scoring rule:** Base 10 + 34 if amount >= $650 + 26 if cross-border + 20 if new device + 15 if hour before 05:00 + 12 if amount >= $1,500. Cap score 100; flag at >=55. The rule is deterministic and illustrative.
