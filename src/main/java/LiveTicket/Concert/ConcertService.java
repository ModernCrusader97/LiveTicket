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
	
	public List<Map<String, Object>> getConcerts() {
        SecSql sql = SecSql.from("SELECT * FROM concert");
        sql.append(" ORDER BY start_at ASC"); // 날짜순 정렬
        
        return DBUtil.selectRows(conn, sql);
    }
	
	public Map<String, Object> getConcertById(long id) {
        SecSql sql = SecSql.from("SELECT * FROM concert");
        sql.append(" WHERE id = ?", id);
        
        return DBUtil.selectRow(conn, sql);
    }
	
	public List<Map<String, Object>> getRemainingSeats(long concertId) {
        SecSql sql = SecSql.from("SELECT SG.grade_name, SG.price, COUNT(S.id) AS remain_count");
        sql.append(" FROM seat_grade AS SG");
        sql.append(" LEFT JOIN seat AS S");
        sql.append(" ON SG.id = S.grade_id AND S.`status` = 'AVAILABLE'"); 
        sql.append(" WHERE SG.concert_id = ?", concertId);
        sql.append(" GROUP BY SG.id");
        
        return DBUtil.selectRows(conn, sql);
    }
	
}
