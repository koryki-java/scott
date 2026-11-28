WITH staff (deptno, payroll, headcount) AS (
SELECT
  e.deptno AS deptno
, e.sal AS payroll
, 1 AS headcount
FROM
 scott.emp e
WHERE
  e.job IN ('CLERK', 'SALESMAN')
)
SELECT
  s.deptno AS deptno
, sum(s.payroll) AS payroll
, count(s.headcount) AS headcount
FROM
 staff s
GROUP BY
  s.deptno
ORDER BY
  s.deptno ASC