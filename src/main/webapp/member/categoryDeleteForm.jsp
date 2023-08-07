<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import = "java.net.*" %>
<%@ page import = "java.util.*" %>
<%@ page import ="vo.*" %>
<%@ page import = "java.sql.*" %>

<%
	// 로그인 안되어있으면 못들어옴
	// 오류메세지 변수 msg
	String msg = URLEncoder.encode(".", "utf-8");
    if(session.getAttribute("loginMemberId") == null){
    	msg = "로그인이 되어있지 않습니다.";
		response.sendRedirect(request.getContextPath()+"/home.jsp?msg="+msg);
       	return;
    }
    String localName = request.getParameter("localName");
	// 로그인 되어있으면 변수에 아이디값 넣음
	String memberId =(String)session.getAttribute("loginMemberId");
	System.out.println("카테고리삭제창 <--- categoryDeleteForm");
	
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
	// 삭제폼에서 삭제할 값을 입력하지않고 선택하기위하여 데이터를 가져옴
	/* 쿼리
		SELECT local_name FROM local	
	*/
	sql ="SELECT local_name localName FROM local	";
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
	<div>
		<jsp:include page="/inc/mainMenu.jsp"></jsp:include>
	</div>
	<br>
	<h2>지역 카테고리 삭제</h2>
	<!-- 오류 메시지 -->
	<%
	if(request.getParameter("msg") != null){
	%>
			<div><%=request.getParameter("msg")%></div>
	<%
	}
	%>
	<!-- 삭제 폼 -->
   	<form action="<%=request.getContextPath()%>/member/categoryDeleteAction.jsp" method="post">
     	 <!-- 비밀번호 확인 -->
		<table class="table table-striped">
	       	 <tr>
	            <th>아이디</th>
	            <td><input type="text" value="<%=memberId %>" readonly="readonly"></td>
	         </tr>
	         <tr>
	         	<th>삭제할 카테고리 이름</th>
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
				<th>삭제 카테고리 재확인</th>
	            <td><input type="text" name="deleteLocalName"></td>
	         </tr>
         </table>
         <button class="btn btn-outline-dark" type="submit">지역 삭제</button>
   </form>
   </div>
</body>
</html>