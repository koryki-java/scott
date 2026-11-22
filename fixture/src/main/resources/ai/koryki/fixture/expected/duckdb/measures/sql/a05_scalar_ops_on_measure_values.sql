WITH aggd1 (i1, k1, c1, c2) AS (
SELECT
  DISTINCT e.empno AS i1
, e.deptno AS k1
, e.sal AS c1
, e.comm AS c2
FROM
 scott.emp e
)
, aggm1 (k1, v1, v2, v3, v4) AS (
SELECT
  x.k1 AS k1
, sum(x.c1) AS v1
, COUNT(*) AS v2
, avg(CAST(x.c1 AS DOUBLE)) AS v3
, sum(x.c2) AS v4
FROM
 aggd1 x
GROUP BY
  x.k1
)
SELECT
  t.k1 AS deptno
, CAST(max(t.v1) AS DOUBLE) / NULLIF(max(t.v2), 0) AS salperemp
, max(t.v3) AS avgsal
, max(t.v1) + coalesce(max(t.v4), 0) AS totalpay
FROM
 aggm1 t
GROUP BY
  t.k1
ORDER BY
  t.k1 ASC