package LiveTicket.Reservation;

import java.sql.Connection;
import java.util.List;
import java.util.Map;

import LiveTicket.SecSql;
import LiveTicket.DTO.Seat;
import LiveTicket.DBUtil;
import LiveTicket.DTO.Seat;


public class ReservationService {
	private Connection conn;
	private ReservationDao reservationDao;
	
	public ReservationService(Connection conn) {
        this.conn = conn;
        this.reservationDao = new ReservationDao(conn);
    }
	
	public List<Seat> getAllSeats(long concertId) {
        return reservationDao.getAllSeats(concertId);
    }

    public void releaseExpiredSeats() {
        reservationDao.releaseExpiredSeats();
    }

    public boolean holdSeat(long seatId, int currentVersion) {
        int affectedRows = reservationDao.updateSeatToPending(seatId, currentVersion);
        return affectedRows > 0;
    }
    
	public List<Map<String, Object>> getMyReservations(long memberId) {

		SecSql sql = SecSql.from("SELECT R.*, S.`row_name` AS row_name, S.`col_number` AS `col_number`, "
				+ "SG.grade_name AS grade_name, "
				+ "C.title AS title, C.start_at AS start_at");
    	sql.append("FROM `reservation` AS R");
    	sql.append("INNER JOIN `seat` AS S");
    	sql.append("ON R.`seat_id` = S.id");
    	sql.append("INNER JOIN `seat_grade` AS SG");
    	sql.append("ON S.`grade_id` = SG.id");
    	sql.append("INNER JOIN `concert` AS C");
    	sql.append("ON S.`concert_id` = C.id");
    	sql.append("WHERE R.`member_id` = ?", memberId);
    	
    	return DBUtil.selectRows(conn, sql);
	}
    
	public boolean confirmReservation(long memberId, long seatId) {
        try {
            conn.setAutoCommit(false);

            SecSql updateSql = SecSql.from("UPDATE `seat`");
            updateSql.append("SET `status` = 'RESERVED'");
            updateSql.append("WHERE id = ? AND `status` = 'PENDING'", seatId);
            
            int affectedRows = DBUtil.update(conn, updateSql);
            
            if (affectedRows == 0) {
                conn.rollback(); 
                return false; 
            }

            SecSql insertSql = SecSql.from("INSERT INTO `reservation`");
            insertSql.append("SET member_id = ?,", memberId);
            insertSql.append("seat_id = ?,", seatId);
            insertSql.append("created_at = NOW()");
            
            DBUtil.insert(conn, insertSql);

            conn.commit(); 
            return true;

        } catch (Exception e) {
            try {
                if (conn != null) conn.rollback(); 
            } catch (Exception ex) {
                System.out.println("Rollback error: " + ex.getMessage());
            }
            e.printStackTrace();
            return false;
        } finally {
            try {
                if (conn != null) conn.setAutoCommit(true); 
            } catch (Exception e) {
                System.out.println("AutoCommit reset error: " + e.getMessage());
            }
        }
    }
	
	public Map<String, Object> getSeatInfo(long seatId) {
        SecSql sql = SecSql.from("SELECT S.*, SG.grade_name, SG.price, C.title AS concert_title");
        sql.append("FROM `seat` AS S");
        sql.append("INNER JOIN `seat_grade` AS SG ON S.grade_id = SG.id");
        sql.append("INNER JOIN `concert` AS C ON S.concert_id = C.id");
        sql.append("WHERE S.id = ?", seatId);
        
        return DBUtil.selectRow(conn, sql);
    }
}
