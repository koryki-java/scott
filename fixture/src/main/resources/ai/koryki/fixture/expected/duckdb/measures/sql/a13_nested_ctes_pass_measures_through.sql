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
, staff2 (deptno, payroll, headcount) AS (
SELECT
  s.deptno AS deptno
, s.payroll AS payroll
, s.headcount AS headcount
FROM
 staff s
)
, staff3 (deptno, payroll, headcount) AS (
SELECT
  t.deptno AS deptno
, t.payroll AS payroll
, t.headcount AS headcount
FROM
 staff2 t
)
SELECT
  u.deptno AS deptno
, sum(u.payroll) AS payroll
, count(u.headcount) AS headcount
FROM
 staff3 u
GROUP BY
  u.deptno
ORDER BY
  u.deptno ASC