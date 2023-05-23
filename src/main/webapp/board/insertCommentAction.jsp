<%@page import="java.net.URLEncoder"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import = "java.sql.*" %>
<%@ page import = "java.util.*" %>
<%@ page import ="vo.*" %>

<%	
	// -------------------------1. 요청분석(컨트롤러 계층)-------------------------------
	// 유효성 검사
	request.setCharacterEncoding("utf-8");

	// 혹시 로그인이 안되어있으면 못들어오게 차단.
	if(session.getAttribute("loginMemberId") == null) {
		response.sendRedirect(request.getContextPath()+"/home.jsp");
	}

	if(request.getParameter("boardNo") == null
		|| request.getParameter("boardNo").equals("")) {
		response.sendRedirect(request.getContextPath()+"/home.jsp");
		return;
	}
	if(request.getParameter("commentContent") == null
		|| request.getParameter("commentContent").equals("")) {
		response.sendRedirect(request.getContextPath()+"/home.jsp");
		return;
	}
	
	// 요청값 변수 저장 필요한 값들만 받아온다.
	int boardNo = Integer.parseInt(request.getParameter("boardNo"));
	String memberId = request.getParameter("memberId");
	String commentContent = request.getParameter("commentContent");
	
	System.out.println(boardNo + "<--- para boardOne boardNo");
	System.out.println(memberId + "<--- para boardOne memberId");
	System.out.println(commentContent + "<--- para boardOne commentContent");
	
	// --------------------------------------2.모델 계층------------------------------------------------
	//db 연동
	String driver = "org.mariadb.jdbc.Driver";
	String dburl = "jdbc:mariadb://127.0.0.1:3306/userboard";
	String dbuser = "root";
	String dbpw = "java1234";
	// db연동 변수 
	Class.forName(driver);
	Connection conn = null;
	conn = DriverManager.getConnection(dburl, dbuser, dbpw);

	String sql = null;
	PreparedStatement Stmt = null;
	ResultSet Rs = null;
	/* 쿼리문
		INSERT into COMMENT(comment_content, board_no, member_id, createdate, updatedate) 
		VALUES(?, ?, ?,NOW(),NOW())
	*/
	sql = "INSERT into COMMENT(comment_content, board_no, member_id, createdate, updatedate) VALUES(?, ?, ?,NOW(),NOW())";
	Stmt = conn.prepareStatement(sql);
	Stmt.setString(1, commentContent);
	Stmt.setInt(2, boardNo);
	Stmt.setString(3, memberId);
	
	int row = Stmt.executeUpdate();	
	
	if(row == 1) {
		System.out.println("댓글 입력성공");
		response.sendRedirect(request.getContextPath()+"/board/boardOne.jsp?boardNo=" + boardNo);
	} else {
		System.out.println("댓글 입력실패");
		response.sendRedirect(request.getContextPath()+"/board/boardOne.jsp?boardNo=" + boardNo);
	}
%>
