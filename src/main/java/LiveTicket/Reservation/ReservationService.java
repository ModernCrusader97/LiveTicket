package LiveTicket.Reservation;

import java.io.IOException;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;
import java.util.List;
import java.util.Map;

import LiveTicket.SecSql;
import LiveTicket.DBUtil;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;


public class ReservationService {
	private Connection conn;
	
	
	public ReservationService(Connection conn) {
        this.conn = conn;
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
	
	public List<Map<String, Object>> getAllSeats(long concertId) {
        SecSql sql = SecSql.from("SELECT S.*, SG.grade_name, SG.price");
        sql.append("FROM `seat` AS S");
        sql.append("INNER JOIN `seat_grade` AS SG ON S.grade_id = SG.id");
        sql.append("WHERE S.concert_id = ?", concertId);
        sql.append("ORDER BY SG.price DESC, S.row_name ASC, S.col_number ASC");

        return DBUtil.selectRows(conn, sql);
    }
	
    public boolean holdSeat(long seatId, int currentVersion) {
        SecSql sql = SecSql.from("UPDATE `seat`");
        sql.append("SET `status` = 'PENDING',");
        sql.append("`version` = `version` + 1,");
        sql.append("`held_at` = NOW()");
        sql.append("WHERE id = ? AND `status` = 'AVAILABLE' AND `version` = ?", seatId, currentVersion);

        int affectedRows = DBUtil.update(conn, sql);
        return affectedRows > 0;
    }
    
    public void releaseExpiredSeats() {
        SecSql sql = SecSql.from("UPDATE `seat`");
        sql.append("SET `status` = 'AVAILABLE',");
        sql.append("`version` = `version` + 1,");
        sql.append("`held_at` = NULL"); 
        sql.append("WHERE `status` = 'PENDING' AND `held_at` < DATE_SUB(NOW(), INTERVAL 5 MINUTE)");
        
        DBUtil.update(conn, sql);
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
