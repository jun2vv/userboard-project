<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%

	session.invalidate(); // 기본 세션을 지우고 갱신 // 세션에 있던 값을 전부초기화하는거다
	response.sendRedirect(request.getContextPath()+"/home.jsp");
%>
    
    