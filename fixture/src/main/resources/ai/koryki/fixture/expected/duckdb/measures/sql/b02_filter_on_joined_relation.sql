SELECT
  e.job AS job
, sum(e.sal) AS sumsal
, COUNT(*) AS empcount
FROM
 scott.emp e
  INNER JOIN scott.dept d ON
   e.deptno = d.deptno
WHERE
  d.loc = 'NEW YORK'
GROUP BY
  e.job
ORDER BY
  e.job ASC