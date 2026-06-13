package com.example.demo.intercpetor;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;
import org.springframework.web.servlet.HandlerInterceptor;

import com.example.demo.service.MemberService;
import com.example.demo.vo.Member;
import com.example.demo.vo.Rq;

import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

@Component
public class NeedAdminInterceptor implements HandlerInterceptor {

    @Autowired
    private Rq rq;

    @Autowired
    private MemberService memberService;

    @Override
    public boolean preHandle(HttpServletRequest request, HttpServletResponse response, Object handler)
            throws Exception {
        // Use the @Autowired scoped-proxy instead of request attribute to guarantee Rq is initialized
        if (!rq.isLogined()) {
            rq.printHistoryBack("관리자만 접근할 수 있습니다.");
            return false;
        }

        Member m = memberService.getMemberById(rq.getLoginedMemberId());
        if (m == null || m.getAuthLevel() < 7) {
            rq.printHistoryBack("관리자만 접근할 수 있습니다.");
            return false;
        }

        return true;
    }
}
