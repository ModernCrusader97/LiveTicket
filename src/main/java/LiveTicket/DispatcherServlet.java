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
			int loginedMemberId = -1;
			String loginedMemberName = null;
			if (session.getAttribute("loginedMemberId") != null) {
				isLogined = true;
				loginedMemberId = (int) session.getAttribute("loginedMemberId");
				loginedMemberName = (String) session.getAttribute("loginedMemberName");
			}
			request.setAttribute("isLogined", isLogined);
			request.setAttribute("loginedMemberId", loginedMemberId);
			request.setAttribute("loginedMemberName", loginedMemberName);

			String requestUri = request.getRequestURI();

			String[] reqUriBits = requestUri.split("/");
			if (reqUriBits.length < 5) { 
				response.getWriter().append(
						String.format("<script>alert('올바른 요청이 아님'); location.replace('../home/main');</script>"));
				return;
			}
			String controllerName = reqUriBits[3]; 
			String actionMethodName = reqUriBits[4]; 
			
			  if (controllerName.equals("Reservation")) { 
				  ReservationController reservationController =  new ReservationController(request, response, conn);
			  
			  if (actionMethodName.equals("MyList")) { 
				  reservationController.showMyList();
			  }

			  }
			/*
			 * if (controllerName.equals("member")) { MemberController memberController =
			 * new MemberController(request, response, conn);
			 * 
			 * if (actionMethodName.equals("login")) { memberController.showLogin(); } if
			 * (actionMethodName.equals("doLogin")) { memberController.doLogin(); } if
			 * (actionMethodName.equals("doLogout")) { memberController.doLogout(); } if
			 * (actionMethodName.equals("join")) { memberController.showJoin(); } if
			 * (actionMethodName.equals("doJoin")) { memberController.doJoin(); } }
			 */
			/*
			 * if (controllerName.equals("home")) { HomeController homeController = new
			 * HomeController(request, response, conn);
			 * 
			 * if (actionMethodName.equals("main")) { homeController.showMain(); } }
			 */
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
