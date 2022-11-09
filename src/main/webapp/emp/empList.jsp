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
	
	//db정보
	String url = "jdbc:mariadb://localhost:3306/employees";
	String user = "root";
	String password = "java1234";
	String CountSql = "SELECT COUNT(*) FROM employees";
	String empSql = "SELECT emp_no empNo, first_name firstName, last_name lastName FROM employees ORDER BY emp_no ASC LIMIT ?,?";
	
	// mariadb 드라이버 로딩
	Class.forName("org.mariadb.jdbc.Driver");
	System.out.println("드라이버 로딩 성공");
	
	// 연결
	Connection conn = DriverManager.getConnection(url, user, password);
	System.out.println(conn + " <--- 연결 성공");
	
	// 쿼리 실행
	PreparedStatement countStmt = conn.prepareStatement(CountSql);
	ResultSet countRs = countStmt.executeQuery();
	if(countRs.next()){
		dataCount = countRs.getInt("COUNT(*)");
	}
	// 마지막 페이지 구하기
	lastPage = dataCount / rowPerPage;
	if(dataCount % rowPerPage != 0){
		lastPage = lastPage + 1;
	}
	
	// 한페이지당 출력할 emp 목록
	PreparedStatement empStmt = conn.prepareStatement(empSql);
	empStmt.setInt(1, rowPerPage * (currentPage - 1));
	empStmt.setInt(2, rowPerPage);
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
		<nav>
			<jsp:include page="/inc/menu.jsp"></jsp:include>
		</nav>
				<!-- 본문 -->
		<div>
			<h1 class="pb-1 pt-1">EMP LIST</h1>	
		</div>	
		<div class="font-weight-bold">
			<!-- 부서 목록 추가 (부서번호 내림차순) -->
			<h2 class="pb-1 pt-1">🧑‍ 사원 목록</h2>
			<a class="btn btn-info float-right mr-3 mb-3" href="<%=request.getContextPath()%>/emp/insertEmpForm.jsp">사원추가</a>
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

		
		
		<div class="text-right">현재 페이지 : <%=currentPage%></div>
		<!-- 페이징 코드 -->
		<div class="text-center">
			<a class="btn btn-sm btn-outline-info mr-3" href="<%=request.getContextPath()%>/emp/empList.jsp?currentPage=1">&lt;첫페이지</a>
			<%
				if(currentPage > 1){
			%>
					<a class="btn btn-sm btn-outline-info mr-3" href="<%=request.getContextPath()%>/emp/empList.jsp?currentPage=<%=currentPage-1%>">&lt;이전</a>
			<%		
				}
			
				if(currentPage < lastPage){
			%>
					<a class="btn btn-sm btn-outline-info mr-3" href="<%=request.getContextPath()%>/emp/empList.jsp?currentPage=<%=currentPage+1%>">다음&gt;</a>
			<%		
				}
			%>
			<a class="btn btn-sm btn-outline-info mr-3" href="<%=request.getContextPath()%>/emp/empList.jsp?currentPage=<%=lastPage%>">마지막페이지&gt;</a>
		</div>
	</body>
</html>