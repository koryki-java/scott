WITH aggd1 (i1, k1, c1) AS (
SELECT
  DISTINCT e.empno AS i1
, e.deptno AS k1
, e.sal AS c1
FROM
 scott.emp e
)
, aggm1s1 (k1, v1, v2) AS (
SELECT
  x.k1 AS k1
, COUNT(*) AS v1
, avg(CAST(x.c1 AS DOUBLE)) AS v2
FROM
 aggd1 x
GROUP BY
  x.k1
)
, aggm1s0 (v1, v2) AS (
SELECT
  COUNT(*) AS v1
, avg(CAST(x.c1 AS DOUBLE)) AS v2
FROM
 aggd1 x
)
, aggu (g, k1, v1, v2) AS (
 SELECT
   1 AS g
 , a.k1 AS k1
 , a.v1 AS v1
 , a.v2 AS v2
 FROM
  aggm1s1 a
UNION ALL
 SELECT
   0 AS g
 , CAST(NULL AS INTEGER) AS k1
 , a.v1 AS v1
 , a.v2 AS v2
 FROM
  aggm1s0 a
)
, aggr (g, k1, v1, v2) AS (
SELECT
  t.g AS g
, t.k1 AS k1
, max(t.v1) AS v1
, max(t.v2) AS v2
FROM
 aggu t
GROUP BY
  t.g
, t.k1
)
SELECT
  r.k1 AS deptno
, r.v1 AS empcount
, r.v2 AS avgsal
FROM
 aggr r
ORDER BY
  r.k1 ASC