<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import = "java.net.*" %>
<%@ page import = "java.util.*" %>
<%@ page import = "java.sql.*" %>

<%
	//1.컨트롤러 계층
	request.setCharacterEncoding("utf-8");
	// 요청값중 null이거나 공백이 있으면 게시글 추가폼으로 다시 보냄
	// 오류메세지를 보낼 변수 msg
	String msg = "";
	if(request.getParameter("commentNo") == null
		|| request.getParameter("commentNo").equals("")){
	    return;
	}
	
	// 요청값 변수 선언	// boardNo는 다시 boardOne화면으로 돌아가기 위함
	int boardNo = Integer.parseInt(request.getParameter("boardNo"));
	int commentNo = Integer.parseInt(request.getParameter("commentNo"));
	System.out.println(boardNo + " <--- removeCommentAction boardNo");
	System.out.println(commentNo + " <--- removeCommentAction commentNo");
	
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
    conn = DriverManager.getConnection(dburl, dbuser, dbpw);
    System.out.println( "드라이버 실행 <--- removeCommentAction");	
    
	String sql = null;
	PreparedStatement stmt = null;
	ResultSet rs = null;
	/* 댓글 삭제 쿼리
		DELETE FROM comment where comment_no = ?
	*/
	sql = "DELETE FROM comment where comment_no = ?";
	stmt = conn.prepareStatement(sql);
	stmt.setInt(1, commentNo);
	int row = stmt.executeUpdate();
	System.out.println(stmt +"<---  removeCommentAction stmt");
	System.out.println(row +"<---  removeCommentAction row");
	

	if(row == 1) {
		System.out.println("댓글 삭제 완료! <--- boardRemoveAction");
		response.sendRedirect(request.getContextPath()+"//board/boardOne.jsp?boardNo=" + boardNo);
	} else{
		System.out.println("댓글 삭제 실패! <--- boardRemoveAction");
		msg = URLEncoder.encode("댓글 삭제에 실패하였습니다.", "utf-8");
		response.sendRedirect(request.getContextPath()+"/board/boardOne.jsp?msg="+msg);
	}

%>