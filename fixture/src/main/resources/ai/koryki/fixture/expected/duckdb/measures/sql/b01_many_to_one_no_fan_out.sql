SELECT
  d.dname AS dname
, sum(e.sal) AS sumsal
, COUNT(*) AS empcount
FROM
 scott.emp e
  INNER JOIN scott.dept d ON
   e.deptno = d.deptno
GROUP BY
  d.dname
ORDER BY
  d.dname ASC