package LiveTicket.Reservation;

import java.io.IOException;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;
import java.util.List;
import java.util.Map;

import LiveTicket.SecSql;
import LiveTicket.DTO.Seat;
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

	public void showSeatMap() throws ServletException, IOException {
		if (isLogined() == false){
            response.getWriter().append("<script>alert('로그인이 필요한 서비스입니다.'); location.replace('../member/login');</script>");
            return;
        }
		
	    String concertIdParam = request.getParameter("concertId");
	    if (concertIdParam == null || concertIdParam.isEmpty()) {
	        response.getWriter().append("<script>alert('잘못된 접근입니다.'); history.back();</script>");
	        return;
	    }

	    long concertId = Long.parseLong(concertIdParam);
	    
	    reservationService.releaseExpiredSeats();
	    List<Seat> seats = reservationService.getAllSeats(concertId);
	    
	    request.setAttribute("seats", seats);
	    request.setAttribute("concertId", concertId);
	    
	    request.getRequestDispatcher("/jsp/reservation/seatMap.jsp").forward(request, response);
	}

	public void doHold() throws ServletException, IOException {
	    if (request.getAttribute("isLogined") != null && !(boolean)request.getAttribute("isLogined")) {
	        response.getWriter().append("<script>alert('로그인이 필요한 서비스입니다.'); location.replace('../member/login');</script>");
	        return;
	    }

	    long seatId = Long.parseLong(request.getParameter("seatId"));
	    int version = Integer.parseInt(request.getParameter("version"));

	    boolean isHeld = reservationService.holdSeat(seatId, version);

	    if (isHeld) {
	        response.sendRedirect("../reservation/payment?seatId=" + seatId);
	    } else {
	        response.getWriter().append("<script>alert('이미 선택된 좌석입니다. 다른 좌석을 골라주세요.'); history.back();</script>");
	    }
	}

}
