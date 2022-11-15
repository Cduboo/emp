<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<%@ page import="vo.*" %>
<%@ page import = "java.net.URLEncoder"%>
<%
	//인코딩
	request.setCharacterEncoding("utf-8");
	response.setContentType("text/html; charset=utf-8");
	response.setCharacterEncoding("utf-8");
	
	//1. 요청분석 
	if(request.getParameter("boardNo") == null || request.getParameter("boardPw") == null ||  request.getParameter("boardTitle") == null ||  request.getParameter("boardContent") == null 
		|| request.getParameter("boardPw").equals("") || request.getParameter("boardTitle").equals("") ||  request.getParameter("boardContent").equals("")){
		response.sendRedirect(request.getContextPath()+"/board/updateBoardForm.jsp");
		return;
	}
	int boardNo = Integer.parseInt(request.getParameter("boardNo"));
	String boardTitle = request.getParameter("boardTitle");
	String boardContent = request.getParameter("boardContent");
	String boardPw = request.getParameter("boardPw");
	Board b = new Board();
	b.boardNo = boardNo;
	b.boardTitle = boardTitle;
	b.boardContent = boardContent;
	b.boardPw = boardPw;
	
	//2.
	//db정보
	String url = "jdbc:mariadb://localhost:3306/employees";
	String user = "root";
	String password = "java1234";
	String sql = "UPDATE board SET board_title=?, board_content=? WHERE board_no = ? AND board_pw = ?";
	// mariadb 드라이버 로딩
	Class.forName("org.mariadb.jdbc.Driver");
	Connection conn = DriverManager.getConnection(url, user, password);
	
	// 쿼리 실행
	PreparedStatement stmt = conn.prepareStatement(sql);
	stmt.setString(1, b.boardTitle);
	stmt.setString(2, b.boardContent);
	stmt.setInt(3, b.boardNo);
	stmt.setString(4, b.boardPw);
	int row = stmt.executeUpdate();
	if(row != 1){
		String msg = URLEncoder.encode("잘못된 비밀번호","utf-8");
		response.sendRedirect(request.getContextPath()+"/board/updateBoardForm.jsp?boardNo="+b.boardNo+"&msg="+msg+"&boardTitle="+URLEncoder.encode(b.boardTitle, "UTF-8")+"&boardContent="+URLEncoder.encode(b.boardTitle, "UTF-8"));
		return;
	}
	response.sendRedirect(request.getContextPath()+"/board/boardList.jsp");
	
	stmt.close();
	conn.close();
%>