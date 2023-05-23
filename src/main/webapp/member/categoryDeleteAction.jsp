<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import = "java.sql.*"%>
<%@ page import = "java.net.*" %>
<%
	// 1. 컨트롤러 계층
	request.setCharacterEncoding("utf-8");
	//로그인 유효성검사
	if(session.getAttribute("loginMemberId") == null){
	   	response.sendRedirect(request.getContextPath()+"/home.jsp");
	  	return;
	}

	//지역추가값이 null이거나 공백이면 카테고리추가폼으로 다시 보냄
	// 오류메세지를 보낼 변수 msg
	String msg = "";
	if(request.getParameter("deleteLocalName") == null
		|| request.getParameter("localName") == null
	   	|| request.getParameter("deleteLocalName").equals("") 
	   	|| request.getParameter("localName").equals("")) {
		msg = URLEncoder.encode("삭제할 카테고리를 지정하지 않았습니다.", "utf-8");
   		response.sendRedirect(request.getContextPath()+"/member/categoryDeleteForm.jsp?msg="+msg);
 		return;
	}
	// 요청값 변수 선언
	String deleteLocalName = request.getParameter("deleteLocalName");
	String localName = request.getParameter("localName");
	System.out.println(deleteLocalName +"<---  updateMemberAction deleteLocalName");
	
	// 선택한 값과 삭제할값이 동일한지 검사 틀릴경우 다시 뒤로 보냄 
	if(!localName.equals(deleteLocalName)) {
		msg = URLEncoder.encode("선택한 카테고리명과 입력한 카테고리명이 다릅니다.", "utf-8");
		response.sendRedirect(request.getContextPath()+"/member/categoryDeleteForm.jsp?msg="+msg);
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
	
	// 외래키 위반 중복 검사
	// 게시물이 남아있을경우 삭제가 안되도록 함.
  	String searchSql ="select count(*) from board where local_name = ?";
  	PreparedStatement searchStmt = conn.prepareStatement(searchSql);
  	searchStmt.setString(1, localName);
  	
  	ResultSet searchRs = searchStmt.executeQuery();
  	int cnt = 0;
  	if(searchRs.next()){
  		cnt = searchRs.getInt("count(*)");
  	}
  	
  	//cnt가 0이 아니면 페이지 반환
  	if(cnt != 0){
  		msg = URLEncoder.encode("기존 카테고리명의 게시글이 남아있어서 삭제가 안됩니다.", "utf-8");
  		response.sendRedirect(request.getContextPath()+"/member/categoryDeleteForm.jsp?msg=" + msg);
  		return;
  	}
  	
  	// 카테고리 삭제 모델
	/* 쿼리
		DELETE FROM local WHERE local_name = ?
	*/
	sql = "DELETE FROM local WHERE local_name = ?";
	stmt = conn.prepareStatement(sql);
	stmt.setString(1, deleteLocalName);
	int row = stmt.executeUpdate();
	System.out.println(stmt +"<---  updateMemberAction stmt");
	System.out.println(row +"<---  updateMemberAction row");
	
	if(row == 1) {
		System.out.println("카테고리 삭제 완료! <--- updateMemberAction");
		response.sendRedirect(request.getContextPath()+"/home.jsp");
	} else{
		System.out.println("카테고리 삭제 실패! <--- updateMemberAction");
		msg = URLEncoder.encode("카테고리 삭제에 실패하였습니다.", "utf-8");
		response.sendRedirect(request.getContextPath()+"/member/categoryDeleteForm.jsp?msg="+msg);
	}
%>

