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


public class ReservationController {
private HttpServletRequest request;
private HttpServletResponse response;
private Connection conn;
private ReservationService reservationService;

private boolean isLogined() throws IOException {
    HttpSession session = request.getSession();
    if (session.getAttribute("loginedMemberId") == null) {
        
        response.getWriter().append("<script>alert('로그인 후 이용해주세요.'); location.replace('../member/login');</script>");
        return false;
    }
    return true;
}

private long getLoginedMemberId() {
    return ((Number) request.getSession().getAttribute("loginedMemberId")).longValue();
}


public ReservationController(HttpServletRequest request, HttpServletResponse response, Connection conn) {
	this.request = request;
	this.response = response;
	this.conn = conn;
	this.reservationService = new ReservationService(conn);
}


public void showMyList() throws ServletException, IOException
{
	
	  if (!isLogined()) return;
	  
	  long loginedMemberId = getLoginedMemberId();

    
    List<Map<String, Object>> myReservations = reservationService.getMyReservations(loginedMemberId);
    
	request.setAttribute("myReservations", myReservations);
	
	request.getRequestDispatcher("/jsp/reservation/mylist.jsp").forward(request, response);
}

}
