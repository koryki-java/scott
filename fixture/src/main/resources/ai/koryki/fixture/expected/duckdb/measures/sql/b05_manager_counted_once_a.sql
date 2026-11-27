WITH aggd1 (i1, k1, c1) AS (
SELECT
  DISTINCT e.empno AS i1
, p.species AS k1
, e.sal AS c1
FROM
 scott.emp e
  INNER JOIN scott.pet p ON
   e.empno = p.empno
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
, aggd2 (i1, k1, c1) AS (
SELECT
  DISTINCT p.pname AS i1
, p.species AS k1
, p.age AS c1
FROM
 scott.emp e
  INNER JOIN scott.pet p ON
   e.empno = p.empno
)
, aggm2 (k1, v3, v4) AS (
SELECT
  x.k1 AS k1
, COUNT(*) AS v3
, sum(x.c1) AS v4
FROM
 aggd2 x
GROUP BY
  x.k1
)
, aggu (k1, v1, v2, v3, v4) AS (
 SELECT
   a.k1 AS k1
 , a.v1 AS v1
 , a.v2 AS v2
 , CAST(NULL AS INTEGER) AS v3
 , CAST(NULL AS INTEGER) AS v4
 FROM
  aggm1 a
UNION ALL
 SELECT
   a.k1 AS k1
 , CAST(NULL AS INTEGER) AS v1
 , CAST(NULL AS DECIMAL(18, 4)) AS v2
 , a.v3 AS v3
 , a.v4 AS v4
 FROM
  aggm2 a
)
SELECT
  t.k1 AS species
, max(t.v1) AS owners
, max(t.v2) AS ownerssal
, max(t.v3) AS pets
, max(t.v4) AS sumage
FROM
 aggu t
GROUP BY
  t.k1
ORDER BY
  t.k1 ASC