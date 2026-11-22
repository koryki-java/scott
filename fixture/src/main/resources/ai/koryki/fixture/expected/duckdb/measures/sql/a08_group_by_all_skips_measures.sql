WITH aggd1 (i1, k1, c1) AS (
SELECT
  DISTINCT e.empno AS i1
, year(e.hiredate) AS k1
, e.sal AS c1
FROM
 scott.emp e
)
, aggm1 (k1, v1, v2) AS (
SELECT
  x.k1 AS k1
, COUNT(*) AS v1
, sum(x.c1) AS v2
FROM
 aggd1 x
GROUP BY
  x.k1
)
SELECT
  t.k1 AS hireyear
, max(t.v1) AS empcount
, max(t.v2) AS sumsal
FROM
 aggm1 t
GROUP BY
  t.k1
ORDER BY
  t.k1 ASC