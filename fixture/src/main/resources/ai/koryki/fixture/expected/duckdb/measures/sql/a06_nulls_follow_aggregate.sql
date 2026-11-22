SELECT
  e.deptno AS deptno
, COUNT(*) AS empcount
, count(e.comm) AS commcount
, sum(e.comm) AS sumcomm
, avg(CAST(e.comm AS DOUBLE)) AS avgcomm
FROM
 scott.emp e
GROUP BY
  e.deptno
ORDER BY
  e.deptno ASC