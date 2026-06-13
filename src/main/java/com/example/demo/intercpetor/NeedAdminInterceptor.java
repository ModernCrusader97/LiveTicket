package com.example.demo.intercpetor;

import org.springframework.stereotype.Component;
import org.springframework.web.servlet.HandlerInterceptor;

import com.example.demo.vo.Rq;

import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import org.springframework.beans.factory.annotation.Autowired;
import com.example.demo.service.MemberService;
import com.example.demo.vo.Member;

@Component
public class NeedAdminInterceptor implements HandlerInterceptor {
    @Autowired
    private Rq rq;

    @Autowired
    private MemberService memberService;

    @Override
    public boolean preHandle(HttpServletRequest request, HttpServletResponse response, Object handler)
            throws Exception {
        Rq rq = (Rq) request.getAttribute("rq");

        if (!rq.isLogined()) {
            rq.printHistoryBack("관리자만 접근할 수 있습니다.");
            return false;
        }

        int memberId = rq.getLoginedMemberId();
        Member m = memberService.getMemberById(memberId);
        if (m == null) {
            rq.printHistoryBack("관리자만 접근할 수 있습니다.");
            return false;
        }

        int authLevel = 3;
        try {
            java.lang.reflect.Field f = m.getClass().getDeclaredField("authLevel");
            f.setAccessible(true);
            Object val = f.get(m);
            if (val instanceof Number) authLevel = ((Number) val).intValue();
        } catch (Exception e) {
            authLevel = 3;
        }

        if (authLevel < 7) {
            rq.printHistoryBack("관리자만 접근할 수 있습니다.");
            return false;
        }

        return HandlerInterceptor.super.preHandle(request, response, handler);
    }
}
