WITH aggd1 (i1, k1, c1) AS (
SELECT
  DISTINCT e.empno AS i1
, s.grade AS k1
, e.sal AS c1
FROM
 scott.emp e
  INNER JOIN scott.dept d ON
   e.deptno = d.deptno
  INNER JOIN scott.salgrade s ON
   e.sal >= s.losal
  AND
   e.sal <= s.hisal
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
, aggd2 (i1, k1) AS (
SELECT
  DISTINCT d.deptno AS i1
, s.grade AS k1
FROM
 scott.emp e
  INNER JOIN scott.dept d ON
   e.deptno = d.deptno
  INNER JOIN scott.salgrade s ON
   e.sal >= s.losal
  AND
   e.sal <= s.hisal
)
, aggm2 (k1, v3) AS (
SELECT
  x.k1 AS k1
, COUNT(*) AS v3
FROM
 aggd2 x
GROUP BY
  x.k1
)
, aggu (k1, v1, v2, v3) AS (
 SELECT
   a.k1 AS k1
 , a.v1 AS v1
 , a.v2 AS v2
 , CAST(NULL AS INTEGER) AS v3
 FROM
  aggm1 a
UNION ALL
 SELECT
   a.k1 AS k1
 , CAST(NULL AS INTEGER) AS v1
 , CAST(NULL AS DECIMAL(18, 4)) AS v2
 , a.v3 AS v3
 FROM
  aggm2 a
)
SELECT
  t.k1 AS grade
, max(t.v1) AS empcount
, max(t.v2) AS sumsal
, max(t.v3) AS deptcount
FROM
 aggu t
GROUP BY
  t.k1
ORDER BY
  t.k1 ASC