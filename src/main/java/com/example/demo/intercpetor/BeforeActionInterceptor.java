package com.example.demo.intercpetor;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;
import org.springframework.web.servlet.HandlerInterceptor;

import com.example.demo.vo.Rq;

import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

@Component
public class BeforeActionInterceptor implements HandlerInterceptor {
	@Autowired
	private Rq rq;
	
	@Override
	public boolean preHandle(HttpServletRequest req, HttpServletResponse resp, Object Handler) throws Exception {
		//System.out.println("실행됨");
		rq.initBeforeActionInterceptor(); // rq생성을 강제로 수행함
		
		return HandlerInterceptor.super.preHandle(req, resp, Handler);

	}

}
