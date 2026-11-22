WITH aggd1 (i1, k1) AS (
SELECT
  DISTINCT d.deptno AS i1
, e.job AS k1
FROM
 scott.emp e
  INNER JOIN scott.dept d ON
   e.deptno = d.deptno
)
, aggm1 (k1, v1) AS (
SELECT
  x.k1 AS k1
, COUNT(*) AS v1
FROM
 aggd1 x
GROUP BY
  x.k1
)
SELECT
  t.k1 AS job
, max(t.v1) AS deptcount
FROM
 aggm1 t
GROUP BY
  t.k1
HAVING
  max(t.v1) > 1
ORDER BY
  t.k1 ASC