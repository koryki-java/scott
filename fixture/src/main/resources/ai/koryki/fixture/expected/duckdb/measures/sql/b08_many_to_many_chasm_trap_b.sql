WITH aggd1 (i1, k1, c1) AS (
SELECT
  DISTINCT e.empno AS i1
, e.ename AS k1
, e.sal AS c1
FROM
 scott.bonus b
  INNER JOIN scott.emp e ON
   b.ename = e.ename
    LEFT OUTER JOIN scott.pet p ON
     e.empno = p.empno
)
, aggm1 (k1, v1) AS (
SELECT
  x.k1 AS k1
, sum(x.c1) AS v1
FROM
 aggd1 x
GROUP BY
  x.k1
)
, aggd2 (i1, i2, i3, i4, k1, c1) AS (
SELECT
  DISTINCT b.ename AS i1
, b.job AS i2
, b.sal AS i3
, b.comm AS i4
, e.ename AS k1
, b.comm AS c1
FROM
 scott.bonus b
  INNER JOIN scott.emp e ON
   b.ename = e.ename
    LEFT OUTER JOIN scott.pet p ON
     e.empno = p.empno
)
, aggm2 (k1, v2, v3) AS (
SELECT
  x.k1 AS k1
, count(x.i1) AS v2
, sum(x.c1) AS v3
FROM
 aggd2 x
GROUP BY
  x.k1
)
, aggd3 (i1, k1) AS (
SELECT
  DISTINCT p.pname AS i1
, e.ename AS k1
FROM
 scott.bonus b
  INNER JOIN scott.emp e ON
   b.ename = e.ename
    LEFT OUTER JOIN scott.pet p ON
     e.empno = p.empno
)
, aggm3 (k1, v4) AS (
SELECT
  x.k1 AS k1
, count(x.i1) AS v4
FROM
 aggd3 x
GROUP BY
  x.k1
)
, aggu (k1, v1, v2, v3, v4) AS (
  SELECT
    a.k1 AS k1
  , a.v1 AS v1
  , CAST(NULL AS INTEGER) AS v2
  , CAST(NULL AS DECIMAL(18, 4)) AS v3
  , CAST(NULL AS INTEGER) AS v4
  FROM
   aggm1 a
UNION ALL
  SELECT
    a.k1 AS k1
  , CAST(NULL AS DECIMAL(18, 4)) AS v1
  , a.v2 AS v2
  , a.v3 AS v3
  , CAST(NULL AS INTEGER) AS v4
  FROM
   aggm2 a
UNION ALL
 SELECT
   a.k1 AS k1
 , CAST(NULL AS DECIMAL(18, 4)) AS v1
 , CAST(NULL AS INTEGER) AS v2
 , CAST(NULL AS DECIMAL(18, 4)) AS v3
 , a.v4 AS v4
 FROM
  aggm3 a
)
SELECT
  t.k1 AS ename
, max(t.v1) AS sal
, max(t.v2) AS bonuses
, max(t.v3) AS bonus
, max(t.v4) AS pets
FROM
 aggu t
GROUP BY
  t.k1
ORDER BY
  t.k1 ASC