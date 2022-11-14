<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<%@ page import="vo.*" %>
<%@ page import="java.util.*" %>
<%
	//인코딩
	request.setCharacterEncoding("utf-8");
	response.setContentType("text/html; charset=utf-8");
	response.setCharacterEncoding("utf-8");
	//1. 요청분석
	int currentPage = 1; //기본 페이지 1
	//페이지 값이 넘어 오면 페이지 값 대입  
	if(request.getParameter("currentPage") != null){
		currentPage = Integer.parseInt(request.getParameter("currentPage"));
	}
	String word = request.getParameter("word");
	
	//2. 요청처리
	final int ROW_PER_PAGE = 10; // 한 페이지에 보여줄 데이터 수
	int beginRow = (currentPage-1) * ROW_PER_PAGE; // 출력 시작 번호
	int cnt = 0; // 전체 행의 수(데이터 수)
	int lastPage = 0; // 마지막 페이지
	
	//db정보
	String url = "jdbc:mariadb://localhost:3306/employees";
	String user = "root";
	String password = "java1234";
	Class.forName("org.mariadb.jdbc.Driver");
	Connection conn = DriverManager.getConnection(url, user, password);
	String cntSql = null;
	String listSql = null;
	PreparedStatement cntStmt = null;
	PreparedStatement listStmt = null;
	
	if(word == null){
		cntSql = "SELECT COUNT(*) cnt FROM board";
		cntStmt = conn.prepareStatement(cntSql);
		
		listSql = "SELECT board_no boardNo, board_title boardTitle, board_content boardContent, board_writer boardWriter, createdate FROM board ORDER BY board_no DESC LIMIT ?,?";
		listStmt = conn.prepareStatement(listSql);
		listStmt.setInt(1, beginRow);
		listStmt.setInt(2, ROW_PER_PAGE);
	}else{
		cntSql = "SELECT COUNT(*) cnt FROM board WHERE board_title LIKE ?";
		cntStmt = conn.prepareStatement(cntSql);
		cntStmt.setString(1, "%"+word+"%");
		
		listSql = "SELECT board_no boardNo, board_title boardTitle, board_content boardContent, board_writer boardWriter, createdate FROM board WHERE board_title LIKE ? ORDER BY board_no DESC LIMIT ?,?";
		listStmt = conn.prepareStatement(listSql);
		listStmt.setString(1, "%"+word+"%");
		listStmt.setInt(2, beginRow);
		listStmt.setInt(3, ROW_PER_PAGE);
	}
	

	
	ResultSet cntRs = cntStmt.executeQuery();
	if(cntRs.next()){
		cnt = cntRs.getInt("cnt");
	}
	// 마지막 페이지 구하기
	lastPage = (int)(Math.ceil((double)cnt / (double)ROW_PER_PAGE));

	ResultSet listRs = listStmt.executeQuery();
	ArrayList<Board> boardList = new ArrayList<>();
	while(listRs.next()){
		Board b = new Board();
		b.boardNo = listRs.getInt("boardNo");
		b.boardTitle = listRs.getString("boardTitle");
		b.boardContent = listRs.getString("boardContent");
		b.boardWriter = listRs.getString("boardWriter");
		b.createdate = listRs.getString("createdate");
		boardList.add(b);
	}
%>
<!DOCTYPE html>
<html>
	<head>
		<meta charset="UTF-8">
		<title>board list</title>
		<link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@4.1.3/dist/css/bootstrap.min.css" integrity="sha384-MCw98/SFnGE8fJT3GXwEOngsV7Zt27NXFoaoApmYm81iuXoPkFOJwJ8ERdknLPMO" crossorigin="anonymous">
		<script src="https://code.jquery.com/jquery-3.3.1.slim.min.js" integrity="sha384-q8i/X+965DzO0rT7abK41JStQIAqVgRVzpbzo5smXKp4YfRvH+8abtTE1Pi6jizo" crossorigin="anonymous"></script>
		<script src="https://cdn.jsdelivr.net/npm/popper.js@1.14.3/dist/umd/popper.min.js" integrity="sha384-ZMP7rVo3mIykV+2+9J3UJ46jBk0WLaUAdn689aCwoqbBJiSnjAK/l8WvCWPIPm49" crossorigin="anonymous"></script>
		<script src="https://cdn.jsdelivr.net/npm/bootstrap@4.1.3/dist/js/bootstrap.min.js" integrity="sha384-ChfqqxuZUCnJSK3+MXmPNIyE6ZbWh2IMqE241rYiqJxyMiZ6OW/JmZQ5stwEULTy" crossorigin="anonymous"></script>
		<link rel="stylesheet" href="../css/style.css">
	</head>
	<body>
		<!-- nav -->
		<jsp:include page="/inc/menu.jsp"></jsp:include>
		<!-- 본문 -->
		<div>
			<h1 class="pb-1 pt-1">BOARD</h1>	
		</div>	
		<div class="font-weight-bold">
			<h2 class="pb-1 pt-1">게시판</h2>
			<a class="btn btn-info float-right mr-3 mb-3" href="<%=request.getContextPath()%>/board/insertBoardForm.jsp">글쓰기</a>
			<div style="position: relative;">
				<!-- 부서명 검색창 -->
				<%
					if(word == null){
				%>
						<form action="<%=request.getContextPath()%>/board/boardList.jsp" method="post">
							<label for="word">제목 검색 : </label>
							<input type="text" id="word" name="word">
							<button type="submit">검색</button>
						</form>
				<%
					}else{
				%>
						<form action="<%=request.getContextPath()%>/board/boardList.jsp" method="post">
							<label for="word">제목 검색 : </label>
							<input type="text" id="word" name="word" value="<%=word%>">
							<button type="submit">검색</button>
						</form>
				<%		
					}
				%>
				<!-- 페이징 코드 -->
				<div class="d-flex" style="position: absolute; top:0; left:350px">
					<%
						if(word == null){
					%>
							<div class="text-center">
								<a href="<%=request.getContextPath()%>/board/boardList.jsp?currentPage=1"><button>&lt;&lt;</button></a>
								<%
									if(currentPage > 1){
								%>
										<a href="<%=request.getContextPath()%>/board/boardList.jsp?currentPage=<%=currentPage-1%>"><button>&lt;</button></a>
								<%		
									}
								
									if(currentPage < lastPage){
								%>
										<a href="<%=request.getContextPath()%>/board/boardList.jsp?currentPage=<%=currentPage+1%>"><button>&gt;</button></a>
								<%		
									}
								%>
								<a href="<%=request.getContextPath()%>/board/boardList.jsp?currentPage=<%=lastPage%>"><button>&gt;&gt;</button></a>
							</div>
							<div class="text-right ml-3"><div class="text-right">page : <%=currentPage%> / <%=lastPage%></div></div>
					<%
						}else{
					%>
							<div class="text-center">
								<a href="<%=request.getContextPath()%>/board/boardList.jsp?currentPage=1&word=<%=word%>"><button>&lt;&lt;</button></a>
								<%
									if(currentPage > 1){
								%>
										<a href="<%=request.getContextPath()%>/board/boardList.jsp?currentPage=<%=currentPage-1%>&word=<%=word%>"><button>&lt;</button></a>
								<%		
									}
								
									if(currentPage < lastPage){
								%>
										<a href="<%=request.getContextPath()%>/board/boardList.jsp?currentPage=<%=currentPage+1%>&word=<%=word%>"><button>&gt;</button></a>
								<%		
									}
								%>
								<a href="<%=request.getContextPath()%>/board/boardList.jsp?currentPage=<%=lastPage%>&word=<%=word%>"><button>&gt;&gt;</button></a>
							</div>
							<div class="text-right ml-3"><div class="text-right">page : <%=currentPage%> / <%=lastPage%></div></div>
					<%		
						}
					%>
				</div>
			</div>
			
			<table class="table table-striped table-hover">
				<thead class="sticky-top">
					<th scope="col">NO</th>
					<th scope="col">제목</th>
					<th scope="col">내용</th>
					<th scope="col">글쓴이</th>
					<th scope="col">작성일</th>
				</thead>
				<tbody>
					<%
					for(Board b : boardList){
					%>
						<tr>
							<td style="width:10%"><%=b.boardNo%></td>
							<td class="text-truncate" style="width:20%">
								<a href="<%=request.getContextPath()%>/board/boardOne.jsp?boardNo=<%=b.boardNo%>">
									<%=b.boardTitle%>
								</a>
							</td>
							<td class="text-truncate" style="width:50%; max-width: 500px;"><%=b.boardContent%></td>
							<td style="width:10%"><%=b.boardWriter%></td>
							<td style="width:10%"><%=b.createdate%></td>
						</tr>
					<%		
						}
					%>
				</tbody>
			</table>
		</div>
	</body>
</html>