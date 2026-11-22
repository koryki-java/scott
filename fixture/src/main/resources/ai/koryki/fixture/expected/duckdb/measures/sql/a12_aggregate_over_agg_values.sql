WITH q1aggd1 (i1, k1, c1) AS (
SELECT
  DISTINCT e.empno AS i1
, e.deptno AS k1
, e.sal AS c1
FROM
 scott.emp e
)
, q1aggm1 (k1, v1) AS (
SELECT
  x.k1 AS k1
, sum(x.c1) AS v1
FROM
 q1aggd1 x
GROUP BY
  x.k1
)
, d (k, deptsal) AS (
SELECT
  t.k1 AS k
, max(t.v1) AS deptsal
FROM
 q1aggm1 t
GROUP BY
  t.k1
)
, q2aggd1 (i1, k1, c1) AS (
SELECT
  DISTINCT e.empno AS i1
, 'avg salary per emp' AS k1
, e.sal AS c1
FROM
 scott.emp e
)
, q2aggm1 (k1, v1) AS (
SELECT
  x.k1 AS k1
, avg(CAST(x.c1 AS DOUBLE)) AS v1
FROM
 q2aggd1 x
GROUP BY
  x.k1
)
 SELECT
   'avg payroll per dept' AS metric
 , avg(CAST(x.deptsal AS DOUBLE)) AS amount
 FROM
  d x
 GROUP BY
   'avg payroll per dept'
UNION ALL
 SELECT
   t.k1 AS metric
 , max(t.v1) AS amount
 FROM
  q2aggm1 t
 GROUP BY
   t.k1