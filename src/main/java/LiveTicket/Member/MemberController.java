package LiveTicket.Member;

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


public class MemberController {
private HttpServletRequest request;
private HttpServletResponse response;
private Connection conn;
private MemberService memberService;


public MemberController(HttpServletRequest request, HttpServletResponse response, Connection conn) {
	this.request = request;
	this.response = response;
	this.conn = conn;
	memberService = new MemberService(conn);
}

public void showLogin() throws ServletException, IOException
{
	request.getRequestDispatcher("/jsp/member/login.jsp").forward(request, response);

}

public void doLogin() throws ServletException, IOException {
    String loginId = request.getParameter("loginId");
    String loginPw = request.getParameter("loginPw");

    Map<String, Object> memberRow = memberService.getMemberByLoginId(loginId);

    if (memberRow.isEmpty()) {
        response.getWriter().append("<script>alert('존재하지 않는 아이디입니다.'); history.back();</script>");
        return;
    }

    if (!memberRow.get("password").equals(loginPw)) {
        response.getWriter().append("<script>alert('비밀번호가 일치하지 않습니다.'); history.back();</script>");
        return;
    }

    String name = (String) memberRow.get("name");


    HttpSession session = request.getSession();
    long memberId = ((Number) memberRow.get("id")).longValue();
    session.setAttribute("loginedMemberId", memberId);
    session.setAttribute("loginedMemberName", name);
    
    response.getWriter()
            .append(String.format("<script>alert('%s님, 반갑습니다!'); location.replace('../home/main')</script>", name));
}
public void doLogout() throws ServletException, IOException {
    HttpSession session = request.getSession();
    session.removeAttribute("loginedMemberId");
    session.removeAttribute("loginedMemberName");

    response.getWriter()
            .append("<script>alert('로그아웃 되었습니다.'); location.replace('../home/main');</script>");
}

public void showJoin() throws ServletException, IOException {
    request.getRequestDispatcher("/jsp/member/join.jsp").forward(request, response);
}

public void doJoin() throws ServletException, IOException {
    String loginId = request.getParameter("loginId");
    String loginPw = request.getParameter("loginPw");
    String name = request.getParameter("name");

    if (memberService.isUsedLoginId(loginId)) {
        response.getWriter().append(String.format("<script>alert('%s(은)는 이미 사용 중인 아이디입니다.'); history.back();</script>", loginId));
        return;
    }

    int newMemberId = memberService.doJoin(loginId, loginPw, name);

    response.getWriter()
            .append(String.format("<script>alert('%s님, 환영합니다!'); location.replace('../home/main')</script>", name));
}

}
