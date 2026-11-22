WITH aggd1 (i1, k1, c1) AS (
SELECT
  DISTINCT e.empno AS i1
, e.job AS k1
, e.sal AS c1
FROM
 scott.emp e
WHERE
  
  EXISTS (
   SELECT
    1
  FROM
   scott.dept x
    INNER JOIN scott.emp s ON
     x.deptno = s.deptno
  WHERE
   e.deptno = x.deptno
  AND
    s.job = 'SALESMAN'
  )
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
SELECT
  t.k1 AS job
, max(t.v1) AS sumsal
FROM
 aggm1 t
GROUP BY
  t.k1
ORDER BY
  t.k1 ASC