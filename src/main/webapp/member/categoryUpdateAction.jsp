<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import = "java.sql.*" %>
<%@ page import = "java.net.*" %>
<%
	// 1. 컨트롤러 계층
	
	//로그인 유효성검사
	if(session.getAttribute("loginMemberId") == null){
     	response.sendRedirect(request.getContextPath()+"/home.jsp");
    	return;
  	}

	//지역추가값이 null이거나 공백이면 카테고리추가폼으로 다시 보냄
	// 오류메세지를 보낼 변수 msg
	String msg = "";
	if(request.getParameter("upLocalName") == null
		|| request.getParameter("localName") == null
     	|| request.getParameter("upLocalName").equals("")
     	|| request.getParameter("localName").equals("")) {
		msg = URLEncoder.encode("추가할 지역을 작성하지 않았습니다.", "utf-8");
     	response.sendRedirect(request.getContextPath()+"/member/categoryUpdateForm.jsp?msg="+msg);
     return;
 	}
	
	// 요청받은값 변수에 저장
	String localName = request.getParameter("localName");
	String upLocalName = request.getParameter("upLocalName");
	System.out.println(localName + " <--- categoryUpdateAction localName");
	System.out.println(upLocalName + " <--- categoryUpdateAction upLocalName");
	
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
    System.out.println( "드라이버 실행 <--- categoryUpdateAction");
    
 	//외래키 위반 중복 검사
 	// 게시물이 남아있을경우 카테고리 수정이 안되도록 함.
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
  		msg = URLEncoder.encode("기존 카테고리명의 게시글이 남아있어서 변경이 안됩니다.", "utf-8");
  		response.sendRedirect(request.getContextPath()+"/member/categoryUpdateForm.jsp?msg=" + msg);
  		return;
  	}
    
    /* 쿼리
    	UPDATE local set local_name = ?, updatedate = now() where local_name = ?
    */
    sql = "UPDATE local set local_name = ?, updatedate = now() where local_name = ?";
   	stmt = conn.prepareStatement(sql);
   	stmt.setString(1, upLocalName);
   	stmt.setString(2, localName);
   	int row = stmt.executeUpdate();
   	
 	// 디버깅
  	System.out.println(stmt +"<--- categoryUpdateAction stmt");
  	System.out.println(row +"<--- categoryUpdateAction row");
  	
 	// row값 1이면 성공 0이면 실패
  	if(row == 1){
  		System.out.println("변경완료");
  		response.sendRedirect(request.getContextPath() +"/home.jsp");
  	} else{
  		System.out.println("변경실패");
  		msg = URLEncoder.encode("지역이 수정되지 않았습니다.", "utf-8");
  		response.sendRedirect(request.getContextPath()+"/member/categoryUpdateForm.jsp?msg="+msg);
 	}
   	
   	
%>
