SELECT
  e.deptno AS deptno
, sum(e.sal) + sum(e.comm) AS totalpay
FROM
 scott.emp e
GROUP BY
  e.deptno
ORDER BY
  e.deptno ASC