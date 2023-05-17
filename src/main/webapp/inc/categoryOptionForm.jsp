<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import = "java.sql.*"%>
<%@ page import = "java.util.*" %>
<%@ page import ="vo.*" %>
<%
	// 로그인 안되어있으면 홈으로 돌아감
	if(session.getAttribute("loginMemberId") == null){
	   	response.sendRedirect(request.getContextPath()+"/home.jsp");
	  	return;
	}

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
	// 수정폼에서 현재 수정할값을 알려주기 위하여 데이터를 가져옴
	/* 쿼리
		SELECT local_name FROM local	
	*/
	// 카테고리설정창에 현재 카테고리종류를 나타내줄 모델
	sql ="SELECT local_name localName, createdate, updatedate FROM local ORDER BY createdate desc";
	stmt = conn.prepareStatement(sql);
	rs = stmt.executeQuery();
		
	ArrayList<Local> localList = new ArrayList<Local>();
	while(rs.next()) {
		Local l = new Local();
		l.setLocalName(rs.getString("LocalName"));
		l.setCreatedate(rs.getString("createdate"));
		l.setUpdatedate(rs.getString("updatedate"));
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
	<div style="text-align: center;">
	<h1>지역 카테고리 설정창</h1>
		<a href="<%=request.getContextPath()%>/home.jsp" class="btn btn-info">홈으로</a>
		<a href="<%=request.getContextPath()%>/member/categoryInsertForm.jsp" class="btn btn-outline-success">지역카테고리 추가</a>
		<a href="<%=request.getContextPath()%>/member/categoryUpdateForm.jsp" class="btn btn-outline-success">지역카테고리 수정</a>
		<a href="<%=request.getContextPath()%>/member/categoryDeleteForm.jsp" class="btn btn-outline-success">지역카테고리 삭제</a>
	</div>	
		<table class="table table-bordered">
			<tr class="table-info">
				<th>카테고리명</th>
				<th>생성일자</th>
				<th>수정일자</th>
			</tr>
				 <%
			         for(Local l : localList ) {
			     %>
			         	<tr>
			         		<td><%=l.getLocalName() %></td>
			         		<td><%=l.getCreatedate() %></td>
			         		<td><%=l.getUpdatedate() %></td>
			         	</tr>
			     <%
					}
			     %>
	         
		</table>
	</div>
</body>
</html>