<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import = "java.sql.*"%>
<%@ page import = "java.net.*" %>
<%
	request.setCharacterEncoding("utf-8");
	// 오류메세지를 보낼 변수 msg
	String msg = "";
	// 1.요청분석 컨트롤러 계층
	if(session.getAttribute("loginMemberId") == null) {
		msg = URLEncoder.encode("로그인이 안되어 있습니다.", "utf-8");
		response.sendRedirect(request.getContextPath()+"/home.jsp?msg="+msg);
		return;
	}

	// 아이디값과 비밀번호값이 null이거나 공백이면 탈퇴폼으로 다시 보냄
	if(request.getParameter("memberId") == null
		|| request.getParameter("memberPw") == null
        || request.getParameter("memberId").equals("") 
        || request.getParameter("memberPw").equals("")) {
		msg = URLEncoder.encode("아이디 또는 비밀번호를 입력하지 않았습니다.", "utf-8");
        response.sendRedirect(request.getContextPath()+"/member/deleteMemberForm.jsp?msg="+msg);
        return;
    }
   	// 값이 있으면 변수에 값을 넣음
    String memberId = request.getParameter("memberId");
    String memberPw = request.getParameter("memberPw");
   
    // 디버깅
    System.out.println(memberId + " <--deleteMemberAction para memberId"); 
    System.out.println(memberPw + " <--deleteMemberAction para memberPw"); 
   
    // 2.모델 계층
    //db 연동
    String driver = "org.mariadb.jdbc.Driver";
    String dburl = "jdbc:mariadb://127.0.0.1:3306/userboard";
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
   
    /* 쿼리문
   		delete from member 
   		where member_id = ? and member_pw = password(?)
    */
    sql="delete from member where member_id = ? and member_pw = password(?)";
    stmt = conn.prepareStatement(sql);
    stmt.setString(1, memberId);
    stmt.setString(2, memberPw);
   
    int row = stmt.executeUpdate(); // member_id가 외래키 설정되어있어 예외 발생 -> 일단 cascade로 변경
   
    System.out.println(stmt + " <--- deleteMemberAction stmt");
    System.out.println(row + " <--- deleteMemberAction row");
   
   	if (row == 1){
       	response.sendRedirect(request.getContextPath()+"/home.jsp");
      	session.invalidate();
      	System.out.println("회원탈퇴 성공 <--- deleteMemberAction");
       return;
    } else {
		msg = URLEncoder.encode("비밀번호가 맞지 않습니다.", "utf-8");
       	response.sendRedirect(request.getContextPath()+"/member/deleteMemberForm.jsp?msg="+msg);
       	System.out.println("회원탈퇴 실패 <--- deleteMemberAction");
    }

%>