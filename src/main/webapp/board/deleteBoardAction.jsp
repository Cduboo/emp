<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@page import="vo.*"%>
<%@ page import="java.sql.*" %>
<%@ page import = "java.net.URLEncoder"%>
<%	
	//인코딩
	request.setCharacterEncoding("utf-8");
	response.setContentType("text/html; charset=utf-8");
	response.setCharacterEncoding("utf-8");
	
	//1. 요청분석 
	if(request.getParameter("boardNo") == null || request.getParameter("boardPw") == null || request.getParameter("boardPw").equals("") || request.getParameter("boardNo").equals("")){
		response.sendRedirect(request.getContextPath()+"/board/boardList.jsp");
		return;
	}
	Board b = new Board();
	b.boardNo = Integer.parseInt(request.getParameter("boardNo"));
	b.boardPw = request.getParameter("boardPw");
	
	//2.
	//db정보
	String url = "jdbc:mariadb://localhost:3306/employees";
	String user = "root";
	String password = "java1234";
	String sql = "DELETE FROM board WHERE board_no = ? AND board_pw = ?";
	// mariadb 드라이버 로딩
	Class.forName("org.mariadb.jdbc.Driver");
	Connection conn = DriverManager.getConnection(url, user, password);
		
	// 쿼리 실행
	PreparedStatement stmt = conn.prepareStatement(sql);
	stmt.setInt(1, b.boardNo);
	stmt.setString(2, b.boardPw);
	int row = stmt.executeUpdate();
	if(row == 1){
		response.sendRedirect(request.getContextPath()+"/board/boardList.jsp");
	}else{
		String msg = URLEncoder.encode("잘못된 비밀번호","utf-8");
		response.sendRedirect(request.getContextPath()+"/board/deleteBoardForm.jsp?boardNo="+b.boardNo+"&msg="+msg);
	}
%>
