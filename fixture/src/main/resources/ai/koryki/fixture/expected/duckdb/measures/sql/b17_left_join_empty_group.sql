WITH aggd1 (i1, k1, c1) AS (
SELECT
  DISTINCT e.empno AS i1
, d.dname AS k1
, e.sal AS c1
FROM
 scott.dept d
  LEFT OUTER JOIN scott.emp e ON
   d.deptno = e.deptno
)
, aggm1 (k1, v1, v2, v3) AS (
SELECT
  x.k1 AS k1
, count(x.i1) AS v1
, sum(x.c1) AS v2
, avg(CAST(x.c1 AS DOUBLE)) AS v3
FROM
 aggd1 x
GROUP BY
  x.k1
)
SELECT
  t.k1 AS dname
, max(t.v1) AS empcount
, max(t.v2) AS sumsal
, max(t.v3) AS avgsal
FROM
 aggm1 t
GROUP BY
  t.k1
ORDER BY
  t.k1 ASC