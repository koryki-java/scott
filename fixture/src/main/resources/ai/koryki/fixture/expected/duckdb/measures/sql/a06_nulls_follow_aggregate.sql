WITH aggd1 (i1, k1, c1) AS (
SELECT
  DISTINCT e.empno AS i1
, e.deptno AS k1
, e.comm AS c1
FROM
 scott.emp e
)
, aggm1 (k1, v1, v2, v3, v4) AS (
SELECT
  x.k1 AS k1
, COUNT(*) AS v1
, count(x.c1) AS v2
, sum(x.c1) AS v3
, avg(CAST(x.c1 AS DOUBLE)) AS v4
FROM
 aggd1 x
GROUP BY
  x.k1
)
SELECT
  t.k1 AS deptno
, max(t.v1) AS empcount
, max(t.v2) AS commcount
, max(t.v3) AS sumcomm
, max(t.v4) AS avgcomm
FROM
 aggm1 t
GROUP BY
  t.k1
ORDER BY
  t.k1 ASC