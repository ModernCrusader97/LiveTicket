package com.example.demo.vo;

import java.io.IOException;

import org.springframework.context.annotation.Scope;
import org.springframework.context.annotation.ScopedProxyMode;
import org.springframework.stereotype.Component;

import com.example.demo.util.Ut;

import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import lombok.Getter;
import lombok.Setter;

@Component
@Scope(value = "request", proxyMode = ScopedProxyMode.TARGET_CLASS)
@Getter
@Setter
public class Rq {
	@Getter
	private boolean isLogined = false;

	@Getter
	private int loginedMemberId = 0;

	@Getter
	private int loginedMemberAuthLevel = 0;

	private HttpServletRequest req;
	private HttpServletResponse resp;

	private HttpSession session;

	public Rq(HttpServletRequest req, HttpServletResponse resp) {
		this.req = req;
		this.resp = resp;
		this.session = req.getSession();

		if (session.getAttribute("loginedMemberId") != null) {
			isLogined = true;
			loginedMemberId = (int) session.getAttribute("loginedMemberId");
			Object authLevelAttr = session.getAttribute("loginedMemberAuthLevel");
			if (authLevelAttr != null) {
				loginedMemberAuthLevel = (int) authLevelAttr;
			}
		}
		this.req.setAttribute("rq", this);
	}

	public void disableCache() {
	    resp.setHeader("Cache-Control", "no-cache, no-store, must-revalidate");
	    resp.setHeader("Pragma", "no-cache");
	    resp.setDateHeader("Expires", 0);
	}

	public void printHistoryBackNT(String msg) {
	    resp.setContentType("text/html; charset=UTF-8");
	    try {
	        println("<script>");
	        if (!Ut.isEmpty(msg)) {
	            String filteredMsg = msg.replace("'", "\\'");
	            println("alert('" + filteredMsg + "');");
	        }
	        println("history.back();");
	        println("</script>");
	        resp.getWriter().flush();
	    } catch (IOException e) {
	        e.printStackTrace();
	    }
	}

	public void printHistoryBack(String msg) throws IOException {
		resp.setContentType("text/html; charset=UTF-8");
		println("<script>");
		if (!Ut.isEmpty(msg)) {
			String safeMsg = msg.replace("\\", "\\\\").replace("'", "\\'").replace("\r", "").replace("\n", "");
			println("alert('" + safeMsg + "');");
		}
		println("history.back();");
		println("</script>");
		resp.getWriter().flush();
		resp.getWriter().close();
	}

	private void println(String str) throws IOException {
		print(str + "\n");
	}

	private void print(String str) throws IOException {
		resp.getWriter().append(str);
	}

	public void logout() {
		session.removeAttribute("loginedMemberId");
		session.removeAttribute("loginedMemberAuthLevel");
	}

	public void login(Member member) {
		session.setAttribute("loginedMemberId", member.getId());
		session.setAttribute("loginedMemberAuthLevel", member.getAuthLevel());
	}

	public boolean isAdmin() {
		return loginedMemberAuthLevel >= 7;
	}

	public void initBeforeActionInterceptor() {
		//System.err.println("initBeforeActionInterceptor 실행됨!");
	}
}
