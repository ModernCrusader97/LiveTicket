package LiveTicket.Home;

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


public class HomeController {
private HttpServletRequest request;
private HttpServletResponse response;
private Connection conn;
private HomeService homeService;


public HomeController(HttpServletRequest request, HttpServletResponse response, Connection conn) {
	this.request = request;
	this.response = response;
	this.conn = conn;
	this.homeService = new HomeService(conn);
}


public void showMain() throws ServletException, IOException
{
	request.getRequestDispatcher("/jsp/home/main.jsp").forward(request, response);
}

}
