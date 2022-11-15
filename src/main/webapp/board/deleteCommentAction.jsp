<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<%@ page import = "java.net.URLEncoder"%>
<%
	//인코딩
	request.setCharacterEncoding("utf-8");
	response.setContentType("text/html; charset=utf-8");
	response.setCharacterEncoding("utf-8");
	
	//1. 요청분석 
	if(request.getParameter("boardNo") == null || request.getParameter("boardNo").equals("") || request.getParameter("commentNo") == null || request.getParameter("commentNo").equals("") || request.getParameter("commentPw") == null || request.getParameter("commentPw").equals("")){
		response.sendRedirect(request.getContextPath()+"/board/boardList.jsp");
		return;
	}
	int boardNo = Integer.parseInt(request.getParameter("boardNo"));
	int commentNo = Integer.parseInt(request.getParameter("commentNo"));
	String commentPw = request.getParameter("commentPw");
	
	//2.
	//db정보
	String url = "jdbc:mariadb://localhost:3306/employees";
	String user = "root";
	String password = "java1234";
	String sql = "DELETE FROM COMMENT WHERE comment_no = ? AND comment_pw = ?";
	// mariadb 드라이버 로딩
	Class.forName("org.mariadb.jdbc.Driver");
	Connection conn = DriverManager.getConnection(url, user, password);
		
	// 쿼리 실행
	PreparedStatement stmt = conn.prepareStatement(sql);
	stmt.setInt(1, commentNo);
	stmt.setString(2, commentPw);
	int row = stmt.executeUpdate();
	if(row == 1){
		response.sendRedirect(request.getContextPath()+"/board/boardOne.jsp?boardNo="+boardNo);
	}else{
		String msg = URLEncoder.encode("잘못된 비밀번호","utf-8");
		response.sendRedirect(request.getContextPath()+"/board/deleteCommentForm.jsp?boardNo="+boardNo+"&commentNo="+commentNo+"&msg="+msg);
	}
	
	stmt.close();
	conn.close();
%>