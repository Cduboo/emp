<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<%@ page import="vo.*" %>
<%@ page import="java.util.*" %>
<%
	//페이지 알고리즘
	int currentPage = 1;
	int lastPage = 0;
	int dataCount = 0;
	int rowPerPage = 20; //한 페이지에 보여줄 데이터 수 
	if(request.getParameter("currentPage") != null){
		currentPage = Integer.parseInt(request.getParameter("currentPage"));
	}
	String word = request.getParameter("word");
	
	//db정보
	String url = "jdbc:mariadb://localhost:3306/employees";
	String user = "root";
	String password = "java1234";
	Class.forName("org.mariadb.jdbc.Driver");
	Connection conn = DriverManager.getConnection(url, user, password);
	String CountSql = null;
	String empSql = null;
	PreparedStatement countStmt = null;
	PreparedStatement empStmt = null;
	
	if(word == null){
		CountSql = "SELECT COUNT(*) FROM employees";
		countStmt = conn.prepareStatement(CountSql);
		
		empSql = "SELECT emp_no empNo, first_name firstName, last_name lastName FROM employees ORDER BY emp_no ASC LIMIT ?,?";
		empStmt = conn.prepareStatement(empSql);
		empStmt.setInt(1, rowPerPage * (currentPage - 1));
		empStmt.setInt(2, rowPerPage);
	}else{
		CountSql = "SELECT COUNT(*) FROM employees WHERE first_name LIKE ? OR last_name LIKE ?";
		countStmt = conn.prepareStatement(CountSql);
		countStmt.setString(1, "%"+word+"%");
		countStmt.setString(2, "%"+word+"%");
		
		empSql = "SELECT emp_no empNo, first_name firstName, last_name lastName FROM employees WHERE CONCAT(first_name,last_name) LIKE REPLACE(?,' ','') ORDER BY emp_no ASC LIMIT ?,?";
		empStmt = conn.prepareStatement(empSql);
		empStmt.setString(1, "%"+word+"%");
		empStmt.setInt(2, rowPerPage * (currentPage - 1));
		empStmt.setInt(3, rowPerPage);
	}

	ResultSet countRs = countStmt.executeQuery();
	if(countRs.next()){
		dataCount = countRs.getInt("COUNT(*)");
	}
	// 마지막 페이지 구하기
	lastPage = dataCount / rowPerPage;
	if(dataCount % rowPerPage != 0){
		lastPage = lastPage + 1;
	}

	ResultSet empRs = empStmt.executeQuery();
	ArrayList<Employee> empList = new ArrayList<>();
	while(empRs.next()){
		Employee e = new Employee();
		e.empNo = empRs.getInt("empNo");
		e.firstName = empRs.getString("firstName");
		e.lastName = empRs.getString("lastName");
		empList.add(e);
	}
%>
<!DOCTYPE html>
<html>
	<head>
		<meta charset="UTF-8">
		<title>emp list</title>
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
			<h1 class="pb-1 pt-1">EMP LIST</h1>	
		</div>	
		<div class="font-weight-bold">
			<!-- 부서 목록 추가 (부서번호 내림차순) -->
			<h2 class="pb-1 pt-1">사원 목록</h2>
			<a class="btn btn-info float-right mr-3 mb-3" href="<%=request.getContextPath()%>/emp/insertEmpForm.jsp">사원추가</a>
			<div style="position: relative;">
				<%
					if(word == null){
				%>
						<!-- 사원 검색창 -->
						<form action="<%=request.getContextPath()%>/emp/empList.jsp" method="post">
							<label for="word">사원명 검색 : </label>
							<input type="text" id="word" name="word">
							<button type="submit">검색</button>
						</form>
				<%		
					}else{
				%>
						<!-- 사원 검색창 -->
						<form action="<%=request.getContextPath()%>/emp/empList.jsp" method="post">
							<label for="word">사원명 검색 : </label>
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
								<a href="<%=request.getContextPath()%>/emp/empList.jsp?currentPage=1"><button>&lt;&lt;</button></a>
								<%
									if(currentPage > 1){
								%>
										<a href="<%=request.getContextPath()%>/emp/empList.jsp?currentPage=<%=currentPage-1%>"><button>&lt;</button></a>
								<%		
									}
								
									if(currentPage < lastPage){
								%>
										<a href="<%=request.getContextPath()%>/emp/empList.jsp?currentPage=<%=currentPage+1%>"><button>&gt;</button></a>
								<%		
									}
								%>
								<a href="<%=request.getContextPath()%>/emp/empList.jsp?currentPage=<%=lastPage%>"><button>&gt;&gt;</button></a>
							</div>
							<div class="text-right ml-3"><div class="text-right">page : <%=currentPage%> / <%=lastPage%></div></div>
					<%
						}else{
					%>
							<div class="text-center">
								<a href="<%=request.getContextPath()%>/emp/empList.jsp?currentPage=1&word=<%=word%>"><button>&lt;&lt;</button></a>
								<%
									if(currentPage > 1){
								%>
										<a href="<%=request.getContextPath()%>/emp/empList.jsp?currentPage=<%=currentPage-1%>&word=<%=word%>"><button>&lt;</button></a>
								<%		
									}
								
									if(currentPage < lastPage){
								%>
										<a href="<%=request.getContextPath()%>/emp/empList.jsp?currentPage=<%=currentPage+1%>&word=<%=word%>"><button>&gt;</button></a>
								<%		
									}
								%>
								<a href="<%=request.getContextPath()%>/emp/empList.jsp?currentPage=<%=lastPage%>&word=<%=word%>"><button>&gt;&gt;</button></a>
							</div>
							<div class="text-right ml-3"><div class="text-right">page : <%=currentPage%> / <%=lastPage%></div></div>
					<%		
						}
					%>
				</div>
			</div>

			<table class="table table-striped table-hover">
				<thead class="sticky-top">
					<th scope="col">사원 코드</th>
					<th scope="col">퍼스트네임</th>
					<th scope="col">라스트네임</th>
					<th scope="col">수정</th>
					<th scope="col">삭제</th>
				</thead>
				<tbody>
					<%
						for(Employee e : empList){
					%>
							<tr>
								<td><%=e.empNo%></td>
								<td><%=e.firstName%></td>
								<td><%=e.lastName%></td>
								<td><a class="btn btn-sm btn-outline-info" href="<%=request.getContextPath()%>/dept/updateEmpForm.jsp?deptNo=<%=e.empNo%>">수정</a></td>
								<td><a class="btn btn-sm btn-outline-danger" href="<%=request.getContextPath()%>/dept/deleteEmp.jsp?deptNo=<%=e.empNo%>">삭제</a></td>
							</tr>
					<%							
						}
					%>
				</tbody>
			</table>
		</div>
	</body>
</html>