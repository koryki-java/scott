SELECT
  COUNT(*) AS empcount
, sum(e.sal) AS sumsal
, avg(CAST(e.sal AS DOUBLE)) AS avgsal
FROM
 scott.emp e
WHERE
  e.deptno = 40