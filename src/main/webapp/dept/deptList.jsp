<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<%@ page import="java.util.*" %>
<%@ page import="vo.*" %>
<%
	// 인코딩
	request.setCharacterEncoding("utf-8");
	response.setContentType("text/html; charset=utf-8");
	response.setCharacterEncoding("utf-8");
	// 1) 요청 분석(Controller)
	String word = request.getParameter("word");
	// 요청 분기 : word -> null, "", "word"
	// 2) 업무(Model) 처리 -> 모델데이터(단일값 or 자료구조형태(배열, 리스트, ...))
	//db정보
	String url = "jdbc:mariadb://localhost:3306/employees";
	String user = "root";
	String password = "java1234";
	Class.forName("org.mariadb.jdbc.Driver");
	Connection conn = DriverManager.getConnection(url, user, password);
	
	String sql = null;
	PreparedStatement stmt = null;
	if(word == null){
		sql = "SELECT dept_no deptNo, dept_name deptName FROM departments ORDER BY dept_no desc";
		stmt = conn.prepareStatement(sql);
	}else{
		sql = "SELECT dept_no deptNo, dept_name deptName FROM departments WHERE dept_name LIKE ? ORDER BY dept_no desc";
		stmt = conn.prepareStatement(sql);
		stmt.setString(1, "%"+word+"%");
	}
	
	ResultSet rs = stmt.executeQuery(); // <- 모델데이터 ResultSet은 일반적인 타입이 아니다.
	// 따라서, ResultSet rs라는 모델자료구조를 좀더 일반적이고 독립적인 자료구조로로 변경하자.
	ArrayList<Department> list = new ArrayList<>();
	while(rs.next()){
		Department d = new Department();
		d.deptNo = rs.getString("deptNo");
		d.deptName = rs.getString("deptName");
		list.add(d);
	}
	
	rs.close();
	stmt.close();
	conn.close();
%>
<!DOCTYPE html>
<html>
	<head>
		<meta charset="UTF-8">
		<title>dept list</title>
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
			<h1 class="pb-1 pt-1">DEPT LIST</h1>	
		</div>	
		<div>
			<!-- 부서 목록 추가 (부서번호 내림차순) -->
			<h2 class="pb-1 pt-1">부서 목록</h2>
			<a class="btn btn-info float-right mr-3 mb-3" href="<%=request.getContextPath()%>/dept/insertDeptForm.jsp">부서추가</a>
			<%
				if(word == null){
			%>
					<!-- 부서명 검색창 -->
					<form action="<%=request.getContextPath()%>/dept/deptList.jsp" method="post">
						<label for="word">부서명 검색 : </label>
						<input type="text" id="word" name="word">
						<button type="submit">검색</button>
					</form>
			<%		
				}else{
			%>
					<!-- 부서명 검색창 -->
					<form action="<%=request.getContextPath()%>/dept/deptList.jsp" method="post">
						<label for="word">부서명 검색 : </label>
						<input type="text" id="word" name="word" value="<%=word%>">
						<button type="submit">검색</button>
					</form>
			<%		
				}
			%>

			<!-- 부서 리스트 -->
			<table class="table table-striped table-hover">
				<thead class="sticky-top">
					<tr>
						<th scope="col">부서 코드</th>
						<th scope="col">부서명</th>
						<th scope="col">수정</th>
						<th scope="col">삭제</th>
					</tr>
				</thead>
				<tbody>
					<%
						for(Department d : list){
					%>
							<tr>
								<td><%=d.deptNo%></td>
								<td><a href="<%=request.getContextPath()%>/deptEmp/deptEmpList.jsp?deptNo=<%=d.deptNo%>"><%=d.deptName%></a></td>
								<td><a class="btn btn-sm btn-outline-info" href="<%=request.getContextPath()%>/dept/updateDeptForm.jsp?deptNo=<%=d.deptNo%>">수정</a></td>
								<td><a class="btn btn-sm btn-outline-danger" href="<%=request.getContextPath()%>/dept/deleteDept.jsp?deptNo=<%=d.deptNo%>">삭제</a></td>
							</tr>
					<%							
						}
					%>
				</tbody>
			</table>
		</div>
	</body>
</html>