<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%
	//인코딩
	request.setCharacterEncoding("utf-8");
	response.setContentType("text/html; charset=utf-8");
	response.setCharacterEncoding("utf-8");
%>
<!DOCTYPE html>
<html>
	<head>
		<meta charset="UTF-8">
		<title>insert dept</title>
		<link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@4.1.3/dist/css/bootstrap.min.css" integrity="sha384-MCw98/SFnGE8fJT3GXwEOngsV7Zt27NXFoaoApmYm81iuXoPkFOJwJ8ERdknLPMO" crossorigin="anonymous">
		<script src="https://code.jquery.com/jquery-3.3.1.slim.min.js" integrity="sha384-q8i/X+965DzO0rT7abK41JStQIAqVgRVzpbzo5smXKp4YfRvH+8abtTE1Pi6jizo" crossorigin="anonymous"></script>
		<script src="https://cdn.jsdelivr.net/npm/popper.js@1.14.3/dist/umd/popper.min.js" integrity="sha384-ZMP7rVo3mIykV+2+9J3UJ46jBk0WLaUAdn689aCwoqbBJiSnjAK/l8WvCWPIPm49" crossorigin="anonymous"></script>
		<script src="https://cdn.jsdelivr.net/npm/bootstrap@4.1.3/dist/js/bootstrap.min.js" integrity="sha384-ChfqqxuZUCnJSK3+MXmPNIyE6ZbWh2IMqE241rYiqJxyMiZ6OW/JmZQ5stwEULTy" crossorigin="anonymous"></script>
	</head>
	<body class="bg-secondary">
		<div class="container rounded bg-white p-5 mt-5 w-50">
			<form action="<%=request.getContextPath()%>/dept/insertDeptAction.jsp" method="post">
				<div class="fw-bold text-left font-weight-bold"><h3>추가하기</h3></div>
				<%
					if(request.getParameter("msg1") != null || request.getParameter("msg2") != null){
						if(request.getParameter("msg1") != null){
				%>
						<div class="text-danger"><%=request.getParameter("msg1")%></div>
						<div class="mb-3 mt-3">
							<label for="deptNo" class="form-label">DEPT NO</label>
							<input class="form-control is-invalid" type="text" id="deptNo" name="deptNo" placeholder="d000" required/>
						</div>
						<div class="mb-5">
							<label for="deptName" class="form-label">DEPT NAME</label>
							<input class="form-control" id="deptName"type="text" name="deptName" value="<%=request.getParameter("deptName") %>" required/>
						</div>
				<%			
						}else if(request.getParameter("msg2") != null){
				%>
							<div class="text-danger"><%=request.getParameter("msg2")%></div>
							<div class="mb-3 mt-3">
								<label for="deptNo" class="form-label">DEPT NO</label>
								<input class="form-control" type="text" id="deptNo" name="deptNo" placeholder="d000" value="<%=request.getParameter("deptNo")%>" required/>
							</div>
							<div class="mb-5">
								<label for="deptName" class="form-label">DEPT NAME</label>
								<input class="form-control is-invalid" id="deptName"type="text" name="deptName" required/>
							</div>
				<%			
						}
				%>
				<%		
					}else{
				%>
						<div class="mb-3 mt-3">
							<label for="deptNo" class="form-label">DEPT NO</label>
							<input class="form-control" type="text" id="deptNo" name="deptNo" placeholder="d000" required/>
						</div>
						<div class="mb-5">
							<label for="deptName" class="form-label">DEPT NAME</label>
							<input class="form-control" id="deptName"type="text" name="deptName" required/>
						</div>
				<%		
					}
				%>
				<button type="submit" class="btn btn-lg btn-block btn-outline-primary m-auto">추가</button>
			</form>
		</div>
	</body>
</html>