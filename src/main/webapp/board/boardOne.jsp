<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@page import="vo.*"%>
<%@ page import="java.sql.*" %>
<%@ page import="java.util.*" %>
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
 	// 댓글 페이징
	int currentPage = 1;
	if(request.getParameter("currentPage") != null){
		currentPage = Integer.parseInt(request.getParameter("currentPage"));
	}
	
	//2.
	//db정보
	String url = "jdbc:mariadb://localhost:3306/employees";
	String user = "root";
	String password = "java1234";
	String boardSql = "SELECT board_title boardTitle, board_content boardContent, board_writer boardWriter, createdate FROM board WHERE board_no = ?";
	String commentSql = "SELECT comment_no commentNo, comment_content commentContent, createdate FROM comment WHERE board_no = ? ORDER BY comment_no DESC LIMIT ?,?";
	String commentCountSql = "SELECT COUNT(*) count FROM comment WHERE board_no = ?";
	// mariadb 드라이버 로딩
	Class.forName("org.mariadb.jdbc.Driver");
	Connection conn = DriverManager.getConnection(url, user, password);
	
	// 쿼리 실행
	PreparedStatement boardStmt = conn.prepareStatement(boardSql);
	boardStmt.setInt(1, boardNo);
	ResultSet boardRs = boardStmt.executeQuery();
	Board b = null;
	if(boardRs.next()){
		b = new Board();
		b.boardNo = boardNo;
		b.boardTitle = boardRs.getString("boardTitle");
		b.boardContent = boardRs.getString("boardContent");
		b.boardWriter = boardRs.getString("boardWriter");
		b.createdate = boardRs.getString("createdate");
	}
	
	// 댓글
	// 1. 요청분석
	int rowPerPage = 5; // 한 페이지 댓글 수
	int beginRow = (currentPage -1) * rowPerPage;
	int commentCnt = 0;
	int lastPage = 0;
	
	// 댓글 출력 쿼리
	PreparedStatement commentStmt = conn.prepareStatement(commentSql);
	commentStmt.setInt(1, boardNo);
	commentStmt.setInt(2, beginRow);
	commentStmt.setInt(3, rowPerPage);
	
	ResultSet commentRs = commentStmt.executeQuery();
	ArrayList<Comment> commentList = new ArrayList<>();
	while(commentRs.next()){
		Comment c = new Comment();
		c.commentNo = commentRs.getInt("commentNo");
		c.commentContent = commentRs.getString("commentContent");
		c.createdate = commentRs.getString("createdate");
		commentList.add(c);
	}
	
	// 전체 댓글 수 검색 쿼리
	PreparedStatement commentCountStmt = conn.prepareStatement(commentCountSql);
	commentCountStmt.setInt(1, boardNo);
	ResultSet commentCountRs = commentCountStmt.executeQuery();
	if(commentCountRs.next()){
		commentCnt = commentCountRs.getInt("count");
	}
	lastPage = commentCnt / rowPerPage ;
	if(commentCnt %  rowPerPage!= 0){
		lastPage = lastPage + 1;
	}
	 	System.out.println("count" + commentCnt);
		System.out.println("lastPage" + lastPage); 
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
		<link rel="stylesheet" href="../css/style.css">
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
			<div class="text-right">
				<a class="btn btn-sm btn-outline-info mr-3" href="<%=request.getContextPath()%>/board/updateBoardForm.jsp?boardNo=<%=b.boardNo%>">게시글 수정</a>
				<a class="btn btn-sm btn-outline-info mr-3" href="<%=request.getContextPath()%>/board/deleteBoardForm.jsp?boardNo=<%=b.boardNo%>">게시글 삭제</a>
				<a class="btn btn-sm btn-outline-info mr-3" href="<%=request.getContextPath()%>/board/boardList.jsp">목록</a>
			</div>
		</div>
		<!-- 댓글 목록 -->
		<div class="container mt-5">
			<div class="fw-bold text-left font-weight-bold p-3" style="background-color : #6a89cc; color:white;"><h3>댓글목록</h3></div>
			<%
				for(Comment c : commentList){
			%>
					<div class="card mt-3">
					  <div class="card-body">
					    <h5 class="card-title"><%=c.commentContent%></h5>
					    <h6 class="card-subtitle mb-2 text-muted"><%=c.createdate%></h6>
					    <div class="text-right">
					    	<a  class="card-link" href="<%=request.getContextPath()%>/board/deleteCommentForm.jsp?commentNo=<%=c.commentNo%>&boardNo=<%=boardNo%>">삭제</a>
					    </div>
					  </div>
					</div>	
			<%
				}
			%>
			<!-- 댓글 페이징 -->
			<div class="text-right">page : <%=currentPage%> / <%=lastPage%></div>
			<div class="text-center m-5">
			<a class="btn btn-sm btn-outline-info mr-3" href="<%=request.getContextPath()%>/board/boardOne.jsp?boardNo=<%=boardNo%>&currentPage=1">&lt;첫페이지</a>
			<%
				if(currentPage > 1){
			%>
					<a class="btn btn-sm btn-outline-info mr-3" href="<%=request.getContextPath()%>/board/boardOne.jsp?boardNo=<%=boardNo%>&currentPage=<%=currentPage-1%>">&lt;이전</a>
			<%		
				}
			
				if(currentPage < lastPage){
			%>
					<a class="btn btn-sm btn-outline-info mr-3" href="<%=request.getContextPath()%>/board/boardOne.jsp?boardNo=<%=boardNo%>&currentPage=<%=currentPage+1%>">다음&gt;</a>
			<%		
				}
			%>
			<a class="btn btn-sm btn-outline-info mr-3" href="<%=request.getContextPath()%>/board/boardOne.jsp?boardNo=<%=boardNo%>&currentPage=<%=lastPage%>">마지막페이지&gt;</a>
			</div>
		</div>
		<!-- 댓글입력 폼 -->
		<div class="container mt-5">
			<div class="fw-bold text-left font-weight-bold p-3" style="background-color : #6a89cc; color:white;"><h3>댓글입력</h3></div>
			<form action="<%=request.getContextPath()%>/board/insertCommentAction.jsp" method="post">
				<input type="hidden" name="boardNo" value="<%=b.boardNo%>">
				<table class="table table-bordered">
						<%
							if(request.getParameter("msg") == null){
						%>
								<tr>
									<td>내용</td>
									<td><textarea class="form-control" rows="3" cols="80" name="commentContent" required></textarea></td>
								</tr>
								<tr>
									<td>비밀번호</td>
									<td><input class="form-control" type="password" name="commentPw"></td>							
								</tr>
						<%		
							}else{
						%>
								<div class="text-danger"><%=request.getParameter("msg")%></div>
								<tr>
									<td>내용</td>
									<td><textarea class="form-control" rows="3" cols="80" name="commentContent" required></textarea></td>
								</tr>
								<tr>
									<td>비밀번호</td>
									<td><input class="form-control" type="password" name="commentPw"></td>							
								</tr>
						<%		
							}
						%>
				</table>
				<div class="text-right mb-5">
					<button class="btn btn-sm btn-outline-info mr-3" type="submit">댓글입력</button>
				</div>
			</form>
		</div>
	</body>
</html>