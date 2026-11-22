WITH d (k, deptsal) AS (
SELECT
  e.deptno AS k
, sum(e.sal) AS deptsal
FROM
 scott.emp e
GROUP BY
  e.deptno
)
 SELECT
   'avg payroll per dept' AS metric
 , avg(CAST(x.deptsal AS DOUBLE)) AS amount
 FROM
  d x
 GROUP BY
   'avg payroll per dept'
UNION ALL
 SELECT
   'avg salary per emp' AS metric
 , avg(CAST(e.sal AS DOUBLE)) AS amount
 FROM
  scott.emp e
 GROUP BY
   'avg salary per emp'