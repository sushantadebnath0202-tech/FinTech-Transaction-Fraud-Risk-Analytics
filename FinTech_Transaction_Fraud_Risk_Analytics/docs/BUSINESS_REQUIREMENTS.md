# Business Requirements Document (BRD)

**Case:** Digital Banking Transaction & Fraud Risk Monitoring

**Problem:** Improve visibility into payment attempts, risk alerts, verified sample fraud and review capacity

**Stakeholders:** Head of Operations; Risk Operations Manager; Product Analyst

## Management questions
1. What is submitted transaction volume and approval rate?
2. Where are risk alerts most concentrated?
3. How much simulated verified fraud made it through approval?
4. How costly is alert review?
5. Which fraud cases did the simple rules miss?

## In scope

MySQL import/validation, risk rule analysis, Excel calculation, PBIP KPI dashboard; excludes real-time scoring, regulated AML decisioning, and deployment.

## Data acceptance criteria

- Document record grain and primary keys; do not count joined facts as unique customers.
- No missing foreign keys; zero duplicate primary/composite keys.
- Reconcile monetary totals with component measures and expose denominator definitions.
- Distinguish operational proxies and simulated labels from verified business facts.
- Provide auditable SQL, formula-based Excel summaries, DAX source, and a documented dashboard layout.

## Dashboard design

Page 1: management scorecard with four KPI cards, time trend and mix chart.

Page 2: investigative/retention detail with operational indicators and segmentation.

## Sign-off standard

Counts and ratios must reconcile between raw CSV and SQL. Visual screenshots require separate Power BI Desktop execution before claiming a rendered interactive report.
