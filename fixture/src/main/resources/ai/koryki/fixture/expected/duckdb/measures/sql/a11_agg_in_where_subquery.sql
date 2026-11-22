WITH q1aggd1 (i1, c1) AS (
SELECT
  DISTINCT x.empno AS i1
, x.sal AS c1
FROM
 scott.emp x
)
, q1aggm1 (v1) AS (
SELECT
  avg(CAST(x.c1 AS DOUBLE)) AS v1
FROM
 q1aggd1 x
)
, q2aggd1 (i1, k1) AS (
SELECT
  DISTINCT e.empno AS i1
, e.deptno AS k1
FROM
 scott.emp e
WHERE
  e.sal > (
    SELECT
      max(t.v1) AS avg_sal
    FROM
     q1aggm1 t
   )
)
, q2aggm1 (k1, v1) AS (
SELECT
  x.k1 AS k1
, COUNT(*) AS v1
FROM
 q2aggd1 x
GROUP BY
  x.k1
)
SELECT
  t.k1 AS deptno
, max(t.v1) AS empcount
FROM
 q2aggm1 t
GROUP BY
  t.k1
ORDER BY
  t.k1 ASC