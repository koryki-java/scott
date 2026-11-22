WITH aggd1 (i1, c1) AS (
SELECT
  DISTINCT e.empno AS i1
, e.sal AS c1
FROM
 scott.emp e
WHERE
  e.deptno = 40
)
, aggm1 (v1, v2, v3) AS (
SELECT
  COUNT(*) AS v1
, sum(x.c1) AS v2
, avg(CAST(x.c1 AS DOUBLE)) AS v3
FROM
 aggd1 x
)
SELECT
  max(t.v1) AS empcount
, max(t.v2) AS sumsal
, max(t.v3) AS avgsal
FROM
 aggm1 t