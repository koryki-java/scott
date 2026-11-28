SELECT
  e.deptno AS deptno
, sum(e.sal) AS payroll
, COUNT(*) AS headcount
FROM
 scott.emp e
WHERE
  e.job IN ('CLERK', 'SALESMAN')
GROUP BY
  e.deptno
ORDER BY
  e.deptno ASC
