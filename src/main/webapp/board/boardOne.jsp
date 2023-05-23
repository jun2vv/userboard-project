<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import = "java.sql.*" %>
<%@ page import = "java.util.*" %>
<%@ page import ="vo.*" %>

<%
	request.setCharacterEncoding("utf-8");
	System.out.println(request.getParameter("boardNo")+ "<--- para boardOne boardNo");
	
	// ----------------------------------------------------------------1. 요청분석(컨트롤러 계층)-------------------------------------------------------------------
	
	// 요청값 boardNo
	int boardNo = 0;
	String memberId = "";
	if(request.getParameter("boardNo") == null
		||request.getParameter("boardNo").equals("")){
		response.sendRedirect(request.getContextPath()+"/home.jsp");
		return;
	}
		boardNo = Integer.parseInt(request.getParameter("boardNo"));
		memberId = request.getParameter("memberId");
	
	// 댓글 초과시 다음페이지로 가기위한 페이지 넘기기 변수
	int currentPage = 1;	// 현재페이지
	int rowPerPage = 10;	// 한페이지당 보여줄 댓글행 개수
	// currentPage 요청값 검사.
	if(request.getParameter("currentPage") != null) {
		currentPage = Integer.parseInt(request.getParameter("currentPage"));
	}
	
	int startRow = (currentPage-1) * rowPerPage;	// 댓글 시작행번호
	
	//디버깅
	System.out.println(boardNo + "<--- boardOne boardNo");
	System.out.println(memberId + "<--- boardOne memberId");
	
	// ------------------------------------------------------------------------2.모델 계층-------------------------------------------------------------------------
	//db 연동
	String driver = "org.mariadb.jdbc.Driver";
	String dburl = "jdbc:mariadb://127.0.0.1:3306/userboard";
	String dbuser = "root";
	String dbpw = "java1234";
	// db연동 변수 
	Class.forName(driver);
	Connection conn = null;
	conn = DriverManager.getConnection(dburl, dbuser, dbpw);
	
	// boardOne 결과셋
	String boardSql = null;
	PreparedStatement boardStmt = null;
	ResultSet boardRs = null;
	
	/* boardOne 쿼리문
		SELECT board_no boardNo, local_name localName, member_id memberId, board_content boardContent 
		FROM board WHERE board_no = ?
	*/
	// board데이터를 출력하기 위한 쿼리 모델
	boardSql="SELECT board_no boardNo, local_name localName, board_title boardTitle, board_content boardContent, member_id memberId, createdate, updatedate FROM board WHERE board_no = ?";
	boardStmt = conn.prepareStatement(boardSql);
	boardStmt.setInt(1,boardNo);
	boardRs = boardStmt.executeQuery();	// row ---> 1
	Board board = null;
	// 데이터를 선택한 번호에 데이터만 보여주기 때문에 아래쪽 view에서 for문사용안해도 됌
	if(boardRs.next()) {
		board = new Board();
		board.setBoardNo( boardRs.getInt("boardNo"));
		board.setLocalName(boardRs.getString("localName"));
		board.setBoardTitle(boardRs.getString("boardTitle"));
		board.setBoardContent(boardRs.getString("boardContent"));
		board.setMemberId(boardRs.getString("memberId"));
		board.setCreatedate(boardRs.getString("createdate"));
		board.setUpdatedate(boardRs.getString("updatedate"));
	}
	
	// 디버깅
	System.out.println(boardStmt + "<--- boardOne stmt");
	System.out.println(boardRs + "<--- boardOne rs");
	
	// comment결과셋
	String commentSql = null;
	PreparedStatement commentStmt = null;
	ResultSet commentRs = null;
	
	/* comment 쿼리문
		SELECT comment_no commentNo, board_no boardNo, comment_content commentContent 
		FROM COMMENT WHERE board_no = ? LIMIT ?, ?
	*/
	// db에 있는comment를 화면에 출력하는 쿼리모델
	commentSql="SELECT comment_no commentNo, board_no boardNo, comment_content commentContent, member_id memberId, createdate createdate, updatedate updatedate FROM comment WHERE board_no = ? ORDER BY createdate DESC LIMIT ?, ?";
	commentStmt = conn.prepareStatement(commentSql);
	commentStmt.setInt(1,boardNo);
	commentStmt.setInt(2, startRow);
	commentStmt.setInt(3, rowPerPage);
	commentRs = commentStmt.executeQuery();	// row ---> 최대10
	// comment데이터를 전부 보여주기 위하여 배열로 만들어 저장.
	ArrayList<Comment> commentList = new ArrayList<Comment>();
	while(commentRs.next()) {
		Comment c = new Comment();
		c.setCommentNo(commentRs.getInt("commentNo"));
		c.setBoardNo(commentRs.getInt("boardNo"));
		c.setCommentContent(commentRs.getString("commentContent"));
		c.setMemberId(commentRs.getString("memberId"));
		c.setCreatedate(commentRs.getString("createdate"));
		c.setUpdatedate(commentRs.getString("updatedate"));
		commentList.add(c);
	}
	//디버깅
	System.out.println(commentStmt + "<--- boardOne commentStmt");
	System.out.println(commentRs + "<--- boardOne commentRs");
	System.out.println(commentList + "<--- boardOne commentList");
	System.out.println(commentList.size() + "<--- boardOne commentList.size()");
	
	
	// 페이징 모델값 구하기	
	// 페이지 넘기기를 위해 필요한 층
	// lastPage를 구하기 위한 쿼리문 count(*)를 사용하여 총 행의(totalCount) 개수를 파악해 rowPerPage로 나눠서 구한다 
	// where board_no =? 를 사용하는 이유 원하는 번호에 comment만 가져오기 위하여 필요함.
	String pageSql = "select count(*) from comment WHERE board_no = ?";
	PreparedStatement pageStmt = conn.prepareStatement(pageSql);
	pageStmt.setInt(1,boardNo);
	ResultSet pageRs = pageStmt.executeQuery();
	int totalCount = 0;	//전체 행의 개수를 담을 변수
	int lastPage = 0;	// 마지막페이지를 구할 변수
		
	if(pageRs.next()) {
		totalCount = pageRs.getInt("COUNT(*)");
	}
	
	// 디버깅
	System.out.println(pageStmt + "<--- boardOne pageStmt");
	System.out.println(pageRs + "<--- boardOne pageRs");
	
	lastPage = totalCount / rowPerPage;		// 전체행 / 한페이지당 보여줄 행의 개수를 하면 마지막페이지를 알 수 있다.
		
		
	if(totalCount % rowPerPage != 0 ) {		// 전체 행의 개수를 한페이지당 보여줄 행의 개수로 나눴을때 0이 아니면 마지막페이지에 +1을 해준다.
		lastPage = lastPage+1;
	}
	//디버깅
	System.out.println(totalCount + "<---  boardOne totalCount");
	System.out.println(lastPage + "<---   boardOne lastPage"); 
	
%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Insert title here</title>
</head>
	<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.2.3/dist/css/bootstrap.min.css" rel="stylesheet">
	<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.2.3/dist/js/bootstrap.bundle.min.js"></script>
<style>
</style>
<body>
<div class="container">
	<a href="<%=request.getContextPath() %>/home.jsp">홈으로가기</a>
	<!-- 오류 메시지 -->
	<%
	if(request.getParameter("msg") != null){
	%>
			<div><%=request.getParameter("msg")%></div>
	<%
	}
	%>
<!------------------------------------------------------------ 3-1 boardOne 결과창 ----------------------------------------------- -->
	<table class="table table-striped">
		<tr>
			<th>board_no</th>
			<th>local_name</th>
			<th>boardTitle</th>
			<th>board_content</th>
			<th>memberId</th>
			<th>createdate</th>
			<th>updatedate</th>
		</tr>
		
		<tr>
			<td><%=boardRs.getInt("boardNo") %></td>
			<td><%=boardRs.getString("localName") %></td>
			<td><%=boardRs.getString("boardTitle") %></td>
			<td><%=boardRs.getString("boardContent") %></td>
			<td><%=boardRs.getString("memberId") %></td>
			<td><%=boardRs.getString("createdate") %></td>
			<td><%=boardRs.getString("updatedate") %></td>
		</tr>
	</table>
	<%
		if(session.getAttribute("loginMemberId") != null && session.getAttribute("loginMemberId").equals(boardRs.getString("memberId"))) {
	%>
			<div>
				<a href="<%=request.getContextPath()%>/board/boardUpdateForm.jsp?localName=<%=board.getLocalName() %>&boardNo=<%=board.getBoardNo() %>">수정</a>
				<a href="<%=request.getContextPath()%>/board/boardRemoveAction.jsp?boardNo=<%=boardRs.getInt("boardNo")%>">삭제</a>
			</div>
	<% 
		}
	%>
<!------------------------------------------------------------ 3-1 boardOne 결과창 종료 ----------------------------------------------- -->

<!-- ---------------------------------------------------3-2 comment(댓글) 입력창 : 로그인 안되어있을시 입력불가능.------------------------------- -->
	<%
		// 로그인 사용자만 댓글 입력허용.
		if(session.getAttribute("loginMemberId") != null) {
			// 현재 로그인 사용자의 아이디
			String loginMemberId = (String)session.getAttribute("loginMemberId");
	%>
			<form action ="<%=request.getContextPath() %>/board/insertCommentAction.jsp" method="post">
					<input type="hidden" name="boardNo" value="<%=board.getBoardNo()%>">
					<input type="hidden" name="memberId" value="<%=loginMemberId %>">
				<table class="table table-striped">
					<tr>
					
						<td>
							<textarea rows="2" cols="60" name="commentContent"></textarea>
						</td>
					</tr>
				</table>
				<button type="submit">댓글달기</button>
			</form>
	<%
		}
	%>
<!-- ---------------------------------------------------3-2 comment(댓글) 입력창 : 로그인 안되어있을시 입력불가능. 종료------------------------------- -->

<!-- ---------------------------------------------------3-3 입력된 comment(댓글) 결과창 ------------------------------- -->
	<table class="table table-striped">
		<tr>
			<th>commentContent</th>
			<th>memberId</th>
			<th>createdate</th>
			<th>updatedate</th>
			<th>수정</th>
			<th>삭제</th>
		</tr>
		<%
			for(Comment c : commentList) {
		%>	
				<tr>
					<td><%=c.getCommentContent() %></td>
					<td><%=c.getMemberId() %></td>
					<td><%=c.getCreatedate() %></td>
					<td><%=c.getUpdatedate() %></td>
					<%
						// 자기가 작성한 댓글만 수정삭제가 가능하도록 조건을 지정
						if(session.getAttribute("loginMemberId") != null && session.getAttribute("loginMemberId").equals(c.getMemberId())) {
					%>
					
					<td>
						<a href ="<%=request.getContextPath()%>/board/modifyCommentForm.jsp?commentNo=<%=c.getCommentNo()%>&boardNo=<%=c.getBoardNo()%>">수정</a>					</td>
					<td>
						<a href ="<%=request.getContextPath()%>/board/removeCommentAction.jsp?commentNo=<%=c.getCommentNo()%>&boardNo=<%=c.getBoardNo()%>">삭제</a>
					</td>
					<% 	
						}
					%>
				</tr>	
		<% 
			}
		%>
	</table>
<!-- ---------------------------------------------------3-3 입력된 comment(댓글) 결과창 종료 ------------------------------- -->
	<div>
		<%
			if(currentPage > 1) {
		%>
			<a href="<%=request.getContextPath() %>/board/boardOne.jsp?boardNo=<%=boardNo %>&currentPage=<%=currentPage-1 %>">이전</a>
		<% 
			} 
			if(currentPage < lastPage) {
		%>
			<a href="<%=request.getContextPath() %>/board/boardOne.jsp?boardNo=<%=boardNo %>&currentPage=<%=currentPage+1 %>">다음</a>
		<% 
			}
		%>

	</div>
</div>
</body>
</html>