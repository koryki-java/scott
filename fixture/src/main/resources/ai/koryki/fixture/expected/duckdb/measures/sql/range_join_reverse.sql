WITH aggd1 (i1, k1) AS (
SELECT
  DISTINCT e.empno AS i1
, s.grade AS k1
FROM
 scott.salgrade s
  INNER JOIN scott.emp e ON
   e.sal >= s.losal
  AND
   e.sal <= s.hisal
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
, aggd2 (i1, k1) AS (
SELECT
  DISTINCT s.grade AS i1
, s.grade AS k1
FROM
 scott.salgrade s
  INNER JOIN scott.emp e ON
   e.sal >= s.losal
  AND
   e.sal <= s.hisal
)
, aggm2 (k1, v2) AS (
SELECT
  x.k1 AS k1
, COUNT(*) AS v2
FROM
 aggd2 x
GROUP BY
  x.k1
)
, aggu (k1, v1, v2) AS (
 SELECT
   a.k1 AS k1
 , a.v1 AS v1
 , CAST(NULL AS INTEGER) AS v2
 FROM
  aggm1 a
UNION ALL
 SELECT
   a.k1 AS k1
 , CAST(NULL AS INTEGER) AS v1
 , a.v2 AS v2
 FROM
  aggm2 a
)
SELECT
  t.k1 AS grade
, max(t.v1) AS empcount
, max(t.v2) AS gradecount
FROM
 aggu t
GROUP BY
  t.k1
ORDER BY
  t.k1 ASC