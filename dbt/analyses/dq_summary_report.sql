-- analyses/dq_summary_report.sql
-- รันด้วย: dbt compile --select dq_summary_report
-- แล้ว copy compiled SQL ไปรันใน BigQuery Console

{{ generate_dq_summary('mart_fiber_fcr') }}
