<%@page import="java.util.ArrayList"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import = "java.net.*" %>
<%@ page import = "java.sql.*"%>
<%@ page import ="vo.*" %>
<%
	// 로그인 유효성검사& 에러메시지 변수
	String msg = URLEncoder.encode(".", "utf-8");
	if(session.getAttribute("loginMemberId") == null) {
		msg = "로그인이 되어있지 않습니다.";
		response.sendRedirect(request.getContextPath()+"/home.jsp?msg="+msg);
		return;
	}
	// 로그인 되어있을시 아이디값 가져옴
	String memberId = (String)session.getAttribute("loginMemberId");
	System.out.println("게시글 추가창 <--- boardInsertForm");
	
	//모델 계층
	// db 연동
	String driver = "org.mariadb.jdbc.Driver";
	String dburl = "jdbc:mariadb://127.0.0.1:3306/userboard";
	String dbuser = "root";
	String dbpw = "java1234";
	// db연동 변수 
	Class.forName(driver);
	Connection conn = null;
	// 서브메뉴 결과셋(모델)
	// 동적쿼리를위한 변수 
	String sql = null;
	PreparedStatement stmt = null;
	ResultSet rs = null;
	conn = DriverManager.getConnection(dburl, dbuser, dbpw);
	
	/* 쿼리	//게시글을 추가시킬 지역을 선택하기위한 쿼리
		SELECT local_name FROM local
	*/
	sql="SELECT local_name localName FROM local";
	stmt = conn.prepareStatement(sql);
	rs = stmt.executeQuery();
	
	ArrayList<Local> localList = new ArrayList<Local>();
	while(rs.next()){
		Local l = new Local();
		l.setLocalName(rs.getString("localName"));
		localList.add(l);
	}
	
	// 디버깅
	System.out.println(localList + " <- boardInsertForm localList");
	
%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Insert title here</title>
</head>
	<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.2.3/dist/css/bootstrap.min.css" rel="stylesheet">
	<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.2.3/dist/js/bootstrap.bundle.min.js"></script>
<body>
	<div class="container">
	<h1>게시글 추가창</h1>
	<a class="btn btn-info" href="<%=request.getContextPath()%>/home.jsp" >홈으로</a>
	<form action="<%=request.getContextPath()%>/board/boardInsertAction.jsp" method="post">
		<table class="table table-striped">
			<tr>
				<th>local_name</th>
				<td>
					<select name="localName">
						<%
							for(Local l : localList){
						%>
								<option value="<%=l.getLocalName() %>"><%=l.getLocalName() %></option>
						<% 	
							}
						%>
					</select>
				</td>
			</tr>
			<tr>
				<th>board_title</th>
				<td><input type="text" name="boardTitle"></td>
			</tr>
			<tr>
				<th>board_content</th>
				<td><input type="text" name="boardContent"></td>
			</tr>
			<tr>
				<th>member_id</th>
				<td><input type="text" name="memberId" value="<%=memberId%>" readonly="readonly"></td>
			</tr>
		</table>
		<button class="btn btn-success" type="submit">게시글 추가하기</button>
	</form>
	</div>
</body>
</html>