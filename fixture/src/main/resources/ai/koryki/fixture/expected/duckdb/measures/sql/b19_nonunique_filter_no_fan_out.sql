SELECT
  e.job AS job
, sum(e.sal) AS sumsal
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
GROUP BY
  e.job
ORDER BY
  e.job ASC