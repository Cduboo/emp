<%@page import="java.security.interfaces.RSAKey"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<%@ page import="vo.*" %>
<%@ page import="java.util.*" %>
<%
	if(request.getParameter("deptNo") == null || request.getParameter("deptNo").equals("")){
		response.sendRedirect(request.getContextPath()+"/dept/deptList.jsp");
		return;
	}
	String deptNo = request.getParameter("deptNo");
	String word = request.getParameter("word");
	//페이징
	int currentPage = 1;
	if(request.getParameter("currentPage") != null){
		currentPage = Integer.parseInt(request.getParameter("currentPage"));
	}
	int rowPerPage = 20; //한 페이지에 보여줄 데이터 수 
	int beginRow = (currentPage - 1) * rowPerPage;
	int dataCount = 0;
	int lastPage = 0;	
	
	//db정보
	String url = "jdbc:mariadb://localhost:3306/employees";
	String user = "root";
	String password = "java1234";
	Class.forName("org.mariadb.jdbc.Driver");
	Connection conn = DriverManager.getConnection(url, user, password);
	
	//해당 부서 정보
	String deptSql = "SELECT dept_no deptNo, dept_name deptName FROM departments WHERE dept_no = ?";
	//해당 부서 매니저
	String deptManagerSql = "SELECT dm.emp_no empNo, e.first_name firstName, e.last_name lastName, dm.from_date fromDate, dm.to_date toDate FROM dept_manager dm INNER JOIN employees e ON dm.emp_no = e.emp_no WHERE dm.dept_no = ? ORDER BY dm.from_date desc";
	
	//해당 부서에서 근무한 사원 목록
	String deptEmpSql = null; 
	String cntSql = null; //해당 부서 근무한 사원 행 개수
	PreparedStatement deptEmpStmt = null; //해당 부서에서 근무한 사원 목록
	PreparedStatement cntStmt = null;
	
	if(word == null){
		cntSql = "SELECT COUNT(*) FROM dept_emp WHERE dept_no = ?";
		cntStmt = conn.prepareStatement(cntSql);
		cntStmt.setString(1, deptNo);
		
		deptEmpSql = "SELECT de.emp_no empNo, de.from_date fromDate, de.to_date toDate, e.first_name firstName, e.last_name lastName FROM dept_emp de INNER JOIN departments d ON de.dept_no = d.dept_no INNER JOIN employees e ON de.emp_no = e.emp_no WHERE de.dept_no = ? LIMIT ?,?";
		deptEmpStmt = conn.prepareStatement(deptEmpSql);
		deptEmpStmt.setString(1, deptNo);
		deptEmpStmt.setInt(2, beginRow);
		deptEmpStmt.setInt(3, rowPerPage);
	}else{
		cntSql = "SELECT COUNT(*) FROM dept_emp de INNER JOIN employees e ON de.emp_no = e.emp_no WHERE dept_no = ? AND e.first_name LIKE ? OR e.last_name LIKE ?";
		cntStmt = conn.prepareStatement(cntSql);
		cntStmt.setString(1, deptNo);
		cntStmt.setString(2, "%"+word+"%");
		cntStmt.setString(3, "%"+word+"%");
		
		deptEmpSql = "SELECT de.emp_no empNo, de.from_date fromDate, de.to_date toDate, e.first_name firstName, e.last_name lastName FROM dept_emp de INNER JOIN departments d ON de.dept_no = d.dept_no INNER JOIN employees e ON de.emp_no = e.emp_no WHERE de.dept_no = ? AND CONCAT(first_name,last_name) LIKE REPLACE(?,' ','') LIMIT ?,?";
		deptEmpStmt = conn.prepareStatement(deptEmpSql);
		deptEmpStmt.setString(1, deptNo);
		deptEmpStmt.setString(2, "%"+word+"%");
		deptEmpStmt.setInt(3, beginRow);
		deptEmpStmt.setInt(4, rowPerPage);
	}
	//전체 행 개수 출력
	ResultSet cntRs = cntStmt.executeQuery();
	if(cntRs.next()){
		dataCount = cntRs.getInt("COUNT(*)");
	}
	lastPage = dataCount / rowPerPage;
	if(dataCount % rowPerPage != 0){
		lastPage = lastPage + 1;
	}
	//해당 부서에서 근무한 사원 목록 출력
	ResultSet deptEmpRs = deptEmpStmt.executeQuery();
	ArrayList<DeptEmp> deptEmpList = new ArrayList<>();
	while(deptEmpRs.next()){
		DeptEmp de = new DeptEmp();
		de.emp = new Employee();
		de.dept = new Department();
		
		de.emp.empNo = deptEmpRs.getInt("empNo");
		de.emp.firstName = deptEmpRs.getString("firstName");
		de.emp.lastName = deptEmpRs.getString("lastName");
		de.fromDate = deptEmpRs.getString("fromDate");
		de.toDate = deptEmpRs.getString("toDate");
		deptEmpList.add(de);
	}

	//해당 부서 정보 출력
	PreparedStatement deptStmt = conn.prepareStatement(deptSql);
	deptStmt.setString(1, deptNo);
	ResultSet deptRs = deptStmt.executeQuery();
	Department d = null;
	if(deptRs.next()){
		d = new Department();
		d.deptNo = deptRs.getString("deptNo");
		d.deptName = deptRs.getString("deptName");
	}
	
	//해당 부서 매니저 출력
	PreparedStatement deptManagerStmt = conn.prepareStatement(deptManagerSql);
	deptManagerStmt.setString(1, deptNo);
	ResultSet deptManagerRs = deptManagerStmt.executeQuery();
	ArrayList<DeptManager> deptManagerList = new ArrayList<>();
	while(deptManagerRs.next()){
		DeptManager dm = new DeptManager();
		dm.emp = new Employee();
		dm.emp.empNo = deptManagerRs.getInt("empNo");
		dm.emp.firstName = deptManagerRs.getString("firstName");
		dm.emp.lastName = deptManagerRs.getString("lastName");
		dm.fromDate = deptManagerRs.getString("fromDate");
		dm.toDate = deptManagerRs.getString("toDate");
		deptManagerList.add(dm);
	}
%>
<!DOCTYPE html>
<html>
	<head>
		<meta charset="UTF-8">
		<title>dept emp list</title>
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
		<div class="p-3"><h3>부서 정보</h3></div>
		<table class="table table-striped table-hover">
			<tr>
				<td class="head" style="width:10%">부서코드</td>
				<td><%=d.deptNo%></td>
			</tr>
			<tr>
				<td class="head">부서명</td>
				<td><%=d.deptName%></td>
			</tr>
		</table>
		<!-- 해당 부서 매니저 -->
		<div class="p-3"><h3>부서 매니저</h3></div>
		<table class="table table-striped table-hover">
			<thead class="sticky-top">
				<tr>
					<th scope="col" style="width:30%">사번</th>
					<th scope="col">이름</th>
					<th scope="col">근무기간</th>
				</tr>
			</thead>
			<tbody>
				<%
					for(DeptManager dm : deptManagerList){
				%>
						<tr>
							<td><%=dm.emp.empNo%></td>
							<td><%=dm.emp.firstName%> <%=dm.emp.lastName%></td>
							<td><%=dm.fromDate%> ~ <%=dm.toDate%></td>
						</tr>
				<%		
					}
				%>
			</tbody>
		</table>
		<!-- 근무한 사원들 --> 
		<div class="p-3"><h3>근무한 사원목록</h3></div>
			<div style="position: relative;">
				<%
					if(word == null){
				%>
						<!-- 사원 검색창 -->
						<form action="<%=request.getContextPath()%>/deptEmp/deptEmpList.jsp?deptNo=<%=deptNo%>" method="post">
							<label for="word">사원명 검색 : </label>
							<input type="text" id="word" name="word">
							<button type="submit">검색</button>
						</form>
				<%		
					}else{
				%>
						<!-- 사원 검색창 -->
						<form action="<%=request.getContextPath()%>/deptEmp/deptEmpList.jsp?deptNo=<%=deptNo%>" method="post">
							<label for="word">사원명 검색 : </label>
							<input type="text" id="word" name="word" value="<%=word%>">
							<button type="submit">검색</button>
						</form>
				<%	
					}
				%>
				<!-- 페이징 코드 -->
				<div class="d-flex" style="position: absolute; top:0px; left:350px">
					<%
						if(word == null){
					%>
							<div class="text-center">
								<a href="<%=request.getContextPath()%>/deptEmp/deptEmpList.jsp?currentPage=1&deptNo=<%=deptNo%>"><button>&lt;&lt;</button></a>
								<%
									if(currentPage > 1){
								%>
										<a href="<%=request.getContextPath()%>/deptEmp/deptEmpList.jsp?currentPage=<%=currentPage-1%>&deptNo=<%=deptNo%>"><button>&lt;</button></a>
								<%		
									}
								
									if(currentPage < lastPage){
								%>
										<a href="<%=request.getContextPath()%>/deptEmp/deptEmpList.jsp?currentPage=<%=currentPage+1%>&deptNo=<%=deptNo%>"><button>&gt;</button></a>
								<%		
									}
								%>
								<a href="<%=request.getContextPath()%>/deptEmp/deptEmpList.jsp?currentPage=<%=lastPage%>&deptNo=<%=deptNo%>"><button>&gt;&gt;</button></a>
							</div>
							<div class="text-right ml-3"><div class="text-right">page : <%=currentPage%> / <%=lastPage%></div></div>
					<%
						}else{
					%>
							<div class="text-center">
								<%
									if(lastPage != 0){
								%>
									<a href="<%=request.getContextPath()%>/deptEmp/deptEmpList.jsp?currentPage=1&deptNo=<%=deptNo%>&word=<%=word%>"><button>&lt;&lt;</button></a>
								<%
									}
								%>
								<%
									if(currentPage > 1){
								%>
										<a href="<%=request.getContextPath()%>/deptEmp/deptEmpList.jsp?currentPage=<%=currentPage-1%>&deptNo=<%=deptNo%>&word=<%=word%>"><button>&lt;</button></a>
								<%		
									}
								
									if(currentPage < lastPage){
								%>
										<a href="<%=request.getContextPath()%>/deptEmp/deptEmpList.jsp?currentPage=<%=currentPage+1%>&deptNo=<%=deptNo%>&word=<%=word%>"><button>&gt;</button></a>
								<%		
									}
								%>
								<%
									if(lastPage != 0){
								%>
										<a href="<%=request.getContextPath()%>/deptEmp/deptEmpList.jsp?currentPage=<%=lastPage%>&deptNo=<%=deptNo%>&word=<%=word%>"><button>&gt;&gt;</button></a>
								<%		
									}
								%>
							</div>
							<div class="text-right ml-3"><div class="text-right">page : <%=currentPage%> / <%=lastPage%></div></div>
					<%		
						}
					%>
				</div>
			</div>
		
		<table class="table table-striped table-hover">
			<thead class="sticky-top">
				<tr>
					<th scope="col" style="width:30%">사번</th>
					<th scope="col">사원명</th>
					<th scope="col">근무기간</th>
				</tr>
			</thead>
			<tbody>
				<%
					for(DeptEmp e : deptEmpList){
				%>
						<tr>
							<td><%=e.emp.empNo%></td>
							<td><%=e.emp.firstName%> <%=e.emp.lastName%></td>
							<td><%=e.fromDate%> ~ <%=e.toDate%></td>
						</tr>
				<%		
					}
				%>
			</tbody>
		</table>
	</body>
</html>