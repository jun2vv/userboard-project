<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import = "java.net.*" %>
<%
	//로그인 유효성검사& 에러메시지 변수
	String msg = URLEncoder.encode(".", "utf-8");
	if(session.getAttribute("loginMemberId") == null) {
			msg = "로그인이 되어있지 않습니다.";
			response.sendRedirect(request.getContextPath()+"/home.jsp?msg="+msg);
			return;
	}
	// 수정완료후 boardOne으로 돌아가기 위한 요청값 
	int boardNo = Integer.parseInt(request.getParameter("boardNo"));
	// 수정할 댓글 번호 요청값
	int commentNo = Integer.parseInt(request.getParameter("commentNo"));
	System.out.println(boardNo + " <--- modifyCommentForm boardNo");
	System.out.println(commentNo + " <--- modifyCommentForm commentNo");
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
	<h1>댓글 수정</h1>
	<a href = "<%=request.getContextPath() %>/board/boardOne.jsp?boardNo=<%=boardNo %>">뒤로가기</a>
	<!-- 오류 메시지 -->
	<%
	if(request.getParameter("msg") != null){
	%>
			<div><%=request.getParameter("msg")%></div>
	<%
	}
	%>
	<form action="<%=request.getContextPath() %>/board/modifyCommentAction.jsp">
		<table class="table table-striped">
			<tr>
				<td>
					<input type="hidden" value="<%=commentNo %>" name="commentNo">
				</td>
				
				<th>댓글 내용</th>
				<td>
					<input type="text" name="commentContent">
				</td>
				
				<td>
					<input type="hidden" value="<%=boardNo %>" name="boardNo">
				</td>
			</tr>
		</table>
		<button class="btn btn-success" type="submit">수정하기</button>
	</form>
	</div>
</body>
</html>