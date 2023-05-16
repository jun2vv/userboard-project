<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import = "java.net.*" %>
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
	System.out.println("카테고리추가창 <--- categoryInsertForm");
	
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
	<a class="btn btn-info" href ="<%=request.getContextPath() %>/home.jsp">홈</a>
	<a class="btn btn-warning" href ="<%=request.getContextPath() %>/inc/categoryOptionForm.jsp">카테고리설정창</a>
	<h1>지역카테고리 추가</h1>
	<!-- 오류 메시지 -->
	<%
	if(request.getParameter("msg") != null){
	%>
			<div><%=request.getParameter("msg")%></div>
	<%
	}
	%>
	<form action="<%=request.getContextPath() %>/member/categoryInsertAction.jsp" method="post">
		<table class="table table-striped">
			<tr>
				<th>아이디</th>
				<td><input type="text" value="<%=memberId %>" readonly= "readonly"></td>
			</tr>
			<tr>
				<th>지역 이름</th>
				<td><input type="text" name="localName"></td>
			</tr>
		</table>
		<button class="btn btn-success" type="submit">추가 하기</button>
	</form>
	</div>
</body>
</html>