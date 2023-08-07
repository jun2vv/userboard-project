<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import = "java.sql.*" %>
<%@ page import = "java.net.*" %>
<%@ page import = "vo.*" %>

<%
	// 회원가입 데이터 창
	request.setCharacterEncoding("utf-8");
	//오류메세지를 보낼 변수 msg
	String msg = "";
	System.out.println(request.getParameter("memberId")+ "<--- insertAction memberId");
	System.out.println(request.getParameter("memberPw")+ "<--- insertAction memberPw");
	
	// 세션 유효성 검사. 
	// 로그인이 되어 있을시 회원가입 화면에 올 수 없음.
	if(session.getAttribute("loginMemberId") != null) {
		msg = URLEncoder.encode("이미 로그인 했습니다.", "utf-8");
		response.sendRedirect(request.getContextPath()+"/home.jsp?msg="+msg);
		return;
	}
	
	//1.컨트롤러 계층
	// 회원가입창에서 보낸 memberId와 memberPw

	if(request.getParameter("memberId")==null 
		|| request.getParameter("memberPw")==null 
		|| request.getParameter("memberId").equals("")
		|| request.getParameter("memberPw").equals("")){
		System.out.println("null 또는 공백값 존재 <--- insertAction 요청값 유효성검사. ");
		msg = URLEncoder.encode(" 아이디 또는 비밀번호를 입력하지 않았습니다.", "utf-8");
		response.sendRedirect(request.getContextPath() + "/member/insertMemberForm.jsp?msg="+msg);
		return;
	}
	//요청값 변수 저장
	String memberId = request.getParameter("memberId");
	String memberPw = request.getParameter("memberPw");
	
	//디버깅
	System.out.println(memberId + "<---  para insertAction memberId ");
	System.out.println(memberPw + "<---  para insertAction memberPw ");

	//db 연동변수
	String driver = "org.mariadb.jdbc.Driver";
	String dburl = "jdbc:mariadb://3.37.133.115:3306/userboard";
	String dbuser = "root";
	String dbpw = "java1234";
	
	// db연동 및 동적쿼리를위한 변수 선언
	Class.forName(driver);
	Connection conn = null;
	PreparedStatement stmt = null;
	ResultSet rs = null;
	conn = DriverManager.getConnection(dburl, dbuser, dbpw);
	
	// 디버깅
	System.out.println("<--- insertAction 드라이버 실행확인 ");
	System.out.println(conn + "<--- insertAction conn ");
	
	// 중복아이디 방지 쿼리문 변수.
	PreparedStatement checkStmt = null;
	ResultSet checkRs = null;
	/* Check쿼리문
		"SELECT count(*) as cnt FROM member WHERE member_id = ?"
	*/
	String CheckSql ="SELECT count(*) FROM member WHERE member_id = ?";
	checkStmt = conn.prepareStatement(CheckSql);
	checkStmt.setString(1, memberId);
	checkRs = checkStmt.executeQuery();
	// 중복된 값이 있을시 중복아이디 수를 넣기 위한 변수cnt
	int cnt = 0;
	// next()를 돌려 중복값이 있을시 cnt에 1씩 오름
	if(checkRs.next()){
		cnt = checkRs.getInt("count(*)");
	}
	// cnt가0보다 크면 중복값이 존재하기에 다시 회원가입창으로 돌려봰ㅁ.
	if (cnt > 0) {
	    // 이미 존재하는 아이디이므로 회원가입 실패 처리
	    System.out.println("중복된 아이디 존재");
	   	msg = URLEncoder.encode("아이디가 중복됩니다 다른 아이디를 사용하세요.", "utf-8");
	    response.sendRedirect(request.getContextPath() + "/member/insertMemberForm.jsp?msg="+msg);
	    return;
	}
	// 디버깅
	System.out.println(checkStmt + "<--- insertAction checkStmt ");
	System.out.println(checkRs + "<--- insertAction checkRs ");
	
	// 데이터 추가 모델
	/* 쿼리문2
		"INSERT INTO member(member_id memberId, member_pw memberPw, createdate, updatedate) 
		VALUES(?, PASSWORD(?), now(), now())"
	*/
	String sql = "INSERT INTO member(member_id, member_pw, createdate, updatedate) VALUES(?, PASSWORD(?), now(), now())";
	stmt = conn.prepareStatement(sql);
	stmt.setString(1, memberId);
	stmt.setString(2, memberPw);
	// INSERT는 Update사용
	int row = stmt.executeUpdate();
	
	System.out.println(row + "<--- insertAction row ");
	
	// row==1이면 입력완료 0이면 입력실패
	if(row==1) {
		System.out.println(row + "<--- insertAction 회원가입완료");
		response.sendRedirect(request.getContextPath()+"/home.jsp");
	} else {
		System.out.println(row + "<--- insertAction 회원가입실패");
		msg = URLEncoder.encode("회원가입 실패 다시 회원가입하세요.", "utf-8");
		response.sendRedirect(request.getContextPath() + "/member/insertMemberForm.jsp?msg="+msg);
	}
	
	
	
	
			
%>
