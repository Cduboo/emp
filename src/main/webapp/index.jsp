<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
	<head>
		<meta charset="UTF-8">
		<title>index</title>
		<link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@4.1.3/dist/css/bootstrap.min.css" integrity="sha384-MCw98/SFnGE8fJT3GXwEOngsV7Zt27NXFoaoApmYm81iuXoPkFOJwJ8ERdknLPMO" crossorigin="anonymous">
		<script src="https://code.jquery.com/jquery-3.3.1.slim.min.js" integrity="sha384-q8i/X+965DzO0rT7abK41JStQIAqVgRVzpbzo5smXKp4YfRvH+8abtTE1Pi6jizo" crossorigin="anonymous"></script>
		<script src="https://cdn.jsdelivr.net/npm/popper.js@1.14.3/dist/umd/popper.min.js" integrity="sha384-ZMP7rVo3mIykV+2+9J3UJ46jBk0WLaUAdn689aCwoqbBJiSnjAK/l8WvCWPIPm49" crossorigin="anonymous"></script>
		<script src="https://cdn.jsdelivr.net/npm/bootstrap@4.1.3/dist/js/bootstrap.min.js" integrity="sha384-ChfqqxuZUCnJSK3+MXmPNIyE6ZbWh2IMqE241rYiqJxyMiZ6OW/JmZQ5stwEULTy" crossorigin="anonymous"></script>
		<link rel="stylesheet" href="css/style.css">
	</head>
	<body>
		<!-- nav -->
		<nav class="sticky-top pt-3">
			<h1>EMPLOYEES</h1>
			<ul class="nav">
			  <li class="nav-item">
			    <a class="nav-link rounded" href="<%=request.getContextPath()%>/index.jsp">홈</a>
			  </li>
			  <li class="nav-item">
			    <a class="nav-link rounded" href="<%=request.getContextPath()%>/dept/deptList.jsp">부서</a>
			  </li>		  
			  <li class="nav-item">
			    <a class="nav-link rounded" href="#">사원</a>
			  </li>		  
			</ul>
		</nav>
		<!-- 본문 내용 -->
		<h1>미완</h1>
	</body>
</html>