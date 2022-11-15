<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<%
	//인코딩
	request.setCharacterEncoding("utf-8");
	response.setContentType("text/html; charset=utf-8");
	response.setCharacterEncoding("utf-8");
	
	//1) 요청 분석(Controller)
	if(request.getParameter("boardPw")==null || request.getParameter("boardTitle")==null ||  request.getParameter("boardContent")==null || request.getParameter("boardPw").equals("") || request.getParameter("boardTitle").equals("") || request.getParameter("boardContent").equals("") || request.getParameter("boardWriter").equals("")){
		response.sendRedirect(request.getContextPath()+"/board/boardList.jsp");
		return;
	}
	String boardPw = request.getParameter("boardPw");
	String boardTitle = request.getParameter("boardTitle");
	String boardContent = request.getParameter("boardContent");		
	String boardWriter = request.getParameter("boardWriter");
	
	//2.
	//db정보
	String url = "jdbc:mariadb://localhost:3306/employees";
	String user = "root";
	String password = "java1234";
	String sql = "INSERT INTO board(board_pw, board_title, board_content, board_writer, createdate) VALUES(?,?,?,?,CURDATE());";
	// mariadb 드라이버 로딩
	Class.forName("org.mariadb.jdbc.Driver");
	Connection conn = DriverManager.getConnection(url, user, password);

	// 쿼리 실행
	PreparedStatement stmt = conn.prepareStatement(sql);
	stmt.setString(1, boardPw);
	stmt.setString(2, boardTitle);
	stmt.setString(3, boardContent);
	stmt.setString(4, boardWriter);
	int row = stmt.executeUpdate();
	
	response.sendRedirect(request.getContextPath()+"/board/boardList.jsp");
	
	stmt.close();
	conn.close();
%>