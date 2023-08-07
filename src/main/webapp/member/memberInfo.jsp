
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import = "java.sql.*" %>
<%@ page import="vo.*" %>


<%
	
	// 컨트롤러 계층
	// 로그인 유효성검사 
	if(session.getAttribute("loginMemberId") == null) {
		response.sendRedirect(request.getContextPath()+"/home.jsp");
		return;
	}
	
	// 로그인이 되어있으면 로그인으로 받아온 값을 memberId에 넣는다.
	String memberId = (String)session.getAttribute("loginMemberId");
	
	System.out.println(memberId +"<--- memberInfo memberId");
	
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
	/* 쿼리문
		select member_id memberId, createdate createdate, updatedate updatedate 
		from member 
		where member_id = ? ;
	*/
	sql = "select member_id memberId, createdate createdate, updatedate updatedate from member where member_id = ? ";
	stmt = conn.prepareStatement(sql);
	stmt.setString(1,memberId);
	rs = stmt.executeQuery();
	
	// 디버깅
	System.out.println(stmt + "<--- memberInfo stmt");	
	System.out.println(rs + "<--- memberInfo rs");	
	
	rs = stmt.executeQuery();
	Member m = null;
	if(rs.next()) {
		m = new Member();
		m.setMemberId(rs.getString("memberId"));
		m.setCreatedate(rs.getString("createdate"));
		m.setUpdatedate(rs.getString("updatedate"));
	}
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
	<div>
		<jsp:include page="/inc/mainMenu.jsp"></jsp:include>
	</div>
	<br>
	<h1>회원정보</h1>
		<table class="table table-striped">
			<tr>
				<th>member_id</th>
				<td><%=m.getMemberId() %></td>
			</tr>
			<tr>
				<th>createdate</th>
				<td><%=m.getCreatedate() %></td>
			</tr>
			<tr>
				<th>updatedate</th>
				<td><%=m.getUpdatedate() %></td>
			</tr>
		</table>
		<a class="btn btn-outline-dark" href="<%=request.getContextPath()%>/member/updateMemberForm.jsp">회원정보 수정</a>
		<a class="btn btn-outline-dark" href="<%=request.getContextPath()%>/member/deleteMemberForm.jsp">회원정보 삭제</a>
	</div>
</body>
</html>