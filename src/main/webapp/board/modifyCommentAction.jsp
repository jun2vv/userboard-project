<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import = "java.net.*" %>
<%@ page import = "java.util.*" %>
<%@ page import = "java.sql.*" %>

<%
	//1.컨트롤러 계층
	request.setCharacterEncoding("utf-8");

	System.out.println(request.getParameter("boardNo") + " <--- modifyCommentAction para boardNo");
	System.out.println(request.getParameter("commentNo") + " <--- modifyCommentAction para commentNo");
	// 요청값중 null이거나 공백이 있으면 게시글 추가폼으로 다시 보냄
	// 오류메세지를 보낼 변수 msg
	String msg = "";
	if(request.getParameter("commentContent") == null
		|| request.getParameter("commentContent").equals("")){
		msg = URLEncoder.encode("댓글내용을 입력하지 않았습니다..", "utf-8");
	    response.sendRedirect(request.getContextPath()+"/board/modifyCommentForm.jsp?msg="+msg);
	    return;
	}
	
	// 수정완료후 boardOne으로 돌아가기 위한 요청값 modifyCommentForm에서 넘어온 값
	int boardNo = Integer.parseInt(request.getParameter("boardNo"));
	// 수정할 댓글 번호 요청값
	int commentNo = Integer.parseInt(request.getParameter("commentNo"));
	String commentContent = request.getParameter("commentContent");
	
	System.out.println(boardNo + " <--- modifyCommentAction boardNo");
	System.out.println(commentNo + " <--- modifyCommentAction commentNo");
	System.out.println(commentContent + " <--- modifyCommentAction commentContent");
	
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
    System.out.println( "드라이버 실행 <--- modifyCommentAction");
    
    /* 댓글 수정 쿼리
    	UPDATE comment set comment_content = ?, updatedate = now()
    */
    
    sql = "UPDATE comment set comment_content = ?, updatedate = now() where comment_no = ?";
   	stmt = conn.prepareStatement(sql);
   	stmt.setString(1, commentContent);
   	stmt.setInt(2, commentNo);
   	int row = stmt.executeUpdate();
   	
 	// row값 1이면 성공 0이면 실패
   	if(row == 1){
   		System.out.println("댓글 수정완료");
   		response.sendRedirect(request.getContextPath()+"/board/boardOne.jsp?boardNo=" + boardNo);
   	} else{
   		System.out.println("댓글 수정실패");
   		msg = URLEncoder.encode("댓글이 수정되지 않았습니다.", "utf-8");
   		response.sendRedirect(request.getContextPath()+"/board/modifyCommentForm.jsp?msg="+msg);
  	}
    
%>
