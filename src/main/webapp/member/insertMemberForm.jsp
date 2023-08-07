<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>

<%
	//-------------------------------------------------------회원가입 view--------------------------------------------------------------
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
	<!-- 오류 메시지 -->
	<%
	if (request.getParameter("msg") != null) {
	%>
	<div><%=request.getParameter("msg")%></div>
	<%
	}
	%>
	<div class="container">
	<div>
		<jsp:include page="/inc/mainMenu.jsp"></jsp:include>
	</div>
	<br>
		
	<h2>회원가입 페이지</h2>
	<form action="<%=request.getContextPath() %>/member/insertAction.jsp" method="post">
		<table class="table table-striped">
			<tr>
				<td>아이디 입력</td>
				<td><input type="text" name="memberId"></td>
				
			</tr>
			<tr>
				<td>비밀번호 입력</td>
				<td><input type="password" name="memberPw"></td>
			</tr>
		</table>
		<button type="submit" class="btn btn-outline-dark">회원가입</button>
	</form>
	<br>
	<br>
	<div>
		<!-- include 페이지 : Copyright &copy; 구디아카데미 -->
		<jsp:include page="/inc/copyright.jsp"></jsp:include>
	</div>
	</div>
</body>
</html>