<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<%@ page import="vo.*" %>
<%
	//인코딩
	request.setCharacterEncoding("utf-8");
	response.setContentType("text/html; charset=utf-8");
	response.setCharacterEncoding("utf-8");
	
	//1) 요청 분석(Controller)
	Department d = new Department();
	String deptNo = request.getParameter("deptNo");
	// 주소창 직접 접근 시 null값 검사
	if(deptNo == null){
		response.sendRedirect(request.getContextPath()+"/dept/deptList.jsp");
		return;
	}
	
	//db정보
	String url = "jdbc:mariadb://localhost:3306/employees";
	String user = "root";
	String password = "java1234";
	String sql = "SELECT dept_no deptNo, dept_name deptName FROM departments WHERE dept_no = ?";
	
	// mariadb 드라이버 로딩
	Class.forName("org.mariadb.jdbc.Driver");
	System.out.println("드라이버 로딩 성공");
	
	// 연결
	Connection conn = DriverManager.getConnection(url, user, password);
	System.out.println(conn + " <--- 연결 성공");
	
	// 쿼리 실행
	PreparedStatement stmt = conn.prepareStatement(sql);
	stmt.setString(1, deptNo);
	ResultSet rs = stmt.executeQuery();
	if(rs.next()){
		d.deptNo = rs.getString("deptNo");
		d.deptName = rs.getString("deptName");
	}
%>
<!DOCTYPE html>
<html>
	<head>
		<meta charset="UTF-8">
		<title>update dept</title>
		<link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@4.1.3/dist/css/bootstrap.min.css" integrity="sha384-MCw98/SFnGE8fJT3GXwEOngsV7Zt27NXFoaoApmYm81iuXoPkFOJwJ8ERdknLPMO" crossorigin="anonymous">
		<script src="https://code.jquery.com/jquery-3.3.1.slim.min.js" integrity="sha384-q8i/X+965DzO0rT7abK41JStQIAqVgRVzpbzo5smXKp4YfRvH+8abtTE1Pi6jizo" crossorigin="anonymous"></script>
		<script src="https://cdn.jsdelivr.net/npm/popper.js@1.14.3/dist/umd/popper.min.js" integrity="sha384-ZMP7rVo3mIykV+2+9J3UJ46jBk0WLaUAdn689aCwoqbBJiSnjAK/l8WvCWPIPm49" crossorigin="anonymous"></script>
		<script src="https://cdn.jsdelivr.net/npm/bootstrap@4.1.3/dist/js/bootstrap.min.js" integrity="sha384-ChfqqxuZUCnJSK3+MXmPNIyE6ZbWh2IMqE241rYiqJxyMiZ6OW/JmZQ5stwEULTy" crossorigin="anonymous"></script>
	</head>
	<body class="bg-secondary">
		<div class="container rounded bg-white p-5 mt-5 w-50">
			<form action="<%=request.getContextPath()%>/dept/updateDeptAction.jsp" method="post">
				<div class="fw-bold text-left font-weight-bold"><h3>수정하기</h3></div>
				<div class="mb-3 mt-3">
					<label for="deptNo" class="form-label">DEPT NO</label>
					<input class="form-control" id="deptNo" type="text" value="<%=d.deptNo%>" name="deptNo" readonly/>
				</div>
	
				<div class="mb-5">
					<label for="deptName" class="form-label">DEPT NAME</label>
					<input class="form-control" id="deptName" type="text" value="<%=d.deptName%>" name="deptName"/>
				</div>
					<button type="submit" class="btn btn-lg btn-block btn-outline-primary m-auto">수정</button>
			</form>
		</div>
	</body>
</html>