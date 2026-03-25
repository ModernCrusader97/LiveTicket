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


public class ConcertController {
private HttpServletRequest request;
private HttpServletResponse response;
private Connection conn;
private ConcertService  concertService;

private boolean isLogined() throws IOException {
    HttpSession session = request.getSession();
    if (session.getAttribute("loginedMemberId") == null) {
        
        response.getWriter().append("<script>alert('로그인 후 이용해주세요.'); location.replace('../member/login');</script>");
        return false;
    }
    return true;
}

private long getLoginedMemberId() {
	return (long) request.getSession().getAttribute("loginedMemberId");
}


public ConcertController(HttpServletRequest request, HttpServletResponse response, Connection conn) {
	this.request = request;
	this.response = response;
	this.conn = conn;
	this.concertService = new ConcertService(conn);
}


public void showList() throws ServletException, IOException
{
	List<Map<String, Object>> concerts = concertService.getConcerts();
    
    request.setAttribute("concerts", concerts);
    request.getRequestDispatcher("/jsp/concert/list.jsp").forward(request, response);

}


public void showDetail() throws ServletException, IOException {
    String idParam = request.getParameter("id");
    if (idParam == null || idParam.isEmpty()) {
        response.getWriter().append("<script>alert('잘못된 접근입니다.'); history.back();</script>");
        return;
    }
    
    long concertId = Long.parseLong(idParam);
    
    Map<String, Object> concert = concertService.getConcertById(concertId);
    List<Map<String, Object>> remainSeats = concertService.getRemainingSeats(concertId);
    
    request.setAttribute("concert", concert);
    request.setAttribute("remainSeats", remainSeats);
    
    request.getRequestDispatcher("/jsp/concert/detail.jsp").forward(request, response);
}
}
