<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<nav class="pt-3">
	<h1>EMPLOYEES</h1>
	<ul class="nav">
	  <li class="nav-item">
	    <a class="nav-link rounded" href="<%=request.getContextPath()%>/index.jsp">홈</a>
	  </li>
	  <li class="nav-item">
	    <a class="nav-link rounded" href="<%=request.getContextPath()%>/dept/deptList.jsp">부서</a>
	  </li>		  
	  <li class="nav-item">
	    <a class="nav-link rounded" href="<%=request.getContextPath()%>/emp/empList.jsp">사원</a>
	  </li>
	 <li class="nav-item">
	    <a class="nav-link rounded" href="<%=request.getContextPath()%>/board/boardList.jsp">게시판관리</a>
	  </li>
	</ul>
</nav>