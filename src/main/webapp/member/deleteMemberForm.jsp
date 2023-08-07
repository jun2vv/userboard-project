<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%
	// 로그인 안되어있으면 못들어옴
    if(session.getAttribute("loginMemberId") == null){
       response.sendRedirect(request.getContextPath()+"/home.jsp");
       return;
    }
	// 로그인 되어있으면 변수에 아이디값 넣음
	String memberId =(String)session.getAttribute("loginMemberId");
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
	<h2>회원탈퇴</h2>
	<!-- 오류 메시지 -->
	<%
	if(request.getParameter("msg") != null){
	%>
			<div><%=request.getParameter("msg")%></div>
	<%
	}
	%>
   	<form action="<%=request.getContextPath()%>/member/deleteMemberAction.jsp" method="post">
     	 <!-- 비밀번호 확인 -->
		<table class="table table-striped">
	       	 <tr>
	            <th>아이디</th>
	            <td><input type="text" name="memberId" value="<%=memberId %>" readonly="readonly"></td>
	         </tr>
	         <tr> 
				<th>현재 비밀번호</th>
	            <td><input type="password" name="memberPw"></td>
	         </tr>
         </table>
         <button class="btn btn-outline-dark" type="submit">회원탈퇴</button>
   </form>
   </div>
</body>
</html>