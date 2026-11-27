WITH aggd1 (i1, c1) AS (
SELECT
  DISTINCT e.empno AS i1
, e.sal AS c1
FROM
 scott.pet p
  LEFT OUTER JOIN scott.emp e ON
   p.empno = e.empno
)
, aggm1 (v1, v2) AS (
SELECT
  count(x.i1) AS v1
, sum(x.c1) AS v2
FROM
 aggd1 x
)
, aggd2 (i1, c1) AS (
SELECT
  DISTINCT p.pname AS i1
, p.age AS c1
FROM
 scott.pet p
  LEFT OUTER JOIN scott.emp e ON
   p.empno = e.empno
)
, aggm2 (v3, v4) AS (
SELECT
  count(x.i1) AS v3
, sum(x.c1) AS v4
FROM
 aggd2 x
)
, aggu (v1, v2, v3, v4) AS (
 SELECT
   a.v1 AS v1
 , a.v2 AS v2
 , CAST(NULL AS INTEGER) AS v3
 , CAST(NULL AS INTEGER) AS v4
 FROM
  aggm1 a
UNION ALL
 SELECT
   CAST(NULL AS INTEGER) AS v1
 , CAST(NULL AS DECIMAL(18, 4)) AS v2
 , a.v3 AS v3
 , a.v4 AS v4
 FROM
  aggm2 a
)
SELECT
  max(t.v1) AS ecount
, max(t.v2) AS esal
, max(t.v3) AS pcount
, max(t.v4) AS page
FROM
 aggu t