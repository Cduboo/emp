<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<%@ page import="vo.*" %>
<%@ page import="java.util.*" %>
<%@ page import="java.text.*" %>
<%
	if(request.getParameter("empNo") == null ){
		response.sendRedirect(request.getContextPath()+"/emp/empList.jsp");
		return;
	}
	int empNo = Integer.parseInt(request.getParameter("empNo"));
	
	//페이징
	int currentPage = 1;
	if(request.getParameter("currentPage") != null){
		currentPage = Integer.parseInt(request.getParameter("currentPage"));
	}
	int rowPerPage = 5; //한 페이지에 보여줄 데이터 수 
	int beginRow = (currentPage - 1) * rowPerPage;
	int dataCount = 0;
	int lastPage = 0;
		
	//db정보
	String url = "jdbc:mariadb://localhost:3306/employees";
	String user = "root";
	String password = "java1234";
	Class.forName("org.mariadb.jdbc.Driver");
	Connection conn = DriverManager.getConnection(url, user, password);
	
	//전체 행 개수
	String cntSql = "SELECT COUNT(*) FROM salaries WHERE emp_no = ?";
	//해당 사원 연봉 이력
	String salarySql = "SELECT s.emp_no empNo, first_name firstName, last_name lastName, salary, from_date fromDate, to_date toDate FROM salaries s INNER JOIN employees e ON s.emp_no = e.emp_no WHERE s.emp_no = ? ORDER BY s.from_date desc LIMIT ?,?";
	//해당 사원 근무한 부서
	String deptEmpSql = "SELECT d.dept_no deptNo, d.dept_name deptName, de.from_date fromDate, de.to_date toDate FROM dept_emp de INNER JOIN employees e ON de.emp_no = e.emp_no JOIN departments d ON de.dept_no = d.dept_no WHERE e.emp_no = ?";
	//해당 사원 정보 
	String empSql = "SELECT emp_no empNo, birth_date birthDate, first_name firstName, last_name lastName, gender, hire_date hireDate FROM employees WHERE emp_no = ?";
	//직급 이력
	String titleSql = "SELECT emp_no empNo, title, from_date fromDate, to_date toDate FROM titles WHERE emp_no = ?";
	
	//전체 행 개수 출력
	PreparedStatement cntStmt = conn.prepareStatement(cntSql);
	cntStmt.setInt(1, empNo);
	ResultSet cntRs = cntStmt.executeQuery();
	if(cntRs.next()){
		dataCount = cntRs.getInt("COUNT(*)");
	}
	lastPage = dataCount / rowPerPage;
	if(dataCount % rowPerPage != 0){
		lastPage = lastPage + 1;
	}
	// 해당 사원 연봉 이력 출력
	PreparedStatement stmt = conn.prepareStatement(salarySql);
	stmt.setInt(1, empNo);
	stmt.setInt(2, (currentPage - 1) * rowPerPage);
	stmt.setInt(3, rowPerPage);
	ResultSet rs = stmt.executeQuery();
	ArrayList<Salary> salaryList = new ArrayList<>();
	while(rs.next()){
		Salary s = new Salary();
		s.emp = new Employee();
		s.emp.empNo = rs.getInt("empNo");
		s.salary = rs.getInt("salary");
		s.fromDate = rs.getString("fromDate");
		s.toDate = rs.getString("toDate");
		s.emp.firstName = rs.getString("firstName");
		s.emp.lastName = rs.getString("lastName");
		salaryList.add(s);
	}
	
	//직급 이력 출력
	PreparedStatement titleStmt = conn.prepareStatement(titleSql);
	titleStmt.setInt(1, empNo);
	ResultSet titleRs = titleStmt.executeQuery();
	ArrayList<Title> titleList = new ArrayList<>();
	while(titleRs.next()){
		Title t = new Title();
		t.empNo = titleRs.getInt("empNo");
		t.title = titleRs.getString("title");
		t.fromDate = titleRs.getString("fromDate");
		t.toDate = titleRs.getString("toDate");
		titleList.add(t);
	}
	
	//해당 사원 정보 출력
	PreparedStatement empStmt = conn.prepareStatement(empSql);
	empStmt.setInt(1, empNo);
	ResultSet empRs = empStmt.executeQuery();

	Employee e = null;
	if(empRs.next()){
		e = new Employee();
		e.empNo = empRs.getInt("empNo");
		e.birthDate = empRs.getString("birthDate");
		e.firstName = empRs.getString("firstName");
		e.lastName = empRs.getString("lastName");
		e.gender = empRs.getString("gender");
		e.hireDate = empRs.getString("hireDate");
	}
	
	//해당 사원 근무한 부서 출력
	PreparedStatement deptEmpStmt = conn.prepareStatement(deptEmpSql);
	deptEmpStmt.setInt(1, empNo);
	ResultSet deptEmpRs = deptEmpStmt.executeQuery();
	ArrayList<HashMap<String,Object>> deptEmpList = new ArrayList<>();
	while(deptEmpRs.next()){
		HashMap<String,Object> deptEmpMap = new HashMap<>();
		deptEmpMap.put("deptNo", deptEmpRs.getString("deptNo"));
		deptEmpMap.put("deptName", deptEmpRs.getString("deptName"));
		deptEmpMap.put("fromDate", deptEmpRs.getString("fromDate"));
		deptEmpMap.put("toDate", deptEmpRs.getString("toDate"));
		deptEmpList.add(deptEmpMap);
	}
	
	cntRs.close();
	rs.close();
	titleRs.close();
	empRs.close();
	deptEmpRs.close();
	cntStmt.close();
	stmt.close();
	titleStmt.close();
	empStmt.close();
	deptEmpStmt.close();
	conn.close();
%>
<!DOCTYPE html>
<html>
	<head>
		<meta charset="UTF-8">
		<title>salary list</title>
		<link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@4.1.3/dist/css/bootstrap.min.css" integrity="sha384-MCw98/SFnGE8fJT3GXwEOngsV7Zt27NXFoaoApmYm81iuXoPkFOJwJ8ERdknLPMO" crossorigin="anonymous">
		<script src="https://code.jquery.com/jquery-3.3.1.slim.min.js" integrity="sha384-q8i/X+965DzO0rT7abK41JStQIAqVgRVzpbzo5smXKp4YfRvH+8abtTE1Pi6jizo" crossorigin="anonymous"></script>
		<script src="https://cdn.jsdelivr.net/npm/popper.js@1.14.3/dist/umd/popper.min.js" integrity="sha384-ZMP7rVo3mIykV+2+9J3UJ46jBk0WLaUAdn689aCwoqbBJiSnjAK/l8WvCWPIPm49" crossorigin="anonymous"></script>
		<script src="https://cdn.jsdelivr.net/npm/bootstrap@4.1.3/dist/js/bootstrap.min.js" integrity="sha384-ChfqqxuZUCnJSK3+MXmPNIyE6ZbWh2IMqE241rYiqJxyMiZ6OW/JmZQ5stwEULTy" crossorigin="anonymous"></script>
		<link rel="stylesheet" href="../css/style.css">
	</head>
	<body>
		<!-- nav -->
		<jsp:include page="/inc/menu.jsp"></jsp:include>
		<!-- 사원 정보 -->
		<div class="p-3"><h3>사원 정보</h3></div>
		<table class="table table-striped table-hover">
			<tr>
				<td class="head" style="width:10%">사번</td>
				<td><%=e.empNo%></td>
			</tr>
			<tr>
				<td class="head">생년월일</td>
				<td><%=e.birthDate%></td>
			</tr>
			<tr>
				<td class="head">이름</td>
				<td><%=e.firstName%> <%=e.lastName%></td>
			</tr>
			<tr>
				<td class="head">성별</td>
				<td><%=e.gender%></td>
			</tr>
			<tr>
				<td class="head">고용일</td>
				<td><%=e.hireDate%></td>
			</tr>
		</table>
		<!-- 직급 아력 -->
		<div class="p-3"><h3>직급 이력</h3></div>
		<table class="table table-striped table-hover">
			<thead class="sticky-top">
				<tr>
					<th scope="col" style="width:30%">직급</th>
					<th scope="col">근무기간</th>
				</tr>
			</thead>
			<tbody>
				<%
					for(Title t : titleList){
				%>
						<tr>
							<td><%=t.title%></td>
							<td><%=t.fromDate%> ~ <%=t.toDate%></td>
						</tr>
				<%		
					}
				%>
			</tbody>
		</table>
		<!-- 근무한 부서 -> 부서번호 누르면 부서정보페이지로 이동(그 부서에 근무했던 사원정보, 해당 부서 역대 매니저 리스트)-->
		<div class="p-3"><h3>근무 부서</h3></div>
		<table class="table table-striped table-hover">
			<thead class="sticky-top">
				<tr>
					<th scope="col" style="width:30%">부서코드</th>
					<th scope="col">부서명</th>
					<th scope="col">근무기간</th>
				</tr>
			</thead>
			<tbody>
				<%
					for(HashMap<String,Object> m : deptEmpList){
				%>
						<tr>
							<td><%=m.get("deptNo")%></td>
							<td><a href="<%=request.getContextPath()%>/deptEmp/deptEmpList.jsp?deptNo=<%=m.get("deptNo")%>"><%=m.get("deptName")%></a></td>
							<td><%=m.get("fromDate")%> ~ <%=m.get("toDate")%></td>
						</tr>
				<%		
					}
				%>
			</tbody>
		</table>
		<!-- 연봉 이력 -->
		<div style="position: relative;">
			<div class="p-3"><h3>연봉 이력</h3></div>
			<!-- 페이징 코드 -->
			<div class="d-flex" style="position: absolute; top:20px; left:150px">
				<div class="text-center">
					<a href="<%=request.getContextPath()%>/salary/salaryList.jsp?currentPage=1&empNo=<%=empNo%>"><button>&lt;&lt;</button></a>
					<%
						if(currentPage > 1){
					%>
							<a href="<%=request.getContextPath()%>/salary/salaryList.jsp?currentPage=<%=currentPage-1%>&empNo=<%=empNo%>"><button>&lt;</button></a>
					<%		
						}
					
						if(currentPage < lastPage){
					%>
							<a href="<%=request.getContextPath()%>/salary/salaryList.jsp?currentPage=<%=currentPage+1%>&empNo=<%=empNo%>"><button>&gt;</button></a>
					<%		
						}
					%>
					<a href="<%=request.getContextPath()%>/salary/salaryList.jsp?currentPage=<%=lastPage%>&empNo=<%=empNo%>"><button>&gt;&gt;</button></a>
				</div>
				<div class="text-right ml-3"><div class="text-right">page : <%=currentPage%> / <%=lastPage%></div></div>
			</div>
		</div>
		<table class="table table-striped table-hover">
			<thead class="sticky-top">
				<tr>
					<th scope="col" style="width:30%">연봉</th>
					<th scope="col">근무기간</th>
				</tr>
			</thead>
			<tbody>
				<%
					DecimalFormat df = new DecimalFormat("###,###");
					for(Salary s : salaryList){
				%>
						<tr>
							<td>$<%=df.format(s.salary)%></td>
							<td><%=s.fromDate%> ~ <%=s.toDate%></td>
						</tr>
				<%		
					}
				%>
			</tbody>
		</table>
	</body>
</html>