SELECT
  e.deptno AS deptno
, CAST(sum(e.sal) AS DOUBLE) / NULLIF(COUNT(*), 0) AS salperemp
, avg(CAST(e.sal AS DOUBLE)) AS avgsal
, sum(e.sal) + coalesce(sum(e.comm), 0) AS totalpay
FROM
 scott.emp e
GROUP BY
  e.deptno
ORDER BY
  e.deptno ASC