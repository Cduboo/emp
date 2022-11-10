<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<%@ page import="vo.*" %>
<%@ page import="java.util.*" %>
<%
	//1. 요청분석
	int currentPage = 1; //기본 페이지 1
	//페이지 값이 넘어 오면 페이지 값 대입  
	if(request.getParameter("currentPage") != null){
		currentPage = Integer.parseInt(request.getParameter("currentPage"));
	}
	
	//2. 요청처리
	final int ROW_PER_PAGE = 10; // 한 페이지에 보여줄 데이터 수
	int beginRow = (currentPage-1) * ROW_PER_PAGE; // 출력 시작 번호
	int cnt = 0; // 전체 행의 수(데이터 수)
	int lastPage = 0;
	
	//db정보
	String url = "jdbc:mariadb://localhost:3306/employees";
	String user = "root";
	String password = "java1234";
	String cntSql = "SELECT COUNT(*) cnt FROM board";
	String listSql = "SELECT board_no boardNo, board_title boardTitle FROM board ORDER BY board_no ASC LIMIT ?,?";

	Class.forName("org.mariadb.jdbc.Driver"); // mariadb 드라이버 로딩
	Connection conn = DriverManager.getConnection(url, user, password); // 연결
	
	// 전체 행의 수(데이터 수) 출력 쿼리 준비
	PreparedStatement cntStmt = conn.prepareStatement(cntSql);
	ResultSet cntRs = cntStmt.executeQuery();
	// 전체 행의 수(데이터 수) 출력 쿼리 실행
	if(cntRs.next()){
		cnt = cntRs.getInt("cnt");
	}
	// 마지막 페이지 구하기
	lastPage = (int)(Math.ceil((double)cnt / (double)ROW_PER_PAGE));

	// 리스트 출력 쿼리 준비
	PreparedStatement listStmt = conn.prepareStatement(listSql);
	listStmt.setInt(1, beginRow);
	listStmt.setInt(2, ROW_PER_PAGE);
	// 리스트 출력 쿼리 실행
	ResultSet listRs = listStmt.executeQuery();
	ArrayList<Board> boardList = new ArrayList<>();
	while(listRs.next()){
		Board b = new Board();
		b.boardNo = listRs.getInt("boardNo");
		b.boardTitle = listRs.getString("boardTitle");
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
			<h1 class="pb-1 pt-1">자유 게시판</h1>	
		</div>	
		<div class="font-weight-bold">
			<h2 class="pb-1 pt-1">📃 게시판</h2>
			<a class="btn btn-info float-right mr-3 mb-3" href="#">글쓰기</a>
			<table class="table table-striped table-hover">
				<thead class="sticky-top">
					<th scope="col">제목</th>
					<th scope="col">내용</th>
				</thead>
				<tbody>
					<%
					for(Board b : boardList){
					%>
						<tr>
							<td><%=b.boardNo %></td>
							<td><a href="<%=request.getContextPath()%>/board/boardOne.jsp?boardNo="<%=b.boardNo%>><%=b.boardTitle%></a></td>
						</tr>
					<%		
						}
					%>
				</tbody>
			</table>
		</div>

		<!-- 페이징 코드 -->
		<div class="text-right">현재 페이지 : <%=currentPage%></div>
		<div class="text-center">
			<a class="btn btn-sm btn-outline-info mr-3" href="<%=request.getContextPath()%>/board/boardList.jsp?currentPage=1">&lt;첫페이지</a>
			<%
				if(currentPage > 1){
			%>
					<a class="btn btn-sm btn-outline-info mr-3" href="<%=request.getContextPath()%>/board/boardList.jsp?currentPage=<%=currentPage-1%>">&lt;이전</a>
			<%		
				}
			
				if(currentPage < lastPage){
			%>
					<a class="btn btn-sm btn-outline-info mr-3" href="<%=request.getContextPath()%>/board/boardList.jsp?currentPage=<%=currentPage+1%>">다음&gt;</a>
			<%		
				}
			%>
			<a class="btn btn-sm btn-outline-info mr-3" href="<%=request.getContextPath()%>/board/boardList.jsp?currentPage=<%=lastPage%>">마지막페이지&gt;</a>
		</div>
	</body>
</html>