package ai.koryki.scott.duckdb;

import java.io.IOException;
import java.io.InputStream;
import java.nio.charset.StandardCharsets;
import java.nio.file.Files;
import java.nio.file.Path;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;
import java.sql.Statement;

/**
 * Builds the SCOTT DuckDB database by running Apache Ossie's {@code scott.sql}, unchanged. The file
 * is not called scott.duckdb: DuckDB names the catalog after the file, and a catalog "scott" next
 * to the schema "scott" makes every reference ambiguous.
 */
public final class BuildDatabase {

    private BuildDatabase() {}

    /** {@code <database file>} */
    public static void main(String[] args) throws IOException, SQLException {
        if (args.length != 1) {
            throw new IllegalArgumentException("usage: BuildDatabase <database file>");
        }
        build(Path.of(args[0]));
    }

    public static void build(Path database) throws IOException, SQLException {
        Files.deleteIfExists(database);
        Files.deleteIfExists(Path.of(database + ".wal"));
        Files.createDirectories(database.toAbsolutePath().getParent());

        String script;
        try (InputStream in = BuildDatabase.class.getResourceAsStream("/scott.sql")) {
            script = new String(in.readAllBytes(), StandardCharsets.UTF_8);
        }
        try (Connection connection =
                        DriverManager.getConnection("jdbc:duckdb:" + database.toAbsolutePath());
                Statement statement = connection.createStatement()) {
            // DuckDB runs a script of several statements in one call.
            statement.execute(script);
            statement.execute("CHECKPOINT");
        }
    }
}
