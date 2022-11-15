<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<%@ page import = "java.net.URLEncoder"%>
<%
	//인코딩
	request.setCharacterEncoding("utf-8");
	response.setContentType("text/html; charset=utf-8");
	response.setCharacterEncoding("utf-8");
	
	//1. 요청분석
	int boardNo = Integer.parseInt(request.getParameter("boardNo"));
	if(request.getParameter("commentContent") == null || request.getParameter("commentContent").equals("") || request.getParameter("commentPw") == null || request.getParameter("commentPw").equals("")){
		String msg = URLEncoder.encode("내용과 비밀번호를 입력해주세요.","utf-8");
		response.sendRedirect(request.getContextPath()+"/board/boardOne.jsp?boardNo="+boardNo+"&msg="+msg);
		return;
	}
	String commentContent = request.getParameter("commentContent");
	String commentPw = request.getParameter("commentPw");
	
	//2.
	//db정보
	String url = "jdbc:mariadb://localhost:3306/employees";
	String user = "root";
	String password = "java1234";
	String sql = "INSERT INTO COMMENT(board_no, comment_pw, comment_content, createdate) VALUES(?,?,?,CURDATE())";
	// mariadb 드라이버 로딩
	Class.forName("org.mariadb.jdbc.Driver");
	Connection conn = DriverManager.getConnection(url, user, password);
	
	// 쿼리 실행
	PreparedStatement stmt = conn.prepareStatement(sql);
	stmt.setInt(1, boardNo);
	stmt.setString(2, commentPw);
	stmt.setString(3, commentContent);
	int row = stmt.executeUpdate();
	if(row == 1){
		response.sendRedirect(request.getContextPath()+"/board/boardOne.jsp?boardNo="+boardNo);
	}
	
	stmt.close();
	conn.close();
%>
