SELECT
  year(e.hiredate) AS hireyear
, COUNT(*) AS empcount
, sum(e.sal) AS sumsal
FROM
 scott.emp e
GROUP BY
  year(e.hiredate)
ORDER BY
  year(e.hiredate) ASC