WITH aggd1 (i1) AS (
SELECT
  DISTINCT d.deptno AS i1
FROM
 scott.dept d
  INNER JOIN scott.emp e ON
   d.deptno = e.deptno
)
, aggm1 (v1) AS (
SELECT
  COUNT(*) AS v1
FROM
 aggd1 x
)
, aggd2 (i1, c1) AS (
SELECT
  DISTINCT e.empno AS i1
, e.sal AS c1
FROM
 scott.dept d
  INNER JOIN scott.emp e ON
   d.deptno = e.deptno
)
, aggm2 (v2, v3) AS (
SELECT
  COUNT(*) AS v2
, sum(x.c1) AS v3
FROM
 aggd2 x
)
, aggu (v1, v2, v3) AS (
 SELECT
   a.v1 AS v1
 , CAST(NULL AS INTEGER) AS v2
 , CAST(NULL AS DECIMAL(18, 4)) AS v3
 FROM
  aggm1 a
UNION ALL
 SELECT
   CAST(NULL AS INTEGER) AS v1
 , a.v2 AS v2
 , a.v3 AS v3
 FROM
  aggm2 a
)
SELECT
  max(t.v1) AS deptcount
, max(t.v2) AS empcount
, max(t.v3) AS sumsal
, CAST(max(t.v3) AS DOUBLE) / NULLIF(max(t.v1), 0) AS salperdept
FROM
 aggu t