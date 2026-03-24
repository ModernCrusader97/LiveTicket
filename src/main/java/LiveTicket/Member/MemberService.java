package LiveTicket.Member;

import java.sql.Connection;
import java.util.Map;

import LiveTicket.SecSql;
import LiveTicket.DBUtil;

public class MemberService {
	private Connection conn;
	
	
	public MemberService(Connection conn) {
        this.conn = conn;
    }
	public Map<String, Object> getMemberByLoginId(String loginId) {
        SecSql sql = SecSql.from("SELECT *");
        sql.append(" FROM `member`");
        sql.append(" WHERE login_id = ?", loginId);
        
        return DBUtil.selectRow(conn, sql);
    }
	
	public boolean isUsedLoginId(String loginId) {
        SecSql sql = SecSql.from("SELECT COUNT(*)");
        sql.append(" FROM `member`");
        sql.append(" WHERE login_id = ?", loginId); 
        
        int count = DBUtil.selectRowIntValue(conn, sql);
        return count > 0;
    }
	
	public int doJoin(String loginId, String password, String name) {
        SecSql sql = SecSql.from("INSERT INTO `member`");
        sql.append(" SET login_id = ?,", loginId);
        sql.append(" `password` = ?,", password); 
        sql.append(" `name` = ?", name);


        return DBUtil.insert(conn, sql);
    }
}
