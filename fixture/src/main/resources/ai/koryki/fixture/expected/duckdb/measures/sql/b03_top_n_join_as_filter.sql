WITH top (d, s) AS (
SELECT
  x.deptno AS d
, sum(x.sal) AS s
FROM
 scott.emp x
GROUP BY
  x.deptno
ORDER BY
  sum(x.sal) DESC
FETCH FIRST 2 ROWS ONLY
)
SELECT
  e.job AS job
, sum(e.sal) AS sumsal
FROM
 scott.emp e
WHERE
  e.deptno IN (
    SELECT
      t.d
    FROM
     top t
   )
GROUP BY
  e.job
ORDER BY
  e.job ASC