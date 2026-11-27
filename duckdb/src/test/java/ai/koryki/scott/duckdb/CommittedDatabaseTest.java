package ai.koryki.scottdb.duckdb;

import static org.junit.jupiter.api.Assertions.assertEquals;

import java.nio.file.Path;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.ResultSet;
import java.sql.Statement;
import java.util.Properties;
import org.junit.jupiter.api.Test;

/** The committed scottdb.duckdb holds the three SCOTT tables with Ossie's rows. */
class CommittedDatabaseTest {

    private static final Path DATABASE =
            Path.of("src/main/resources/ai/koryki/duckdb/databases/scott/scottdb.duckdb");

    @Test
    void tablesHaveTheRowsOfScott() throws Exception {
        Properties readOnly = new Properties();
        readOnly.setProperty("duckdb.read_only", "true");
        try (Connection c =
                        DriverManager.getConnection(
                                "jdbc:duckdb:" + DATABASE.toAbsolutePath(), readOnly);
                Statement s = c.createStatement()) {
            assertEquals(4, count(s, "scott.dept"));
            assertEquals(14, count(s, "scott.emp"));
            assertEquals(5, count(s, "scott.salgrade"));
            assertEquals(3, count(s, "scott.bonus"));
            assertEquals(8, count(s, "scott.pet"));
            try (ResultSet rs = s.executeQuery("SELECT sum(sal), count(comm) FROM scott.emp")) {
                rs.next();
                assertEquals("29025.00", rs.getBigDecimal(1).toPlainString());
                assertEquals(4, rs.getInt(2));
            }
        }
    }

    private static long count(Statement s, String table) throws Exception {
        try (ResultSet rs = s.executeQuery("SELECT count(*) FROM " + table)) {
            rs.next();
            return rs.getLong(1);
        }
    }
}
