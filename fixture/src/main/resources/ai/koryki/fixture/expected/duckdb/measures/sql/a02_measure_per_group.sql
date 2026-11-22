SELECT
  e.deptno AS deptno
, sum(e.sal) AS sumsal
, COUNT(*) AS empcount
FROM
 scott.emp e
GROUP BY
  e.deptno
ORDER BY
  e.deptno ASC