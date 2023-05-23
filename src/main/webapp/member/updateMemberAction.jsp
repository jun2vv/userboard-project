<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import = "java.sql.*" %>
<%@ page import = "java.net.*" %>

<%
	
	// 1. 요청분석 컨트롤러계층
	request.setCharacterEncoding("utf-8");
	// 오류메세지를 보낼 변수 msg
	String msg = "";
	if(session.getAttribute("loginMemberId") == null) {
		msg = URLEncoder.encode("로그인이 안되어 있습니다.", "utf-8");
		response.sendRedirect(request.getContextPath()+"/home.jsp?msg="+msg);
		return;
	}
	
	// 요청값중 null이거나 공백이 있으면 다시 수정폼으로 보냄
	if(request.getParameter("memberId") ==null
		|| request.getParameter("memberPw") ==null
	    || request.getParameter("newPw") ==null
	    || request.getParameter("newPwCheck") ==null
	    || request.getParameter("memberId").equals("")
	    || request.getParameter("memberPw").equals("")
	    || request.getParameter("newPw").equals("")
	    || request.getParameter("newPwCheck").equals("")) {
		msg = URLEncoder.encode("아이디 또는 비밀번호가 입력되지 않았습니다. ", "utf-8");
		response.sendRedirect(request.getContextPath() +"/member/updateMemberForm.jsp?msg="+msg);
	    	return;
	   }
	
	// 요청값 변수 선언
	String memberId = request.getParameter("memberId");
	String memberPw = request.getParameter("memberPw");
	String newPw = request.getParameter("newPw");
	String newPwCheck = request.getParameter("newPwCheck");
	     
	// 요청값 디버깅
	System.out.println(memberId +"<---  updateMemberAction memberId");
 	System.out.println(memberPw +"<---  updateMemberAction memberPw");
 	System.out.println(newPw +"<---  updateMemberAction newPw");
	System.out.println(newPwCheck +"<---  updateMemberAction newPwCheck");
	   
	// 비밀번호 확인 검사 새로운 비밀번호와 확인비밀번호가 다르면 수정폼으로 다시보내버림.
	if(!newPw.equals(newPwCheck)){
		System.out.println("<--- 비밀번호 불일치  updateMemberAction");
		msg = URLEncoder.encode("비밀번호가 불일치합니다.. ", "utf-8");
		response.sendRedirect(request.getContextPath() +"/member/updateMemberForm.jsp?msg="+msg);
	    return;
	}
	   
 	// 2.모델 계층
 	//db 연동
 	String driver = "org.mariadb.jdbc.Driver";
 	String dburl = "jdbc:mariadb://127.0.0.1:3306/userboard";
 	String dbuser = "root";
 	String dbpw = "java1234";
 	// db연동 변수 
 	Class.forName(driver);
 	Connection conn = null;
 	// 1) 서브메뉴 결과셋(모델)
	//동적쿼리를위한 변수 
	String sql = null;
 	PreparedStatement stmt = null;
 	ResultSet rs = null;
 	conn = DriverManager.getConnection(dburl, dbuser, dbpw);
 	/* 쿼리문
 		update member set member_pw = password(?), updatedate = now() 
 		where member_id = ? and member_pw = password(?);
 	*/
 	sql = "update member set member_pw = password(?), updatedate = now() where member_id = ? and member_pw = password(?)";
 	stmt = conn.prepareStatement(sql);
 	stmt.setString(1,newPw);
 	stmt.setString(2,memberId);
 	stmt.setString(3,memberPw);
 	int row = stmt.executeUpdate();
 	
	// 디버깅
 	System.out.println(stmt +"<--- updateMemberAction stmt");
 	System.out.println(row +"<--- updateMemberAction row");
	
 	// row값 1이면 성공 0이면 실패
 	if(row == 1){
 		System.out.println("변경완료");
 		response.sendRedirect(request.getContextPath() +"/home.jsp");
 	} else{
 		System.out.println("변경실패");
		msg = URLEncoder.encode("아이디 또는 비밀번호가 입력되지 않았습니다. ", "utf-8");
 		response.sendRedirect(request.getContextPath() +"/member/updateMemberForm.jsp?msg="+msg);
	}
%>