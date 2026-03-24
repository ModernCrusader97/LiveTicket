package LiveTicket.Concert;

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


public class ConcertService {
	private Connection conn;
	
	
	public ConcertService(Connection conn) {
        this.conn = conn;
    }
	public List<Map<String, Object>> getMyReservations(int memberId) {

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

}
