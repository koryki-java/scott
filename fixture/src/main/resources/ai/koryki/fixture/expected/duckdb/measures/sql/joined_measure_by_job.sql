WITH aggd1 (i1, k1, c1, c2) AS (
SELECT
  DISTINCT e.empno AS i1
, e.job AS k1
, e.sal AS c1
, aggj1_1.loc AS c2
FROM
 scott.emp e
  LEFT OUTER JOIN scott.pet p ON
   e.empno = p.empno
  LEFT OUTER JOIN scott.dept aggj1_1 ON
   e.deptno = aggj1_1.deptno
)
, aggm1 (k1, v1) AS (
SELECT
  x.k1 AS k1
, sum(CASE WHEN x.c2 = 'DALLAS' THEN x.c1 END) AS v1
FROM
 aggd1 x
GROUP BY
  x.k1
)
SELECT
  t.k1 AS job
, max(t.v1) AS dallas_sal
FROM
 aggm1 t
GROUP BY
  t.k1