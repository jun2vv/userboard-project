<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import = "java.sql.*" %>
<%@ page import = "java.net.*" %>
<%@ page import = "vo.*" %>
<%
	// 1.컨트롤러 계층
	request.setCharacterEncoding("utf-8");
	//로그인 유효성검사
	if(session.getAttribute("loginMemberId") == null){
       	response.sendRedirect(request.getContextPath()+"/home.jsp");
      	return;
    }
	// 지역추가값이 null이거나 공백이면 카테고리추가폼으로 다시 보냄
	// 오류메세지를 보낼 변수 msg
	String msg = "";
	if(request.getParameter("localName") == null
        || request.getParameter("localName").equals("")) {
		msg = URLEncoder.encode("추가할 지역을 작성하지 않았습니다.", "utf-8");
        response.sendRedirect(request.getContextPath()+"/member/categoryInsertForm.jsp?msg="+msg);
        return;
    }
	
	// 요청받은값 변수에 저장
	String localName = request.getParameter("localName");
	System.out.println(localName + " <--- categoryInsertAction localName");
	
	// 2.모델 계층
    //db 연동
    String driver = "org.mariadb.jdbc.Driver";
    String dburl = "jdbc:mariadb://3.37.133.115:3306/userboard";
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
    System.out.println( "드라이버 실행 <--- categoryInsertAction");
    
	// 외래키 위반 중복 검사
	// 같은 카테고리가 있을경우 추가 안됨.
  	String searchSql ="select count(*) from local where local_name = ?";
  	PreparedStatement searchStmt = conn.prepareStatement(searchSql);
  	searchStmt.setString(1, localName);
  	
  	ResultSet searchRs = searchStmt.executeQuery();
  	int cnt = 0;
  	if(searchRs.next()){
  		cnt = searchRs.getInt("count(*)");
  	}
  	
  	//cnt가 0이 아니면 페이지 반환
  	if(cnt != 0){
  		msg = URLEncoder.encode("기존 카테고리명이 중복됩니다.", "utf-8");
  		response.sendRedirect(request.getContextPath()+"/member/categoryInsertForm.jsp?msg=" + msg);
  		return;
  	}
    
    /* 쿼리문
    	INSERT INTO local(local_name, createdate, updatedate) VALUES(?, now(), now())
    */
	sql = "INSERT INTO local(local_name, createdate, updatedate) VALUES(?, now(), now())";
	stmt = conn.prepareStatement(sql);
	stmt.setString(1, localName);
	int row = stmt.executeUpdate();
	
	System.out.println(stmt + "<--- categoryInsertAction stmt ");
	System.out.println(row + "<--- categoryInsertAction row ");
	
	// 성공시 홈으로 실패시 카테고리 추가폼으로
	if(row == 1) {
		System.out.println("카테고리 추가 완료 <--- categoryInsertAction");
		response.sendRedirect(request.getContextPath()+"/home.jsp");
	} else {
		System.out.println("카테고리 추가 실패 <--- categoryInsertAction");
		msg = URLEncoder.encode("카테고리가 추가되지 않았습니다 다시시도해주세요", "utf-8");
		response.sendRedirect(request.getContextPath()+"/member/categoryInsertForm.jsp?msg="+msg);
	}
%>
