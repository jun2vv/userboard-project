<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import = "java.sql.*" %>
<%
	// 로그인 유효성검사 
	if(session.getAttribute("loginMemberId") == null) {
		response.sendRedirect(request.getContextPath()+"/home.jsp");
		return;
	}
	String memberId =(String)session.getAttribute("loginMemberId");
	
	System.out.println(memberId +"<--- para updateMemberForm memberId");
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
	<h1>비밀번호바꾸기</h1>
	<!-- 오류 메시지 -->
	<%
	if(request.getParameter("msg") != null){
	%>
			<div><%=request.getParameter("msg")%></div>
	<%
	}
	%>
	<form action="<%=request.getContextPath()%>/member/updateMemberAction.jsp" method="post">
		<table class="table table-striped">
			<tr>
				<th>아이디</th>
				<td><input type="text" name="memberId" value="<%=memberId%>" readonly="readonly"></td>
			</tr>
			<tr>
				<th>현재 비밀번호</th>
				<td><input type="password" name="memberPw"></td>
			</tr>
			<tr>
				<th>변경 비밀번호</th>
				<td><input type="password" name="newPw"></td>
			</tr>
			<tr>
				<th>변경 비밀번호 확인</th>
				<td><input type="password" name="newPwCheck"></td>
			</tr>
		</table>
			<button class="btn btn-outline-dark" type="submit">비밀번호변경</button>
	</form>
	</div>
</body>
</html>