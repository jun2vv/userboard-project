<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import = "java.net.*" %>
<%@ page import = "java.util.*" %>
<%@ page import ="vo.*" %>
<%@ page import = "java.sql.*" %>
<%
	//로그인이 되어 있지 않을시 카테고리 추가 화면 못옴
	String msg = URLEncoder.encode(".", "utf-8");
	if(session.getAttribute("loginMemberId") == null) {
		msg = "로그인이 되어있지 않습니다.";
		response.sendRedirect(request.getContextPath()+"/home.jsp?msg="+msg);
		return;
	}
	// 로그인 되어있을시 아이디값 가져옴
	String memberId = (String)session.getAttribute("loginMemberId");
	System.out.println("카테고리수정창 <--- categoryUpdateForm");
	
	// 모델 계층
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
	// 수정폼에서 현재 수정할값을 알려주기 위하여 데이터를 가져옴
	/* 쿼리
		SELECT local_name FROM local	
	*/
	sql ="SELECT local_name localName FROM local";
	stmt = conn.prepareStatement(sql);
	rs = stmt.executeQuery();
		
	ArrayList<Local> localList = new ArrayList<Local>();
	while(rs.next()) {
		Local l = new Local();
		l.setLocalName(rs.getString("LocalName"));
		localList.add(l);
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
	<a class="btn btn-info" href ="<%=request.getContextPath() %>/home.jsp">홈으로</a>
	<a class="btn btn-warning" href ="<%=request.getContextPath() %>/inc/categoryOptionForm.jsp">카테고리설정창</a>
	<h1>지역카테고리 수정</h1>
	<!-- 오류 메시지 -->
	<%
	if(request.getParameter("msg") != null){
	%>
			<div><%=request.getParameter("msg")%></div>
	<%
	}
	%>
	<form action="<%=request.getContextPath() %>/member/categoryUpdateAction.jsp" method="post">
		<table class="table table-striped">
			<tr>
				<th>아이디</th>
				<td><input type="text" value="<%=memberId %>" readonly= "readonly"></td>
			</tr>
			 <tr>
	         	<th>수정할 카테고리</th>
	         	<td>
	         		<select name="localName">
	         <%
	         	for(Local l : localList ) {
	         %>
	         		<!--  value의 값이 실제 넘어가는 값 -->
	         		<option value="<%=l.getLocalName()%>"><%=l.getLocalName() %></option>
	         <%
				}
	         %>
	         		</select>
	         	</td>
	         </tr>
			<tr>
				<th>수정된 이름</th>
				<td><input type="text" name="upLocalName"></td>
			</tr>
		</table>
		<button class="btn btn-success" type="submit">수정 하기</button>
	</form>
	</div>
</body>
</html>