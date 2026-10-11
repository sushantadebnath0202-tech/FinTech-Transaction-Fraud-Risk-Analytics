# Business findings — transaction & fraud risk simulation

Analysis period: April–September 2026. Values are **synthetic USD examples**.

| KPI | Validated result |
| --- | ---: |
| Customers / accounts | 360 / 360 |
| Transactions | 1,800 |
| Submitted transaction volume | $264,372.78 |
| Approval rate | 88.33% |
| Risk alerts (flagged transactions) | 81 (4.50%) |
| Simulated confirmed fraud cases | 23 |
| Approved fraud losses in sample | $3,374.24 |
| Cleared alerts as share of all alerts | 87.65% |
| Confirmed fraud that was not flagged | 17 cases |

## Interpretation and recommended management response

1. Rule-based thresholds flag 4.50% of transactions; **alerts are not confirmed fraud**. A high cleared-alert share is a proxy for review workload, not a precise false-positive rate because some alerts remain escalated.
2. Approved, confirmed simulated fraud totals $3,374.24. Do not equate all flagged amounts with realized losses.
3. 17 simulated fraud cases were not flagged. Existing illustrative rules do not deliver complete fraud capture; test additional patterns before any deployment.
4. Segment by channel and merchant category using SQL analysis query 03/05. Prioritize review improvements where *confirmed loss* and *alert workload* intersect.
5. Business control proposal: track confirmed fraud capture rate, review clearance rate, approval impact, and review turnaround weekly; review rule threshold changes in an offline sample first.

## Caveats

- Classification labels and transactions were simulated, not investigated by a real compliance team.
- The alert score is a simple rule-based weighted sum, **not machine learning, certified AML monitoring, or a deployed fraud prevention service**.
- There is no full customer identity, real money movement, regulatory conclusion, or causal assessment.
