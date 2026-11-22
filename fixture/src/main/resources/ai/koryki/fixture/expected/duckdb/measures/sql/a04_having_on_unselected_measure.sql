SELECT
  e.job AS job
, sum(e.sal) AS sumsal
FROM
 scott.emp e
GROUP BY
  e.job
HAVING
  COUNT(*) > 2
ORDER BY
  sum(e.sal) DESC
FETCH FIRST 3 ROWS ONLY