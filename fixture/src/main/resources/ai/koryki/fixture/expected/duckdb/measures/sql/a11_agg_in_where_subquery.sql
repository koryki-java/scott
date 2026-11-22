SELECT
  e.deptno AS deptno
, COUNT(*) AS empcount
FROM
 scott.emp e
WHERE
  e.sal > (
    SELECT
      avg(CAST(x.sal AS DOUBLE)) AS avg_sal
    FROM
     scott.emp x
   )
GROUP BY
  e.deptno
ORDER BY
  e.deptno ASC