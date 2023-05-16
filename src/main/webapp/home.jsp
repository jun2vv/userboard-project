<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import = "java.sql.*" %>
<%@ page import = "java.util.*" %>
<%@ page import ="vo.*" %>
<%
	response.setCharacterEncoding("utf-8");
	System.out.println(request.getParameter("localName")+ "<--- home localName");
		
	// 1. 요청분석(컨트롤러 계층)
	// 1) session JSP내장(기본)객체

	// 2) request/ respnse JSP내장(기본)객체
	// 현재페이지 변수
	int currentPage = 1;
	if(request.getParameter("currentPage") != null){
		currentPage = Integer.parseInt(request.getParameter("currentPage"));
	}
	// 페이지당 출력할 행의 수
	int rowPerPage = 10;
	// 페이지당 시작 행번호
	int startRow = (currentPage-1) * rowPerPage;
	
	
	
	// localName을 전체로 선언해 놓음으로써 초기화면을 전체데이터를 출력한다.
	String localName = "전체";
	if(request.getParameter("localName") != null){
		localName = request.getParameter("localName");
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

	
	// 2) 게시판 목록 결과셋
	/*	쿼리문
		SELECT board_no boardNo, local_name localName, board_title boardTitle 
		FROM board LIMIT ?, ?
	*/
	// localName의 기본값이 전체이므로 비교했을시 아래 sql문이 실행된다. 
	if(localName.equals("전체")) {
		sql = "SELECT board_no boardNo, local_name localName, board_title boardTitle, member_id memberId, createdate FROM board ORDER BY createdate DESC LIMIT ?, ?";
		stmt = conn.prepareStatement(sql);
		stmt.setInt(1, startRow);
		stmt.setInt(2, rowPerPage);
		rs = stmt.executeQuery();
		// 디버깅
		System.out.println(stmt + " <--- home 전체stmt");
		System.out.println(rs + " <--- home 전체rs");
	} else { // 전체가 아닐시 실행
		sql = "SELECT board_no boardNo, local_name localName, board_title boardTitle, member_id memberId, createdate FROM board WHERE local_name = ? ORDER BY createdate DESC LIMIT ?, ?";
		stmt = conn.prepareStatement(sql);
		stmt.setString(1, localName);
		stmt.setInt(2, startRow);
		stmt.setInt(3, rowPerPage);
		rs = stmt.executeQuery();
		// 디버깅
		System.out.println(stmt + " <--- home 전체 아닐때 전체x stmt");
		System.out.println(rs + " <--- home 전체 아닐때 전체x rs");
	}
	
	// Local 클래스의 ArrayList 객체 생성
	// rs를 localList로 넣기 위함
	ArrayList<Board> localList = new ArrayList<Board>(); // 애플리케이션에서 사용할 모델(사이즈0)
	while(rs.next()) {
		Board l = new Board();
		l.setBoardNo(rs.getInt("boardNo"));			
		l.setLocalName(rs.getString("localName"));			
		l.setBoardTitle(rs.getString("boardTitle"));	
		l.setMemberId(rs.getString("MemberId"));	
		l.setCreatedate(rs.getString("createdate"));	
		localList.add(l);
	} 
	// 디버깅
	System.out.println(localList + " <- home localList");
	System.out.println(localList.size() + " <- home localList.size()");
	
	
	int totalRow = 0;	//전체 행의 갯수를 담을 변수

	String pageSql = "select count(*) from board";
	PreparedStatement pageStmt= null;
	
	if(localName.equals("전체")){
		pageStmt = conn.prepareStatement(pageSql);
	}else{
		pageStmt = conn.prepareStatement(pageSql+" where local_name=? ");
		pageStmt.setString(1, localName);
	}
	ResultSet pagingRs = pageStmt.executeQuery();
	if(pagingRs.next()) {
		totalRow = pagingRs.getInt("count(*)");
	}
	//System.out.println( totalRow + BG_RED+ "<---totalRow home.jsp" +RESET);
	int lastPage = totalRow / rowPerPage;
	//rowPerPage가 딱 나뉘어 떨어지지 않으면 그 여분을 보여주기 위해 +1
	if(totalRow % rowPerPage != 0) {
		lastPage = lastPage + 1;
	}
	//System.out.println( lastPage + BG_RED+ "<---lastPage home.jsp" +RESET);
	
		//페이징을 리스트 형태로 변환하기 위한 변수 선언
 	int pageRange = 4; // 현재 페이지 주변에 보여줄 페이지의 수
 	//Math.max --> 값들 중 가장 큰 값 반환  Math.min --> 값들 중 가장 작은 값 반환
    int startPage = Math.max(1, currentPage - pageRange); // 현재 페이지 주변의 첫 페이지 번호 계산
    int endPage = Math.min(lastPage, currentPage + pageRange); // 현재 페이지 주변의 마지막 페이지 번호 계산
	
%>

<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Insert title here</title>
	<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.2.3/dist/css/bootstrap.min.css" rel="stylesheet">
	<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.2.3/dist/js/bootstrap.bundle.min.js"></script>
</head>
<body>
<div class="container">
<div class="row">
	<!-- 오류 메시지 -->
	<%
	if(request.getParameter("msg") != null){
	%>
			<div><%=request.getParameter("msg")%></div>
	<%
	}
	%>
	
	<%
	/* 쿼리문
	 	SELECT '전체' localName, COUNT(local_name) cnt FROM board
		UNION ALL
		SELECT local_name, COUNT(local_name) FROM board GROUP BY local_name
	*/
 	// 전체와 local_name의 총수를 cnt로 나타내기 위함
	String subMenuSql = "SELECT '전체' localName, COUNT(local_name) cnt FROM board UNION ALL SELECT local_name, COUNT(local_name) FROM board GROUP BY local_name";
	PreparedStatement subMenuStmt = conn.prepareStatement(subMenuSql);
	ResultSet subMenuRs = subMenuStmt.executeQuery();
	// subMenuList에 ArrayList<HashMap<string, Object>>데이터 타입을 가진 객체 생성
	ArrayList<HashMap<String, Object>> subMenuList = new  ArrayList<HashMap<String, Object>>();
		while(subMenuRs.next()) {
		HashMap<String, Object> m = new HashMap<String, Object>();
		m.put("localName", subMenuRs.getString("localName"));
		m.put("cnt", subMenuRs.getInt("cnt"));
		subMenuList.add(m);
		}
	%>
	<%
	// action태그의 원본태그
			// request.getRequestDispatcher(request.getContextPath()+"/inc/copyright.jsp").include(request, response );
			// 이 코드를 action태그로 변경하면 아래와 같다.
	%>
	<!-- 메인메뉴(가로) -->
	<div>
		<jsp:include page="/inc/mainMenu.jsp"></jsp:include>
	</div>
	<div>
		<!-- home내용 : 상단 로그인폼 / 카테고리별 게시글 10개씩  -->
		<!--  로그인 폼 -->
		<%
		if(session.getAttribute("loginMemberId") == null) {	// 로그인 전이면 로그인폼 출력
		%>	
			<div>
			<form action="<%=request.getContextPath()%>/member/loginAction.jsp" method="post">
				<table>
					<tr>
						<td>아이디</td>
						<td><input type="text" name="memberId"></td>
					</tr>
					<tr>
						<td>비밀번호</td>
						<td><input type="password" name="memberPw"></td>
					</tr>
				</table>
				<button class="btn btn-success" type="submit">로그인</button>
			</form>
			</div>
		<%
		     
        } else {
    	 %>
     		<h2><%=session.getAttribute("loginMemberId")%>님</h2>
     		<!-- 메인메뉴(가로) -->
			<!-- 서버기술이기 때문에 ﹤% request...%﹥를 쓸 필요가 없음 -->
    	 <%
        	}
     	%>   
	</div>
	<div class="col-sm-2 container">
	<div style="margin-top: 32px; text-align: center;">
	<!-- 서브메뉴(세로) subMenuList메뉴를 출력-->
	<div style="margin-top: 32px; text-align: center;">
		<table class="table table-bordered">
			<%
			for(HashMap<String, Object> m : subMenuList) {
			%>	
				<tr class="table-danger">	
					<td>													<!-- 자바문 (String),(Integer)생략가능 -->
						<a href ="<%=request.getContextPath()%>/home.jsp?localName=<%=(String)m.get("localName")%>">
							<%=(String)m.get("localName")%>(<%=(Integer)m.get("cnt")%>)</a>
					</td>
				</tr>
			<%
			}
			%>
		</table>
	</div>
	</div>
	</div>
	<!-- (시작부분)localList--------------------------------------------------------------------------------- -->
<div class="col-sm-10">	
	<table class="table table-bordered">
		<tr class="table-info">
			<th>board_no</th>
			<th>local_name</th>
			<th>board_title</th>
			<th>member_id</th>
			<th>createdate</th>
		</tr>
		<%
		for(Board l  : localList) {
		%>	
			<tr>
				<td><%=l.getBoardNo() %></td>
				<td><%=l.getLocalName() %></td>
				<td><a href="<%=request.getContextPath()%>/board/boardOne.jsp?boardNo=<%=l.getBoardNo()%>&memberId=<%=l.getMemberId() %>"><%=l.getBoardTitle() %></a></td>
				<td><%=l.getMemberId() %></td>
				<td><%=l.getCreatedate() %></td>
			</tr>
		<% 
			}
		%>
	</table>
</div>	
</div>
		<% 	//페이지가 1이 상이면 이전 페이지 보여주기
			if (startPage > 1) {
		%>
			<a href="<%=request.getContextPath()%>/home.jsp?currentPage=<%=1%>&localName=<%=localName%>">1</a>
			
		<%
		      } 
		      
			for (int i = startPage; i <= endPage; i+=1) { 
				if (i == currentPage) {
		%>
					<%=i%>>
		<%
				} else {
		%>
					<a href="<%=request.getContextPath()%>/home.jsp?currentPage=<%=i%>&localName=<%=localName%>"><%=i%></a>
		<% 
				} 
			} 	
			
		      if (endPage < lastPage) {
		%>
					
					<a href="<%=request.getContextPath()%>/home.jsp?currentPage=<%=lastPage%>&localName=<%=localName%>"><%=lastPage%>마지막페이지</a>
		<% 
			}
		%>
	<div>
		<!-- include 페이지 : Copyright &copy; 구디아카데미 -->
		<jsp:include page="/inc/copyright.jsp"></jsp:include>
	</div>
	
</div>
</body>
</html>