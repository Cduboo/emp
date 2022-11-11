<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@page import="vo.*"%>
<%@ page import="java.sql.*" %>
<%
	//인코딩
	request.setCharacterEncoding("utf-8");
	response.setContentType("text/html; charset=utf-8");
	response.setCharacterEncoding("utf-8");
	
	//1. 요청분석 
	if(request.getParameter("boardNo") == null || request.getParameter("boardNo").equals("")){
		response.sendRedirect(request.getContextPath()+"/board/boardList.jsp");
		return;
	}
 	int boardNo = Integer.parseInt(request.getParameter("boardNo"));

	//2.
	//db정보
	String url = "jdbc:mariadb://localhost:3306/employees";
	String user = "root";
	String password = "java1234";
	String sql = "SELECT board_title boardTitle, board_content boardContent, board_writer boardWriter, createdate FROM board WHERE board_no = ?";
	// mariadb 드라이버 로딩
	Class.forName("org.mariadb.jdbc.Driver");
	Connection conn = DriverManager.getConnection(url, user, password);
	
	// 쿼리 실행
	PreparedStatement stmt = conn.prepareStatement(sql);
	stmt.setInt(1, boardNo);
	ResultSet rs = stmt.executeQuery();
	Board b = null;
	if(rs.next()){
		b = new Board();
		b.boardNo = boardNo;
		b.boardTitle = rs.getString("boardTitle");
		b.boardContent = rs.getString("boardContent");
		b.boardWriter = rs.getString("boardWriter");
		b.createdate = rs.getString("createdate");
	}
%>
<!DOCTYPE html>
<html>
	<head>
		<meta charset="UTF-8">
		<title>board one</title>
		<link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@4.1.3/dist/css/bootstrap.min.css" integrity="sha384-MCw98/SFnGE8fJT3GXwEOngsV7Zt27NXFoaoApmYm81iuXoPkFOJwJ8ERdknLPMO" crossorigin="anonymous">
		<script src="https://code.jquery.com/jquery-3.3.1.slim.min.js" integrity="sha384-q8i/X+965DzO0rT7abK41JStQIAqVgRVzpbzo5smXKp4YfRvH+8abtTE1Pi6jizo" crossorigin="anonymous"></script>
		<script src="https://cdn.jsdelivr.net/npm/popper.js@1.14.3/dist/umd/popper.min.js" integrity="sha384-ZMP7rVo3mIykV+2+9J3UJ46jBk0WLaUAdn689aCwoqbBJiSnjAK/l8WvCWPIPm49" crossorigin="anonymous"></script>
		<script src="https://cdn.jsdelivr.net/npm/bootstrap@4.1.3/dist/js/bootstrap.min.js" integrity="sha384-ChfqqxuZUCnJSK3+MXmPNIyE6ZbWh2IMqE241rYiqJxyMiZ6OW/JmZQ5stwEULTy" crossorigin="anonymous"></script>
	</head>
	<body>
		<div class="container mt-5">
			<div class="fw-bold text-left font-weight-bold"><h3>게시글</h3></div>
			<table class="table table-bordered">
					<td>글번호 : <%=b.boardNo%></td>
					<td>제목 : <%=b.boardTitle%></td>
					<td>글쓴이 : <%=b.boardWriter%></td>
					<td>작성일자 : <%=b.createdate%></td>
				<tr>
					<td colspan="4">
						<%=b.boardContent%>
					</td>
			</table>
			<div class="float-right">
				<a class="btn btn-sm btn-outline-info mr-3" href="<%=request.getContextPath()%>/board/updateBoardForm.jsp?boardNo=<%=b.boardNo%>">수정</a>
				<a class="btn btn-sm btn-outline-info mr-3" href="<%=request.getContextPath()%>/board/deleteBoardForm.jsp?boardNo=<%=b.boardNo%>">삭제</a>
				<a class="btn btn-sm btn-outline-info mr-3" href="<%=request.getContextPath()%>/board/boardList.jsp">목록</a>
			</div>
		</div>
	</body>
</html>