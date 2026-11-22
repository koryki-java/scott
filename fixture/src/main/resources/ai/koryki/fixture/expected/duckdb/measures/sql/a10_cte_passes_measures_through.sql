WITH aggd1 (i1, k1, c1) AS (
SELECT
  DISTINCT e.empno AS i1
, e.deptno AS k1
, e.sal AS c1
FROM
 scott.emp e
WHERE
  e.job IN ('CLERK', 'SALESMAN')
)
, aggm1 (k1, v1, v2) AS (
SELECT
  x.k1 AS k1
, sum(x.c1) AS v1
, COUNT(*) AS v2
FROM
 aggd1 x
GROUP BY
  x.k1
)
SELECT
  t.k1 AS deptno
, max(t.v1) AS payroll
, max(t.v2) AS headcount
FROM
 aggm1 t
GROUP BY
  t.k1
ORDER BY
  t.k1 ASC