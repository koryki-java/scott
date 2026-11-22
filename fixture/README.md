# fixture

The test corpus for the **measures** of the SCOTT catalog, in the layout of the corpus of
[koryki-java/northwind](https://github.com/koryki-java/northwind) (read its `SPEC.md`; the schema `measures` is
described there). Only that schema exists here.

The queries are named after the cases of the query compliance suite of Apache Ossie
(`compliance/query/cases/<case>`), whose data is the SCOTT schema. Each `.kql` is a hand translation of the
`query.ossie.sql` of its case; the measures are `catalog/.../databases/scott/measures.json`, a translation of the
dataset-scoped metrics of `scott_model.ossie.yaml`.

```
queries/kql/measures/<case>.kql                  a query with agg()
expected/kql/measures/rewrite/<case>.kql         the plain KQL the rewriter returns
expected/kql/measures/provenance/<case>.txt      output column : table.measure
expected/kql/measures/csv/<case>.csv, .json      result and column types, on DuckDB
expected/duckdb/measures/sql/<case>.sql          the SQL on DuckDB
```

The goldens are written and checked by `ai.koryki.measure.generator.scott.AggRewriterFixturesTest` of
[koryki-java/measures](https://github.com/koryki-java/measures) (`./gradlew scottTest`; `-Dfixtures.write=true` writes
them). The same task runs `OssieCasesTest`, which compares the rows with the `expected.sql` of each case in a checkout of
apache/ossie (`-Dossie.root=...`, evaluated on DuckDB) and writes `build/ossie-status.md`.
`./gradlew :fixture:test` here checks the corpus alone.

## Status against Ossie's suite

28 of its 32 cases are translated, and the rows of all 28 equal Ossie's `expected.sql` (numbers compared at two
decimals, the precision of the CSV golden; rows as a multiset, the ORDER BY is in the SQL golden).

| Case | Result |
|---|---|
| a01-a12 | equal. a11 is `agg` in a scalar sub-query, a12 an outer aggregate over `agg` values and a `UNIONALL`, b03 a block with sort and limit used as `IN` filter. a09 is ROLLUP, one evaluation per grouping set (total row 2073.21, not the average of averages). a08 groups by `year(hiredate)`. a10 is the CTE's `WHERE` as a `FILTER`: what a CTE passing measures through means is not tested |
| b01, b02, b04, b05, b08, b09, b14, b18, b20 | equal (inner joins, self joins, one side counted once, ratio, HAVING) |
| b10, b11, b15, b17 | equal: LEFT JOINs with the NULL-padded rows adding nothing, a RIGHT JOIN as a LEFT JOIN with the sides swapped (`m [empno = mgr] + emp e`), an empty group with 0 and NULLs |
| b16 | equal: a `FILTER` on an optionally linked alias is rendered in the ON clause of the LEFT JOIN by core, so the departments stay |
| b19 | equal, as a semi join: `EXISTS (e VIA same_department dept x, x [deptno = deptno] emp s FILTER ...)` |

### The 4 that are open, and why

| Case | What it needs | Where the gap is |
|---|---|---|
| b12 (FULL JOIN), b13 (CROSS JOIN) | KQL has no FULL or CROSS join; two sources without a link get an inferred join | KQL, not the rewriter |
| b06, b07 (range join) | `e.sal BETWEEN s.losal AND s.hisal`: a link is an equality of columns, so `salgrade` cannot be joined | KQL / the catalog |

What equal means, and does not: koryki's KQL, rewritten by the measures project, gives the rows Ossie's reference SQL
gives, on the same data. It is not that Ossie's SQL is accepted: the cases are rewritten into KQL by hand, and the
measures are written by hand until a converter exists.
