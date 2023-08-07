<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<style>
   #nav_menu ul {
      list-style-type:none;
      /* 좌측 여백 없애기 */
      padding-left:0px;
      
      /* 우측 정렬 하기 */
      float:right;
   }
   
   #nav_menu ul li {
      display:inline;
      border-left: 1px solid #c0c0c0;
      /* 테두리와 메뉴 간격 벌리기. padding: 위 오른쪽 아래 왼쪽; */
      padding: 0px 10px 0px 10px;
      
      /* 메뉴와 테두리 사이 간격 벌리기. margin: 위 오른쪽 아래 왼쪽; */
      margin: 5px 0px 5px 0px;
   }
   
   #nav_menu ul li:first-child {
      border-left: none;
</style>

<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.2.3/dist/css/bootstrap.min.css" rel="stylesheet">
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.2.3/dist/js/bootstrap.bundle.min.js"></script>
<div class="row">
<div class="col-sm-3 container"></div>
<div class="col-sm-6 container">


	<ul class="nav nav-tabs">
		<!--  -->
		<li class="nav-item"><a class="nav-link" style="color: black;" href="<%=request.getContextPath()%>/home.jsp">홈으로</a></li>
		
		<!-- 로그인전 : 회원가입 
			 로그인후 : 회원정보 / 로그아웃 (로그인정보 세션 loginMemberId
		-->
		
		<%
			if(session.getAttribute("loginMemberId") == null) {	// 로그인전
		%>
				<li class="nav-item list-group-item-primary"><a class="nav-link" style="color: black;" href="<%=request.getContextPath()%>/member/insertMemberForm.jsp">회원가입</a></li>
		<% 
			} else {	//로그인후
		%>
				<li class="nav-item"><a class="nav-link" style="color: black;" href="<%=request.getContextPath()%>/member/memberInfo.jsp">회원정보</a></li>
				<li class="nav-item"><a class="nav-link" style="color: black;" href="<%=request.getContextPath()%>/inc/categoryOptionForm.jsp">지역카테고리 설정</a></li>
				<li class="nav-item"><a class="nav-link" style="color: black;" href="<%=request.getContextPath()%>/board/boardInsertForm.jsp">게시글 추가</a></li>
				<li class="nav-item"><a class="nav-link" style="color: black;" href="<%=request.getContextPath()%>/member/logoutAction.jsp">로그아웃</a></li>
		<% 	
			}
		%>
	</ul>
</div>
<div class="col-sm-3 container">
</div>
</div>
