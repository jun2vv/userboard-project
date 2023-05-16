<%@page import="javax.naming.spi.DirStateFactory.Result"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import = "java.sql.*" %>
<%@ page import = "java.net.*" %>
<%@ page import = "vo.*" %>

<%
	// -------------------------------------------------------로그인 데이터 -------------------------------------------------------------------------
	request.setCharacterEncoding("utf-8");

	// 1.세션유효성겁사 --> 2.요청값 유효성겁사
	if(session.getAttribute("loginMemberId") != null) {
		response.sendRedirect(request.getContextPath()+"/home.jsp");
		return;
	}
	
	// 요청값 유효성검사
	String memberId = request.getParameter("memberId");
	String memberPw = request.getParameter("memberPw");
	//디버깅
	System.out.println(memberId + "<---  para loginAction memberId ");
	System.out.println(memberPw + "<---  para loginAction memberPw ");
	
	//db 연동
	String driver = "org.mariadb.jdbc.Driver";
	String dburl = "jdbc:mariadb://127.0.0.1:3306/userboard";
	String dbuser = "root";
	String dbpw = "java1234";
	
	// db연동 변수 및 동적쿼리를위한 변수 선언
	Class.forName(driver);
	Connection conn = null;
	PreparedStatement stmt = null;
	ResultSet rs = null;
	conn = DriverManager.getConnection(dburl, dbuser, dbpw);
	 /* 쿼리문
	    SELECT member_id memberId FROM member 
	    WHERE member_id = ? AND member_pw = PASSWORD(?)"
	 */
	
	String sql = "SELECT member_id memberId FROM member WHERE member_id = ? AND member_pw = PASSWORD(?)";
	stmt = conn.prepareStatement(sql);
	stmt.setString(1, memberId);
	stmt.setString(2, memberPw);
	rs = stmt.executeQuery();
	// 디버깅
	System.out.println(stmt + "<--- stmt loginAction");
	System.out.println(rs + "<--- rs loginAction");
	
	if(rs.next()) { // 로그인 성공
		session.setAttribute("loginMemberId", rs.getString("memberId"));
		System.out.println("로그인 성공 세션정보 :" + session.getAttribute("loginMemberId") + "<--- loginAction");
	} else { // 로그인 실패
		System.out.println("로그인 실패 <--- loginAction");
	}
	
	response.sendRedirect(request.getContextPath()+"/home.jsp");
	
%>
