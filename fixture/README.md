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

16 of its 32 cases are translated, and the rows of all 16 equal Ossie's `expected.sql` (numbers compared at two
decimals, the precision of the CSV golden; rows as a multiset, the ORDER BY is in the SQL golden).

| Case | Result |
|---|---|
| a01-a07 (grand total, group, filter, HAVING on an unselected measure, scalar operations, NULLs, empty input) | equal |
| b01, b02, b04, b05, b08, b09, b14, b18, b20 (inner joins, self joins, one side counted once, ratio, HAVING) | equal |
| a08-a12, b03, b06, b07, b10-b13, b15-b17, b19 | not translated |

What equal means, and does not: koryki's KQL, rewritten by the measures project, gives the rows Ossie's
reference SQL gives, on the same data. It is not that Ossie's SQL is accepted: the cases are rewritten into KQL by
hand, and the measures are written by hand until a converter exists. The cases not translated use what the rewriter
refuses today (outer links, `WITH`, sub-queries, `ROLLUP`), a join that is not a relationship (`salgrade` by a range,
a cross join), or have not been looked at yet; none was tried and failed.
