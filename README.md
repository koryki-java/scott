# scott

The SCOTT sample schema (`dept`, `emp`, `salgrade`) as a koryki catalog on DuckDB, and the measures corpus that
checks koryki's `agg()` rewrite against the query compliance cases of [Apache Ossie](https://github.com/apache/ossie).

| Module | |
|---|---|
| `duckdb` | `scottdb.duckdb`, built from Ossie's `scott.sql` by `./gradlew :duckdb:updateDatabase` |
| `catalog` | `db.json`, `model/en/model.json`, `measures.json` |
| `fixture` | the corpus: queries named after the Ossie cases, goldens, and the status against Ossie's suite |

The database file is not called `scott.duckdb`: DuckDB names the catalog after the file, and a catalog `scott` next to
the schema `scott` makes every reference ambiguous. The catalog sets `schemaPrefix` to `scott`.

Licence: Apache License 2.0. The data is Ossie's, see [NOTICE](NOTICE).
