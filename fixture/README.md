# fixture

The test corpus for the **measures** of the SCOTT catalog, in the layout of the corpus of
[koryki-java/northwind](https://github.com/koryki-java/northwind) (read its `SPEC.md`; the schema `measures` is
described there). Only that schema exists here.

The queries are named after the cases of the query compliance suite of Apache Ossie
(`compliance/query/<case>.ost`), whose data is the SCOTT schema. Each `.kql` is a hand translation of an
`executeExpand` query of its script. A script with more than one is translated in order: the first query is `<case>`,
the second `<case>_a`, the third `<case>_b`, as Ossie labels them (B8, B8a, B8b). The measures are `catalog/.../databases/scott/measures.json`, a translation of the
dataset-scoped metrics of `scott_model.ossie.yaml`.

```
queries/kql/measures/<case>[_a|_b].kql           a query with agg()
expected/kql/measures/rewrite/<query>.kql        the plain KQL the rewriter returns
expected/kql/measures/provenance/<query>.txt     output column : table.measure
expected/kql/measures/csv/<query>.csv, .json     result and column types, on DuckDB
expected/duckdb/measures/sql/<query>.sql         the SQL on DuckDB
```

The goldens are written and checked by `ai.koryki.measure.generator.scott.AggRewriterFixturesTest` of
[koryki-java/measures](https://github.com/koryki-java/measures) (`./gradlew scottTest`; `-Dfixtures.write=true` writes
them). The same task runs `OssieCasesTest`, which compares the rows with the expected table of each query in the `.ost`
scripts of a checkout of apache/ossie (`-Dossie.root=...`; no database is needed, the tables are in the scripts) and writes
`build/ossie-status.md`. A query of Ossie's suite with no translation fails the test, and so does a translation of a query
the script lacks.
`./gradlew :fixture:test` here checks the corpus alone.

## Status against Ossie's suite

All 32 of its cases are translated, with the 8 further queries that b05, b08 and b09 to b13 hold since the scripts
replaced the old cases (Ossie 2026-11-21): 40 queries, and the rows of all 40 equal the expected tables of the `.ost`
scripts (numbers compared at two decimals, the precision of the CSV golden; rows as a multiset). The further queries
read `pet` and `bonus`, which the SCOTT data of Ossie has had since then.

| Case | Result |
|---|---|
| a01-a12 | equal. a11 is `agg` in a scalar sub-query, a12 an outer aggregate over `agg` values and a `UNIONALL`, b03 a block with sort and limit used as `IN` filter. a09 is ROLLUP, one evaluation per grouping set (total row 2073.21, not the average of averages). a08 groups by `year(hiredate)`. a10 is the CTE's `WHERE` as a `FILTER`: what a CTE passing measures through means is not tested |
| b01, b02, b04, b05, b08, b09, b14, b18, b20 | equal (inner joins, self joins, one side counted once, ratio, HAVING) |
| derived_ratio_across_relations | equal to b14's ratio: `emp.sal_per_dept`, a stored `agg(emp.sum_sal) / agg(dept.dept_count)` (not in Ossie's suite) |
| joined_measure_by_job | `emp.sum_sal_dallas` reads `dept.loc` through a join the measure declares, in a query that fans out through pets: each salary counted once (not in Ossie's suite) |
| b05a, b08a, b08b, b09a-b13a | equal: the owner of a pet (`same_owner`), the pets of a manager (`e [mgr = empno] pet p`), and the chasm trap of `bonus` and `pet`, both on the many side of `emp` (`bonus b, b VIA same_employee emp e, e VIA same_owner + pet p`); b09a to b13a are the five join types again, now on `emp` and `pet` |
| b10, b11, b15, b17 | equal: LEFT JOINs with the NULL-padded rows adding nothing, a RIGHT JOIN as a LEFT JOIN with the sides swapped (`m [empno = mgr] + emp e`), an empty group with 0 and NULLs |
| b16 | equal: a `FILTER` on an optionally linked alias is rendered in the ON clause of the LEFT JOIN by core, so the departments stay |
| b19 | equal, as a semi join: `EXISTS (e VIA same_department dept x, x [deptno = deptno] emp s FILTER ...)` |
| b06, b07 | equal: the range join is a relationship of the catalog (`fk_emp_salgrade`, `condition: start.sal BETWEEN end.losal AND end.hisal`, link `same_grade`), so the query is `e VIA same_grade salgrade s` |
| b12, b13 | equal: `e VIA same_manager FULL emp m` and `e CROSS emp m`. A FULL join pads both sides, so the rewriter writes `count()` as `count(x.i1)` as for `+` |

What equal means, and does not: koryki's KQL, rewritten by the measures project, gives the rows Ossie's reference SQL
gives, on the same data. It is not that Ossie's SQL is accepted: the cases are rewritten into KQL by hand, and the
measures are written by hand until a converter exists.
