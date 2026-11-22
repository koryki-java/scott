WITH aggd1 (i1, k1) AS (
SELECT
  DISTINCT e.empno AS i1
, e.job AS k1
FROM
 scott.emp e
  INNER JOIN scott.emp m ON
   e.mgr = m.empno
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
, aggd2 (i1, k1, c1) AS (
SELECT
  DISTINCT m.empno AS i1
, e.job AS k1
, m.sal AS c1
FROM
 scott.emp e
  INNER JOIN scott.emp m ON
   e.mgr = m.empno
)
, aggm2 (k1, v2, v3) AS (
SELECT
  x.k1 AS k1
, COUNT(*) AS v2
, sum(x.c1) AS v3
FROM
 aggd2 x
GROUP BY
  x.k1
)
, aggu (k1, v1, v2, v3) AS (
 SELECT
   a.k1 AS k1
 , a.v1 AS v1
 , CAST(NULL AS INTEGER) AS v2
 , CAST(NULL AS DECIMAL(18, 4)) AS v3
 FROM
  aggm1 a
UNION ALL
 SELECT
   a.k1 AS k1
 , CAST(NULL AS INTEGER) AS v1
 , a.v2 AS v2
 , a.v3 AS v3
 FROM
  aggm2 a
)
SELECT
  t.k1 AS job
, max(t.v1) AS empcount
, max(t.v2) AS managers
, max(t.v3) AS managerssal
FROM
 aggu t
GROUP BY
  t.k1
ORDER BY
  t.k1 ASC