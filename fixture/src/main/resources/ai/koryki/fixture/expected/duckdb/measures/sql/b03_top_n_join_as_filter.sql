WITH q1aggd1 (i1, k1, c1) AS (
SELECT
  DISTINCT x.empno AS i1
, x.deptno AS k1
, x.sal AS c1
FROM
 scott.emp x
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
, top (d, s) AS (
SELECT
  t.k1 AS d
, max(t.v1) AS s
FROM
 q1aggm1 t
GROUP BY
  t.k1
ORDER BY
  max(t.v1) DESC
FETCH FIRST 2 ROWS ONLY
)
, q2aggd1 (i1, k1, c1) AS (
SELECT
  DISTINCT e.empno AS i1
, e.job AS k1
, e.sal AS c1
FROM
 scott.emp e
WHERE
  e.deptno IN (
    SELECT
      t.d
    FROM
     top t
   )
)
, q2aggm1 (k1, v1) AS (
SELECT
  x.k1 AS k1
, sum(x.c1) AS v1
FROM
 q2aggd1 x
GROUP BY
  x.k1
)
SELECT
  t.k1 AS job
, max(t.v1) AS sumsal
FROM
 q2aggm1 t
GROUP BY
  t.k1
ORDER BY
  t.k1 ASC