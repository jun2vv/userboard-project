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
	// 로그인 되어있을시 아이디값 가져옴
	String memberId = (String)session.getAttribute("loginMemberId");
	
	// boardOne 에서 넘어온값 
	if(request.getParameter("localName") != null
		||request.getParameter("boardNo") != null){
	}
	String localName = request.getParameter("localName");
	int boardNo = Integer.parseInt(request.getParameter("boardNo"));
	
	
	System.out.println(memberId + "<--- boardModifyForm memberId");
	System.out.println(localName + "<--- boardModifyForm localName");
	System.out.println(boardNo + "<--- boardModifyForm boardNo");
	
	
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
	<h2>게시글 수정창</h2>
		<form action="<%=request.getContextPath() %>/board/boardModifyAction.jsp">
			<table class="table table-striped">
				<tr>
					<th>board_no</th>
					<td><input type="text" name="boardNo" value="<%=boardNo%>" readonly="readonly"></td>
				</tr>
				<tr>
					<th>member_id</th>
					<td>
						<input type="text"  value="<%=memberId%>" readonly="readonly">
					</td>
				</tr>
				<tr>
					<th>local_name</th>
					<td>
						<input type="text" value="<%=localName%>" readonly="readonly">
					</td>
				</tr>
				<tr>
					<th>board_title</th>
					<td>
						<input type="text" name="boardTitle">
					</td>
				</tr>
				<tr>
					<th>board_content</th>
					<td>
						<input type="text" name="boardContent">
					</td>
				</tr>
			</table>
			<button class="btn btn-outline-dark" type="submit">게시글 수정하기</button>
		</form>
	</div>
</body>
</html>