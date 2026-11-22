WITH aggd1 (i1, c1) AS (
SELECT
  DISTINCT e.empno AS i1
, e.sal AS c1
FROM
 scott.emp e
)
, aggm1 (v1, v2) AS (
SELECT
  sum(x.c1) AS v1
, COUNT(*) AS v2
FROM
 aggd1 x
)
SELECT
  max(t.v1) AS sumsal
, max(t.v2) AS empcount
FROM
 aggm1 t