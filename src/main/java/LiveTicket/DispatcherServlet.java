package LiveTicket;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;

import LiveTicket.Concert.ConcertController;
import LiveTicket.Home.HomeController;
import LiveTicket.Member.MemberController;
import LiveTicket.Reservation.ReservationController;


@WebServlet("/s/*")
public class DispatcherServlet extends HttpServlet {
	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		request.setCharacterEncoding("UTF-8");
		response.setContentType("text/html;charset=UTF-8");	

		try {
			Class.forName("com.mysql.cj.jdbc.Driver");
		} catch (ClassNotFoundException e) {
			System.out.println("클래스 없음");
			e.printStackTrace();
		}
		
		String url = "jdbc:mysql://127.0.0.1:3306/liveticket?useUnicode=true&characterEncoding=utf8&autoReconnect=true&serverTimezone=Asia/Seoul";
		String user = "root";
		String password = "";

		Connection conn = null;
		try {
			conn = DriverManager.getConnection(url, user, password);
			HttpSession session = request.getSession();

			boolean isLogined = false;
			long loginedMemberId = -1;
			String loginedMemberName = null;
			if (session.getAttribute("loginedMemberId") != null) {
				isLogined = true;
				loginedMemberId = ((Number) session.getAttribute("loginedMemberId")).longValue();
				loginedMemberName = (String) session.getAttribute("loginedMemberName");
			}
			request.setAttribute("isLogined", isLogined);
			request.setAttribute("loginedMemberId", loginedMemberId);
			request.setAttribute("loginedMemberName", loginedMemberName);

			String requestUri = request.getRequestURI();

			String[] reqUriBits = requestUri.split("/");

			if (reqUriBits.length < 5) {

				String relativePath = "";
				
	
				if (reqUriBits.length == 3) {
					relativePath = "s/home/main";
				} 

				else {
					int depth = reqUriBits.length - 4;
					

					for (int i = 0; i < depth; i++) {
						relativePath += "../";
					}
					relativePath += "home/main";
				}
				
				response.getWriter().append(
						String.format("<script>alert('올바른 요청이 아님'); location.replace('%s');</script>", relativePath));
				return;
			}
			String controllerName = reqUriBits[3]; 
			String actionMethodName = reqUriBits[4]; 
			
			  if (controllerName.equals("reservation")) { 
				  ReservationController reservationController =  new ReservationController(request, response, conn);
			  
			  if (actionMethodName.equals("myList")) { 
				  reservationController.showMyList();}
			  if (actionMethodName.equals("seatMap")) { reservationController.showSeatMap(); }
			  if (actionMethodName.equals("doHold")) { reservationController.doHold(); }

			  }
			
			  else if (controllerName.equals("member")) { MemberController memberController =
					  new MemberController(request, response, conn);
					  
					  if (actionMethodName.equals("login")) { memberController.showLogin(); } 
					  if (actionMethodName.equals("doLogin")) { memberController.doLogin(); } 
					  if (actionMethodName.equals("doLogout")) { memberController.doLogout(); } 
					  if (actionMethodName.equals("join")) { memberController.showJoin(); } 
					  if (actionMethodName.equals("doJoin")) { memberController.doJoin(); } 
					  }
					  
			  else if (controllerName.equals("concert")) { 
					ConcertController concertController = new ConcertController(request, response, conn);
					
					if (actionMethodName.equals("list")) { concertController.showList(); } 
					if (actionMethodName.equals("detail")) { concertController.showDetail(); } 
					}
			
			  else if (controllerName.equals("home")) { HomeController homeController = new
			  HomeController(request, response, conn);
			  
			  if (actionMethodName.equals("main")) { homeController.showMain(); } 
			  }
			  else {
				  	String homeUrl = request.getContextPath() + "/s/home/main";
					response.getWriter().append(String.format("<script>alert('존재하지 않는 페이지입니다.'); location.replace('%s');</script>", homeUrl));
					return;
				}
			 
		} catch (SQLException e) {
			System.out.println("에러 : " + e);
		} finally {
			try {
				if (conn != null && !conn.isClosed()) {
					conn.close();
				}
			} catch (SQLException e) {
				e.printStackTrace();
			}
		}
			
		response.getWriter().append("Served at: ").append(request.getContextPath());
	}


	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {

		doGet(request, response);
	}

}
