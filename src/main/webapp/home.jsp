<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ page import="java.sql.*"%>
<%@ page import="java.util.*"%>
<%@ page import="vo.*"%>
<%
	// 깃 테스트
	request.setCharacterEncoding("utf-8");
	System.out.println(request.getParameter("localName") + "<--- home localName");
	
	// 1. 요청분석(컨트롤러 계층)
	// 1) session JSP내장(기본)객체
	
	// 2) request/ respnse JSP내장(기본)객체
	// 현재페이지 변수
	int currentPage = 1;
	if (request.getParameter("currentPage") != null) {
		currentPage = Integer.parseInt(request.getParameter("currentPage"));
	}
	// 페이지당 출력할 행의 수
	int rowPerPage = 10;
	// 페이지당 시작 행번호
	int startRow = (currentPage - 1) * rowPerPage;
	
	// localName을 전체로 선언해 놓음으로써 초기화면을 전체데이터를 출력한다.
	String localName = "전체";
	if (request.getParameter("localName") != null) {
		localName = request.getParameter("localName");
	}
	
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
	
	// 2) 게시판 목록 결과셋
	/*	쿼리문
		SELECT board_no boardNo, local_name localName, board_title boardTitle 
		FROM board LIMIT ?, ?
	*/
	// localName의 기본값이 전체이므로 비교했을시 아래 sql문이 실행된다. 
	if (localName.equals("전체")) {
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
	while (rs.next()) {
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
	
	// 페이징 모델
	int totalRow = 0; //전체 행의 갯수를 담을 변수
	String pageSql = "select count(*) from board";
	PreparedStatement pageStmt = null;
	
	if (localName.equals("전체")) {
		pageStmt = conn.prepareStatement(pageSql);
	} else {
		pageStmt = conn.prepareStatement(pageSql + " where local_name=? ");
		pageStmt.setString(1, localName);
	}
	ResultSet pagingRs = pageStmt.executeQuery();
	if (pagingRs.next()) {
		totalRow = pagingRs.getInt("count(*)");
	}
	
	int lastPage = totalRow / rowPerPage;
	//rowPerPage가 딱 나뉘어 떨어지지 않으면 그 여분을 보여주기 위해 +1
	if (totalRow % rowPerPage != 0) {
		lastPage = lastPage + 1;
	}
	// 페이지 네비게이션 페이징
	int pagePerPage = 10;
	/*	cp	minPage		maxPage
		1		1	~	10
		2		1	~	10
		10		1	~	10
		
		11		11	~	20
		12		11	~	20
		20		11	~	20
		
		((cp-1) / pagePerPage) * pagePerPage + 1 --> minPage
		minPage + (pagePerPgae -1) --> maxPage
		maxPage > lastPage --> maxPage = lastPage;
	*/
	// 마지막 페이지 구하기
	// 최소페이지,최대페이지 구하기
	int minPage = ((currentPage - 1) / pagePerPage) * pagePerPage + 1;
	int maxPage = minPage + (pagePerPage - 1);
	if (maxPage > lastPage) {
		maxPage = lastPage;
	}
%>

<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Insert title here</title>
<link
	href="https://cdn.jsdelivr.net/npm/bootstrap@5.2.3/dist/css/bootstrap.min.css"
	rel="stylesheet">
<script
	src="https://cdn.jsdelivr.net/npm/bootstrap@5.2.3/dist/js/bootstrap.bundle.min.js"></script>
</head>
<body>
	<!-- 오류 메시지 -->
	<%
	if (request.getParameter("msg") != null) {
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
	ArrayList<HashMap<String, Object>> subMenuList = new ArrayList<HashMap<String, Object>>();
	while (subMenuRs.next()) {
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
	<div class="container">
		<div>
			<jsp:include page="/inc/mainMenu.jsp"></jsp:include>
		</div>
		<br>
		<div class="row">
			<div class="col-sm-2">
				<!-- 서브메뉴(세로) subMenuList메뉴를 출력-->
				<div style="text-align: center;">
					<table class="table table-bordered">
						<%
						for (HashMap<String, Object> m : subMenuList) {
						%>
						<tr class="table-danger">
							<td>
								<!-- 자바문 (String),(Integer)생략가능 --> <a
								style="color: black; text-decoration: none;"
								href="<%=request.getContextPath()%>/home.jsp?localName=<%=(String) m.get("localName")%>">
									<%=(String) m.get("localName")%>(<%=(Integer) m.get("cnt")%>)
							</a>
							</td>
						</tr>
						<%
						}
						%>
					</table>
				</div>
			</div>
			<!-- (시작부분)localList--------------------------------------------------------------------------------- -->
			<div class="col-sm-8">
				<table class="table table-bordered table-hover">
					<tr class="table-success">
						<th>board_no</th>
						<th>local_name</th>
						<th>board_title</th>
						<th>member_id</th>
						<th>createdate</th>
					</tr>
					<%
					for (Board l : localList) {
					%>
					<tr
						onclick="location.href='<%=request.getContextPath()%>/board/boardOne.jsp?boardNo=<%=l.getBoardNo()%>&memberId=<%=l.getMemberId()%>'"
						style="cursor: pointer;">
						<td><%=l.getBoardNo()%></td>
						<td><%=l.getLocalName()%></td>
						<td><%=l.getBoardTitle()%></td>
						<td><%=l.getMemberId()%></td>
						<td><%=l.getCreatedate()%></td>
					</tr>
					<%
					}
					%>
				</table>
			</div>
			<div class="col-sm-2">
				<!-- home내용 : 상단 로그인폼 / 카테고리별 게시글 10개씩  -->
				<!--  로그인 폼 -->
				<%
				if (session.getAttribute("loginMemberId") == null) { // 로그인 전이면 로그인폼 출력
				%>
				<div>
					<form action="<%=request.getContextPath()%>/member/loginAction.jsp"
						method="post">
						<table>
							<tr>
								<td>아이디</td>
							</tr>
							<tr>
								<td><input type="text" class="form-control" name="memberId"
									value="user1"></td>
							</tr>
							<tr>
								<td>비밀번호</td>
							</tr>
							<tr>
								<td><input type="password" class="form-control"
									name="memberPw" value="1234"></td>
							</tr>
							<tr>
								<td>
									<div class="d-grid">
										<button class="btn btn-success btn-sm btn-block" type="submit">로그인</button>
									</div>
								</td>
							</tr>
						</table>
					</form>
				</div>
				<%
				} else {
				%>
				<h2><%=session.getAttribute("loginMemberId")%>님
				</h2>
				<!-- 메인메뉴(가로) -->
				<!-- 서버기술이기 때문에 ﹤% request...%﹥를 쓸 필요가 없음 -->
				<%
				}
				%>
				<br>
				<div style="background-color: #C6DBDA;">
					<h5>회원전용 게시판 프로젝트</h5>
					<span style="font-weight: bold;">
					- 기간 2023.05.03 ~ 2023.05.20 - <br><br>
					
					&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;- 개발환경 - <br>
					&nbsp;&nbsp;<span style="color: red;">OS</span> : window11<br>
					&nbsp;&nbsp;<span style="color: red;">Tool</span> : Eclipse,heidiSQL<br>
					&nbsp;&nbsp;<span style="color: red;">DB</span> : mariaDB(3.1.3)<br>
					&nbsp;&nbsp;<span style="color: red;">WAS</span> : Tomcat9<br>
					&nbsp;&nbsp;<span style="color: red;">Language</span> : HTML5,<br> 
					&nbsp;&nbsp;CSS3, Java(JDK17),<br> 
					&nbsp;&nbsp;mySQL<br>
					
					&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;- 구현기능 -<br>
					&nbsp;&nbsp;1. 게시물 페이징<br>
					&nbsp;&nbsp;2. session을 사용한<br>
					&nbsp;&nbsp;로그인 및 회원가입<br>
					&nbsp;&nbsp;3. 카테고리 추가,<br>
					&nbsp;&nbsp;수정,삭제<br>
					&nbsp;&nbsp;4. 게시글 추가,수정,삭제<br>
					&nbsp;&nbsp;5. 게시글 별 댓글 추가,<br>
					&nbsp;&nbsp;수정,삭제
					</span>
				</div>
			</div>
		</div>
		<!--  페이징  ---------------- -->
		<ul
			class="pagination justify-content-center list-group list-group-horizontal">
			<%
			// 최소페이지가 1보다크면 첫페이지로 가게 해주는 버튼
			if (minPage > 1) {
			%>
			<li class="list-group-item list-group-item-info"><a
				style="color: black; text-decoration: none;"
				href="<%=request.getContextPath()%>/home.jsp?currentPage=<%=1%>&localName=<%=localName%>">첫페이지로</a>
			</li>
			<%
			}
			// 최소페이지가 1보다크면 이전페이지(이전페이지는 만약 내가 11페이지면 1페이지로 21페이지면 11페이지로)버튼
			if (minPage > 1) {
			%>
			<li class="list-group-item list-group-item-info">
				<!-- 이전페이지 --> <a style="color: black; text-decoration: none;"
				href="<%=request.getContextPath()%>/home.jsp?currentPage=<%=minPage - pagePerPage%>&localName=<%=localName%>">이전</a>
			</li>
			<%
			}

			for (int i = minPage; i <= maxPage; i += 1) {
			if (i == currentPage) {
			%>
			<li class="list-group-item">
				<!-- i와 현재페이지가 같은곳이라면 현재위치한 페이지 빨간색표시 --> <span style="color: red;"><%=i%></span>
			</li>
			<%
			// i가 현재페이지와 다르다면 출력
			} else {
			%>
			<li class="list-group-item">
				<!--  1~10, 11~20... 페이지 출력 --> <a
				style="color: black; text-decoration: none;"
				href="<%=request.getContextPath()%>/home.jsp?currentPage=<%=i%>&localName=<%=localName%>"><%=i%></a>
			</li>
			<%
			}
			}
			// maxPage가 마지막페이지와 다르다면 다음버튼 마지막페이지에서는 둘이 같으니 다음버튼이 안나오겠죠
			// 다음페이지(만약 내가 1페이지에서 누르면 11페이지로 11페이지에서 누르면 21페이지로)버튼
			if (maxPage != lastPage) {
			%>
			<li class="list-group-item list-group-item-info">
				<!--  다음페이지 maxPage+1을해도 아래와 같다 --> <a
				style="color: black; text-decoration: none;"
				href="<%=request.getContextPath()%>/home.jsp?currentPage=<%=minPage + pagePerPage%>&localName=<%=localName%>">다음</a>
			</li>
			<%
			}
			// maxPage가 lastPage보다 작으면 현재마지막페이지가 아닌것 이므로 마지막페이지로 갈 수 있는 버튼
			if (maxPage < lastPage) {
			%>
			<li class="list-group-item list-group-item-info">
				<!-- 마지막페이지로  --> <a style="color: black; text-decoration: none;"
				href="<%=request.getContextPath()%>/home.jsp?currentPage=<%=lastPage%>&localName=<%=localName%>">마지막페이지</a>
			</li>
			<%
			}
			%>
		</ul>
		<div>
			<!-- include 페이지 : Copyright &copy; 구디아카데미 -->
			<jsp:include page="/inc/copyright.jsp"></jsp:include>
		</div>
	</div>
</body>
</html>