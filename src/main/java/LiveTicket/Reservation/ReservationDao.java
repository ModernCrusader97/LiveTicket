package LiveTicket.Reservation;

import java.sql.Connection;
import java.util.ArrayList;
import java.util.List;
import java.util.Map;

import LiveTicket.DBUtil;
import LiveTicket.SecSql;
import LiveTicket.DTO.Seat;

public class ReservationDao {
    private Connection conn;

    public ReservationDao(Connection conn) {
        this.conn = conn;
    }

    public List<Seat> getAllSeats(long concertId) {
        SecSql sql = SecSql.from("SELECT S.*, SG.grade_name, SG.price");
        sql.append("FROM `seat` AS S");
        sql.append("INNER JOIN `seat_grade` AS SG ON S.grade_id = SG.id");
        sql.append("WHERE S.concert_id = ?", concertId);
        sql.append("ORDER BY SG.price DESC, S.row_name ASC, S.col_number ASC");

        List<Map<String, Object>> rows = DBUtil.selectRows(conn, sql);
        List<Seat> seats = new ArrayList<>();
        
        for (Map<String, Object> row : rows) {
            seats.add(new Seat(row));
        }
        return seats;
    }

    public void releaseExpiredSeats() {
        SecSql sql = SecSql.from("UPDATE `seat`");
        sql.append("SET `status` = 'AVAILABLE',");
        sql.append("`version` = `version` + 1,");
        sql.append("`held_at` = NULL");
        sql.append("WHERE `status` = 'PENDING' AND `held_at` < DATE_SUB(NOW(), INTERVAL 5 MINUTE)");

        DBUtil.update(conn, sql);
    }

    public int updateSeatToPending(long seatId, int currentVersion) {
        SecSql sql = SecSql.from("UPDATE `seat`");
        sql.append("SET `status` = 'PENDING',");
        sql.append("`version` = `version` + 1,");
        sql.append("`held_at` = NOW()");
        sql.append("WHERE id = ? AND `status` = 'AVAILABLE' AND `version` = ?", seatId, currentVersion);

        return DBUtil.update(conn, sql);
    }
}