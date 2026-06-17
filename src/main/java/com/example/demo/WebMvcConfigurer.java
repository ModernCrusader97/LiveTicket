package com.example.demo;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.context.annotation.Configuration;
import org.springframework.web.servlet.config.annotation.InterceptorRegistry;
import org.springframework.web.servlet.config.annotation.ResourceHandlerRegistry;

import com.example.demo.intercpetor.BeforeActionInterceptor;
import com.example.demo.intercpetor.NeedLoginInterceptor;
import com.example.demo.intercpetor.NeedLogoutInterceptor;
import com.example.demo.intercpetor.NeedAdminInterceptor;

@Configuration
public class WebMvcConfigurer implements org.springframework.web.servlet.config.annotation.WebMvcConfigurer {
	// BeforeActionInterceptor 연결
	@Value("${custom.upload.path:src/main/resources/static/img}")
	private String uploadPath;

	@Autowired
	BeforeActionInterceptor beforActionInterceptor;

	@Autowired
	NeedLoginInterceptor needLoginInterceptor;

	@Autowired
	NeedLogoutInterceptor needLogoutInterceptor;

	@Autowired
	NeedAdminInterceptor needAdminInterceptor;

	@Override
	public void addResourceHandlers(ResourceHandlerRegistry registry) {
		String absPath = "file:" + System.getProperty("user.dir") + "/" + uploadPath + "/";
		// 업로드 폴더(파일시스템) 먼저, 없으면 WAR 내 classpath static으로 fallback
		registry.addResourceHandler("/img/**")
				.addResourceLocations(absPath, "classpath:/static/img/");
	}

	@Override
	public void addInterceptors(InterceptorRegistry registry) {
		registry.addInterceptor(beforActionInterceptor).addPathPatterns("/**");
		// 모든 요청이 들어오기 전에 beforActionInterceptor를 활용하겠다.

		registry.addInterceptor(needLoginInterceptor).addPathPatterns("/usr/article/write")
				.addPathPatterns("/usr/article/doWrite").addPathPatterns("/usr/article/modify")
				.addPathPatterns("/usr/article/doModify").addPathPatterns("/usr/article/doDelete")
				.addPathPatterns("/usr/article/doLogout");

		registry.addInterceptor(needLogoutInterceptor).addPathPatterns("/usr/member/login")
				.addPathPatterns("/usr/member/doLogin").addPathPatterns("/usr/member/join")
				.addPathPatterns("/usr/member/doJoin");

		// Admin-only paths
		registry.addInterceptor(needAdminInterceptor).addPathPatterns("/admin/**");

	}
}
