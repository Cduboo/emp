<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<%
	String result =  request.getParameter("result");
	System.out.println(result);
	//인코딩
	request.setCharacterEncoding("utf-8");
	response.setContentType("text/html; charset=utf-8");
	response.setCharacterEncoding("utf-8");
	
	//1) 요청 분석(Controller)
	String deptNo = request.getParameter("deptNo");

	//db정보
	String url = "jdbc:mariadb://localhost:3306/employees";
	String user = "root";
	String password = "java1234";
	String sql = "DELETE FROM departments WHERE dept_no=?";
	
	// mariadb 드라이버 로딩
	Class.forName("org.mariadb.jdbc.Driver");
	
	// 연결
	Connection conn = DriverManager.getConnection(url, user, password);
	
	// 쿼리 실행
	PreparedStatement stmt = conn.prepareStatement(sql);
	stmt.setString(1, deptNo);
	int row = stmt.executeUpdate();
	
	response.sendRedirect(request.getContextPath()+"/dept/deptList.jsp");
	
	stmt.close();
	conn.close();
%>
