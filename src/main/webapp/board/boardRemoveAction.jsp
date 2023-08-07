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
	if(request.getParameter("boardNo") == null
		|| request.getParameter("boardNo").equals("")){
	    return;
	}
	int boardNo = Integer.parseInt(request.getParameter("boardNo"));
	System.out.println(boardNo + " <--- boardRemoveAction boardNo");

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
    System.out.println( "드라이버 실행 <--- boardRemoveAction");	
    
	// 외래키 위반 중복 검사
	// 게시물이 남아있을경우 삭제가 안되도록 함.
	String searchSql = null;
	PreparedStatement searchStmt = null;
	ResultSet searchRs = null;
	
	searchSql ="SELECT count(*) FROM comment WHERE board_no = ?";
	searchStmt = conn.prepareStatement(searchSql);
	searchStmt.setInt(1, boardNo);
	searchRs = searchStmt.executeQuery();
	
	System.out.println(searchStmt + " <--- boardRemoveAction searchStmt");
	System.out.println(searchRs + " <--- boardRemoveAction searchRs");
	
	int cnt = 0;
	if(searchRs.next()){
	  	cnt = searchRs.getInt("count(*)");
	}
	  	
	//cnt가 0이 아니면 페이지 반환
	if(cnt > 0){
		msg = URLEncoder.encode("게시글에 댓글이 남아있어 게시글 삭제가 불가합니다.", "utf-8");
	  	response.sendRedirect(request.getContextPath()+"/board/boardOne.jsp?msg=" + msg + "&boardNo=" +boardNo);
	  	return;
	}	
	
	String sql = null;
	PreparedStatement stmt = null;
	ResultSet rs = null;
    /* 삭제쿼리
    	DELETE FROM board where board_no = ?
    */
    sql = "DELETE FROM board where board_no = ?";
	stmt = conn.prepareStatement(sql);
	stmt.setInt(1, boardNo);
	int row = stmt.executeUpdate();
	System.out.println(stmt +"<---  boardRemoveAction stmt");
	System.out.println(row +"<---  boardRemoveAction row");
	
	if(row == 1) {
		System.out.println("게시글 삭제 완료! <--- boardRemoveAction");
		response.sendRedirect(request.getContextPath()+"/home.jsp");
	} else{
		System.out.println("게시글 삭제 실패! <--- boardRemoveAction");
		msg = URLEncoder.encode("게시글 삭제에 실패하였습니다.", "utf-8");
		response.sendRedirect(request.getContextPath()+"/board/boardOne.jsp?msg="+msg);
	}
%>
